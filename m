Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:50380 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbcAAT0k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 14:26:40 -0500
Subject: [PATCH] net-brcmfmac: Delete an unnecessary variable initialisation
 in brcmf_sdio_download_firmware()
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5686D2E0.2010309@users.sourceforge.net> (sfid-20160101_202751_144210_D0D10B0D)
Date: Fri, 1 Jan 2016 20:26:24 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 1 Jan 2016 20:20:15 +0100

Omit explicit initialisation at the beginning for one local variable
that is redefined before its first use.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index ceb2a75..c21eeb1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3260,7 +3260,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 					const struct firmware *fw,
 					void *nvram, u32 nvlen)
 {
-	int bcmerror = -EFAULT;
+	int bcmerror;
 	u32 rstvec;
 
 	sdio_claim_host(bus->sdiodev->func[1]);
-- 
2.6.3

