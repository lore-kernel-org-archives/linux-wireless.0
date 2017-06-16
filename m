Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752647AbdFPNOx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 09:14:53 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Jelle van der Waa <jelle@vdwaa.nl>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH 1/2] brcmfmac: Log chip id and revision
Date: Fri, 16 Jun 2017 15:14:48 +0200
Message-Id: <20170616131449.12108-1-hdegoede@redhat.com> (sfid-20170616_151456_645841_0BEBB820)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For debugging some problems, it is useful to know the chip revision
add a brcmf_info message logging this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index e03450059b06..4ed40c94bda9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4214,6 +4214,8 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	if (ret)
 		goto fail;
 
+	brcmf_info("Loading firmware %s for chip %08x rev %08x\n",
+		   sdiodev->fw_name, bus->ci->chip, bus->ci->chiprev);
 	ret = brcmf_fw_get_firmwares(sdiodev->dev, BRCMF_FW_REQUEST_NVRAM,
 				     sdiodev->fw_name, sdiodev->nvram_name,
 				     brcmf_sdio_firmware_callback);
-- 
2.13.0
