Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2420 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab2FIVZV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 17:25:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/5] brcmsmac: remove brcms_set_hint() function
Date: Sat, 9 Jun 2012 22:51:41 +0200
Message-ID: <1339275105-3593-2-git-send-email-arend@broadcom.com> (sfid-20120609_232524_979459_4650AFD2)
In-Reply-To: <1339275105-3593-1-git-send-email-arend@broadcom.com>
References: <1339275105-3593-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcms_set_hint() does not add any functionality
so regulatory_hint() can be called directly. The error value
has been removed from the message when regulatory_hint() fails.

Reported-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 50f92a0..341e06a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -721,14 +721,6 @@ static const struct ieee80211_ops brcms_ops = {
 	.flush = brcms_ops_flush,
 };
 
-/*
- * is called in brcms_bcma_probe() context, therefore no locking required.
- */
-static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
-{
-	return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
-}
-
 void brcms_dpc(unsigned long data)
 {
 	struct brcms_info *wl;
@@ -1068,9 +1060,9 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 		wiphy_err(wl->wiphy, "%s: ieee80211_register_hw failed, status"
 			  "%d\n", __func__, err);
 
-	if (wl->pub->srom_ccode[0] && brcms_set_hint(wl, wl->pub->srom_ccode))
-		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
-			  __func__, err);
+	if (wl->pub->srom_ccode[0] &&
+	    regulatory_hint(wl->wiphy, wl->pub->srom_ccode))
+		wiphy_err(wl->wiphy, "%s: regulatory hint failed\n", __func__);
 
 	n_adapters_found++;
 	return wl;
-- 
1.7.9.5


