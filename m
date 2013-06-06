Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3374 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab3FFLb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:31:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 V2] brcmsmac: disable power-save related
 functions
Date: Thu, 6 Jun 2013 13:29:56 +0200
Message-ID: <1370518196-14840-1-git-send-email-arend@broadcom.com> (sfid-20130606_133159_632685_86BF336D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression introduced by:

  commit 6da3b6c48d79da96a36c2632053cf4f53bf48fb2
  Author: Hauke Mehrtens <hauke@hauke-m.de>
  Date:   Sun Mar 24 01:45:52 2013 +0100

      brcmsmac: remove brcms_bss_cfg->associated

The regression behaviour was described on mailing list.

http://mid.gmane.org/5197DC4F.7030503@broadcom.com:
"On laptop I installed kernel with brcmsmac compiled as
module. It comes up and associates during boot, but after
logging in there is no connectivity. Triggering reassoc
gives connectivity for some time, but after a while (1-2 min)
it stops."

Before the mentioned commit the return value of
the function brcms_c_ps_allowed() was always false,
which is desired behaviour as power-save is not
supported at the moment. Therefor, the function is
changed to just return false instead of simply
reverting the mentioned commit.

Bug: 58471 <https://bugzilla.kernel.org/show_bug.cgi?id=58471>

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi, John

The commit message has been updated based on feedback
from Kalle en Hauke.

Gr. AvS
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


