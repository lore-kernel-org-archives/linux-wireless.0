Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE65414DC9
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 14:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902986; cv=none; b=SO4/WhH+LIw6VfEsQkqfwCwjduT64ITSrJxHSW8AKydCyv1MS4oJKLgM1Kn2cKSGYX49CEaJCrow5RiDk1f1iunslOMAYSqeb8FRoUTlbP6tkldm4fgY8ttHNuTHP6e8Z8+fIJDxikpztDUcNd0mew6sipl2hTw9RZv/TUD27RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902986; c=relaxed/simple;
	bh=eDtb2fXAJiSnSZxkQop/J8nwZlPgiLFbBDYTLC6hOtA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PciljHbFtfvtqPzVOBY+AgsIoZds76JZg2MM7ezSXqTYnEYR5IBNMWBvPYp4ZU+5GbO92++mpcZ3UoTQ7+cX/Q4i9XzvAbw9K/rc8UIdnJ9SMpN6g0gRRvrskorp6nP8xNSrLUBDfeZeG9J2qkt/sBSyTEysFhOsLe5jRiCBzMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MDNvs5uQ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MDNvs5uQ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66OEN2V301234639, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784902982; bh=sR2NMbbtnO/J/MdVm4ZczwAX/+MF3E6dpB0D7VjjaNI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=MDNvs5uQmR904CPvbSWkyFXZlDHoGlGUXwsWhDzBEUtFRY5qQrILaOjBIUHQbB39c
	 uypPxXQQ7WML7iDDjnVuupdgwzOQ7m/a5KbCtd/QpxvQsO/jstMvT469TvsaDCknwp
	 c7W62pZEyDmJoeC+lpqGyjie4wV/dwcLslA8BQ+uhgnq7uPHAx+bsTP/LComOaEYhb
	 ahaXW9eQg9jR2T0o/nBkcwknFuneFGSDjcfXMJ/1aADU5JISCSooL1T6AzObjaVHxO
	 t0nDJqwE6mko0PkXhwOCqcA1k6UJX2sGq0McUhK6Xqp/N+aFky7oZVCqpG4LoKHltC
	 und3FBLybWc8g==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66OEN2V301234639
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 22:23:02 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 22:23:02 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 22:23:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <phhuang@realtek.com>
Subject: [PATCH rtw-next 3/3] wifi: rtw89: change scan offload format to V3 for WiFi 7 IC
Date: Fri, 24 Jul 2026 22:22:46 +0800
Message-ID: <20260724142246.3195274-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260724142246.3195274-1-pkshih@realtek.com>
References: <20260724142246.3195274-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Po-Hao Huang <phhuang@realtek.com>

Adapt H2C formt to fit firmware version after 0.35.113.2, which
only supports active scanning with a provided SSID list.
Keep original style also to support older firmwares.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h |   4 +
 drivers/net/wireless/realtek/rtw89/fw.c   | 118 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw89/fw.h   |   1 +
 3 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 7573f1965c98..9e6e0b2b47da 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5700,6 +5700,7 @@ enum rtw89_fw_feature {
 	RTW89_FW_FEATURE_MACID_PAUSE_SLEEP,
 	RTW89_FW_FEATURE_SCAN_OFFLOAD_BE_V0,
 	RTW89_FW_FEATURE_SCAN_OFFLOAD_BE_V1,
+	RTW89_FW_FEATURE_SCAN_OFFLOAD_BE_V2,
 	RTW89_FW_FEATURE_WOW_REASON_V1,
 	RTW89_FW_FEATURE_GROUP(WITH_RFK_PRE_NOTIFY,
 			       RTW89_FW_FEATURE_RFK_PRE_NOTIFY_V0,
@@ -6894,6 +6895,9 @@ struct rtw89_hw_scan_info {
 	struct list_head chan_list;
 	struct rtw89_chan op_chan;
 	struct rtw89_hw_scan_extra_op extra_op;
+	u8 wildcard_pkt_id[NUM_NL80211_BANDS];
+	u16 ssid_total_len;
+	int n_ssids;
 	bool connected;
 	bool abort;
 	u16 delay; /* in unit of ms */
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 7d68ee870ed5..52ea1282f26e 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -934,6 +934,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8922A, ge, 0, 35, 100, 0, SER_POST_RECOVER_DMAC),
 	__CFG_FW_FEAT(RTL8922A, ge, 0, 35, 108, 0, SIM_SER_L0L1_BY_HALT_H2C),
 	__CFG_FW_FEAT(RTL8922A, lt, 0, 35, 109, 1, SCAN_OFFLOAD_BE_V1),
+	__CFG_FW_FEAT(RTL8922A, lt, 0, 35, 113, 2, SCAN_OFFLOAD_BE_V2),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 0, 0, 0, MACID_PAUSE_SLEEP),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 75, 2, SCAN_OFFLOAD),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 75, 2, BEACON_FILTER),
@@ -949,6 +950,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 108, 0, SIM_SER_L0L1_BY_HALT_H2C),
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 109, 1, SCAN_OFFLOAD_BE_V1),
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 113, 0, RFK_TXIQK_V0),
+	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 113, 2, SCAN_OFFLOAD_BE_V2),
 };
 
 static void rtw89_fw_iterate_feature_cfg(struct rtw89_fw_info *fw,
@@ -7365,6 +7367,7 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 	struct rtw89_h2c_chinfo_elem_be *elem;
 	struct rtw89_mac_chinfo_be *ch_info;
 	struct rtw89_h2c_chinfo_be *h2c;
+	bool wildcard_by_drv;
 	struct sk_buff *skb;
 	unsigned int cond;
 	u8 ver = U8_MAX;
@@ -7383,6 +7386,10 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 	if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V0, &rtwdev->fw))
 		ver = 0;
 
