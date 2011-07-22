Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3349 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 21/29] staging: brcm80211: cleanup to get rid of 'over
 80 character' line
Date: Fri, 22 Jul 2011 20:57:08 +0200
Message-ID: <1311361036-3175-22-git-send-email-arend@broadcom.com> (sfid-20110722_205740_573688_4BC9F413)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One checkpatch warning was remaining in the brcmsmac driver. The
code has been restructured to get rid of this last checkpatch
warning.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index f5f914f..2a139aa 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -6253,14 +6253,13 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 
 			/* merge rateset coming in with the current mcsset */
 			if (N_ENAB(wlc->pub)) {
+				struct brcms_bss_info *mcsset_bss;
 				if (bsscfg->associated)
-					memcpy(rs.mcs,
-					       &current_bss->rateset.mcs[0],
-					       MCSSET_LEN);
+					mcsset_bss = current_bss;
 				else
-					memcpy(rs.mcs,
-					       &wlc->default_bss->rateset.mcs[0],
-					       MCSSET_LEN);
+					mcsset_bss = wlc->default_bss;
+				memcpy(rs.mcs, &mcsset_bss->rateset.mcs[0],
+				       MCSSET_LEN);
 			}
 
 			bcmerror = brcms_c_set_rateset(wlc, &rs);
-- 
1.7.4.1


