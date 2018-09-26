Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEBBC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 12:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 437B2208E4
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 12:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 437B2208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbeIZTHC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 15:07:02 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:42027 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbeIZTHC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 15:07:02 -0400
Received: from wuerfel.lan ([109.193.40.16]) by mrelayeu.kundenserver.de
 (mreue002 [212.227.15.129]) with ESMTPA (Nemesis) id
 0LrEhY-1fdd74367w-0139Bb; Wed, 26 Sep 2018 14:53:58 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: fix building without CONFIG_MT76x0U
Date:   Wed, 26 Sep 2018 14:51:59 +0200
Message-Id: <20180926125356.2026635-1-arnd@arndb.de>
X-Mailer: git-send-email 2.18.0
X-Provags-ID: V03:K1:QbA2GUwDid79ftprVbjEuEIVqL7DGY4/0RzQtoFb/oDh1Q5zoNy
 fmO99/YxVFVdL3YDtHtNvWPl8uMTLA6AaU22w+ZNBjlkz9KFDk7c67MvnQH6578bT/XUXx3
 /lnmAi74/MDgC4FokI3SLWCh2gpVJU94MFufpXE6wXUrJ/GqU3ZOQcZkquL1Ug9c1mD5Wjz
 Jf7N0lmoG0EmvOsWPoCfg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:9qRm+CJ5aHo=:pwaXj8ga9X99oMzrPperxV
 hWCDLaCnTFvbZxgvbin3dbvzOyA7WshwVu3H8FQ3bp4ZNVnaYSHf4/tPYz82JQ2Ovw3LmtRDV
 bfDt075ZvSQcKjLVQ2dDN0gU2vV+Ec+m/CgxSnz1UWWZQE4Bak9Zm7EldsVa8ADeoILEpGSYL
 n6sjgeIpOBfqdMSln19oSVoLcbk2QQxbjIYCgfeQlxBIgaUyQW1uGfxhQA9lLUrUvHyBW+a4B
 P9zNyflnAfhC3caWrLdrXR+VlFXwJOew81Ua/2mLIvII7QAwXNma3J8i4GN8y/xwfM+6lJkW8
 goIfh9C2ObcxfurG+d6BRqQ/oMtG0tfM9zM4p6x2p/nvkAAmnDZI00QZHYiWFwCUrsvON6HS8
 OzgCwZC1TNmmk9+900Fx9gGIH8sdKf9aIsl/1ni6NLVRd391fVdDAkM1KAeI6BVRiuVYkXHSB
 QUscyxl6iU6pEeo+8PaC+n8Kjuf+h9A9A4NPaekWFV7u7rEPmmI28zs21PpHgq07+qv/t25Tv
 q9TQxq07vsE0G9vqIETvgM0Hyxka3Od+znXKHlQoGQlZVEzJURLYTAwT7DZDmRD6kXKxShrlL
 SHSyiJ/b34ePKuukOBOD1yTnfJZvtRhXktn0jjEN3d2tPsOZ94YTXFbkOufxFhLwVyH19FLUz
 o/fRtxLEOUw1EmxvLboIJIKV1EF9Or8vEduCLFKeqd7YNzwVYNM36Y2RUsH8A8MA3HGw=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The recent rework of the mt76 driver caused build failures in
configurations that leave the mt76x0u support disabled:

ERROR: "mt76u_mcu_deinit" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
ERROR: "mt76x02u_set_txinfo" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
ERROR: "mt76u_queues_deinit" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
ERROR: "mt76u_stop_stat_wk" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!

The mt76x0_push_txwi()/mt76x0_tx_prepare_skb()/mt76x0_cleanup() functions
that cause some of these are only called from the usb portion, and can
be hidden in an #ifdef in this case.

mt76u_stop_stat_wk() is called mt76x0_mac_stop(), which is in turn
shared between multiple callers. Calling it only when the USB driver
is enabled avoids the link error but it is not clear to me whether this
can be called from a context where it would not do the right thing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 5 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c   | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 3a88be267daf..9d0f0e1bf07a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -377,7 +377,8 @@ void mt76x0_mac_stop(struct mt76x0_dev *dev)
 {
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
-	mt76u_stop_stat_wk(&dev->mt76);
+	if (IS_ENABLED(CONFIG_MT76x0U))
+		mt76u_stop_stat_wk(&dev->mt76);
 	mt76x0_mac_stop_hw(dev);
 }
 EXPORT_SYMBOL_GPL(mt76x0_mac_stop);
@@ -457,6 +458,7 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x0_init_hardware);
 
+#ifdef CONFIG_MT76x0U
 void mt76x0_cleanup(struct mt76x0_dev *dev)
 {
 	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
@@ -465,6 +467,7 @@ void mt76x0_cleanup(struct mt76x0_dev *dev)
 	mt76u_mcu_deinit(&dev->mt76);
 }
 EXPORT_SYMBOL_GPL(mt76x0_cleanup);
+#endif
 
 struct mt76x0_dev *
 mt76x0_alloc_device(struct device *pdev, const struct mt76_driver_ops *drv_ops)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index c6d8ba01feb1..2d3c20e82ce1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -17,6 +17,7 @@
 #include "../mt76x02_util.h"
 #include "../mt76x02_usb.h"
 
+#ifdef CONFIG_MT76x0U
 static struct mt76x02_txwi *
 mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 		  struct ieee80211_sta *sta, struct mt76_wcid *wcid,
@@ -53,6 +54,7 @@ mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 
 	return txwi;
 }
+#endif
 
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	       struct sk_buff *skb)
@@ -82,6 +84,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	mt76_tx(&dev->mt76, control->sta, wcid, skb);
 }
 
+#ifdef CONFIG_MT76x0U
 int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			  struct sk_buff *skb, struct mt76_queue *q,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
@@ -97,6 +100,7 @@ int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	return mt76x02u_set_txinfo(skb, wcid, q2ep(q->hw_idx));
 }
 EXPORT_SYMBOL_GPL(mt76x0_tx_prepare_skb);
+#endif
 
 void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb)
-- 
2.18.0

