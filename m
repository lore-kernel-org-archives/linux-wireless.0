Return-Path: <SRS0=eo9X=ZL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8D8C33CA0
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 02:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D751522311
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 02:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKSCSA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Nov 2019 21:18:00 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7139 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbfKSCSA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Nov 2019 21:18:00 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 101431AC88401CD54E2F;
        Tue, 19 Nov 2019 10:17:58 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 19 Nov 2019
 10:17:50 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <Jes.Sorensen@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next v2] rtl8xxxu: Remove set but not used variable 'vif','dev','len'
Date:   Tue, 19 Nov 2019 10:25:14 +0800
Message-ID: <1574130314-25626-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5396:24: warning: variable vif set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5397:17: warning: variable dev set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5400:6: warning: variable len set but not used [-Wunused-but-set-variable]

They are introduced by commit e542e66b7c2e ("rtl8xxxu:
add bluetooth co-existence support for single antenna"), but never used,
so remove them.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
v1->v2: modify comment, it --> they
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 1d94cab..aa2bb2a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5393,18 +5393,13 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 {
 	struct rtl8xxxu_priv *priv;
 	struct rtl8723bu_c2h *c2h;
-	struct ieee80211_vif *vif;
-	struct device *dev;
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
-	int len;
 	u8 bt_info = 0;
 	struct rtl8xxxu_btcoex *btcoex;

 	priv = container_of(work, struct rtl8xxxu_priv, c2hcmd_work);
-	vif = priv->vif;
 	btcoex = &priv->bt_coex;
-	dev = &priv->udev->dev;

 	if (priv->rf_paths > 1)
 		goto out;
@@ -5415,7 +5410,6 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 		spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);

 		c2h = (struct rtl8723bu_c2h *)skb->data;
-		len = skb->len - 2;

 		switch (c2h->id) {
 		case C2H_8723B_BT_INFO:
--
2.7.4

