Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51868 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbZGPKkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 06:40:19 -0400
Received: by fxm18 with SMTP id 18so18104fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 03:40:18 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT 5/5] mac80211: implement basic background scanning
Date: Thu, 16 Jul 2009 12:40:25 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <200907161104.41975.helmut.schaa@gmail.com> <200907161150.54237.helmut.schaa@gmail.com> <1247739394.29762.9.camel@johannes.local>
In-Reply-To: <1247739394.29762.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907161240.25574.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 16. Juli 2009 schrieb Johannes Berg:
> On Thu, 2009-07-16 at 11:50 +0200, Helmut Schaa wrote:
> > Maybe I should use other terms. Ideas?
> 
> Ah, ok. Since your patch 4/5 changes sw_scanning to SW_SCANNING, I think
> at least change it to BG_SCANNING there already. OTOH, I think people
> are used to sw_scanning so it would be better to keep it. Maybe do
> 	SW_SCANNING
> and
> 	SW_SCANNING | OFF_CHANNEL
> 
> or maybe
> 	SW_SCANNING | PROBING
> or something like that?

Yes, something like this sounds better and does not cause so much confusion.

> > > Anyway looks pretty good to me! How does it fare during ping -f or
> > > something?
> > 
> > I compared it to the hw_scan implementation of iwlwifi. We loose a few
> > more frames (I guess due to not flushing the queues before channel switch)
> > but it's not really much, it was <1% for ping -f).
> 
> Yeah, we still need to add a queue flush callback for the hardware, but
> that can wait some more.

Right, that can wait :)

> > I didn't do much performance testing, just a single wget and the performance
> > dropped to about 50%. I still have to run some iperf tests (both RX and TX) to
> > see how it behaves.
> 
> I'd be more interested in the rtt stats that ping -f prints after you
> abort it:
> 
> rtt min/avg/max/mdev = 0.021/0.028/1.726/0.051 ms

I don't have any stats here anymore but if I remember correctly the max rtt I
got was around 250ms. Will try that again when I'm back in the evening.

Helmut