+	wildcard_by_drv = !(RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V0, &rtwdev->fw) ||
+			    RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V1, &rtwdev->fw) ||
+			    RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V2, &rtwdev->fw));
+
 	skb_put(skb, sizeof(*h2c));
 	h2c = (struct rtw89_h2c_chinfo_be *)skb->data;
 
@@ -7392,6 +7399,8 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 				  RTW89_H2C_CHINFO_ARG_MAC_IDX_MASK);
 
 	list_for_each_entry(ch_info, chan_list, list) {
+		bool with_probe_id = ch_info->probe_id != RTW89_SCANOFLD_PKT_NONE;
+
 		elem = (struct rtw89_h2c_chinfo_elem_be *)skb_put(skb, sizeof(*elem));
 
 		elem->w0 = le32_encode_bits(ch_info->dwell_time, RTW89_H2C_CHINFO_BE_W0_DWELL) |
@@ -7409,7 +7418,7 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 					    RTW89_H2C_CHINFO_BE_W1_RANDOM) |
 			   le32_encode_bits(ch_info->notify_action,
 					    RTW89_H2C_CHINFO_BE_W1_NOTIFY) |
-			   le32_encode_bits(ch_info->probe_id != 0xff ? 1 : 0,
+			   le32_encode_bits(wildcard_by_drv || with_probe_id,
 					    RTW89_H2C_CHINFO_BE_W1_PROBE) |
 			   le32_encode_bits(ch_info->leave_crit,
 					    RTW89_H2C_CHINFO_BE_W1_EARLY_LEAVE_CRIT) |
@@ -7574,6 +7583,27 @@ static void rtw89_scan_get_6g_disabled_chan(struct rtw89_dev *rtwdev,
 	}
 }
 
+static void rtw89_hw_scan_calc_req_ssid(struct rtw89_dev *rtwdev,
+					struct rtw89_vif_link *rtwvif_link)
+{
+	struct rtw89_hw_scan_info *scan_info = &rtwdev->scan_info;
+	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
+	struct cfg80211_scan_request *req = rtwvif->scan_req;
+	int i, num = 0;
+	u16 sum = 0;
+
+	for (i = 0; i < req->n_ssids; i++) {
+		if (req->ssids[i].ssid_len == 0)
+			continue;
+
+		num++;
+		sum += req->ssids[i].ssid_len + 1;
+	}
+
+	scan_info->n_ssids = num;
+	scan_info->ssid_total_len = sum;
+}
+
 int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 				 struct rtw89_scan_option *option,
 				 struct rtw89_vif_link *rtwvif_link,
@@ -7594,12 +7624,13 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 	struct sk_buff *skb;
 	u8 macc_role_size = sizeof(*macc_role) * option->num_macc_role;
 	u8 opch_size = sizeof(*opch) * option->num_opch;
