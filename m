Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FF0C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 07:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22B1A206B7
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 07:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22B1A206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbeLEHuz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 02:50:55 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:49522 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726102AbeLEHuz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 02:50:55 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ED9482EDD9504;
        Wed,  5 Dec 2018 15:50:50 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.408.0; Wed, 5 Dec 2018 15:50:45 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Maya Erez <merez@codeaurora.org>, Kalle Valo <kvalo@codeaurora.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qti.qualcomm.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] wil6210: remove set but not used variable 'wdev'
Date:   Wed, 5 Dec 2018 07:59:03 +0000
Message-ID: <1543996743-137124-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
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

drivers/net/wireless/ath/wil6210/main.c: In function '_wil6210_disconnect':
drivers/net/wireless/ath/wil6210/main.c:407:23: warning:
 variable 'wdev' set but not used [-Wunused-but-set-variable]

It never used since commit ("e1b43407c034 wil6210: refactor disconnect flow")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index ba6a2ee..5b7de00 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -404,7 +404,6 @@ static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
 {
 	struct wil6210_priv *wil;
 	struct net_device *ndev;
-	struct wireless_dev *wdev;
 	int cid = -ENOENT;
 
 	if (unlikely(!vif))
@@ -412,7 +411,6 @@ static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
 
 	wil = vif_to_wil(vif);
 	ndev = vif_to_ndev(vif);
-	wdev = vif_to_wdev(vif);
 
 	might_sleep();
 	wil_info(wil, "disconnect bssid=%pM, reason=%d\n", bssid, reason_code);



