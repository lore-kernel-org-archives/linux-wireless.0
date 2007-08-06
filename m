Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:64395 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXHFDBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 23:01:05 -0400
Date: Sun, 05 Aug 2007 22:00:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Fix regression in interrupt handling
Message-ID: <46b68ec8.nObKM6TauxkzJMGV%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 85a83d26697dd2203ac4e5f33022951f2c3e6e33, "bcm43xx-mac80211:
Rewrite and simplify handling of the initialization status", some PCI
adapters have problems due to interrupts happening before the device status
reaches BCM43xx_STARTED. This patch delays the initial interrupt enable until
after the device status is set.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch fixes a regression since 2.6.23-rc1. Michael and I have discussed this
and he has agreed that this is the proper fix.

Larry

 bcm43xx_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
@@ -3014,13 +3014,13 @@ static int bcm43xx_wireless_core_start(s
 		       dev->dev->irq);
 		goto out;
 	}
-	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
 	bcm43xx_mac_enable(dev);
 
 	bcm43xx_periodic_tasks_setup(dev);
 
 	ieee80211_start_queues(dev->wl->hw);
 	bcm43xx_set_status(dev, BCM43xx_STAT_STARTED);
+	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
 	bcmdbg(dev->wl, "Wireless interface started\n");
 out:
 	return err;
