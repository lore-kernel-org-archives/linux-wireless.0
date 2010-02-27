Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:57563 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030634Ab0B0SyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 13:54:20 -0500
Received: by iwn12 with SMTP id 12so1227946iwn.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 10:54:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B895AAA.6070700@openwrt.org>
References: <133e8d7e1002270926p64cfd2b5uc4017bf0187c53c2@mail.gmail.com>
	 <4B895AAA.6070700@openwrt.org>
Date: Sat, 27 Feb 2010 19:54:19 +0100
Message-ID: <133e8d7e1002271054s71138b5csb10d5ea2f4488231@mail.gmail.com>
Subject: Re: [RFC] ath9k: Make AR_SREV_5416() macro evaluate to true for
	AR9100
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, I got those parenthesis mixed up. You are right. My bad.

But is AR9100 really not AR5416 based? For instance the devid define
is named AR5416_AR9100_DEVID and the original firmware reports the
chipset as

  ath_hal: 0.9.17.1 (AR5416, DEBUG, REGOPS_FUNC, WRITE_EEPROM, 11D)

Confusing, but you are probably right.

/Björn

2010/2/27 Felix Fietkau <nbd@openwrt.org>:
> On 2010-02-27 6:26 PM, Björn Smedman wrote:
>> The AR_SREV_5416() macro evaluates to false for AR9100 while the
>> definitions for AR_SREV_5416_20_OR_LATER() and
>> AR_SREV_5416_22_OR_LATER() seem to assume AR9100 based chips fall
>> under this category. For example the last line of
>>
>> #define AR_SREV_5416_20_OR_LATER(_ah) \
>>         (((AR_SREV_5416(_ah)) && \
>>          ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)) || \
>>          ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
>>
>> makes no sense if AR_SREV_5416(_ah) is false when
>> (_ah)->hw_version.macVersion == AR_SREV_VERSION_9100.
> I think this is wrong. The AR_SREV_xxxx macros typically point to a
> specific chip generation, whereas the AR_SREV_XXXX_OR_LATER() point to
> the chip generation or any later.
> AR9100 is related to AR9160, but not AR5416, so AR_SREV_5416() should
> return false for 9100 based devices.
> If you look at the AR_SREV_5416_20_OR_LATER macros, they do not assume
> that AR_SREV_5416() evaluates to true for the
> ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100) case, as it's
> either (is 5416 && macRev >= 20) or macVersion > 9100
>
> - Felix
>



-- 
Venatech AB
Ideon Innovation
Ole Römers väg 12
SE-22370 LUND
Sweden

+46 (0) 46 286 86 20
info@venatech.se
http://www.venatech.se
