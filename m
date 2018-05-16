Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48256 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752482AbeEPMMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 08:12:30 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 6/6] brcmfmac: trigger memory dump on SDIO firmware halt message
Date: Wed, 16 May 2018 14:12:03 +0200
Message-Id: <1526472723-15758-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180516_141241_505564_9013DF73)
In-Reply-To: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

Attempt to dump dongle memory for debug upon receiving firmware halt
message through dongle to host mail box interrupt.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 412a05b..c99a191 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1072,8 +1072,10 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 	bus->sdcnt.f1regdata += 2;
 
 	/* dongle indicates the firmware has halted/crashed */
-	if (hmb_data & HMB_DATA_FWHALT)
+	if (hmb_data & HMB_DATA_FWHALT) {
 		brcmf_err("mailbox indicates firmware halted\n");
+		brcmf_dev_coredump(&sdiod->func1->dev);
+	}
 
 	/* Dongle recomposed rx frames, accept them again */
 	if (hmb_data & HMB_DATA_NAKHANDLED) {
-- 
1.9.1
