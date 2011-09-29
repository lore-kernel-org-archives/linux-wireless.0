Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2019 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab1I2We6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 21/25] staging: brcm80211: use endian annotated
 structures in brcmsmac
Date: Thu, 29 Sep 2011 15:34:32 -0700
Message-ID: <1317335676-3424-22-git-send-email-frankyl@broadcom.com> (sfid-20110930_003526_131234_22A63BD5)
In-Reply-To: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Structures interfacing with the device have a specific endianess and
structures exchanged between host and device have been annotated so
sparse checking can be done. The Makefile has been modified to add
the __CHECK_ENDIAN__ flag.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile       |    3 +-
 drivers/staging/brcm80211/brcmsmac/d11.h          |   77 +++++++++++--------
 drivers/staging/brcm80211/brcmsmac/dma.c          |   41 +++++-----
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |   12 ++--
 drivers/staging/brcm80211/brcmsmac/main.c         |   86 +++++++++++----------
 drivers/staging/brcm80211/brcmsmac/srom.c         |    4 +-
 drivers/staging/brcm80211/brcmsmac/ucode_loader.h |    8 +-
 7 files changed, 126 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 8fdca2e..e44859d 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -15,7 +15,8 @@
 # OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
-ccflags-y :=				\
+ccflags-y := \
+	-D__CHECK_ENDIAN__ \
 	-Idrivers/staging/brcm80211/brcmsmac \
 	-Idrivers/staging/brcm80211/brcmsmac/phy \
 	-Idrivers/staging/brcm80211/include
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index cbb574a..1f05e8a 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -745,37 +745,37 @@ struct cck_phy_hdr {
 
 /* TX DMA buffer header */
 struct d11txh {
-	u16 MacTxControlLow;	/* 0x0 */
-	u16 MacTxControlHigh;	/* 0x1 */
-	u16 MacFrameControl;	/* 0x2 */
-	u16 TxFesTimeNormal;	/* 0x3 */
-	u16 PhyTxControlWord;	/* 0x4 */
-	u16 PhyTxControlWord_1;	/* 0x5 */
-	u16 PhyTxControlWord_1_Fbr;	/* 0x6 */
-	u16 PhyTxControlWord_1_Rts;	/* 0x7 */
-	u16 PhyTxControlWord_1_FbrRts;	/* 0x8 */
-	u16 MainRates;	/* 0x9 */
-	u16 XtraFrameTypes;	/* 0xa */
+	__le16 MacTxControlLow;	/* 0x0 */
+	__le16 MacTxControlHigh;	/* 0x1 */
+	__le16 MacFrameControl;	/* 0x2 */
+	__le16 TxFesTimeNormal;	/* 0x3 */
+	__le16 PhyTxControlWord;	/* 0x4 */
+	__le16 PhyTxControlWord_1;	/* 0x5 */
+	__le16 PhyTxControlWord_1_Fbr;	/* 0x6 */
+	__le16 PhyTxControlWord_1_Rts;	/* 0x7 */
+	__le16 PhyTxControlWord_1_FbrRts;	/* 0x8 */
+	__le16 MainRates;	/* 0x9 */
+	__le16 XtraFrameTypes;	/* 0xa */
 	u8 IV[16];		/* 0x0b - 0x12 */
 	u8 TxFrameRA[6];	/* 0x13 - 0x15 */
-	u16 TxFesTimeFallback;	/* 0x16 */
+	__le16 TxFesTimeFallback;	/* 0x16 */
 	u8 RTSPLCPFallback[6];	/* 0x17 - 0x19 */
-	u16 RTSDurFallback;	/* 0x1a */
+	__le16 RTSDurFallback;	/* 0x1a */
 	u8 FragPLCPFallback[6];	/* 0x1b - 1d */
-	u16 FragDurFallback;	/* 0x1e */
-	u16 MModeLen;	/* 0x1f */
-	u16 MModeFbrLen;	/* 0x20 */
-	u16 TstampLow;	/* 0x21 */
-	u16 TstampHigh;	/* 0x22 */
-	u16 ABI_MimoAntSel;	/* 0x23 */
-	u16 PreloadSize;	/* 0x24 */
-	u16 AmpduSeqCtl;	/* 0x25 */
-	u16 TxFrameID;	/* 0x26 */
-	u16 TxStatus;	/* 0x27 */
-	u16 MaxNMpdus;	/* 0x28 */
-	u16 MaxABytes_MRT;	/* 0x29 */
-	u16 MaxABytes_FBR;	/* 0x2a */
-	u16 MinMBytes;	/* 0x2b */
+	__le16 FragDurFallback;	/* 0x1e */
+	__le16 MModeLen;	/* 0x1f */
+	__le16 MModeFbrLen;	/* 0x20 */
+	__le16 TstampLow;	/* 0x21 */
+	__le16 TstampHigh;	/* 0x22 */
+	__le16 ABI_MimoAntSel;	/* 0x23 */
+	__le16 PreloadSize;	/* 0x24 */
+	__le16 AmpduSeqCtl;	/* 0x25 */
+	__le16 TxFrameID;	/* 0x26 */
+	__le16 TxStatus;	/* 0x27 */
+	__le16 MaxNMpdus;	/* 0x28 */
+	__le16 MaxABytes_MRT;	/* 0x29 */
+	__le16 MaxABytes_FBR;	/* 0x2a */
+	__le16 MinMBytes;	/* 0x2b */
 	u8 RTSPhyHeader[D11_PHY_HDR_LEN];	/* 0x2c - 0x2e */
 	struct ieee80211_rts rts_frame;	/* 0x2f - 0x36 */
 	u16 PAD;		/* 0x37 */
@@ -1379,6 +1379,21 @@ struct shm_acparams {
  * RxTSFTime: RxTSFTime time of first MAC symbol + M_PHY_PLCPRX_DLY
  * RxChan: gain code, channel radio code, and phy type
  */
+struct d11rxhdr_le {
+	__le16 RxFrameSize;
+	u16 PAD;
+	__le16 PhyRxStatus_0;
+	__le16 PhyRxStatus_1;
+	__le16 PhyRxStatus_2;
+	__le16 PhyRxStatus_3;
+	__le16 PhyRxStatus_4;
+	__le16 PhyRxStatus_5;
+	__le16 RxStatus1;
+	__le16 RxStatus2;
+	__le16 RxTSFTime;
+	__le16 RxChan;
+} __packed;
+
 struct d11rxhdr {
 	u16 RxFrameSize;
 	u16 PAD;
@@ -1392,20 +1407,18 @@ struct d11rxhdr {
 	u16 RxStatus2;
 	u16 RxTSFTime;
 	u16 RxChan;
-} __packed;
+};
 
 /*
  * rxhdr: received frame header data
- * tsf_l: TSF_L reading
- * rssi: computed instanteneous rssi in BMAC
+ * rssi: rssi computed by PHY
  * rxpwr0: obsoleted, place holder for legacy ROM code. use rxpwr[]
  * rxpwr1: obsoleted, place holder for legacy ROM code. use rxpwr[]
  * do_rssi_ma: do per-pkt sampling for per-antenna ma in HIGH
  * rxpwr: rssi for supported antennas
  */
 struct brcms_d11rxhdr {
-	struct d11rxhdr rxhdr;
-	u32 tsf_l;
+	struct d11rxhdr rxh_cpu;
 	s8 rssi;
 	s8 rxpwr0;
 	s8 rxpwr1;
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 714c74c..ef856ce 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -206,10 +206,10 @@
  * Descriptors are only read by the hardware, never written back.
  */
 struct dma64desc {
-	u32 ctrl1;	/* misc control bits & bufcount */
-	u32 ctrl2;	/* buffer count and address extension */
-	u32 addrlow;	/* memory address of the date buffer, bits 31:0 */
-	u32 addrhigh;	/* memory address of the date buffer, bits 63:32 */
+	__le32 ctrl1;	/* misc control bits & bufcount */
+	__le32 ctrl2;	/* buffer count and address extension */
+	__le32 addrlow;	/* memory address of the date buffer, bits 31:0 */
+	__le32 addrhigh; /* memory address of the date buffer, bits 63:32 */
 };
 
 /* dma engine software state */
@@ -295,15 +295,18 @@ struct dma_info {
 static uint dma_msg_level;
 
 /* Check for odd number of 1's */
-static u32 parity32(u32 data)
+static u32 parity32(__le32 data)
 {
-	data ^= data >> 16;
-	data ^= data >> 8;
-	data ^= data >> 4;
-	data ^= data >> 2;
-	data ^= data >> 1;
+	/* no swap needed for counting 1's */
+	u32 par_data = *(u32 *)&data;
 
-	return data & 1;
+	par_data ^= par_data >> 16;
+	par_data ^= par_data >> 8;
+	par_data ^= par_data >> 4;
+	par_data ^= par_data >> 2;
+	par_data ^= par_data >> 1;
+
+	return par_data & 1;
 }
 
 static bool dma64_dd_parity(struct dma64desc *dd)
@@ -873,13 +876,13 @@ static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 	rxp = di->rxp[i];
 	di->rxp[i] = NULL;
 
-	pa = cpu_to_le32(di->rxd64[i].addrlow) - di->dataoffsetlow;
+	pa = le32_to_cpu(di->rxd64[i].addrlow) - di->dataoffsetlow;
 
 	/* clear this packet from the descriptor ring */
 	pci_unmap_single(di->pbus, pa, di->rxbufsize, PCI_DMA_FROMDEVICE);
 
-	di->rxd64[i].addrlow = 0xdeadbeef;
-	di->rxd64[i].addrhigh = 0xdeadbeef;
+	di->rxd64[i].addrlow = cpu_to_le32(0xdeadbeef);
+	di->rxd64[i].addrhigh = cpu_to_le32(0xdeadbeef);
 
 	di->rxin = nextrxd(di, i);
 
@@ -917,7 +920,7 @@ struct sk_buff *dma_rx(struct dma_pub *pub)
 	if (head == NULL)
 		return NULL;
 
-	len = le16_to_cpu(*(u16 *) (head->data));
+	len = le16_to_cpu(*(__le16 *) (head->data));
 	DMA_TRACE(("%s: dma_rx len %d\n", di->name, len));
 	dma_spin_for_len(len, head);
 
@@ -1367,14 +1370,14 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 		dma_addr_t pa;
 		uint size;
 
-		pa = cpu_to_le32(di->txd64[i].addrlow) - di->dataoffsetlow;
+		pa = le32_to_cpu(di->txd64[i].addrlow) - di->dataoffsetlow;
 
 		size =
-		    (cpu_to_le32(di->txd64[i].ctrl2) &
+		    (le32_to_cpu(di->txd64[i].ctrl2) &
 		     D64_CTRL2_BC_MASK);
 
-		di->txd64[i].addrlow = 0xdeadbeef;
-		di->txd64[i].addrhigh = 0xdeadbeef;
+		di->txd64[i].addrlow = cpu_to_le32(0xdeadbeef);
+		di->txd64[i].addrhigh = cpu_to_le32(0xdeadbeef);
 
 		txp = di->txp[i];
 		di->txp[i] = NULL;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 1c45687..1fa95d7 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -89,9 +89,9 @@
 }
 
 struct firmware_hdr {
-	u32 offset;
-	u32 len;
-	u32 idx;
+	__le32 offset;
+	__le32 len;
+	__le32 idx;
 };
 
 static const char * const brcms_firmwares[MAX_FW_IMAGES] = {
@@ -243,7 +243,7 @@ static const struct ieee80211_supported_band brcms_band_2GHz_nphy_template = {
 		   .mcs = {
 			   /* placeholders for now */
 			   .rx_mask = {0xff, 0xff, 0, 0, 0, 0, 0, 0, 0, 0},
-			   .rx_highest = 500,
+			   .rx_highest = cpu_to_le16(500),
 			   .tx_params = IEEE80211_HT_MCS_TX_DEFINED}
 		   }
 };
@@ -265,7 +265,7 @@ static const struct ieee80211_supported_band brcms_band_5GHz_nphy_template = {
 		   .mcs = {
 			   /* placeholders for now */
 			   .rx_mask = {0xff, 0xff, 0, 0, 0, 0, 0, 0, 0, 0},
-			   .rx_highest = 500,
+			   .rx_highest = cpu_to_le16(500),
 			   .tx_params = IEEE80211_HT_MCS_TX_DEFINED}
 		   }
 };
@@ -1625,7 +1625,7 @@ int brcms_ucode_init_uint(struct brcms_info *wl, u32 *data, u32 idx)
 						  "ERROR: fw hdr len\n");
 					return -ENOMSG;
 				}
-				*data = le32_to_cpu(*((u32 *) pdata));
+				*data = le32_to_cpu(*((__le32 *) pdata));
 				return 0;
 			}
 		}
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 1a7d005..3e39407 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -338,9 +338,9 @@ static u16 frametype(u32 rspec, u8 mimoframe)
 #define XMTFIFOTBL_STARTREV	20
 
 struct d11init {
-	u16 addr;
-	u16 size;
-	u32 value;
+	__le16 addr;
+	__le16 size;
+	__le32 value;
 };
 
 /* currently the best mechanism for determining SIFS is the band in use */
