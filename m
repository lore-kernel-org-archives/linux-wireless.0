Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbXHPQb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 12:31:27 -0400
Message-Id: <20070816162932.999042000@sipsolutions.net>
References: <20070816162908.030659000@sipsolutions.net>
Date: Thu, 16 Aug 2007 18:29:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, developers@islsm.org
Subject: [PATCH 3/4] p54: remove IEEE80211_HW_DATA_NULLFUNC_ACK
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag will be removed from mac80211 because it is unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: developers@islsm.org

---
 drivers/net/wireless/p54common.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/p54common.c	2007-08-16 18:19:38.323468950 +0200
+++ wireless-dev/drivers/net/wireless/p54common.c	2007-08-16 18:19:49.633468950 +0200
@@ -893,9 +893,7 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->modes[0].channels = priv->channels;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
 		    IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_WEP_INCLUDE_IV |
-		    IEEE80211_HW_DATA_NULLFUNC_ACK; /* TODO: check */
-		    /* IEEE80211_HW_MONITOR_DURING_OPER FIXME: check */
+		    IEEE80211_HW_WEP_INCLUDE_IV;
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_rssi = 100;
 

-- 

