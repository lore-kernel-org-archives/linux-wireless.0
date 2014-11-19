Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61325 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaKSVNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 16:13:20 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-3.18] brcmfmac: don't include linux/unaligned/access_ok.h
Date: Wed, 19 Nov 2014 22:13:10 +0100
Message-ID: <1416431594-13993-1-git-send-email-arend@broadcom.com> (sfid-20141119_221327_526226_ED71F69C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is a specific implementation, <asm/unaligned.h> is the
multiplexer that has the arch-specific knowledge of which
of the implementations needs to be used, so include that.

This issue was revealed by kbuild testing
when <asm/unaligned.h> was added in <linux/ieee80211.h>
resulting in redefinition of get_unaligned_be16 (and
probably others).

Cc: stable@vger.kernel.org # v3.17
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 8c0632e..16fef33 100644
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
1.9.1

