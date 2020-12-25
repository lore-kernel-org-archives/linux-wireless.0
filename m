Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD45C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Dec 2020 07:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C7E230FF
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Dec 2020 07:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgLYHfq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Dec 2020 02:35:46 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10364 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLYHfq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Dec 2020 02:35:46 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D2Jbs611wz7Kvw;
        Fri, 25 Dec 2020 15:34:17 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 25 Dec 2020 15:34:59 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <ajay.kathat@microchip.com>, <claudiu.beznea@microchip.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>
Subject: [PATCH] wilc1000: use flexible-array member instead of zero-length array
Date:   Fri, 25 Dec 2020 15:35:03 +0800
Message-ID: <1608881703-37060-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use flexible-array member introduced in C99 instead of zero-length
array. Most of zero-length array was already taken care in previous
patch [1].

[1]. https://patchwork.kernel.org/patch/11394197/

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/net/wireless/microchip/wilc1000/fw.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/fw.h b/drivers/net/wireless/microchip/wilc1000/fw.h
index a76e1de..1114530 100644
--- a/drivers/net/wireless/microchip/wilc1000/fw.h
+++ b/drivers/net/wireless/microchip/wilc1000/fw.h
@@ -44,20 +44,20 @@ struct wilc_drv_handler {
 struct wilc_wep_key {
 	u8 index;
 	u8 key_len;
-	u8 key[0];
+	u8 key[];
 } __packed;
 
 struct wilc_sta_wpa_ptk {
 	u8 mac_addr[ETH_ALEN];
 	u8 key_len;
-	u8 key[0];
+	u8 key[];
 } __packed;
 
 struct wilc_ap_wpa_ptk {
 	u8 mac_addr[ETH_ALEN];
 	u8 index;
 	u8 key_len;
-	u8 key[0];
+	u8 key[];
 } __packed;
 
 struct wilc_gtk_key {
@@ -65,7 +65,7 @@ struct wilc_gtk_key {
 	u8 rsc[8];
 	u8 index;
 	u8 key_len;
-	u8 key[0];
+	u8 key[];
 } __packed;
 
 struct wilc_op_mode {
-- 
2.7.4

