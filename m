Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3373 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933242Ab2KOCqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:35 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/19] brcmfmac: fix wrong usage of unaligned include
 file
Date: Wed, 14 Nov 2012 18:46:14 -0800
Message-ID: <1352947583-25341-11-git-send-email-frankyl@broadcom.com> (sfid-20121115_034654_172940_E21EC7E6)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Replaced <linux/unaligned/access_ok.h> by <asm/unaligned.h>
to make it work on ARM and other architectures.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index 13bd333..b39246a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -18,7 +18,7 @@
 #ifndef FWEH_H_
 #define FWEH_H_
 
-#include <linux/unaligned/access_ok.h>
+#include <asm/unaligned.h>
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
 #include <linux/if.h>
-- 
1.7.9.5


