Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418FCECDE44
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 03:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AB03207DE
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 03:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AB03207DE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbeJWMBX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 08:01:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14103 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727131AbeJWMBX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 08:01:23 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7158511589C7E;
        Tue, 23 Oct 2018 11:39:53 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.408.0; Tue, 23 Oct 2018 11:39:52 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ath9k: remove set but not used variable 'new_flags'
Date:   Tue, 23 Oct 2018 11:27:14 +0800
Message-ID: <1540265234-58050-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

new_flags is not used after setting its value. It is safe to remove
the unused variable.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 0fe9c83..9899661 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1055,17 +1055,15 @@ void ar9003_mci_stop_bt(struct ath_hw *ah, bool save_fullsleep)
 static void ar9003_mci_send_2g5g_status(struct ath_hw *ah, bool wait_done)
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
-	u32 new_flags, to_set, to_clear;
+	u32 to_set, to_clear;
 
 	if (!mci->update_2g5g || (mci->bt_state == MCI_BT_SLEEP))
 		return;
 
 	if (mci->is_2g) {
-		new_flags = MCI_2G_FLAGS;
 		to_clear = MCI_2G_FLAGS_CLEAR_MASK;
 		to_set = MCI_2G_FLAGS_SET_MASK;
 	} else {
-		new_flags = MCI_5G_FLAGS;
 		to_clear = MCI_5G_FLAGS_CLEAR_MASK;
 		to_set = MCI_5G_FLAGS_SET_MASK;
 	}
-- 
1.7.12.4