+	u8 *probe_id = scan_info->wildcard_pkt_id;
 	enum rtw89_scan_be_opmode opmode;
-	u8 probe_id[NUM_NL80211_BANDS];
 	u8 scan_offload_ver = U8_MAX;
 	u8 cfg_len = sizeof(*h2c);
 	unsigned int cond;
 	u8 ver = U8_MAX;
+	u8 n_ssids = 0;
 	u8 policy_val;
 	void *ptr;
 	u8 txnull;
@@ -7621,9 +7652,14 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 	} else if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V1, &rtwdev->fw)) {
 		cfg_len = offsetofend(typeof(*h2c), w9);
 		scan_offload_ver = 1;
+	} else if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V2, &rtwdev->fw)) {
+		scan_offload_ver = 2;
 	}
 
 	len = cfg_len + macc_role_size + opch_size;
+	if (scan_offload_ver > 2)
+		len += scan_info->ssid_total_len;
+
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
 	if (!skb) {
 		rtw89_err(rtwdev, "failed to alloc skb for h2c scan offload\n");
@@ -7634,8 +7670,6 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 	h2c = (struct rtw89_h2c_scanofld_be *)skb->data;
 	ptr = skb->data;
 
-	memset(probe_id, RTW89_SCANOFLD_PKT_NONE, sizeof(probe_id));
-
 	if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V0, &rtwdev->fw))
 		ver = 0;
 
@@ -7667,7 +7701,10 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 		  le32_encode_bits(option->norm_cy, RTW89_H2C_SCANOFLD_BE_W2_NORM_CY) |
 		  le32_encode_bits(option->opch_end, RTW89_H2C_SCANOFLD_BE_W2_OPCH_END);
 
-	h2c->w3 = le32_encode_bits(0, RTW89_H2C_SCANOFLD_BE_W3_NUM_SSID) |
+	if (scan_offload_ver > 2)
+		n_ssids = scan_info->n_ssids;
+
+	h2c->w3 = le32_encode_bits(n_ssids, RTW89_H2C_SCANOFLD_BE_W3_NUM_SSID) |
 		  le32_encode_bits(0, RTW89_H2C_SCANOFLD_BE_W3_NUM_SHORT_SSID) |
 		  le32_encode_bits(0, RTW89_H2C_SCANOFLD_BE_W3_NUM_BSSID) |
 		  le32_encode_bits(probe_id[NL80211_BAND_2GHZ], RTW89_H2C_SCANOFLD_BE_W3_PROBEID);
@@ -7794,6 +7831,20 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 		ptr += sizeof(*opch);
 	}
 
+	if (scan_offload_ver <= 2)
+		goto set_hdr;
+
+	for (i = 0; i < req->n_ssids; i++) {
+		if (req->ssids[i].ssid_len == 0)
+			continue;
+
+		memcpy(ptr, &req->ssids[i].ssid_len, 1);
+		ptr++;
+		memcpy(ptr, req->ssids[i].ssid, req->ssids[i].ssid_len);
+		ptr += req->ssids[i].ssid_len;
+	}
+
+set_hdr:
 	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
 			      H2C_CAT_MAC, H2C_CL_MAC_FW_OFLD,
 			      H2C_FUNC_SCANOFLD_BE, 1, 1,
