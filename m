Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42958 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3AaJ1F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 04:27:05 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 2/6] ath9k: Only process fft samples when ATH9K_DEBUGFS is enabled
Date: Thu, 31 Jan 2013 10:26:45 +0100
Message-Id: <1359624409-14815-2-git-send-email-sven@narfation.org> (sfid-20130131_102713_979552_8F432F06)
In-Reply-To: <1359624409-14815-1-git-send-email-sven@narfation.org>
References: <1359624409-14815-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code can only be used when ATH9k_DEBUGFS is enabled an not when ATH_DEBUG
is activated. Still enabling it would cause build failures.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2af6f19..d372e4a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1027,7 +1027,7 @@ static s8 fix_rssi_inv_only(u8 rssi_val)
 static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 			   struct ath_rx_status *rs, u64 tsf)
 {
-#ifdef CONFIG_ATH_DEBUG
+#ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath_hw *ah = sc->sc_ah;
 	u8 bins[SPECTRAL_HT20_NUM_BINS];
 	u8 *vdata = (u8 *)hdr;
-- 
1.7.10.4

