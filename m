Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbeCIG13 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 01:27:29 -0500
From: mpubbise@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [RFC] mac80211: advertise supported interface types for sw encryption
Date: Fri,  9 Mar 2018 11:57:02 +0530
Message-Id: <1520576822-1954-1-git-send-email-mpubbise@codeaurora.org> (sfid-20180309_072736_538438_D7F33282)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <mpubbise@codeaurora.org>

Extending SW_CRYPTO_CONTROL interface so that drivers can advertise
the interface types on which they can support software encryption.
Driver's job is not done by advertising the supported vif types alone,
they should also return -EOPNOTSUPP from set_key.

Mac80211 will make the fallback decision to sw ecryption based
on the return type of set_key callback and the driver's support for
software encryption.

This change is done with the sole reason of adding the support of
VLANs for drivers which enable SW_CRYPTO_CONTROL(ex:ath10k).

With the current logic, configuring GTKs for specific VLAN groups will
always fail with the drivers enabling SW_CRYPTO_CONTROL. I understand
that the driver can return 1 from set_key to enable software encryption
in mac80211, but GTKs for VLANs are never passed down to the driver.
Since the return value is initialized to -EOPNOTSUPP, with this approach,
we get away with the failure.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
 include/net/mac80211.h |  5 +++++
 net/mac80211/key.c     | 12 +++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2fd59ed..3df6bee5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2237,6 +2237,10 @@ enum ieee80211_hw_flags {
  *	supported by HW.
  * @max_nan_de_entries: maximum number of NAN DE functions supported by the
  *	device.
+ * @supp_sw_crypto_iftypes: supported interface types for software crypto,
+ * 	this field is applicable for devices advertising SW_CRYPTO_CONTROL
+ * 	hwflag. Drivers may also set the interface types on which mac80211
+ * 	can fallback to software encryption if set_key returns -EOPNOTSUPP.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -2272,6 +2276,7 @@ struct ieee80211_hw {
 	u8 n_cipher_schemes;
 	const struct ieee80211_cipher_scheme *cipher_schemes;
 	u8 max_nan_de_entries;
+	u16 supp_sw_crypto_iftypes;
 };
 
 static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index aee05ec..a1011c4 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -126,7 +126,7 @@ static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
 
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = key->sdata;
 	struct sta_info *sta;
 	int ret = -EOPNOTSUPP;
 
@@ -162,7 +162,6 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (sta && !sta->uploaded)
 		goto out_unsupported;
 
-	sdata = key->sdata;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		/*
 		 * The driver doesn't know anything about VLAN interfaces.
@@ -214,8 +213,15 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
-		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
+
+		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL)) {
+			if ((ret == -EOPNOTSUPP) &&
+			    (sdata->local->hw.supp_sw_crypto_iftypes &
+			    (1 << sdata->vif.type)))
+				return 0;
 			return -EINVAL;
+		}
+
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.7.4
