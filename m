Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59031 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795Ab2LGQKL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 11:10:11 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcmsmac: add support for BCM43224 with PCI id of 14e4:a8d8
Date: Fri,  7 Dec 2012 17:10:03 +0100
Message-Id: <1354896603-5803-1-git-send-email-hauke@hauke-m.de> (sfid-20121207_171024_430190_27B0A687)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This device can be found on some embedded devices connected to a
Broadcom SoC like the BCM4718.
I tested this with my Netgear WNDR3400 v1.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 2599cd0..17594de 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4500,7 +4500,8 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 
 	/* check device id(srom, nvram etc.) to set bands */
 	if (wlc_hw->deviceid == BCM43224_D11N_ID ||
-	    wlc_hw->deviceid == BCM43224_D11N_ID_VEN1)
+	    wlc_hw->deviceid == BCM43224_D11N_ID_VEN1 ||
+	    wlc_hw->deviceid == BCM43224_CHIP_ID)
 		/* Dualband boards */
 		wlc_hw->_nbands = 2;
 	else
@@ -5653,7 +5654,7 @@ static bool brcms_c_chipmatch_pci(struct bcma_device *core)
 		return false;
 	}
 
-	if (device == BCM43224_D11N_ID_VEN1)
+	if (device == BCM43224_D11N_ID_VEN1 || device == BCM43224_CHIP_ID)
 		return true;
 	if ((device == BCM43224_D11N_ID) || (device == BCM43225_D11N2G_ID))
 		return true;
-- 
1.7.10.4

