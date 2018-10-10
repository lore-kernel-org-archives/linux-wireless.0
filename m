Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3082C46463
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AEB520870
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:48:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AEB520870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbeJKEMO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 00:12:14 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:14462 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbeJKEMO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 00:12:14 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 1094440612;
        Wed, 10 Oct 2018 22:48:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id iGH2dpQXmEXA; Wed, 10 Oct 2018 22:48:18 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] iw: Make input to mac_addr_n2a() const
Date:   Wed, 10 Oct 2018 22:47:46 +0200
Message-Id: <20181010204747.1555-1-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The parameter is not modified, so we can make it constant. This makes it
possible to provide other const parameters to this function.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 iw.h   | 2 +-
 util.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iw.h b/iw.h
index 47aa27d..bdd39ee 100644
--- a/iw.h
+++ b/iw.h
@@ -175,7 +175,7 @@ int valid_handler(struct nl_msg *msg, void *arg);
 void register_handler(int (*handler)(struct nl_msg *, void *), void *data);
 
 int mac_addr_a2n(unsigned char *mac_addr, char *arg);
-void mac_addr_n2a(char *mac_addr, unsigned char *arg);
+void mac_addr_n2a(char *mac_addr, const unsigned char *arg);
 int parse_hex_mask(char *hexmask, unsigned char **result, size_t *result_len,
 		   unsigned char **mask);
 unsigned char *parse_hex(char *hex, size_t *outlen);
diff --git a/util.c b/util.c
index 5b286b7..796549e 100644
--- a/util.c
+++ b/util.c
@@ -5,7 +5,7 @@
 #include "iw.h"
 #include "nl80211.h"
 
-void mac_addr_n2a(char *mac_addr, unsigned char *arg)
+void mac_addr_n2a(char *mac_addr, const unsigned char *arg)
 {
 	int i, l;
 
-- 
2.11.0

