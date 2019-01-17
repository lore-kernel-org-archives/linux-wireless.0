Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433F5C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 03:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BB8820657
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 03:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfAQDLM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 22:11:12 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:34394 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727185AbfAQDLM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 22:11:12 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 430BE74B390037FD2CF2;
        Thu, 17 Jan 2019 11:11:10 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.408.0; Thu, 17 Jan 2019 11:11:00 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH v2] virt_wifi: remove set but not used variable 'w_priv'
Date:   Thu, 17 Jan 2019 03:17:03 +0000
Message-ID: <1547695023-71081-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1545274318-144187-1-git-send-email-yuehaibing@huawei.com>
References: <1545274318-144187-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/virt_wifi.c: In function 'virt_wifi_net_device_stop':
drivers/net/wireless/virt_wifi.c:432:31: warning:
 variable 'w_priv' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: fix prefix to 'virt_wifi:'
---
 drivers/net/wireless/virt_wifi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index 64b2186..ea10f58 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -429,13 +429,11 @@ static int virt_wifi_net_device_open(struct net_device *dev)
 static int virt_wifi_net_device_stop(struct net_device *dev)
 {
 	struct virt_wifi_netdev_priv *n_priv = netdev_priv(dev);
-	struct virt_wifi_wiphy_priv *w_priv;
 
 	n_priv->is_up = false;
 
 	if (!dev->ieee80211_ptr)
 		return 0;
-	w_priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 
 	virt_wifi_cancel_scan(dev->ieee80211_ptr->wiphy);
 	virt_wifi_cancel_connect(dev);



