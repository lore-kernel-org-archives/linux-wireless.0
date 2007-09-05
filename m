Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbXIFNqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:31 -0400
Message-Id: <20070905234631.739054000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 21/21] mac80211: kill vlan_id
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each station has a vlan_id that is useless. Remove it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_sta.c     |    1 -
 net/mac80211/ieee80211_ioctl.c |    1 -
 net/mac80211/sta_info.h        |    2 --
 3 files changed, 4 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs_sta.c	2007-09-06 01:34:52.404453431 +0200
+++ wireless-dev/net/mac80211/debugfs_sta.c	2007-09-06 01:35:30.514453431 +0200
@@ -61,7 +61,6 @@ static const struct file_operations sta_
 
 STA_FILE(aid, aid, D);
 STA_FILE(dev, dev->name, S);
-STA_FILE(vlan_id, vlan_id, D);
 STA_FILE(rx_packets, rx_packets, LU);
 STA_FILE(tx_packets, tx_packets, LU);
 STA_FILE(rx_bytes, rx_bytes, LU);
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-06 01:35:16.144453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-06 01:36:05.424453431 +0200
@@ -734,7 +734,6 @@ static int ieee80211_ioctl_set_sta_vlan(
 							     sta->addr);
 			}
 			sta->dev = new_vlan_dev;
-			sta->vlan_id = param->u.set_sta_vlan.vlan_id;
 			dev_put(new_vlan_dev);
 		}
 		sta_info_put(sta);
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-09-06 01:34:52.554453431 +0200
+++ wireless-dev/net/mac80211/sta_info.h	2007-09-06 01:35:30.524453431 +0200
@@ -109,8 +109,6 @@ struct sta_info {
 	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
 #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
 
-	int vlan_id;
-
 	u16 listen_interval;
 
 #ifdef CONFIG_MAC80211_DEBUGFS

-- 

