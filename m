Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52227 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaKLHck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 02:32:40 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k: common-spectral: don't depend from ATH9K_DEBUGFS
Date: Wed, 12 Nov 2014 08:32:08 +0100
Message-Id: <1415777528-611-1-git-send-email-linux@rempel-privat.de> (sfid-20141112_083243_037330_3C25EE00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we can have here two variants. Add
ATH9K_CMN_DEBUGFS y if ATH9K_CMN_DEBUGFS || ATH9K_HTC_DEBUGFS
wich will add more configurations and testcases. Or remove ATH9K_HTC_DEBUGFS
which need more time to be done.

So, make common-spectral ignore ATH9K_DEBUGFS option for now.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common-spectral.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.h b/drivers/net/wireless/ath/ath9k/common-spectral.h
index 214c3ba..82d9dd2 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.h
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.h
@@ -138,17 +138,7 @@ void ath9k_cmn_spectral_scan_trigger(struct ath_common *common,
 int ath9k_cmn_spectral_scan_config(struct ath_common *common,
 			       struct ath_spec_scan_priv *spec_priv,
 			       enum spectral_mode spectral_mode);
-
-#ifdef CONFIG_ATH9K_DEBUGFS
 int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
 		    struct ath_rx_status *rs, u64 tsf);
-#else
-static inline int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv,
-				  struct ieee80211_hdr *hdr,
-				  struct ath_rx_status *rs, u64 tsf)
-{
-	return 0;
-}
-#endif /* CONFIG_ATH9K_DEBUGFS */
 
 #endif /* SPECTRAL_H */
-- 
1.9.1

