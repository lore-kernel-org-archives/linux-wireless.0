Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51217 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab1DZTRu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 15:17:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: use function for setting queue_mapping
Date: Tue, 26 Apr 2011 21:17:11 +0200
Message-Id: <1303845431-972-2-git-send-email-hauke@hauke-m.de> (sfid-20110426_211805_054094_A89A532C)
In-Reply-To: <1303845431-972-1-git-send-email-hauke@hauke-m.de>
References: <1303845431-972-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/22-multiqueue.patch |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/patches/22-multiqueue.patch b/patches/22-multiqueue.patch
index 0aa0ec6..2090320 100644
--- a/patches/22-multiqueue.patch
+++ b/patches/22-multiqueue.patch
@@ -44,6 +44,17 @@ are used for injecting frames so they have their own respective queue
 handling, but mac80211 just always sends management frames on VO
 queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
 
+--- a/drivers/net/wireless/wl12xx/main.c
++++ b/drivers/net/wireless/wl12xx/main.c
+@@ -1272,7 +1272,7 @@ static struct sk_buff *wl12xx_alloc_dumm
+ 	skb->priority = WL1271_TID_MGMT;
+ 
+ 	/* Initialize all fields that might be used */
+-	skb->queue_mapping = 0;
++	skb_set_queue_mapping(skb, 0);
+ 	memset(IEEE80211_SKB_CB(skb), 0, sizeof(struct ieee80211_tx_info));
+ 
+ 	return skb;
 --- a/net/mac80211/util.c
 +++ b/net/mac80211/util.c
 @@ -264,6 +264,18 @@ __le16 ieee80211_ctstoself_duration(stru
-- 
1.7.1

