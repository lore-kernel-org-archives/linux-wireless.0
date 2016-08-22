Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60703 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbcHVNf7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 09:35:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Benjamin Berg <benjamin.berg@open-mesh.com>
Cc: Adi Ratiu <adi@adirat.com>, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
        linux-kernel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: ath9k: Fix beacon configuration assertion failure
References: <fb48526fcf8f4b6db25c20b727c4a3d5@euamsexm01a.eu.qualcomm.com>
        <87fuq1yt1x.fsf@kamboji.qca.qualcomm.com>
        <1471855240.16921.6.camel@open-mesh.com>
Date: Mon, 22 Aug 2016 16:35:28 +0300
In-Reply-To: <1471855240.16921.6.camel@open-mesh.com> (Benjamin Berg's message
        of "Mon, 22 Aug 2016 10:40:40 +0200")
Message-ID: <87r39h3p0f.fsf@purkki.adurom.net> (sfid-20160822_153617_684704_179D062B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Berg <benjamin.berg@open-mesh.com> writes:

> On Fr, 2016-08-19 at 13:03 +0300, Kalle Valo wrote:
>> Actually, I see two patches which might be related but not identical:
>> 
>> ath9k: fix client mode beacon configuration
>> https://patchwork.kernel.org/patch/9247699/
>> 
>> ath9k: Fix beacon configuration assertion failure
>> https://patchwork.kernel.org/patch/9281191/
>> 
>> Felix (CCed) & Benjamin: please take a look and advice which one I
>> should take.
>
> Yes, both patches are designed to fix the same issue in my patch.
>
> Felix solution looks entirely correct to me, the second solution seems
> slightly wrong because it prevents the call to ath9k_beacon_config from
> happening instead of ensuring the correct parameter value.
> ath9k_beacon_config needs to be called even if iter_data.beacons is
> false as it disables the interrupts.

Ok, I'll the patch from Felix then. Thanks.

-- 
Kalle Valo