@@ -666,7 +666,7 @@ static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 
 	base = (u8 *)wlc_hw->regs;
 
-	for (i = 0; inits[i].addr != 0xffff; i++) {
+	for (i = 0; inits[i].addr != cpu_to_le16(0xffff); i++) {
 		size = le16_to_cpu(inits[i].size);
 		addr = base + le16_to_cpu(inits[i].addr);
 		value = le32_to_cpu(inits[i].value);
@@ -806,30 +806,33 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 
 	/* process each frame */
 	while ((p = head) != NULL) {
+		struct d11rxhdr_le *rxh_le;
 		struct d11rxhdr *rxh;
 		head = head->prev;
 		p->prev = NULL;
 
-		wlc_rxhdr = (struct brcms_d11rxhdr *) p->data;
+		rxh_le = (struct d11rxhdr_le *)p->data;
 		rxh = (struct d11rxhdr *)p->data;
+		wlc_rxhdr = (struct brcms_d11rxhdr *) p->data;
 
 		/* fixup rx header endianness */
-		rxh->RxFrameSize = le16_to_cpu(rxh->RxFrameSize);
-		rxh->PhyRxStatus_0 = le16_to_cpu(rxh->PhyRxStatus_0);
-		rxh->PhyRxStatus_1 = le16_to_cpu(rxh->PhyRxStatus_1);
-		rxh->PhyRxStatus_2 = le16_to_cpu(rxh->PhyRxStatus_2);
-		rxh->PhyRxStatus_3 = le16_to_cpu(rxh->PhyRxStatus_3);
-		rxh->PhyRxStatus_4 = le16_to_cpu(rxh->PhyRxStatus_4);
-		rxh->PhyRxStatus_5 = le16_to_cpu(rxh->PhyRxStatus_5);
-		rxh->RxStatus1 = le16_to_cpu(rxh->RxStatus1);
-		rxh->RxStatus2 = le16_to_cpu(rxh->RxStatus2);
-		rxh->RxTSFTime = le16_to_cpu(rxh->RxTSFTime);
-		rxh->RxChan = le16_to_cpu(rxh->RxChan);
+		rxh->RxFrameSize = le16_to_cpu(rxh_le->RxFrameSize);
+		rxh->PhyRxStatus_0 = le16_to_cpu(rxh_le->PhyRxStatus_0);
+		rxh->PhyRxStatus_1 = le16_to_cpu(rxh_le->PhyRxStatus_1);
+		rxh->PhyRxStatus_2 = le16_to_cpu(rxh_le->PhyRxStatus_2);
+		rxh->PhyRxStatus_3 = le16_to_cpu(rxh_le->PhyRxStatus_3);
+		rxh->PhyRxStatus_4 = le16_to_cpu(rxh_le->PhyRxStatus_4);
+		rxh->PhyRxStatus_5 = le16_to_cpu(rxh_le->PhyRxStatus_5);
+		rxh->RxStatus1 = le16_to_cpu(rxh_le->RxStatus1);
+		rxh->RxStatus2 = le16_to_cpu(rxh_le->RxStatus2);
+		rxh->RxTSFTime = le16_to_cpu(rxh_le->RxTSFTime);
+		rxh->RxChan = le16_to_cpu(rxh_le->RxChan);
 
 		/*
 		 * compute the RSSI from d11rxhdr and record it in wlc_rxd11hr
 		 */
-		wlc_rxhdr->rssi = wlc_phy_rssi_compute(wlc_hw->band->pi, rxh);
+		wlc_rxhdr->rssi = (s8)wlc_phy_rssi_compute(wlc_hw->band->pi,
+							   rxh);
 		brcms_c_recv(wlc_hw->wlc, p);
 	}
 
@@ -888,7 +891,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 		brcms_c_print_txstatus(txs);
 	}
 
-	if (txs->frameid != cpu_to_le16(txh->TxFrameID))
+	if (txs->frameid != le16_to_cpu(txh->TxFrameID))
 		goto fatal;
 	tx_info = IEEE80211_SKB_CB(p);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
@@ -907,7 +910,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 		       "%s: Pkt tx suppressed, possibly channel %d\n",
 		       __func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec));
 
