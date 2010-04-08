Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217Ab0DHT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:40 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 022/102] ath9k_hw: Add few routines for rx edma support
Date: Thu,  8 Apr 2010 15:26:18 -0400
Message-Id: <1270754858-26266-23-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

* Set rx buf size in register 0x60
* Set rxdp on the respective hw rx queue (HP and LP queues)
* Process rx descriptor

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   95 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |   25 ++++++-
 drivers/net/wireless/ath/ath9k/hw.c         |    6 ++-
 drivers/net/wireless/ath/ath9k/mac.h        |    3 +
 drivers/net/wireless/ath/ath9k/reg.h        |    6 ++
 5 files changed, 131 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index ee84e64..2089006 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -26,3 +26,98 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 
 	ops->rx_enable = ar9003_hw_rx_enable;
 }
+
+void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size)
+{
+	REG_WRITE(ah, AR_DATABUF_SIZE, buf_size & AR_DATABUF_SIZE_MASK);
+}
+EXPORT_SYMBOL(ath9k_hw_set_rx_bufsize);
+
+void ath9k_hw_addrxbuf_edma(struct ath_hw *ah, u32 rxdp,
+			    enum ath9k_rx_qtype qtype)
+{
+	if (qtype == ATH9K_RX_QUEUE_HP)
+		REG_WRITE(ah, AR_HP_RXDP, rxdp);
+	else
+		REG_WRITE(ah, AR_LP_RXDP, rxdp);
+}
+EXPORT_SYMBOL(ath9k_hw_addrxbuf_edma);
+
+int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
+				 void *buf_addr)
+{
+	struct ar9003_rxs *rxsp = (struct ar9003_rxs *) buf_addr;
+	unsigned int phyerr;
+
+	/* TODO: byte swap on big endian for ar9300_10 */
+
+	if ((rxsp->status11 & AR_RxDone) == 0)
+		return -EINPROGRESS;
+
+	if (MS(rxsp->ds_info, AR_DescId) != 0x168c)
+		return -EINVAL;
+
+	if ((rxsp->ds_info & (AR_TxRxDesc | AR_CtrlStat)) != 0)
+		return -EINPROGRESS;
+
+	rxs->rs_status = 0;
+	rxs->rs_flags =  0;
+
+	rxs->rs_datalen = rxsp->status2 & AR_DataLen;
+	rxs->rs_tstamp =  rxsp->status3;
+
+	/* XXX: Keycache */
+	rxs->rs_rssi = MS(rxsp->status5, AR_RxRSSICombined);
+	rxs->rs_rssi_ctl0 = MS(rxsp->status1, AR_RxRSSIAnt00);
+	rxs->rs_rssi_ctl1 = MS(rxsp->status1, AR_RxRSSIAnt01);
+	rxs->rs_rssi_ctl2 = MS(rxsp->status1, AR_RxRSSIAnt02);
+	rxs->rs_rssi_ext0 = MS(rxsp->status5, AR_RxRSSIAnt10);
+	rxs->rs_rssi_ext1 = MS(rxsp->status5, AR_RxRSSIAnt11);
+	rxs->rs_rssi_ext2 = MS(rxsp->status5, AR_RxRSSIAnt12);
+
+	if (rxsp->status11 & AR_RxKeyIdxValid)
+		rxs->rs_keyix = MS(rxsp->status11, AR_KeyIdx);
+	else
+		rxs->rs_keyix = ATH9K_RXKEYIX_INVALID;
+
+	rxs->rs_rate = MS(rxsp->status1, AR_RxRate);
+	rxs->rs_more = (rxsp->status2 & AR_RxMore) ? 1 : 0;
+
+	rxs->rs_isaggr = (rxsp->status11 & AR_RxAggr) ? 1 : 0;
+	rxs->rs_moreaggr = (rxsp->status11 & AR_RxMoreAggr) ? 1 : 0;
+	rxs->rs_antenna = (MS(rxsp->status4, AR_RxAntenna) & 0x7);
+	rxs->rs_flags  = (rxsp->status4 & AR_GI) ? ATH9K_RX_GI : 0;
+	rxs->rs_flags  |= (rxsp->status4 & AR_2040) ? ATH9K_RX_2040 : 0;
+
+	rxs->evm0 = rxsp->status6;
+	rxs->evm1 = rxsp->status7;
+	rxs->evm2 = rxsp->status8;
+	rxs->evm3 = rxsp->status9;
+	rxs->evm4 = (rxsp->status10 & 0xffff);
+
+	if (rxsp->status11 & AR_PreDelimCRCErr)
+		rxs->rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
+
+	if (rxsp->status11 & AR_PostDelimCRCErr)
+		rxs->rs_flags |= ATH9K_RX_DELIM_CRC_POST;
+
+	if (rxsp->status11 & AR_DecryptBusyErr)
+		rxs->rs_flags |= ATH9K_RX_DECRYPT_BUSY;
+
+	if ((rxsp->status11 & AR_RxFrameOK) == 0) {
+		if (rxsp->status11 & AR_CRCErr) {
+			rxs->rs_status |= ATH9K_RXERR_CRC;
+		} else if (rxsp->status11 & AR_PHYErr) {
+			rxs->rs_status |= ATH9K_RXERR_PHY;
+			phyerr = MS(rxsp->status11, AR_PHYErrCode);
+			rxs->rs_phyerr = phyerr;
+		} else if (rxsp->status11 & AR_DecryptCRCErr) {
+			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
+		} else if (rxsp->status11 & AR_MichaelErr) {
+			rxs->rs_status |= ATH9K_RXERR_MIC;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ath9k_hw_process_rxdesc_edma);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index a468c3d..68f0ebf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -14,10 +14,21 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef AR9003_MAC_H
-#define AR9003_MAC_H
+#ifndef ar9003_MAC_H
+#define ar9003_MAC_H
 
-struct ar9300_rxs {
+#define AR_DescId	0xffff0000
+#define AR_DescId_S	16
+#define AR_CtrlStat	0x00004000
+#define AR_TxRxDesc	0x00008000
+
+enum ath9k_rx_qtype {
+	ATH9K_RX_QUEUE_HP,
+	ATH9K_RX_QUEUE_LP,
+	ATH9K_RX_QUEUE_MAX,
+};
+
+struct ar9003_rxs {
 	u32 ds_info;
 	u32 status1;
 	u32 status2;
@@ -33,4 +44,12 @@ struct ar9300_rxs {
 } __packed;
 
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw);
+void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size);
+void ath9k_hw_addrxbuf_edma(struct ath_hw *ah, u32 rxdp,
+			    enum ath9k_rx_qtype qtype);
+
+int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah,
+				 struct ath_rx_status *rxs,
+				 void *buf_addr);
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6d2ec20..0e4a40c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2929,7 +2929,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		else
 			pCap->rx_lp_qdepth = ATH9K_HW_RX_LP_QDEPTH_AR9300_10;
 
-		pCap->rx_status_len = sizeof(struct ar9300_rxs);
+		pCap->rx_status_len = sizeof(struct ar9003_rxs);
 	}
 
 	return 0;
