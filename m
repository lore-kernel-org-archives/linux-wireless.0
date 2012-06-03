Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45376 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2FCF64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 01:58:56 -0400
Received: by obbtb18 with SMTP id tb18so5330081obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jun 2012 22:58:55 -0700 (PDT)
From: Chris Yungmann <yungmann.chris@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Chris Yungmann <yungmann.chris@gmail.com>
Subject: [PATCH] brcm80211: brcmsmac: fixed checkpatch and sparse warnings
Date: Sun,  3 Jun 2012 00:57:57 -0500
Message-Id: <1338703077-15700-1-git-send-email-yungmann.chris@gmail.com> (sfid-20120603_080002_149773_CE01B936)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed checkpatch and sparse warnings related to aiutils.*

Signed-off-by: Chris Yungmann <yungmann.chris@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    3 +--
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 6d8b721..3c6f9b1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -631,9 +631,8 @@ uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 	cc = sii->icbus->drv_cc.core;
 
 	/* mask and set */
-	if (mask || val) {
+	if (mask || val)
 		bcma_maskset32(cc, regoff, ~mask, val);
-	}
 
 	/* readback */
 	w = bcma_read32(cc, regoff);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index d9f04a6..d6fa982 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -193,7 +193,7 @@ extern void ai_detach(struct si_pub *sih);
 extern uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val);
 extern void ai_clkctl_init(struct si_pub *sih);
 extern u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih);
-extern bool ai_clkctl_cc(struct si_pub *sih, uint mode);
+extern bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode);
 extern bool ai_deviceremoved(struct si_pub *sih);
 
 extern void ai_pci_down(struct si_pub *sih);
-- 
1.7.10

