Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0E2GRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 May 2010 02:17:51 -0400
Subject: Re: paged RX skbs and BlockAck Request packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <9F6635B9-D6BE-4C6A-AA12-37662043B70E@cs.washington.edu>
References: <7994C719-E1C8-4818-A03E-0566E8380CC3@cs.washington.edu>
	 <1275078893.3909.117.camel@jlt3.sipsolutions.net>
	 <9F6635B9-D6BE-4C6A-AA12-37662043B70E@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 08:17:40 +0200
Message-ID: <1275113860.3640.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 14:38 -0700, Daniel Halperin wrote:
> On May 28, 2010, at 1:34 PM, Johannes Berg wrote:
> > One thing I ask myself though is do we ever check that the frame is long
> > enough? In the patch below I will by checking the skb_copy_bits() return
> > value, but without that we don't, as far as I can tell?
> 
> Good point.

> > +		if (skb_copy_bits(skb, offsetof(struct ieee80211_bar, control),
> > +				  &bar_data, sizeof(bar_data)))
> > +			return RX_DROP_MONITOR;
> > +
> > 		if (!rx->sta)
> > 			return RX_DROP_MONITOR;
> 
> Maybe invert the order of these two exit conditions? Figure most CPUs
> will speculate anyway, but the second check seems a more efficient
> short-circuit.

Yeah, true. I think it probably makes more sense to just linearize
control frames like you did, and separately add a length check.

johannes

