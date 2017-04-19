Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:60588 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765437AbdDSWLm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 18:11:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] brcmfmac: fix build without CONFIG_BRCMFMAC_PROTO_BCDC
Date: Thu, 20 Apr 2017 00:10:24 +0200
Message-Id: <20170419221133.2180685-1-arnd@arndb.de> (sfid-20170420_001208_937000_55BCF676)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With CONFIG_BRCMFMAC_PROTO_BCDC unset, we cannot build the fwsignal.c file:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c: In function 'brcmf_fws_notify_credit_map':
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c:1590:31: error: implicit declaration of function 'drvr_to_fws'; did you mean 'dev_to_psd'? [-Werror=implicit-function-declaration]
  struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c:1590:31: error: initialization makes pointer from integer without a cast [-Werror=int-conversion]
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c:1621:31: error: initialization makes pointer from integer without a cast [-Werror=int-conversion]

However, as pointed out in the changeset description for the patch that caused
the problem, fwsignal.c is only required when CONFIG_BRCMFMAC_PROTO_BCDC is
enabled, so we can simply change the Makefile to build it conditionally.

Fixes: acf8ac41dd73 ("brcmfmac: remove reference to fwsignal data from struct brcmf_pub")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
index 0383ba559edc..1f5a9b948abf 100644
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
2.9.0
