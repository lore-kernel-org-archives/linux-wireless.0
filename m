Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.225]:52766 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbYISQ2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 12:28:02 -0400
Received: by qb-out-0506.google.com with SMTP id f11so423035qba.17
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 09:28:00 -0700 (PDT)
Date: Fri, 19 Sep 2008 09:27:48 -0700 (PDT)
From: Steven Noonan <steven@uplinklabs.net>
To: Robert Hancock <hancockr@shaw.ca>
cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Ingo Molnar <mingo@elte.hu>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5,
 rc6, probably others)
In-Reply-To: <48D3BB5B.7060003@shaw.ca>
Message-ID: <alpine.LNX.2.00.0809190925250.22158@alcarin.uplinklabs.net> (sfid-20080919_182821_447858_B64ECD6C)
References: <fa.jQQm4Iwb0lkAWxV+5FAfTMHY4m4@ifi.uio.no> <fa.zGA6t2p+jJeMRIaZFOqy1I8En1c@ifi.uio.no> <fa.AGi3s2gpyC3T3KuCJ8cYQ30teak@ifi.uio.no> <fa.59AlSLNBuMx/BjQSvR6whwGydbU@ifi.uio.no> <fa.NwYDTAB59VZjr1quzgR4OU0+8eQ@ifi.uio.no> <fa.tRre/FoeQKwChGwdusnYJgwjRmw@ifi.uio.no>
 <48D3BB5B.7060003@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 19 Sep 2008, Robert Hancock wrote:

> Steven Noonan wrote:
> > Second of all, I'm looking at the ath9k interrupt handler right now,
> > and there are a few cases where it returns IRQ_NONE. And here's where
> > I'm a bit fuzzy. Since there could be any number of things using IRQ
> > 17 (though in my case, ath9k is on its own dedicated IRQ), it seems
> > odd that you check the value of sc->sc_invalid, since the cookie
> > passed to the handler might not actually be ath9k's cookie if multiple
> > drivers have registered IRQ handlers for that particular IRQ. Who
> > knows if what you're reading is even valid? Heck, what if some driver
> > uses a NULL for their cookie (however unlikely)? You'd get a
> > segmentation fault on the second line of the interrupt handler. Of
> > course, I could be completely wrong: does parent interrupt handler
> > check to see which device driver owns the particular device signaling
> > an IRQ and then call the appropriate handler?
> 
> All the IRQ handlers registered on that interrupt will get called. The cookie
> will always be the right one for that handler however.

Thank you! I appreciate the explanation.

> The bug is presumably that it returns IRQ_NONE in some cases where the device
> is actually generating an interrupt. The advice to turn on irqpoll is rather
> useless in this case - that's mainly useful where the IRQ routing is messed up
> and the device can't receive any interrupts at all.

Strange, though, that irqpoll solved the connectivity issues (but of 
course created the ridiculous latency that this thread's all about).

