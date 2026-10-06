Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E2645C6F6
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 13:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791292046; cv=none; b=lifmfK40RwGMdC1MyAUKlx559hKNc4pw1MTA/6PKpYe3wheVDMUN606vsGgwXR47h/lg5JUWU3TRmSs3reCp8cQ0p8AagbAaBdBfkSSI6G6w+qr/93Eb+slCGZOvh1U2EiKPk7PMr4nZGo7UfUT79ZSuLTzKWSIQhQHkTD5cfmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791292046; c=relaxed/simple;
	bh=gXFTUY5EleGj19niqXAHP97huAcyAjf4cpDHqJ38rwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiOtShzgAQXJzChnc4UmdHZge4knlq8B6y4AdVbzUXxtZveHVYUyzrWvUBzbtRqfxEi7ustJvXxN6o6n3Mt1IfrMjdNSxomi13V543PxBWDg5d5rYgdmV+zgpwnKiH7cFTp8n6qbSF3rVA3B1Gpy4ydJv3NwJI4s/TcUWuJvbkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gMYFu/HC; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gMYFu/HC"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gXFTUY5EleGj19niqXAHP97huAcyAjf4cpDHqJ38rwo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791292041; v=1; x=1791896841;
 b=gMYFu/HCUhSexqdcle5TA62/NLOWiZh6OhtPxsHdAgyzxytFBsPZiTI44OGi4sweNA3YLw4O
 8WsmYNpK1Sr/huEN8muRcfTJcbmIgJYzOJTzt6SJUHXHWwQVkxMJpm8di2qcXL/16qg1QxYPp3Q
 rqhGNxnO7iSgsA8GKzp5IIDI=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5b2f4d58ac618a56;
	Tue, 06 Oct 2026 13:07:21 +0000
X-Mizu-Trace-ID: 5b2f4d58ac618a56
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v8 4/7] wifi: rtw88: move the shared 8723x definitions to rtw8723x.h
Date: Tue,  6 Oct 2026 15:06:58 +0200
Message-ID: <20261006130701.120460-5-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006130701.120460-1-luka.gejak@linux.dev>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RTL8723B driver needs the receive PHY status layout, the SDIO
aggregation burst fields and four baseband registers, which currently
live in rtw8703b.h. Move them to rtw8723x.h, the header for the
definitions shared within the family, and rename struct phy_status_8703b
to struct phy_status_8723x. The layout is called phy_status_rpt_8192cd in
the vendor driver. This is not a logical change.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/rtw8703b.c |  4 +-
 drivers/net/wireless/realtek/rtw88/rtw8703b.h | 63 -------------------
 drivers/net/wireless/realtek/rtw88/rtw8723x.h | 60 ++++++++++++++++++
 3 files changed, 62 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8703b.c b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
