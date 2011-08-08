Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1675 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1HHN7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:22 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend Van Spriel" <arend@LB-BUN-53.bun.broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 01/82] staging: brcm80211: fix compile error on
 non-x86 archs since 3.0 kernel
Date: Mon, 8 Aug 2011 15:57:45 +0200
Message-ID: <1312811946-16713-2-git-send-email-arend@broadcom.com> (sfid-20110808_155927_205501_49E08466)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend Van Spriel <arend@LB-BUN-53.bun.broadcom.com>

Since the arrival of kernel version 3.0 in the staging tree it
turns out compile error occurs for sparc64, powerpc, and arm
platforms. This patch fixes that issue.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/types.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index bbf2189..823b5e4 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -18,6 +18,7 @@
 #define _BRCM_TYPES_H_
 
 #include <linux/types.h>
+#include <linux/io.h>
 
 /* Bus types */
 #define	SI_BUS			0	/* SOC Interconnect */
-- 
1.7.4.1


