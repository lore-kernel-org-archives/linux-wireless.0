Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47098 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab1C3A4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:56:48 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 06/34] ath6kl: move setting netdev for non-cf80211 case
Date: Tue, 29 Mar 2011 17:56:03 -0700
Message-ID: <1301446591-15236-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check for SET_NETDEV_DEV is not required given that
this is upstream. The setting of the SET_NETDEV_DEV with
the osDevInfo.pOSDevice is redundant for the cfg80211 case
as this was already being done, so just set the netdev device
for the non-cfg80211 which was missing.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index bb4dbb5..94b9132 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1685,6 +1685,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
     }
     ether_setup(dev);
     ar_netif = ar6k_priv(dev);
+    SET_NETDEV_DEV(dev, osDevInfo.pOSDevice);
 #endif /* ATH6K_CONFIG_CFG80211 */
 
     if (ar_netif == NULL) {
@@ -1715,11 +1716,6 @@ ar6000_avail_ev(void *context, void *hif_handle)
 
     init_netdev(dev, ifname);
 
-#ifdef SET_NETDEV_DEV
-    if (ar_netif) { 
-        SET_NETDEV_DEV(dev, osDevInfo.pOSDevice);
-    }
-#endif 
 
     ar->arNetDev             = dev;
     ar->arHifDevice          = hif_handle;
-- 
1.7.0.4

