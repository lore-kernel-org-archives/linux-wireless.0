Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53591 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbYHDCwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 22:52:50 -0400
Date: Sun, 3 Aug 2008 23:52:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080804025245.GD23180@khazad-dum.debian.net> (sfid-20080804_045254_231947_8C006961)
References: <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <1ba2fa240808021421h421fc362ib92660f7be4727f8@mail.gmail.com> <20080803035559.GB6053@khazad-dum.debian.net> <1ba2fa240808022303i4d330023i74f3cbb7e08083eb@mail.gmail.com> <20080803135229.GG12118@khazad-dum.debian.net> <1ba2fa240808030849g3110cfefo3de65d3ae3000273@mail.gmail.com> <20080803182521.GA23180@khazad-dum.debian.net> <1ba2fa240808031536n3c2d6171l191d5ec1c9321c7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240808031536n3c2d6171l191d5ec1c9321c7c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 04 Aug 2008, Tomas Winkler wrote:
> > Err, no.  If it involves energy emission, if rfkill forbade it [which is to
> > be taken as the user forbade it], the driver must not, EVER, cause it to
> > happen.  There are no exceptions.
> 
> I didn't mean those kind of events :)  iwlwifi driver has proper FCC
> certification.

One thing has nothing to do with the other :)  transmitter blocked == energy
emission forbidden.  I say it like that so that people don't think it is
okay to just block data transmission and leave a carrier still being
transmitted, or whatever.

Remember, rfkill is *generic*, it goes well beyond WiFi.

> >> > Sure.  I was wondering about drivers that *don't* have it, if any, out of
> >> > the potential set of drivers that should be using rfkill (it is not a matter
> >> > of those who are using rfkill right now).
> >>
> >> I think we are aligned in general.
> >
> > I may still have it as optional, but I will switch the default behaviour
> > around.  It will likely be useful for someone, and it is less than 10 LOC.
> 
> I make an effort to remove  it's a mess.

Mess? How so?

Anyway, I have been looking at everything that includes linux/rfkill.h.  I
cannot trust every current in-tree user of rfkill to be shutting down the
devices on suspend by just a quick look at their drivers,  I just don't know
enough about drivers/net/usb/hso or arm/mach-pxa/tosa.  I can't even be sure
about rt2xxx USB by just looking at the code...

So I will ask their maintainers first, instead of trying to guess.  Lets see
what answers I get.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