@@ -9123,14 +9174,19 @@ void rtw89_fw_st_dbg_dump(struct rtw89_dev *rtwdev)
 
 static void rtw89_hw_scan_release_pkt_list(struct rtw89_dev *rtwdev)
 {
+	struct rtw89_hw_scan_info *scan_info = &rtwdev->scan_info;
 	struct list_head *pkt_list = rtwdev->scan_info.pkt_list;
 	struct rtw89_pktofld_info *info, *tmp;
-	u8 idx;
+	u8 idx, wildcard_pkt_id;
 
 	for (idx = NL80211_BAND_2GHZ; idx < NUM_NL80211_BANDS; idx++) {
 		if (!(rtwdev->chip->support_bands & BIT(idx)))
 			continue;
 
+		wildcard_pkt_id = scan_info->wildcard_pkt_id[idx];
+		if (wildcard_pkt_id != RTW89_SCANOFLD_PKT_NONE)
+			rtw89_fw_h2c_del_pkt_offload(rtwdev, wildcard_pkt_id);
+
 		list_for_each_entry_safe(info, tmp, &pkt_list[idx], list) {
 			if (test_bit(info->id, rtwdev->pkt_offload))
 				rtw89_fw_h2c_del_pkt_offload(rtwdev, info->id);
@@ -9225,16 +9281,57 @@ static int rtw89_append_probe_req_ie(struct rtw89_dev *rtwdev,
 	return ret;
 }
 
+static int rtw89_hw_scan_append_wildcard_probe_req(struct rtw89_dev *rtwdev,
+						   struct rtw89_vif_link *rtwvif_link,
+						   const u8 *mac_addr)
+{
+	struct rtw89_hw_scan_info *scan_info = &rtwdev->scan_info;
+	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
+	struct cfg80211_scan_request *req = rtwvif->scan_req;
+	struct ieee80211_scan_ies *ies = rtwvif->scan_ies;
+	enum nl80211_band band;
+	struct sk_buff *skb;
+	int ret;
+	u8 id;
+
+	for (band = NL80211_BAND_2GHZ; band < NUM_NL80211_BANDS; band++) {
+		if (!(rtwdev->chip->support_bands & BIT(band)))
+			continue;
+
+		skb = ieee80211_probereq_get(rtwdev->hw, mac_addr,
+					     NULL, 0, req->ie_len);
+		if (!skb)
+			return -ENOMEM;
+
+		skb_put_data(skb, ies->ies[band], ies->len[band]);
+		skb_put_data(skb, ies->common_ies, ies->common_ie_len);
+
+		ret = rtw89_fw_h2c_add_pkt_offload(rtwdev, &id, skb);
+		kfree_skb(skb);
+
+		if (ret)
+			return ret;
+
+		scan_info->wildcard_pkt_id[band] = id;
+	}
+
+	return 0;
+}
+
 static int rtw89_hw_scan_update_probe_req(struct rtw89_dev *rtwdev,
 					  struct rtw89_vif_link *rtwvif_link,
 					  const u8 *mac_addr)
 {
 	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
 	struct cfg80211_scan_request *req = rtwvif->scan_req;
-	struct sk_buff *skb;
 	u8 num = req->n_ssids, i;
+	struct sk_buff *skb;
 	int ret;
 
+	ret = rtw89_hw_scan_append_wildcard_probe_req(rtwdev, rtwvif_link, mac_addr);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < num; i++) {
 		skb = ieee80211_probereq_get(rtwdev->hw, mac_addr,
 					     req->ssids[i].ssid,
@@ -9542,6 +9639,9 @@ static void rtw89_hw_scan_add_chan_be(struct rtw89_dev *rtwdev, int chan_type,
 			if (probe_count >= RTW89_SCANOFLD_MAX_SSID)
 				break;
 		}
+
+		if (scan_info->n_ssids)
+			ch_info->fw_probe0_ssids = GENMASK(scan_info->n_ssids - 1, 0);
 	}
 
 	if (ch_info->ch_band == RTW89_BAND_6G) {
@@ -10144,6 +10244,10 @@ int rtw89_hw_scan_start(struct rtw89_dev *rtwdev,
 	rtwdev->scan_info.delay = 0;
 	rtwvif->scan_ies = &scan_req->ies;
 	rtwvif->scan_req = req;
+	rtw89_hw_scan_calc_req_ssid(rtwdev, rtwvif_link);
+
+	memset(rtwdev->scan_info.wildcard_pkt_id, RTW89_SCANOFLD_PKT_NONE,
+	       sizeof(rtwdev->scan_info.wildcard_pkt_id));
 
 	if (req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR)
 		get_random_mask_addr(mac_addr, req->mac_addr,
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index e86014ca249a..f70b096a542d 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -3099,6 +3099,7 @@ struct rtw89_h2c_scanofld_be {
 	__le32 w11; /* Added after SCAN_OFFLOAD_BE_V2 */
 	/* struct rtw89_h2c_scanofld_be_macc_role (flexible number) */
 	/* struct rtw89_h2c_scanofld_be_opch (flexible number) */
+	/* probe SSID list (flexible number); Added after SCAN_OFFLOAD_BE_V3 */
 } __packed;
 
 #define RTW89_H2C_SCANOFLD_BE_W0_OP GENMASK(1, 0)
-- 
2.25.1

