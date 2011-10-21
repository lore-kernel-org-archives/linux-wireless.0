Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2879 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab1JUOQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:50 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 01/17] brcm80211: fmac: allow wd timer to be disabled
 when bus down
Date: Fri, 21 Oct 2011 16:16:19 +0200
Message-ID: <1319206595-17138-2-git-send-email-arend@broadcom.com> (sfid-20111021_161705_725400_AF232887)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Watchdog timer should be able to be stopped even firmware is not
loaded.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index c6825f2..785ab08 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -4579,10 +4579,6 @@ struct device *brcmf_bus_get_device(struct brcmf_bus *bus)
 void
 brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 {
-	/* don't start the wd until fw is loaded */
-	if (bus->drvr->busstate == BRCMF_BUS_DOWN)
-		return;
-
 	/* Totally stop the timer */
 	if (!wdtick && bus->wd_timer_valid == true) {
 		del_timer_sync(&bus->timer);
@@ -4591,6 +4587,10 @@ brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 		return;
 	}
 
+	/* don't start the wd until fw is loaded */
+	if (bus->drvr->busstate == BRCMF_BUS_DOWN)
+		return;
+
 	if (wdtick) {
 		if (bus->save_ms != BRCMF_WD_POLL_MS) {
 			if (bus->wd_timer_valid == true)
-- 
1.7.4.1


