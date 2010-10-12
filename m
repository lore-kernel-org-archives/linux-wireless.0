Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0JLWKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 18:10:50 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so2776714bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 15:10:49 -0700 (PDT)
From: mike.rapoport@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 7/7] staging: brcm80211: remove unrefrenced malloced field
Date: Wed, 13 Oct 2010 00:09:13 +0200
Message-Id: <e72c12b598351305a816ee08eeea2dbb3c731f1e.1286920620.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1286920620.git.mike.rapoport@gmail.com>
References: <cover.1286920620.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

from 'struct osl_info' structure

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/util/linux_osl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/util/linux_osl.c b/drivers/staging/brcm80211/util/linux_osl.c
index 876d72f..d86afba 100644
--- a/drivers/staging/brcm80211/util/linux_osl.c
+++ b/drivers/staging/brcm80211/util/linux_osl.c
@@ -37,7 +37,6 @@ struct osl_info {
 	osl_pubinfo_t pub;
 	uint magic;
 	void *pdev;
-	uint malloced;
 	uint failed;
 	uint bustype;
 };
@@ -128,7 +127,6 @@ osl_t *osl_attach(void *pdev, uint bustype, bool pkttag)
 #endif /* BRCM_FULLMAC */
 
 	osh->magic = OS_HANDLE_MAGIC;
-	osh->malloced = 0;
 	osh->failed = 0;
 	osh->pdev = pdev;
 	osh->pub.pkttag = pkttag;
-- 
1.6.4.4

