Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2419 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab1ECJgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 47/61] staging: brcm80211: remove check on interconnect
 type in ai_setcore
Date: Tue, 3 May 2011 11:35:47 +0200
Message-ID: <1304415361-7813-48-git-send-email-arend@broadcom.com> (sfid-20110503_113840_380242_350957EF)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All functions in aiutils are only used for AI SOC interconnect chipsets
so no software check is needed other then during the ai_scan function.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 549a612..2ee4236 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1068,12 +1068,7 @@ void *ai_setcore(si_t *sih, uint coreid, uint coreunit)
 	if (!GOODIDX(idx))
 		return NULL;
 
-	if (sih->socitype == SOCI_AI)
-		return ai_setcoreidx(sih, idx);
-	else {
-		ASSERT(0);
-		return NULL;
-	}
+	return ai_setcoreidx(sih, idx);
 }
 
 /* Turn off interrupt as required by ai_setcore, before switch core */
-- 
1.7.4.1


