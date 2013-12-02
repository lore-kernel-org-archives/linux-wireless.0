Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41142 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3LBPeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 10:34:10 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so9017330eae.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 07:34:09 -0800 (PST)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH 1/2] nl80211/cfg80211: Set VHT Operating mode
Date: Mon,  2 Dec 2013 16:33:58 +0100
Message-Id: <1385998439-27632-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131202_163414_795209_0ED995B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This attribuite is needed for setting Operating Mode Notification
in AP mode from User Space. This functionality is required when
User Space received Assoc Reqeust contains VHT Operation Mode
Notification element.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 include/net/cfg80211.h       |    4 ++++
 include/uapi/linux/nl80211.h |    6 ++++++
 net/wireless/nl80211.c       |    7 +++++++
 3 files changed, 17 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3eae46c..0b66d91 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -748,6 +748,8 @@ enum station_parameters_apply_mask {
  * @supported_channels_len: number of supported channels
  * @supported_oper_classes: supported oper classes in IEEE 802.11 format
  * @supported_oper_classes_len: number of supported operating classes
+ * @vht_opmode: operating mode field
+ * @vht_opmode_used: information if operating mode field is used
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -771,6 +773,8 @@ struct station_parameters {
 	u8 supported_channels_len;
 	const u8 *supported_oper_classes;
 	u8 supported_oper_classes_len;
+	u8 vht_opmode;
+	bool vht_opmode_used;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f752e98..0240e7d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1508,6 +1508,10 @@ enum nl80211_commands {
  *	to react to radar events, e.g. initiate a channel switch or leave the
  *	IBSS network.
  *
+ * @NL80211_ATTR_VHT_OPMODE: Operating mode field from Operating Mode
+ *	Notification Element based on association request when used with
+ *	NL80211_CMD_NEW_STATION
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1824,6 +1828,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HANDLE_DFS,
 
+	NL80211_ATTR_VHT_OPMODE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a7f4e79..ddd1f71 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -357,6 +357,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_STA_SUPPORTED_CHANNELS] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
 	[NL80211_ATTR_HANDLE_DFS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_VHT_OPMODE] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -4125,6 +4126,12 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.vht_capa =
 			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
 
+	if (info->attrs[NL80211_ATTR_VHT_OPMODE]) {
+		params.vht_opmode_used = true;
+		params.vht_opmode =
+			nla_get_u8(info->attrs[NL80211_ATTR_VHT_OPMODE]);
+	}
+
 	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION]) {
 		params.plink_action =
 			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
-- 
1.7.9.5

