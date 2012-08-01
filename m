Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2HARjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 13:39:35 -0400
Message-ID: <1343842772.4638.15.camel@jlt3.sipsolutions.net> (sfid-20120801_193938_642377_3272E093)
Subject: Re: cfg80211_disconnected memory leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 01 Aug 2012 19:39:32 +0200
In-Reply-To: <CAMLZHHQkv_fHzd89fP7bNow7eL3oX+Duzr5rS5NJfhffqwUv2g@mail.gmail.com> (sfid-20120731_193632_210136_6D17A1A4)
References: <CAMLZHHQkv_fHzd89fP7bNow7eL3oX+Duzr5rS5NJfhffqwUv2g@mail.gmail.com>
	 (sfid-20120731_193632_210136_6D17A1A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> unreferenced object 0xe90f1398 (size 64):

>   backtrace:
>     [<b0747a00>] kmemleak_alloc+0x26/0x44
>     [<b049eff1>] __kmalloc+0xf3/0x176
>     [<b0740aae>] cfg80211_disconnected+0x3e/0xc8
>     [<b06008c9>] lbs_disconnect+0x73/0x86
>     [<b0600955>] lbs_cfg_disconnect+0x79/0x88
>     [<b0741c20>] __cfg80211_disconnect+0xf5/0x148
>     [<b072cd8f>] cfg80211_netdev_notifier_call+0x253/0x452

> By adding some printks I have found that cfg80211_disconnected() does
> indeed queue an event to be processed in cfg80211_wq on the eth0
> device, but by the time cfg80211_process_rdev_events() is called, eth0
> is no longer present in the rdev's netdev_list, so the event never
> gets processed (or freed).

This is very odd. What version of the kernel is this?

The strange thing is that we call __cfg80211_disconnect() from the
netdev notifier with NETDEV_GOING_DOWN. This will allocate and queue the
work item as you found. The next thing that happens should be
NETDEV_DOWN, which will cause us to dev_hold() the device and then queue
the cleanup work. The cleanup work must run for us to dev_put() the
device, so that it can only be unregistered after that runs. Then,
finally, we get NETDEV_UNREGISTER which removes it from the list.

Now note that the work item we queue in __cfg80211_disconnect() is
queued *before* the cleanup work, therefore it should also run before
the cleanup work since the workqueue is singlethreaded.

Hence I have no idea how this comes about.

johannes

