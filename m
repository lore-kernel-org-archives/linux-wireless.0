Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39303
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXBFO4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 09:56:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Date: Tue, 6 Feb 2007 15:55:45 +0100
Cc: linux-wireless@vger.kernel.org
References: <200702041344.19117.mb@bu3sch.de> <20070205214333.4e77948e@griffin.suse.cz>
In-Reply-To: <20070205214333.4e77948e@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702061555.45532.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 February 2007 21:43, Jiri Benc wrote:
> On Sun, 4 Feb 2007 13:44:18 +0100, Michael Buesch wrote:
> > We need the phase1 for bcm43xx. We need to upload it to
> > card memory and we need to pass it on every TX on the DMA.
> > 
> > So, currently we receive the phase1 key on the first
> > encrypted TX. That's too late, as we already receive encrypted
> > packets before that. bcm43xx needs the phase1 key (and the iv32)
> > on RX. It uses the one uploaded into the card memory. But it
> > is not uploaded, yet, as we did not TX any encrypted packet.
> > 
> > I'd say the only solution to this is to implement the earlier
> > suggested way of having a library function call to generate
> > the keys. Of course, that needs some bookkeeping about the IVs
> > and stuff.
> > That library function would be called by bcm43xx before any
> > traffic to get an initial phase1 key (and iv32) uploaded.
> 
> What if the key is changed by the user space? You won't know that and
> won't call the library function then. I think it needs to be designed
> in the opposite way - the stack will call a driver's callback.
> 
> Or am I missing something?

Yeah, peobably. I don't really know in detail how
tkip works. I just know that current implementation in
d80211 does not work, as I tried it. ;)

I need to read the specs about it first.

-- 
Greetings Michael.
