Received: from mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCF24BD37A
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005459; cv=none; b=L5CkvzNtp+uuSWccj+yFYmf7N4om4Hk6PUzISwmtiJxUAW+dBjjZuO6nun9YXz3lZPpAl9YLokZFE9ZwQevbCflOLTlGce2mjJEs1hgPSF9NWwU6vNKkJa2FwjE/DilXX+cj4xZl9rwgDGxVARrnojQOAkaKOnRUp1doAuaUnLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005459; c=relaxed/simple;
	bh=Ne0za4PM3YrMt6qnnQwWKNZ7CbbgltQmkIZuCD/h0zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8vCvH7CGFXSyjnrRK+4R42YMqJDo7bgM1EItFAcTYvCaPf3Q/2l5GhguswhpkwQMu4vpgdBakoR9Sk3X0zLw1YVU0LN3psBl0qWgKubJAtOLdYyFLmcWKzBTwIrlXSvsuv42VEahwa98LzLo8sBllr+pdOhZM9wXDlGRWWiE8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aFpIT2GJ; arc=none smtp.client-ip=95.215.58.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aFpIT2GJ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ne0za4PM3YrMt6qnnQwWKNZ7CbbgltQmkIZuCD/h0zU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790005455; v=1; x=1790610255;
 b=aFpIT2GJesnLwktdqYApOroLVhASqgtGprPl8sLSruBC+4EaiIsu7oB3Hsf+wA/S5+G8XG2N
 i7So7hRB9rMv/skXzPFWPF2e6s4eKRznM7YMYTcACqxUe2wyhnz0WjUTkljOWUhlM9QuuXJ/GIG
 qu6kqrvVjRaap5srU/bhgrik=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f23133c31f542964;
	Mon, 21 Sep 2026 15:44:14 +0000
X-Mizu-Trace-ID: f23133c31f542964
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v3 1/6] wifi: rtw88: 8723b: add the RTL8723B register definitions
Date: Mon, 21 Sep 2026 17:43:42 +0200
Message-ID: <20260921154347.82317-2-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154347.82317-1-luka.gejak@linux.dev>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the register offsets and bit definitions the RTL8723B driver uses:
the power and system function bits, the BT antenna and control
registers, the packet lifetime and MAC ID drop registers, the FPGA0
HSSI and RF switch control registers, and the RFE antenna path
registers.

These are split out from the chip driver so the driver patch that
follows is easier to read. Nothing references them yet.

This depends on the shared core handling sent as a separate series,
"wifi: rtw88: preparations for RTL8723B/RTL8723BS".

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/reg.h | 31 ++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 0b9ba6f37680..314c9594af0b 100644
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
@@ -105,6 +111,7 @@
 #define BIT_BTGP_SPI_EN		BIT(20)
 #define BIT_LED1DIS		BIT(15)
 #define BIT_SW_DPDT_SEL_DATA	BIT(0)
+#define REG_BT_ANT_SEL_8723B	0x0067
 #define REG_WL_BT_PWR_CTRL	0x0068
 #define BIT_BT_FUNC_EN		BIT(18)
 #define BIT_BT_DIG_CLK_EN	BIT(8)
@@ -301,6 +308,8 @@
 #define REG_HMEBOX3		0x01DC
 #define REG_LLT_INIT		0x01E0
 #define BIT_LLT_WRITE_ACCESS	BIT(30)
+#define REG_RFK_FW_ACK_8723B	0x01e7
+#define BIT_RFK_FW_ACK_8723B	BIT(0)
 #define REG_HMEBOX0_EX		0x01F0
 #define REG_HMEBOX1_EX		0x01F4
 #define REG_HMEBOX2_EX		0x01F8
@@ -429,6 +438,8 @@
 #define REG_ARFRH5		0x04A8
 #define REG_SW_AMPDU_BURST_MODE_CTRL 0x04BC
 #define BIT_PRE_TX_CMD		BIT(6)
+#define REG_PKT_VO_VI_LIFE_TIME	0x04C0
+#define REG_PKT_BE_BK_LIFE_TIME	0x04C2
 #define REG_QUEUE_CTRL		0x04C6
 #define BIT_PTA_WL_TX_EN	BIT(4)
 #define BIT_PTA_EDCCA_EN	BIT(5)
