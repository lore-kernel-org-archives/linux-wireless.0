Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38850 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752160AbdBULqw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 06:46:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH V3 2/2] brcmfmac: don't warn user about NVRAM if fallback to platform one succeeds
References: <20170216072636.7128-1-zajec5@gmail.com>
        <20170221094754.15406-1-zajec5@gmail.com>
        <20170221094754.15406-2-zajec5@gmail.com>
        <9ac0557a-2746-bc61-7397-a7fa58a02787@broadcom.com>
Date: Tue, 21 Feb 2017 13:46:34 +0200
In-Reply-To: <9ac0557a-2746-bc61-7397-a7fa58a02787@broadcom.com> (Arend Van
        Spriel's message of "Tue, 21 Feb 2017 10:57:07 +0100")
Message-ID: <87vas3daw5.fsf@kamboji.qca.qualcomm.com> (sfid-20170221_124729_177328_DD658568)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 21-2-2017 10:47, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>=20
>> Failing to load NVRAM file isn't critical if we manage to get platform
>> one in the fallback path. It means warnings like:
>> [ 10.801506] brcmfmac 0000:01:00.0: Direct firmware load for
>> brcm/brcmfmac43602-pcie.txt failed with error -2
>> are unnecessary & disturbing for people with platform NVRAM. This is
>> very common case for Broadcom home routers.
>>=20
>> So instead of printing warning immediately with the firmware subsystem
>> let's first try our fallback code. If that fails as well, then it's a
>> right moment to print an error.
>>=20
>> This should reduce amount of false reports from users seeing this
>> warning while having wireless working perfectly fine.
>
> I think FW_OPT_NO_WARN does not cover all warnings in firmware_class
> although I did not check. Anyway...
>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Acked-by: Kalle Valo <kvalo@codeaurora.org>

Feel free to this via some another tree.

--=20
Kalle Valo
