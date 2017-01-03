Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34443 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759515AbdACQmj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 11:42:39 -0500
Received: by mail-lf0-f68.google.com with SMTP id d16so30583455lfb.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 08:42:39 -0800 (PST)
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
Subject: [PATCH] brcmfmac: check if we can support used firmware API version
Date: Tue,  3 Jan 2017 17:11:40 +0100
Message-Id: <20170103161140.16919-1-zajec5@gmail.com> (sfid-20170103_174257_238876_733786D5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Every new firmware API will most likely require changes in our code to
support it. Right now we support 2 versions only. Refuse to init if we
detect newer version.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
Hi Arend,

I think you were concerned about possible firmware API changes. Please
review this patch, I hope it's a proper check for running unsupported
firmware version which could result in broken communication between host
driver and a device.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 0babfc7..c69ae84 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6816,6 +6816,11 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		brcmf_err("Failed to get D11 version (%d)\n", err);
 		goto priv_out;
 	}
+	if (io_type > BRCMU_D11AC_IOTYPE) {
+		brcmf_err("Unsupported IO version %d\n", io_type);
+		goto priv_out;
+	}
+
 	cfg->d11inf.io_type = (u8)io_type;
 	brcmu_d11_attach(&cfg->d11inf);
 
-- 
2.10.1
