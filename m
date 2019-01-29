Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27D8C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 06:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89B882175B
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 06:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbfA2G4U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 01:56:20 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:49100 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbfA2G4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 01:56:20 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3DE4EDE16150E97F5CD0;
        Tue, 29 Jan 2019 14:40:56 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.408.0; Tue, 29 Jan 2019
 14:40:46 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <sameo@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: nci: remove set-but-not-used variable 'status'
Date:   Tue, 29 Jan 2019 14:40:28 +0800
Message-ID: <20190129064028.7768-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

gcc warning this:
net/nfc/nci/hci.c:373:5:
 warning: variable 'status' set but not used [-Wunused-but-set-variable]

It not used since commit d8cd37ed2fc8 ("NFC: nci: Fix improper
management of HCI return code"), so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/nfc/nci/hci.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index ddfc52a..4debba8 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -370,17 +370,11 @@ static void nci_hci_resp_received(struct nci_dev *ndev, u8 pipe,
 				  u8 result, struct sk_buff *skb)
 {
 	struct nci_conn_info    *conn_info;
-	u8 status = result;
 
 	conn_info = ndev->hci_dev->conn_info;
-	if (!conn_info) {
-		status = NCI_STATUS_REJECTED;
-		goto exit;
-	}
-
-	conn_info->rx_skb = skb;
+	if (conn_info)
+		conn_info->rx_skb = skb;
 
-exit:
 	nci_req_complete(ndev, NCI_STATUS_OK);
 }
 
-- 
2.7.0


