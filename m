Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36266 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab2FEXIf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 12/18] brcmsmac: add a conditions for core rev 17 again
Date: Wed,  6 Jun 2012 01:07:15 +0200
Message-Id: <1338937641-8519-13-git-send-email-hauke@hauke-m.de> (sfid-20120606_012943_692922_4B2C7E05)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts some changes made in this commit:
commit 7234592364e2efe8b4ac1040c99b1d7ef01cf502
Author: Roland Vossen <rvossen@broadcom.com>
Date:   Mon Feb 14 12:16:45 2011 +0100

    staging: brcm80211: removal of inactive d11 code

The bcm4716 has a rev 17 wireless core and this condition is needed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index a07ff0a..9aa14e2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1941,7 +1941,8 @@ static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 		 * accesses phyreg throughput mac. This can be skipped since
 		 * only mac reg is accessed below
 		 */
-		flags |= SICF_PCLKE;
+		if (D11REV_GE(wlc_hw->corerev, 18))
+			flags |= SICF_PCLKE;
 
 		/*
 		 * TODO: test suspend/resume
@@ -2022,7 +2023,8 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 	 * phyreg throughput mac, AND phy_reset is skipped at early stage when
 	 * band->pi is invalid. need to enable PHY CLK
 	 */
-	flags |= SICF_PCLKE;
+	if (D11REV_GE(wlc_hw->corerev, 18))
+		flags |= SICF_PCLKE;
 
 	/*
 	 * reset the core
-- 
1.7.9.5

