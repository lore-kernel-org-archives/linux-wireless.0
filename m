Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab1LOCXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 21:23:07 -0500
Date: Wed, 14 Dec 2011 20:23:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: frankyl@broadcom.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH] brcmsmac: Replace kmalloc/memset with kzalloc
Message-ID: <4ee95a07.ADXjXEI3nOhhruq1%Larry.Finger@lwfinger.net> (sfid-20111215_032312_662772_69C28A42)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ai_attach(), space is allocated for an si_info struct. Immediately
after the allocation, routine ai_doattach() is called and that allocated
space is set to zero. As no other routine calls ai_doattach(), kzalloc()
can be utilized.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 3.3 material.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ wireless-testing-new/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -565,8 +565,6 @@ static struct si_info *ai_doattach(struc
 	struct bcma_device *cc;
 	uint socitype;
 
-	memset((unsigned char *) sii, 0, sizeof(struct si_info));
-
 	savewin = 0;
 
 	sii->icbus = pbus;
@@ -677,7 +675,7 @@ ai_attach(struct bcma_bus *pbus)
 	struct si_info *sii;
 
 	/* alloc struct si_info */
-	sii = kmalloc(sizeof(struct si_info), GFP_ATOMIC);
+	sii = kzalloc(sizeof(struct si_info), GFP_ATOMIC);
 	if (sii == NULL)
 		return NULL;
 
