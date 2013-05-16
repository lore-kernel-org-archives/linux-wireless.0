Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11708 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3EPRMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 13:12:37 -0400
Date: Thu, 16 May 2013 20:11:08 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Allow TDLS peer AID to be configured for VHT
Message-ID: <20130516171108.GA27497@jouni.qca.qualcomm.com> (sfid-20130516_191240_413646_192CAF9C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VHT uses peer AID in the PARTIAL_AID field in TDLS frames. The current
design for TDLS is to first add a dummy STA entry before completing TDLS
Setup and then update information on this STA entry based on what was
received from the peer during the setup exchange.

In theory, this could use NL80211_ATTR_STA_AID to set the peer AID just
like this is used in AP mode to set the AID of an association station.
However, existing cfg80211 validation rules prevent this attribute from
being used with set_station operation. To avoid interoperability issues
between different kernel and user space version combinations, introduce
a new nl80211 attribute for the purpose of setting TDLS peer AID. This
attribute can be used in both the new_station and set_station
operations. It is not supposed to be allowed to change the AID value
during the lifetime of the STA entry, but that validation is left for
drivers to do in the change_station callback.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/uapi/linux/nl80211.h |    7 +++++++
 net/wireless/nl80211.c       |   11 +++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d1e48b5..a061437 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1429,6 +1429,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_MAX_CRIT_PROT_DURATION: duration in milliseconds in which
  *      the connection should have increased reliability (u16).
  *
+ * @NL80211_ATTR_PEER_AID: Association ID for the peer TDLS station (u16).
+ *	This is similar to @NL80211_ATTR_STA_AID but with a difference of being
+ *	allowed to be used with the first @NL80211_CMD_SET_STATION command to
+ *	update a TDLS peer STA entry.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1727,6 +1732,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_CRIT_PROT_ID,
 	NL80211_ATTR_MAX_CRIT_PROT_DURATION,
 
+	NL80211_ATTR_PEER_AID,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index afa2838..1525040 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -378,6 +378,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MDID] = { .type = NLA_U16 },
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_PEER_AID] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -3834,6 +3835,8 @@ static int nl80211_set_station_tdls(struct genl_info *info,
 				    struct station_parameters *params)
 {
 	/* Dummy STA entry gets updated once the peer capabilities are known */
+	if (info->attrs[NL80211_ATTR_PEER_AID])
+		params->aid = nla_get_u16(info->attrs[NL80211_ATTR_PEER_AID]);
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
 		params->ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
@@ -3974,7 +3977,8 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES])
 		return -EINVAL;
 
-	if (!info->attrs[NL80211_ATTR_STA_AID])
+	if (!info->attrs[NL80211_ATTR_STA_AID] &&
+	    !info->attrs[NL80211_ATTR_PEER_AID])
 		return -EINVAL;
 
 	mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
@@ -3985,7 +3989,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	params.listen_interval =
 		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
 
-	params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
+	if (info->attrs[NL80211_ATTR_STA_AID])
+		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
+	else
+		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_PEER_AID]);
 	if (!params.aid || params.aid > IEEE80211_MAX_AID)
 		return -EINVAL;
 
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
