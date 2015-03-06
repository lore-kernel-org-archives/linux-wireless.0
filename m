Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:53197 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbbCFRlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 12:41:00 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/5] brcmfmac: Fix possible race-condition.
Date: Fri, 6 Mar 2015 18:40:40 +0100
Message-ID: <1425663642-19725-4-git-send-email-arend@broadcom.com> (sfid-20150306_184103_867951_B7CB263D)
In-Reply-To: <1425663642-19725-1-git-send-email-arend@broadcom.com>
References: <1425663642-19725-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

SDIO is using a "shared" variable to handoff ctl frames to DPC
and to see when they are done. In a timeout situation this can
lead to erroneous situation where DPC started to handle the ctl
frame while the timeout expired. This patch will fix this by
adding locking around the shared variable.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 37 +++++++++++++++++---------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 161acd0..c9a9ff1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -2700,11 +2700,13 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	if (bus->ctrl_frame_stat && (bus->clkstate == CLK_AVAIL) &&
 	    data_ok(bus)) {
 		sdio_claim_host(bus->sdiodev->func[1]);
-		err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
-					      bus->ctrl_frame_len);
+		if (bus->ctrl_frame_stat) {
+			err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
+						      bus->ctrl_frame_len);
+			bus->ctrl_frame_err = err;
+			bus->ctrl_frame_stat = false;
+		}
 		sdio_release_host(bus->sdiodev->func[1]);
-		bus->ctrl_frame_err = err;
-		bus->ctrl_frame_stat = false;
 		brcmf_sdio_wait_event_wakeup(bus);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
@@ -2720,9 +2722,13 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		brcmf_err("failed backplane access over SDIO, halting operation\n");
 		atomic_set(&bus->intstatus, 0);
 		if (bus->ctrl_frame_stat) {
-			bus->ctrl_frame_err = -ENODEV;
-			bus->ctrl_frame_stat = false;
-			brcmf_sdio_wait_event_wakeup(bus);
+			sdio_claim_host(bus->sdiodev->func[1]);
+			if (bus->ctrl_frame_stat) {
+				bus->ctrl_frame_err = -ENODEV;
+				bus->ctrl_frame_stat = false;
+				brcmf_sdio_wait_event_wakeup(bus);
+			}
+			sdio_release_host(bus->sdiodev->func[1]);
 		}
 	} else if (atomic_read(&bus->intstatus) ||
 		   atomic_read(&bus->ipend) > 0 ||
@@ -2930,15 +2936,20 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	brcmf_sdio_trigger_dpc(bus);
 	wait_event_interruptible_timeout(bus->ctrl_wait, !bus->ctrl_frame_stat,
 					 msecs_to_jiffies(CTL_DONE_TIMEOUT));
-
-	if (!bus->ctrl_frame_stat) {
+	ret = 0;
+	if (bus->ctrl_frame_stat) {
+		sdio_claim_host(bus->sdiodev->func[1]);
+		if (bus->ctrl_frame_stat) {
+			brcmf_dbg(SDIO, "ctrl_frame timeout\n");
+			bus->ctrl_frame_stat = false;
+			ret = -ETIMEDOUT;
+		}
+		sdio_release_host(bus->sdiodev->func[1]);
+	}
+	if (!ret) {
 		brcmf_dbg(SDIO, "ctrl_frame complete, err=%d\n",
 			  bus->ctrl_frame_err);
 		ret = bus->ctrl_frame_err;
-	} else {
-		brcmf_dbg(SDIO, "ctrl_frame timeout\n");
-		bus->ctrl_frame_stat = false;
-		ret = -ETIMEDOUT;
 	}
 
 	if (ret)
-- 
1.9.1

