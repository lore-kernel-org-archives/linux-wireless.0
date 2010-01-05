Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56683 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab0AEXLX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 18:11:23 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 15:11:23 -0800
Date: Tue, 5 Jan 2010 15:11:21 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"joshuacov@googlemail.com" <joshuacov@googlemail.com>,
	"stephenbeahm@comcast.net" <stephenbeahm@comcast.net>,
	"stable@kernel.org" <stable@kernel.org>,
	David Quan <David.Quan@Atheros.com>
Subject: Re: [PATCH] ath5k: Fix eeprom checksum check for custom sized
 eeproms
Message-ID: <20100105231121.GG2086@tux>
References: <1262619639-21426-1-git-send-email-lrodriguez@atheros.com>
 <40f31dec1001041009r87f677l9c777535c1a057f@mail.gmail.com>
 <43e72e891001041015h6026607bp34d6cb3440f7aae5@mail.gmail.com>
 <40f31dec1001051506j2648a4ccp4871b6855e1c417@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <40f31dec1001051506j2648a4ccp4871b6855e1c417@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2010 at 03:06:11PM -0800, Nick Kossifidis wrote:
> 2010/1/4 Luis R. Rodriguez <lrodriguez@atheros.com>:
> > On Mon, Jan 4, 2010 at 10:09 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> >> 2010/1/4 Luis R. Rodriguez <lrodriguez@atheros.com>:
> >>>
> >>> +
> >>> +/* FLASH(EEPROM) Defines for AR531X chips */
> >>> +#define AR5K_EEPROM_SIZE_LOWER         0x1b /* size info -- lower */
> >>> +#define AR5K_EEPROM_SIZE_UPPER         0x1c /* size info -- upper */
> >>> +#define AR5K_EEPROM_SIZE_UPPER_MASK    0xfff0
> >>> +#define AR5K_EEPROM_SIZE_UPPER_SHIFT   4
> >>> +#define AR5K_EEPROM_SIZE_ENDLOC_SHIFT  12
> >>> +
> >>
> >> AR531X chips are SoCs, are you sure this comment is correct ?
> >
> > I got that from the legacy HAL, so just using that as a source of
> > documentation for this.
> >
> >> In the docs this marks the end of EAR section (and the end of
> >> checksum) for EEPROMs larger than 16k
> >> valid values for checksum end are 0x00000C0 to 0x0080000
> >
> > I didn't see this used, just replicating what I saw in the legacy HAL
> > to match the code on Linux with what we have on other operating
> > systems. Not sure about the valid values for the checksum as per
> > documentation Vs what is implemented, I am just following what I see
> > implemented to ensure consistency.
> >
> >> Also to calculate EEPROM size (stored on the first 4 bits of 0x1c) you
> >> do this according to the docs
> >> 2 ^ (EEPROM size + 9) and valid values are from 1 to 11 (11 = 1MB)
> >
> > OK thanks so the eep_max should not be > 11 ?
> >
> 
> I guess
> 
> eep_max > (3 * AR5K_EEPROM_INFO_MAX)
> 
> should be
> 
> eep_max > 1024

; 0x400 - 0x00c0
	0x340
0x340 = 832

Whatever that means not sure. Have been lazy to read the EEPROM docs.
Anyway once we are certain of a value it can be updated. For now this
fixed some user issues, the main goal of the limit check was to prevent
out of range access to some bogus registers or doing an infinite loop
when a busted EEPROM was detected. This was already merged, once we
get the right value we can update this.

  Luis