@@ -3613,6 +3613,8 @@ static void ar9002_hw_attach_ops(struct ath_hw *ah)
 	ar5008_hw_attach_phy_ops(ah);
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		ar9002_hw_attach_phy_ops(ah);
+
+	ar9002_hw_attach_mac_ops(ah);
 }
 
 /* Sets up the AR9003 hardware familiy callbacks */
@@ -3623,4 +3625,6 @@ static void ar9003_hw_attach_ops(struct ath_hw *ah)
 	priv_ops->macversion_supported = ar9003_hw_macversion_supported;
 
 	ar9003_hw_attach_phy_ops(ah);
+
+	ar9003_hw_attach_mac_ops(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index f34a976..126a403 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -148,6 +148,8 @@ struct ath_rx_status {
 	u32 evm0;
 	u32 evm1;
 	u32 evm2;
+	u32 evm3;
+	u32 evm4;
 };
 
 struct ath_htc_rx_status {
@@ -735,4 +737,5 @@ bool ath9k_hw_stopdmarecv(struct ath_hw *ah);
 int ath9k_hw_beaconq_setup(struct ath_hw *ah);
 
 void ar9002_hw_attach_mac_ops(struct ath_hw *ah);
+
 #endif /* MAC_H */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index d524891..bc48bc9 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -144,6 +144,9 @@
 #define AR_MACMISC_MISC_OBS_BUS_MSB_S   15
 #define AR_MACMISC_MISC_OBS_BUS_1       1
 
+#define AR_DATABUF_SIZE		0x0060
+#define AR_DATABUF_SIZE_MASK	0x00000FFF
+
 #define AR_GTXTO    0x0064
 #define AR_GTXTO_TIMEOUT_COUNTER    0x0000FFFF
 #define AR_GTXTO_TIMEOUT_LIMIT      0xFFFF0000
@@ -160,6 +163,9 @@
 #define AR_CST_TIMEOUT_LIMIT      0xFFFF0000
 #define AR_CST_TIMEOUT_LIMIT_S    16
 
+#define AR_HP_RXDP 0x0074
+#define AR_LP_RXDP 0x0078
+
 #define AR_ISR               0x0080
 #define AR_ISR_RXOK          0x00000001
 #define AR_ISR_RXDESC        0x00000002
-- 
1.6.3.3

