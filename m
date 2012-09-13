Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42703 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab2IMQ7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 12:59:15 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so4250213pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2012 09:59:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120913165124.GA13877@pandem0nium>
References: <20120813165340.GA10044@pandem0nium>
	<CAD2nsn1=q_YCXjQOLyc+KeG6Bji=7b_VHN4PDA7poXk5Kkdi6Q@mail.gmail.com>
	<CAJ-VmonwheNtv8xfEJnWpD-XOmSEebMFJAmQmWUfe2Pd3tMnqA@mail.gmail.com>
	<168362233.PzT7LJrFi2@bentobox>
	<20120913165124.GA13877@pandem0nium>
Date: Thu, 13 Sep 2012 09:59:15 -0700
Message-ID: <CAJ-VmonC5rh7uQ+PAkZ8pbx2WBo_osOMvAUZL_Lj6Fm=NyOEXg@mail.gmail.com> (sfid-20120913_185919_741104_514971EC)
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
From: Adrian Chadd <adrian.chadd@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Sven Eckelmann <sven@narfation.org>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>,
	Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It'll only go into that mode if that core is off for some reason.

So sure, do that and try to turn the radio off/on :-)



adrian


On 13 September 2012 09:51, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> ath9k fellows,
>
> as it seems no one could find the cause for this problem so far. I'd therefore
> like to create a workaround by checking one/some registers for 0xdeadbeef and
> reset the chip if this is found.
>
> Can anyone recommend a register which should never go 0xdeadbeef in a normal case?
>
> From what i've seen, AR_CFG (0x0014) might be a good choice. My regdumps say:
>
> bad regdump:  0x000014 0xdeadbeef
> good regdump: 0x000014 0x0008010a
>
> Unfortunately I don't have documentation to find out if this register can ever
> go deadbeef in a normal case. :)
>
> What do you think? (of course, a proper solution is still appreciated ...)
>
> Cheers,
>         Simon
>
>
> On Wed, Sep 05, 2012 at 04:20:52PM +0200, Sven Eckelmann wrote:
>> On Wednesday 05 September 2012 07:08:47 Adrian Chadd wrote:
>> > I don't think it's a stuck beacon WAR issue here; 0xdeadbeef really
>> > does read like the MAC has gone to sleep.
>> >
>> > Where's the complete register dump hiding?
>>
>> It was not sent to the public mailing lists due to the size. You will receive
>> the dump mentioned in the first mail in some minutes.
>>
>> Kind regards,
>>       Sven
>
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAlBSDwwACgkQrzg/fFk7axaCLQCg27g4pk6seTqcix0RFoeoglZm
> +fkAoJnqhGv77388XjzRPdhSM/V3yNYl
> =BYI7
> -----END PGP SIGNATURE-----
>
