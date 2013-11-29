Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1947 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab3K2WAl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 17:00:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.13] brcmfmac: fix uninitialized warning
Date: Fri, 29 Nov 2013 23:00:31 +0100
Message-ID: <1385762431-22559-1-git-send-email-arend@broadcom.com> (sfid-20131129_230055_173319_3D867EAA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Building brcmfmac for sparc64 gave the following warning:

  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.o
    bcmsdh_sdmmc.c: In function 'brcmf_sdioh_request_byte':
     bcmsdh_sdmmc.c:89:6: warning: 'err_ret' may be used uninitialized
                          in this function [-Wuninitialized]

Inspecting the code it indeed had a path of execution in
which the return value was used uninitialized. This patch
fixes that code path.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

This problem popped up when enabling some more build targets and
figured it could be taken for 3.13. Just strange it only showed
on sparc64 as the warning seems valid. Anyway, it applies to the
wireless master branch.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 905704e..abc9cec 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -109,6 +109,8 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 					brcmf_err("Disable F2 failed:%d\n",
 						  err_ret);
 			}
+		} else {
+			err_ret = -ENOENT;
 		}
 	} else if ((regaddr == SDIO_CCCR_ABORT) ||
 		   (regaddr == SDIO_CCCR_IENx)) {
-- 
1.8.1.3


