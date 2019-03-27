Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98167C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 711472070B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733070AbfC0J6t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 05:58:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27673 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732541AbfC0J6s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 05:58:48 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 154715D5F4;
        Wed, 27 Mar 2019 09:58:48 +0000 (UTC)
Received: from localhost (unknown [10.40.205.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A3C41949F;
        Wed, 27 Mar 2019 09:58:47 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH 7/8] rt2x00: remove not used entry field
Date:   Wed, 27 Mar 2019 10:58:30 +0100
Message-Id: <1553680711-15730-8-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
References: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 27 Mar 2019 09:58:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove not used any longer queue_entry field and flag.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
index a15bae29917b..20113f861b9e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
@@ -361,7 +361,6 @@ enum queue_entry_flags {
 	ENTRY_DATA_PENDING,
 	ENTRY_DATA_IO_FAILED,
 	ENTRY_DATA_STATUS_PENDING,
-	ENTRY_DATA_STATUS_SET,
 };
 
 /**
@@ -387,8 +386,6 @@ struct queue_entry {
 
 	unsigned int entry_idx;
 
-	u32 status;
-
 	void *priv_data;
 };
 
-- 
2.7.5

