Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48021 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbZFJUBz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 16:01:55 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, julian.calaby@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] [compat-2.6] Update compat.diff
Date: Wed, 10 Jun 2009 22:01:47 +0200
Message-Id: <1244664108-3997-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1244664108-3997-1-git-send-email-hauke@hauke-m.de>
References: <1244664108-3997-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

requeue was removed out of skbuff.h in wireless-testing.
Add missing import for b43 with kernel 2.6.28.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |   66 ++++++++++++---------------------------------------
 config.mk          |    1 +
 2 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index dec8e91..058a933 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -195,6 +195,18 @@
  	if (res != 0)
  		goto err_kfree_ssb;
  
+--- a/drivers/net/wireless/b43/phy_common.h
++++ b/drivers/net/wireless/b43/phy_common.h
+@@ -2,6 +2,9 @@
+ #define LINUX_B43_PHY_COMMON_H_
+ 
+ #include <linux/types.h>
++#if (LINUX_VERSION_CODE == KERNEL_VERSION(2,6,28))
++#include <asm/atomic.h>
++#endif
+ 
+ struct b43_wldev;
+ 
 --- a/drivers/net/wireless/ipw2x00/ipw2100.c
 +++ b/drivers/net/wireless/ipw2x00/ipw2100.c
 @@ -6008,6 +6008,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
@@ -572,25 +584,9 @@
  
  /**
   * DOC: Key handling basics
---- a/net/mac80211/main.c	2009-04-28 15:34:50.000000000 -0700
-+++ b/net/mac80211/main.c	2009-04-28 15:35:06.000000000 -0700
-@@ -469,6 +469,7 @@
- 		return;
- 	}
- 
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
- 	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
- 		/* Software retry the packet once */
- 		skb->requeue = 1;
-@@ -476,6 +477,7 @@
- 		dev_queue_xmit(skb);
- 		return;
- 	}
-+#endif
- 
- #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
- 	if (net_ratelimit())
-@@ -808,6 +810,7 @@
+--- a/net/mac80211/main.c
++++ b/net/mac80211/main.c
+@@ -759,6 +759,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
  }
  EXPORT_SYMBOL(ieee80211_alloc_hw);
  
@@ -598,7 +594,7 @@
  static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_start_xmit = ieee80211_master_start_xmit,
  	.ndo_open = ieee80211_master_open,
-@@ -815,12 +818,22 @@
+@@ -766,12 +767,22 @@ static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
  	.ndo_select_queue = ieee80211_select_queue,
  };
@@ -643,36 +639,6 @@
  
  	return ops;
  }
---- a/net/mac80211/rx.c	2009-04-28 15:34:51.000000000 -0700
-+++ b/net/mac80211/rx.c	2009-04-28 15:35:06.000000000 -0700
-@@ -815,12 +815,17 @@
- 
- 	/* Send all buffered frames to the station */
- 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
-+#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,28))
-+		dev_kfree_skb(skb);
-+#else
- 		sent++;
- 		skb->requeue = 1;
- 		dev_queue_xmit(skb);
-+#endif
- 	}
- 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
- 		local->total_ps_buffered--;
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
- 		sent++;
- #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
- 		printk(KERN_DEBUG "%s: STA %pM aid %d send PS frame "
-@@ -829,6 +834,9 @@
- #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
- 		skb->requeue = 1;
- 		dev_queue_xmit(skb);
-+#else
-+		dev_kfree_skb(skb);
-+#endif
- 	}
- 
- 	return sent;
 --- a/net/mac80211/wme.c
 +++ b/net/mac80211/wme.c
 @@ -97,6 +97,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
diff --git a/config.mk b/config.mk
index 7de159b..8992f9b 100644
--- a/config.mk
+++ b/config.mk
@@ -295,6 +295,7 @@ endif # end of USB driver list
 ifneq ($(CONFIG_SPI_MASTER),)
 
 CONFIG_WL12XX=m
+CONFIG_P54_SPI=m
 CONFIG_LIBERTAS_SPI=m
 NEED_LIBERTAS=y
 
-- 
1.6.2.1

