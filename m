Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52723 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752AbYGASl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 14:41:29 -0400
Date: Tue, 1 Jul 2008 15:41:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Message-ID: <20080701184124.GE24605@khazad-dum.debian.net> (sfid-20080701_204141_375824_37C9768E)
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com> <200807011227.15805.mb@bu3sch.de> <20080701143439.GA6962@khazad-dum.debian.net> <1214923097.3462.0.camel@johannes.berg> <20080701165036.GB6962@khazad-dum.debian.net> <1214931676.3462.5.camel@johannes.berg> <20080701173345.GA24605@khazad-dum.debian.net> <1214935291.3462.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214935291.3462.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 01 Jul 2008, Johannes Berg wrote:
> > THIS is very interesting alright...  and it is *extremely* important, so
> > let's triple verify it, shall we?
> > 
> > Please hack the driver to try to transmit data with that bit set to high, and
> > also with that bit set to low.  The best way to go about it is probably to
> > disable the rfkill support (so that it doesn't get in the way), hack the
> > check-the-bit function to just printk its state, and see if the radio can
> > effectively transmit and communicate no matter what state the input pin is
> > at.
> > 
> > This is very important.  It will caracterize that input pin as either an
> > hardware rfkill line, or as an input device (in which case I would be wrong
> > when I asked to remove the input support from b43, but one step at a time).
> 
> Sorry, no, I think I got confused, it should be a hardware rfkill line.

I'd like to have a certain response for this.  Can you test, and assert
whether it is a rfkill line or not?

And, if it IS a rfkill line, I still need to know if it is flip-flop-like or
not...  I am not certain I got the right idea (I understood it was NOT
flip-flop-like).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
