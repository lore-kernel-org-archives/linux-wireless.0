Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97923BB134
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937289; cv=none; b=Po0C9o7KNy+rMegEtYgJXF0wPIotnevCb00pwzFdmHBCs4/4EWoITujf8X1kWgqK4IcBiCLzZhkvUdIWuAEGIojQBEu5c2gAnn5pzM9RykbnfksJJuDdtoeaHK7lUqg23IflacEdDwnwhRDHWGU0ps/k0FHSIAeQLjdmPfwEfuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937289; c=relaxed/simple;
	bh=zdJ6gOFESBqkEAZGbI9F5W/Na+N5SgMSKk9oZY/19XQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FGz6CmwbEQykvV+Q/38hAICfGOvtolbg/3fwUyMQlk2gKDtRDLQdGr/FZWdVKVgI8LLKcYJpYQTGV3Kcovu8hlQOroFrMCstVDtAlglqgr1MnwyHW4R1LPfQz0pp4kTcziRNszhUrtqjI6sGB/Cem4FyEsiKIkZF1nUBc8vv55c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OLObjVPa; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OLObjVPa"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68971MjjC356872, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937282; bh=LuQ5yV6iPwi49UBzzSs6bCRQLOV/2f2ydWqxL2uN+Ds=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=OLObjVPare0tILn99NfHCWtnwC98TtFn++TT22/jqiQgt9sMFtuccIE/u7xBeMHzx
	 dxIin+VduhIw/+IV4p91SY9jzWIf1kCZoqId4njWhITOSrusSisXN65myKfsJxxPR+
	 xFHIDwr3CXPWYuPlA0B7csPn7QdPn95nBFj52o3+9t973oft4CLf1Z3JMDQ+vPBHdq
	 wgLy7cXII/k32FtL1CnDV8f2VppDP+RMcfw9kxeBeoDy3yS8+KrQ5wWayKwEVFNyHk
	 sDGRBUTFsTXB67hVfxfWWuqA9uSvFsLHlNWRDrvxPFBUZUtz9elST1MBlY5fs6QnKy
	 K+XGn2zjA81eg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68971MjjC356872
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:01:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:20 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:20 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:01:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 08/15] wifi: rtw89: explicitly declare TX queue flags by DECLARE_BITMAP()
Date: Wed, 9 Sep 2026 14:59:57 +0800
Message-ID: <20260909070004.35353-9-pkshih@realtek.com>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Originally, TX queue flags was declared by pure unsigned long but was
used with bitops, e.g. test_bit. Although for now, there are not much
cases in enum rtw89_txq_flags to be over than bits that one long can
deal with, it indeed missed logical boundary check. Refine it to be
declared by DECLARE_BITMAP().

Resolve ARRAY_VS_SINGLETON (Out-of-bounds access) reported by Coverity.

(doesn't change logic)

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c     | 24 +++++++++----------
 drivers/net/wireless/realtek/rtw89/core.h     |  5 +++-
 drivers/net/wireless/realtek/rtw89/mac80211.c |  4 ++--
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 8ab15ee1b155..b074b3677c43 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4625,7 +4625,7 @@ static void rtw89_core_ba_work(struct work_struct *work)
 				    "failed to setup BA session for %pM:%2d: %d\n",
 				    sta->addr, tid, ret);
 			if (ret == -EINVAL)
-				set_bit(RTW89_TXQ_F_BLOCK_BA, &rtwtxq->flags);
+				set_bit(RTW89_TXQ_F_BLOCK_BA, rtwtxq->flags);
 		}
 skip_ba_work:
 		list_del_init(&rtwtxq->list);
@@ -4658,7 +4658,7 @@ void rtw89_core_free_sta_pending_forbid_ba(struct rtw89_dev *rtwdev,
 		struct ieee80211_txq *txq = rtw89_txq_to_txq(rtwtxq);
 
 		if (sta == txq->sta) {
-			clear_bit(RTW89_TXQ_F_FORBID_BA, &rtwtxq->flags);
+			clear_bit(RTW89_TXQ_F_FORBID_BA, rtwtxq->flags);
 			list_del_init(&rtwtxq->list);
 		}
 	}
