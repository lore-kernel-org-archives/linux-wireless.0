Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F601C433DB
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Feb 2021 11:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45C116023B
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Feb 2021 11:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhBMLtp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Feb 2021 06:49:45 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:52873 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhBMLto (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Feb 2021 06:49:44 -0500
Received: from legolas.fritz.box (unknown [84.174.249.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id E7E5558004F;
        Sat, 13 Feb 2021 12:49:02 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH] iw: fix pointer arithmetic in __print_he_capa
Date:   Sat, 13 Feb 2021 12:48:53 +0100
Message-Id: <20210213114853.17276-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Found by fuzzing with clang fuzzer.

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util.c b/util.c
index 12ba218..9f21f5f 100644
--- a/util.c
+++ b/util.c
@@ -1160,7 +1160,7 @@ static void __print_he_capa(const __u16 *mac_cap,
 
 	/* Caller didn't provide ppet; infer it, if there's trailing space. */
 	if (!ppet) {
-		ppet = (const void *)(mcs_set + mcs_used);
+		ppet = (const void *)((const __u8 *)mcs_set + mcs_used);
 		if (mcs_used < mcs_len)
 			ppet_len = mcs_len - mcs_used;
 		else
-- 
2.30.1

