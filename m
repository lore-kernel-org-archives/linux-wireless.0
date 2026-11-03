Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692413;
	b=XcqN0Fo63bV7KYCiGk4dCAtepZH1RrzNcJqeWtVVNy8G2cP2HUoMw0i6qti/fmGwiRBl
	 JZ5wBsAfnQDYGEotPdR7ynVWt5oXiBKPGhbEPXLdA230SRcKXy1ASlmtr3Kp//Be/mQVq
	 0shD/pj92UVsxY7keZ289Dg4yHckQvCLef9ida5kB1cMfAHMhfBxkaHxjpKIkK0CPm8iA
	 NRqUYMYtPg9VzhV6pzfNFsHWXUTcsTPax317k0bCr4XEg2XTvAP+wVZlT2CYHZmZi8gBi
	 VJByTyBUsiHmYMshbU1qgR/rHPQ5ctSJmvpkBmIVnXSzedx8IgU8c0MWPae+iMuBwaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692413;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type;
	bh=n8bobHCEOxmTBV7IVD6M4PdGuWNv6M0HC6fay/DLDEo=;
	b=ZTDbWNabrghHOtN58xdIy4mrWvTufDYRxHjqZx81QJrWc9U/AxQtZHdRN7wYNcDaR4th
	 nMPCdrXDe7QYiXVBKECdqjwJEMFWVeIEF+Xxl8oKa7R/scmg8s/+YHgF+BvYscgnRwqly
	 HFD+LId7Lej8zOH4cj+wPScpkP3JTVSOHURJrvX9irnLuZr4k4/OoBGYYmBY/7xuFTD2k
	 +C6ZqeUX9BUNW4tZkcGv11dgPYFkEJ6SVUaQBgMvkhx1cqOWn9PYGPdKwWPjdjkNTzLco
	 Pza3KPX2+2HW8SRBLJ3LVUyJLu5JC3etHmWUKozA8xc0n8iWJeX1dnwowzxcguzIESQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=nBIhlqHK;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB21606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 07:53:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FB21606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=nBIhlqHK
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A37rUyJ52864339, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793692410; bh=n8bobHCEOxmTBV7IVD6M4PdGuWNv6M0HC6fay/DLDEo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=nBIhlqHKBl0ozPzDm6M5kU+ZN3mvp0eYRAxPa0dQRcT4+kWERr7DOwLuGsEHtmcaI
	 VY/fB6GSFhxYOUyA8xUfg/crlSZfU6I4uR00yxPDBVk2EUr+9p9I2tNp9oczJVZd6h
	 vXrm4EZxESLJxZyub2JqVhkLB8F2UwfqIYIhvtrrtxoSeVhwbFN0HX54eb9FcSkTpF
	 JxnX+A9GVfSZVYJ9Aje2ktuCANlc6O6rRrwBho2+fFq4Y5hLRMdtRCPNRM02PvB96s
	 u1um5Hq+OizUEZegSylfUk75G+TCkYMrsJjyMkin4ELSeIdLA3xrKOdyBze+DoSAyE
	 gW26Fz3oytrOw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A37rUyJ52864339
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 15:53:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 15:53:30 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 15:53:29 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 15:53:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>
Subject: [PATCH rtw-next 2/2] wifi: rtw89: avoid premature power save entry for buffered traffic
Date: Tue, 3 Nov 2026 15:52:55 +0800
Message-ID: <20261103075255.56487-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261103075255.56487-1-pkshih@realtek.com>
References: <20261103075255.56487-1-pkshih@realtek.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chin-Yen Lee <timlee@realtek.com>

Configure two LPS parameters to prevent premature entry into power
save mode and improving the delivery of real-time traffic. Enable
MART_PS_DTIM_RX to transmit a Null Data frame to synchronize the
power save state with the AP after waking up when buffered traffic
is indicated by the beacon TIM. Enable TRX_EXT_MODE to keep the device
awake for the remainder of the current TBTT interval when the AP has
buffered packets.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 40 +++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h | 15 ++++++++++
 drivers/net/wireless/realtek/rtw89/ps.c |  1 +
 3 files changed, 56 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index ea7dba077f5d..5ba265e0eeed 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3525,6 +3525,46 @@ int rtw89_fw_h2c_lps_parm(struct rtw89_dev *rtwdev,
 	return ret;
 }
 
