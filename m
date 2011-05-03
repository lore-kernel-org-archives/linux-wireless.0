Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2346 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab1ECJgX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 41/61] staging: brcm80211: fix checkpatch warning in
 si_pmu_res_init
Date: Tue, 3 May 2011 11:35:41 +0200
Message-ID: <1304415361-7813-42-git-send-email-arend@broadcom.com> (sfid-20110503_113706_591607_06AD1627)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch "remove dependency between aiutils and siutils sources" introduced
several checkpatch warnings. This patch removes one from si_pmu_res_init().

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index cd42a77..2c3d42fd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -1626,7 +1626,8 @@ void si_pmu_res_init(si_t *sih)
 			pmu_res_updown_table_sz = 0;
 		} else {
 			pmu_res_updown_table = bcm4329_res_updown;
-			pmu_res_updown_table_sz = ARRAY_SIZE(bcm4329_res_updown);
+			pmu_res_updown_table_sz =
+				ARRAY_SIZE(bcm4329_res_updown);
 		}
 		/* Optimize resources dependencies */
 		pmu_res_depend_table = bcm4329_res_depend;
@@ -1758,15 +1759,13 @@ void si_pmu_res_init(si_t *sih)
 
 	/* Program max resource mask */
 
-	if (max_mask) {
+	if (max_mask)
 		W_REG(&cc->max_res_mask, max_mask);
-	}
 
 	/* Program min resource mask */
 
-	if (min_mask) {
+	if (min_mask)
 		W_REG(&cc->min_res_mask, min_mask);
-	}
 
 	/* Add some delay; allow resources to come up and settle. */
 	mdelay(2);
-- 
1.7.4.1


