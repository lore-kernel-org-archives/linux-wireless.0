Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hall.aurel32.net ([88.191.38.19]:36294 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbXHBJ4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 05:56:12 -0400
Message-ID: <46B19FFE.2010900@aurel32.net>
Date: Thu, 02 Aug 2007 11:12:30 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] ssb-chipcommon: Add function to get processor clock
References: <200708010011.56753.mb@bu3sch.de> <20070801150611.44c9c47a.akpm@linux-foundation.org> <200708020009.50374.mb@bu3sch.de>
In-Reply-To: <200708020009.50374.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch a =E9crit :
> On Thursday 02 August 2007 00:06:11 Andrew Morton wrote:
>> On Wed, 1 Aug 2007 00:11:56 +0200
>> Michael Buesch <mb@bu3sch.de> wrote:
>>
>>> From: Aurelien Jarno <aurelien@aurel32.net>
>>>
>>> The patch below (against 2.6.23-rc1-mm1) adds a new function to get=
 the=20
>>> processor clock. It originally comes from the OpenWrt patches.
>>>
>>> Cc: Felix Fietkau <nbd@openwrt.org>
>>> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
>>> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>>>
>>> --- a/drivers/ssb/driver_chipcommon.c	2007-07-14 21:05:44.000000000=
 +0200
>>> +++ b/drivers/ssb/driver_chipcommon.c	2007-07-14 21:22:04.000000000=
 +0200
>>> @@ -264,6 +264,30 @@
>>>  	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
>>>  }
>>> =20
>>> +/* Get the processor clock */
>>> +void ssb_chipco_get_clockcpu(struct ssb_chipcommon *cc,
>>> +                             u32 *plltype, u32 *n, u32 *m)
>>> +{
>>> +	*n =3D chipco_read32(cc, SSB_CHIPCO_CLOCK_N);
>>> +	*plltype =3D (cc->capabilities & SSB_CHIPCO_CAP_PLLT);
>>> +	switch (*plltype) {
>>> +		case SSB_PLLTYPE_2:
>>> +		case SSB_PLLTYPE_4:
>>> +		case SSB_PLLTYPE_6:
>>> +		case SSB_PLLTYPE_7:
>>> +			*m =3D chipco_read32(cc, SSB_CHIPCO_CLOCK_MIPS);
>>> +			break;
>>> +		case SSB_PLLTYPE_3:
>>> +			/* 5350 uses m2 to control mips */
>>> +			*m =3D chipco_read32(cc, SSB_CHIPCO_CLOCK_M2);
>>> +			break;
>>> +		default:
>>> +			*m =3D chipco_read32(cc, SSB_CHIPCO_CLOCK_SB);
>>> +			break;
>>> +	}
>>> +}
>> Please indent the body of switch statements one tabstop less than th=
is.
>=20
> Ok, please resend, Aurelien :)

It looks like Andrew took care of that.

>>> +/* Get the bus clock */
>>>  void ssb_chipco_get_clockcontrol(struct ssb_chipcommon *cc,
>>>  				 u32 *plltype, u32 *n, u32 *m)
>>>  {
>>> --- a/include/linux/ssb/ssb_driver_chipcommon.h	2007-07-14 21:05:44=
=2E000000000 +0200
>>> +++ b/include/linux/ssb/ssb_driver_chipcommon.h	2007-07-14 21:17:28=
=2E000000000 +0200
>>> @@ -364,6 +364,8 @@
>>>  extern void ssb_chipco_suspend(struct ssb_chipcommon *cc, pm_messa=
ge_t state);
>>>  extern void ssb_chipco_resume(struct ssb_chipcommon *cc);
>>> =20
>>> +extern void ssb_chipco_get_clockcpu(struct ssb_chipcommon *cc,
>>> +                                    u32 *plltype, u32 *n, u32 *m);
>> But it has no callers?
>>
>>
>=20
> The callers are in the bcm47xx arch code. We are going to merge
> that, too. This patch is part of the merge.
> We can't (and shouldn't) merge it all at once.
> There are still a few dirty hacks in there that won't get accepted, y=
et.

Yep the merge of the bcm47xx is on my TODO list, but I want to finish
the SSB parts first. I hope to finish that before the end of this week-=
end.

About the bcm47xx arch code, my plan is to merge first a very simple
version that allow the machine to boot, but without support for CFE.

--=20
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
