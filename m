Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbXGaSeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:19 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:19 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/24] rt2x00: Call all configure handlers during resume
Date: Tue, 31 Jul 2007 20:37:29 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.29645.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 4800d5b02a237838913df950e557cf17f2f70dde Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sun, 29 Jul 2007 14:19:31 +0200
Subject: [PATCH 16/24] rt2x00: Call all configure handlers during resume

All configure handlers should be called during
resume operation to bring the device back into
the correct state to make the device work again.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00dev.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 0220107..4989cdb 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -1078,6 +1078,9 @@ EXPORT_SYMBOL_GPL(rt2x00lib_suspend);
 
 int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 {
+	const struct rt2x00lib_ops *lib = rt2x00dev->ops->lib;
+	struct ieee80211_conf *conf = &rt2x00dev->hw->conf;
+	struct interface *intf = &rt2x00dev->interface;
 	int retval;
 
 	NOTICE(rt2x00dev, "Waking up.\n");
@@ -1095,10 +1098,27 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Configure the device to the original state.
+	 */
+	lib->config_type(rt2x00dev, intf->type);
+	lib->config_promisc(rt2x00dev, test_bit(INTERFACE_ENABLED_PROMISC,
+						&rt2x00dev->flags));
+	lib->config_bssid(rt2x00dev, intf->bssid);
+	lib->config_phymode(rt2x00dev, conf->phymode);
+	lib->config_channel(rt2x00dev, conf->channel_val,
+			    conf->channel, conf->power_level);
+	lib->config_antenna(rt2x00dev, conf->antenna_sel_tx,
+			    conf->antenna_sel_rx);
+	lib->config_duration(rt2x00dev,
+			     (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME),
+			     conf->beacon_int);
+	lib->reset_tuner(rt2x00dev);
+
+	/*
 	 * We only need to continue when in Master or Ad-hoc mode.
 	 */
-	if (rt2x00dev->interface.type != IEEE80211_IF_TYPE_AP &&
-	    rt2x00dev->interface.type != IEEE80211_IF_TYPE_IBSS)
+	if (intf->type != IEEE80211_IF_TYPE_AP &&
+	    intf->type != IEEE80211_IF_TYPE_IBSS)
 		return 0;
 
 	/*
-- 
1.5.2.4