index 42cfc8e62db8..25456f0367b2 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8703b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
@@ -930,7 +930,7 @@ static s8 get_cck_rx_pwr(struct rtw_dev *rtwdev, u8 lna_idx, u8 vga_idx)
 static void query_phy_status_cck(struct rtw_dev *rtwdev, u8 *phy_raw,
 				 struct rtw_rx_pkt_stat *pkt_stat)
 {
-	struct phy_status_8703b *phy_status = (struct phy_status_8703b *)phy_raw;
+	struct phy_status_8723x *phy_status = (struct phy_status_8723x *)phy_raw;
 	u8 vga_idx = phy_status->cck_agc_rpt_ofdm_cfosho_a & VGA_BITS;
 	u8 lna_idx = phy_status->cck_agc_rpt_ofdm_cfosho_a & LNA_L_BITS;
 	s8 rx_power;
@@ -952,7 +952,7 @@ static void query_phy_status_cck(struct rtw_dev *rtwdev, u8 *phy_raw,
 static void query_phy_status_ofdm(struct rtw_dev *rtwdev, u8 *phy_raw,
 				  struct rtw_rx_pkt_stat *pkt_stat)
 {
-	struct phy_status_8703b *phy_status = (struct phy_status_8703b *)phy_raw;
+	struct phy_status_8723x *phy_status = (struct phy_status_8723x *)phy_raw;
 	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
 	s8 val_s8;
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8703b.h b/drivers/net/wireless/realtek/rtw88/rtw8703b.h
index 3e2da2e6739d..51e9038e7c1e 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8703b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.h
@@ -16,62 +16,7 @@ extern const struct rtw_chip_info rtw8703b_hw_spec;
 #define BIT_LNA_H_MASK BIT(3)
 #define BIT_LNA_L_MASK GENMASK(2, 0)
 
-struct phy_rx_agc_info {
-#ifdef __LITTLE_ENDIAN
-	u8 gain: 7;
-	u8 trsw: 1;
-#else
-	u8 trsw: 1;
-	u8 gain: 7;
-#endif
-} __packed;
-
-/* This struct is called phy_status_rpt_8192cd in the vendor driver,
- * there might be potential to share it with drivers for other chips
- * of the same generation.
- */
-struct phy_status_8703b {
-	struct phy_rx_agc_info path_agc[2];
-	u8 ch_corr[2];
-	u8 cck_sig_qual_ofdm_pwdb_all;
-	/* for CCK: bits 0:4: VGA index, bits 5:7: LNA index (low) */
-	u8 cck_agc_rpt_ofdm_cfosho_a;
-	/* for CCK: bit 7 is high bit of LNA index if long report type */
-	u8 cck_rpt_b_ofdm_cfosho_b;
-	u8 reserved_1;
-	u8 noise_power_db_msb;
-	s8 path_cfotail[2];
-	u8 pcts_mask[2];
-	s8 stream_rxevm[2];
-	u8 path_rxsnr[2];
-	u8 noise_power_db_lsb;
-	u8 reserved_2[3];
-	u8 stream_csi[2];
-	u8 stream_target_csi[2];
-	s8 sig_evm;
-	u8 reserved_3;
-
-#ifdef __LITTLE_ENDIAN
-	u8 antsel_rx_keep_2: 1;
-	u8 sgi_en: 1;
-	u8 rxsc: 2;
-	u8 idle_long: 1;
-	u8 r_ant_train_en: 1;
-	u8 ant_sel_b: 1;
-	u8 ant_sel: 1;
-#else /* __BIG_ENDIAN */
-	u8 ant_sel: 1;
-	u8 ant_sel_b: 1;
-	u8 r_ant_train_en: 1;
-	u8 idle_long: 1;
-	u8 rxsc: 2;
-	u8 sgi_en: 1;
-	u8 antsel_rx_keep_2: 1;
-#endif
-} __packed;
-
 /* Baseband registers */
-#define REG_BB_PWR_SAV5_11N 0x0818
 /* BIT(11) should be 1 for 8703B *and* 8723D, which means LNA uses 4
  * bit for CCK rates in report, not 3. Vendor driver logs a warning if
  * it's 0, but handles the case.
@@ -87,16 +32,8 @@ struct phy_status_8703b {
 #define REG_CCK_TXSF2 0x0a24  /* CCK TX filter 2 */
 #define REG_CCK_DBG 0x0a28  /* debug port */
 #define REG_OFDM0_A_TX_AFE 0x0c84
-#define REG_TXIQK_MATRIXB_LSB2_11N 0x0c9c
-#define REG_OFDM0_TX_PSD_NOISE 0x0ce4  /* TX pseudo noise weighting */
-#define REG_IQK_RDY 0x0e90  /* is != 0 when IQK is done */
 
 /* RF registers */
 #define RF_RCK1 0x1E
 
-#define AGG_BURST_NUM 3
-#define AGG_BURST_SIZE 0 /* 1K */
-#define BIT_MASK_AGG_BURST_NUM (GENMASK(3, 2))
-#define BIT_MASK_AGG_BURST_SIZE (GENMASK(5, 4))
-
 #endif /* __RTW8703B_H__ */
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723x.h b/drivers/net/wireless/realtek/rtw88/rtw8723x.h
index 0fc70dfdfc8b..e07b6ca99b3d 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723x.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723x.h
@@ -162,6 +162,57 @@ struct rtw8723x_common {
 
 extern const struct rtw8723x_common rtw8723x_common;
 
+struct phy_rx_agc_info {
+#ifdef __LITTLE_ENDIAN
+	u8 gain: 7;
+	u8 trsw: 1;
+#else
+	u8 trsw: 1;
+	u8 gain: 7;
+#endif
+} __packed;
+
+/* Receive PHY status layout, shared by the 8723x chips. */
+struct phy_status_8723x {
+	struct phy_rx_agc_info path_agc[2];
+	u8 ch_corr[2];
+	u8 cck_sig_qual_ofdm_pwdb_all;
+	/* for CCK: bits 0:4: VGA index, bits 5:7: LNA index (low) */
+	u8 cck_agc_rpt_ofdm_cfosho_a;
+	/* for CCK: bit 7 is high bit of LNA index if long report type */
+	u8 cck_rpt_b_ofdm_cfosho_b;
+	u8 reserved_1;
+	u8 noise_power_db_msb;
+	s8 path_cfotail[2];
+	u8 pcts_mask[2];
+	s8 stream_rxevm[2];
+	u8 path_rxsnr[2];
+	u8 noise_power_db_lsb;
+	u8 reserved_2[3];
+	u8 stream_csi[2];
+	u8 stream_target_csi[2];
+	s8 sig_evm;
+	u8 reserved_3;
+
+#ifdef __LITTLE_ENDIAN
+	u8 antsel_rx_keep_2: 1;
+	u8 sgi_en: 1;
+	u8 rxsc: 2;
+	u8 idle_long: 1;
+	u8 r_ant_train_en: 1;
+	u8 ant_sel_b: 1;
+	u8 ant_sel: 1;
+#else /* __BIG_ENDIAN */
+	u8 ant_sel: 1;
+	u8 ant_sel_b: 1;
+	u8 r_ant_train_en: 1;
+	u8 idle_long: 1;
+	u8 rxsc: 2;
+	u8 sgi_en: 1;
+	u8 antsel_rx_keep_2: 1;
+#endif
+} __packed;
+
 #define PATH_IQK_RETRY	2
 #define MAX_TOLERANCE	5
 #define IQK_TX_X_ERR	0x142
@@ -176,6 +227,11 @@ extern const struct rtw8723x_common rtw8723x_common;
 
 #define WLAN_TXQ_RPT_EN		0x1F
 
+#define AGG_BURST_NUM		3
+#define AGG_BURST_SIZE		0 /* 1K */
+#define BIT_MASK_AGG_BURST_NUM	(GENMASK(3, 2))
+#define BIT_MASK_AGG_BURST_SIZE	(GENMASK(5, 4))
+
 #define SPUR_THRES		0x16
 #define DIS_3WIRE		0xccf000c0
 #define EN_3WIRE		0xccc000c0
@@ -201,6 +257,7 @@ extern const struct rtw8723x_common rtw8723x_common;
 #define REG_LTECOEX_WRITE_DATA	0x07c4
 #define REG_LTECOEX_READ_DATA	0x07c8
 #define REG_PSDFN		0x0808
+#define REG_BB_PWR_SAV5_11N	0x0818
 #define REG_BB_PWR_SAV1_11N	0x0874
 #define REG_ANA_PARAM1		0x0880
 #define REG_ANALOG_P4		0x088c
@@ -261,6 +318,7 @@ extern const struct rtw8723x_common rtw8723x_common;
 #define BIT_MASK_TXIQ_ELM_D	GENMASK(31, 22)
 #define REG_TXIQK_MATRIXA_LSB2_11N	0x0c94
 #define BIT_SET_TXIQ_ELM_C1(c)	(((c) & 0x000003C0) >> 6)
+#define REG_TXIQK_MATRIXB_LSB2_11N	0x0c9c
 #define REG_RXIQK_MATRIX_LSB_11N	0x0ca0
 #define BIT_MASK_RXIQ_S1_Y2	0xF0000000
 #define BIT_SET_RXIQ_S1_Y2(y)	(((y) >> 6) & 0xF)
@@ -276,6 +334,7 @@ extern const struct rtw8723x_common rtw8723x_common;
 #define REG_RXIQ_AB_S0		0x0cd8
 #define BIT_MASK_RXIQ_X_S0	0x000003FF
 #define BIT_MASK_RXIQ_Y_S0	0x003FF000
+#define REG_OFDM0_TX_PSD_NOISE	0x0ce4	/* TX pseudo noise weighting */
 #define REG_OFDM_FA_TYPE1_11N	0x0cf0
 #define BIT_MASK_OFDM_FF_CNT	GENMASK(15, 0)
 #define BIT_MASK_OFDM_SF_CNT	GENMASK(31, 16)
@@ -315,6 +374,7 @@ extern const struct rtw8723x_common rtw8723x_common;
 #define REG_RX_IQK_TONE_B	0x0e54
 #define REG_TXIQK_PI_B		0x0e58
 #define REG_RXIQK_PI_B		0x0e5c
+#define REG_IQK_RDY		0x0e90	/* is != 0 when IQK is done */
 #define REG_IQK_RES_TX		0x0e94
 #define BIT_MASK_RES_TX		GENMASK(25, 16)
 #define REG_IQK_RES_TY		0x0e9c
-- 
2.55.0

