Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192EB21CFEF
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991898; cv=none; b=hUTwcsyZn97kSNstTbN/AzINLNKzwaMlaLXVUNYpS0d6LisvMQQ8h8sBSdWNmLaLABFbD5q9EEa0oS3Fks72MpGQ0pw8oXDAJrGNxHqtSW1Ur2T5tlQ2+8ZSANRpa+6LAT/NBiy0LgGzBFtuaIUPdf8KjirsePDii6O0J3YQ89M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991898; c=relaxed/simple;
	bh=LHpGpzjL1uOwjlBaIO90InqWsWUAnDDYnOZ91uCf8A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6OLjzszgKxU/jidEl3rMYKHiv0YLWs/odGummi+UKGPMn5fQnJXk2PGnWGFztT1aKmsw/pXmV3rNVgwfs81nnXInISVVrjz3FJWuqVeIjtdpAerqVV1XxcDX0SIzma1+EBChaF/8TweGoirFDA62uCwXLhJQPPETp/0VZQK96o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vHERFgbx; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vHERFgbx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784991895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lF5WnMxjImn1MaAktMHv+BB6Hk67GwaL4Xcun9Zmj2w=;
	b=vHERFgbxWWl4DzLTEEe87jhp4Zs8mhY0gtSs/aW9jibYD+0jKM9kr5IYKJdgOz1Jb5j55r
	rEXm7bDb3zg317TlShaScyovH2WfOY5XVSSghdMVbqJXulNHUeL/goJVZ5UoGi4Z2l/E2o
	Q+EKOvnd7vtlTx6xVqBsTvsXMSQpEJk=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 03/11] wifi: rtw88: fw: add the GNT_BT firmware command
Date: Sat, 25 Jul 2026 17:04:19 +0200
Message-ID: <20260725150427.93887-4-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-1-luka.gejak@linux.dev>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The RTL8723BS coexistence sequence needs an H2C command that rtw88 does
not implement: the firmware GNT_BT state, which hands the shared antenna
to WiFi. Add it here so the coexistence change that follows has it
available.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 11 +++++++++++
 drivers/net/wireless/realtek/rtw88/fw.h |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..dd6595b8175e 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -786,6 +786,17 @@ void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool connect)
 	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
 }
 
+/* 8723BS SDIO: set the firmware GNT_BT state (0 = WiFi owns the antenna). */
+void rtw_fw_set_gnt_bt(struct rtw_dev *rtwdev, u8 state)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_GNT_BT);
+	SET_GNT_BT_STATE(h2c_pkt, state);
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
 void rtw_fw_update_wl_phy_info(struct rtw_dev *rtwdev)
 {
 	struct rtw_traffic_stats *stats = &rtwdev->stats;
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 48ad9ceab6ea..f5ed65c46350 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -572,6 +572,7 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
 #define H2C_CMD_QUERY_BT_MP_INFO	0x67
 #define H2C_CMD_BT_WIFI_CONTROL		0x69
 #define H2C_CMD_WIFI_CALIBRATION	0x6d
+#define H2C_CMD_GNT_BT			0x6e
 #define H2C_CMD_QUERY_BT_HID_INFO	0x73
 
 #define H2C_CMD_KEEP_ALIVE		0x03
@@ -684,6 +685,8 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(31, 24))
 #define SET_QUERY_BT_INFO(h2c_pkt, value)                                      \
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(8))
+#define SET_GNT_BT_STATE(h2c_pkt, value)                                       \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(8))
 #define SET_WL_CH_INFO_LINK(h2c_pkt, value)                                    \
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
 #define SET_WL_CH_INFO_CHNL(h2c_pkt, value)                                    \
@@ -849,6 +852,7 @@ void rtw_fw_send_rssi_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si);
 void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 			 bool reset_ra_mask);
 void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool conn);
+void rtw_fw_set_gnt_bt(struct rtw_dev *rtwdev, u8 state);
 void rtw_fw_update_wl_phy_info(struct rtw_dev *rtwdev);
 void rtw_fw_beacon_filter_config(struct rtw_dev *rtwdev, bool connect,
 				 struct ieee80211_vif *vif);
-- 
2.55.0

