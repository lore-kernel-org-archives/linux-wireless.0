Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42962 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab3AaJ1I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 04:27:08 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 3/6] ath9k: Only add fix_rssi_inv_only when spectral code is used
Date: Thu, 31 Jan 2013 10:26:46 +0100
Message-Id: <1359624409-14815-3-git-send-email-sven@narfation.org> (sfid-20130131_102719_013833_242AC275)
In-Reply-To: <1359624409-14815-1-git-send-email-sven@narfation.org>
References: <1359624409-14815-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code is only used when ATH9K_DEBUGFS is activated and causes build warnings
when it is still compiled without user.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d372e4a..e349bff 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1016,12 +1016,14 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 		rxs->flag &= ~RX_FLAG_DECRYPTED;
 }
 
+#ifdef CONFIG_ATH9K_DEBUGFS
 static s8 fix_rssi_inv_only(u8 rssi_val)
 {
 	if (rssi_val == 128)
 		rssi_val = 0;
 	return (s8) rssi_val;
 }
+#endif
 
 /* returns 1 if this was a spectral frame, even if not handled. */
 static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
-- 
1.7.10.4

