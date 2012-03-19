Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab2CSIYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 04:24:33 -0400
Subject: Re: mac80211 20/40 coexist
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	"Manoharan, Sujith" <c_manoha@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJ-VmomNGku0CNfX+feeeUET4mXEFDj976sSfg-GG-KUSGCWvw@mail.gmail.com> (sfid-20120318_201943_672959_05F441F9)
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	 <1331902885.6753.10.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	 <1332065984.3609.5.camel@jlt3.sipsolutions.net>
	 <CAJ-VmomNGku0CNfX+feeeUET4mXEFDj976sSfg-GG-KUSGCWvw@mail.gmail.com>
	 (sfid-20120318_201943_672959_05F441F9)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 09:24:28 +0100
Message-ID: <1332145468.3359.3.camel@jlt3.sipsolutions.net> (sfid-20120319_092441_584875_91FFBDCE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-03-18 at 12:19 -0700, Adrian Chadd wrote:
> On 18 March 2012 03:19, Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > I'm not sure I can believe this -- surely the firmware has to have a way
> > of dealing with stations that can't do 40 MHz and stations that can, so
> > switching between the two doesn't seem like a major proposal? We also
> > don't currently handle the action frames for that, but it seems like we
> > should.
> >
> > Note, however, that we're now discussing something already done --
> > Paul's patch already removed the channel type update when all we wanted
> > was update the RC.
> 
> When are stations being notified of a CWM change?



> I know FreeBSD handles it with a big stick at the moment - it just
> does a full interface reset and channel change. I don't necessarily
> like it, but I haven't yet sat down to look at when and why this is
> occuring.

I'm not convinced this is the right thing to do -- we kinda do/did the
same thing but we want to change TX bandwidth for the AP peer, not RX
(channel) bandwidth.

johannes

