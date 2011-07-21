Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37051 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab1GURgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 13:36:37 -0400
Subject: [PATCH 2/3] ath5k: remove ath5k_hw_get_capability(),
 don't use VEOL on AR5210
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 21 Jul 2011 13:36:35 -0400
Message-ID: <20110721173635.30989.81930.stgit@mj.roinet.com> (sfid-20110721_193657_171976_80602AA8)
In-Reply-To: <20110721173628.30989.19587.stgit@mj.roinet.com>
References: <20110721173628.30989.19587.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are only two capabilities we need, and both are trivial to find.

ath5k_hw_hasbssidmask() is true on AR5212, but not on AR5210 or AR5211.

ath5k_hw_hasveol() is true on AR5211 and AR5212, but not on AR5210,
according to the HAL source.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   32 -----------------------
 drivers/net/wireless/ath/ath5k/base.h  |    9 ++++--
 drivers/net/wireless/ath/ath5k/caps.c  |   45 --------------------------------
 3 files changed, 5 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index c6fb44c..277d5cb 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -972,35 +972,6 @@ enum ath5k_power_mode {
 #define AR5K_SOFTLED_ON		0
 #define AR5K_SOFTLED_OFF	1
 
-/*
- * Chipset capabilities -see ath5k_hw_get_capability-
- * get_capability function is not yet fully implemented
- * in ath5k so most of these don't work yet...
- * TODO: Implement these & merge with _TUNE_ stuff above
- */
-enum ath5k_capability_type {
-	AR5K_CAP_REG_DMN		= 0,	/* Used to get current reg. domain id */
-	AR5K_CAP_TKIP_MIC		= 2,	/* Can handle TKIP MIC in hardware */
-	AR5K_CAP_TKIP_SPLIT		= 3,	/* TKIP uses split keys */
-	AR5K_CAP_PHYCOUNTERS		= 4,	/* PHY error counters */
-	AR5K_CAP_DIVERSITY		= 5,	/* Supports fast diversity */
-	AR5K_CAP_NUM_TXQUEUES		= 6,	/* Used to get max number of hw txqueues */
-	AR5K_CAP_VEOL			= 7,	/* Supports virtual EOL */
-	AR5K_CAP_COMPRESSION		= 8,	/* Supports compression */
-	AR5K_CAP_BURST			= 9,	/* Supports packet bursting */
-	AR5K_CAP_FASTFRAME		= 10,	/* Supports fast frames */
-	AR5K_CAP_TXPOW			= 11,	/* Used to get global tx power limit */
-	AR5K_CAP_TPC			= 12,	/* Can do per-packet tx power control (needed for 802.11a) */
-	AR5K_CAP_BSSIDMASK		= 13,	/* Supports bssid mask */
-	AR5K_CAP_MCAST_KEYSRCH		= 14,	/* Supports multicast key search */
-	AR5K_CAP_TSF_ADJUST		= 15,	/* Supports beacon tsf adjust */
-	AR5K_CAP_XR			= 16,	/* Supports XR mode */
-	AR5K_CAP_WME_TKIPMIC		= 17,	/* Supports TKIP MIC when using WMM */
-	AR5K_CAP_CHAN_HALFRATE		= 18,	/* Supports half rate channels */
-	AR5K_CAP_CHAN_QUARTERRATE	= 19,	/* Supports quarter rate channels */
-	AR5K_CAP_RFSILENT		= 20,	/* Supports RFsilent */
-};
-
 
 /* XXX: we *may* move cap_range stuff to struct wiphy */
 struct ath5k_capabilities {
@@ -1506,9 +1477,6 @@ void ath5k_rfkill_hw_stop(struct ath5k_hw *ah);
 
 /* Misc functions TODO: Cleanup */
 int ath5k_hw_set_capabilities(struct ath5k_hw *ah);
-int ath5k_hw_get_capability(struct ath5k_hw *ah,
-			    enum ath5k_capability_type cap_type, u32 capability,
-			    u32 *result);
 int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid, u16 assoc_id);
 int ath5k_hw_disable_pspoll(struct ath5k_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index aa8aafc..a81f28d 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -81,9 +81,10 @@ struct ath5k_vif_iter_data {
 void ath5k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif);
 
 
-#define ath5k_hw_hasbssidmask(_ah) \
-	(ath5k_hw_get_capability(_ah, AR5K_CAP_BSSIDMASK, 0, NULL) == 0)
-#define ath5k_hw_hasveol(_ah) \
-	(ath5k_hw_get_capability(_ah, AR5K_CAP_VEOL, 0, NULL) == 0)
+/* Check whether BSSID mask is supported */
+#define ath5k_hw_hasbssidmask(_ah) (ah->ah_version == AR5K_AR5212)
+
+/* Check whether virtual EOL is supported */
+#define ath5k_hw_hasveol(_ah) (ah->ah_version != AR5K_AR5210)
 
 #endif
diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index c752982..eefe670 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -112,51 +112,6 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 	return 0;
 }
 
-/* Main function used by the driver part to check caps */
-int ath5k_hw_get_capability(struct ath5k_hw *ah,
-		enum ath5k_capability_type cap_type,
-		u32 capability, u32 *result)
-{
-	switch (cap_type) {
-	case AR5K_CAP_NUM_TXQUEUES:
-		if (result) {
-			if (ah->ah_version == AR5K_AR5210)
-				*result = AR5K_NUM_TX_QUEUES_NOQCU;
-			else
-				*result = AR5K_NUM_TX_QUEUES;
-			goto yes;
-		}
-	case AR5K_CAP_VEOL:
-		goto yes;
-	case AR5K_CAP_COMPRESSION:
-		if (ah->ah_version == AR5K_AR5212)
-			goto yes;
-		else
-			goto no;
-	case AR5K_CAP_BURST:
-		goto yes;
-	case AR5K_CAP_TPC:
-		goto yes;
-	case AR5K_CAP_BSSIDMASK:
-		if (ah->ah_version == AR5K_AR5212)
-			goto yes;
-		else
-			goto no;
-	case AR5K_CAP_XR:
-		if (ah->ah_version == AR5K_AR5212)
-			goto yes;
-		else
-			goto no;
-	default:
-		goto no;
-	}
-
-no:
-	return -EINVAL;
-yes:
-	return 0;
-}
-
 /*
  * TODO: Following functions should be part of a new function
  * set_capability
