Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C90DC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F36218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfBILIz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 06:08:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfBILIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 06:08:54 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EB01637F9;
        Sat,  9 Feb 2019 11:08:54 +0000 (UTC)
Received: from localhost (ovpn-204-22.brq.redhat.com [10.40.204.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 173AD5DEA9;
        Sat,  9 Feb 2019 11:08:53 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [RFC/RFT 7/8] rt2x00: remove not used entry field
Date:   Sat,  9 Feb 2019 12:08:37 +0100
Message-Id: <1549710518-15650-8-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1549710518-15650-1-git-send-email-sgruszka@redhat.com>
References: <1549710518-15650-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Sat, 09 Feb 2019 11:08:54 +0000 (UTC)
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

