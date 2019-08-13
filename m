Return-Path: <SRS0=uvJa=WJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8589DC32750
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Aug 2019 12:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 637E020840
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Aug 2019 12:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfHMMEU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Aug 2019 08:04:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:55764 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725981AbfHMMEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Aug 2019 08:04:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5127BB5EC;
        Tue, 13 Aug 2019 12:04:18 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, dsd@gentoo.org,
        kune@deine-taler.de, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCHv3] zd1211rw: remove false assertion from zd_mac_clear()
Date:   Tue, 13 Aug 2019 14:04:11 +0200
Message-Id: <20190813120412.6240-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The function is called before the lock which is asserted was ever used.
Just remove it.

V2: correct CCs
V3: correct name

Reported-by: syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
index da7e63fca9f5..a9999d10ae81 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
@@ -223,7 +223,6 @@ void zd_mac_clear(struct zd_mac *mac)
 {
 	flush_workqueue(zd_workqueue);
 	zd_chip_clear(&mac->chip);
-	lockdep_assert_held(&mac->lock);
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
 }
 
-- 
2.16.4

