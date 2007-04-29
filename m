Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:50472 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756302AbXD2Pb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 11:31:28 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: remove hostapd scanning
Date: Sun, 29 Apr 2007 11:27:00 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070429155623.3a7f1a67@logostar.upir.cz>
In-Reply-To: <20070429155623.3a7f1a67@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704291127.00777.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 April 2007 09:56, Jiri Benc wrote:
> This removes passive_scan callback with associated code. The whole thing is
> not a job for a driver and can be done in a much cleaner way using user
> space MLME. Besides, nobody (not even hostapd) uses that call.
>
Well, if we're gonna get rid of this, we can kill ieee80211_netif_oper for 
good since ieee80211_scan.c was the last user.

--
mac80211: remove ieee80211_netif_oper

From: Michael Wu <flamingice@sourmilk.net>

Without ieee80211_scan.c, nothing uses ieee80211_netif_oper now. This patch
removes it.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c   |   35 -----------------------------------
 net/mac80211/ieee80211_i.h |    6 ------
 2 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index d4dd85a..958d02d 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4865,41 +4865,6 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
 
-/* Perform netif operations on all configured interfaces */
-int ieee80211_netif_oper(struct ieee80211_hw *hw, Netif_Oper op)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct net_device *dev = local->mdev;
-
-	switch (op) {
-	case NETIF_ATTACH:
-		netif_device_attach(dev);
-		break;
-	case NETIF_DETACH:
-		netif_device_detach(dev);
-		break;
-	case NETIF_START:
-		netif_start_queue(dev);
-		break;
-	case NETIF_STOP:
-		break;
-	case NETIF_WAKE:
-		netif_wake_queue(dev);
-		if (/* FIX: 802.11 qdisc in use */ 1)
-			__netif_schedule(dev);
-		break;
-	case NETIF_IS_STOPPED:
-		if (netif_queue_stopped(dev))
-			return 1;
-		break;
-	case NETIF_UPDATE_TX_START:
-		dev->trans_start = jiffies;
-		break;
-	}
-
-	return 0;
-}
-
 void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 525db14..6c9a162 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -728,12 +728,6 @@ void ieee80211_if_mgmt_setup(struct net_device *dev);
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
-/* This function is deprecated. */
-typedef enum {
-	NETIF_ATTACH, NETIF_DETACH, NETIF_START, NETIF_STOP, NETIF_WAKE,
-	NETIF_IS_STOPPED, NETIF_UPDATE_TX_START
-} Netif_Oper;
-int ieee80211_netif_oper(struct ieee80211_hw *hw, Netif_Oper op);
 
 /* ieee80211_ioctl.c */
 int ieee80211_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
