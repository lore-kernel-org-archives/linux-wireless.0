Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48962 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbdGPLqj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:46:39 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 02/21] net: brcmfmac: Fix brain damaged fn parameter order
Date: Sun, 16 Jul 2017 12:21:10 +0100
Message-Id: <20170716112129.10206-3-ian@mnementh.co.uk> (sfid-20170716_140042_595966_A0B54BD0)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index fd398d27a30c..dadbba2f82ed 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -232,8 +232,7 @@ void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 	sdiodev->state = state;
 }
 
-static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func,
-					uint regaddr, u8 byte)
+static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func, u8 byte, uint regaddr)
 {
 	int err_ret;
 
@@ -271,8 +270,7 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 			if (fn)
 				sdio_writeb(func, *(u8 *)data, addr, &ret);
 			else
-				ret = brcmf_sdiod_f0_writeb(func, addr,
-							    *(u8 *)data);
+				ret = brcmf_sdiod_f0_writeb(func, *(u8 *)data, addr);
 		} else {
 			if (fn)
 				*(u8 *)data = sdio_readb(func, addr, &ret);
-- 
2.11.0
