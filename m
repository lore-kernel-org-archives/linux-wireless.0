Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37903 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1BQDb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 22:31:29 -0500
Message-ID: <4D5C9679.3060700@candelatech.com>
Date: Wed, 16 Feb 2011 19:31:05 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, bloat-devel@lists.bufferbloat.net,
	"Nathaniel J. Smith" <njs@pobox.com>
Subject: Re: [RFC] mac80211: implement eBDP algorithm to fight bufferbloat
References: <1297619803-2832-1-git-send-email-njs@pobox.com> <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/16/2011 05:49 PM, John W. Linville wrote:
> This is an implementation of the eBDP algorithm as documented in
> Section IV of "Buffer Sizing for 802.11 Based Networks" by Tianji Li,
> et al.
>
> 	http://www.hamilton.ie/tianji_li/buffersizing.pdf
>
> This implementation timestamps an skb before handing it to the hardware
> driver, then computes the service time when the transmit status is
> reported back from the driver.  An exponentially weighted moving
> average of per packet service times is used to restrict queueing
> delays in hopes of achieving a target packet transmission latency.
>
> Signed-off-by: John W. Linville<linville@tuxdriver.com>
> ---
> This is preliminary, but it seems to put some limits on latencies
> for me.  I haven't even really done much testing, so YMMV...
>
> I'm sure this isn't ideal.  This should be combined with the ALT
> algorithm to yield the A* algorithm.  There are parameters that
> probably should be tunable (or at least better researched).  This may
> not be ideal for 802.11n -- it may even be detrimental to it.
>
> Still, it is an attempt at addressing buffer bloat.  Plus, it should
> pertain to all mac80211-based drivers.  So, feel free to test it,
> suggest different parameters, report real numbers, post patches,
> etc... :-)

> +		/* test for queue admission qualifications */
> +		tserv_ns_avg = ewma_read(&sdata->tserv_ns_avg);
> +		/* constants 2 msec and offset 5 should be tunable? */
> +		max_enqueued = 2 * NSEC_PER_MSEC / tserv_ns_avg + 5;
> +		if (atomic_read(&sdata->enqueued)>  max_enqueued) {
> +			/* silently drop */
> +			dev_kfree_skb(skb);
> +			return IEEE80211_TX_OK;
> +		}

We should have some visible stat to increment when you drop on xmit,
  tx-fifo error or similar?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
