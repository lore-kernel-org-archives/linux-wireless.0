Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34008 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936287AbdDZWEt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 18:04:49 -0400
Received: by mail-pf0-f182.google.com with SMTP id c198so6989494pfc.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 15:04:49 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-soc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wcn36xx@lists.infradead.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>
Subject: [PATCH 1/2] wcn36xx: Pass used skb to ieee80211_tx_status()
Date: Wed, 26 Apr 2017 15:04:43 -0700
Message-Id: <20170426220444.10539-1-bjorn.andersson@linaro.org> (sfid-20170427_000624_047560_805C9599)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the tx skbs are collected they should be passed to
ieee80211_tx_status() rather than ieee80211_free_txskb(), as the prior
will take care of monitoring and LED triggers while the latter will
consider the skb dropped.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 87dfdaf9044c..938b7bd733cf 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -371,7 +371,7 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 			info = IEEE80211_SKB_CB(ctl->skb);
 			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
 				/* Keep frame until TX status comes */
-				ieee80211_free_txskb(wcn->hw, ctl->skb);
+				ieee80211_tx_status(wcn->hw, ctl->skb);
 			}
 			spin_lock(&ctl->skb_lock);
 			if (wcn->queues_stopped) {
-- 
2.12.0
