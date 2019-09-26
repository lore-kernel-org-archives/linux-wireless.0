Return-Path: <SRS0=TTqJ=XV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484BEC432C2
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Sep 2019 08:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E65222BE
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Sep 2019 08:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfIZIyg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Sep 2019 04:54:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfIZIyg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Sep 2019 04:54:36 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C2BA27E437;
        Thu, 26 Sep 2019 08:54:35 +0000 (UTC)
Received: from localhost (unknown [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1EC360605;
        Thu, 26 Sep 2019 08:54:34 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Jonathan Liu <net147@gmail.com>
Subject: [PATCH] rt2x00: initialize last_reset
Date:   Thu, 26 Sep 2019 10:54:33 +0200
Message-Id: <20190926085433.1300-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 26 Sep 2019 08:54:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Initialize last_reset variable to INITIAL_JIFFIES, otherwise it is not
possible to test H/W reset for first 5 minutes of system run.

Fixes: e403fa31ed71 ("rt2x00: add restart hw")
Reported-and-tested-by: Jonathan Liu <net147@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
index 4d4e3888ef20..f2395309ec00 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
@@ -555,7 +555,7 @@ static ssize_t rt2x00debug_write_restart_hw(struct file *file,
 {
 	struct rt2x00debug_intf *intf =	file->private_data;
 	struct rt2x00_dev *rt2x00dev = intf->rt2x00dev;
-	static unsigned long last_reset;
+	static unsigned long last_reset = INITIAL_JIFFIES;
 
 	if (!rt2x00_has_cap_restart_hw(rt2x00dev))
 		return -EOPNOTSUPP;
-- 
2.20.1

