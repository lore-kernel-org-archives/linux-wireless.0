Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB54C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 20:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B17B21479
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 20:23:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B17B21479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ispras.ru
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbeJFDXm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 23:23:42 -0400
Received: from mail.ispras.ru ([83.149.199.45]:52496 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbeJFDXm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 23:23:42 -0400
Received: from localhost.localdomain (unknown [85.140.188.249])
        by mail.ispras.ru (Postfix) with ESMTPSA id 52678540089;
        Fri,  5 Oct 2018 23:22:57 +0300 (MSK)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] mac80211_hwsim: fix module init error paths for netlink
Date:   Fri,  5 Oct 2018 23:22:06 +0300
Message-Id: <1538770926-8413-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is no unregister netlink notifier and family on error paths
in init_mac80211_hwsim(). Also there is an error path where
hwsim_class is not destroyed.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: 62759361eb49 ("mac80211-hwsim: Provide multicast event for HWSIM_CMD_NEW_RADIO")
---
 drivers/net/wireless/mac80211_hwsim.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 07442ada6dd0..6532cb25a333 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3712,16 +3712,16 @@ static int __init init_mac80211_hwsim(void)
 	if (err)
 		goto out_unregister_pernet;
 
+	err = hwsim_init_netlink();
+	if (err)
+		goto out_unregister_driver;
+
 	hwsim_class = class_create(THIS_MODULE, "mac80211_hwsim");
 	if (IS_ERR(hwsim_class)) {
 		err = PTR_ERR(hwsim_class);
-		goto out_unregister_driver;
+		goto out_exit_netlink;
 	}
 
-	err = hwsim_init_netlink();
-	if (err < 0)
-		goto out_unregister_driver;
-
 	for (i = 0; i < radios; i++) {
 		struct hwsim_new_radio_params param = { 0 };
 
@@ -3827,6 +3827,8 @@ static int __init init_mac80211_hwsim(void)
 	free_netdev(hwsim_mon);
 out_free_radios:
 	mac80211_hwsim_free();
+out_exit_netlink:
+	hwsim_exit_netlink();
 out_unregister_driver:
 	platform_driver_unregister(&mac80211_hwsim_driver);
 out_unregister_pernet:
-- 
2.7.4

