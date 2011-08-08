Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1852 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab1HHN7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 73/82] staging: brcm80211: cleanup to get rid of 'over
 80 character' line
Date: Mon, 8 Aug 2011 15:58:57 +0200
Message-ID: <1312811946-16713-74-git-send-email-arend@broadcom.com> (sfid-20110808_160028_563746_6ED09919)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One checkpatch warning was remaining in the brcmsmac driver. The
code has been restructured to get rid of this last checkpatch
warning.

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


