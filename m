Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3911 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab2DTV2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 17:28:05 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3.4 1/2] brcm80211: fmac: fix SDIO function 0 register
 r/w issue
Date: Fri, 20 Apr 2012 14:27:48 -0700
Message-ID: <1334957269-27416-2-git-send-email-frankyl@broadcom.com> (sfid-20120420_232810_370521_932A49FB)
In-Reply-To: <1334957269-27416-1-git-send-email-frankyl@broadcom.com>
References: <1334957269-27416-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SDIO stack doesn't have a structure for function 0. The structure
pointer stored in card->sdio_func[0] is actually for function 1.
With current implementation the register read/write is applied to
function 1. This pathch fixes the issue.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 4688904..6989916 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -108,9 +108,13 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 			sdio_release_host(sdfunc);
 		}
 	} else if (regaddr == SDIO_CCCR_ABORT) {
+		sdfunc = kzalloc(sizeof(struct sdio_func), GFP_KERNEL);
+		memcpy(sdfunc, sdiodev->func[0], sizeof(struct sdio_func));
+		sdfunc->num = 0;
 		sdio_claim_host(sdfunc);
 		sdio_writeb(sdfunc, *byte, regaddr, &err_ret);
 		sdio_release_host(sdfunc);
+		kfree(sdfunc);
 	} else if (regaddr < 0xF0) {
 		brcmf_dbg(ERROR, "F0 Wr:0x%02x: write disallowed\n", regaddr);
 		err_ret = -EPERM;
@@ -486,7 +490,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			kfree(bus_if);
 			return -ENOMEM;
 		}
-		sdiodev->func[0] = func->card->sdio_func[0];
+		sdiodev->func[0] = func;
 		sdiodev->func[1] = func;
 		sdiodev->bus_if = bus_if;
 		bus_if->bus_priv.sdio = sdiodev;
-- 
1.7.5.4


