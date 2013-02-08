Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2426 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946225Ab3BHLGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 06:06:45 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/5] brcmfmac: turn clocks on when reading shared info
Date: Fri, 8 Feb 2013 12:06:34 +0100
Message-ID: <1360321595-31722-5-git-send-email-arend@broadcom.com> (sfid-20130208_120649_822220_12888A0A)
In-Reply-To: <1360321595-31722-1-git-send-email-arend@broadcom.com>
References: <1360321595-31722-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Make sure backplane clocks are on while reading crash data.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 9a1f823..97764b4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2699,6 +2699,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	 * address of sdpcm_shared structure
 	 */
 	sdio_claim_host(bus->sdiodev->func[1]);
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 	rv = brcmf_sdbrcm_membytes(bus, false, shaddr,
 				   (u8 *)&addr_le, 4);
 	sdio_release_host(bus->sdiodev->func[1]);
-- 
1.7.10.4


