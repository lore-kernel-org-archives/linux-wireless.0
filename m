Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3059 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/15] brcm80211: smac: register with bcma for specific
 802.11 core revisions
Date: Mon, 12 Dec 2011 15:15:12 -0800
Message-ID: <1323731713-14942-15-git-send-email-frankyl@broadcom.com> (sfid-20111213_001600_825190_2C298BEF)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The brcmsmac driver has been verified on chipsets that were supported
when it was a pci device driver, ie. bcm4313, bcm43224, and bcm43225.
This patch restricts the driver to 802.11 core revisions that are found
in these chipsets.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 30ac8b4..77fdc45 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -90,8 +90,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 /* recognized BCMA Core IDs */
 static struct bcma_device_id brcms_coreid_table[] = {
-	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211,
-		  BCMA_ANY_REV, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 23, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 24, BCMA_ANY_CLASS),
 	BCMA_CORETABLE_END
 };
 MODULE_DEVICE_TABLE(bcma, brcms_coreid_table);
-- 
1.7.5.4


