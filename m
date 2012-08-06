Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab2HFTRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:17:34 -0400
Message-ID: <50201846.2000606@suse.com> (sfid-20120806_211737_514909_59079845)
Date: Mon, 06 Aug 2012 15:17:26 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>
Subject: [PATCH] brcmsmac: document firmware dependencies
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac driver requests firmware but doesn't document the
dependency. This means that software that analyzes the modules to
determine if firmware is needed won't detect it.

Specifically, (at least) openSUSE won't install the kernel-firmware
package if no hardware requires it.

This patch adds the MODULE_FIRMWARE directives.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -86,7 +86,9 @@ MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
-
+/* This needs to be adjusted when brcms_firmwares changes */
+MODULE_FIRMWARE("brcm/bcm43xx-0.fw");
+MODULE_FIRMWARE("brcm/bcm43xx_hdr-0.fw");
  /* recognized BCMA Core IDs */
 static struct bcma_device_id brcms_coreid_table[] = {

-- 
Jeff Mahoney
SUSE Labs
