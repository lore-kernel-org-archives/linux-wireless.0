Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3055 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab1LLXPu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:50 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/15] brcm80211: smac: change ai_findcoreidx() to
 ai_findcore()
Date: Mon, 12 Dec 2011 15:14:59 -0800
Message-ID: <1323731713-14942-2-git-send-email-frankyl@broadcom.com> (sfid-20111213_001601_790850_783C153A)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Instead of returning the core index the function now returns
the bcma device for the requested core id. This function is
now exposed in the header file.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   14 +++++++-------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    2 ++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 8d3829a..a54cf32 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -884,7 +884,7 @@ uint ai_coreidx(struct si_pub *sih)
 }
 
 /* return index of coreid or BADIDX if not found */
-uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit)
+struct bcma_device *ai_findcore(struct si_pub *sih, u16 coreid, u16 coreunit)
 {
 	struct bcma_device *core;
 	struct si_info *sii;
@@ -897,11 +897,11 @@ uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit)
 	list_for_each_entry(core, &sii->icbus->cores, list)
 		if (core->id.id == coreid) {
 			if (found == coreunit)
-				return core->core_index;
+				return core;
 			found++;
 		}
 
-	return BADIDX;
+	return NULL;
 }
 
 /*
@@ -912,13 +912,13 @@ uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit)
  */
 void __iomem *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit)
 {
-	uint idx;
+	struct bcma_device *core;
 
-	idx = ai_findcoreidx(sih, coreid, coreunit);
-	if (idx >= SI_MAXCORES)
+	core = ai_findcore(sih, coreid, coreunit);
+	if (core == NULL)
 		return NULL;
 
-	return ai_setcoreidx(sih, idx);
+	return ai_setcoreidx(sih, core->core_index);
 }
 
 /* Turn off interrupt as required by ai_setcore, before switch core */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 67b378f..b0b0bff 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -219,6 +219,8 @@ struct si_info {
 
 
 /* AMBA Interconnect exported externs */
+extern struct bcma_device *ai_findcore(struct si_pub *sih,
+				       u16 coreid, u16 coreunit);
 extern uint ai_coreidx(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
 extern u32 ai_core_cflags(struct bcma_device *core, u32 mask, u32 val);
-- 
1.7.5.4


