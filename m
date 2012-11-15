Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3393 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255Ab2KOCqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:35 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 13/19] brcmfmac: Any error should result in failure of
 probe.
Date: Wed, 14 Nov 2012 18:46:17 -0800
Message-ID: <1352947583-25341-14-git-send-email-frankyl@broadcom.com> (sfid-20121115_034653_498908_17F9F1E3)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

In brcmf_sdbrcm_probe only error ELINK is seen as error. However
brcmf_bus_start can return many more error codes and all should
result in failed init of driver.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index ba339f7..e2351a7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3994,10 +3994,8 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	/* if firmware path present try to download and bring up bus */
 	ret = brcmf_bus_start(bus->sdiodev->dev);
 	if (ret != 0) {
-		if (ret == -ENOLINK) {
-			brcmf_dbg(ERROR, "dongle is not responding\n");
-			goto fail;
-		}
+		brcmf_dbg(ERROR, "dongle is not responding\n");
+		goto fail;
 	}
 
 	return bus;
-- 
1.7.9.5


