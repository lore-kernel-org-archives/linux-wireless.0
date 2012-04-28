Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4507 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758346Ab2D1B5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 21:57:15 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] brcmfmac: postpone interrupt register function
Date: Fri, 27 Apr 2012 18:56:58 -0700
Message-ID: <1335578219-4224-4-git-send-email-frankyl@broadcom.com> (sfid-20120428_035721_999117_21E3B68F)
In-Reply-To: <1335578219-4224-1-git-send-email-frankyl@broadcom.com>
References: <1335578219-4224-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For out of band interrupt which is going to be introduced shortly,
the interrupt register function must be called after firmware is
downloaded. This patch moves it from brcmf_sdbrcm_probe to
brcmf_sdbrcm_bus_init.

Reviewed-by: pieter-paul giesberts <pieterpg@broadcom.com>
Reviewed-by: arend van spriel <arend@broadcom.com>
Signed-off-by: franky lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 46fc16f..b82edaf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3507,6 +3507,12 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
+	if (ret == 0) {
+		ret = brcmf_sdcard_intr_reg(bus->sdiodev);
+		if (ret != 0)
+			brcmf_dbg(ERROR, "intr register failed:%d\n", ret);
+	}
+
 	/* If we didn't come up, turn off backplane clock */
 	if (bus_if->state != BRCMF_BUS_DATA)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
@@ -3967,15 +3973,6 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 		goto fail;
 	}
 
-	/* Register interrupt callback, but mask it (not operational yet). */
-	brcmf_dbg(INTR, "disable SDIO interrupts (not interested yet)\n");
-	ret = brcmf_sdcard_intr_reg(bus->sdiodev);
-	if (ret != 0) {
-		brcmf_dbg(ERROR, "FAILED: sdcard_intr_reg returned %d\n", ret);
-		goto fail;
-	}
-	brcmf_dbg(INTR, "registered SDIO interrupt function ok\n");
-
 	brcmf_dbg(INFO, "completed!!\n");
 
 	/* if firmware path present try to download and bring up bus */
-- 
1.7.9.5


