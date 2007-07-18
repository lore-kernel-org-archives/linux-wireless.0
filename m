Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4227 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbXGRAdK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2007 20:33:10 -0400
Date: Tue, 17 Jul 2007 20:01:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
Message-ID: <20070718000140.GA26907@tuxdriver.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com> <1175111599.5151.123.camel@johannes.berg> <46137FF2.6020203@linux.intel.com> <1182374019.3714.87.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1182374019.3714.87.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2007 at 11:13:39PM +0200, Johannes Berg wrote:
> Mohamed,
> 
> > +		padding = calc_pad_len(subframe_len);
> > +		/* the last MSDU has no padding */
> > +		if (subframe_len > remaining)
> > +			return TXRX_DROP;
> > +
> > +		frame = dev_alloc_skb(local->hw.extra_tx_headroom + 
> > +				      subframe_len);
> > +
> > +		if (frame == NULL) 
> > +			return TXRX_DROP;
> > +
> > +		memcpy(skb_put(frame, subframe_len), (u8*)eth, subframe_len);
> > +		frame->mac.raw = frame->data;
> > +		skb2 = NULL;
> 
> Here you allocate a new frame which can be sent back to the device when
> one of the aggregated frames was a multicast frame and we're an AP
> device. You also correctly add extra_tx_headroom, but it seems that this
> is missing some skb_reserve(extra_tx_headroom), no? Could you make a
> patch adding it? I'm not sure I fully understand the code there.

Was there ever any reply to this?

John
-- 
John W. Linville
linville@tuxdriver.com
