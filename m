Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41300 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756956AbYHCSZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 14:25:28 -0400
Date: Sun, 3 Aug 2008 15:25:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080803182521.GA23180@khazad-dum.debian.net> (sfid-20080803_202551_049076_256AD75F)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <1ba2fa240808021421h421fc362ib92660f7be4727f8@mail.gmail.com> <20080803035559.GB6053@khazad-dum.debian.net> <1ba2fa240808022303i4d330023i74f3cbb7e08083eb@mail.gmail.com> <20080803135229.GG12118@khazad-dum.debian.net> <1ba2fa240808030849g3110cfefo3de65d3ae3000273@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240808030849g3110cfefo3de65d3ae3000273@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 03 Aug 2008, Tomas Winkler wrote:
> > All the radio-is-allowed-to-transmit decisions are rfkill's.  The driver is
> > not allowed to override those.  This is done to present a uniform behaviour
> > and interface to the system's user (and any instance of rfkill doing
> > something the user wouldn't expect to the radio is to be considered a major
> > bug).  rfkill is supposed to represend the will of the system's user
> > regarding permission to transmit energy out of wireless transmitters.
> 
> May point is that there are radio event out of scope rfkill so the
> driver although obey rfkill system

Err, no.  If it involves energy emission, if rfkill forbade it [which is to
be taken as the user forbade it], the driver must not, EVER, cause it to
happen.  There are no exceptions.

This is a safety thing, not a convenience thing.

> > Sure.  I was wondering about drivers that *don't* have it, if any, out of
> > the potential set of drivers that should be using rfkill (it is not a matter
> > of those who are using rfkill right now).
> 
> I think we are aligned in general.

I may still have it as optional, but I will switch the default behaviour
around.  It will likely be useful for someone, and it is less than 10 LOC.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
