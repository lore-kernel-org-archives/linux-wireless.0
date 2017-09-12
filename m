Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:44623 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751332AbdILJWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 05:22:33 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/7] brcmfmac: handle FWHALT mailbox indication
Date: Tue, 12 Sep 2017 11:22:17 +0200
Message-Id: <1505208143-30166-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170912_112243_165524_73EF5BE0)
In-Reply-To: <1505208143-30166-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1505208143-30166-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware uses a mailbox to communicate to the host what is going
on. In the driver we validate the bit received. Various people seen
the following message:

 brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012

Bit 4 is cause of this message, but this actually indicates the firmware
has halted. Handle this bit by giving a more meaningful error message.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 613caca..3d79664 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -260,10 +260,11 @@ struct rte_console {
 #define I_HMB_HOST_INT	I_HMB_SW3	/* Miscellaneous Interrupt */
 
 /* tohostmailboxdata */
-#define HMB_DATA_NAKHANDLED	1	/* retransmit NAK'd frame */
-#define HMB_DATA_DEVREADY	2	/* talk to host after enable */
-#define HMB_DATA_FC		4	/* per prio flowcontrol update flag */
-#define HMB_DATA_FWREADY	8	/* fw ready for protocol activity */
+#define HMB_DATA_NAKHANDLED	0x0001	/* retransmit NAK'd frame */
+#define HMB_DATA_DEVREADY	0x0002	/* talk to host after enable */
+#define HMB_DATA_FC		0x0004	/* per prio flowcontrol update flag */
+#define HMB_DATA_FWREADY	0x0008	/* fw ready for protocol activity */
+#define HMB_DATA_FWHALT		0x0010	/* firmware halted */
 
 #define HMB_DATA_FCDATA_MASK	0xff000000
 #define HMB_DATA_FCDATA_SHIFT	24
@@ -1094,6 +1095,10 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 			  offsetof(struct sdpcmd_regs, tosbmailbox));
 	bus->sdcnt.f1regdata += 2;
 
+	/* dongle indicates the firmware has halted/crashed */
+	if (hmb_data & HMB_DATA_FWHALT)
+		brcmf_err("mailbox indicates firmware halted\n");
+
 	/* Dongle recomposed rx frames, accept them again */
 	if (hmb_data & HMB_DATA_NAKHANDLED) {
 		brcmf_dbg(SDIO, "Dongle reports NAK handled, expect rtx of %d\n",
@@ -1151,6 +1156,7 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 			 HMB_DATA_NAKHANDLED |
 			 HMB_DATA_FC |
 			 HMB_DATA_FWREADY |
+			 HMB_DATA_FWHALT |
 			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK))
 		brcmf_err("Unknown mailbox data content: 0x%02x\n",
 			  hmb_data);
-- 
1.9.1
