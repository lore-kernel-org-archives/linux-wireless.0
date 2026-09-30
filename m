Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5969640BCC8
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 06:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790750791; cv=none; b=HNZ3IzLN+K//sucUTIbAoU7yxu3cu8jGpR6c+DeOCYU8kMRQ9TfTv2ru38W2Y78qfQPkyc6ejTUEDsECqoABMlVrBBdXtr441/iJovqfpoZaGOMl3dVohRgviMclj8zeGevNR9CZx/a7kSdTye7QQBpB16UfX8NFLs1sPcP8pBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790750791; c=relaxed/simple;
	bh=gFZLIC5rxFwqaFUdQUKlKCKq7aeoC8ELAKmf1zOL+2I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZkPUz2lDTdN88bSX/+fEPgtPsIDdV9lfYw539bLk8FLg1XFPLKj51QwFULJNz98+sNN2wt0obuMoyxPhlTeUDqb6A80286mVJl0kUc2RdpcNCEmE9UPMphFpGGqcL9m1JpyLeNatj+q5pimPQViKixjrSW0Dobc1h3xLe8rlHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mTOdRmSX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mTOdRmSX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U6kL6e91882974, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790750781; bh=Be1zOUBD+56vfvXuuTjFZ92lEZUI23cymViqy7hU/sg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=mTOdRmSXh5HwfXSkL50OYX7rqqcrBgW/6tg7sk5g011EdqmgyCbw9sKSecnRfA/jg
	 BuoRYWCHj4Xe6Abz09AYu5sKEhKzNdqVtISva+y6UOlSAdQ/NAGP2UHktFRtaOcnb1
	 bsb8Cvv2rKt9uVUtJuczLPsDMOjPZ/WFobYDqGYyvxmt4+WA+KXC1R3wsk7cp5rwEs
	 PsXvkxNFTp7AUWf2jgN9DUbyWcX2x1b5OjpDdpV4V0A3M76jAUKXeToaaMZT//lz+Z
	 +Ymu4KoV5Pu2N/GxzUUkC82UvEyDjMV5sI3/1w/7eyJo9UIXEd+h1kkWB5aACq8fUr
	 vAKYsMJcdQ2uw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U6kL6e91882974
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:46:21 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:22 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:21 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 14:46:21 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>,
	<wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 3/6] wifi: rtw89: rx: refine skb/desc naming to improve readability
Date: Wed, 30 Sep 2026 14:45:21 +0800
Message-ID: <20260930064524.39403-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260930064524.39403-1-pkshih@realtek.com>
References: <20260930064524.39403-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

In rx path, there are skb of Wi-Fi and skb of PPDU. However, skb_ppdu was
used in some places for Wi-Fi skb. It was a bit confused. So, refine the
naming as follow-up. Call skb for skb of Wi-Fi, and call skb_ppdu for skb
of PPDU. Besides, call desc_ppdu for rx_desc_info of PPDU.

