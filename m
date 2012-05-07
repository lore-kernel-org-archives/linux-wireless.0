Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36154 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2EGTag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 15:30:36 -0400
Received: by pbbrp8 with SMTP id rp8so7069536pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 12:30:35 -0700 (PDT)
From: Il Han <corone.il.han@gmail.com>
To: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Il Han <corone.il.han@gmail.com>
Subject: [PATCH] brcm80211: Initialize a variable before used.
Date: Tue,  8 May 2012 04:23:52 +0900
Message-Id: <1336418632-16758-1-git-send-email-corone.il.han@gmail.com> (sfid-20120507_213041_820397_D6669783)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable val is used uninitialized.
It should be initialized before used.
Initialize it.

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index c93ea35..d67c5c4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -1141,7 +1141,7 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 {
 	struct bcma_device *cc;
-	u32 val;
+	u32 val = 0;
 
 	cc = ai_findcore(sih, CC_CORE_ID, 0);
 
-- 
1.7.4.1

