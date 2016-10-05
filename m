Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38839 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbcJESZW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 14:25:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+cie=enhUYBF-OSrMdQ5S_048JF31ghEjtBNAmkGbB9Q@mail.gmail.com>
References: <20161002225059.16757-1-martin.blumenstingl@googlemail.com> <CAL_Jsq+cie=enhUYBF-OSrMdQ5S_048JF31ghEjtBNAmkGbB9Q@mail.gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Wed, 5 Oct 2016 20:25:00 +0200
Message-ID: <CAFBinCCDjZs6szRw0D1rwB89tUo+-RNFH2_g=K+Xj2iRJuUZDQ@mail.gmail.com> (sfid-20161005_202527_125224_B8AF9789)
Subject: Re: [RFC 0/3] of: add common bindings to (de)activate IEEE 802.11 bands
To: Rob Herring <robh+dt@kernel.org>, Felix Fietkau <nbd@nbd.name>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k-devel@lists.ath9k.org, Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 3, 2016 at 5:22 PM, Rob Herring <robh+dt@kernel.org> wrote:
> On Sun, Oct 2, 2016 at 5:50 PM, Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
>> There are at least two drivers (ath9k and mt76) out there, where
>> devicetree authors need to override the enabled bands.
>>
>> For ath9k there is only one use-case: disabling a band which has been
>> incorrectly enabled by the vendor in the EEPROM (enabling a band is not
>> possible because the calibration data would be missing in the EEPROM).
>> The mt76 driver (currently pending for review) however allows enabling
>> and disabling the 2.4GHz and 5GHz band, see [0].
>>
>> Based on the discussion of (earlier versions of) my ath9k devicetree
>> patch it was suggested [1] that we use enable- and disable- properties.
>> The current patch implements:
>> - bands can be enabled or disabled with the corresponding property
>> - if both (disable and enable) properties are given and a driver asks
>>   whether the band is enabled then the logic will return false (= not
>>   enabled, preferring the disabled flag)
>> - if both (disable and enable) properties are given and a driver asks
>>   whether the band is disabled then the logic will return true (again,
>>   preferring the disabled flag over the enabled flag)
>>
>> We can still change the logic to do what the mt76 driver does (I am
>> fine with both solutions):
>> - property not available: driver decides which bands to enable
>> - property set to 0: disable the band
>> - property set to 1: enable the band
>
> I prefer this way. Really, I'd prefer just a boolean disable property.
> I'm not sure why you need the enable. We usually have these tri-state
> properties when you want not present to mean use the bootloader or
> default setting. Try to make not present the most common case.
Felix: could you please give a few details why mt76 can not only
disable but also enable a specific band?
There is no specific comment in the sources [0] why this is needed.
All other drivers that I am aware of (ath9k, rt2x00) only allow
disabling a specific band, they never enable it (this has to be done
explicitly by the EEPROM).

>> The new code has been integrated into ath9k to demonstrate how to use
>> it (with the benefit that the disable_2ghz and disable_5ghz settings
>> from the ath9k_platform_data can now also be configured via .dts).
>>
>> open questions/decisions needed:
>> - where to place this new code? I put it into drivers/of/of_ieee80211
>>   because that's where most other functions live.
>>   However, I found that this makes backporting the code harder (using
>>   wireless-backports from the driver-backports project [2])
>
> We are generally moving subsystem specific code like this out of
> drivers/of/, so please do that here. Maybe someone will get motivated
> to move the other networking code out too.
OK, thanks for the hint.

[0] https://github.com/openwrt/mt76/blob/master/eeprom.c
