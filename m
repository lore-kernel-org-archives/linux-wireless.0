Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36274 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCRCXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:23:33 -0400
Received: by mail-pf0-f171.google.com with SMTP id u190so146112294pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:23:32 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 07/19] brcmfmac: Delete unnecessary variable initialisation
Date: Fri, 18 Mar 2016 13:23:24 +1100
Message-Id: <d863ece71c5bf88576103c3d4e4ec813caf11d87.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032335_772025_19983602)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>

In brcmf_sdio_download_firmware(), bcmerror is set by the call to
brcmf_sdio_download_code_file(), before it's checked in the following
line.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Arend van Spriel <arend@broadcom.com>
[Rewrote commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 43fd3f4..fa2179d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3261,7 +3261,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 					const struct firmware *fw,
 					void *nvram, u32 nvlen)
 {
-	int bcmerror = -EFAULT;
+	int bcmerror;
 	u32 rstvec;
 
 	sdio_claim_host(bus->sdiodev->func[1]);
-- 
2.7.0

