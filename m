Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34018 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604Ab0JYOaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 10:30:11 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PAO3o-0006ZF-K5
	for linux-wireless@vger.kernel.org; Mon, 25 Oct 2010 16:30:06 +0200
Received: from itav173.av.it.pt ([193.136.93.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 16:30:04 +0200
Received: from ric.vmoreira+gmaneorg by itav173.av.it.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 16:30:04 +0200
To: linux-wireless@vger.kernel.org
From: Ricardo <ric.vmoreira+gmaneorg@gmail.com>
Subject: Re: Complexity of Adding 5/10 MHz Channel Support
Date: Mon, 25 Oct 2010 14:27:06 +0000 (UTC)
Message-ID: <loom.20101025T162119-425@post.gmane.org>
References: <1A7DEBB8-6337-4551-9F21-14C20E13B86B@zinkconsulting.com> <1287996379.3587.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:

> 
> On Fri, 2010-10-15 at 15:30 -0700, Galen wrote:
> > Can anybody give me an idea the extent and complexity of adding
> > support for 5/10 MHz channels in mac80211?
> > 
> > Several different radios (including those supported by ath5k and
> > ath9k) have the hardware capability to operate at 5 MHz. Obviously,
> > support in those drivers is a separate issue, but it is my
> > understanding that mac80211 must first support 5/10 MHz channels.
> 
> Since we already have channel types, I've always suggested to add 5/10
> as such. The complexity comes from the fact that some channel types are
> incompatible, and we currently do not have to handle that -- a regular
> scan for example will cover all current channel types, but with 5/10 MHz
> you need to do special scans etc.
> 
> Also, you need to start in cfg80211, not mac80211, and make everything
> from auth/assoc/connect/ibss-join etc. aware of channel types as well as
> center freq.
> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Hello,

I am also interested in seeing/having this functionality implemented in ath5k. I 
am not an expert or have a big knowledge of the driver itself but it would be 
great to be able to change the channel width (even if it was a "dirty" solution, 
like manually hardcode some register values to achieve the desired channel 
widths).

Maybe someone has any useful tips for me? I can do the "dirty work" but i just 
need some indications on HOW to do it.

Best regards
Ricardo



