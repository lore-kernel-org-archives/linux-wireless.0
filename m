Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CC4C433ED
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Apr 2021 12:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C532613BD
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Apr 2021 12:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243027AbhDFMMf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:12:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15496 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbhDFMM2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Apr 2021 08:12:28 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FF5v30YWWzrdBy;
        Tue,  6 Apr 2021 20:10:07 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 20:12:10 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] rfkill: use DEFINE_SPINLOCK() for spinlock
Date:   Tue, 6 Apr 2021 20:11:56 +0800
Message-ID: <1617711116-49370-1-git-send-email-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Guobin Huang <huangguobin4@huawei.com>

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
---
 net/rfkill/input.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/rfkill/input.c b/net/rfkill/input.c
index 4b01baea1d4a..598d0a61bda7 100644
--- a/net/rfkill/input.c
+++ b/net/rfkill/input.c
@@ -36,7 +36,7 @@ module_param_named(master_switch_mode, rfkill_master_switch_mode, uint, 0);
 MODULE_PARM_DESC(master_switch_mode,
 	"SW_RFKILL_ALL ON should: 0=do nothing (only unlock); 1=restore; 2=unblock all");
 
-static spinlock_t rfkill_op_lock;
+static DEFINE_SPINLOCK(rfkill_op_lock);
 static bool rfkill_op_pending;
 static unsigned long rfkill_sw_pending[BITS_TO_LONGS(NUM_RFKILL_TYPES)];
 static unsigned long rfkill_sw_state[BITS_TO_LONGS(NUM_RFKILL_TYPES)];
@@ -330,8 +330,6 @@ int __init rfkill_handler_init(void)
 		return -EINVAL;
 	}
 
-	spin_lock_init(&rfkill_op_lock);
-
 	/* Avoid delay at first schedule */
 	rfkill_last_scheduled =
 			jiffies - msecs_to_jiffies(RFKILL_OPS_DELAY) - 1;

