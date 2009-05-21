Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36820 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbZEUTDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 15:03:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 12:03:55 -0700
Date: Thu, 21 May 2009 12:03:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	Joerg Albert <jal2@gmx.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: Re: ath/regd.c: regdomain 0x8000 fails to retrieve a regulatory
	domain pair
Message-ID: <20090521190356.GA32055@tesla>
References: <4A0802B0.9070206@gmx.de> <20090511190602.GC18696@tesla> <618D4DE9D5223A45A46C48063FD640451098774889@TAEXMB-01.global.atheros.com> <20090521171619.GB28691@tesla> <69e28c910905211119l1a0e0e31u914cfd609afd295b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <69e28c910905211119l1a0e0e31u914cfd609afd295b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 11:19:02AM -0700, Gábor Stefanik wrote:
> On Thu, May 21, 2009 at 7:16 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> >> On Mon, May 11, 2009 at 03:49:20AM -0700, Joerg Albert wrote:
> >> > Plugging in a WNDA3100 (ar9170usb) I get the error
> >> >
> >> > ath: No regulatory domain pair found, cannot continue
> >> >
> >> > Seems like the EEPROM of the stick initializes regulatory.current_rd
> >> > to 0x8000, current_rd_ext to 0. Is this a valid setting?
> >> >
> >> > Looked into ath/regd.c, ath_regd_init():
> >> >
> >> > ath_get_regpair(regdmn)
> >> >
> >> > is called with regdmn == 0x8000 and returns NULL.
> >> >
> >> > Shall that regdmn value be dealt with by
> >> >
> >> >          if (reg->country_code == CTRY_DEFAULT &&
> >> >              regdmn == CTRY_DEFAULT)
> >> >                  reg->country_code = CTRY_UNITED_STATES;
> >> > ?
> 
> Why CTRY_UNITED_STATES?

Well, that's just the way the regulatory infrastructure is designed, I suppose
that we inform vendors they can program their EEPROM with with 0x8000 as an
option to use CTRY_UNITED_STATES.

> Is there no CTRY_WORLD?

If (regdm & 0x60) then you have a world regualtory domain. Atheros devices
have 12 world regulatory domains today. They are all built-in to ath.ko.

> Or is 0x8000 US-specific?

That's what I believe.

  Luis
