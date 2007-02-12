Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41722
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965424AbXBLVju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 16:39:50 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Date: Mon, 12 Feb 2007 22:39:31 +0100
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <200702041344.19117.mb@bu3sch.de> <20070212183020.GA16597@instant802.com>
In-Reply-To: <20070212183020.GA16597@instant802.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702122239.31778.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 February 2007 19:30, Jouni Malinen wrote:
> On Sun, Feb 04, 2007 at 01:44:18PM +0100, Michael Buesch wrote:
> 
> > We need the phase1 for bcm43xx. We need to upload it to
> > card memory and we need to pass it on every TX on the DMA.
> 
> > So, currently we receive the phase1 key on the first
> > encrypted TX. That's too late, as we already receive encrypted
> > packets before that. bcm43xx needs the phase1 key (and the iv32)
> > on RX. It uses the one uploaded into the card memory. But it
> > is not uploaded, yet, as we did not TX any encrypted packet.
> 
> How exactly is this supposed to work for RX?

I misunderstood it, so my explaination was not 100% correct.

It works the following way: We need the phase1 for TX and for RX.
The key for TX is passed along with the TX frame. We can take the
key from the tx_control (I'd still like to get rid of the
array in the tx_control, though. Working on it...)
For RX we have the phase1 uploaded to some device memory.

What happens on RX when the iv32 wraps. Well, it simply won't decrypt
the frame. What we must do then is upload a new key as fast as possible.
The undecrypted frame can be either decrypted in SW (which I think d80211
can do. At least with minor additional changes), or we drop it.

I started to implement an API to calculate the phase1 key on demand.
It doesn't quite work, yet and I'm stuck in more important work
that should be done before the d80211 merge, so it will take some time
until I can continue debugging the stuff.

-- 
Greetings Michael.
