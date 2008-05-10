Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYEJWWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 18:22:03 -0400
Received: from [91.5.117.77] (helo=[10.0.0.127])
	by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1JuxS4-0000z9-S0
	for linux-wireless@vger.kernel.org; Sun, 11 May 2008 00:22:01 +0200
Message-Id: <20080510221907.428400000@sipsolutions.net> (sfid-20080511_002226_206457_2891D8EB)
References: <20080510221845.340428000@sipsolutions.net>
Date: Sun, 11 May 2008 00:18:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT/C 4/7] mac80211: let drivers wake but not start queues
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having drivers start queues is just confusing, their ->start()
callback can block and do whatever is necessary, so let mac80211
start queues and have drivers wake queues when necessary (to get
packets flowing again right away.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/adm8211.c              |    2 +-
 drivers/net/wireless/at76_usb.c             |    4 ++--
 drivers/net/wireless/ath5k/base.c           |    2 +-
 drivers/net/wireless/b43/main.c             |    1 -
 drivers/net/wireless/b43legacy/main.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 drivers/net/wireless/p54/p54common.c        |    3 ---
 drivers/net/wireless/p54/p54pci.c           |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    4 ++--
 include/net/mac80211.h                      |    8 --------
 net/mac80211/main.c                         |    8 +++++++-
 net/mac80211/util.c                         |   12 ------------
 13 files changed, 16 insertions(+), 35 deletions(-)

--- everything.orig/drivers/net/wireless/adm8211.c	2008-05-10 23:00:08.000000000 +0200
+++ everything/drivers/net/wireless/adm8211.c	2008-05-11 00:02:10.000000000 +0200
@@ -2014,7 +2014,7 @@ static int adm8211_resume(struct pci_dev
 
 	if (priv->mode != IEEE80211_IF_TYPE_INVALID) {
 		adm8211_start(dev);
-		ieee80211_start_queues(dev);
+		ieee80211_wake_queues(dev);
 	}
 
 	return 0;
--- everything.orig/drivers/net/wireless/at76_usb.c	2008-05-10 23:00:07.000000000 +0200
+++ everything/drivers/net/wireless/at76_usb.c	2008-05-11 00:02:09.000000000 +0200
@@ -1720,7 +1720,7 @@ static void at76_mac80211_tx_callback(st
 	memset(&priv->tx_status, 0, sizeof(priv->tx_status));
 	priv->tx_skb = NULL;
 
-	ieee80211_start_queues(priv->hw);
+	ieee80211_wake_queues(priv->hw);
 }
 
 static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -1918,7 +1918,7 @@ static void at76_dwork_hw_scan(struct wo
 	if (is_valid_ether_addr(priv->bssid))
 		at76_join(priv);
 
-	ieee80211_start_queues(priv->hw);
+	ieee80211_wake_queues(priv->hw);
 
 exit:
 	mutex_unlock(&priv->mtx);
--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-05-10 23:00:08.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.c	2008-05-11 00:02:10.000000000 +0200
@@ -1601,7 +1601,7 @@ ath5k_txq_cleanup(struct ath5k_softc *sc
 					sc->txqs[i].link);
 			}
 	}
-	ieee80211_start_queues(sc->hw); /* XXX move to callers */
+	ieee80211_wake_queues(sc->hw); /* XXX move to callers */
 
 	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
 		if (sc->txqs[i].setup)
--- everything.orig/drivers/net/wireless/b43/main.c	2008-05-10 23:00:08.000000000 +0200
+++ everything/drivers/net/wireless/b43/main.c	2008-05-11 00:02:10.000000000 +0200
@@ -3497,7 +3497,6 @@ static int b43_wireless_core_start(struc
 	/* Start data flow (TX/RX). */
 	b43_mac_enable(dev);
 	b43_interrupt_enable(dev, dev->irq_savedstate);
-	ieee80211_start_queues(dev->wl->hw);
 
 	/* Start maintainance work */
 	b43_periodic_tasks_setup(dev);
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-05-10 23:00:08.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-05-11 00:02:06.000000000 +0200
@@ -2794,7 +2794,6 @@ static int b43legacy_wireless_core_start
 	/* Start data flow (TX/RX) */
 	b43legacy_mac_enable(dev);
 	b43legacy_interrupt_enable(dev, dev->irq_savedstate);
-	ieee80211_start_queues(dev->wl->hw);
 
 	/* Start maintenance work */
 	b43legacy_periodic_tasks_setup(dev);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-10 23:00:07.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-11 00:02:09.000000000 +0200
@@ -5832,7 +5832,7 @@ static void iwl3945_alive_start(struct i
 	if (iwl3945_is_rfkill(priv))
 		return;
 
-	ieee80211_start_queues(priv->hw);
+	ieee80211_wake_queues(priv->hw);
 
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-10 23:00:07.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-11 00:02:09.000000000 +0200
@@ -4853,7 +4853,7 @@ static void iwl4965_alive_start(struct i
 	if (iwl_is_rfkill(priv))
 		return;
 
-	ieee80211_start_queues(priv->hw);
+	ieee80211_wake_queues(priv->hw);
 
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-05-10 23:00:08.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-05-11 00:02:10.000000000 +0200
@@ -375,9 +375,6 @@ static void inline p54_wake_free_queues(
 	struct p54_common *priv = dev->priv;
 	int i;
 
-	/* ieee80211_start_queues is great if all queues are really empty.
-	 * But, what if some are full? */
-
 	for (i = 0; i < dev->queues; i++)
 		if (priv->tx_stats[i].len < priv->tx_stats[i].limit)
 			ieee80211_wake_queue(dev, i);
--- everything.orig/drivers/net/wireless/p54/p54pci.c	2008-05-10 23:00:08.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54pci.c	2008-05-10 23:07:37.000000000 +0200
@@ -665,7 +665,7 @@ static int p54p_resume(struct pci_dev *p
 
 	if (priv->common.mode != IEEE80211_IF_TYPE_INVALID) {
 		p54p_open(dev);
-		ieee80211_start_queues(dev);
+		ieee80211_wake_queues(dev);
 	}
 
 	return 0;
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-05-10 23:00:08.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-05-11 00:02:04.000000000 +0200
@@ -125,7 +125,7 @@ int rt2x00lib_enable_radio(struct rt2x00
 	/*
 	 * Start the TX queues.
 	 */
-	ieee80211_start_queues(rt2x00dev->hw);
+	ieee80211_wake_queues(rt2x00dev->hw);
 
 	return 0;
 }
@@ -1186,7 +1186,7 @@ int rt2x00lib_resume(struct rt2x00_dev *
 	 * In that case we have disabled the TX queue and should
 	 * now enable it again
 	 */
-	ieee80211_start_queues(rt2x00dev->hw);
+	ieee80211_wake_queues(rt2x00dev->hw);
 
 	/*
 	 * During interface iteration we might have changed the
--- everything.orig/net/mac80211/util.c	2008-05-10 23:07:35.000000000 +0200
+++ everything/net/mac80211/util.c	2008-05-11 00:02:09.000000000 +0200
@@ -350,18 +350,6 @@ void ieee80211_stop_queue(struct ieee802
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
-void ieee80211_start_queues(struct ieee80211_hw *hw)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	int i;
-
-	for (i = 0; i < hw->queues + hw->ampdu_queues; i++)
-		clear_bit(IEEE80211_LINK_STATE_XOFF, &local->state[i]);
-	if (!ieee80211_qdisc_installed(local->mdev))
-		netif_start_queue(local->mdev);
-}
-EXPORT_SYMBOL(ieee80211_start_queues);
-
 void ieee80211_stop_queues(struct ieee80211_hw *hw)
 {
 	int i;
--- everything.orig/include/net/mac80211.h	2008-05-10 23:00:07.000000000 +0200
+++ everything/include/net/mac80211.h	2008-05-11 00:02:09.000000000 +0200
@@ -1546,14 +1546,6 @@ void ieee80211_wake_queue(struct ieee802
 void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue);
 
 /**
- * ieee80211_start_queues - start all queues
- * @hw: pointer to as obtained from ieee80211_alloc_hw().
- *
- * Drivers should use this function instead of netif_start_queue.
- */
-void ieee80211_start_queues(struct ieee80211_hw *hw);
-
-/**
  * ieee80211_stop_queues - stop all queues
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  *
--- everything.orig/net/mac80211/main.c	2008-05-10 23:00:07.000000000 +0200
+++ everything/net/mac80211/main.c	2008-05-11 00:04:49.000000000 +0200
@@ -112,7 +112,13 @@ static int ieee80211_master_open(struct 
 			break;
 		}
 	}
-	return res;
+
+	if (res)
+		return res;
+
+	netif_start_queue(local->mdev);
+
+	return 0;
 }
 
 static int ieee80211_master_stop(struct net_device *dev)

-- 

