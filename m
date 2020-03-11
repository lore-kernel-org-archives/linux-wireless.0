Return-Path: <SRS0=yqm1=44=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00301C10F29
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Mar 2020 09:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D773421655
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Mar 2020 09:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgCKJRm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 11 Mar 2020 05:17:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:48576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgCKJRl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Mar 2020 05:17:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2025BAE63;
        Wed, 11 Mar 2020 09:17:40 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Michael Buesch <m@bues.ch>
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 10:17:39 +0100
Message-Id: <20200311091739.22635-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/ssb/sprom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/sprom.c b/drivers/ssb/sprom.c
index 4f028a80d6c4..52d2e0f33be7 100644
--- a/drivers/ssb/sprom.c
+++ b/drivers/ssb/sprom.c
@@ -26,9 +26,9 @@ static int sprom2hex(const u16 *sprom, char *buf, size_t buf_len,
 	int i, pos = 0;
 
 	for (i = 0; i < sprom_size_words; i++)
-		pos += snprintf(buf + pos, buf_len - pos - 1,
+		pos += scnprintf(buf + pos, buf_len - pos - 1,
 				"%04X", swab16(sprom[i]) & 0xFFFF);
-	pos += snprintf(buf + pos, buf_len - pos - 1, "\n");
+	pos += scnprintf(buf + pos, buf_len - pos - 1, "\n");
 
 	return pos + 1;
 }
-- 
2.16.4

