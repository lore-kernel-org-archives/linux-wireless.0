Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2732 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab1HONem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:42 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/15] staging: brcm80211: remove mips specific include
 from dma.c
Date: Mon, 15 Aug 2011 15:34:24 +0200
Message-ID: <1313415267-5264-13-git-send-email-arend@broadcom.com> (sfid-20110815_153449_652748_14542893)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The include <asm/addrspace.h> has been removed as it is not
needed. None of the definitions from it are used in the source
file.

Tested on BCM63281.

Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index aa4d9cf..bda36c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -18,10 +18,6 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 
-#if defined(__mips__)
-#include <asm/addrspace.h>
-#endif
-
 #include <brcmu_utils.h>
 #include <aiutils.h>
 #include "types.h"
-- 
1.7.4.1


