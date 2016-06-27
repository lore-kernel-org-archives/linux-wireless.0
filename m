Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38549 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbcF0O7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 10:59:14 -0400
Received: by mail-wm0-f51.google.com with SMTP id r201so119322780wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2016 07:59:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160627125709.GF1113@leverpostej>
References: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
 <20160623174536.5967-2-martin.blumenstingl@googlemail.com>
 <20160623175809.GA31170@leverpostej> <CAFBinCC6iY_y-_w_yeoqOOysqYBQxcRf8oVgXYs3YqqSE=sJrQ@mail.gmail.com>
 <20160627125709.GF1113@leverpostej>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 27 Jun 2016 16:58:53 +0200
Message-ID: <CAFBinCBJdibUJH1jwEZObWVLNAGyh+ZH9XzB1CbmoGr+nUZYbg@mail.gmail.com> (sfid-20160627_165923_417540_63AAB8D2)
Subject: Re: [PATCH RFC v2 1/2] Documentation: dt: net: add ath9k wireless
 device binding
To: Mark Rutland <mark.rutland@arm.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name, chunkeey@googlemail.com,
	robh+dt@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 27, 2016 at 2:57 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > Please find a better way to identify relevant FW. What exactly affects
>> > which FW can be used, or would ideally be used? Are different FWs
>> > required for the same HW in some contexts?
>> >
>> > Can we not figure out the relevant FW names in the driver based on some
>> > identification mechanism (e.g. a more thoroughly defined set of
>> > compatible strings)?
>> The only way of auto-detecting a "correct" name would be via
>> dev_name() (with some prefix this could give something like
>> ath9k-pci-0000:00:0e.0.bin).
>
> That may work, if the above is not an option.
I would also prefer this (Felix' email already contains an explanation
why this way is preferred and I fully agree with him).

>> >> +- qca,check-eeprom-endianness: Allow checking the EEPROM endianness and
>> >> +                             swapping of the EEPROM data if required
>> >
>> > CAn we not simply always do this?
>> I've asked myself this question as well, but unfortunately some
>> manufacturers ship the EEPROM data with incorrect endianness magic.
>> Thus I decided to stay consistent with ath9k_platform_data which also
>> has a boolean (which defaults to false).
>
> Ah. It's probably worth a note in the binding that this is not always
> safe, and should only be set if the eeprom is known to have valid
> endianness magic.
>
> It would also be worth specifying teh behaviour in the absence of this
> property.
noted, I will fix this in the next round

>>
>> >> +- qca,disable-2ghz: Disables the 2.4GHz band, even if enabled in the EEPROM
>> >> +- qca,disable-5ghz: Disables the 5GHz band, even if enabled in the EEPROM
>> >
>> > When/why would these be necessary?
>> sometimes a manufacturer (accidentally) leaves both bands enabled in
>> the EEPROM data,while the RF hardware is only suitable for one of both
>> bands. The same settings exist in ath9k_platform_data, serving exactly
>> the same purpose
>
> Ok. Can we invert these instead (i.e. describe when the feature is
> available)? e.g. qca,supports-2ghz.
we could invert these, but I think the "disable" logic was chosen with
a good reason:
the ath9k calibration data already contains the information which
bands are enabled/disabled. Enabling a band via devicetree / platform
data is not possible, because that would mean we would have to pass
additional calibration data for this band.
The only use-case where these disable-Xghz properties are used is when
the device vendor forgot to disable one of the bands. I can improve
the documentation for this one, but I would prefer to stay with the
disable naming/logic


Martin
