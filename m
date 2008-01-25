Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48427 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYAYLWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 06:22:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable 1/3] b43: Fix suspend/resume
Date: Fri, 25 Jan 2008 12:11:45 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200801251211.45980.mb@bu3sch.de> (sfid-20080125_112259_757838_EC0B50FE)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes suspend/resume work with the b43 driver.
We must not overwrite the MAC addresses in the init function, as this
would also overwrite the MAC on resume. With an all-zero MAC the device
firmware is not able to ACK any received packets anymore.
Fix this by moving the initializion stuff that must be done on init but
not on resume to the start function.
Also zero out filter_flags to make sure we don't have some flags
from a previous instance for a tiny timeframe until mac80211 reconfigures
them.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch is upstream inside of the netdev tree.


Index: linux-2.6.24/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43/main.c	2008-01-25 11:48:26.000000000 +0100
+++ linux-2.6.24/drivers/net/wireless/b43/main.c	2008-01-25 11:48:28.000000000 +0100
@@ -3395,8 +3395,6 @@ static int b43_wireless_core_init(struct
 	b43_bluetooth_coext_enable(dev);
 
 	ssb_bus_powerup(bus, 1);	/* Enable dynamic PCTL */
-	memset(wl->bssid, 0, ETH_ALEN);
-	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
 	b43_rng_init(wl);
@@ -3493,6 +3491,13 @@ static int b43_start(struct ieee80211_hw
 	int did_init = 0;
 	int err = 0;
 
+	/* Kill all old instance specific information to make sure
+	 * the card won't use it in the short timeframe between start
+	 * and mac80211 reconfiguring it. */
+	memset(wl->bssid, 0, ETH_ALEN);
+	memset(wl->mac_addr, 0, ETH_ALEN);
+	wl->filter_flags = 0;
+
 	/* First register RFkill.
 	 * LEDs that are registered later depend on it. */
 	b43_rfkill_init(dev);
