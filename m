Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62362 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2EHGmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 02:42:21 -0400
Received: by dady13 with SMTP id y13so2251526dad.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 23:42:21 -0700 (PDT)
From: Il Han <corone.il.han@gmail.com>
To: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, linux-wireless@vger.kernel.org,
	Il Han <corone.il.han@gmail.com>
Subject: [PATCH] brcm80211: Remove an unused variable.
Date: Tue,  8 May 2012 15:35:47 +0900
Message-Id: <1336458947-20698-1-git-send-email-corone.il.han@gmail.com> (sfid-20120508_084225_624594_2996C43B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable val is not used afterward.
Remove the declaration and the assignment line of it.

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index c93ea35..f79b526 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -1141,7 +1141,6 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 {
 	struct bcma_device *cc;
-	u32 val;
 
 	cc = ai_findcore(sih, CC_CORE_ID, 0);
 
@@ -1156,7 +1155,6 @@ void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 			bcma_set32(cc, CHIPCREGOFFS(chipcontrol),
 				   CCTRL4331_EXTPA_EN);
 	} else {
-		val &= ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5);
 		bcma_mask32(cc, CHIPCREGOFFS(chipcontrol),
 			    ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5));
 	}
-- 
1.7.4.1

