Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F131453A3B
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544360; cv=none; b=e7h9CCxUE71Jm3JcB11NMuZAPvTGqWnE50wARmG64aE4N67l9ynVC2Ga4LEke4ad++cgZV7oLrNdwzGaX9vpTuFoee7mB00Dj7ZswvdAe0MFvmStFDsfE6arswaDuLJvFHDV+Q8l9Pvh83KDB1jHR0+6S/3/YPZ3ek0uuzHimgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544360; c=relaxed/simple;
	bh=+4lNS/xs06SWz0AQ07ocl9ncngIBBcEX8ZCtU7vqgXQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fN/VIqzQP54gywAWRI0wz4wSF6SLqkiyMZXLBmqHgUCc97qDHOeEQ2/H4oGQsZcqR+9Y6vwB8qFyHSAeIn07T7Jk/4QQi0JuP9XpfJla1XnHm+8nbGW5b59Mq4NjFdTsD6p1wKJv7P0/1r17VkCr4OrW9nncv67Y1VY02E6h6xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Hij9Tmsb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Hij9Tmsb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7d1DM12173108, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789544342; bh=yVv+lVaRJ1y4r4NxWhCod5y2/FSDkdNTfcbWfVSmKzI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=Hij9TmsbBxftPGj+6kp7THZBq5Ipm9BuP4VngxPGeILfQrBsi+aHWaNCgPPYyxW4c
	 PCeJ706AhqrimiZD08tyJRvnDbPXBQBW53CBCZXJJTkP4JtRyuBjMyzVgZNmOH3nfC
	 SQ3X0a7Gli4QmtcwsJF+zGGGk3PGw1Wd5NU8948brnpiNtAtCm4WBIyKRn9nxMBJfZ
	 OsfY9D4cA52TeYjwAyT8q9L7hI1OFw/f4IkCh5x7594zTrzU5H4u3PQYTUiD9Vq6Zg
	 aDn7aeOJ94LvEj2WaI5yJ/BbsYYAcyGUZP0J3WjGS3QO+zIwoatSlEDWuUm7a99Wi1
	 7C1qJ9t1n9z/g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7d1DM12173108
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 15:39:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:39:01 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:39:00 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:38:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>, <securelevelone@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw89: use one single BA CAM entry per MLD instead of per link
Date: Wed, 16 Sep 2026 15:38:31 +0800
Message-ID: <20260916073831.65809-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Previously each link took one BA CAM entry, and then when a MLD (MLSR)
switches the target link, the relation between old link and old BA CAM
entry got missing and could not correctly release the old BA CAM entry.
Besides, it would cause list_del corruption problems once BA CAM entry
replacing process was activated after all BA CAM entries were leaked.

Since HW supports to use single BA CAM entry per MLD, no need to maintain
multiple BA CAM entries across different links. So, set MLD_EN bit when a
MLD acquire a BA CAM entry and tweak the flow correspondingly.

Reported-by: Aiden Calloway <securelevelone@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CAH-fA9oS2N-D05BSd0DDp_hGtBEH==cLuxr1XCUiL_UC3CN+bg@mail.gmail.com/
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c     |  9 ++-
 drivers/net/wireless/realtek/rtw89/core.h     | 11 ++--
 drivers/net/wireless/realtek/rtw89/debug.c    |  7 ++-
 drivers/net/wireless/realtek/rtw89/fw.c       | 61 +++++++++++++------
 drivers/net/wireless/realtek/rtw89/fw.h       | 26 ++------
 drivers/net/wireless/realtek/rtw89/mac80211.c |  2 +
 drivers/net/wireless/realtek/rtw89/ser.c      |  4 +-
 7 files changed, 64 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index b074b3677c43..0c1c5c8ae8ce 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -5601,7 +5601,7 @@ void rtw89_core_release_all_bits_map(unsigned long *addr, unsigned int nbits)
 }
 
 int rtw89_core_acquire_sta_ba_entry(struct rtw89_dev *rtwdev,
-				    struct rtw89_sta_link *rtwsta_link, u8 tid,
+				    struct rtw89_sta *rtwsta, u8 tid,
 				    u8 *cam_idx)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
@@ -5639,7 +5639,7 @@ int rtw89_core_acquire_sta_ba_entry(struct rtw89_dev *rtwdev,
 	}
 
 	entry->tid = tid;
-	list_add_tail(&entry->list, &rtwsta_link->ba_cam_list);
+	list_add_tail(&entry->list, &rtwsta->ba_cam_list);
 
 	*cam_idx = idx;
 
