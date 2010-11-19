Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38236 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab0KSRAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 12:00:13 -0500
Received: by pwj1 with SMTP id 1so758249pwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 09:00:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290184873.23033.3.camel@maggie>
References: <1290028477-6462-1-git-send-email-zajec5@gmail.com>
 <AANLkTikXqg9boY1H_OPAvs7WPd6SXUt8DpykRHuRxB6E@mail.gmail.com> <1290184873.23033.3.camel@maggie>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 19 Nov 2010 17:59:52 +0100
Message-ID: <AANLkTimFQ9UYWKtHpjXBTS0PPJcB_vPD7kawfffY_c+-@mail.gmail.com>
Subject: Re: [PATCH V2] b43: rfkill: use HI enabled bit for all devices
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 19, 2010 at 5:41 PM, Michael Büsch <mb@bu3sch.de> wrote:
> On Fri, 2010-11-19 at 17:12 +0100, Gábor Stefanik wrote:
>> 2010/11/17 Rafał Miłecki <zajec5@gmail.com>:
>> > Devices which use LO enabled bit are covered by b43legacy
>> >
>> > Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> > ---
>> > V2: Dropped some not needed stuff as pointed by Michael, thanks!
>> >
>> > John: it's .38 ofc.
>> > ---
>> >  drivers/net/wireless/b43/rfkill.c |   19 ++-----------------
>> >  1 files changed, 2 insertions(+), 17 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
>> > index 78016ae..86bc0a0 100644
>> > --- a/drivers/net/wireless/b43/rfkill.c
>> > +++ b/drivers/net/wireless/b43/rfkill.c
>> > @@ -28,23 +28,8 @@
>> >  /* Returns TRUE, if the radio is enabled in hardware. */
>> >  bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
>> >  {
>> > -       if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
>> > -               if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
>> > -                     & B43_MMIO_RADIO_HWENABLED_HI_MASK))
>> > -                       return 1;
>> > -       } else {
>> > -               /* To prevent CPU fault on PPC, do not read a register
>> > -                * unless the interface is started; however, on resume
>> > -                * for hibernation, this routine is entered early. When
>> > -                * that happens, unconditionally return TRUE.
>> > -                */
>> > -               if (b43_status(dev) < B43_STAT_STARTED)
>> > -                       return 1;
>> > -               if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
>> > -                   & B43_MMIO_RADIO_HWENABLED_LO_MASK)
>> > -                       return 1;
>> > -       }
>> > -       return 0;
>>
>> Is there any reason why this bool originally returned 1 or 0 instead
>> of true or false?
>
> There's no difference.
> (int)0 implicitly casts to false and anything else to true.

I know, just for the sake of coding style. Same as initializing
pointers to NULL, not 0 (though AFAIK there are platforms where 0x0 is
a valid memory address, so using NULL is more than just coding style).

>
> --
> Greetings Michael.
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
