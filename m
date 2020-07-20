Return-Path: <SRS0=4aWb=A7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5E4C433E7
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Jul 2020 09:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 145F12080D
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Jul 2020 09:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgGTJEb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 20 Jul 2020 05:04:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53244 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726030AbgGTJEa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Jul 2020 05:04:30 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D975527FA9C33330A3E9;
        Mon, 20 Jul 2020 17:04:23 +0800 (CST)
Received: from NRM-11.huawei.com (10.175.101.78) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Jul 2020 17:04:12 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brcm80211-dev-list@cypress.com>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <kvalo@codeaurora.org>, <kuba@kernel.org>,
        <franky.lin@broadcom.com>, <wright.feng@cypress.com>
CC:     Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH net-next] ath11k: Fix possible memleak in ath11k_qmi_init_service
Date:   Mon, 20 Jul 2020 17:36:44 +0800
Message-ID: <1595237804-66297-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.78]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When qmi_add_lookup fail, we should destroy the workqueue

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index c00a99a..497cff7 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2419,6 +2419,7 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
 			     ATH11K_QMI_WLFW_SERVICE_INS_ID_V01);
 	if (ret < 0) {
 		ath11k_warn(ab, "failed to add qmi lookup\n");
+		destroy_workqueue(ab->qmi.event_wq);
 		return ret;
 	}
 
-- 
1.8.3