+int rtw89_fw_h2c_lps_adv_param(struct rtw89_dev *rtwdev,
+			       struct rtw89_vif_link *rtwvif_link)
+{
+	struct rtw89_h2c_lps_adv_parm *h2c;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	int ret;
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for h2c lps adv parm\n");
+		return -ENOMEM;
+	}
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_lps_adv_parm *)skb->data;
+
+	h2c->w0 = le32_encode_bits(rtwvif_link->mac_id, RTW89_H2C_PS_ADV_PARM_W0_MACID) |
+		  le32_encode_bits(1, RTW89_H2C_PS_ADV_PARM_W0_EN_SMART_PS_DTIM_RX) |
+		  le32_encode_bits(1, RTW89_H2C_PS_ADV_PARM_W0_EN_TRX_EXT_MODE);
+
+	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
+			      H2C_CAT_MAC,
+			      H2C_CL_MAC_PS,
+			      H2C_FUNC_MAC_PS_ADVANCE_PARM, 0, 1,
+			      len);
+
+	ret = rtw89_h2c_tx(rtwdev, skb, false);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to send h2c\n");
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	dev_kfree_skb_any(skb);
+
+	return ret;
+}
+
 int rtw89_fw_h2c_lps_ch_info(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index e4d3331fc18f..ba4813b9230f 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2338,6 +2338,18 @@ struct rtw89_h2c_wow_payload_cam_update {
 	__le32 w8;
 } __packed;
 
+struct rtw89_h2c_lps_adv_parm {
+	__le32 w0;
+	__le32 w1;
+} __packed;
+
+#define RTW89_H2C_PS_ADV_PARM_W0_MACID GENMASK(7, 0)
+#define RTW89_H2C_PS_ADV_PARM_W0_TRX_TIMEOUT_TIME_SET GENMASK(9, 8)
+#define RTW89_H2C_PS_ADV_PARM_W0_EN_SMART_PS_DTIM_RX BIT(10)
+#define RTW89_H2C_PS_ADV_PARM_W0_EN_TRX_EXT_MODE BIT(11)
+#define RTW89_H2C_PS_ADV_PARM_W1_TRX_TIMEOUT_TIME_VAL GENMASK(7, 0)
+#define RTW89_H2C_PS_ADV_PARM_W1_EXTNUM GENMASK(15, 8)
+
 #define RTW89_H2C_WOW_PLD_CAM_UPD_W0_R_W BIT(0)
 #define RTW89_H2C_WOW_PLD_CAM_UPD_W0_IDX GENMASK(7, 1)
 #define RTW89_H2C_WOW_PLD_CAM_UPD_WKFM0 GENMASK(31, 0)
@@ -4800,6 +4812,7 @@ enum rtw89_ps_h2c_func {
 	H2C_FUNC_MAC_LPS_PARM		= 0x0,
 	H2C_FUNC_P2P_ACT		= 0x1,
 	H2C_FUNC_IPS_CFG		= 0x3,
+	H2C_FUNC_MAC_PS_ADVANCE_PARM	= 0x4,
 	H2C_FUNC_PS_POWER_LEVEL		= 0x7,
 	H2C_FUNC_TBTT_TUNING		= 0xA,
 
@@ -5636,6 +5649,8 @@ int rtw89_fw_h2c_init_ba_cam_users(struct rtw89_dev *rtwdev, u8 users,
 
 int rtw89_fw_h2c_lps_parm(struct rtw89_dev *rtwdev,
 			  struct rtw89_lps_parm *lps_param);
+int rtw89_fw_h2c_lps_adv_param(struct rtw89_dev *rtwdev,
+			       struct rtw89_vif_link *rtwvif_link);
 int rtw89_fw_h2c_lps_ch_info(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif);
 int rtw89_fw_h2c_lps_ml_cmn_info(struct rtw89_dev *rtwdev,
 				 struct rtw89_vif *rtwvif);
diff --git a/drivers/net/wireless/realtek/rtw89/ps.c b/drivers/net/wireless/realtek/rtw89/ps.c
index 3639292eba7a..40bac65dd8ed 100644
--- a/drivers/net/wireless/realtek/rtw89/ps.c
+++ b/drivers/net/wireless/realtek/rtw89/ps.c
@@ -138,6 +138,7 @@ static void __rtw89_enter_lps_link(struct rtw89_dev *rtwdev,
 
 	rtw89_btc_ntfy_radio_state(rtwdev, BTC_RFCTRL_FW_CTRL);
 	rtw89_fw_h2c_lps_parm(rtwdev, &lps_param);
+	rtw89_fw_h2c_lps_adv_param(rtwdev, rtwvif_link);
 
 	if (RTW89_CHK_FW_FEATURE(BEACON_TRACKING, &rtwdev->fw))
 		rtw89_fw_h2c_pwr_lvl(rtwdev, rtwvif_link);
-- 
2.25.1

