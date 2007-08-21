Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971AbXHUPFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:05:46 -0400
Message-Id: <20070821150041.213734000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH 06/27] ralink drivers: remove IEEE80211_HW_HOST_GEN_BEACON  flag
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no point in setting that flag, the drivers can simply
call ieee80211_beacon_get() if they need a beacon.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: rt2400-devel@lists.sourceforge.net
Cc: Ivo van Doorn <ivdoorn@gmail.com>

---
 drivers/net/wireless/rt2x00/rt2400pci.c |    1 -
 drivers/net/wireless/rt2x00/rt2500pci.c |    1 -
 drivers/net/wireless/rt2x00/rt61pci.c   |    1 -
 3 files changed, 3 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/rt2x00/rt2400pci.c	2007-08-21 16:25:25.155923881 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00/rt2400pci.c	2007-08-21 16:25:27.765923881 +0200
@@ -1448,7 +1448,6 @@ static void rt2400pci_probe_hw_mode(stru
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
--- wireless-dev.orig/drivers/net/wireless/rt2x00/rt2500pci.c	2007-08-21 16:25:25.165923881 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00/rt2500pci.c	2007-08-21 16:25:27.765923881 +0200
@@ -1746,7 +1746,6 @@ static void rt2500pci_probe_hw_mode(stru
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
--- wireless-dev.orig/drivers/net/wireless/rt2x00/rt61pci.c	2007-08-21 16:25:25.175923881 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00/rt61pci.c	2007-08-21 16:25:27.765923881 +0200
@@ -2119,7 +2119,6 @@ static void rt61pci_probe_hw_mode(struct
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |

-- 

