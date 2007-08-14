Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37074
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615AbXHNSN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:13:58 -0400
Message-Id: <20070814181215.464099000@bu3sch.de>
References: <20070814181213.135874000@bu3sch.de>
Date: Tue, 14 Aug 2007 20:12:18 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 5/9] b43: Suppress sending of probe responses from firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MLME takes care of this.
In future we probably want to change the MLME to support this
hardware feature.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-12 22:03:12.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-13 14:24:30.000000000 +0200
@@ -3328,6 +3328,12 @@ static int b43_wireless_core_init(struct
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SFFBLIM, 3);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_LFFBLIM, 2);
 
+	/* Disable sending probe responses from firmware.
+	 * Setting the MaxTime to one usec will always trigger
+	 * a timeout, so we never send any probe resp.
+	 * A timeout of zero is infinite. */
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRMAXTIME, 1);
+
 	b43_rate_memory_init(dev);
 
 	/* Minimum Contention Window */

-- 