(No logic is changed.)

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 90 +++++++++++------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 2a1f54e9664a..0ae5aff8a122 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1945,11 +1945,11 @@ void rtw89_core_fill_txdesc_fwcmd_v2(struct rtw89_dev *rtwdev,
 EXPORT_SYMBOL(rtw89_core_fill_txdesc_fwcmd_v2);
 
 static int rtw89_core_rx_process_mac_ppdu(struct rtw89_dev *rtwdev,
-					  struct sk_buff *skb,
+					  struct sk_buff *skb_ppdu,
 					  struct rtw89_rx_phy_ppdu *phy_ppdu)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
-	const struct rtw89_rxinfo *rxinfo = (const struct rtw89_rxinfo *)skb->data;
+	const struct rtw89_rxinfo *rxinfo = (const struct rtw89_rxinfo *)skb_ppdu->data;
 	const struct rtw89_rxinfo_user *user;
 	enum rtw89_chip_gen chip_gen = rtwdev->chip->chip_gen;
 	int rx_cnt_size = RTW89_PPDU_MAC_RX_CNT_SIZE;
@@ -2003,7 +2003,7 @@ static int rtw89_core_rx_process_mac_ppdu(struct rtw89_dev *rtwdev,
 		break;
 	}
 
-	phy_sts = skb->data + RTW89_PPDU_MAC_INFO_SIZE;
+	phy_sts = skb_ppdu->data + RTW89_PPDU_MAC_INFO_SIZE;
 	phy_sts += usr_num * RTW89_PPDU_MAC_INFO_USR_SIZE;
 	/* 8-byte alignment */
 	if (usr_num & BIT(0))
@@ -2012,11 +2012,11 @@ static int rtw89_core_rx_process_mac_ppdu(struct rtw89_dev *rtwdev,
 		phy_sts += rx_cnt_size;
 	phy_sts += plcp_size;
 
-	if (phy_sts > skb->data + skb->len)
+	if (phy_sts > skb_ppdu->data + skb_ppdu->len)
 		return -EINVAL;
 
 	phy_ppdu->buf = phy_sts;
-	phy_ppdu->len = skb->data + skb->len - phy_sts;
+	phy_ppdu->len = skb_ppdu->data + skb_ppdu->len - phy_sts;
 
 	return 0;
 }
@@ -2443,16 +2443,16 @@ bool rtw89_check_rx_statu_gi_match(struct ieee80211_rx_status *status, u8 gi_ltf
 }
 
 static bool rtw89_core_rx_ppdu_match(struct rtw89_dev *rtwdev,
-				     struct rtw89_rx_desc_info *desc_info,
+				     struct rtw89_rx_desc_info *desc_ppdu,
 				     struct ieee80211_rx_status *status)
 {
-	u8 band = desc_info->bb_sel ? RTW89_PHY_1 : RTW89_PHY_0;
+	u8 band = desc_ppdu->bb_sel ? RTW89_PHY_1 : RTW89_PHY_0;
 	u8 data_rate_mode, bw, rate_idx = MASKBYTE0, gi_ltf;
 	bool eht = false;
 	u16 data_rate;
 	bool ret;
 
-	data_rate = desc_info->data_rate;
+	data_rate = desc_ppdu->data_rate;
 	data_rate_mode = rtw89_get_data_rate_mode(rtwdev, data_rate);
 	if (data_rate_mode == DATA_RATE_MODE_NON_HT) {
 		rate_idx = rtw89_get_data_not_ht_idx(rtwdev, data_rate);
@@ -2468,9 +2468,9 @@ static bool rtw89_core_rx_ppdu_match(struct rtw89_dev *rtwdev,
 	}
 
 	eht = data_rate_mode == DATA_RATE_MODE_EHT;
-	bw = rtw89_hw_to_rate_info_bw(desc_info->bw);
-	gi_ltf = rtw89_rxdesc_to_nl_he_eht_gi(rtwdev, desc_info->gi_ltf, false, eht);
-	ret = rtwdev->ppdu_sts.curr_rx_ppdu_cnt[band] == desc_info->ppdu_cnt &&
+	bw = rtw89_hw_to_rate_info_bw(desc_ppdu->bw);
+	gi_ltf = rtw89_rxdesc_to_nl_he_eht_gi(rtwdev, desc_ppdu->gi_ltf, false, eht);
+	ret = rtwdev->ppdu_sts.curr_rx_ppdu_cnt[band] == desc_ppdu->ppdu_cnt &&
 	      status->rate_idx == rate_idx &&
 	      rtw89_check_rx_statu_gi_match(status, gi_ltf, eht) &&
 	      status->bw == bw;
@@ -4005,7 +4005,7 @@ static bool rtw89_core_skb_pn_valid(struct rtw89_dev *rtwdev,
 static void rtw89_core_rx_to_mac80211(struct rtw89_dev *rtwdev,
 				      struct rtw89_rx_phy_ppdu *phy_ppdu,
 				      struct rtw89_rx_desc_info *desc_info,
-				      struct sk_buff *skb_ppdu,
+				      struct sk_buff *skb,
 				      struct ieee80211_rx_status *rx_status)
 {
 	struct napi_struct *napi = &rtwdev->napi;
@@ -4015,57 +4015,57 @@ static void rtw89_core_rx_to_mac80211(struct rtw89_dev *rtwdev,
 		napi = NULL;
 
 	rtw89_core_hw_to_sband_rate(rx_status);
-	rtw89_core_rx_stats(rtwdev, phy_ppdu, desc_info, skb_ppdu);
+	rtw89_core_rx_stats(rtwdev, phy_ppdu, desc_info, skb);
 	rtw89_core_update_rx_status_by_ppdu(rtwdev, rx_status, phy_ppdu);
-	rtw89_core_update_radiotap(rtwdev, desc_info, skb_ppdu, rx_status, phy_ppdu);
+	rtw89_core_update_radiotap(rtwdev, desc_info, skb, rx_status, phy_ppdu);
 	rtw89_core_validate_rx_signal(rx_status);
-	rtw89_core_update_rx_freq_from_ie(rtwdev, skb_ppdu, rx_status);
+	rtw89_core_update_rx_freq_from_ie(rtwdev, skb, rx_status);
 	rtw89_core_correct_mcc_chan(rtwdev, desc_info, rx_status, phy_ppdu);
 
 	/* In low power mode, it does RX in thread context. */
 	local_bh_disable();
-	ieee80211_rx_napi(rtwdev->hw, NULL, skb_ppdu, napi);
+	ieee80211_rx_napi(rtwdev->hw, NULL, skb, napi);
 	local_bh_enable();
 	rtwdev->napi_budget_countdown--;
 }
 
 static void rtw89_core_rx_pending_skb(struct rtw89_dev *rtwdev,
 				      struct rtw89_rx_phy_ppdu *phy_ppdu,
-				      struct rtw89_rx_desc_info *desc_info,
-				      struct sk_buff *skb)
+				      struct rtw89_rx_desc_info *desc_ppdu,
+				      struct sk_buff *skb_ppdu)
 {
-	u8 band = desc_info->bb_sel ? RTW89_PHY_1 : RTW89_PHY_0;
+	u8 band = desc_ppdu->bb_sel ? RTW89_PHY_1 : RTW89_PHY_0;
 	int curr = rtwdev->ppdu_sts.curr_rx_ppdu_cnt[band];
-	struct sk_buff *skb_ppdu = NULL, *tmp;
+	struct sk_buff *skb = NULL, *tmp;
 	struct ieee80211_rx_status *rx_status;
 
 	if (curr > RTW89_MAX_PPDU_CNT)
 		return;
 
-	skb_queue_walk_safe(&rtwdev->ppdu_sts.rx_queue[band], skb_ppdu, tmp) {
-		skb_unlink(skb_ppdu, &rtwdev->ppdu_sts.rx_queue[band]);
-		rx_status = IEEE80211_SKB_RXCB(skb_ppdu);
-		if (rtw89_core_rx_ppdu_match(rtwdev, desc_info, rx_status))
+	skb_queue_walk_safe(&rtwdev->ppdu_sts.rx_queue[band], skb, tmp) {
+		skb_unlink(skb, &rtwdev->ppdu_sts.rx_queue[band]);
+		rx_status = IEEE80211_SKB_RXCB(skb);
+		if (rtw89_core_rx_ppdu_match(rtwdev, desc_ppdu, rx_status))
 			rtw89_chip_query_ppdu(rtwdev, phy_ppdu, rx_status);
 		rtw89_correct_cck_chan(rtwdev, rx_status);
-		rtw89_core_rx_to_mac80211(rtwdev, phy_ppdu, desc_info, skb_ppdu, rx_status);
+		rtw89_core_rx_to_mac80211(rtwdev, phy_ppdu, desc_ppdu, skb, rx_status);
 	}
 }
 
 static void rtw89_core_rx_process_ppdu_sts(struct rtw89_dev *rtwdev,
-					   struct rtw89_rx_desc_info *desc_info,
-					   struct sk_buff *skb)
-{
-	struct rtw89_rx_phy_ppdu phy_ppdu = {.buf = skb->data, .valid = false,
-					     .len = skb->len,
-					     .to_self = desc_info->addr1_match,
-					     .rate = desc_info->data_rate,
-					     .mac_id = desc_info->mac_id,
-					     .phy_idx = desc_info->bb_sel};
+					   struct rtw89_rx_desc_info *desc_ppdu,
+					   struct sk_buff *skb_ppdu)
+{
+	struct rtw89_rx_phy_ppdu phy_ppdu = {.buf = skb_ppdu->data, .valid = false,
+					     .len = skb_ppdu->len,
+					     .to_self = desc_ppdu->addr1_match,
+					     .rate = desc_ppdu->data_rate,
+					     .mac_id = desc_ppdu->mac_id,
+					     .phy_idx = desc_ppdu->bb_sel};
 	int ret;
 
-	if (desc_info->mac_info_valid) {
-		ret = rtw89_core_rx_process_mac_ppdu(rtwdev, skb, &phy_ppdu);
+	if (desc_ppdu->mac_info_valid) {
+		ret = rtw89_core_rx_process_mac_ppdu(rtwdev, skb_ppdu, &phy_ppdu);
 		if (ret)
 			goto out;
 	}
@@ -4077,8 +4077,8 @@ static void rtw89_core_rx_process_ppdu_sts(struct rtw89_dev *rtwdev,
 	rtw89_core_rx_process_phy_sts(rtwdev, &phy_ppdu);
 
 out:
-	rtw89_core_rx_pending_skb(rtwdev, &phy_ppdu, desc_info, skb);
-	dev_kfree_skb_any(skb);
+	rtw89_core_rx_pending_skb(rtwdev, &phy_ppdu, desc_ppdu, skb_ppdu);
+	dev_kfree_skb_any(skb_ppdu);
 }
 
 static void rtw89_core_rx_process_report(struct rtw89_dev *rtwdev,
@@ -4476,24 +4476,24 @@ static void rtw89_core_flush_ppdu_rx_queue(struct rtw89_dev *rtwdev,
 	struct rtw89_ppdu_sts_info *ppdu_sts = &rtwdev->ppdu_sts;
 	u8 band = desc_info->bb_sel ? RTW89_PHY_1 : RTW89_PHY_0;
 	struct ieee80211_rx_status *rx_status;
-	struct sk_buff *skb_ppdu, *tmp;
+	struct sk_buff *skb, *tmp;
 
-	skb_queue_walk_safe(&ppdu_sts->rx_queue[band], skb_ppdu, tmp) {
-		skb_unlink(skb_ppdu, &ppdu_sts->rx_queue[band]);
-		rx_status = IEEE80211_SKB_RXCB(skb_ppdu);
-		rtw89_core_rx_to_mac80211(rtwdev, NULL, desc_info, skb_ppdu, rx_status);
+	skb_queue_walk_safe(&ppdu_sts->rx_queue[band], skb, tmp) {
+		skb_unlink(skb, &ppdu_sts->rx_queue[band]);
+		rx_status = IEEE80211_SKB_RXCB(skb);
+		rtw89_core_rx_to_mac80211(rtwdev, NULL, desc_info, skb, rx_status);
 	}
 }
 
 static
 void rtw89_core_rx_pkt_hdl(struct rtw89_dev *rtwdev, const struct sk_buff *skb,
-			   const struct rtw89_rx_desc_info *desc)
+			   const struct rtw89_rx_desc_info *desc_info)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct rtw89_sta_link *rtwsta_link;
 	struct ieee80211_sta *sta;
 	struct rtw89_sta *rtwsta;
-	u8 macid = desc->mac_id;
+	u8 macid = desc_info->mac_id;
 
 	if (!refcount_read(&rtwdev->refcount_ap_info))
 		return;
-- 
2.25.1

