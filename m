Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:36208 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570Ab1F2Ud4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 16:33:56 -0400
Subject: Re: [PATCH] net, wireless: Don't return uninitialized in
 __cfg80211_stop_sched_scan()
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1309379244.4071.7.camel@jlt3.sipsolutions.net>
References: <alpine.LNX.2.00.1106292212110.3747@swampdragon.chaosbits.net>
	 <1309379244.4071.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 23:33:50 +0300
Message-ID: <1309379630.1514.122.camel@cumari> (sfid-20110629_223359_850939_C19A332F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-29 at 22:27 +0200, Johannes Berg wrote: 
> On Wed, 2011-06-29 at 22:13 +0200, Jesper Juhl wrote:
> > If the 'driver_initiated' function argument to
> > __cfg80211_stop_sched_scan() is not 0 then we'll return an
> > uninitialized 'ret' from the function.
> 
> 'err'. I also dislike the initialisation, can we just replace the
> "return err;" at the end of the function with "return 0;" instead?

Luckily we were never using the return value when passing
driver_initiate =- false.

And I agree with you, there's no use to return err at the end.  Better
to simply return 0.


> Luca, should it maybe be return -ENOENT anyway in the !sched_scan_req
> case?

We could do that.  I had just thought that stopping a scan that is not
running would just be a NOP, but if you prefer to return an error in
that case, I can do it.

-- 
Cheers,
Luca.

