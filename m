Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:42907 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3LCJFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 04:05:16 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so1249331eek.41
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 01:05:16 -0800 (PST)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH 1/2 V3] nl80211/cfg80211: Set Operating Mode Notification
Date: Tue,  3 Dec 2013 10:04:59 +0100
Message-Id: <1386061500-5750-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131203_100532_815982_147095C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This attribuite is needed for setting Operating Mode Notification
in AP mode from User Space. This functionality is required when
User Space received Assoc Reqeust contains Operation Mode
Notification element.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 include/net/cfg80211.h       |    4 ++++
 include/uapi/linux/nl80211.h |    6 ++++++
 net/wireless/nl80211.c       |    7 +++++++
 3 files changed, 17 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3eae46c..ca3c81e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -748,6 +748,8 @@ enum station_parameters_apply_mask {
  * @supported_channels_len: number of supported channels
  * @supported_oper_classes: supported oper classes in IEEE 802.11 format
  * @supported_oper_classes_len: number of supported operating classes
+ * @opmode_notif: operating mode field from Operating Mode Notification
+ * @opmode_notif_used: information if operating mode field is used
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -771,6 +773,8 @@ struct station_parameters {
 	u8 supported_channels_len;
 	const u8 *supported_oper_classes;
 	u8 supported_oper_classes_len;
+	u8 opmode_notif;
+	bool opmode_notif_used;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f752e98..0f283a9 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1508,6 +1508,10 @@ enum nl80211_commands {
  *	to react to radar events, e.g. initiate a channel switch or leave the
  *	IBSS network.
  *
+ * @NL80211_ATTR_OPMODE_NOTIF: Operating mode field from Operating Mode
+ *	Notification Element based on association request when used with
+ *	NL80211_CMD_NEW_STATION
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1824,6 +1828,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HANDLE_DFS,
 
+	NL80211_ATTR_OPMODE_NOTIF,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a7f4e79..fefa954 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -357,6 +357,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_STA_SUPPORTED_CHANNELS] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
 	[NL80211_ATTR_HANDLE_DFS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_OPMODE_NOTIF] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -4125,6 +4126,12 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.vht_capa =
 			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
 
+	if (info->attrs[NL80211_ATTR_OPMODE_NOTIF]) {
+		params.opmode_notif_used = true;
+		params.opmode_notif =
+			nla_get_u8(info->attrs[NL80211_ATTR_OPMODE_NOTIF]);
+	}
+
 	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION]) {
 		params.plink_action =
 			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
-- 
1.7.9.5

