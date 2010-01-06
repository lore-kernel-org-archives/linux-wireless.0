Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox1.netikka.net ([213.250.81.202]:43990 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab0AFVtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 16:49:42 -0500
Message-ID: <4B450004.9050601@mandriva.org>
Date: Wed, 06 Jan 2010 23:26:28 +0200
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
References: <1262710858.28653.5.camel@johannes.local>
In-Reply-To: <1262710858.28653.5.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05.01.2010 19:00, Johannes Berg 
wrote:<johannes-<johannes-<johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>cdvu00un1VgdHxzADdlk8Q@public.gmane.org>cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
> Since I removed the master netdev, we've been
> keeping internal queues only, and even before
> that we never told the networking stack above
> the virtual interfaces about congestion. This
> means that packets are queued in mac80211 and
> the upper layers never know, possibly leading
> to memory exhaustion and other problems.
>
> This patch makes all interfaces multiqueue and
> uses ndo_select_queue to put the packets into
> queues per AC. Additionally, when the driver
> stops a queue, we now stop all corresponding
> queues for the virtual interfaces as well.
>
> The injection case will use VO by default for
> non-data frames, and BE for data frames, but
> downgrade any data frames according to ACM. It
> needs to be fleshed out in the future to allow
> chosing the queue/AC in radiotap.
>
> Reported-by: Lennert Buytenhek<buytenh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Johannes Berg<johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org [2.6.32]
> ---
> I know it's late, and large, but still would be good to have in .33
> since the issue is fairly serious.
>
>   net/mac80211/iface.c |   39 +++++++++++++++++++-
>   net/mac80211/rx.c    |    4 +-
>   net/mac80211/tx.c    |    5 ++
>   net/mac80211/util.c  |   12 ++++++
>   net/mac80211/wme.c   |   96 +++++++++++++++++++++++++++++++++++++--------------
>   net/mac80211/wme.h   |    8 +++-
>   6 files changed, 132 insertions(+), 32 deletions(-)
>

With this patch applied to 2.6.33-rc3 kernel crashes at boot...

I have a iwl4965 connecting to a wpa2-psk encrypted network, arch is 
x86_64, distro Mandriva Linux and the kernel has preempt enabled.

Am I only missing some patches, or did I hit a real bug ?

--
Thomas
