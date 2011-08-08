Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1865 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab1HHN7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 77/82] staging: brcm80211: removed
 brcms_c_module_unregister() call in ampdu.c
Date: Mon, 8 Aug 2011 15:59:01 +0200
Message-ID: <1312811946-16713-78-git-send-email-arend@broadcom.com> (sfid-20110808_160000_894263_308078EF)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

The AMPDU module was never registered, so it does not have to be unregistered.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 64bbc24..3c0fa13 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -243,7 +243,6 @@ void brcms_c_ampdu_detach(struct ampdu_info *ampdu)
 	for (i = 0; i < AMPDU_INI_FREE; i++)
 		kfree(ampdu->ini_free[i]);
 
-	brcms_c_module_unregister(ampdu->wlc->pub, "ampdu", ampdu);
 	kfree(ampdu);
 }
 
-- 
1.7.4.1