@@ -4685,12 +4685,12 @@ static void rtw89_core_stop_tx_ba_session(struct rtw89_dev *rtwdev,
 	if (unlikely(!rtwsta) || unlikely(rtwsta->disassoc))
 		return;
 
-	if (!test_bit(RTW89_TXQ_F_AMPDU, &rtwtxq->flags) ||
-	    test_bit(RTW89_TXQ_F_FORBID_BA, &rtwtxq->flags))
+	if (!test_bit(RTW89_TXQ_F_AMPDU, rtwtxq->flags) ||
+	    test_bit(RTW89_TXQ_F_FORBID_BA, rtwtxq->flags))
 		return;
 
 	spin_lock_bh(&rtwdev->ba_lock);
-	if (!test_and_set_bit(RTW89_TXQ_F_FORBID_BA, &rtwtxq->flags))
+	if (!test_and_set_bit(RTW89_TXQ_F_FORBID_BA, rtwtxq->flags))
 		list_add_tail(&rtwtxq->list, &rtwdev->forbid_ba_list);
 	spin_unlock_bh(&rtwdev->ba_lock);
 
@@ -4709,7 +4709,7 @@ static void rtw89_core_txq_check_agg(struct rtw89_dev *rtwdev,
 	struct ieee80211_sta *sta = txq->sta;
 	struct rtw89_sta *rtwsta = sta_to_rtwsta_safe(sta);
 
-	if (test_bit(RTW89_TXQ_F_FORBID_BA, &rtwtxq->flags))
+	if (test_bit(RTW89_TXQ_F_FORBID_BA, rtwtxq->flags))
 		return;
 
 	if (unlikely(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
@@ -4720,10 +4720,10 @@ static void rtw89_core_txq_check_agg(struct rtw89_dev *rtwdev,
 	if (unlikely(!sta))
 		return;
 
-	if (unlikely(test_bit(RTW89_TXQ_F_BLOCK_BA, &rtwtxq->flags)))
+	if (unlikely(test_bit(RTW89_TXQ_F_BLOCK_BA, rtwtxq->flags)))
 		return;
 
-	if (test_bit(RTW89_TXQ_F_AMPDU, &rtwtxq->flags)) {
+	if (test_bit(RTW89_TXQ_F_AMPDU, rtwtxq->flags)) {
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_AMPDU;
 		return;
 	}
@@ -4901,7 +4901,7 @@ static void rtw89_forbid_ba_work(struct work_struct *w)
 
 	spin_lock_bh(&rtwdev->ba_lock);
 	list_for_each_entry_safe(rtwtxq, tmp, &rtwdev->forbid_ba_list, list) {
-		clear_bit(RTW89_TXQ_F_FORBID_BA, &rtwtxq->flags);
+		clear_bit(RTW89_TXQ_F_FORBID_BA, rtwtxq->flags);
 		list_del_init(&rtwtxq->list);
 	}
 	spin_unlock_bh(&rtwdev->ba_lock);
@@ -6036,13 +6036,13 @@ static void _rtw89_core_set_tid_config(struct rtw89_dev *rtwdev,
 
 		if (mask & BIT(NL80211_TID_CONFIG_ATTR_AMPDU_CTRL)) {
 			if (tid_conf->ampdu == NL80211_TID_CONFIG_ENABLE) {
-				clear_bit(RTW89_TXQ_F_FORBID_BA, &rtwtxq->flags);
+				clear_bit(RTW89_TXQ_F_FORBID_BA, rtwtxq->flags);
 			} else {
-				if (test_bit(RTW89_TXQ_F_AMPDU, &rtwtxq->flags))
+				if (test_bit(RTW89_TXQ_F_AMPDU, rtwtxq->flags))
 					ieee80211_stop_tx_ba_session(sta, txq->tid);
 				spin_lock_bh(&rtwdev->ba_lock);
 				list_del_init(&rtwtxq->list);
-				set_bit(RTW89_TXQ_F_FORBID_BA, &rtwtxq->flags);
+				set_bit(RTW89_TXQ_F_FORBID_BA, rtwtxq->flags);
 				spin_unlock_bh(&rtwdev->ba_lock);
 			}
 		}
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index c300d15581fc..d725124b39bf 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -244,6 +244,8 @@ enum rtw89_txq_flags {
 	RTW89_TXQ_F_AMPDU		= 0,
 	RTW89_TXQ_F_BLOCK_BA		= 1,
 	RTW89_TXQ_F_FORBID_BA		= 2,
+
+	NUM_OF_RTW89_TXQ_FLAGS,
 };
 
 enum rtw89_net_type {
@@ -1313,8 +1315,9 @@ struct rtw89_core_tx_request {
 
 struct rtw89_txq {
 	struct list_head list;
-	unsigned long flags;
 	int wait_cnt;
+
+	DECLARE_BITMAP(flags, NUM_OF_RTW89_TXQ_FLAGS);
 };
 
 struct rtw89_mac_ax_gnt {
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index c1be69a3c192..cf356a54d91c 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -1043,7 +1043,7 @@ static int rtw89_ops_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
-		clear_bit(RTW89_TXQ_F_AMPDU, &rtwtxq->flags);
+		clear_bit(RTW89_TXQ_F_AMPDU, rtwtxq->flags);
 		clear_bit(tid, rtwsta->ampdu_map);
 		rtw89_chip_h2c_ampdu_cmac_tbl(rtwdev, rtwvif, rtwsta);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -1051,7 +1051,7 @@ static int rtw89_ops_ampdu_action(struct ieee80211_hw *hw,
 		rtw89_phy_ra_recalc_agg_limit(rtwdev);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		set_bit(RTW89_TXQ_F_AMPDU, &rtwtxq->flags);
+		set_bit(RTW89_TXQ_F_AMPDU, rtwtxq->flags);
 		rtwsta->ampdu_params[tid].agg_num = params->buf_size;
 		rtwsta->ampdu_params[tid].amsdu = params->amsdu;
 		set_bit(tid, rtwsta->ampdu_map);
-- 
2.25.1

