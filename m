Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CC23BFAD1
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937306; cv=none; b=Ts4rC/XpOPz1n0SRGB8r7A+PudXyVSI2ZfbGTHmifdQ02lcUs8pV/PXF+gCLClDblntiRLNOo742cxkXpWPd57tdtHk/SOUbYpNuebbi89Y5DSP+xdStHEhDcfyzrm1YyZWRa05Mi4BtGN2Ig6EhNLSPJx4WG9Xr6ZmF740SGyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937306; c=relaxed/simple;
	bh=B1DFRJCvyJKnN8sgQRQTb7ISpiUyMId04149IAX5M+k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c7Kq/OG4iB6skv5+vDV2Cc6IvJZcub83Gc/JQffh1ijZTyZIeTnxyQeb27iF7+FJi34TasgEeJySA2ylaVSwL52F4Y/WU3dp0WNaj/Vb0H3z0Hn0XHVbMLhrtGxJ6sio+s+Ue5w5ULKyeZGcnhuSqlyXmfBL3MqJnP+AIdIsXjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=YK4lkiYG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="YK4lkiYG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68971dweE356938, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937301; bh=0kNLrhSyUMJ3KVldy5LGn6Eqs95zwrA99H7lxKMO0C0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=YK4lkiYGPEcjiRDZIhdqH1exOOywYjCvWtLOaCDG98Ubox5lyGK+9b1E6PKOkXFyn
	 8bXszbvxeLSpffWryJLk8MymFeYzCGdNziExkD1+qYGxLj0MYj3uBai/U8eY3vH572
	 dMEnme9fvmDByoJVhhQma+tqN7wSpYfP7dTf9t6F/CVgMG5aIjjAfIgGs/DlGGjPTo
	 mWX7/Oa2Dl3ZwwewwUByJF7pbRzud/HvTVVl8ZHrZLXUAisMh0FWaZN6Ptzdgr4DNF
	 Y65iEWMupVGFC7KECn4MyS3z6/+r9TRnFh7sKB47QIQBwV6Kw+BTMmY6WRdMIaDKyO
	 TbaJbMvP8iOMQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68971dweE356938
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:01:40 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:39 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:39 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:01:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 11/15] wifi: rtw89: fw: extend ch_info format of hw_scan to v2
Date: Wed, 9 Sep 2026 15:00:00 +0800
Message-ID: <20260909070004.35353-12-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The new format of ch_info is extended from 8 words to 9 words to have
additional control probe delay on 6GHz band, but not implement these
fields for now.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c   | 27 +++++++++++++++++++----
 drivers/net/wireless/realtek/rtw89/fw.h   |  6 ++++-
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index e88942c469e4..3caef61b21d3 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6011,6 +6011,7 @@ enum rtw89_fw_feature {
 	RTW89_FW_FEATURE_NO_WOW_CPU_IO_RX,
 	RTW89_FW_FEATURE_NOTIFY_AP_INFO,
 	RTW89_FW_FEATURE_CH_INFO_BE_V0,
+	RTW89_FW_FEATURE_CH_INFO_BE_V1,
 	RTW89_FW_FEATURE_LPS_CH_INFO,
 	RTW89_FW_FEATURE_NO_PHYCAP_P1,
 	RTW89_FW_FEATURE_NO_POWER_DIFFERENCE,
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 300686ed0f6e..9eaace2d57c4 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -967,6 +967,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8922A, ge, 0, 35, 108, 0, SIM_SER_L0L1_BY_HALT_H2C),
 	__CFG_FW_FEAT(RTL8922A, lt, 0, 35, 109, 1, SCAN_OFFLOAD_BE_V1),
 	__CFG_FW_FEAT(RTL8922A, lt, 0, 35, 113, 2, SCAN_OFFLOAD_BE_V2),
+	__CFG_FW_FEAT(RTL8922A, lt, 0, 35, 119, 0, CH_INFO_BE_V1),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 0, 0, 0, MACID_PAUSE_SLEEP),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 75, 2, SCAN_OFFLOAD),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 75, 2, BEACON_FILTER),
@@ -984,6 +985,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 113, 0, RFK_TXIQK_V0),
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 113, 2, SCAN_OFFLOAD_BE_V2),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 119, 0, LPS_ML_INFO_V1_EXTRA),
+	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 119, 0, CH_INFO_BE_V1),
 };
 
 static void rtw89_fw_iterate_feature_cfg(struct rtw89_fw_info *fw,
@@ -7615,24 +7617,34 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 	struct rtw89_h2c_chinfo_elem_be *elem;
 	struct rtw89_mac_chinfo_be *ch_info;
 	struct rtw89_h2c_chinfo_be *h2c;
+	u8 elem_size = sizeof(*elem);
 	bool wildcard_by_drv;
 	struct sk_buff *skb;
 	unsigned int cond;
 	u8 ver = U8_MAX;
+	int used_len;
 	int skb_len;
 	int ret;
 
 	static_assert(sizeof(*elem) == RTW89_MAC_CHINFO_SIZE_BE);
 
 	skb_len = struct_size(h2c, elem, ch_num);
+	used_len = skb_len;
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, skb_len);
 	if (!skb) {
 		rtw89_err(rtwdev, "failed to alloc skb for h2c scan list\n");
 		return -ENOMEM;
 	}
 
