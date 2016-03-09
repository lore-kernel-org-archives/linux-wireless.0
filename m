Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35842 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbcCIJOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 04:14:52 -0500
Received: by mail-oi0-f43.google.com with SMTP id r187so30735108oih.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2016 01:14:52 -0800 (PST)
From: Hante Meuleman <hante.meuleman@broadcom.com>
References: <1457508326-24420-1-git-send-email-hui.wang@canonical.com>
In-Reply-To: <1457508326-24420-1-git-send-email-hui.wang@canonical.com>
MIME-Version: 1.0
Date: Wed, 9 Mar 2016 10:14:51 +0100
Message-ID: <6d617d09cc3f449be4c6ce593ab84cd4@mail.gmail.com> (sfid-20160309_101458_640873_FF5F57CF)
Subject: RE: [PATCH] brcmfmac: Remove waitqueue_active check
To: Hui Wang <hui.wang@canonical.com>, brudley@broadcom.com,
	arend@broadcom.com, frankyl@broadcom.com, meuleman@broadcom.com,
	pieterpg@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hui,

Excellent find. Looks like a perfect solution to me.

Regards,
Hante

-----Original Message-----
From: Hui Wang [mailto:hui.wang@canonical.com]
Sent: Wednesday, March 09, 2016 8:25 AM
To: brudley@broadcom.com; arend@broadcom.com; frankyl@broadcom.com;
meuleman@broadcom.com; pieterpg@broadcom.com
Cc: linux-wireless@vger.kernel.org; brcm80211-dev-list@broadcom.com;
hui.wang@canonical.com
Subject: [PATCH] brcmfmac: Remove waitqueue_active check

We met a problem of pm_suspend  when repeated closing/opening the lid
on a Lenovo laptop (1/20 reproduce rate), below is the log:

[ 199.735876] PM: Entering mem sleep
[ 199.750516] e1000e: EEE TX LPI TIMER: 00000011
[ 199.856638] Trying to free nonexistent resource
<000000000000d000-000000000000d0ff>
[ 201.753566] brcmfmac: brcmf_pcie_suspend: Timeout on response for
entering D3 substate
[ 201.753581] pci_legacy_suspend(): brcmf_pcie_suspend+0x0/0x1f0
[brcmfmac] returns -5
[ 201.753585] dpm_run_callback(): pci_pm_suspend+0x0/0x160 returns -5
[ 201.753589] PM: Device 0000:04:00.0 failed to suspend async: error -5

Through debugging, we found when problem happens, it is not the device
fails to enter D3, but the signal D3_ACK comes too early to pass the
waitqueue_active() check.

Just like this:
brcmf_pcie_send_mb_data(devinfo, BRCMF_H2D_HOST_D3_INFORM);
// signal is triggered here
wait_event_timeout(devinfo->mbdata_resp_wait, devinfo->mbdata_completed,
		   BRCMF_PCIE_MBDATA_TIMEOUT);

So far I think it is safe to remove waitqueue_active check since there
is only one place to trigger this signal (sending
BRCMF_H2D_HOST_D3_INFORM). And it is not a problem calling wake_up
event earlier than calling wait_event.

Cc: Brett Rudley <brudley@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>
Cc: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 0480b70..5f12ff3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -675,10 +675,8 @@ static void brcmf_pcie_handle_mb_data(struct
brcmf_pciedev_info *devinfo)
 		brcmf_dbg(PCIE, "D2H_MB_DATA: DEEP SLEEP EXIT\n");
 	if (dtoh_mb_data & BRCMF_D2H_DEV_D3_ACK) {
 		brcmf_dbg(PCIE, "D2H_MB_DATA: D3 ACK\n");
-		if (waitqueue_active(&devinfo->mbdata_resp_wait)) {
-			devinfo->mbdata_completed = true;
-			wake_up(&devinfo->mbdata_resp_wait);
-		}
+		devinfo->mbdata_completed = true;
+		wake_up(&devinfo->mbdata_resp_wait);
 	}
 }

-- 
1.9.1
