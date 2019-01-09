Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EC6C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 12:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A32E206BA
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 12:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbfAIMAZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 07:00:25 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:34772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728186AbfAIMAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 07:00:25 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CA88EDA9D10086071019;
        Wed,  9 Jan 2019 20:00:22 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.408.0; Wed, 9 Jan 2019 20:00:14 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] staging: wilc1000: remove set but not used variable 'msa'
Date:   Wed, 9 Jan 2019 12:06:41 +0000
Message-ID: <1547035601-84566-1-git-send-email-yuehaibing@huawei.com>
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

drivers/staging/wilc1000/host_interface.c: In function 'wilc_parse_network_info':
drivers/staging/wilc1000/host_interface.c:748:16: warning:
 variable 'msa' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5dae6e7..c05c120 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -745,7 +745,7 @@ static s32 wilc_parse_network_info(u8 *msg_buffer,
 {
 	struct network_info *info;
 	struct ieee80211_mgmt *mgt;
-	u8 *wid_val, *msa, *ies;
+	u8 *wid_val, *ies;
 	u16 wid_len, rx_len, ies_len;
 	u8 msg_type;
 	size_t offset;
@@ -764,7 +764,6 @@ static s32 wilc_parse_network_info(u8 *msg_buffer,
 
 	info->rssi = wid_val[0];
 
-	msa = &wid_val[1];
 	mgt = (struct ieee80211_mgmt *)&wid_val[1];
 	rx_len = wid_len - 1;
 





