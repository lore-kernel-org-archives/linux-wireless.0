Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754948AbcJEUcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 16:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <23f49efe-ddef-ea16-00de-7477e4872d82@nbd.name>
References: <20161002225059.16757-1-martin.blumenstingl@googlemail.com>
 <CAL_Jsq+cie=enhUYBF-OSrMdQ5S_048JF31ghEjtBNAmkGbB9Q@mail.gmail.com>
 <CAFBinCCDjZs6szRw0D1rwB89tUo+-RNFH2_g=K+Xj2iRJuUZDQ@mail.gmail.com> <23f49efe-ddef-ea16-00de-7477e4872d82@nbd.name>
From: Rob Herring <robh+dt@kernel.org>
Date: Wed, 5 Oct 2016 15:31:35 -0500
Message-ID: <CAL_JsqJfxEZCtdNi-wRgrtdmkPsGw0-ZMGhdbcoQ=seyij5LiQ@mail.gmail.com> (sfid-20161005_223204_584527_AFF6940A)
Subject: Re: [RFC 0/3] of: add common bindings to (de)activate IEEE 802.11 bands
To: Felix Fietkau <nbd@nbd.name>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k-devel@lists.ath9k.org, Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 5, 2016 at 1:36 PM, Felix Fietkau <nbd@nbd.name> wrote:
> On 2016-10-05 20:25, Martin Blumenstingl wrote:
>> On Mon, Oct 3, 2016 at 5:22 PM, Rob Herring <robh+dt@kernel.org> wrote:
>>> On Sun, Oct 2, 2016 at 5:50 PM, Martin Blumenstingl
>>> <martin.blumenstingl@googlemail.com> wrote:
>>>> There are at least two drivers (ath9k and mt76) out there, where
>>>> devicetree authors need to override the enabled bands.
>>>>
>>>> For ath9k there is only one use-case: disabling a band which has been
>>>> incorrectly enabled by the vendor in the EEPROM (enabling a band is not
>>>> possible because the calibration data would be missing in the EEPROM).
>>>> The mt76 driver (currently pending for review) however allows enabling
>>>> and disabling the 2.4GHz and 5GHz band, see [0].
>>>>
>>>> Based on the discussion of (earlier versions of) my ath9k devicetree
>>>> patch it was suggested [1] that we use enable- and disable- properties.
>>>> The current patch implements:
>>>> - bands can be enabled or disabled with the corresponding property
>>>> - if both (disable and enable) properties are given and a driver asks
>>>>   whether the band is enabled then the logic will return false (= not
>>>>   enabled, preferring the disabled flag)
>>>> - if both (disable and enable) properties are given and a driver asks
>>>>   whether the band is disabled then the logic will return true (again,
>>>>   preferring the disabled flag over the enabled flag)
>>>>
>>>> We can still change the logic to do what the mt76 driver does (I am
>>>> fine with both solutions):
>>>> - property not available: driver decides which bands to enable
>>>> - property set to 0: disable the band
>>>> - property set to 1: enable the band
>>>
>>> I prefer this way. Really, I'd prefer just a boolean disable property.
>>> I'm not sure why you need the enable. We usually have these tri-state
>>> properties when you want not present to mean use the bootloader or
>>> default setting. Try to make not present the most common case.
>> Felix: could you please give a few details why mt76 can not only
>> disable but also enable a specific band?
>> There is no specific comment in the sources [0] why this is needed.
>> All other drivers that I am aware of (ath9k, rt2x00) only allow
>> disabling a specific band, they never enable it (this has to be done
>> explicitly by the EEPROM).
> None of the devices use it at the moment, I probably added it when I
> played with a device that had broken EEPROM data. I guess I decided to
> do it this way because on many devices the band capability field simply
> cannot be trusted.
> I guess I would be okay with just having a disable property and adding
> an enable property later only if we end up actually needing it.

If EEPROM is commonly wrong or missing, then seems like you want to
plan ahead and support both enable and disable.

The other approach I've mentioned before is just put raw EEPROM data
into DT to override the EEPROM. This would be better if there's a
large number of settings you need.

Rob
