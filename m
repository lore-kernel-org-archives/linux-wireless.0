Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59385 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0DAVwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 17:52:35 -0400
Received: by wwb17 with SMTP id 17so1095298wwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 14:52:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB513AA.8020209@gmail.com>
References: <k2g880c1631004011414z59ce4547j1bcea7ad5aff7229@mail.gmail.com>
	<4BB513AA.8020209@gmail.com>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Thu, 1 Apr 2010 22:52:13 +0100
Message-ID: <q2uefe7343f1004011452oc7fbdc2fzb52da2d6ba673abf@mail.gmail.com>
Subject: Re: [PATCH V3] rt2x00: remove MCU requests for SoC platforms
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Luis Correia <buga@loide.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gertjan,

On Thu, Apr 1, 2010 at 22:44, Gertjan van Wingerde <gwingerde@gmail.com> wrote:
> Luis,
>
> On 04/01/10 23:14, Luis Correia wrote:
>> The ralink SoC platforms do not have an MCU.
>>
>> Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
>
> I know Ivo already acked the v2 version of the patch, but isn't the
> addition of a driver flag a bit overkill?
>
> We have the test on whether the platform is SOC w.r.t. MCU requests
> in 2 places, and both of them are in rt2800 code. I do not really see
> a need to clutter the global rt2x00 space with a rt2800 specific flag,
> which is only used in rt2800 code.
>


Well, I confess that it was really his suggestion.

For me, if a chipset needs firmware then it implicitly says there is
an MCU involved.
And I had a previously unpublished patch that just tested for SoC and
prevented MCU stuff.

But the patch itself is mostly harmless, since it doesn't add any
functionality nor makes the driver misbehave more then it already is.

I can revise it if needed.


>> ---
>>
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c   2010-03-26
>> 18:25:50.000000000 +0000
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c   2010-04-01
>> 13:05:18.249747122 +0100
>> @@ -221,9 +221,9 @@
>>        u32 reg;
>>
>>        /*
>> -        * SOC devices don't support MCU requests.
>> +        * some devices don't support MCU requests.
>>         */
>> -       if (rt2x00_is_soc(rt2x00dev))
>> +       if (!test_bit(DRIVER_REQUIRE_MCU, &rt2x00dev->flags))
>>                return;
>>
>>        mutex_lock(&rt2x00dev->csr_mutex);
>> --- a/drivers/net/wireless/rt2x00/rt2800pci.c   2010-03-26
>> 18:25:50.000000000 +0000
>> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c   2010-04-01
>> 13:04:42.453621607 +0100
>> @@ -59,6 +59,12 @@
>>  {
>>        unsigned int i;
>>        u32 reg;
>> +
>> +       /*
>> +        * some devices don't support MCU requests.
>> +        */
>> +       if (!test_bit(DRIVER_REQUIRE_MCU, &rt2x00dev->flags))
>> +               return;
>>
>>        for (i = 0; i < 200; i++) {
>>                rt2800_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
>
> So, the minimal patch would be simply this change to rt2800pci, and to have it
> test for SoC (via rt2x00_is_soc).
>
>> @@ -1098,10 +1104,12 @@
>>        __set_bit(DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL, &rt2x00dev->flags);
>>
>>        /*
>> -        * This device requires firmware.
>> +        * This device requires firmware and MCU access.
>>         */
>> -       if (!rt2x00_is_soc(rt2x00dev))
>> +       if (!rt2x00_is_soc(rt2x00dev)) {
>>                __set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
>> +               __set_bit(DRIVER_REQUIRE_MCU, &rt2x00dev->flags);
>> +       }
>>        __set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
>>        __set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
>>        if (!modparam_nohwcrypt)
>> --- a/drivers/net/wireless/rt2x00/rt2x00.h      2010-03-26
>> 18:25:50.000000000 +0000
>> +++ b/drivers/net/wireless/rt2x00/rt2x00.h      2010-04-01
>> 13:01:26.812694036 +0100
>> @@ -631,6 +631,7 @@
>>         * Driver requirements
>>         */
>>        DRIVER_REQUIRE_FIRMWARE,
>> +       DRIVER_REQUIRE_MCU,
>>        DRIVER_REQUIRE_BEACON_GUARD,
>>        DRIVER_REQUIRE_ATIM_QUEUE,
>>        DRIVER_REQUIRE_DMA,
>
> If we choose to have the flag anyways:
> From a naming point of view, this name is aligned with the other flags.
> However, from a usage point of view it would be better to have a flag
> DRIVER_NO_MCU, so we don't have to have the negative tests above, and
> have no tests at all that determine if MCU is allowed.

Good point, lets wait on the decision above to make this change.

>
> ---
> Gertjan.

As you all know, i'm not really a programmer ;)

Luis Correia
rt2x00 project admin
