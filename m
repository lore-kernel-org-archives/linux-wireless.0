Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:38142 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZHJTIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:08:04 -0400
Received: by fg-out-1718.google.com with SMTP id e21so789679fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 12:08:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908102101.38698.mb@bu3sch.de>
References: <4A806B9E.5010105@gmail.com> <200908102101.38698.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 10 Aug 2009 21:07:45 +0200
Message-ID: <69e28c910908101207p17139562v55ede047c944dae@mail.gmail.com>
Subject: Re: [PATCH RFC] ssb: Implement the remaining rev.8 SPROM vars needed
	for LP-PHY
To: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/10 Michael Buesch <mb@bu3sch.de>:
> On Monday 10 August 2009 20:49:02 Gábor Stefanik wrote:
>> Also add a "SPEX32" macro for extracting 32-bit SPROM variables.
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> ---
>> I'm not quite sure that the SPEX32 macro is sane endianness-wise;
>> please review it carefully. (In the future, we will probably need
>> a SPEX64 macro too, to correctly extract boardflags.)
>>
>>  drivers/ssb/pci.c            |   53 +++++++++++++++++++++++++++++++++-
>>  include/linux/ssb/ssb.h      |   44 +++++++++++++++++++++++----
>>  include/linux/ssb/ssb_regs.h |   66 +++++++++++++++++++++++++++++++++++++----
>>  3 files changed, 148 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
>> index 40ea417..50811e4 100644
>> --- a/drivers/ssb/pci.c
>> +++ b/drivers/ssb/pci.c
>> @@ -169,8 +169,14 @@ err_pci:
>>  /* Get the word-offset for a SSB_SPROM_XXX define. */
>>  #define SPOFF(offset)        (((offset) - SSB_SPROM_BASE) / sizeof(u16))
>>  /* Helper to extract some _offset, which is one of the SSB_SPROM_XXX defines. */
>> -#define SPEX(_outvar, _offset, _mask, _shift)        \
>> +#define SPEX16(_outvar, _offset, _mask, _shift)      \
>>       out->_outvar = ((in[SPOFF(_offset)] & (_mask)) >> (_shift))
>> +#define SPEX32(_outvar, _offset, _mask, _shift)      \
>> +     out->_outvar = ((((in[SPOFF((_offset)+2)] << sizeof(u16)) | \
>                                                  ^^^^^^^^^^^^^^
> This shifts by 2 bit. Did you want 16 bits? Just write  << 16  then.
Good catch, thanks!

> Also, it seems you need +1 instead of +2 (it is an u16 pointer).
I'm adding to _offset, not to SPOFF(_offset). AFAICS _offset is not an
u16 pointer, it's a plain #defined number, unlike SPOFF(_offset).

> I also usually cast u16 values to u32 before shifting >=16 bits.
> The result of shifting a 16bit variable left by 16bits is machine dependent.
> It works as expected for every linux architecture, but I prefer the cast anyway.
Will do, thanks.

>
> Your macro extracts the value in littleendian format. I didn't check if this is
> correct for your values. But there also are values stored in BE format.
Larry, do you have any comments on this?

>
>
> --
> Greetings, Michael.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
