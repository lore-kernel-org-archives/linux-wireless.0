Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34101 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932111AbdA3PKO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 10:10:14 -0500
Received: by mail-lf0-f67.google.com with SMTP id q89so31607388lfi.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2017 07:10:03 -0800 (PST)
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
Subject: [PATCH 1/2] brcmfmac: check brcmf_bus_get_memdump result for error
Date: Mon, 30 Jan 2017 16:09:51 +0100
Message-Id: <20170130150952.7133-1-zajec5@gmail.com> (sfid-20170130_161021_805865_A00299A7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This method may be unsupported (see: USB bus) or may just fail (see:
SDIO bus).
While at it rework logic in brcmf_sdio_bus_get_memdump function to avoid
too many conditional code nesting levels.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   | 23 +++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index e64557c35553..6f8a4b074c31 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -32,16 +32,25 @@ static int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 {
 	void *dump;
 	size_t ramsize;
+	int err;
 
 	ramsize = brcmf_bus_get_ramsize(bus);
-	if (ramsize) {
-		dump = vzalloc(len + ramsize);
-		if (!dump)
-			return -ENOMEM;
-		memcpy(dump, data, len);
-		brcmf_bus_get_memdump(bus, dump + len, ramsize);
-		dev_coredumpv(bus->dev, dump, len + ramsize, GFP_KERNEL);
+	if (!ramsize)
+		return -ENOTSUPP;
+
+	dump = vzalloc(len + ramsize);
+	if (!dump)
+		return -ENOMEM;
+
+	memcpy(dump, data, len);
+	err = brcmf_bus_get_memdump(bus, dump + len, ramsize);
+	if (err) {
+		vfree(dump);
+		return err;
 	}
+
+	dev_coredumpv(bus->dev, dump, len + ramsize, GFP_KERNEL);
+
 	return 0;
 }
 
-- 
2.11.0
