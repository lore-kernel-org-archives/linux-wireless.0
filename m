Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:25856 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaA2Och (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:37 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/14] brcmfmac: on sdio remove first detach bus then stop worker.
Date: Wed, 29 Jan 2014 15:32:18 +0100
Message-ID: <1391005944-3220-9-git-send-email-arend@broadcom.com> (sfid-20140129_153252_168243_2D1AFBC9)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Currently the function sdio_remove will first destroy the datawork
workqueue and then detach the bus. This can create the situation
where work gets added on non-existing work queue resulting in panic.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index be2ec8a..0981854 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -4205,14 +4205,14 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		/* De-register interrupt handler */
 		brcmf_sdiod_intr_unregister(bus->sdiodev);
 
-		cancel_work_sync(&bus->datawork);
-		if (bus->brcmf_wq)
-			destroy_workqueue(bus->brcmf_wq);
-
 		if (bus->sdiodev->bus_if->drvr) {
 			brcmf_detach(bus->sdiodev->dev);
 		}
 
+		cancel_work_sync(&bus->datawork);
+		if (bus->brcmf_wq)
+			destroy_workqueue(bus->brcmf_wq);
+
 		if (bus->ci) {
 			if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
 				sdio_claim_host(bus->sdiodev->func[1]);
-- 
1.7.10.4

