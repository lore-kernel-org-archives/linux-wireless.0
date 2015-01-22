Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60495 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbbAVUiu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:38:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: support drivers to control software crypto
Date: Thu, 22 Jan 2015 21:38:44 +0100
Message-Id: <1421959125-10834-1-git-send-email-johannes@sipsolutions.net> (sfid-20150122_213902_869381_3EC6AD4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some drivers unfortunately cannot support software crypto, but
mac80211 currently assumes that they do.

This has the issue that if the hardware enabling fails for some
reason, the software fallback is used, which won't work. This
clearly isn't desirable, the error should be reported and the
key setting refused.

Support this in mac80211 by allowing drivers to set a new HW
flag IEEE80211_HW_SW_CRYPTO_CONTROL, in which case mac80211 will
only allow software fallback if the set_key() method returns 1.
The driver will also need to advertise supported cipher suites
so that mac80211 doesn't advertise any (future) software ciphers
that the driver then can't actually do.

While at it, to make it easier to support this, refactor the
ieee80211_init_cipher_suites() code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 12 ++++++++++
 net/mac80211/key.c     |  8 +++++--
 net/mac80211/main.c    | 65 ++++++++++++++++++++++++++++++--------------------
 3 files changed, 57 insertions(+), 28 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 275ee56152ad..33b87c50a4cf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1634,6 +1634,12 @@ struct ieee80211_tx_control {
  *	be created.  It is expected user-space will create vifs as
  *	desired (and thus have them named as desired).
  *
+ * @IEEE80211_HW_SW_CRYPTO_CONTROL: The driver wants to control which of the
+ *	crypto algorithms can be done in software - so don't automatically
+ *	try to fall back to it if hardware crypto fails, but do so only if
+ *	the driver returns 1. This also forces the driver to advertise its
+ *	supported cipher suites.
+ *
  * @IEEE80211_HW_QUEUE_CONTROL: The driver wants to control per-interface
  *	queue mapping in order to use different queues (not just one per AC)
  *	for different virtual interfaces. See the doc section on HW queue
@@ -1681,6 +1687,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
 	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
 	IEEE80211_HW_NO_AUTO_VIF			= 1<<15,
+	IEEE80211_HW_SW_CRYPTO_CONTROL			= 1<<16,
 	/* free slots */
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
@@ -1955,6 +1962,11 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * added; if you return 0 then hw_key_idx must be assigned to the
  * hardware key index, you are free to use the full u8 range.
  *
+ * Note that in the case that the @IEEE80211_HW_SW_CRYPTO_CONTROL flag is
+ * set, mac80211 will not automatically fall back to software crypto if
+ * enabling hardware crypto failed. The set_key() call may also return the
+ * value 1 to permit this specific key/algorithm to be done in software.
+ *
  * When the cmd is %DISABLE_KEY then it must succeed.
  *
  * Note that it is permissible to not decrypt a frame even if a key
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f8d9f0ee59bf..760fedc08f42 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -150,7 +150,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		return 0;
 	}
 
-	if (ret != -ENOSPC && ret != -EOPNOTSUPP)
+	if (ret != -ENOSPC && ret != -EOPNOTSUPP && ret != 1)
 		sdata_err(sdata,
 			  "failed to set key (%d, %pM) to hardware (%d)\n",
 			  key->conf.keyidx,
@@ -163,7 +163,11 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		/* all of these we can do in software */
+		/* all of these we can do in software - if driver can */
+		if (ret == 1)
+			return 0;
+		if (key->local->hw.flags & IEEE80211_HW_SW_CRYPTO_CONTROL)
+			return -EINVAL;
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 46264cb6604b..ea6b82ac4f0b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -658,7 +658,6 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 	bool have_wep = !(IS_ERR(local->wep_tx_tfm) ||
 			  IS_ERR(local->wep_rx_tfm));
 	bool have_mfp = local->hw.flags & IEEE80211_HW_MFP_CAPABLE;
-	const struct ieee80211_cipher_scheme *cs = local->hw.cipher_schemes;
 	int n_suites = 0, r = 0, w = 0;
 	u32 *suites;
 	static const u32 cipher_suites[] = {
@@ -672,12 +671,38 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		WLAN_CIPHER_SUITE_AES_CMAC
 	};
 
-	/* Driver specifies the ciphers, we have nothing to do... */
-	if (local->hw.wiphy->cipher_suites && have_wep)
-		return 0;
+	if (local->hw.flags & IEEE80211_HW_SW_CRYPTO_CONTROL ||
+	    local->hw.wiphy->cipher_suites) {
+		/* If the driver advertises, or doesn't support SW crypto,
+		 * we only need to remove WEP if necessary.
+		 */
+		if (have_wep)
+			return 0;
+
+		/* well if it has _no_ ciphers ... fine */
+		if (!local->hw.wiphy->n_cipher_suites)
+			return 0;
+
+		/* Driver provides cipher suites, but we need to exclude WEP */
+		suites = kmemdup(local->hw.wiphy->cipher_suites,
+				 sizeof(u32) * local->hw.wiphy->n_cipher_suites,
+				 GFP_KERNEL);
+		if (!suites)
+			return -ENOMEM;
 
-	/* Set up cipher suites if driver relies on mac80211 cipher defs */
-	if (!local->hw.wiphy->cipher_suites && !cs) {
+		for (r = 0; r < local->hw.wiphy->n_cipher_suites; r++) {
+			u32 suite = local->hw.wiphy->cipher_suites[r];
+
+			if (suite == WLAN_CIPHER_SUITE_WEP40 ||
+			    suite == WLAN_CIPHER_SUITE_WEP104)
+				continue;
+			suites[w++] = suite;
+		}
+	} else if (!local->hw.cipher_schemes) {
+		/* If the driver doesn't have cipher schemes, there's nothing
+		 * else to do other than assign the (software supported and
+		 * perhaps offloaded) cipher suites.
+		 */
 		local->hw.wiphy->cipher_suites = cipher_suites;
 		local->hw.wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
@@ -689,12 +714,16 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 			local->hw.wiphy->n_cipher_suites -= 2;
 		}
 
+		/* not dynamically allocated, so just return */
 		return 0;
-	}
+	} else {
+		const struct ieee80211_cipher_scheme *cs;
 
-	if (!local->hw.wiphy->cipher_suites) {
-		/*
-		 * Driver specifies cipher schemes only
+		cs = local->hw.cipher_schemes;
+
+		/* Driver specifies cipher schemes only (but not cipher suites
+		 * including the schemes)
+		 *
 		 * We start counting ciphers defined by schemes, TKIP and CCMP
 		 */
 		n_suites = local->hw.n_cipher_schemes + 2;
@@ -724,22 +753,6 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 
 		for (r = 0; r < local->hw.n_cipher_schemes; r++)
 			suites[w++] = cs[r].cipher;
-	} else {
-		/* Driver provides cipher suites, but we need to exclude WEP */
-		suites = kmemdup(local->hw.wiphy->cipher_suites,
-				 sizeof(u32) * local->hw.wiphy->n_cipher_suites,
-				 GFP_KERNEL);
-		if (!suites)
-			return -ENOMEM;
-
-		for (r = 0; r < local->hw.wiphy->n_cipher_suites; r++) {
-			u32 suite = local->hw.wiphy->cipher_suites[r];
-
-			if (suite == WLAN_CIPHER_SUITE_WEP40 ||
-			    suite == WLAN_CIPHER_SUITE_WEP104)
-				continue;
-			suites[w++] = suite;
-		}
 	}
 
 	local->hw.wiphy->cipher_suites = suites;
-- 
2.1.4

