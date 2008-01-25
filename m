Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33072 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754265AbYAYNgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 08:36:45 -0500
Date: Fri, 25 Jan 2008 14:26:21 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: stable@kernel.org
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH stable 2/4] b43legacy: fix suspend/resume
Message-ID: <20080125142621.0d240fd8@morte> (sfid-20080125_133647_994557_44ECD9F0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes suspend/resume work with the b43legacy driver.
We must not overwrite the MAC addresses in the init function, as this
would also overwrite the MAC on resume. With an all-zero MAC the device
firmware is not able to ACK any received packets anymore.
Fix this by moving the initializion stuff that must be done on init but
not on resume to the start function.
Also zero out filter_flags to make sure we don't have some flags
from a previous instance for a tiny timeframe until mac80211 reconfigures
them.

This patch by Michael Buesch has been ported to b43legacy.

Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: linux-2.6.24/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43legacy/main.c
+++ linux-2.6.24/drivers/net/wireless/b43legacy/main.c
@@ -3215,8 +3215,6 @@ static int b43legacy_wireless_core_init(
 	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED, 0x0414, 0x01F4);
 
 	ssb_bus_powerup(bus, 1); /* Enable dynamic PCTL */
-	memset(wl->bssid, 0, ETH_ALEN);
-	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43legacy_upload_card_macaddress(dev);
 	b43legacy_security_init(dev);
 	b43legacy_rng_init(wl);
@@ -3311,6 +3309,13 @@ static int b43legacy_start(struct ieee80
 	int did_init = 0;
 	int err = 0;
 
+	/* Kill all old instance specific information to make sure
+	 * the card won't use it in the short timeframe between start
+	 * and mac80211 reconfiguring it. */
+	memset(wl->bssid, 0, ETH_ALEN);
+	memset(wl->mac_addr, 0, ETH_ALEN);
+	wl->filter_flags = 0;
+
 	mutex_lock(&wl->mutex);
 
 	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {


--
Ciao
Stefano
