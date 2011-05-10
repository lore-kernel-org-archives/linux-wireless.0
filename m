Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53274 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab1EJLLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 07:11:48 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: make patches apply again
Date: Tue, 10 May 2011 13:11:34 +0200
Message-Id: <1305025896-12586-1-git-send-email-hauke@hauke-m.de> (sfid-20110510_131151_309415_3E0CD633)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This part of the patch is now in wireless-testing.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/22-multiqueue.patch |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/patches/22-multiqueue.patch b/patches/22-multiqueue.patch
index 2090320..05129d5 100644
--- a/patches/22-multiqueue.patch
+++ b/patches/22-multiqueue.patch
@@ -44,17 +44,6 @@ are used for injecting frames so they have their own respective queue
 handling, but mac80211 just always sends management frames on VO
 queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
 
---- a/drivers/net/wireless/wl12xx/main.c
-+++ b/drivers/net/wireless/wl12xx/main.c
-@@ -1272,7 +1272,7 @@ static struct sk_buff *wl12xx_alloc_dumm
- 	skb->priority = WL1271_TID_MGMT;
- 
- 	/* Initialize all fields that might be used */
--	skb->queue_mapping = 0;
-+	skb_set_queue_mapping(skb, 0);
- 	memset(IEEE80211_SKB_CB(skb), 0, sizeof(struct ieee80211_tx_info));
- 
- 	return skb;
 --- a/net/mac80211/util.c
 +++ b/net/mac80211/util.c
 @@ -264,6 +264,18 @@ __le16 ieee80211_ctstoself_duration(stru
@@ -107,7 +96,7 @@ queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
  
 --- a/net/mac80211/tx.c
 +++ b/net/mac80211/tx.c
-@@ -1598,6 +1598,10 @@ static void ieee80211_xmit(struct ieee80
+@@ -1587,6 +1587,10 @@ static void ieee80211_xmit(struct ieee80
  				return;
  			}
  
@@ -118,7 +107,7 @@ queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
  	ieee80211_set_qos_hdr(local, skb);
  	ieee80211_tx(sdata, skb, false);
  	rcu_read_unlock();
-@@ -2090,7 +2094,14 @@ void ieee80211_tx_pending(unsigned long
+@@ -2079,7 +2083,14 @@ void ieee80211_tx_pending(unsigned long
  
  		if (skb_queue_empty(&local->pending[i]))
  			list_for_each_entry_rcu(sdata, &local->interfaces, list)
-- 
1.7.4.1

