Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37174 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3LCEqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 23:46:50 -0500
From: Chet Lanctot <clanctot@codeaurora.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Chet Lanctot <clanctot@codeaurora.org>
Subject: [PATCH 2/2 V2] nl80211/cfg80211: Enable station PMF requirement to be specified to driver with AP SME
Date: Mon,  2 Dec 2013 20:46:25 -0800
Message-Id: <1386045985-2398-3-git-send-email-clanctot@codeaurora.org> (sfid-20131203_054705_519068_5DDD6BF4)
In-Reply-To: <1386045985-2398-1-git-send-email-clanctot@codeaurora.org>
References: <1386045985-2398-1-git-send-email-clanctot@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the device driver implements the AP SME there is a need
for userspace to indicate to the driver the PMF (Protected
Management Frames, 802.11w) requirements for station connections.

The driver enforces the requested PMF state when processing station
connection requests.  Value NL80211_MFP_NO means that PMF connections
cannot be made with stations.  Value NL80211_MFP_REQUIRED means that all
station connections must be PMF protected.  Value NL80211_MFP_OPTIONAL
means that a connection can be made if the station supports it, but it is not
required.

Signed-off-by: Chet Lanctot <clanctot@codeaurora.org>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h | 12 +++++++++---
 net/wireless/nl80211.c       | 15 ++++++++++++---
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aeaf6df..9039888 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -636,6 +636,9 @@ struct cfg80211_acl_data {
  *	user space)
  * @ssid_len: length of @ssid
  * @hidden_ssid: whether to hide the SSID in Beacon/Probe Response frames
+ * @mfp: indicate whether management frame protection is used for
+ *	station connections, this is enforced by the driver when a station
+ *	attempts to make a connection (see definion of nl80211_mfp for details)
  * @crypto: crypto settings
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
@@ -655,6 +658,7 @@ struct cfg80211_ap_settings {
 	const u8 *ssid;
 	size_t ssid_len;
 	enum nl80211_hidden_ssid hidden_ssid;
+	enum nl80211_mfp mfp;
 	struct cfg80211_crypto_settings crypto;
 	bool privacy;
 	enum nl80211_auth_type auth_type;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 4c80a10..59d4d2e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1063,8 +1063,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_USE_MFP: Whether management frame protection (IEEE 802.11w) is
  *	used for the association (&enum nl80211_mfp, represented as a u32);
- *	this attribute can be used
- *	with %NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests
+ *	this attribute can be used with %NL80211_CMD_ASSOCIATE,
+ *	%NL80211_CMD_CONNECT, and @NL80211_CMD_START_AP requests
  *
  * @NL80211_ATTR_STA_FLAGS2: Attribute containing a
  *	&struct nl80211_sta_flag_update.
@@ -2934,12 +2934,18 @@ enum nl80211_key_type {
 
 /**
  * enum nl80211_mfp - Management frame protection state
- * @NL80211_MFP_NO: Management frame protection not used
+ * @NL80211_MFP_NO: Management frame protection not used on
+ *	any connection
  * @NL80211_MFP_REQUIRED: Management frame protection required
+ *	on all connections
+ * @NL80211_MFP_OPTIONAL: For an AP, management frame
+ *	protection is optional for a station connection depending
+ *	on whether the station supports MFP
  */
 enum nl80211_mfp {
 	NL80211_MFP_NO,
 	NL80211_MFP_REQUIRED,
+	NL80211_MFP_OPTIONAL,
 };
 
 enum nl80211_wpa_versions {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 14a14d4..7a73adf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3207,6 +3207,15 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.acl);
 	}
 
+	if (info->attrs[NL80211_ATTR_USE_MFP]) {
+		params.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
+		if (params.mfp != NL80211_MFP_REQUIRED &&
+		    params.mfp != NL80211_MFP_OPTIONAL &&
+		    params.mfp != NL80211_MFP_NO)
+			return -EINVAL;
+	} else
+		params.mfp = NL80211_MFP_NO;
+
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
 		wdev->preset_chandef = params.chandef;
@@ -3689,7 +3698,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 7);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
 
 	switch (statype) {
 	case CFG80211_STA_MESH_PEER_KERNEL:
@@ -3767,7 +3776,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
 				  BIT(NL80211_STA_FLAG_WME) |
 				  BIT(NL80211_STA_FLAG_MFP) |
-				  BIT(NL80211_STA_FLAG_SA_QUERY_REQUIRED)))
+				  BIT(NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED)))
 			return -EINVAL;
 
 		/* but authenticated/associated only if driver handles it */
@@ -4091,7 +4100,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 7);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
 
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
-- 
1.7.12.rc0.22.gcdd159b

