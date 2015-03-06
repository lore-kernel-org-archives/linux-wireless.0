Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24792 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbbCFRkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 12:40:49 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/5] brcmfmac: Fix oops when SDIO device is removed.
Date: Fri, 6 Mar 2015 18:40:38 +0100
Message-ID: <1425663642-19725-2-git-send-email-arend@broadcom.com> (sfid-20150306_184054_031728_C416021F)
In-Reply-To: <1425663642-19725-1-git-send-email-arend@broadcom.com>
References: <1425663642-19725-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On removal of SDIO card both functions of card will be getting
a remove call. When the first is hanging in ctrl frame xmit then
the second will cause oops. This patch fixes the xmit ctrl
handling in case of serious errors and also limits the handling
for remove to function 1 only.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c   | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index c438ccd..ffb0e2d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1194,7 +1194,7 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	brcmf_dbg(SDIO, "sdio device ID: 0x%04x\n", func->device);
 	brcmf_dbg(SDIO, "Function: %d\n", func->num);
 
-	if (func->num != 1 && func->num != 2)
+	if (func->num != 1)
 		return;
 
 	bus_if = dev_get_drvdata(&func->dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 257ee70..c54ba4f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -2740,6 +2740,11 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	if ((bus->sdiodev->state != BRCMF_SDIOD_DATA) || (err != 0)) {
 		brcmf_err("failed backplane access over SDIO, halting operation\n");
 		atomic_set(&bus->intstatus, 0);
+		if (bus->ctrl_frame_stat) {
+			bus->ctrl_frame_err = -ENODEV;
+			bus->ctrl_frame_stat = false;
+			brcmf_sdio_wait_event_wakeup(bus);
+		}
 	} else if (atomic_read(&bus->intstatus) ||
 		   atomic_read(&bus->ipend) > 0 ||
 		   (!atomic_read(&bus->fcstate) &&
-- 
1.9.1

