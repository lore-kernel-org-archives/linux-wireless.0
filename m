Received: from mta1.migadu.com (out-145.mta1.migadu.com [95.215.58.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192AD43D4E0
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 07:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926747; cv=none; b=uJZhjQPbct+u75SQMvi0R+321yAmCBMmv50U3sGFhcn28Ef7T25+3LQzP3GBhzF35pJ1GONX6Sph2kW42RnkuTqZ2HMsJgPxieEcWc2c76pCyDrn575qd0FBu67KtV9fOsWlU+bfTO8T4ojzvbf66rh2UqKDrDa8yvJWIgIEoUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926747; c=relaxed/simple;
	bh=J2XNiKbHwo+NoskCXkX/ICLGyx/2EEg8o+1tuZd1c7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoVC1y59ooXc+rBsuhiIJfDHXdrmdkVLDa+dWU/K6c2yADNvcZHt8bituMKB80RSBUy0i18Jd2kcr1dld0trHGJUdt1vbHzKc+Escg+IUbVHzhhNBUQuJ1Ben6TnLyBNppCbUqBTJ93e56hD2qThSIlptxE2bvOwf7SIhhp6mUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aLY+6VYL; arc=none smtp.client-ip=95.215.58.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aLY+6VYL"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=J2XNiKbHwo+NoskCXkX/ICLGyx/2EEg8o+1tuZd1c7A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790926743; v=1; x=1791531543;
 b=aLY+6VYLgBFre1C2EqGu5ytjoIReC7LUjTaKjIbG8FeNPU2/vGrviVkSOvITHIb87iF3Afvx
 W5nRW6YTCb6XwFHX3UJ8itQwhPk/sn+J7YYQJE1ThTBqpRDOguXZn+c/7+GK3uVPXdf8kHLRLM3
 1eTL/KY88t6/jOX64o1S3ykI=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1e7c19e368d04c55;
	Fri, 02 Oct 2026 07:39:03 +0000
X-Mizu-Trace-ID: 1e7c19e368d04c55
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v7 2/6] wifi: rtw88: 8723b: add the RTL8723B register definitions
Date: Fri,  2 Oct 2026 09:38:41 +0200
Message-ID: <20261002073845.31486-3-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002073845.31486-1-luka.gejak@linux.dev>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the register offsets and bit definitions the RTL8723B driver uses,
including the power and system function bits, the BT antenna and efuse
control registers, the packet lifetime and MAC ID drop registers, the
FPGA0 HSSI and RF switch control registers, and the RFE antenna path
registers.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/reg.h | 34 ++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 0b9ba6f37680..afcdb66fdb9a 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -8,7 +8,9 @@
 #define REG_SYS_FUNC_EN		0x0002
 #define BIT_FEN_EN_25_1		BIT(13)
 #define BIT_FEN_ELDR		BIT(12)
+#define BIT_FEN_PPLL		BIT(7)
 #define BIT_FEN_PCIEA		BIT(6)
+#define BIT_FEN_DIO_PCIE	BIT(5)
 #define BIT_FEN_CPUEN		BIT(2)
 #define BIT_FEN_USBA		BIT(2)
 #define BIT_FEN_BB_GLB_RST	BIT(1)
@@ -19,6 +21,7 @@
 #define BIT_PFM_WOWL		BIT(3)
 #define BIT_APFM_OFFMAC		BIT(9)
 #define REG_APS_FSMCO		0x0004
+#define BIT_EN_PDN		BIT(4)
 #define APS_FSMCO_MAC_ENABLE	BIT(8)
 #define APS_FSMCO_MAC_OFF	BIT(9)
 #define APS_FSMCO_HW_POWERDOWN	BIT(15)
@@ -67,6 +70,9 @@
 #define BIT_SHIFT_LDO25_VOLTAGE	4
 #define BIT_LDO25_EN		BIT(7)
 
+#define REG_PWR_DATA		0x0038
+#define BIT_EEPRPAD_RFE_CTRL_EN	BIT(11)
+
 #define REG_ACLK_MON		0x3e
 
 #define REG_GPIO_MUXCFG		0x0040
@@ -105,6 +111,12 @@
 #define BIT_BTGP_SPI_EN		BIT(20)
 #define BIT_LED1DIS		BIT(15)
 #define BIT_SW_DPDT_SEL_DATA	BIT(0)
+#define REG_BT_ANT_SEL		0x0067
+#define BIT_BT_SEL_BY_WIFI	BIT(5)
+/* 0x006b is the high byte of the 16 bit register at 0x006a. */
+#define REG_BT_EFUSE_CTRL	0x006b
+#define BIT_BT_PWR_CUT		BIT(6)
+#define BIT_BT_OUT_ISO		BIT(7)
 #define REG_WL_BT_PWR_CTRL	0x0068
 #define BIT_BT_FUNC_EN		BIT(18)
 #define BIT_BT_DIG_CLK_EN	BIT(8)
@@ -301,6 +313,8 @@
 #define REG_HMEBOX3		0x01DC
 #define REG_LLT_INIT		0x01E0
 #define BIT_LLT_WRITE_ACCESS	BIT(30)
+#define REG_RFK_FW_ACK		0x01E7
+#define BIT_RFK_FW_ACK		BIT(0)
 #define REG_HMEBOX0_EX		0x01F0
 #define REG_HMEBOX1_EX		0x01F4
 #define REG_HMEBOX2_EX		0x01F8
@@ -429,6 +443,8 @@
 #define REG_ARFRH5		0x04A8
 #define REG_SW_AMPDU_BURST_MODE_CTRL 0x04BC
 #define BIT_PRE_TX_CMD		BIT(6)
+#define REG_PKT_VO_VI_LIFE_TIME	0x04C0
+#define REG_PKT_BE_BK_LIFE_TIME	0x04C2
 #define REG_QUEUE_CTRL		0x04C6
 #define BIT_PTA_WL_TX_EN	BIT(4)
 #define BIT_PTA_EDCCA_EN	BIT(5)
@@ -437,6 +453,8 @@
 #define REG_PROT_MODE_CTRL	0x04C8
 #define REG_MAX_AGGR_NUM	0x04CA
 #define REG_BAR_MODE_CTRL	0x04CC
+#define REG_MACID_PKT_DROP0	0x04D0
+#define REG_MACID_PKT_SLEEP	0x04D4
 #define REG_PRECNT_CTRL		0x04E5
 #define BIT_BTCCA_CTRL		(BIT(0) | BIT(1))
 #define BIT_EN_PRECNT		BIT(11)
@@ -520,6 +538,7 @@
 #define BIT_UC_MD_EN		BIT(16)
 #define BIT_RXSK_PERPKT		BIT(15)
 #define BIT_HTC_LOC_CTRL	BIT(14)
+#define BIT_AMF			BIT(13)
 #define BIT_RPFM_CAM_ENABLE	BIT(12)
 #define BIT_TA_BCN		BIT(11)
 #define BIT_RCR_ADF		BIT(11)
@@ -546,6 +565,7 @@
 #define REG_ACKTO		0x0640
 #define REG_EIFS		0x0642
 #define REG_NAV_CTRL		0x0650
+#define REG_NAV_UPPER		0x0652
 #define REG_WMAC_TRXPTCL_CTL	0x0668
 #define BIT_RFMOD		(BIT(7) | BIT(8))
 #define BIT_RFMOD_80M		BIT(8)
@@ -581,6 +601,7 @@
 #define REG_BT_COEX_V2		0x0762
 #define BIT_GNT_BT_POLARITY	BIT(12)
 #define BIT_LTE_COEX_EN		BIT(7)
+#define REG_BT_CONTROL		0x0764
 #define REG_GNT_BT		0x0765
 #define BIT_PTA_SW_CTL		GENMASK(4, 3)
 #define REG_BT_COEX_ENH_INTR_CTRL	0x76E
@@ -606,12 +627,20 @@
 #define BIT_RX_PSEL_RST		(BIT(28) | BIT(29))
 #define REG_TXPSEL		0x080C
 #define REG_RX_GAIN_EN		0x081c
+#define REG_FPGA0_XA_HSSI_PARM2	0x0824
+#define HSSI_3WIRE_ADDR_LEN	0x400
+#define HSSI_3WIRE_DATA_LEN	0x800
 #define REG_CCASEL		0x082C
+#define REG_FPGA0_XB_HSSI_PARM2	0x082C
 #define REG_PDMFTH		0x0830
 #define REG_BWINDICATION	0x0834
 #define REG_CCA2ND		0x0838
 #define REG_L1PKTH		0x0848
 #define REG_CLKTRK		0x0860
+#define REG_FPGA0_XA_RF_INT_OE	0x0860
+#define REG_FPGA0_XB_RF_INT_OE	0x0864
+#define REG_FPGA0_XA_RF_SW_CTRL	0x0870
+#define RFSI_RFENV		0x10
 #define REG_CSI_MASK_SETTING1	0x0874
 #define REG_NBI_SETTING		0x087c
 #define BIT_NBI_ENABLE		BIT(13)
@@ -630,6 +659,9 @@
 #define REG_PSD			0x0910
 #define BIT_PSD_INI		GENMASK(23, 22)
 #define REG_SINGLE_TONE_CONT_TX	0x0914
+#define REG_RFE_CTRL_ANTA_SRC	0x0930
+#define REG_RFE_CTRL_ANT_SW	0x0944
+#define BIT_RFE_CTRL_ANT_SW_SEL	GENMASK(1, 0)
 #define REG_AGC_TABLE		0x0958
 #define REG_RFE_CTRL_E		0x0974
 #define REG_2ND_CCA_CTRL	0x0976
@@ -649,6 +681,7 @@
 #define REG_CCA_MF		0x0a20
 #define BIT_MBC_WIN		GENMASK(5, 4)
 #define REG_CCK0_TX_FILTER1	0x0a20
+#define REG_CCK_SWING		0x0a22
 #define REG_CCK0_TX_FILTER2	0x0a24
 #define REG_CCK0_DEBUG_PORT	0x0a28
 #define REG_CCK0_FAREPORT	0x0a2c
@@ -683,6 +716,7 @@
 #define REG_RX_IQC_AB_A		0x0c10
 #define REG_RX_IQC_CD_A		0x0c14
 #define REG_TXSCALE_A		0x0c1c
+#define REG_B_RXIQI		0x0c1c
 #define BB_SWING_MASK		GENMASK(31, 21)
 #define REG_TX_AGC_A_CCK_11_CCK_1		0xc20
 #define REG_TX_AGC_A_OFDM18_OFDM6		0xc24
-- 
2.55.0

