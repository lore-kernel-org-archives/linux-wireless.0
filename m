Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2C0PA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 11:00:29 -0400
Message-ID: <1332860425.3501.3.camel@jlt3.sipsolutions.net> (sfid-20120327_170032_789078_FC83C216)
Subject: Re: [RFC 00/12] multi-channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 27 Mar 2012 17:00:25 +0200
In-Reply-To: <4F71D17F.6090405@tieto.com>
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>
				 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>
			 <4F6C82A5.5080302@tieto.com>
		 (sfid-20120323_150333_004349_1A5648D7) <1332514895.10384.40.camel@jlt3.sipsolutions.net>
		 <4F706122.6080107@tieto.com>
	 <1332767991.5435.34.camel@jlt3.sipsolutions.net>
	 <4F71D17F.6090405@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-27 at 16:41 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > Ok, so ... I think we're getting to the bottom of our misunderstanding&
> > confusion. I've completely ignored scan/off-channel in this because I
> > don't have to handle it in software, our device handles it itself. It
> > seems from this that you do need it handled in software.
> 
> No, not really. I was just worried as to not break things and maybe 
> improve them as a bonus.

Ah, ok. I agree we should be careful to not break things, but I don't
think we should do more than we have to. In particular, I think adding
multi-channel software implementation is too much :-)


> > Now let's go back to the question of off-channel/scan -- this seems to
> > be the fundamental difference in how we look at things. First, the same
> > thing applies here. SW scanning in mac80211 right now is very
> > inefficient when you try to do background scanning, since it doesn't
> > synchronise with beacons etc. With multiple virtual interfaces, this
> > will only get worse. With multiple channels, probably more so.
> >
> > Then also I'm in a bit of a luxurious position -- our device implements
> > scanning and off-channel all by itself. For this reason, but also
> > because of the timing, I've always wanted to ignore off-channel and
> > scanning in the multi-channel code as much as possible.
> >
> > Your proposal to add temporary channel contexts might be feasible, but I
> > wonder how complex it would become and how much of it can really be
> > shared? I expect that ath9k will implement multi-channel completely in
> > software, and any scheduler there would probably also roll in
> > scanning/off-channel. (Not that I know, I don't work for QCA :) )
> 
> It would be nice if someone from Atheros camp could give us a hint on that.

Yeah, though I'm not sure I care at this stage? I'm sure when (if?) they
implement this they can come up with a proposal, and if it ends up being
useful for somebody else at some point then they can work together to
design the code to handle it all.


> > Would that seem okay to you? I'd rather leave this complexity out of
> > mac80211, not just for complexity reasons but also to make the API have
> > easier semantics.
> 
> I get the general idea but I can't imagine any detailed examples. I'm 
> yet to fully understand mac80211 and other drivers/devices.

Ok. Basically I'm punting software-off-channel/-scan in multi-channel
context -- is that something you could work with for your device? Does
your device have hw-scan/hw-off-channel?


johannes

