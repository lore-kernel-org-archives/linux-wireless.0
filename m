Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48828 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933405AbXGaSea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:30 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121282ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:29 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 22/24] rt2x00: Configure type during add_interface
Date: Tue, 31 Jul 2007 20:37:40 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.40306.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From b10059fd3e2bbaef1f82ac60a177902bd19071dc Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 31 Jul 2007 17:09:15 +0200
Subject: [PATCH 22/24] rt2x00: Configure type during add_interface

When there was only 1 interface present which was configured
as monitor interface the interface would fail to configure
the device correctly. This resulted in too many frames to be dropped.

This patch will add the configure_type and configure_packet_filter
to the add_interface handler instead of the config_interface handler.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00mac.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00mac.c b/drivers/net/wireless/rt2x00mac.c
index 9c6d043..205f10f 100644
--- a/drivers/net/wireless/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00mac.c
@@ -173,6 +173,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct interface *intf = &rt2x00dev->interface;
+	int retval;
 
 	/*
 	 * We only support 1 non-monitor interface.
@@ -195,7 +196,17 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 		intf->filter = 0;
 	}
 
-	return rt2x00lib_init_interface(rt2x00dev);
+	retval = rt2x00lib_init_interface(rt2x00dev);
+	if (retval)
+		return retval;
+
+	/*
+	 * Configure interface.
+	 */
+	rt2x00lib_config_type(rt2x00dev, conf->type);
+	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_add_interface);
 
@@ -290,12 +301,6 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
 	 */
 	if (conf->type != IEEE80211_IF_TYPE_AP)
 		memcpy(&intf->bssid, conf->bssid, ETH_ALEN);
-
-	/*
-	 * Enable configuration.
-	 */
-	rt2x00lib_config_type(rt2x00dev, conf->type);
-	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
 	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 
 	/*
-- 
1.5.2.4

