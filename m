Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52146 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755185AbdKMUgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:36:03 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 01/10] brcmfmac: Fix parameter order in brcmf_sdiod_f0_writeb()
Date: Mon, 13 Nov 2017 21:35:38 +0100
Message-Id: <1510605347-7629-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171113_213625_334510_BE38FB29)
In-Reply-To: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

All the other IO functions are the other way round in this
driver. Make this one match.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index cd58732..a8976a76 100644
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
1.9.1
