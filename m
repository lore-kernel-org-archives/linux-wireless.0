Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5736 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab3IQTcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 15:32:00 -0400
From: Chet Lanctot <clanctot@codeaurora.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Chet Lanctot <clanctot@codeaurora.org>
Subject: [PATCH 2/2] nl80211/cfg80211: PMF Requirement communicated to driver with AP SME
Date: Tue, 17 Sep 2013 12:31:36 -0700
Message-Id: <1379446296-22236-3-git-send-email-clanctot@codeaurora.org> (sfid-20130917_213227_344083_0A8DC8D3)
In-Reply-To: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
References: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed for drivers that have AP SME integrated.  Whether PMF (Protected
Management Frames, 802.11w) should be used for station connections
is communicated from upper layer software through nl80211/cfg80211.

Signed-off-by: Chet Lanctot <clanctot@codeaurora.org>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 14 ++++++++++----
 net/wireless/nl80211.c       |  9 +++++++++
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aeaf6df..5ac389c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -636,6 +636,8 @@ struct cfg80211_acl_data {
  *	user space)
  * @ssid_len: length of @ssid
  * @hidden_ssid: whether to hide the SSID in Beacon/Probe Response frames
+ * @mfp: indicate whether management frame protection is used for 
+ *	station connections 
  * @crypto: crypto settings
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
@@ -655,6 +657,7 @@ struct cfg80211_ap_settings {
 	const u8 *ssid;
 	size_t ssid_len;
 	enum nl80211_hidden_ssid hidden_ssid;
+	enum nl80211_mfp mfp;
 	struct cfg80211_crypto_settings crypto;
 	bool privacy;
 	enum nl80211_auth_type auth_type;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index aa1d122..f711ab5 100644
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
- * @NL80211_MFP_REQUIRED: Management frame protection required
+ * @NL80211_MFP_NO: Management frame protection not used on 
+ *	any connection 
+ * @NL80211_MFP_REQUIRED: Management frame protection required 
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
index 14a14d4..1702ae9 100644
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
-- 
1.7.12.rc0.22.gcdd159b

