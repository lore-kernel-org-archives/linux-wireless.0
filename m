Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:50705 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYECXKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 19:10:04 -0400
Received: by nf-out-0910.google.com with SMTP id d3so885274nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2008 16:10:03 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: multiqueue
Date: Sun, 4 May 2008 01:15:24 +0200
Cc: linux-wireless@vger.kernel.org
References: <200805040035.05512.IvDoorn@gmail.com> <1209854340.3673.23.camel@johannes.berg>
In-Reply-To: <1209854340.3673.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805040115.24553.IvDoorn@gmail.com> (sfid-20080504_010935_374302_7FF9CB5D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 May 2008, Johannes Berg wrote:
> Hi Ivo,
> 
> > Below is a warning I get with your latest QOS patch series,
> > rt61pci registers 4 queues, but apparently the WARN_ON()
> > in ieee80211_wake_queue is being triggered.
> > 
> > void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
> > {
> > 	struct ieee80211_local *local = hw_to_local(hw);
> > 
> > 	if (netif_is_multiqueue(local->mdev)) {
> > 		netif_wake_subqueue(local->mdev, queue);
> > 	} else {
> > 		WARN_ON(queue != 0);
> > 		netif_wake_queue(local->mdev);
> > 	}
> > }
> > 
> > CONFIG_MAC80211_QOS is enabled in the kernel configuration,
> > and debugfs shows that rt2x00 is serving frames over multiple
> > TX queues, so the multiqueue is working...
> 
> Strange. Can you verify that the master device has the
> NETIF_F_MULTI_QUEUE flag set? Since that config symbol got enabled you
> must have multiqueue code compiled in. Or maybe I put the setting of the
> MULTI_QUEUE flag into a wrong patch by accident? Check
> net/mac80211/main.c please

My config options are:
CONFIG_NET_SCHED=y
CONFIG_NETDEVICES_MULTIQUEUE=y
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_QOS=y

snip from net/mac80211/main.c:

#ifdef CONFIG_MAC80211_QOS
	if (hw->queues > IEEE80211_MAX_QUEUES)
		hw->queues = IEEE80211_MAX_QUEUES;
	if (hw->ampdu_queues > IEEE80211_MAX_AMPDU_QUEUES)
		hw->ampdu_queues = IEEE80211_MAX_AMPDU_QUEUES;
	if (hw->queues < 4)
		hw->ampdu_queues = 0;
#else
	hw->queues = 1;
	hw->ampdu_queues = 0;
#endif

	/* for now, mdev needs sub_if_data :/ */
	mdev = alloc_netdev_mq(sizeof(struct ieee80211_sub_if_data),
			       "wmaster%d", ether_setup,
			       hw->queues + hw->ampdu_queues);
	if (!mdev)
		goto fail_mdev_alloc;
	if (hw->queues > 1)
		mdev->flags |= NETIF_F_MULTI_QUEUE;

So theoretically this flag should be set.
However /sys/class/net/wmaster1/features contains the value 0x0

Ivo
