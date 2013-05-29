Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4707 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759146Ab3E2QyQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:54:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10] brcmsmac: fix regression observed in 3.10-rc1
Date: Wed, 29 May 2013 18:54:05 +0200
Message-ID: <1369846445-32216-1-git-send-email-arend@broadcom.com> (sfid-20130529_185421_652312_7B78F025)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression introduced by:

  commit 6da3b6c48d79da96a36c2632053cf4f53bf48fb2
  Author: Hauke Mehrtens <hauke@hauke-m.de>
  Date:   Sun Mar 24 01:45:52 2013 +0100

      brcmsmac: remove brcms_bss_cfg->associated

This commit changed the behaviour of the function
brcms_c_ps_allowed().

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 28e7aee..9fd6f2f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3074,21 +3074,8 @@ static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
  */
 static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 {
-	/* disallow PS when one of the following global conditions meets */
-	if (!wlc->pub->associated)
-		return false;
-
-	/* disallow PS when one of these meets when not scanning */
-	if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
-		return false;
-
-	if (wlc->bsscfg->type == BRCMS_TYPE_AP)
-		return false;
-
-	if (wlc->bsscfg->type == BRCMS_TYPE_ADHOC)
-		return false;
-
-	return true;
+	/* not supporting PS so always return false for now */
+	return false;
 }
 
 static void brcms_c_statsupd(struct brcms_c_info *wlc)
-- 
1.7.10.4


