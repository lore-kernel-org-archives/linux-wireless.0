Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1210 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab1JDVTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:36 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/26] staging: brcm80211: removed redundant code from
 brcms_c_set_gmode
Date: Tue, 4 Oct 2011 23:19:02 +0200
Message-ID: <1317763152-17607-17-git-send-email-arend@broadcom.com> (sfid-20111004_231944_797534_F6E338F9)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

The comment says the rateset is being cleared when switching to GMODE_LEGACY_B,
but the code that follows it does not do so. Besides, the rateset is already
valid at this point.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 3349716..9988e03 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5965,13 +5965,6 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		return -ENOTSUPP;
 	}
 
-	/*
-	 * If we are switching to gmode == GMODE_LEGACY_B,
-	 * clean up rate info that may refer to OFDM rates.
-	 */
-	if ((gmode == GMODE_LEGACY_B) && (band->gmode != GMODE_LEGACY_B))
-		band->gmode = gmode;
-
 	band->gmode = gmode;
 
 	wlc->shortslot_override = shortslot;
-- 
1.7.4.1


