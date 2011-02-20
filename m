Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60370 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab1BTPAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 10:00:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 07:00:24 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH] staging: ath6kl: Eliminate cfg80211 warnings
Date: Sun, 20 Feb 2011 07:00:38 -0800
Message-ID: <1298214038-5303-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cancel the pending scan operation once the interface is going down to 
avoid warnings from the cfg80211 module. Once the interface is down, 
cfg80211 checks for any pending scan requests and dumps a warning if it 
finds one. It expects the driver to abort any ongoing scan operation 
once the driver detects that the interface is going down.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index a659f70..4d76489 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -2338,6 +2338,7 @@ ar6000_close(struct net_device *dev)
         }
         ar->arWlanState = WLAN_DISABLED;
     }
+	ar6k_cfg80211_scanComplete_event(ar, A_ECANCELED);
 #endif /* ATH6K_CONFIG_CFG80211 */
 
     return 0;
-- 
1.6.3.3

