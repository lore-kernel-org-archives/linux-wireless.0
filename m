Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37048 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbcHVQZu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 12:25:50 -0400
Received: by mail-wm0-f42.google.com with SMTP id i5so153532849wmg.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2016 09:25:49 -0700 (PDT)
From: Ioan-Adrian Ratiu <adi@adirat.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Benjamin Berg <benjamin.berg@open-mesh.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k-devel@lists.ath9k.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: ath9k: Fix beacon configuration assertion failure
In-Reply-To: <87r39h3p0f.fsf@purkki.adurom.net>
References: <fb48526fcf8f4b6db25c20b727c4a3d5@euamsexm01a.eu.qualcomm.com> <87fuq1yt1x.fsf@kamboji.qca.qualcomm.com> <1471855240.16921.6.camel@open-mesh.com> <87r39h3p0f.fsf@purkki.adurom.net>
Date: Mon, 22 Aug 2016 19:18:42 +0300
Message-ID: <87mvk4kc9p.fsf@ni.com> (sfid-20160822_182600_209979_06A43DD6)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 22 Aug 2016, Kalle Valo <kvalo@codeaurora.org> wrote:
> Benjamin Berg <benjamin.berg@open-mesh.com> writes:
>
>> On Fr, 2016-08-19 at 13:03 +0300, Kalle Valo wrote:
>>> Actually, I see two patches which might be related but not identical:
>>>=20
>>> ath9k: fix client mode beacon configuration
>>> https://patchwork.kernel.org/patch/9247699/
>>>=20
>>> ath9k: Fix beacon configuration assertion failure
>>> https://patchwork.kernel.org/patch/9281191/
>>>=20
>>> Felix (CCed) & Benjamin: please take a look and advice which one I
>>> should take.
>>
>> Yes, both patches are designed to fix the same issue in my patch.
>>
>> Felix solution looks entirely correct to me, the second solution seems
>> slightly wrong because it prevents the call to ath9k_beacon_config from
>> happening instead of ensuring the correct parameter value.
>> ath9k_beacon_config needs to be called even if iter_data.beacons=C2=A0is
>> false as it disables the interrupts.
>
> Ok, I'll the patch from Felix then. Thanks.

Tested Felix patch. Confirm it works great. Thanks!

>
> --=20
> Kalle Valo
