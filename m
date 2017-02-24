Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33989 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdBXNKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 08:10:45 -0500
Received: by mail-lf0-f66.google.com with SMTP id x142so568386lfd.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 05:10:44 -0800 (PST)
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
Subject: [PATCH 4.12] brcmfmac: put chip into passive mode (when attaching) just once
Date: Fri, 24 Feb 2017 14:10:27 +0100
Message-Id: <20170224131027.29880-1-zajec5@gmail.com> (sfid-20170224_141303_580122_2F496E40)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

It avoids some unnecessary work. Most likely there wasn't much sense in
doing this before bus reset anyway, as reset is supposed to put chip
into default state. In PCIe code (only bus implementing reset) we e.g.
use watchdog to perform a chip "reboot".

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 05f22ff81d60..670f2f50f9e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -967,16 +967,14 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 	if (ret)
 		return ret;
 
-	/* assure chip is passive for core access */
-	brcmf_chip_set_passive(&ci->pub);
-
 	/* Call bus specific reset function now. Cores have been determined
 	 * but further access may require a chip specific reset at this point.
 	 */
-	if (ci->ops->reset) {
+	if (ci->ops->reset)
 		ci->ops->reset(ci->ctx, &ci->pub);
-		brcmf_chip_set_passive(&ci->pub);
-	}
+
+	/* assure chip is passive for core access */
+	brcmf_chip_set_passive(&ci->pub);
 
 	return brcmf_chip_get_raminfo(ci);
 }
-- 
2.11.0
