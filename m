Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1134 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946262Ab3BHLGv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 06:06:51 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/5] brcmfmac: remove unnecessary locking in trap info
 processing
Date: Fri, 8 Feb 2013 12:06:35 +0100
Message-ID: <1360321595-31722-6-git-send-email-arend@broadcom.com> (sfid-20130208_120655_860074_EAD44B11)
In-Reply-To: <1360321595-31722-1-git-send-email-arend@broadcom.com>
References: <1360321595-31722-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Locking host access in trap info processing
is not needed as bus access functions do it on
their own.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 97764b4..3581763 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2721,10 +2721,8 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	}
 
 	/* Read hndrte_shared structure */
-	sdio_claim_host(bus->sdiodev->func[1]);
 	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&sh_le,
 				   sizeof(struct sdpcm_shared_le));
-	sdio_release_host(bus->sdiodev->func[1]);
 	if (rv < 0)
 		return rv;
 
@@ -2826,14 +2824,12 @@ static int brcmf_sdio_trap_info(struct brcmf_sdio *bus, struct sdpcm_shared *sh,
 	if ((sh->flags & SDPCM_SHARED_TRAP) == 0)
 		return 0;
 
-	sdio_claim_host(bus->sdiodev->func[1]);
 	error = brcmf_sdbrcm_membytes(bus, false, sh->trap_addr, (u8 *)&tr,
 				      sizeof(struct brcmf_trap_info));
 	if (error < 0)
 		return error;
 
 	nbytes = brcmf_sdio_dump_console(bus, sh, data, count);
-	sdio_release_host(bus->sdiodev->func[1]);
 	if (nbytes < 0)
 		return nbytes;
 
-- 
1.7.10.4