@@ -5647,7 +5647,7 @@ int rtw89_core_acquire_sta_ba_entry(struct rtw89_dev *rtwdev,
 }
 
 int rtw89_core_release_sta_ba_entry(struct rtw89_dev *rtwdev,
-				    struct rtw89_sta_link *rtwsta_link, u8 tid,
+				    struct rtw89_sta *rtwsta, u8 tid,
 				    u8 *cam_idx)
 {
 	struct rtw89_cam_info *cam_info = &rtwdev->cam_info;
@@ -5656,7 +5656,7 @@ int rtw89_core_release_sta_ba_entry(struct rtw89_dev *rtwdev,
 
 	lockdep_assert_wiphy(rtwdev->hw->wiphy);
 
-	list_for_each_entry_safe(entry, tmp, &rtwsta_link->ba_cam_list, list) {
+	list_for_each_entry_safe(entry, tmp, &rtwsta->ba_cam_list, list) {
 		if (entry->tid != tid)
 			continue;
 
@@ -5751,7 +5751,6 @@ int rtw89_core_sta_link_add(struct rtw89_dev *rtwdev,
 	int ret;
 
 	rtwsta_link->prev_rssi = 0;
-	INIT_LIST_HEAD(&rtwsta_link->ba_cam_list);
 	ewma_rssi_init(&rtwsta_link->avg_rssi);
 	ewma_snr_init(&rtwsta_link->avg_snr);
 	ewma_evm_init(&rtwsta_link->evm_1ss);
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 2e6d1be3a751..db1a8179e597 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4638,7 +4638,6 @@ struct rtw89_sta_link {
 	__le32 htc_template;
 	struct rtw89_addr_cam_entry addr_cam; /* AP mode or TDLS peer only */
 	struct rtw89_bssid_cam_entry bssid_cam; /* TDLS peer only */
-	struct list_head ba_cam_list;
 
 	bool use_cfg_mask;
 	struct cfg80211_bitrate_mask mask;
@@ -4989,9 +4988,7 @@ struct rtw89_chip_ops {
 				    struct rtw89_sta_link *rtwsta_link);
 	int (*h2c_update_beacon)(struct rtw89_dev *rtwdev,
 				 struct rtw89_vif_link *rtwvif_link);
-	int (*h2c_ba_cam)(struct rtw89_dev *rtwdev,
-			  struct rtw89_vif_link *rtwvif_link,
-			  struct rtw89_sta_link *rtwsta_link,
+	int (*h2c_ba_cam)(struct rtw89_dev *rtwdev, struct rtw89_sta *rtwsta,
 			  bool valid, struct ieee80211_ampdu_params *params);
 	int (*h2c_wow_cam_update)(struct rtw89_dev *rtwdev,
 				  struct rtw89_wow_cam_info *cam_info);
@@ -7778,6 +7775,8 @@ struct rtw89_sta {
 	struct rtw89_tid_stats tid_rx_stats[IEEE80211_NUM_TIDS];
 	DECLARE_BITMAP(ampdu_map, IEEE80211_NUM_TIDS);
 
+	struct list_head ba_cam_list;
+
 	DECLARE_BITMAP(pairwise_sec_cam_map, RTW89_MAX_SEC_CAM_NUM);
 
 	struct list_head dlink_pool;
@@ -9339,10 +9338,10 @@ u8 rtw89_core_acquire_bit_map(unsigned long *addr, unsigned long size);
 void rtw89_core_release_bit_map(unsigned long *addr, u8 bit);
 void rtw89_core_release_all_bits_map(unsigned long *addr, unsigned int nbits);
 int rtw89_core_acquire_sta_ba_entry(struct rtw89_dev *rtwdev,
-				    struct rtw89_sta_link *rtwsta_link, u8 tid,
+				    struct rtw89_sta *rtwsta, u8 tid,
 				    u8 *cam_idx);
 int rtw89_core_release_sta_ba_entry(struct rtw89_dev *rtwdev,
-				    struct rtw89_sta_link *rtwsta_link, u8 tid,
+				    struct rtw89_sta *rtwsta, u8 tid,
 				    u8 *cam_idx);
 void rtw89_core_free_sta_pending_ba(struct rtw89_dev *rtwdev,
 				    struct ieee80211_sta *sta);
diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 2417381bca1c..3a430bd082c3 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -4642,13 +4642,13 @@ void rtw89_vif_ids_get_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 
 static int rtw89_dump_ba_cam(struct rtw89_dev *rtwdev,
 			     char *buf, size_t bufsz,
-			     struct rtw89_sta_link *rtwsta_link)
+			     struct rtw89_sta *rtwsta)
 {
 	struct rtw89_ba_cam_entry *entry;
 	char *p = buf, *end = buf + bufsz;
 	bool first = true;
 
-	list_for_each_entry(entry, &rtwsta_link->ba_cam_list, list) {
+	list_for_each_entry(entry, &rtwsta->ba_cam_list, list) {
 		if (first) {
 			p += scnprintf(p, end - p, "\tba_cam ");
 			first = false;
@@ -4683,7 +4683,6 @@ static int rtw89_sta_link_ids_get(struct rtw89_dev *rtwdev,
 	p += scnprintf(p, end - p, "\tlink_id=%u%s\n", rtwsta_link->link_id,
 		       designated ? " (*)" : "");
 	p += rtw89_dump_addr_cam(rtwdev, p, end - p, &rtwsta_link->addr_cam);
-	p += rtw89_dump_ba_cam(rtwdev, p, end - p, rtwsta_link);
 
 	return p - buf;
 }
@@ -4705,6 +4704,8 @@ static void rtw89_sta_ids_get_iter(void *data, struct ieee80211_sta *sta)
 
 	p += scnprintf(p, end - p, "STA %pM %s\n", sta->addr,
 		       sta->tdls ? "(TDLS)" : "");
+	p += rtw89_dump_ba_cam(rtwdev, p, end - p, rtwsta);
+
 	rtw89_sta_for_each_link(rtwsta, rtwsta_link, link_id)
 		p += rtw89_sta_link_ids_get(rtwdev, p, end - p, rtwsta_link,
 					    rtwsta_link == designated_link);
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 63dd918b0989..fa30543a8b42 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2606,23 +2606,28 @@ int rtw89_fw_h2c_default_dmac_tbl_v3(struct rtw89_dev *rtwdev,
 }
 EXPORT_SYMBOL(rtw89_fw_h2c_default_dmac_tbl_v3);
 
-int rtw89_fw_h2c_ba_cam(struct rtw89_dev *rtwdev,
-			struct rtw89_vif_link *rtwvif_link,
-			struct rtw89_sta_link *rtwsta_link,
+int rtw89_fw_h2c_ba_cam(struct rtw89_dev *rtwdev, struct rtw89_sta *rtwsta,
 			bool valid, struct ieee80211_ampdu_params *params)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
+	struct rtw89_vif_link *rtwvif_link;
+	struct rtw89_sta_link *rtwsta_link;
 	struct rtw89_h2c_ba_cam *h2c;
-	u8 macid = rtwsta_link->mac_id;
 	u32 len = sizeof(*h2c);
 	struct sk_buff *skb;
 	u8 entry_idx;
+	u8 macid;
 	int ret;
 
+	rtwsta_link = rtw89_get_designated_link(rtwsta);
+	rtwvif_link = rtwsta_link->rtwvif_link;
+
+	macid = rtwsta_link->mac_id;
+
 	ret = valid ?
-	      rtw89_core_acquire_sta_ba_entry(rtwdev, rtwsta_link, params->tid,
+	      rtw89_core_acquire_sta_ba_entry(rtwdev, rtwsta, params->tid,
 					      &entry_idx) :
-	      rtw89_core_release_sta_ba_entry(rtwdev, rtwsta_link, params->tid,
+	      rtw89_core_release_sta_ba_entry(rtwdev, rtwsta, params->tid,
 					      &entry_idx);
 	if (ret) {
 		/* it still works even if we don't have static BA CAM, because
@@ -2741,24 +2746,33 @@ void rtw89_fw_h2c_init_dynamic_ba_cam_v0_ext(struct rtw89_dev *rtwdev)
 	}
 }
 
-int rtw89_fw_h2c_ba_cam_v1(struct rtw89_dev *rtwdev,
-			   struct rtw89_vif_link *rtwvif_link,
-			   struct rtw89_sta_link *rtwsta_link,
+int rtw89_fw_h2c_ba_cam_v1(struct rtw89_dev *rtwdev, struct rtw89_sta *rtwsta,
 			   bool valid, struct ieee80211_ampdu_params *params)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
+	struct rtw89_vif_link *rtwvif_link;
+	struct rtw89_sta_link *rtwsta_link;
 	struct rtw89_h2c_ba_cam_v1 *h2c;
-	u8 macid = rtwsta_link->mac_id;
+	struct ieee80211_vif *vif;
 	u32 len = sizeof(*h2c);
 	struct sk_buff *skb;
 	u8 entry_idx;
 	u8 bmap_size;
+	bool is_mld;
+	u8 macid;
 	int ret;
 
+	rtwsta_link = rtw89_get_designated_link(rtwsta);
+	rtwvif_link = rtwsta_link->rtwvif_link;
+	vif = rtwvif_link_to_vif(rtwvif_link);
+
+	macid = rtwsta_link->mac_id;
+	is_mld = ieee80211_vif_is_mld(vif);
+
 	ret = valid ?
-	      rtw89_core_acquire_sta_ba_entry(rtwdev, rtwsta_link, params->tid,
+	      rtw89_core_acquire_sta_ba_entry(rtwdev, rtwsta, params->tid,
 					      &entry_idx) :
-	      rtw89_core_release_sta_ba_entry(rtwdev, rtwsta_link, params->tid,
+	      rtw89_core_release_sta_ba_entry(rtwdev, rtwsta, params->tid,
 					      &entry_idx);
 	if (ret) {
 		/* it still works even if we don't have static BA CAM, because
@@ -2797,6 +2811,7 @@ int rtw89_fw_h2c_ba_cam_v1(struct rtw89_dev *rtwdev,
 	entry_idx += chip->bacam_dynamic_num; /* std entry right after dynamic ones */
 	h2c->w1 = le32_encode_bits(entry_idx, RTW89_H2C_BA_CAM_V1_W1_ENTRY_IDX_MASK) |
 		  le32_encode_bits(1, RTW89_H2C_BA_CAM_V1_W1_STD_ENTRY_EN) |
+		  le32_encode_bits(is_mld, RTW89_H2C_BA_CAM_V1_W1_MLD_EN) |
 		  le32_encode_bits(!!rtwvif_link->mac_idx,
 				   RTW89_H2C_BA_CAM_V1_W1_BAND_SEL);
 
@@ -2820,24 +2835,33 @@ int rtw89_fw_h2c_ba_cam_v1(struct rtw89_dev *rtwdev,
 }
 EXPORT_SYMBOL(rtw89_fw_h2c_ba_cam_v1);
 
-int rtw89_fw_h2c_ba_cam_g7(struct rtw89_dev *rtwdev,
-			   struct rtw89_vif_link *rtwvif_link,
-			   struct rtw89_sta_link *rtwsta_link,
+int rtw89_fw_h2c_ba_cam_g7(struct rtw89_dev *rtwdev, struct rtw89_sta *rtwsta,
 			   bool valid, struct ieee80211_ampdu_params *params)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
+	struct rtw89_vif_link *rtwvif_link;
+	struct rtw89_sta_link *rtwsta_link;
 	struct rtw89_h2c_ba_cam_g7 *h2c;
-	u16 macid = rtwsta_link->mac_id;
+	struct ieee80211_vif *vif;
 	u32 len = sizeof(*h2c);
 	struct sk_buff *skb;
 	u8 entry_idx;
 	u8 bmap_size;
+	bool is_mld;
+	u16 macid;
 	int ret;
 
+	rtwsta_link = rtw89_get_designated_link(rtwsta);
+	rtwvif_link = rtwsta_link->rtwvif_link;
+	vif = rtwvif_link_to_vif(rtwvif_link);
+
+	macid = rtwsta_link->mac_id;
+	is_mld = ieee80211_vif_is_mld(vif);
+
 	ret = valid ?
-	      rtw89_core_acquire_sta_ba_entry(rtwdev, rtwsta_link, params->tid,
+	      rtw89_core_acquire_sta_ba_entry(rtwdev, rtwsta, params->tid,
 					      &entry_idx) :
-	      rtw89_core_release_sta_ba_entry(rtwdev, rtwsta_link, params->tid,
+	      rtw89_core_release_sta_ba_entry(rtwdev, rtwsta, params->tid,
 					      &entry_idx);
 	if (ret) {
 		/*
@@ -2871,6 +2895,7 @@ int rtw89_fw_h2c_ba_cam_g7(struct rtw89_dev *rtwdev,
 		  le32_encode_bits(1, RTW89_H2C_BA_CAM_G7_W0_INIT_REQ) |
 		  le32_encode_bits(params->tid, RTW89_H2C_BA_CAM_G7_W0_TID_MASK) |
 		  le32_encode_bits(1, RTW89_H2C_BA_CAM_G7_W0_STD_ENTRY_EN) |
+		  le32_encode_bits(is_mld, RTW89_H2C_BA_CAM_G7_W0_MLD_EN) |
 		  le32_encode_bits(!!rtwvif_link->mac_idx,
 				   RTW89_H2C_BA_CAM_G7_W0_BAND_SEL) |
 		  le32_encode_bits(bmap_size, RTW89_H2C_BA_CAM_G7_W0_BMAP_SIZE_MASK) |
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index a15a5967cabc..9ab21d6afcf3 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -5593,17 +5593,11 @@ void rtw89_fw_release_general_pkt_list_vif(struct rtw89_dev *rtwdev,
 					   struct rtw89_vif_link *rtwvif_link,
 					   bool notify_fw);
 void rtw89_fw_release_general_pkt_list(struct rtw89_dev *rtwdev, bool notify_fw);
-int rtw89_fw_h2c_ba_cam(struct rtw89_dev *rtwdev,
-			struct rtw89_vif_link *rtwvif_link,
-			struct rtw89_sta_link *rtwsta_link,
+int rtw89_fw_h2c_ba_cam(struct rtw89_dev *rtwdev, struct rtw89_sta *rtwsta,
 			bool valid, struct ieee80211_ampdu_params *params);
-int rtw89_fw_h2c_ba_cam_v1(struct rtw89_dev *rtwdev,
-			   struct rtw89_vif_link *rtwvif_link,
-			   struct rtw89_sta_link *rtwsta_link,
+int rtw89_fw_h2c_ba_cam_v1(struct rtw89_dev *rtwdev, struct rtw89_sta *rtwsta,
 			   bool valid, struct ieee80211_ampdu_params *params);
-int rtw89_fw_h2c_ba_cam_g7(struct rtw89_dev *rtwdev,
-			   struct rtw89_vif_link *rtwvif_link,
-			   struct rtw89_sta_link *rtwsta_link,
+int rtw89_fw_h2c_ba_cam_g7(struct rtw89_dev *rtwdev, struct rtw89_sta *rtwsta,
 			   bool valid, struct ieee80211_ampdu_params *params);
 void rtw89_fw_h2c_init_dynamic_ba_cam_v0_ext(struct rtw89_dev *rtwdev);
 int rtw89_fw_h2c_init_ba_cam_users(struct rtw89_dev *rtwdev, u8 users,
@@ -5845,20 +5839,8 @@ int rtw89_chip_h2c_ba_cam(struct rtw89_dev *rtwdev, struct rtw89_sta *rtwsta,
 			  bool valid, struct ieee80211_ampdu_params *params)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
-	struct rtw89_vif_link *rtwvif_link;
-	struct rtw89_sta_link *rtwsta_link;
-	unsigned int link_id;
-	int ret;
-
-	rtw89_sta_for_each_link(rtwsta, rtwsta_link, link_id) {
-		rtwvif_link = rtwsta_link->rtwvif_link;
-		ret = chip->ops->h2c_ba_cam(rtwdev, rtwvif_link, rtwsta_link,
-					    valid, params);
-		if (ret)
-			return ret;
-	}
 
-	return 0;
+	return chip->ops->h2c_ba_cam(rtwdev, rtwsta, valid, params);
 }
 
 static inline
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index cf356a54d91c..9e6cafc492c4 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -519,6 +519,8 @@ static int __rtw89_ops_sta_add(struct rtw89_dev *rtwdev,
 	INIT_LIST_HEAD(&rtwsta->dlink_pool);
 
 	skb_queue_head_init(&rtwsta->roc_queue);
+
+	INIT_LIST_HEAD(&rtwsta->ba_cam_list);
 	bitmap_zero(rtwsta->pairwise_sec_cam_map, RTW89_MAX_SEC_CAM_NUM);
 
 	rtwsta_link = rtw89_sta_set_link(rtwsta, sta->deflink.link_id);
diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index a507ce1fcd63..701440bd7be1 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -327,6 +327,8 @@ static void ser_sta_deinit_cam_iter(void *data, struct ieee80211_sta *sta)
 	if (rtwvif != target_rtwvif)
 		return;
 
+	INIT_LIST_HEAD(&rtwsta->ba_cam_list);
+
 	rtw89_sta_for_each_link(rtwsta, rtwsta_link, link_id) {
 		rtwvif_link = rtwsta_link->rtwvif_link;
 
@@ -334,8 +336,6 @@ static void ser_sta_deinit_cam_iter(void *data, struct ieee80211_sta *sta)
 			rtw89_cam_deinit_addr_cam(rtwdev, &rtwsta_link->addr_cam);
 		if (sta->tdls)
 			rtw89_cam_deinit_bssid_cam(rtwdev, &rtwsta_link->bssid_cam);
-
-		INIT_LIST_HEAD(&rtwsta_link->ba_cam_list);
 	}
 }
 

base-commit: 73e3b1c94c7d5b4a113e7cbb42665dc2fe3b9d78
-- 
2.25.1

