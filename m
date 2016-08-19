Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755137AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 08/20] rtl8xxxu: Remove now obsolete rtl8xxxu_old_init_queue_reserved_page()
Date: Fri, 19 Aug 2016 17:46:30 -0400
Message-Id: <1471643202-26250-9-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234819_303757_88619874)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Switching over the old devices to use the new function allows us to
get rid of this legacy.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 30 ++--------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 948f153..efe24a6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3847,28 +3847,6 @@ void rtl8xxxu_gen2_disable_rf(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_RX_WAIT_CCA, val32);
 }
 
-static void rtl8xxxu_old_init_queue_reserved_page(struct rtl8xxxu_priv *priv)
-{
-	u8 val8;
-	u32 val32;
-
-	if (priv->ep_tx_normal_queue)
-		val8 = TX_PAGE_NUM_NORM_PQ;
-	else
-		val8 = 0;
-
-	rtl8xxxu_write8(priv, REG_RQPN_NPQ, val8);
-
-	val32 = (TX_PAGE_NUM_PUBQ << RQPN_PUB_PQ_SHIFT) | RQPN_LOAD;
-
-	if (priv->ep_tx_high_queue)
-		val32 |= (TX_PAGE_NUM_HI_PQ << RQPN_HI_PQ_SHIFT);
-	if (priv->ep_tx_low_queue)
-		val32 |= (TX_PAGE_NUM_LO_PQ << RQPN_LO_PQ_SHIFT);
-
-	rtl8xxxu_write32(priv, REG_RQPN, val32);
-}
-
 static void rtl8xxxu_init_queue_reserved_page(struct rtl8xxxu_priv *priv)
 {
 	struct rtl8xxxu_fileops *fops = priv->fops;
@@ -3929,12 +3907,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		goto exit;
 	}
 
-	if (!macpower) {
-		if (priv->fops->total_page_num)
-			rtl8xxxu_init_queue_reserved_page(priv);
-		else
-			rtl8xxxu_old_init_queue_reserved_page(priv);
-	}
+	if (!macpower)
+		rtl8xxxu_init_queue_reserved_page(priv);
 
 	ret = rtl8xxxu_init_queue_priority(priv);
 	dev_dbg(dev, "%s: init_queue_priority %i\n", __func__, ret);
-- 
2.7.4
