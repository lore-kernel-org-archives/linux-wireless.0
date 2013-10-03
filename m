Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38312 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3JCLtc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 07:49:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	arend@broadcom.com, brcm80211-dev-list@broadcom.com,
	jogo@openwrt.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] brcmsmac: add support for a BCM4313 with PCI id 0x4313
Date: Thu,  3 Oct 2013 13:49:11 +0200
Message-Id: <1380800951-28643-3-git-send-email-hauke@hauke-m.de> (sfid-20131003_134935_221195_80DB1205)
In-Reply-To: <1380800951-28643-1-git-send-email-hauke@hauke-m.de>
References: <1380800951-28643-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some BCM4313 out there with a PCI id of 0x4313. These devices
are missing a sprom and are only used on routers or other embedded
devices. We found one connected to a BCM63XX SoC.

This devices was found by someone in this ticket:
https://dev.openwrt.org/ticket/13551

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 4608e0e..df6229e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -5695,7 +5695,7 @@ static bool brcms_c_chipmatch_pci(struct bcma_device *core)
 		return true;
 	if ((device == BCM43224_D11N_ID) || (device == BCM43225_D11N2G_ID))
 		return true;
-	if (device == BCM4313_D11N2G_ID)
+	if (device == BCM4313_D11N2G_ID || device == BCM4313_CHIP_ID)
 		return true;
 	if ((device == BCM43236_D11N_ID) || (device == BCM43236_D11N2G_ID))
 		return true;
-- 
1.7.10.4

