Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0JLWKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 18:10:17 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so2776714bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 15:10:16 -0700 (PDT)
From: mike.rapoport@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 5/7] staging: brcm80211: remove unused NATIVE_{MALLOC,MFREE}
Date: Wed, 13 Oct 2010 00:09:11 +0200
Message-Id: <eadf0342fcea3d78c02458744c3203b63f716c62.1286920620.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1286920620.git.mike.rapoport@gmail.com>
References: <cover.1286920620.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/include/linux_osl.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/include/linux_osl.h b/drivers/staging/brcm80211/include/linux_osl.h
index 69f0e84..0e00188 100644
--- a/drivers/staging/brcm80211/include/linux_osl.h
+++ b/drivers/staging/brcm80211/include/linux_osl.h
@@ -97,9 +97,6 @@ typedef struct {
 #define MFREE(osh, addr, size)	osl_mfree((osh), (addr), (size))
 extern void osl_mfree(osl_t *osh, void *addr, uint size);
 
-#define NATIVE_MALLOC(osh, size)	kmalloc(size, GFP_ATOMIC)
-#define NATIVE_MFREE(osh, addr, size)	kfree(addr)
-
 #define	DMA_CONSISTENT_ALIGN	osl_dma_consistent_align()
 extern uint osl_dma_consistent_align(void);
 extern void *osl_dma_alloc_consistent(osl_t *osh, uint size, u16 align,
-- 
1.6.4.4