-	if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V0, &rtwdev->fw))
+	if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V0, &rtwdev->fw)) {
 		ver = 0;
+		elem_size = offsetofend(typeof(*elem), w7);
+		used_len = sizeof(*h2c) + elem_size * ch_num;
+	} else if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V1, &rtwdev->fw)) {
+		ver = 1;
+		elem_size = offsetofend(typeof(*elem), w7);
+		used_len = sizeof(*h2c) + elem_size * ch_num;
+	}
 
 	wildcard_by_drv = !(RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V0, &rtwdev->fw) ||
 			    RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V1, &rtwdev->fw) ||
@@ -7642,14 +7654,14 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 	h2c = (struct rtw89_h2c_chinfo_be *)skb->data;
 
 	h2c->ch_num = ch_num;
-	h2c->elem_size = sizeof(*elem) / 4; /* in unit of 4 bytes */
+	h2c->elem_size = elem_size / 4; /* in unit of 4 bytes */
 	h2c->arg = u8_encode_bits(rtwvif_link->mac_idx,
 				  RTW89_H2C_CHINFO_ARG_MAC_IDX_MASK);
 
 	list_for_each_entry(ch_info, chan_list, list) {
 		bool with_probe_id = ch_info->probe_id != RTW89_SCANOFLD_PKT_NONE;
 
-		elem = (struct rtw89_h2c_chinfo_elem_be *)skb_put(skb, sizeof(*elem));
+		elem = (struct rtw89_h2c_chinfo_elem_be *)skb_put(skb, elem_size);
 
 		elem->w0 = le32_encode_bits(ch_info->dwell_time, RTW89_H2C_CHINFO_BE_W0_DWELL) |
 			   le32_encode_bits(ch_info->central_ch,
@@ -7704,11 +7716,16 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 		else
 			elem->w7 = le32_encode_bits(ch_info->period,
 						    RTW89_H2C_CHINFO_BE_W7_PERIOD_V1);
+
+		if (ver < 2)
+			continue;
+
+		elem->w8 = 0;
 	}
 
 	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
 			      H2C_CAT_MAC, H2C_CL_MAC_FW_OFLD,
-			      H2C_FUNC_ADD_SCANOFLD_CH, 1, 1, skb_len);
+			      H2C_FUNC_ADD_SCANOFLD_CH, 1, 1, used_len);
 
 	cond = RTW89_SCANOFLD_WAIT_COND_ADD_CH;
 
@@ -7929,6 +7946,8 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 
 	if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V0, &rtwdev->fw))
 		ver = 0;
+	else if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V1, &rtwdev->fw))
+		ver = 1;
 
 	h2c->w0 = le32_encode_bits(option->operation, RTW89_H2C_SCANOFLD_BE_W0_OP) |
 		  le32_encode_bits(option->scan_mode,
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index d1bd82788376..d64435ffbf78 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -342,7 +342,7 @@ struct rtw89_fw_macid_pause_sleep_grp {
 #define RTW89_SCANOFLD_DEBUG_MASK 0x1F
 #define RTW89_CHAN_INVALID 0xFF
 #define RTW89_MAC_CHINFO_SIZE 28
-#define RTW89_MAC_CHINFO_SIZE_BE 32
+#define RTW89_MAC_CHINFO_SIZE_BE 36
 #define RTW89_SCAN_LIST_GUARD 4
 #define RTW89_SCAN_LIST_LIMIT(size) \
 		((RTW89_H2C_MAX_SIZE / (size)) - RTW89_SCAN_LIST_GUARD)
@@ -3009,6 +3009,7 @@ struct rtw89_h2c_chinfo_elem_be {
 	__le32 w5;
 	__le32 w6;
 	__le32 w7;
+	__le32 w8; /* after CH_INFO_BE_V1 */
 } __packed;
 
 #define RTW89_H2C_CHINFO_BE_W0_PERIOD GENMASK(7, 0)
@@ -3041,6 +3042,9 @@ struct rtw89_h2c_chinfo_elem_be {
 #define RTW89_H2C_CHINFO_BE_W6_FW_PROBE0_SHORTSSIDS GENMASK(15, 0)
 #define RTW89_H2C_CHINFO_BE_W6_FW_PROBE0_BSSIDS GENMASK(31, 16)
 #define RTW89_H2C_CHINFO_BE_W7_PERIOD_V1 GENMASK(15, 0)
+#define RTW89_H2C_CHINFO_BE_W7_SSIDS_IGN_DELAY_V2 GENMASK(31, 16)
+#define RTW89_H2C_CHINFO_BE_W8_SHORTSSIDS_IGN_DELAY_V2 GENMASK(15, 0)
+#define RTW89_H2C_CHINFO_BE_W8_BSSIDS_IGN_DELAY_V2 GENMASK(31, 16)
 
 struct rtw89_h2c_chinfo {
 	u8 ch_num;
-- 
2.25.1

