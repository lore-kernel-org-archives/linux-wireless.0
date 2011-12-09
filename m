Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:34555 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1LIXxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 18:53:47 -0500
Received: by yenm5 with SMTP id m5so457864yen.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 15:53:46 -0800 (PST)
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by wpzn4.hot.corp.google.com (Postfix) with ESMTPS id A3C0F1E004D
	for <linux-wireless@vger.kernel.org>; Fri,  9 Dec 2011 15:45:36 -0800 (PST)
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by wpaz1.hot.corp.google.com with ESMTP id pB9NjZ0b030575
	for <linux-wireless@vger.kernel.org>; Fri, 9 Dec 2011 15:45:35 -0800
From: Paul Stewart <pstew@chromium.org>
Date: Fri, 9 Dec 2011 14:31:44 -0800
Subject: [PATCHv2] iw: Print connected time and beacon loss in station
To: linux-wireless@vger.kernel.org
In-Reply-To: <20111209223349.53B9B206F0@glenhelen.mtv.corp.google.com>
References: <20111209223349.53B9B206F0@glenhelen.mtv.corp.google.com>
Message-Id: <20111209234535.64E01204E6@glenhelen.mtv.corp.google.com> (sfid-20111210_005350_384611_6004A543)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print beacon loss and connected time stats out of the station.

Signed-off-by: Paul Stewart <pstew@chromium.org>

v2: Add space between seconds and "s"
---
 nl80211.h |    4 ++++
 station.c |    9 +++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index f51e3bf..3c88e7a 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1651,6 +1651,7 @@ enum nl80211_sta_bss_param {
  *     containing info as possible, see &enum nl80211_sta_bss_param
  * @NL80211_STA_INFO_CONNECTED_TIME: time since the station is last connected
  * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
+ * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1673,6 +1674,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_BSS_PARAM,
 	NL80211_STA_INFO_CONNECTED_TIME,
 	NL80211_STA_INFO_STA_FLAGS,
+	NL80211_STA_INFO_BEACON_LOSS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2785,9 +2787,11 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_SK_TX_STATUS: This driver supports reflecting back
  *	TX status to the socket error queue when requested with the
  *	socket option.
+ * @NL80211_FEATURE_HT_IBSS: This driver supports IBSS with HT datarates.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
+	NL80211_FEATURE_HT_IBSS		= 1 << 1,
 };
 
 /**
diff --git a/station.c b/station.c
index ef69ea5..db34050 100644
--- a/station.c
+++ b/station.c
@@ -51,8 +51,10 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_PLINK_STATE] = { .type = NLA_U8 },
 		[NL80211_STA_INFO_TX_RETRIES] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_TX_FAILED] = { .type = NLA_U32 },
+		[NL80211_STA_INFO_CONNECTED_TIME] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_STA_FLAGS] =
 			{ .minlen = sizeof(struct nl80211_sta_flag_update) },
+		[NL80211_STA_INFO_BEACON_LOSS] = { .type = NLA_U32 },
 	};
 
 	static struct nla_policy rate_policy[NL80211_RATE_INFO_MAX + 1] = {
@@ -86,6 +88,9 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	if_indextoname(nla_get_u32(tb[NL80211_ATTR_IFINDEX]), dev);
 	printf("Station %s (on %s)", mac_addr, dev);
 
+	if (sinfo[NL80211_STA_INFO_CONNECTED_TIME])
+		printf("\n\tconnected time:\t%u s",
+			nla_get_u32(sinfo[NL80211_STA_INFO_CONNECTED_TIME]));
 	if (sinfo[NL80211_STA_INFO_INACTIVE_TIME])
 		printf("\n\tinactive time:\t%u ms",
 			nla_get_u32(sinfo[NL80211_STA_INFO_INACTIVE_TIME]));
@@ -107,6 +112,10 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	if (sinfo[NL80211_STA_INFO_TX_FAILED])
 		printf("\n\ttx failed:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_FAILED]));
+	if (sinfo[NL80211_STA_INFO_BEACON_LOSS])
+		printf("\n\tbeacon loss:\t%u",
+			nla_get_u32(sinfo[NL80211_STA_INFO_BEACON_LOSS]));
+
 	if (sinfo[NL80211_STA_INFO_SIGNAL])
 		printf("\n\tsignal:  \t%d dBm",
 			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]));
-- 
1.7.3.1

