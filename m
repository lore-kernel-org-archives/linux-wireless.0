Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4838 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759567Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/24] brcm80211: fmac: remove unused parameter of
 brcmf_sdbrcm_probe
Date: Tue, 22 Nov 2011 17:21:49 -0800
Message-ID: <1322011319-24863-15-git-send-email-frankyl@broadcom.com> (sfid-20111123_022220_739377_4DE94B9E)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bus_no, slot, func and bustype are no longer needed by brcmf_sdbrcm_probe.
This patch removes them.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    3 +--
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 668eb36..6c85d66 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -432,7 +432,7 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->sbwad = SI_ENUM_BASE;
 
 	/* try to attach to the target device */
-	sdiodev->bus = brcmf_sdbrcm_probe(0, 0, 0, 0, regs, sdiodev);
+	sdiodev->bus = brcmf_sdbrcm_probe(regs, sdiodev);
 	if (!sdiodev->bus) {
 		brcmf_dbg(ERROR, "device attach failed\n");
 		ret = -ENODEV;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 8acd1bb..f01da6a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3861,8 +3861,7 @@ static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
-void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
-			 u32 regsva, struct brcmf_sdio_dev *sdiodev)
+void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
 	struct brcmf_bus *bus;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 4e501f8..0618f5e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -258,8 +258,7 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
 				    bool enable);
 
-extern void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
-				u32 regsva, struct brcmf_sdio_dev *sdiodev);
+extern void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev);
 extern void brcmf_sdbrcm_disconnect(void *ptr);
 extern void brcmf_sdbrcm_isr(void *arg);
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.5.4


