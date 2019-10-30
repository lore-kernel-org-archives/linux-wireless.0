Return-Path: <SRS0=eZlD=YX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F135ECA9EC4
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Oct 2019 03:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C45742086A
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Oct 2019 03:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfJ3DFC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Oct 2019 23:05:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44354 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726714AbfJ3DFC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Oct 2019 23:05:02 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7DE2C491F63B277F3E84;
        Wed, 30 Oct 2019 11:05:00 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 30 Oct 2019 11:04:53 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH] mac80211_hwsim: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs fops
Date:   Wed, 30 Oct 2019 11:01:02 +0800
Message-ID: <1572404462-45462-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It is more clear to use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs file
operation rather than DEFINE_SIMPLE_ATTRIBUTE.

It is detected with the help of coccinelle.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 31ae6c4..0373810 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -769,8 +769,8 @@ static int hwsim_fops_ps_write(void *dat, u64 val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
-			"%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
+			 "%llu\n");
 
 static int hwsim_write_simulate_radar(void *dat, u64 val)
 {
@@ -781,8 +781,8 @@ static int hwsim_write_simulate_radar(void *dat, u64 val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(hwsim_simulate_radar, NULL,
-			hwsim_write_simulate_radar, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(hwsim_simulate_radar, NULL,
+			 hwsim_write_simulate_radar, "%llu\n");
 
 static int hwsim_fops_group_read(void *dat, u64 *val)
 {
@@ -798,9 +798,9 @@ static int hwsim_fops_group_write(void *dat, u64 val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
-			hwsim_fops_group_read, hwsim_fops_group_write,
-			"%llx\n");
+DEFINE_DEBUGFS_ATTRIBUTE(hwsim_fops_group,
+			 hwsim_fops_group_read, hwsim_fops_group_write,
+			 "%llx\n");
 
 static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
 					struct net_device *dev)
-- 
1.7.12.4

