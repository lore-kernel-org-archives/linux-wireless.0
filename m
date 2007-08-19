Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:34595 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbXHSSaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:25 -0400
Received: by fk-out-0910.google.com with SMTP id z23so999280fkz
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:23 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/30] rt2x00: Clear MAC and BSSID when non-monitor interface goes down
Date: Sun, 19 Aug 2007 20:21:31 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192021.31729.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From f027057821e22cf353fd37e3c139dc908c85bffe Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 12:51:46 +0200
Subject: [PATCH 02/30] rt2x00: Clear MAC and BSSID when non-monitor interface goes down

When the non-monitor interface goes down the BSSID and MAC address
should be cleared inside the registers to prevent acking of frames.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00.h    |    2 +-
 drivers/net/wireless/rt2x00dev.c |    8 ++++++--
 drivers/net/wireless/rt2x00mac.c |    4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 77556fe..b06cda6 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -290,7 +290,7 @@ struct interface {
 	/*
 	 * MAC of the device.
 	 */
-	u8 *mac;
+	u8 mac[ETH_ALEN];
 
 	/*
 	 * BBSID of the AP to associate with.
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 28ddbe0..1597d2d 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -920,12 +920,16 @@ void rt2x00lib_deinit_interface(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * If no interfaces are present, we should disable the radio
-	 * Otherwise check which interface needs to be initialized.
+	 * Otherwise configure the mac_address and bssid and check
+	 * which interface needs to be initialized.
 	 */
 	if (!is_monitor_present(intf) && !is_interface_present(intf))
 		rt2x00lib_disable_radio(rt2x00dev);
-	else if (is_monitor_present(intf) ^ is_interface_present(intf))
+	else if (is_monitor_present(intf) ^ is_interface_present(intf)) {
+		rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
+		rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 		rt2x00lib_config_type(rt2x00dev, intf->type);
+	}
 
 	/*
 	 * If we are in reset mode, the device must be deinitialized.
diff --git a/drivers/net/wireless/rt2x00mac.c b/drivers/net/wireless/rt2x00mac.c
index c384767..31fe0f1 100644
--- a/drivers/net/wireless/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00mac.c
@@ -192,7 +192,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 		intf->type = conf->type;
 		if (conf->type == IEEE80211_IF_TYPE_AP)
 			memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
-		intf->mac = conf->mac_addr;
+		memcpy(&intf->mac, conf->mac_addr, ETH_ALEN);
 		intf->filter = 0;
 	}
 
@@ -232,7 +232,7 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 		intf->id = 0;
 		intf->type = INVALID_INTERFACE;
 		memset(&intf->bssid, 0x00, ETH_ALEN);
-		intf->mac = NULL;
+		memset(&intf->mac, 0x00, ETH_ALEN);
 		intf->filter = 0;
 	}
 
-- 
1.5.3.rc5

