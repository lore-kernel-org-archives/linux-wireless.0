Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42152 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZEKTFv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 15:05:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 12:05:53 -0700
Date: Mon, 11 May 2009 12:06:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Joerg Albert <jal2@gmx.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<Stephen.Chen@atheros.com>
Subject: Re: ath/regd.c: regdomain 0x8000 fails to retrieve a regulatory
	domain pair
Message-ID: <20090511190602.GC18696@tesla>
References: <4A0802B0.9070206@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A0802B0.9070206@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 03:49:20AM -0700, Joerg Albert wrote:
> Plugging in a WNDA3100 (ar9170usb) I get the error
> 
> ath: No regulatory domain pair found, cannot continue
> 
> Seems like the EEPROM of the stick initializes regulatory.current_rd
> to 0x8000, current_rd_ext to 0. Is this a valid setting?
> 
> Looked into ath/regd.c, ath_regd_init():
> 
> ath_get_regpair(regdmn)
> 
> is called with regdmn == 0x8000 and returns NULL.
> 
> Shall that regdmn value be dealt with by
> 
>          if (reg->country_code == CTRY_DEFAULT &&
>              regdmn == CTRY_DEFAULT)
>                  reg->country_code = CTRY_UNITED_STATES;
> ?
> 
> wireless-testing is git v2.6.30-rc4-22735-gbd48c47, I run
> compat-wireless with a 2.6.29.2 kernel.

Thanks for reporting this.

Stephen do ar9170 cards get sold with a regulatory domain set to 0x8000?
If so we need to deal with this in the common ath.ko module and set the regulatory
domain as intended.

If we are not sure we can simply default to one of the world regulatory domains for
this specific case, 0x64, for example.

Thanks,

  Luis
