Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44408 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3DOP7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 11:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <1366013912.676272.13358.5267@saddam4.rambler.ru>
References: <CAL1gcdP90HGCPxw_L6mph3D5GoJevg_oJyuBUW9Uxg6N8AfxvA@mail.gmail.com>
	<1366013912.676272.13358.5267@saddam4.rambler.ru>
Date: Mon, 15 Apr 2013 17:59:51 +0200
Message-ID: <CAL1gcdNwZ8jRP71PCaT3SJXYuToONH_x=N5h91KzX0yfCK7Anw@mail.gmail.com> (sfid-20130415_175957_392333_DE10DC67)
Subject: Re: Re: [PATCH v2] rt2x00: Fix transmit power troubles on some Ralink
 RT30xx cards
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Alex Mihaylov <minimumlaw@rambler.ru>
Cc: stable@vger.kernel.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 15, 2013 at 10:18 AM, Alex Mihaylov <minimumlaw@rambler.ru> wrote:
>
> Good day!
>
>> > From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
>> > Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
>> > value in them EEPROM/EFUSE. In this case, we must use default value,
>> > but always used EEPROM/EFUSE value. As result we have tranmitt power
>> > range from -10dBm to +6dBm instead 0dBm to +16dBm.
>
>
>> > Signed-off-by: Alex A. Mihaylov <minimumlaw@rambler.ru>
>> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
>> > b/drivers/net/wireless/rt2x00/rt2800lib.c
>
>
>> Could you explain how you have come to this patch?
>> Is this behavior of the Ralink provided driver that you replicated
>> here, or have you come to this approach in an other way?
>
>
> Yes, vendor driver have this code in chips/rt3070.c (function
> NICInitRT3070RFRegisters) and chips/rt30xx.c (function
> RT30xxLoadRFNormalModeSetup) files.
> Look like this:
> [skipped]
> if (pAd->TxMixerGain24G >= 2)
> {
>      RFValue &= (~0x7);  /* clean bit [2:0]*/
>      RFValue |= pAd->TxMixerGain24G;
> }
> RT30xxWriteRFRegister(pAd, RF_R17, RFValue);
> [skipped]
> and have differents only in constants (2 in rt30xx.c and one in tr3070.c).
> TxPower i messaurment on power detector, connected directly to module.

OK. Thanks for the explanation. I've found it myself there as well.
I'll ack the patch.

--
---
Gertjan
