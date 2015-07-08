Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:27834 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516AbbGHTkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 15:40:36 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: kvalo@codeaurora.org, brudley@broadcom.com, arend@broadcom.com,
	frankyl@broadcom.com, meuleman@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] mac80211: Use kstrdup to simplify code
Date: Wed,  8 Jul 2015 21:32:07 +0200
Message-Id: <1436383927-14010-1-git-send-email-christophe.jaillet@wanadoo.fr> (sfid-20150708_214042_291938_588DDEE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace a kmalloc+strcpy by an equivalent kstrdup in order to improve
readability.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 4813506..8a6c077 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1476,9 +1476,7 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 	wl->timers = t;
 
 #ifdef DEBUG
-	t->name = kmalloc(strlen(name) + 1, GFP_ATOMIC);
-	if (t->name)
-		strcpy(t->name, name);
+	t->name = kstrdup(name, GFP_ATOMIC);
 #endif
 
 	return t;
-- 
2.1.4

