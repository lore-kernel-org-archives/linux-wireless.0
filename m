Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D022DC282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 02:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B4B320872
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 02:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbfDQC6o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 22:58:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44808 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727063AbfDQC6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 22:58:44 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A966E5D91625C1C48451;
        Wed, 17 Apr 2019 10:58:41 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.408.0; Wed, 17 Apr 2019
 10:58:31 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath9k: Remove some set but not used variables
Date:   Wed, 17 Apr 2019 10:57:45 +0800
Message-ID: <20190417025745.24044-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/ath/ath9k/xmit.c: In function 'ath_tx_count_frames':
drivers/net/wireless/ath/ath9k/xmit.c:413:25: warning: variable 'fi' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/xmit.c: In function 'ath_tx_complete_aggr':
drivers/net/wireless/ath/ath9k/xmit.c:449:24: warning: variable 'hdr' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/xmit.c: In function 'ath_tx_start':
drivers/net/wireless/ath/ath9k/xmit.c:2274:18: warning: variable 'avp' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/xmit.c:2269:24: warning: variable 'hdr' set but not used [-Wunused-but-set-variable]

These variables are not used any more
and can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b17e1ca..59c3ab7 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -410,7 +410,6 @@ static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
 			        struct ath_tx_status *ts, int txok,
 			        int *nframes, int *nbad)
 {
-	struct ath_frame_info *fi;
 	u16 seq_st = 0;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int ba_index;
@@ -426,7 +425,6 @@ static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
 	}
 
 	while (bf) {
-		fi = get_frame_info(bf->bf_mpdu);
 		ba_index = ATH_BA_INDEX(seq_st, bf->bf_state.seqno);
 
 		(*nframes)++;
@@ -446,7 +444,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 {
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
-	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
 	struct ath_buf *bf_next, *bf_last = bf->bf_lastbf;
 	struct list_head bf_head;
@@ -463,8 +460,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	int bar_index = -1;
 
 	skb = bf->bf_mpdu;
-	hdr = (struct ieee80211_hdr *)skb->data;
-
 	tx_info = IEEE80211_SKB_CB(skb);
 
 	memcpy(rates, bf->rates, sizeof(rates));
@@ -2269,12 +2264,10 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl)
 {
-	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = txctl->sta;
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ath_frame_info *fi = get_frame_info(skb);
-	struct ath_vif *avp = NULL;
 	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
 	struct ath_atx_tid *tid = NULL;
@@ -2283,16 +2276,12 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	bool ps_resp;
 	int q, ret;
 
-	if (vif)
-		avp = (void *)vif->drv_priv;
-
 	ps_resp = !!(info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE);
 
 	ret = ath_tx_prepare(hw, skb, txctl);
 	if (ret)
 	    return ret;
 
-	hdr = (struct ieee80211_hdr *) skb->data;
 	/*
 	 * At this point, the vif, hw_key and sta pointers in the tx control
 	 * info are no longer valid (overwritten by the ath_frame_info data.
-- 
2.7.0


