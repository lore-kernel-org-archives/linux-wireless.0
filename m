Return-Path: <SRS0=FFSH=OD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A93DC43441
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 13:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC49020868
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 13:19:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC49020868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbeKYAIF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 24 Nov 2018 19:08:05 -0500
Received: from a3.inai.de ([88.198.85.195]:54196 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbeKYAIF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Nov 2018 19:08:05 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Nov 2018 19:08:04 EST
Received: by a3.inai.de (Postfix, from userid 65534)
        id 669913BACCCA; Sat, 24 Nov 2018 14:12:59 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id E37C73BB6970;
        Sat, 24 Nov 2018 14:12:58 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     marcel@holtmann.org
Cc:     linux-wireless@vger.kernel.org, jengelh@inai.de
Subject: [PATCH] ell:: build: bump SO version of libell
Date:   Sat, 24 Nov 2018 14:12:58 +0100
Message-Id: <20181124131258.15978-1-jengelh@inai.de>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit 0.13-7-g4a386a1 changed the ABI of l_signal_create. This
warrants a bump in the SO version.
---
 Makefile.am | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index d115360..5a44f40 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -8,8 +8,8 @@ ACLOCAL_AMFLAGS = -I build-aux
 # Interfaces added:		CURRENT++ REVISION=0 AGE++
 # Interfaces removed:		CURRENT++ REVISION=0 AGE=0
 
-ELL_CURRENT = 0
-ELL_REVISION = 2
+ELL_CURRENT = 1
+ELL_REVISION = 0
 ELL_AGE = 0
 
 pkginclude_HEADERS = ell/ell.h \
-- 
2.19.1

