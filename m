Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58120 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752921AbeEOJPI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:15:08 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 7/8] brcmfmac: trigger memory dump upon firmware halt signal
Date: Tue, 15 May 2018 11:14:50 +0200
Message-Id: <1526375691-31789-8-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180515_111547_902888_492C3DD7)
In-Reply-To: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

PCIe dongle firmware signals a halt/trap through mailbox interrupt.
Trigger a memory dump upon receiving such signal could help to provide
useful information for issue debug.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 5baa837..45928b5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -182,6 +182,7 @@ enum brcmf_pcie_state {
 #define BRCMF_D2H_DEV_D3_ACK			0x00000001
 #define BRCMF_D2H_DEV_DS_ENTER_REQ		0x00000002
 #define BRCMF_D2H_DEV_DS_EXIT_NOTE		0x00000004
+#define BRCMF_D2H_DEV_FWHALT			0x10000000
 
 #define BRCMF_H2D_HOST_D3_INFORM		0x00000001
 #define BRCMF_H2D_HOST_DS_ACK			0x00000002
@@ -717,6 +718,10 @@ static void brcmf_pcie_handle_mb_data(struct brcmf_pciedev_info *devinfo)
 		devinfo->mbdata_completed = true;
 		wake_up(&devinfo->mbdata_resp_wait);
 	}
+	if (dtoh_mb_data & BRCMF_D2H_DEV_FWHALT) {
+		brcmf_dbg(PCIE, "D2H_MB_DATA: FW HALT\n");
+		brcmf_dev_coredump(&devinfo->pdev->dev);
+	}
 }
 
 
-- 
1.9.1
