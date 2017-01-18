Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35778 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751692AbdARKtY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 05:49:24 -0500
Received: by mail-lf0-f67.google.com with SMTP id v186so1176697lfa.2
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 02:49:23 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 3/4] brcmfmac: drop brcmf_bus_detach and inline its code
Date: Wed, 18 Jan 2017 11:48:53 +0100
Message-Id: <20170118104854.32231-3-zajec5@gmail.com> (sfid-20170118_114927_898759_3692C89F)
In-Reply-To: <20170118104854.32231-1-zajec5@gmail.com>
References: <20170118104854.32231-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Driver used to call brcmf_bus_detach only from one place and it already
contained a check for drvr not being NULL. We can get rid of this extra
function, call brcmf_bus_stop directly and simplify the code.
There also isn't brcmf_bus_attach function which one could expect so it
looks more consistent this way.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9e6f60a..372d2c4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1075,16 +1075,6 @@ void brcmf_bus_add_txhdrlen(struct device *dev, uint len)
 	}
 }
 
-static void brcmf_bus_detach(struct brcmf_pub *drvr)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (drvr) {
-		/* Stop the bus module */
-		brcmf_bus_stop(drvr->bus_if);
-	}
-}
-
 void brcmf_dev_reset(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -1131,7 +1121,7 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_fws_deinit(drvr);
 
-	brcmf_bus_detach(drvr);
+	brcmf_bus_stop(drvr->bus_if);
 
 	brcmf_proto_detach(drvr);
 
-- 
2.10.1
