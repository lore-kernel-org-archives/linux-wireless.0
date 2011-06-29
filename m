Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1910 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab1F2Xsh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 018/119] staging: brcm80211: remove macro definition
 DRV_MODULE_NAME
Date: Wed, 29 Jun 2011 16:46:42 -0700
Message-ID: <1309391303-22741-19-git-send-email-frankyl@broadcom.com> (sfid-20110630_014851_640087_82E13BA6)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The macro definition DRV_MODULE_NAME has exactly the same value as
KBUILD_MODNAME so using that instead now.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index dfbbda7..d09706b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -180,8 +180,6 @@ MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
-#define DRV_MODULE_NAME "brcmfmac"
-
 /* Linux wireless extension support */
 #if defined(CONFIG_WIRELESS_EXT)
 #include <wl_iw.h>
@@ -1490,7 +1488,7 @@ static void dhd_ethtool_get_drvinfo(struct net_device *net,
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
 
-	sprintf(info->driver, DRV_MODULE_NAME);
+	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", dhd->pub.drv_version);
 	sprintf(info->fw_version, "%s", wl_cfg80211_get_fwname());
 	sprintf(info->bus_info, "%s", dev_name(&wl_cfg80211_get_sdio_func()->dev));
-- 
1.7.1


