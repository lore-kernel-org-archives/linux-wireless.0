Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53233 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3EJJMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 05:12:03 -0400
Received: by mail-wi0-f172.google.com with SMTP id hm14so391278wib.17
        for <linux-wireless@vger.kernel.org>; Fri, 10 May 2013 02:12:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368170776.8390.4.camel@jlt4.sipsolutions.net>
References: <1368170776.8390.4.camel@jlt4.sipsolutions.net>
Date: Fri, 10 May 2013 02:12:00 -0700
Message-ID: <CAJ-Vmo=RCVOD1ffraTexETgqYP6LbLAa_g0d2DVd8yTO99Q1AQ@mail.gmail.com> (sfid-20130510_111210_614528_F5645E58)
Subject: Re: [PATCH 0/8] Add support for 5 and 10 MHz channels
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: a@pandem0nium.sipsolutions.net, linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 May 2013 00:26, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-05-09 at 20:10 +0200, a@pandem0nium wrote:
>
>> Comments:
>>  * Is there any special requirement for handling beacons? For example,
>>    rates are halfed or quartered, but some rates could not be represented
>>    in the rate IEs. For example, 2.25 mbit/s can not be represented as
>>    multiple of 500 kbps.
>>  * therefore, all rates are handled like the corresponding 20 MHz
>> rates
>>    internally, which makes a lot of things easier (no changes required
>>    for rc-algos, beacon creation, etc...). We might consider adjusting
>> the
>>    output of rates for nl80211 or radiotap, though.
>
> This seems completely wrong, since Clause 18 says:
>
>         The OFDM system also provides a “half-clocked” operation using
>         10 MHz channel spacings with data communications capabilities of
>         3, 4.5, 6, 9, 12, 18, 24, and 27 Mb/s. The support of
>         transmitting and receiving at data rates of 3, 6, and 12 Mb/s is
>         mandatory when using 10 MHz channel spacing. The half-clocked
>         operation doubles symbol times and clear channel assessment
>         (CCA) times when using 10 MHz channel spacing. The regulatory
>         requirements and information regarding use of this OFDM PHY are
>         in Annex D and Annex E.
>
> IOW, it treats the rates as actually the rate they should be. Besides,
> what's so hard about rounding up? (8.4.2.4)
>
>         and bits 6 to 0 are set to the data rate, if necessary rounded
>         up to the next 500kb/s, in units of 500 kb/s.
>
>
> I also think you really need to handle this. If you just want a hack for
> 5/10 MHz, you can put it into drivers' debugfs, if not, then it should
> be done properly :-)

I think net80211 from FreeBSD and madwifi do this. Ie, they advertise
the half and quarter rate speeds as their real speeds at half/quarter
rate.

If anything, interoperability would be nice.




Adrian
