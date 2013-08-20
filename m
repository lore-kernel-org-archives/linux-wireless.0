Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3168 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab3HTOBC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 10:01:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/12] brcmsmac: add debug info message providing phy
 and radio info
Date: Tue, 20 Aug 2013 16:00:38 +0200
Message-ID: <1377007246-9957-5-git-send-email-arend@broadcom.com> (sfid-20130820_160108_040507_B953D985)
In-Reply-To: <1377007246-9957-1-git-send-email-arend@broadcom.com>
References: <1377007246-9957-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For debug purposes it is good to have the phy and radio information
available in the log. Only logged when driver is built when BRCMDBG
or BRCM_TRACING kconfig are set.

Tested-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
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


