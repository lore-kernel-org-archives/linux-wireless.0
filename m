Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3442 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab2DKJxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 7/9] brcm80211: smac: do not use US as fallback
 regulatory hint
Date: Wed, 11 Apr 2012 11:52:49 +0200
Message-ID: <1334137971-3972-8-git-send-email-arend@broadcom.com> (sfid-20120411_115351_401438_84265C7D)
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac driver provides the country code from sprom as a regulatory
hint to cfg80211. When brcmsmac does not find a country code entry in
the sprom it passes 'US' as regulatory hint. Better approach is to rely
on the world regulatory domain in cfg80211/crda.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 569ab8a..aa15558 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1069,11 +1069,7 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 		wiphy_err(wl->wiphy, "%s: ieee80211_register_hw failed, status"
 			  "%d\n", __func__, err);
 
-	if (wl->pub->srom_ccode[0])
-		err = brcms_set_hint(wl, wl->pub->srom_ccode);
-	else
-		err = brcms_set_hint(wl, "US");
-	if (err)
+	if (wl->pub->srom_ccode[0] && brcms_set_hint(wl, wl->pub->srom_ccode))
 		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
 			  __func__, err);
 
-- 
1.7.5.4


