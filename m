Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4459 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1I0Rps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 05/26] staging: brcm80211: removed global var from
 aiutils.c
Date: Tue, 27 Sep 2011 10:45:09 -0700
Message-ID: <1317145530-18839-6-git-send-email-frankyl@broadcom.com> (sfid-20110927_194645_471715_43BE1C3D)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index b7b0bdf..d05c4ba 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -477,9 +477,6 @@ struct aidmp {
 	u32 componentid3;	/* 0xffc */
 };
 
-/* global kernel resource */
-static struct si_info ksii;
-
 /* EROM parsing */
 
 static u32
@@ -1216,8 +1213,7 @@ void ai_detach(struct si_pub *sih)
 		pcicore_deinit(sii->pch);
 	sii->pch = NULL;
 
-	if (sii != &ksii)
-		kfree(sii);
+	kfree(sii);
 }
 
 /* register driver interrupt disabling and restoring callback functions */
-- 
1.7.1


