Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:29942 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbXD2OEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 10:04:05 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1126888uga
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2007 07:04:03 -0700 (PDT)
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] rt2x00: remove passive_scan handler
Date: Sun, 29 Apr 2007 16:02:46 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070429155736.322076b3@logostar.upir.cz>
In-Reply-To: <20070429155736.322076b3@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704291602.46275.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 April 2007 15:57, Jiri Benc wrote:
> This removes passive_scan handler that was removed from mac80211.

Ehm, please check my rt2x00 git pull request of yesterday. ;)
To quote myself:
"Perhaps the most interesting thing would be the removal
of passive scan support, because it was a purely software based
solution that (if really required) could best be resolved in mac80211
rather then the driver for devices that don't support such a thing in the
hardware."

When John pulls the upstream branch of rt2x00 git, passive scanning will already be removed. :)

Ivo

> Signed-off-by: Jiri Benc <jbenc@suse.cz>
> 
> ---
>  drivers/net/wireless/mac80211/rt2x00/rt2400pci.c |   22 ----
>  drivers/net/wireless/mac80211/rt2x00/rt2500pci.c |   22 ----
>  drivers/net/wireless/mac80211/rt2x00/rt2500usb.c |   22 ----
>  drivers/net/wireless/mac80211/rt2x00/rt2x00.h    |   57 -----------
>  drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h |    2 
>  drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c |  119 -----------------------
>  drivers/net/wireless/mac80211/rt2x00/rt61pci.c   |   24 ----
>  drivers/net/wireless/mac80211/rt2x00/rt73usb.c   |   24 ----
>  8 files changed, 292 deletions(-)
> 
> --- dscape.orig/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> +++ dscape/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> @@ -1196,12 +1196,6 @@ static void rt2400pci_uninitialize(struc
>  		return;
>  
>  	/*
> -	 * Cancel scanning.
> -	 */
> -	if (rt2x00dev->scan)
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_CANCELLED);
> -
> -	/*
>  	 * Flush out all pending work.
>  	 */
>  	flush_workqueue(rt2x00dev->workqueue);
> @@ -1612,16 +1606,6 @@ static void rt2400pci_txdone(struct work
>  	}
>  
>  	/*
> -	 * Check if we are waiting on an empty queue
> -	 * to start scanning.
> -	 */
> -	if (rt2x00dev->scan &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_TX]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_ATIM]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_PRIO]))
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_READY);
> -
> -	/*
>  	 * If the data ring was full before the txdone handler
>  	 * we must make sure the packet queue in the mac80211 stack
>  	 * is reenabled when the txdone handler has finished.
> @@ -1832,7 +1816,6 @@ static const struct ieee80211_ops rt2400
>  	.config			= rt2x00lib_config,
>  	.config_interface	= rt2x00lib_config_interface,
>  	.set_multicast_list	= rt2x00lib_set_multicast_list,
> -	.passive_scan		= rt2x00lib_passive_scan,
>  	.get_stats		= rt2400pci_get_stats,
>  	.set_retry_limit	= rt2400pci_set_retry_limit,
>  	.conf_tx		= rt2400pci_conf_tx,
> @@ -2310,11 +2293,6 @@ static int rt2400pci_alloc_dev(struct pc
>  	rt2x00dev->interface.type = -EINVAL;
>  
>  	/*
> -	 * Intialize scanning attributes.
> -	 */
> -	rt2x00dev->scan = NULL;
> -
> -	/*
>  	 * Allocate ring array.
>  	 */
>  	if (rt2400pci_alloc_rings(rt2x00dev))
> --- dscape.orig/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
> +++ dscape/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
> @@ -1322,12 +1322,6 @@ static void rt2500pci_uninitialize(struc
>  		return;
>  
>  	/*
> -	 * Cancel scanning.
> -	 */
> -	if (rt2x00dev->scan)
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_CANCELLED);
> -
> -	/*
>  	 * Flush out all pending work.
>  	 */
>  	flush_workqueue(rt2x00dev->workqueue);
> @@ -1778,16 +1772,6 @@ static void rt2500pci_txdone(struct work
>  	}
>  
>  	/*
> -	 * Check if we are waiting on an empty queue
> -	 * to start scanning.
> -	 */
> -	if (rt2x00dev->scan &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_TX]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_ATIM]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_PRIO]))
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_READY);
> -
> -	/*
>  	 * If the data ring was full before the txdone handler
>  	 * we must make sure the packet queue in the mac80211 stack
>  	 * is reenabled when the txdone handler has finished.
> @@ -1973,7 +1957,6 @@ static const struct ieee80211_ops rt2500
>  	.config			= rt2x00lib_config,
>  	.config_interface	= rt2x00lib_config_interface,
>  	.set_multicast_list	= rt2x00lib_set_multicast_list,
> -	.passive_scan		= rt2x00lib_passive_scan,
>  	.get_stats		= rt2500pci_get_stats,
>  	.set_retry_limit	= rt2500pci_set_retry_limit,
>  	.conf_tx		= rt2x00lib_conf_tx,
> @@ -2607,11 +2590,6 @@ static int rt2500pci_alloc_dev(struct pc
>  	rt2x00dev->interface.type = -EINVAL;
>  
>  	/*
> -	 * Intialize scanning attributes.
> -	 */
> -	rt2x00dev->scan = NULL;
> -
> -	/*
>  	 * Allocate ring array.
>  	 */
>  	if (rt2500pci_alloc_rings(rt2x00dev))
> --- dscape.orig/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
> +++ dscape/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
> @@ -1246,12 +1246,6 @@ static void rt2500usb_uninitialize(struc
>  		return;
>  
>  	/*
> -	 * Cancel scanning.
> -	 */
> -	if (rt2x00dev->scan)
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_CANCELLED);
> -
> -	/*
>  	 * Flush out all pending work.
>  	 */
>  	flush_workqueue(rt2x00dev->workqueue);
> @@ -1731,16 +1725,6 @@ static void rt2500usb_interrupt_txdone(s
>  	rt2x00_ring_index_done_inc(entry->ring);
>  
>  	/*
> -	 * Check if we are waiting on an empty queue
> -	 * to start scanning.
> -	 */
> -	if (rt2x00dev->scan &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_TX]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_ATIM]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_PRIO]))
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_READY);
> -
> -	/*
>  	 * If the data ring was full before the txdone handler
>  	 * we must make sure the packet queue in the mac80211 stack
>  	 * is reenabled when the txdone handler has finished.
> @@ -1878,7 +1862,6 @@ static const struct ieee80211_ops rt2500
>  	.config			= rt2x00lib_config,
>  	.config_interface	= rt2x00lib_config_interface,
>  	.set_multicast_list	= rt2x00lib_set_multicast_list,
> -	.passive_scan		= rt2x00lib_passive_scan,
>  	.get_stats		= rt2500usb_get_stats,
>  	.conf_tx		= rt2x00lib_conf_tx,
>  	.get_tx_stats		= rt2x00lib_get_tx_stats,
> @@ -2433,11 +2416,6 @@ static int rt2500usb_alloc_dev(struct us
>  	rt2x00dev->interface.type = -EINVAL;
>  
>  	/*
> -	 * Intialize scanning attributes.
> -	 */
> -	rt2x00dev->scan = NULL;
> -
> -	/*
>  	 * Allocate ring array.
>  	 */
>  	if (rt2500usb_alloc_rings(rt2x00dev))
> --- dscape.orig/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
> +++ dscape/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
> @@ -646,58 +646,6 @@ struct interface {
>  };
>  
>  /*
> - * Scanning structure.
> - * Swithing channel during scanning will be put
> - * in a workqueue so we will be able to sleep
> - * during the switch.
> - * We also make use of the completion structure
> - * in case a frame must be send before a
> - * channel switch.
> - */
> -struct scanning {
> -	/*
> -	 * Pointer to main rt2x00dev structure where this
> -	 * scanning structure belongs to.
> -	 */
> -	struct rt2x00_dev *rt2x00dev;
> -
> -	/*
> -	 * Completion structure if an packet needs to be send.
> -	 */
> -	struct completion completion;
> -
> -	/*
> -	 * Scanning parameters.
> -	 */
> -	struct ieee80211_scan_conf conf;
> -
> -	/*
> -	 * Scanning state: IEEE80211_SCAN_START or IEEE80211_SCAN_END.
> -	 */
> -	short state;
> -
> -	/*
> -	 * Flag to see if this scan has been cancelled.
> -	 */
> -	short status;
> -#define SCANNING_READY		0x0000
> -#define SCANNING_WAITING	0x0001
> -#define SCANNING_CANCELLED	0x0002
> -
> -	/*
> -	 * Work structure for scheduling the scanning work.
> -	 */
> -	struct work_struct work;
> -};
> -
> -static inline void rt2x00_signal_scan(struct scanning *scan, short status)
> -{
> -	scan->status = status;
> -
> -	complete_all(&scan->completion);
> -}
> -
> -/*
>   * rt2x00lib callback functions.
>   */
>  struct rt2x00lib_ops {
> @@ -886,11 +834,6 @@ struct rt2x00_dev {
>  	struct ieee80211_rx_status rx_status;
>  
>  	/*
> -	 * Scanning structure.
> -	 */
> -	struct scanning *scan;
> -
> -	/*
>  	 * Data rings for both RX and TX.
>  	 * The first entries must be the normal TX
>  	 * rings, followed by a possible ATIM ring
> --- dscape.orig/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
> +++ dscape/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
> @@ -70,8 +70,6 @@ int rt2x00lib_config_interface(struct ie
>  	struct ieee80211_if_conf *conf);
>  void rt2x00lib_set_multicast_list(struct ieee80211_hw *hw,
>  	unsigned short flags, int mc_count);
> -int rt2x00lib_passive_scan(struct ieee80211_hw *hw,
> -	int state, struct ieee80211_scan_conf *conf);
>  int rt2x00lib_get_tx_stats(struct ieee80211_hw *hw,
>  	struct ieee80211_tx_queue_stats *stats);
>  int rt2x00lib_conf_tx(struct ieee80211_hw *hw, int queue,
> --- dscape.orig/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
> +++ dscape/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
> @@ -369,125 +369,6 @@ void rt2x00lib_set_multicast_list(struct
>  }
>  EXPORT_SYMBOL_GPL(rt2x00lib_set_multicast_list);
>  
> -static void rt2x00lib_scan(struct work_struct *work)
> -{
> -	struct scanning *scan =
> -		container_of(work, struct scanning, work);
> -
> -	if (unlikely(!scan->rt2x00dev))
> -		return;
> -
> -	/*
> -	 * Before we can start switch the channel for scanning
> -	 * we need to wait until all TX rings are empty to guarantee
> -	 * that all frames are send on the correct channel.
> -	 * Check if the status is set SCANNING_WAITING in order to
> -	 * start waiting, or if it is set to SCANNING_CANCELLED which
> -	 * means that we shouldn't proceed with the scanning.
> -	 */
> -	if (scan->status == SCANNING_WAITING)
> -		wait_for_completion(&scan->completion);
> -	if (scan->status == SCANNING_CANCELLED)
> -		goto exit;
> -
> -	/*
> -	 * Switch channel and update active info for RX.
> -	 */
> -	if (scan->state == IEEE80211_SCAN_START) {
> -		scan->rt2x00dev->lib_ops->config_phymode(
> -			scan->rt2x00dev,
> -			scan->conf.scan_phymode);
> -
> -		scan->rt2x00dev->lib_ops->config_channel(
> -			scan->rt2x00dev,
> -			scan->conf.scan_channel_val,
> -			scan->conf.scan_channel,
> -			scan->conf.scan_freq,
> -			scan->conf.scan_power_level);
> -	} else {
> -		scan->rt2x00dev->lib_ops->config_phymode(
> -			scan->rt2x00dev,
> -			scan->conf.running_phymode);
> -
> -		scan->rt2x00dev->lib_ops->config_channel(
> -			scan->rt2x00dev,
> -			scan->conf.running_channel_val,
> -			scan->conf.running_channel,
> -			scan->conf.running_freq,
> -			scan->conf.scan_power_level);
> -	}
> -
> -exit:
> -	scan->rt2x00dev->scan = NULL;
> -	kfree(scan);
> -}
> -
> -int rt2x00lib_passive_scan(struct ieee80211_hw *hw,
> -	int state, struct ieee80211_scan_conf *conf)
> -{
> -	struct rt2x00_dev *rt2x00dev = hw->priv;
> -
> -	/*
> -	 * Check if we are not busy with the previous
> -	 * passive scan request.
> -	 */
> -	if (rt2x00dev->scan)
> -		return -EBUSY;
> -
> -	/*
> -	 * Check if the radio is enabled.
> -	 */
> -	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
> -		return -EIO;
> -
> -	/*
> -	 * Allocate scanning structure to store scanning info.
> -	 */
> -	rt2x00dev->scan = kzalloc(sizeof(struct scanning), GFP_ATOMIC);
> -	if (!rt2x00dev->scan)
> -		return -ENOMEM;
> -
> -	/*
> -	 * Initialize Scanning structure.
> -	 */
> -	rt2x00dev->scan->rt2x00dev = rt2x00dev;
> -	rt2x00dev->scan->state = state;
> -	memcpy(&rt2x00dev->scan->conf, conf, sizeof(*conf));
> -
> -	/*
> -	 * Initialize completion handler.
> -	 * Set initial status to SCANNING_WAITING to prevent scanning
> -	 * to begin while there are still TX packets queued.
> -	 */
> -	init_completion(&rt2x00dev->scan->completion);
> -	rt2x00dev->scan->status = SCANNING_WAITING;
> -
> -	/*
> -	 * Check if we have to send a packet before the
> -	 * channel switch.
> -	 */
> -	if (conf->skb) {
> -		if (rt2x00dev->hw_ops->tx(hw, conf->skb, conf->tx_control))
> -			goto exit;
> -	}
> -
> -	/*
> -	 * Queue work.
> -	 */
> -	INIT_WORK(&rt2x00dev->scan->work, rt2x00lib_scan);
> -	if (!queue_work(rt2x00dev->workqueue, &rt2x00dev->scan->work))
> -		goto exit;
> -
> -	return 0;
> -
> -exit:
> -	kfree(rt2x00dev->scan);
> -	rt2x00dev->scan = NULL;
> -
> -	return -EIO;
> -}
> -EXPORT_SYMBOL_GPL(rt2x00lib_passive_scan);
> -
>  int rt2x00lib_get_tx_stats(struct ieee80211_hw *hw,
>  	struct ieee80211_tx_queue_stats *stats)
>  {
> --- dscape.orig/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
> +++ dscape/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
> @@ -1592,12 +1592,6 @@ static void rt61pci_uninitialize(struct 
>  		return;
>  
>  	/*
> -	 * Cancel scanning.
> -	 */
> -	if (rt2x00dev->scan)
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_CANCELLED);
> -
> -	/*
>  	 * Flush out all pending work.
>  	 */
>  	flush_workqueue(rt2x00dev->workqueue);
> @@ -2073,18 +2067,6 @@ static void rt61pci_txdone(struct work_s
>  	}
>  
>  	/*
> -	 * Check if we are waiting on an empty queue
> -	 * to start scanning.
> -	 */
> -	if (rt2x00dev->scan &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_AC_VO]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_AC_VI]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_AC_BE]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_AC_BK]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_PRIO]))
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_READY);
> -
> -	/*
>  	 * If the data ring was full before the txdone handler
>  	 * we must make sure the packet queue in the mac80211 stack
>  	 * is reenabled when the txdone handler has finished.
> @@ -2280,7 +2262,6 @@ static const struct ieee80211_ops rt61pc
>  	.config			= rt2x00lib_config,
>  	.config_interface	= rt2x00lib_config_interface,
>  	.set_multicast_list	= rt2x00lib_set_multicast_list,
> -	.passive_scan		= rt2x00lib_passive_scan,
>  	.get_stats		= rt61pci_get_stats,
>  	.set_retry_limit	= rt61pci_set_retry_limit,
>  	.conf_tx		= rt2x00lib_conf_tx,
> @@ -3072,11 +3053,6 @@ static int rt61pci_alloc_dev(struct pci_
>  	rt2x00dev->interface.type = -EINVAL;
>  
>  	/*
> -	 * Initialize scanning attributes.
> -	 */
> -	rt2x00dev->scan = NULL;
> -
> -	/*
>  	 * Allocate ring array.
>  	 */
>  	if (rt61pci_alloc_rings(rt2x00dev))
> --- dscape.orig/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
> +++ dscape/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
> @@ -1375,12 +1375,6 @@ static void rt73usb_uninitialize(struct 
>  		return;
>  
>  	/*
> -	 * Cancel scanning.
> -	 */
> -	if (rt2x00dev->scan)
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_CANCELLED);
> -
> -	/*
>  	 * Flush out all pending work.
>  	 */
>  	flush_workqueue(rt2x00dev->workqueue);
> @@ -1877,18 +1871,6 @@ static void rt73usb_interrupt_txdone(str
>  	rt2x00_ring_index_done_inc(entry->ring);
>  
>  	/*
> -	 * Check if we are waiting on an empty queue
> -	 * to start scanning.
> -	 */
> -	if (rt2x00dev->scan &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_AC_VO]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_AC_VI]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_AC_BE]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_AC_BK]) &&
> -	    rt2x00_ring_empty(&rt2x00dev->ring[RING_PRIO]))
> -		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_READY);
> -
> -	/*
>  	 * If the data ring was full before the txdone handler
>  	 * we must make sure the packet queue in the mac80211 stack
>  	 * is reenabled when the txdone handler has finished.
> @@ -2053,7 +2035,6 @@ static const struct ieee80211_ops rt73us
>  	.config			= rt2x00lib_config,
>  	.config_interface	= rt2x00lib_config_interface,
>  	.set_multicast_list	= rt2x00lib_set_multicast_list,
> -	.passive_scan		= rt2x00lib_passive_scan,
>  	.get_stats		= rt73usb_get_stats,
>  	.set_retry_limit	= rt73usb_set_retry_limit,
>  	.conf_tx		= rt2x00lib_conf_tx,
> @@ -2720,11 +2701,6 @@ static int rt73usb_alloc_dev(struct usb_
>  	rt2x00dev->interface.type = -EINVAL;
>  
>  	/*
> -	 * Intialize scanning attributes.
> -	 */
> -	rt2x00dev->scan = NULL;
> -
> -	/*
>  	 * Allocate ring array.
>  	 */
>  	if (rt73usb_alloc_rings(rt2x00dev))
> 
> 
