Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37630 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822AbYHCNwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 09:52:34 -0400
Date: Sun, 3 Aug 2008 10:52:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080803135229.GG12118@khazad-dum.debian.net> (sfid-20080803_155249_588099_18A75473)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <1ba2fa240808021421h421fc362ib92660f7be4727f8@mail.gmail.com> <20080803035559.GB6053@khazad-dum.debian.net> <1ba2fa240808022303i4d330023i74f3cbb7e08083eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240808022303i4d330023i74f3cbb7e08083eb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 03 Aug 2008, Tomas Winkler wrote:
> At least from iwlwifi perspective killing radio is not the same
> operation as shutting down the card.

It almost never is.  Which is why I said we should not bother if nobody
needs that.

> The intention is different if nothing it's really redundant operation

On proper drivers that do proper power management? Certainly :-)

> > RFKILL is not about tracking, it is about *controlling*.
> 
>  I think driver controls the radio why need to add another entity for
> that. I don't like this definition, But that's just wording I hope.

All the radio-is-allowed-to-transmit decisions are rfkill's.  The driver is
not allowed to override those.  This is done to present a uniform behaviour
and interface to the system's user (and any instance of rfkill doing
something the user wouldn't expect to the radio is to be considered a major
bug).  rfkill is supposed to represend the will of the system's user
regarding permission to transmit energy out of wireless transmitters.

Not even WoWL is an exception, if your radio is blocked before suspend, you
are not allowed to enable the transmitter [to get WoWL to work -- I sure
hope this is not necessary, but it could be].  I'd expect a printk
complaining about it, though :-)

> I rather remove it, If the driver has D3 operation it should move card
> to operation

Sure.  I was wondering about drivers that *don't* have it, if any, out of
the potential set of drivers that should be using rfkill (it is not a matter
of those who are using rfkill right now).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