@@ -437,6 +448,8 @@
 #define REG_PROT_MODE_CTRL	0x04C8
 #define REG_MAX_AGGR_NUM	0x04CA
 #define REG_BAR_MODE_CTRL	0x04CC
+#define REG_MACID_PKT_DROP0	0x04D0
+#define REG_MACID_PKT_SLEEP	0x04D4
 #define REG_PRECNT_CTRL		0x04E5
 #define BIT_BTCCA_CTRL		(BIT(0) | BIT(1))
 #define BIT_EN_PRECNT		BIT(11)
@@ -497,6 +510,8 @@
 #define REG_TIMER0_SRC_SEL	0x05B4
 #define BIT_TSFT_SEL_TIMER0	(BIT(4) | BIT(5) | BIT(6))
 
+#define REG_BWOPMODE		0x0603
+#define BIT_BWOPMODE_20MHZ	BIT(2)
 #define REG_TCR			0x0604
 #define BIT_PWRMGT_HWDATA_EN	BIT(7)
 #define BIT_TCR_UPDATE_TIMIE	BIT(5)
@@ -520,6 +535,7 @@
 #define BIT_UC_MD_EN		BIT(16)
 #define BIT_RXSK_PERPKT		BIT(15)
 #define BIT_HTC_LOC_CTRL	BIT(14)
+#define BIT_AMF			BIT(13)
 #define BIT_RPFM_CAM_ENABLE	BIT(12)
 #define BIT_TA_BCN		BIT(11)
 #define BIT_RCR_ADF		BIT(11)
@@ -546,6 +562,7 @@
 #define REG_ACKTO		0x0640
 #define REG_EIFS		0x0642
 #define REG_NAV_CTRL		0x0650
+#define REG_NAV_UPPER		0x0652
 #define REG_WMAC_TRXPTCL_CTL	0x0668
 #define BIT_RFMOD		(BIT(7) | BIT(8))
 #define BIT_RFMOD_80M		BIT(8)
@@ -581,6 +598,7 @@
 #define REG_BT_COEX_V2		0x0762
 #define BIT_GNT_BT_POLARITY	BIT(12)
 #define BIT_LTE_COEX_EN		BIT(7)
+#define REG_BT_CONTROL_8723B	0x0764
 #define REG_GNT_BT		0x0765
 #define BIT_PTA_SW_CTL		GENMASK(4, 3)
 #define REG_BT_COEX_ENH_INTR_CTRL	0x76E
@@ -606,12 +624,20 @@
 #define BIT_RX_PSEL_RST		(BIT(28) | BIT(29))
 #define REG_TXPSEL		0x080C
 #define REG_RX_GAIN_EN		0x081c
+#define REG_FPGA0_XA_HSSI_PARM2	0x0824
+#define HSSI_3WIRE_ADDR_LEN	0x400
+#define HSSI_3WIRE_DATA_LEN	0x800
 #define REG_CCASEL		0x082C
+#define REG_FPGA0_XB_HSSI_PARM2	0x082c
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
@@ -630,6 +656,10 @@
 #define REG_PSD			0x0910
 #define BIT_PSD_INI		GENMASK(23, 22)
 #define REG_SINGLE_TONE_CONT_TX	0x0914
+#define REG_RFE_CTRL_ANTA_SRC	0x0930
+#define REG_RFE_CTRL_ANT_SW	0x0944
+#define BIT_RFE_CTRL_ANT_SW_SEL	GENMASK(1, 0)
+#define BIT_BT_SEL_BY_WIFI_8723B	BIT(5)
 #define REG_AGC_TABLE		0x0958
 #define REG_RFE_CTRL_E		0x0974
 #define REG_2ND_CCA_CTRL	0x0976
@@ -683,6 +713,7 @@
 #define REG_RX_IQC_AB_A		0x0c10
 #define REG_RX_IQC_CD_A		0x0c14
 #define REG_TXSCALE_A		0x0c1c
+#define REG_B_RXIQI		0x0c1c
 #define BB_SWING_MASK		GENMASK(31, 21)
 #define REG_TX_AGC_A_CCK_11_CCK_1		0xc20
 #define REG_TX_AGC_A_OFDM18_OFDM6		0xc24
-- 
2.55.0

