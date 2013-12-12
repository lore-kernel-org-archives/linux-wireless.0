Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:11789 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab3LLK7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:17 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/18] brcmfmac: remove brcmf_sdio_regrw_helper() from header file
Date: Thu, 12 Dec 2013 11:58:54 +0100
Message-ID: <1386845946-9859-7-git-send-email-arend@broadcom.com> (sfid-20131212_115935_361555_E54D7AAB)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make brcmf_sdio_regrw_helper() static removing its use outside of
the bcmsdh.c source file.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c    |    5 ++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c  |    4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h |    2 --
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 5919b45..8ba1b77 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -369,9 +369,8 @@ brcmf_sdio_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
 	return 0;
 }
 
-int
-brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
-			void *data, bool write)
+static int brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
+				   void *data, bool write)
 {
 	u8 func_num, reg_size;
 	s32 retry = 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index c3f3d8d..a70feb5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2316,7 +2316,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	addr = bus->ci->c_inf[idx].base +
 	       offsetof(struct sdpcmd_regs, intstatus);
 
-	ret = brcmf_sdio_regrw_helper(bus->sdiodev, addr, &val, false);
+	val = brcmf_sdio_regrl(bus->sdiodev, addr, &ret);
 	bus->sdcnt.f1regdata++;
 	if (ret != 0)
 		val = 0;
@@ -2326,7 +2326,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 
 	/* Clear interrupts */
 	if (val) {
-		ret = brcmf_sdio_regrw_helper(bus->sdiodev, addr, &val, true);
+		brcmf_sdio_regwl(bus->sdiodev, addr, val, &ret);
 		bus->sdcnt.f1regdata++;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 8b8f2a9..a1e5f72 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -194,8 +194,6 @@ void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr, u8 data,
 		      int *ret);
 void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data,
 		      int *ret);
-int brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
-			    void *data, bool write);
 
 /* Buffer transfer to/from device (client) core via cmd53.
  *   fn:       function number
-- 
1.7.10.4

