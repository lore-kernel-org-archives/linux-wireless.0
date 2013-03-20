Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3CTPJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 11:09:08 -0400
Message-ID: <1363792139.8224.10.camel@jlt4.sipsolutions.net> (sfid-20130320_160934_773672_8262B976)
Subject: Re: rcutree tree warning during P2P device support testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: David Spinadel <dvdspndl@gmail.com>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Date: Wed, 20 Mar 2013 16:08:59 +0100
In-Reply-To: <5149CD81.40301@broadcom.com>
References: <5149CD81.40301@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I am testing the P2P device support patches. Upon stopping the
> wpa_supplicant I get the following warning and when I unload brcmfmac it
> hangs resulting in hung_task_timeout message. The whole rcu stuff still
> needs to settle in my brain. I suspect the warning is related to
> brcmfmac unload failure, but maybe you have some ideas where I should look.

Hmm, why would stopping the supplicant cause brcmfmac to unload?? Or are
you saying you first stop the supplicant, which gets you that warning,
and then unload fails?

> [ 1634.039095] WARNING: at kernel/rcutree.c:1960
> rcu_process_callbacks+0x469/0x560()

> [ 1634.133917] Call Trace:
> [ 1634.139833]  [<c1039c92>] warn_slowpath_common+0x72/0xa0
> [ 1634.148659]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
> [ 1634.157914]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
> [ 1634.167121]  [<c1039ce2>] warn_slowpath_null+0x22/0x30
> [ 1634.175725]  [<c10c61f9>] rcu_process_callbacks+0x469/0x560

Can't say I understand this warning ...

> [ 3606.381631] INFO: task khubd:30 blocked for more than 120 seconds.
> [ 3606.388366] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3606.396931] khubd           D f4f01cd8     0    30      2 0x00000000
> [ 3606.403609]  f4f01d10 00000092 00000000 f4f01cd8 00000246 c1748000
> c183fb40 c183fb40
> [ 3606.411731]  d46b6273 0000031c f53e7b40 f4d323c0 c1748000 00000246
> 00000000 f0820090
> [ 3606.419807]  00000246 f4f01cd8 00000046 00000001 00000046 00000000
> 00000002 f0820090
> [ 3606.427881] Call Trace:
> [ 3606.430518]  [<c1097aeb>] ? trace_hardirqs_on+0xb/0x10
> [ 3606.435907]  [<c1525ff3>] schedule+0x23/0x60
> [ 3606.440402]  [<f8230c65>] wiphy_unregister+0xa5/0x2e0 [cfg80211]

This seems to be because you don't remove the p2p device if it's still
present when you unload the driver. Call cfg80211_unregister_wdev() at
some appropriate place.

johannes

