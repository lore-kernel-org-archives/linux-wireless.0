Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34771 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaE0K4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 14/16] brcmfmac: Increase max buffer size for receiving control message from dongle
Date: Tue, 27 May 2014 12:56:26 +0200
Message-ID: <1401188188-16492-15-git-send-email-arend@broadcom.com> (sfid-20140527_125722_688438_4CE358A4)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

The max buffer size for receiving control message from dongle needs to be
increased considering possible block padding. Otherwise some big control
message can't be received due to buffer overrun check.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 506ef0d..8fa0dbb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -4086,8 +4086,13 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		goto fail;
 	}
 
+	/* Query the F2 block size, set roundup accordingly */
+	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
+	bus->roundup = min(max_roundup, bus->blocksize);
+
 	/* Allocate buffers */
 	if (bus->sdiodev->bus_if->maxctl) {
+		bus->sdiodev->bus_if->maxctl += bus->roundup;
 		bus->rxblen =
 		    roundup((bus->sdiodev->bus_if->maxctl + SDPCM_HDRLEN),
 			    ALIGNMENT) + bus->head_align;
@@ -4115,10 +4120,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->idletime = BRCMF_IDLE_INTERVAL;
 	bus->idleclock = BRCMF_IDLE_ACTIVE;
 
-	/* Query the F2 block size, set roundup accordingly */
-	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
-	bus->roundup = min(max_roundup, bus->blocksize);
-
 	/* SR state */
 	bus->sleeping = false;
 	bus->sr_enabled = false;
-- 
1.7.9.5

