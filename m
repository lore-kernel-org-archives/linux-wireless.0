Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:45467 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503AbXB1WIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 17:08:42 -0500
Received: by nf-out-0910.google.com with SMTP id o25so693944nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 14:08:41 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: fix NULL pointer exception
Date: Wed, 28 Feb 2007 23:08:36 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702282308.36935.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will fix a NULL pointer exception when working in master mode.
When a master mode interface is added, the bssid is initialized,
when config_interface() is called the bssid is invalid (only with master mode)
so we cannot use that, instead the bssid inside the interface structure should
be used.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c
index e882182..8dacf00 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c
@@ -480,6 +480,7 @@ int rt2x00lib_config_interface(struct ieee80211_hw *hw, int if_id,
 	struct ieee80211_if_conf *conf)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
 
 	/*
 	 * Monitor mode does not need configuring.
@@ -488,7 +489,7 @@ int rt2x00lib_config_interface(struct ieee80211_hw *hw, int if_id,
 	 */
 	if (conf->type == IEEE80211_IF_TYPE_MNTR)
 		return 0;
-	else if (conf->type != rt2x00dev->interface.type)
+	else if (conf->type != intf->type)
 		return -EINVAL;
 
 	/*
@@ -497,13 +498,13 @@ int rt2x00lib_config_interface(struct ieee80211_hw *hw, int if_id,
 	 * should now be set.
 	 */
 	if (conf->type != IEEE80211_IF_TYPE_AP)
-		memcpy(&rt2x00dev->interface.bssid, conf->bssid, ETH_ALEN);
+		memcpy(&intf->bssid, conf->bssid, ETH_ALEN);
 
 	/*
 	 * Enable configuration.
 	 */
 	rt2x00dev->lib_ops->config_type(rt2x00dev, conf->type);
-	rt2x00dev->lib_ops->config_bssid(rt2x00dev, conf->bssid);
+	rt2x00dev->lib_ops->config_bssid(rt2x00dev, intf->bssid);
 
 	return 0;
 }
