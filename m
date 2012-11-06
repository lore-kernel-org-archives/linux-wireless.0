Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4508 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab2KFAWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:49 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/24] brcmfmac: remove brcmf_sdbrcm_wait_for_event
Date: Mon, 5 Nov 2012 16:22:25 -0800
Message-ID: <1352161352-30405-18-git-send-email-frankyl@broadcom.com> (sfid-20121106_013116_751132_2C935A3C)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_sdbrcm_wait_for_event is now a one line function and only
used by brcmf_sdbrcm_bus_txctl. Intergrate the function call
wait_event_interruptible_timeout into brcmf_sdbrcm_bus_txctl.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 7b8c653..eec1cbf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1787,13 +1787,6 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 }
 
 static void
-brcmf_sdbrcm_wait_for_event(struct brcmf_sdio *bus, bool *lockvar)
-{
-	wait_event_interruptible_timeout(bus->ctrl_wait, !*lockvar, HZ * 2);
-	return;
-}
-
-static void
 brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
 {
 	if (waitqueue_active(&bus->ctrl_wait))
@@ -2662,7 +2655,9 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 		bus->ctrl_frame_buf = frame;
 		bus->ctrl_frame_len = len;
 
-		brcmf_sdbrcm_wait_for_event(bus, &bus->ctrl_frame_stat);
+		wait_event_interruptible_timeout(bus->ctrl_wait,
+						 !bus->ctrl_frame_stat,
+						 msecs_to_jiffies(2000));
 
 		if (!bus->ctrl_frame_stat) {
 			brcmf_dbg(INFO, "ctrl_frame_stat == false\n");
-- 
1.7.9.5


