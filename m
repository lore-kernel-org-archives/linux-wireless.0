Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:64984 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaHGMpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 08:45:14 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-3.17 1/2] brcmfmac: fix curly brace mistake in brcmf_pcie_handle_mb_data()
Date: Thu, 7 Aug 2014 14:45:08 +0200
Message-ID: <1407415509-22442-2-git-send-email-arend@broadcom.com> (sfid-20140807_144531_326853_FBF6EA1E)
In-Reply-To: <1407415509-22442-1-git-send-email-arend@broadcom.com>
References: <1407415509-22442-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Running coccicheck on brcm80211 drivers resulted in following report:

$ make coccicheck MODE=report M=drivers/net/wireless/brcm80211

  drivers/net/wireless/brcm80211/brcmfmac/pcie.c:595:2-43:
    code aligned with following code on line 596

It revealed that due to a merge failure a block statement lost its
curly braces where it should not.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index bc972c0..e5101b2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -591,12 +591,13 @@ static void brcmf_pcie_handle_mb_data(struct brcmf_pciedev_info *devinfo)
 	}
 	if (dtoh_mb_data & BRCMF_D2H_DEV_DS_EXIT_NOTE)
 		brcmf_dbg(PCIE, "D2H_MB_DATA: DEEP SLEEP EXIT\n");
-	if (dtoh_mb_data & BRCMF_D2H_DEV_D3_ACK)
+	if (dtoh_mb_data & BRCMF_D2H_DEV_D3_ACK) {
 		brcmf_dbg(PCIE, "D2H_MB_DATA: D3 ACK\n");
 		if (waitqueue_active(&devinfo->mbdata_resp_wait)) {
 			devinfo->mbdata_completed = true;
 			wake_up(&devinfo->mbdata_resp_wait);
 		}
+	}
 }
 
 
-- 
1.9.1

