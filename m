Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33007 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab3CGTJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 14:09:24 -0500
Received: by mail-ea0-f174.google.com with SMTP id j13so315183eaa.5
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 11:09:23 -0800 (PST)
Date: Thu, 7 Mar 2013 20:10:18 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de, johannes@sipsolutions.net,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: Question regarding minstrel(_ht) and retry limits
Message-ID: <20130307191018.GA13138@gobelin> (sfid-20130307_200934_008197_DE62D55C)
References: <20130307153100.GA30608@pandem0nium>
 <20130307154045.GB29428@magnum.frso.rivierawaves.com>
 <20130307181405.GB31210@pandem0nium>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130307181405.GB31210@pandem0nium>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 07, 2013 at 07:14:05PM +0100, Simon Wunderlich wrote:
> On Thu, Mar 07, 2013 at 04:40:45PM +0100, Karl Beldan wrote:
> > On Thu, Mar 07, 2013 at 04:31:00PM +0100, Simon Wunderlich wrote:
> > > Hello list,
> > > 
> > > as you might be aware, it is possible to set short and long retry limits
> > > to specify how often a frame should be retransmitted before getting dropped.
> > > 
> > > However, it appears that minstrel completely ignores any retry limit, and it is
> > > also not applied later in the code path. I've hacked minstrel_ht a little bit
> > > to apply the retry limits in minstrel_get_rate() before returning the rates
> > > (i.e. just cutting retries at the end from the struct ieee80211_tx_rate array).
> > > 
> > > This worked for me, but is probably not clean either and might disturb minstrel
> > > operation. Also minstrel uses much more retries than default retry limits
> > > (short: 7, long: 4), so this patch might introduce behaviour changes.
> > > 
> > > What is your opinion on this? Can we get it properly supported? Does it hurt
> > > to just use the first $retry_limit retries, and cut the rest at other rates
> > > at the end?
> > > 
> > BTW, it also ignores max_rate_tries < 3 and rts thresholds.
> 
> Yup, regarding RTS we had a long discussion some time ago:
> 
>  * http://thread.gmane.org/gmane.linux.kernel.wireless.general/84459
> 
Yes, plus I seem to recall that there's a minstrel paper discussing
protection impact, but I would have found the thread more interesting if
it discussed enforcing protection rather than disabling it at user's
will.

> regarding max_rate_tries, I guess this comes from the hardware? Does it hurt
> to ignore it (as drivers will cut it anyway)?
> 
It comes from the hardware.
Can't really say, but the topic being hot with some rate controls facing
removal and the activity around minstrel it might be interesting to be
aware of this when comparing throughputs and also the drivers ampdu
stats reports which hugely affect minstrel.

 
Karl
