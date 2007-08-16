Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765759AbXHPQa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 12:30:56 -0400
Message-Id: <20070816162932.472787000@sipsolutions.net>
References: <20070816162908.030659000@sipsolutions.net>
Date: Thu, 16 Aug 2007 18:29:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 2/4] rtl8187: remove IEEE80211_HW_DATA_NULLFUNC_ACK
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag will be removed from mac80211 because it is unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>

---
 drivers/net/wireless/rtl8187_dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/rtl8187_dev.c	2007-08-16 18:18:59.553468950 +0200
+++ wireless-dev/drivers/net/wireless/rtl8187_dev.c	2007-08-16 18:19:02.563468950 +0200
@@ -621,8 +621,7 @@ static int __devinit rtl8187_probe(struc
 	priv->mode = IEEE80211_IF_TYPE_MGMT;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_WEP_INCLUDE_IV |
-		     IEEE80211_HW_DATA_NULLFUNC_ACK;
+		     IEEE80211_HW_WEP_INCLUDE_IV;
 	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
 	dev->queues = 1;
 	dev->max_rssi = 65;

-- 

