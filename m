Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4552 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757700Ab1F2Xsn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:43 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 004/119] staging: brcm80211: minor cleanup in
 initvars_srom_pci()
Date: Wed, 29 Jun 2011 16:46:28 -0700
Message-ID: <1309391303-22741-5-git-send-email-frankyl@broadcom.com> (sfid-20110630_014925_767810_F42CD69C)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The error handling code labelled with errout: did a conditional kfree(). The
last error jump to the label is upon failure of the kmalloc() for which the
conditional kfree() is done. Therefor, the kfree is moved before the error
label and done unconditionally.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/srom.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 5b5306a..31aa84d 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -1287,12 +1287,10 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 		*vp++ = '\0';
 
 		err = initvars_table(base, vp, vars, count);
+		kfree(base);
 	}
 
 errout:
-	if (base)
-		kfree(base);
-
 	kfree(srom);
 	return err;
 }
-- 
1.7.1


