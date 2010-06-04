Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:18808 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0FDKdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 06:33:10 -0400
Received: by fg-out-1718.google.com with SMTP id l26so86498fgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 03:33:08 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2800, minstrel_ht & mac80211
Date: Fri, 4 Jun 2010 12:32:53 +0200
Cc: Felix Fietkau <nbd@openwrt.org>, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
References: <201006041222.49820.helmut.schaa@googlemail.com> <1275647301.9953.20.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275647301.9953.20.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006041232.53326.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag 04 Juni 2010 schrieb Johannes Berg:
> On Fri, 2010-06-04 at 12:22 +0200, Helmut Schaa wrote:
> 
> > This meant that minstrel most of the time selected MCS15 as tx rate which
> > resulted in a huge number of retries and thus a very slow throughput.
> > 
> > status.c:
> > 
> > 178                 /* the HW cannot have attempted that rate */
> > 179                 if (i >= hw->max_rates) {
> > 180                         info->status.rates[i].idx = -1;
> > 181                         info->status.rates[i].count = 0;
> > 
> > Johannes, is there a valid reason for this check in status.c. Can we remove
> > it without breaking anything else?
> 
> IIRC there were/are some drivers that were not terminating the rates[]
> array correctly with a -1, thus this code.

Understood, so it's a driver workaround ;)

Maybe we should check which driver doesn't set it and fix these?

> > What other options would we have to fix this issue? Just use max_rates = 4 
> > in rt2800 even if we will only use the first rate provided by minstrel and
> > then fall back to the global fallback setup (I tried that already and it
> > works just fine but seems not correct to me)?
> 
> p54 kinda does some trickery in this area too, not really sure what to
> do though.

Thanks for the pointer, p54 just sets max_rates=4 even if it cannot support
it.

So, if you would like to keep the check I'll just use max_rates=4 in rt2800.

Helmut
