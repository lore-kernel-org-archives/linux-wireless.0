Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33420 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378Ab2GLHoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 03:44:08 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] wireless: brcm80211: use %pM to print BSSID
Date: Thu, 12 Jul 2012 10:43:44 +0300
Message-Id: <1342079024-18851-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20120712_094413_686913_9BD0CD75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d13ae9c..e3c0446 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -919,9 +919,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	set_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
 
 	if (params->bssid)
-		WL_CONN("BSSID: %02X %02X %02X %02X %02X %02X\n",
-		params->bssid[0], params->bssid[1], params->bssid[2],
-		params->bssid[3], params->bssid[4], params->bssid[5]);
+		WL_CONN("BSSID: %pM\n", params->bssid);
 	else
 		WL_CONN("No BSSID specified\n");
 
-- 
1.7.10.4

