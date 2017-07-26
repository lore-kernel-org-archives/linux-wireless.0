Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:33848 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdGZU0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:26:09 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 01/34] brcmfmac: Fix parameter order in brcmf_sdiod_f0_writeb()
Date: Wed, 26 Jul 2017 21:25:24 +0100
Message-Id: <20170726202557.15632-2-ian@mnementh.co.uk> (sfid-20170726_222621_477378_D5323498)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	All the other IO functions are the other way round in this
driver. Make this one match.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 984c1d0560b1..f585dfd89453 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -230,8 +230,8 @@ void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 	sdiodev->state = state;
 }
 
-static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func,
-					uint regaddr, u8 byte)
+static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func, u8 byte,
+					uint regaddr)
 {
 	int err_ret;
 
@@ -269,8 +269,8 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 			if (fn)
 				sdio_writeb(func, *(u8 *)data, addr, &ret);
 			else
-				ret = brcmf_sdiod_f0_writeb(func, addr,
-							    *(u8 *)data);
+				ret = brcmf_sdiod_f0_writeb(func, *(u8 *)data,
+							    addr);
 		} else {
 			if (fn)
 				*(u8 *)data = sdio_readb(func, addr, &ret);
-- 
2.11.0
