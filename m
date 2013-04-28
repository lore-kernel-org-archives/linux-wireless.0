Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64722 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab3D1GlP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Apr 2013 02:41:15 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MEpV6-1UHYWp2cVm-00FzUh for
 <linux-wireless@vger.kernel.org>; Sun, 28 Apr 2013 08:41:13 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v3] ath9k: collect statistics about Rx-Dup and Rx-STBC packets
Date: Sun, 28 Apr 2013 08:41:06 +0200
Message-Id: <1367131266-4769-1-git-send-email-linux@rempel-privat.de> (sfid-20130428_084128_692311_9F0F2B7F)
In-Reply-To: <1367076326-21616-1-git-send-email-linux@rempel-privat.de>
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Collect statistics about recived duplicate and STBC packets.
This information should help see if STBC is actually working.

Tested on ar9285; Should work for all chips after ar9280.

Changes:
- v2. test for stbc vield only on ar9280 and later.
      reanme rx_gi to rx_short_gi
- v3. use u16 rs_flags instead of two u8

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/debug.c | 20 +++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/debug.h |  4 ++++
 drivers/net/wireless/ath/ath9k/mac.c   |  6 ++++++
 drivers/net/wireless/ath/ath9k/mac.h   | 26 +++++++++++++++-----------
 4 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index e6307b8..3cb2ae9 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -848,7 +848,7 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 
 	struct ath_softc *sc = file->private_data;
 	char *buf;
-	unsigned int len = 0, size = 1600;
+	unsigned int len = 0, size = 2048;
 	ssize_t retval = 0;
 
 	buf = kzalloc(size, GFP_KERNEL);
@@ -900,6 +900,11 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	RXS_ERR("RX-Frags", rx_frags);
 	RXS_ERR("RX-Spectral", rx_spectral);
 
+	RXS_ERR("RX-ShortGI", rx_short_gi);
+	RXS_ERR("RX-HT40", rx_ht40);
+	RXS_ERR("RX-Duplicate", rx_duplicate);
+	RXS_ERR("RX-STBC", rx_stbc);
+
 	if (len > size)
 		len = size;
 
@@ -939,6 +944,14 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 		if (rs->rs_phyerr < ATH9K_PHYERR_MAX)
 			RX_PHY_ERR_INC(rs->rs_phyerr);
 	}
+	if (rs->rs_flags & ATH9K_RX_GI)
+		RX_STAT_INC(rx_short_gi);
+	if (rs->rs_flags & ATH9K_RX_2040)
+		RX_STAT_INC(rx_ht40);
+	if (rs->rs_flags & ATH9K_RX_DUP)
+		RX_STAT_INC(rx_duplicate);
+	if (rs->rs_flags & ATH9K_RX_STBC)
+		RX_STAT_INC(rx_stbc);
 
 #ifdef CONFIG_ATH9K_MAC_DEBUG
 	spin_lock(&sc->debug.samp_lock);
@@ -1993,6 +2006,11 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 	AWDATA(data_underrun);
 	AWDATA(delim_underrun);
 
+	AWDATA_RX(rx_short_gi);
+	AWDATA_RX(rx_ht40);
+	AWDATA_RX(rx_duplicate);
+	AWDATA_RX(rx_stbc);
+
 	AWDATA_RX(crc_err);
 	AWDATA_RX(decrypt_crc_err);
 	AWDATA_RX(phy_err);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 794a7ec..639dae9 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -241,6 +241,10 @@ struct ath_rx_stats {
 	u32 rx_beacons;
 	u32 rx_frags;
 	u32 rx_spectral;
+	u32 rx_short_gi;
+	u32 rx_ht40;
+	u32 rx_duplicate;
+	u32 rx_stbc;
 };
 
 struct ath_stats {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 498fee0..853cb09 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -590,6 +590,12 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		(ads.ds_rxstatus3 & AR_GI) ? ATH9K_RX_GI : 0;
 	rs->rs_flags |=
 		(ads.ds_rxstatus3 & AR_2040) ? ATH9K_RX_2040 : 0;
+	rs->rs_flags |=
+		(ads.ds_rxstatus3 & AR_RXST_DUP) ? ATH9K_RX_DUP : 0;
+
+	if (AR_SREV_9280_20_OR_LATER(ah))
+		rs->rs_flags |=
+			(ads.ds_rxstatus3 & AR_RXST_STBC) ? ATH9K_RX_STBC : 0;
 
 	if (ads.ds_rxstatus8 & AR_PreDelimCRCErr)
 		rs->rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 5865f92..8ea9566 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -142,7 +142,7 @@ struct ath_rx_status {
 	u8 rs_isaggr;
 	u8 rs_moreaggr;
 	u8 rs_num_delims;
-	u8 rs_flags;
+	u16 rs_flags;
 	bool is_mybeacon;
 	u32 evm0;
 	u32 evm1;
@@ -185,13 +185,16 @@ struct ath_htc_rx_status {
 #define ATH9K_RXERR_KEYMISS       0x20
 #define ATH9K_RXERR_CORRUPT_DESC  0x40
 
-#define ATH9K_RX_MORE             0x01
-#define ATH9K_RX_MORE_AGGR        0x02
-#define ATH9K_RX_GI               0x04
-#define ATH9K_RX_2040             0x08
-#define ATH9K_RX_DELIM_CRC_PRE    0x10
-#define ATH9K_RX_DELIM_CRC_POST   0x20
-#define ATH9K_RX_DECRYPT_BUSY     0x40
+/* rs_flags */
+#define ATH9K_RX_MORE             0x0001
+#define ATH9K_RX_MORE_AGGR        0x0002
+#define ATH9K_RX_GI               0x0004
+#define ATH9K_RX_2040             0x0008
+#define ATH9K_RX_DELIM_CRC_PRE    0x0010
+#define ATH9K_RX_DELIM_CRC_POST   0x0020
+#define ATH9K_RX_DECRYPT_BUSY     0x0040
+#define ATH9K_RX_DUP              0x0080
+#define ATH9K_RX_STBC             0x0100
 
 #define ATH9K_RXKEYIX_INVALID	((u8)-1)
 #define ATH9K_TXKEYIX_INVALID	((u8)-1)
@@ -529,11 +532,12 @@ struct ar5416_desc {
 
 #define AR_RcvTimestamp     ds_rxstatus2
 
+/* rxstatus3 */
 #define AR_GI               0x00000001
 #define AR_2040             0x00000002
-#define AR_Parallel40       0x00000004
-#define AR_Parallel40_S     2
-#define AR_RxStatusRsvd30   0x000000f8
+#define AR_RXST_DUP         0x00000004 /* duplicate packets */
+#define AR_RXST_STBC        0x00000008 /* ar9280 and later */
+#define AR_RxStatusRsvd30   0x000000f0
 #define AR_RxAntenna	    0xffffff00
 #define AR_RxAntenna_S	    8
 
-- 
1.8.1.2

