Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:4971 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757729Ab0IHHFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 03:05:42 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0432109540
	for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2010 16:05:41 +0900 (JST)
Subject: [PATCH 8/8] ath9k: Use common crypt capabilities flags
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Wed, 08 Sep 2010 16:05:10 +0900
Message-ID: <20100908070510.11255.49382.stgit@tt-desk>
In-Reply-To: <20100908070427.11255.17659.stgit@tt-desk>
References: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use common crypt capabilities flags from common ath and remove corresponding
ath9k HW capabilities flags.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   12 +++++------
 drivers/net/wireless/ath/ath9k/hw.h |   40 +++++++++++++++--------------------
 2 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 14fb082..b126f2e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1864,13 +1864,13 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->low_5ghz_chan = 4920;
 	pCap->high_5ghz_chan = 6100;
 
-	pCap->hw_caps &= ~ATH9K_HW_CAP_CIPHER_CKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_TKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_AESCCM;
+	common->crypt_caps &= ~ATH_CRYPT_CAP_CIPHER_CKIP;
+	common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_TKIP;
+	common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_AESCCM;
 
-	pCap->hw_caps &= ~ATH9K_HW_CAP_MIC_CKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_MIC_TKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_MIC_AESCCM;
+	common->crypt_caps &= ~ATH_CRYPT_CAP_MIC_CKIP;
+	common->crypt_caps |= ATH_CRYPT_CAP_MIC_TKIP;
+	common->crypt_caps |= ATH_CRYPT_CAP_MIC_AESCCM;
 
 	if (ah->config.ht_enable)
 		pCap->hw_caps |= ATH9K_HW_CAP_HT;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1bee964..2a8ef09 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -181,29 +181,23 @@ enum wireless_mode {
 };
 
 enum ath9k_hw_caps {
-	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(0),
-	ATH9K_HW_CAP_MIC_CKIP                   = BIT(1),
-	ATH9K_HW_CAP_MIC_TKIP                   = BIT(2),
-	ATH9K_HW_CAP_CIPHER_AESCCM              = BIT(3),
-	ATH9K_HW_CAP_CIPHER_CKIP                = BIT(4),
-	ATH9K_HW_CAP_CIPHER_TKIP                = BIT(5),
-	ATH9K_HW_CAP_VEOL                       = BIT(6),
-	ATH9K_HW_CAP_BSSIDMASK                  = BIT(7),
-	ATH9K_HW_CAP_MCAST_KEYSEARCH            = BIT(8),
-	ATH9K_HW_CAP_HT                         = BIT(9),
-	ATH9K_HW_CAP_GTT                        = BIT(10),
-	ATH9K_HW_CAP_FASTCC                     = BIT(11),
-	ATH9K_HW_CAP_RFSILENT                   = BIT(12),
-	ATH9K_HW_CAP_CST                        = BIT(13),
-	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(14),
-	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(15),
-	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(16),
-	ATH9K_HW_CAP_EDMA			= BIT(17),
-	ATH9K_HW_CAP_RAC_SUPPORTED		= BIT(18),
-	ATH9K_HW_CAP_LDPC			= BIT(19),
-	ATH9K_HW_CAP_FASTCLOCK			= BIT(20),
-	ATH9K_HW_CAP_SGI_20			= BIT(21),
-	ATH9K_HW_CAP_PAPRD			= BIT(22),
+	ATH9K_HW_CAP_VEOL                       = BIT(0),
+	ATH9K_HW_CAP_BSSIDMASK                  = BIT(1),
+	ATH9K_HW_CAP_MCAST_KEYSEARCH            = BIT(2),
+	ATH9K_HW_CAP_HT                         = BIT(3),
+	ATH9K_HW_CAP_GTT                        = BIT(4),
+	ATH9K_HW_CAP_FASTCC                     = BIT(5),
+	ATH9K_HW_CAP_RFSILENT                   = BIT(6),
+	ATH9K_HW_CAP_CST                        = BIT(7),
+	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(8),
+	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(9),
+	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(10),
+	ATH9K_HW_CAP_EDMA			= BIT(11),
+	ATH9K_HW_CAP_RAC_SUPPORTED		= BIT(12),
+	ATH9K_HW_CAP_LDPC			= BIT(13),
+	ATH9K_HW_CAP_FASTCLOCK			= BIT(14),
+	ATH9K_HW_CAP_SGI_20			= BIT(15),
+	ATH9K_HW_CAP_PAPRD			= BIT(16),
 };
 
 struct ath9k_hw_capabilities {

