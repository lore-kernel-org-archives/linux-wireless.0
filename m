Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40857 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbaKSUSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 15:18:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Arend van Spriel <arend@broadcom.com>,
	John Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] brcmfmac: don't include linux/unaligned/access_ok.h
Date: Wed, 19 Nov 2014 21:18:18 +0100
Message-Id: <1416428298-10000-1-git-send-email-johannes@sipsolutions.net> (sfid-20141119_211828_419130_4EF17608)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is a specific implementation, <asm/unaligned.h> is the
multiplexer that has the arch-specific knowledge of which
of the implementations needs to be used, so include that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index b0ae7993e2e8..138691a1365a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -19,10 +19,10 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
-#include <linux/unaligned/access_ok.h>
 #include <linux/interrupt.h>
 #include <linux/bcma/bcma.h>
 #include <linux/sched.h>
+#include <asm/unaligned.h>
 
 #include <soc.h>
 #include <chipcommon.h>
-- 
2.1.1

