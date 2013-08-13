Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2884 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758921Ab3HMUEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:32 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>
Subject: [RFT V2 05/13] brcmsmac: add debug info message providing phy
 and radio info
Date: Tue, 13 Aug 2013 22:03:32 +0200
Message-ID: <1376424220-10765-6-git-send-email-arend@broadcom.com> (sfid-20130813_220439_778402_8F0FF331)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For debug purposes it is good to have the phy and radio information
available in the log. Only logged when driver is build when BRCMDBG
or BRCM_TRACING kconfig are set.

Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 7ca10bf..c3c6123 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4652,7 +4652,9 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 		wlc->band->phyrev = wlc_hw->band->phyrev;
 		wlc->band->radioid = wlc_hw->band->radioid;
 		wlc->band->radiorev = wlc_hw->band->radiorev;
-
+		brcms_dbg_info(core, "wl%d: phy %u/%u radio %x/%u\n", unit,
+			       wlc->band->phytype, wlc->band->phyrev,
+			       wlc->band->radioid, wlc->band->radiorev);
 		/* default contention windows size limits */
 		wlc_hw->band->CWmin = APHY_CWMIN;
 		wlc_hw->band->CWmax = PHY_CWMAX;
-- 
1.7.10.4


