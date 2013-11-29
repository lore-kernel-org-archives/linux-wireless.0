Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1060 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/19] brcmfmac: remove unnecessary EXPORT_SYMBOL()
 usage
Date: Fri, 29 Nov 2013 12:25:18 +0100
Message-ID: <1385724324-6361-14-git-send-email-arend@broadcom.com> (sfid-20131129_122543_813115_F1E9A8B4)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In bcmsdh.c the functions brcmf_sdio_probe() and brcmf_sdio_remove()
were exported, but that is not needed. The functions are linked into
the driver module, which is the only one needing to call these.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 3e10b80..91651ec 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -17,7 +17,6 @@
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
-#include <linux/export.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
@@ -774,7 +773,6 @@ out:
 
 	return ret;
 }
-EXPORT_SYMBOL(brcmf_sdio_probe);
 
 int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 {
@@ -791,7 +789,6 @@ int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 
 	return 0;
 }
-EXPORT_SYMBOL(brcmf_sdio_remove);
 
 void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev, bool enable)
 {
-- 
1.7.10.4


