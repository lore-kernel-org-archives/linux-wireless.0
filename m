Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:45474 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752397AbdDNV2H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 17:28:07 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] brcmfmac: only build fwsignal module for CONFIG_BRCMFMAC_PROTO_BCDC
Date: Fri, 14 Apr 2017 22:27:37 +0100
Message-Id: <1492205257-18578-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170414_232810_674958_E3EADA3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fwsignal module is only referenced by the bcdc module and part of the
bcdc protocol. So only build it when CONFIG_BRCMFMAC_PROTO_BCDC is selected.

Fixes: acf8ac41dd73 ("brcmfmac: remove reference to fwsignal data from struct brcmf_pub")
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

This should do it. At least verified it with .config provided in the
report(s).

Happy easter ;-)

Regards,
Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
index 0383ba5..1f5a9b9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
@@ -25,7 +25,6 @@ brcmfmac-objs += \
 		chip.o \
 		fwil.o \
 		fweh.o \
-		fwsignal.o \
 		p2p.o \
 		proto.o \
 		common.o \
@@ -36,7 +35,8 @@ brcmfmac-objs += \
 		vendor.o \
 		pno.o
 brcmfmac-$(CONFIG_BRCMFMAC_PROTO_BCDC) += \
-		bcdc.o
+		bcdc.o \
+		fwsignal.o
 brcmfmac-$(CONFIG_BRCMFMAC_PROTO_MSGBUF) += \
 		commonring.o \
 		flowring.o \
-- 
1.9.1
