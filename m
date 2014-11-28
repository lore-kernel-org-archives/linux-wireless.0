Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23491 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaK1Jm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 04:42:29 -0500
Date: Fri, 28 Nov 2014 12:43:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: [patch] brcmsmac: NULL dereferences in brcms_c_detach_mfree()
Message-ID: <20141128094340.GA10364@mwanda> (sfid-20141128_104236_189466_8E66E412)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcms_c_attach_malloc() function can call this with a NULL
"wlc->corestate" or "wlc->hw".

Also I threw in a bonus cleanup by deleting an obvious comment and a
no-op NULL assignment.  :)

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 738cfac..a104d7a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -445,18 +445,18 @@ static void brcms_c_detach_mfree(struct brcms_c_info *wlc)
 	kfree(wlc->protection);
 	kfree(wlc->stf);
 	kfree(wlc->bandstate[0]);
-	kfree(wlc->corestate->macstat_snapshot);
+	if (wlc->corestate)
+		kfree(wlc->corestate->macstat_snapshot);
 	kfree(wlc->corestate);
-	kfree(wlc->hw->bandstate[0]);
+	if (wlc->hw)
+		kfree(wlc->hw->bandstate[0]);
 	kfree(wlc->hw);
 	if (wlc->beacon)
 		dev_kfree_skb_any(wlc->beacon);
 	if (wlc->probe_resp)
 		dev_kfree_skb_any(wlc->probe_resp);
 
-	/* free the wlc */
 	kfree(wlc);
-	wlc = NULL;
 }
 
 static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit)
