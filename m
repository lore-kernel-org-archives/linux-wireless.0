Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2043 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1FIOpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:15 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/21] staging: brcm80211: remove 'used' keyword from
 function ai_ispcie()
Date: Thu, 9 Jun 2011 16:44:45 +0200
Message-ID: <1307630701-9170-6-git-send-email-rvossen@broadcom.com> (sfid-20110609_164606_145619_BE4EB6EE)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function ai_ispcie() is a static function that is currently being
called from the c sources in the driver. Side-effect of the keyword
is that warning will suppressed when this function is no longer used.
As there is no assembly code using this function, the keyword is removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 4b908f7..7907b15 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -2028,7 +2028,7 @@ static char *ai_devpathvar(struct si_pub *sih, char *var, int len,
 }
 
 /* return true if PCIE capability exists in the pci config space */
-static __used bool ai_ispcie(si_info_t *sii)
+static bool ai_ispcie(si_info_t *sii)
 {
 	u8 cap_ptr;
 
-- 
1.7.4.1


