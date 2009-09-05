Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:49298 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZIEUmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 16:42:03 -0400
Received: by iwn5 with SMTP id 5so539651iwn.4
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2009 13:42:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA2CAEC.3000908@gmx.de>
References: <4AA270AF.2010902@gmx.de> <43e72e890909051233s3df12787oa1c59a8b9728c271@mail.gmail.com>
	<4AA2CAEC.3000908@gmx.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 5 Sep 2009 13:41:45 -0700
Message-ID: <43e72e890909051341l2a81bf4dy8a40f681f0779095@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath,ar9170: move CTL_ defines into regd.h
To: Joerg Albert <jal2@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 5, 2009 at 1:32 PM, Joerg Albert<jal2@gmx.de> wrote:
> On 09/05/2009 09:33 PM, Luis R. Rodriguez wrote:
>> On Sat, Sep 5, 2009 at 7:07 AM, Joerg Albert<jal2@gmx.de> wrote:
>>> The ar9170 driver needs the defines for conformance test limit groups
>>> and cannot include regd_common.h
>>>
>>> Signed-off-by: Joerg Albert <jal2@gmx.de>
>>
>> Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>
>> Just please test compilation of ath5k and ath9k as well.
>
> They compile fine.
>
> Sometime we should IMHO unify the CTL_* defines in the driver below ath/.
> Currently ath5k, ath9k and regd.h have separate definitions for the modes, e.g.
>
> ~/src/wireless.gits/wireless-testing/drivers/net/wireless/ath$ fgrep -r --include=*.h CTL_11A *
> ath5k/eeprom.h: AR5K_CTL_11A = 0,
> ath9k/eeprom.h:#define CTL_11A                 0
> ath9k/eeprom.h:#define CTL_11A_EXT (CTL_11A | EXT_ADDITIVE)
> regd.h:#define CTL_11A                 0

right, that's the idea of ath.ko, to unify as much as we can, step by
step. If you see anything else to be shared just send a patch.

  Luis
