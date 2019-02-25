Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7D2C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 03:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 258972084D
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 03:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfBYDTd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 22:19:33 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:40820 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726458AbfBYDTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 22:19:32 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CCF5C88E74C75C70DE61;
        Mon, 25 Feb 2019 11:19:30 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.408.0; Mon, 25 Feb 2019 11:19:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] ath9k: remove set but not used variable 'acq'
Date:   Mon, 25 Feb 2019 03:32:46 +0000
Message-ID: <20190225033246.127410-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_rx_count_airtime':
drivers/net/wireless/ath/ath9k/recv.c:1010:18: warning:
 variable 'acq' set but not used [-Wunused-but-set-variable]

It's not used after 89cea7493a34 ("ath9k: Switch to mac80211 TXQ scheduling
and airtime APIs"). Also remove related variables.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 285a62d3019d..4e97f7f3b2a3 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1006,9 +1006,6 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 				 struct ath_rx_status *rs,
 				 struct sk_buff *skb)
 {
-	struct ath_node *an;
-	struct ath_acq *acq;
-	struct ath_vif *avp;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1019,7 +1016,7 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 	int phy;
 	u16 len = rs->rs_datalen;
 	u32 airtime = 0;
-	u8 tidno, acno;
+	u8 tidno;
 
 	if (!ieee80211_is_data(hdr->frame_control))
 		return;
@@ -1029,11 +1026,7 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 	sta = ieee80211_find_sta_by_ifaddr(sc->hw, hdr->addr2, NULL);
 	if (!sta)
 		goto exit;
-	an = (struct ath_node *) sta->drv_priv;
-	avp = (struct ath_vif *) an->vif->drv_priv;
 	tidno = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
-	acno = TID_TO_WME_AC(tidno);
-	acq = &avp->chanctx->acq[acno];
 
 	rxs = IEEE80211_SKB_RXCB(skb);



