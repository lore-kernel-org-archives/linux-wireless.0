Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:43726 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbZKIWLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:11:34 -0500
Received: by ey-out-2122.google.com with SMTP id 4so69911eyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 14:11:38 -0800 (PST)
Message-ID: <4AF89398.6060305@gmail.com>
Date: Mon, 09 Nov 2009 23:11:36 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] rt2x00: Properly detect Ralink RT3070 devices.
References: <1257803976-5378-1-git-send-email-gwingerde@gmail.com> <69e28c910911091404i18e4e4b8ydd9d334bc833de3b@mail.gmail.com>
In-Reply-To: <69e28c910911091404i18e4e4b8ydd9d334bc833de3b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/09 23:04, Gábor Stefanik wrote:
> On Mon, Nov 9, 2009 at 10:59 PM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> Allow rt2800usb to properly detect RT307X based devices, and set the appropriate chipset values.
>>
>> Signed-off-by: Gertjan van Wingede <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800usb.c |   21 ++++++++++++++-------
>>  drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
>>  2 files changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
>> index d22ab64..bd2f6e6 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
>> @@ -790,16 +790,19 @@ static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>>         */
>>        value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
>>        rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
>> -       rt2x00_set_chip(rt2x00dev, RT2870, value, reg);
>> +       rt2x00_set_chip_rf(rt2x00dev, value, reg);
>>
>>        /*
>>         * The check for rt2860 is not a typo, some rt2870 hardware
>>         * identifies itself as rt2860 in the CSR register.
>>         */
>> -       if (!rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28600000) &&
>> -           !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28700000) &&
>> -           !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28800000) &&
>> -           !rt2x00_check_rev(&rt2x00dev->chip, 0xffff0000, 0x30700000)) {
>> +       if (rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28600000) ||
>> +           rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28700000) ||
>> +           rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28800000)) {
>> +               rt2x00_set_chip_rt(rt2x00dev, RT3070);
> 
> Typo?
> 

Doh. You're right. And I did even test this on a RT2870 device :-(

Thanks for noticing this.

I'll resend the patch with this fixed.

But first, I need to find a brown paper bag somewhere. ;-)

---
Gertjan.
