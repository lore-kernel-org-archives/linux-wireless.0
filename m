Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFADC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85E9D20877
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85E9D20877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=strongswan.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbeIYNrh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 09:47:37 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:57410 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbeIYNrh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 09:47:37 -0400
Received: from book.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id ABF1240F60;
        Tue, 25 Sep 2018 09:41:27 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH 3/3] mac80211_hwsim: drop now unused work-queue from hwsim
Date:   Tue, 25 Sep 2018 09:41:15 +0200
Message-Id: <20180925074115.18169-4-martin@strongswan.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20180925074115.18169-1-martin@strongswan.org>
References: <20180925074115.18169-1-martin@strongswan.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The work-queue was used for deferred destruction of hwsim radios;
this does not work well with namespaces about to exit. The one
remaining user has been migrated, so drop the now unused work-queue
instance.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 09fcd6911020..70229a839c84 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -495,7 +495,6 @@ static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
 
 static spinlock_t hwsim_radio_lock;
 static LIST_HEAD(hwsim_radios);
-static struct workqueue_struct *hwsim_wq;
 static struct rhashtable hwsim_radios_rht;
 static int hwsim_radio_idx;
 static int hwsim_radios_generation = 1;
@@ -3693,13 +3692,9 @@ static int __init init_mac80211_hwsim(void)
 
 	spin_lock_init(&hwsim_radio_lock);
 
-	hwsim_wq = alloc_workqueue("hwsim_wq", 0, 0);
-	if (!hwsim_wq)
-		return -ENOMEM;
-
 	err = rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
 	if (err)
-		goto out_free_wq;
+		return err;
 
 	err = register_pernet_device(&hwsim_net_ops);
 	if (err)
@@ -3830,8 +3825,6 @@ static int __init init_mac80211_hwsim(void)
 	unregister_pernet_device(&hwsim_net_ops);
 out_free_rht:
 	rhashtable_destroy(&hwsim_radios_rht);
-out_free_wq:
-	destroy_workqueue(hwsim_wq);
 	return err;
 }
 module_init(init_mac80211_hwsim);
@@ -3843,12 +3836,10 @@ static void __exit exit_mac80211_hwsim(void)
 	hwsim_exit_netlink();
 
 	mac80211_hwsim_free();
-	flush_workqueue(hwsim_wq);
 
 	rhashtable_destroy(&hwsim_radios_rht);
 	unregister_netdev(hwsim_mon);
 	platform_driver_unregister(&mac80211_hwsim_driver);
 	unregister_pernet_device(&hwsim_net_ops);
-	destroy_workqueue(hwsim_wq);
 }
 module_exit(exit_mac80211_hwsim);
-- 
2.17.1