-	tx_rts = cpu_to_le16(txh->MacTxControlLow) & TXC_SENDRTS;
+	tx_rts = le16_to_cpu(txh->MacTxControlLow) & TXC_SENDRTS;
 	tx_frame_count =
 	    (txs->status & TX_STATUS_FRM_RTX_MASK) >> TX_STATUS_FRM_RTX_SHIFT;
 	tx_rts_count =
@@ -1676,6 +1679,8 @@ brcms_b_write_template_ram(struct brcms_hardware *wlc_hw, int offset, int len,
 {
 	struct d11regs *regs;
 	u32 word;
+	__le32 word_le;
+	__be32 word_be;
 	bool be_bit;
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1691,10 +1696,13 @@ brcms_b_write_template_ram(struct brcms_hardware *wlc_hw, int offset, int len,
 	while (len > 0) {
 		memcpy(&word, buf, sizeof(u32));
 
-		if (be_bit)
-			word = cpu_to_be32(word);
-		else
-			word = cpu_to_le32(word);
+		if (be_bit) {
+			word_be = cpu_to_be32(word);
+			word = *(u32 *)&word_be;
+		} else {
+			word_le = cpu_to_le32(word);
+			word = *(u32 *)&word_le;
+		}
 
 		W_REG(&regs->tplatewrdata, word);
 
@@ -2437,8 +2445,9 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 	ai_gpiocontrol(wlc_hw->sih, gm, gc, GPIO_DRV_PRIORITY);
 }
 
-static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
-			      const uint nbytes) {
+static void brcms_ucode_write(struct brcms_hardware *wlc_hw,
+			      const __le32 ucode[], const size_t nbytes)
+{
 	struct d11regs *regs = wlc_hw->regs;
 	uint i;
 	uint count;
@@ -4260,7 +4269,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 	do {
 		memset((char *)&acp_shm, 0, sizeof(struct shm_acparams));
 		/* fill in shm ac params struct */
-		acp_shm.txop = le16_to_cpu(params->txop);
+		acp_shm.txop = params->txop;
 		/* convert from units of 32us to us for ucode */
 		wlc->edcf_txop[aci & 0x3] = acp_shm.txop =
 		    EDCF_TXOP2USEC(acp_shm.txop);
@@ -4313,16 +4322,11 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 	u16 aci;
 	int i_ac;
 	struct ieee80211_tx_queue_params txq_pars;
-	struct ieee80211_tx_queue_params *params = &txq_pars;
 	static const struct edcf_acparam default_edcf_acparams[] = {
-		 {EDCF_AC_BE_ACI_STA, EDCF_AC_BE_ECW_STA,
-		  cpu_to_le16(EDCF_AC_BE_TXOP_STA)},
-		 {EDCF_AC_BK_ACI_STA, EDCF_AC_BK_ECW_STA,
-		  cpu_to_le16(EDCF_AC_BK_TXOP_STA)},
-		 {EDCF_AC_VI_ACI_STA, EDCF_AC_VI_ECW_STA,
-		  cpu_to_le16(EDCF_AC_VI_TXOP_STA)},
-		 {EDCF_AC_VO_ACI_STA, EDCF_AC_VO_ECW_STA,
-		  cpu_to_le16(EDCF_AC_VO_TXOP_STA)}
+		 {EDCF_AC_BE_ACI_STA, EDCF_AC_BE_ECW_STA, EDCF_AC_BE_TXOP_STA},
+		 {EDCF_AC_BK_ACI_STA, EDCF_AC_BK_ECW_STA, EDCF_AC_BK_TXOP_STA},
+		 {EDCF_AC_VI_ACI_STA, EDCF_AC_VI_ECW_STA, EDCF_AC_VI_TXOP_STA},
+		 {EDCF_AC_VO_ACI_STA, EDCF_AC_VO_ECW_STA, EDCF_AC_VO_TXOP_STA}
 	}; /* ucode needs these parameters during its initialization */
 	const struct edcf_acparam *edcf_acp = &default_edcf_acparams[0];
 
@@ -4331,15 +4335,15 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 		aci = (edcf_acp->ACI & EDCF_ACI_MASK) >> EDCF_ACI_SHIFT;
 
 		/* fill in shm ac params struct */
-		params->txop = edcf_acp->TXOP;
-		params->aifs = edcf_acp->ACI;
+		txq_pars.txop = edcf_acp->TXOP;
+		txq_pars.aifs = edcf_acp->ACI;
 
 		/* CWmin = 2^(ECWmin) - 1 */
-		params->cw_min = EDCF_ECW2CW(edcf_acp->ECW & EDCF_ECWMIN_MASK);
+		txq_pars.cw_min = EDCF_ECW2CW(edcf_acp->ECW & EDCF_ECWMIN_MASK);
 		/* CWmax = 2^(ECWmax) - 1 */
-		params->cw_max = EDCF_ECW2CW((edcf_acp->ECW & EDCF_ECWMAX_MASK)
+		txq_pars.cw_max = EDCF_ECW2CW((edcf_acp->ECW & EDCF_ECWMAX_MASK)
 					    >> EDCF_ECWMAX_SHIFT);
-		brcms_c_wme_setparams(wlc, aci, params, suspend);
+		brcms_c_wme_setparams(wlc, aci, &txq_pars, suspend);
 	}
 
 	if (suspend)
@@ -8126,7 +8130,7 @@ static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
 	brcms_b_read_tsf(wlc->hw, &tsf_l, &tsf_h);
 
 	rx_tsf_16_31 = (u16)(tsf_l >> 16);
-	rx_tsf_0_15 = rxh->rxhdr.RxTSFTime;
+	rx_tsf_0_15 = rxh->rxh_cpu.RxTSFTime;
 
 	/*
 	 * a greater tsf time indicates the low 16 bits of
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index ce31959..0105306 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -822,14 +822,14 @@ static inline void ltoh16_buf(u16 *buf, unsigned int size)
 {
 	size /= 2;
 	while (size--)
-		*(buf + size) = le16_to_cpu(*(buf + size));
+		*(buf + size) = le16_to_cpu(*(__le16 *)(buf + size));
 }
 
 static inline void htol16_buf(u16 *buf, unsigned int size)
 {
 	size /= 2;
 	while (size--)
-		*(buf + size) = cpu_to_le16(*(buf + size));
+		*(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
 }
 
 /* Initialization of varbuf structure */
diff --git a/drivers/staging/brcm80211/brcmsmac/ucode_loader.h b/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
index 438675a..49d5b7e 100644
--- a/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
+++ b/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
@@ -35,10 +35,10 @@ struct brcms_ucode {
 	struct d11init *d11n0absinitvals16;
 	struct d11init *d11n0bsinitvals16;
 	struct d11init *d11n0initvals16;
-	u32 *bcm43xx_16_mimo;
-	u32 bcm43xx_16_mimosz;
-	u32 *bcm43xx_24_lcn;
-	u32 bcm43xx_24_lcnsz;
+	__le32 *bcm43xx_16_mimo;
+	size_t bcm43xx_16_mimosz;
+	__le32 *bcm43xx_24_lcn;
+	size_t bcm43xx_24_lcnsz;
 	u32 *bcm43xx_bommajor;
 	u32 *bcm43xx_bomminor;
 };
-- 
1.7.1


