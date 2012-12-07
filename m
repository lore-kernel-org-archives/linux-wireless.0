Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58975 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030765Ab2LGQE2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 11:04:28 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	nlhintz@hotmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcmsmac: do a read after the write of the objmem on broken PCIe controllers
Date: Fri,  7 Dec 2012 17:04:13 +0100
Message-Id: <1354896253-5702-1-git-send-email-hauke@hauke-m.de> (sfid-20121207_170438_317493_D7C9E3F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As described in the documentation of bcma_wflush16 in drivers/net
/wireless/brcm80211/brcmsmac/types.h some PCIe controllers of Broadcom
SoCs are broken. The PCIe controller on these SoCs are mostly used to
connect some additional wifi device to the SoC and some of these wifi
devices are supported by brcmsmac.
For my BCM43224 connected to the broken PCIe controller of the BCM4718 I
need an extra read after write in brcms_b_write_objmem() to prevent a
Data bus error. This fixes the problem reading tsf_random later.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index cb48fc4..2599cd0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2920,7 +2920,7 @@ brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset, u16 v,
 	if (offset & 2)
 		objoff += 2;
 
-	bcma_write16(core, objoff, v);
+	bcma_wflush16(core, objoff, v);
 }
 
 /*
-- 
1.7.10.4

