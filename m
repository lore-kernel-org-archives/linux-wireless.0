Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA5D44E040;
	Fri, 24 Jul 2026 18:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917161; cv=none; b=ahunDKonG0ZM2RI7O2wmnP8bdneGANRM89QEObJMzKJ+q8Ic2WvBiW4ZHCqE2ImZYTSe7R6Jzrw3L3qZoYrv+YNvJMcQ6KJmepJE5mzqw3rTXoSN8OBIpW/L95O4bBumJwjMjl3Lsc0en+yDHlQ21IN6eecMD0uPK9u11OwXfsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917161; c=relaxed/simple;
	bh=HbDmfFlBhz7UPU1jMwShc5uZRpr5WzQDOy4y5+IdpHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eERk7V2HR2wogQbtqWeIkRDcLTSp/Ef40Fxh6j26S6fnGXs/twhLXsh/z6KuNaCtwJ7/eSFjQBD53JfEK1wsUVO410hh3i2jX6nMFJY73g/HuJJth3ImdC1SYCtq3Nbr4+VXGt+ifba3PvsVxnqWkCkbnBTm6QCjP7w6Pq8OU58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i7ttsxEx; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i7ttsxEx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OiDTYv43op+6AuiHfvwh9FttAhnDXyY8yKDtSmRi4vs=;
	b=i7ttsxExdbBKFP1sg7zYs3EB8M6S4KMeyteVXpEm/vRT3GbOIfn1loNib8Psj6f3cAoi6b
	BJIvSK/2Q3HVrupBZC5lrqjF0rbeyasNaNsogySSfojMAWdHsbESUxGjD6RM9lOLX7hbgn
	vJgr7zJJ+5p4imRdg+eedl4+sCwjg3E=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 07/19] wifi: rtw88: fw: add the vendor firmware commands used by RTL8723BS
Date: Fri, 24 Jul 2026 20:18:46 +0200
Message-ID: <20260724181858.192903-8-luka.gejak@linux.dev>
In-Reply-To: <20260724181858.192903-1-luka.gejak@linux.dev>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The RTL8723BS join and coexistence sequences need four commands that
rtw88 does not implement: MACID_CFG to configure rate adaptation after
association, the WL channel info report, the firmware GNT_BT state, and
the coexistence antenna select reserve that forms part of the vendor
initialisation toggle.

Add them here so the coexistence and association changes that follow
have the commands available.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 59 +++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/fw.h | 13 ++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 87da0dd82aaa..b43ee5d951fd 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -856,6 +856,65 @@ void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool connect)
 	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
 }
 
+/* 8723BS SDIO: post-assoc rate-adaptation config in the vendor v5.2.17
+ * MACID_CFG byte layout. disra (bit7 of [2]) must stay 0 so the firmware keeps
+ * running rate adaptation for this mac_id.
+ */
+void rtw_fw_macid_cfg(struct rtw_dev *rtwdev, u8 mac_id, u8 raid, u8 bw,
+		      u8 sgi, u32 rate_mask)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RA_INFO);
+
+	h2c_pkt[1] = mac_id & 0x7f;
+	h2c_pkt[2] = (raid & 0x1f) | (sgi ? BIT(7) : 0) | 0x60;
+	h2c_pkt[3] = (bw ? 3 : 1) & 0x3;
+	h2c_pkt[4] = rate_mask & 0xff;
+	h2c_pkt[5] = (rate_mask >> 8) & 0xff;
+	h2c_pkt[6] = (rate_mask >> 16) & 0xff;
+	h2c_pkt[7] = (rate_mask >> 24) & 0xff;
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+/* 8723BS SDIO: report the connected channel/bandwidth to the vendor firmware. */
+void rtw_fw_send_wl_ch_info(struct rtw_dev *rtwdev, u8 ch, u8 bw)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+	u8 bw_byte = bw == RTW_CHANNEL_WIDTH_40 ? 0x30 : 0x20;
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_WL_CH_INFO);
+	h2c_pkt[1] = 0x00;
+	h2c_pkt[2] = ch;
+	h2c_pkt[3] = bw_byte;
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
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
+/* 8723BS SDIO: vendor coex antenna-select reserve H2C (part of the init toggle). */
+void rtw_fw_coex_ant_sel_rsv(struct rtw_dev *rtwdev, u8 inverse, u8 type)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_COEX_ANT_SEL_RSV);
+	SET_COEX_ANT_SEL_RSV_INVERSE(h2c_pkt, inverse);
+	SET_COEX_ANT_SEL_RSV_TYPE(h2c_pkt, type);
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
 void rtw_fw_update_wl_phy_info(struct rtw_dev *rtwdev)
 {
 	struct rtw_traffic_stats *stats = &rtwdev->stats;
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 6927d2041d24..8b238b41decf 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -572,10 +572,12 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
 #define H2C_CMD_QUERY_BT_INFO		0x61
 #define H2C_CMD_FORCE_BT_TX_POWER	0x62
 #define H2C_CMD_IGNORE_WLAN_ACTION	0x63
+#define H2C_CMD_COEX_ANT_SEL_RSV	0x65
 #define H2C_CMD_WL_CH_INFO		0x66
 #define H2C_CMD_QUERY_BT_MP_INFO	0x67
 #define H2C_CMD_BT_WIFI_CONTROL		0x69
 #define H2C_CMD_WIFI_CALIBRATION	0x6d
+#define H2C_CMD_GNT_BT			0x6e
 #define H2C_CMD_QUERY_BT_HID_INFO	0x73
 
 #define H2C_CMD_KEEP_ALIVE		0x03
@@ -688,6 +690,12 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(31, 24))
 #define SET_QUERY_BT_INFO(h2c_pkt, value)                                      \
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(8))
+#define SET_GNT_BT_STATE(h2c_pkt, value)                                       \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(8))
+#define SET_COEX_ANT_SEL_RSV_INVERSE(h2c_pkt, value)                           \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
+#define SET_COEX_ANT_SEL_RSV_TYPE(h2c_pkt, value)                              \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(23, 16))
 #define SET_WL_CH_INFO_LINK(h2c_pkt, value)                                    \
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
 #define SET_WL_CH_INFO_CHNL(h2c_pkt, value)                                    \
@@ -853,6 +861,11 @@ void rtw_fw_send_rssi_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si);
 void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 			 bool reset_ra_mask);
 void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool conn);
+void rtw_fw_macid_cfg(struct rtw_dev *rtwdev, u8 mac_id, u8 raid, u8 bw,
+		      u8 sgi, u32 rate_mask);
+void rtw_fw_send_wl_ch_info(struct rtw_dev *rtwdev, u8 ch, u8 bw);
+void rtw_fw_set_gnt_bt(struct rtw_dev *rtwdev, u8 state);
+void rtw_fw_coex_ant_sel_rsv(struct rtw_dev *rtwdev, u8 inverse, u8 type);
 void rtw_fw_update_wl_phy_info(struct rtw_dev *rtwdev);
 void rtw_fw_beacon_filter_config(struct rtw_dev *rtwdev, bool connect,
 				 struct ieee80211_vif *vif);
-- 
2.55.0

