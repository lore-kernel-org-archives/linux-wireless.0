Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44056 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdDCNCe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 09:02:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johan Hovold <johan@kernel.org>
CC: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sujith Manoharan <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH 1/2] wireless: ath9k_htc: fix NULL-deref at probe
Date: Mon, 3 Apr 2017 13:02:28 +0000
Message-ID: <87k271myos.fsf@kamboji.qca.qualcomm.com> (sfid-20170403_150313_258376_4BA3835D)
References: <20170313124421.28587-1-johan@kernel.org>
        <20170403084213.GE25742@localhost>      <87shlpomvx.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87shlpomvx.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Mon, 03 Apr 2017 12:34:26 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Johan Hovold <johan@kernel.org> writes:
>
>> On Mon, Mar 13, 2017 at 01:44:20PM +0100, Johan Hovold wrote:
>>> Make sure to check the number of endpoints to avoid dereferencing a
>>> NULL-pointer or accessing memory beyond the endpoint array should a
>>> malicious device lack the expected endpoints.
>>>=20
>>> Fixes: 36bcce430657 ("ath9k_htc: Handle storage devices")
>>> Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>>> Signed-off-by: Johan Hovold <johan@kernel.org>
>>
>> Is this one still in your queue, Kalle?
>
> Yes, I'm just lacking behing:
>
> https://patchwork.kernel.org/patch/9620723/

Meant "lagging" of course. Mondays..

>> As I mentioned earlier, I should have added a
>>
>> Cc: stable <stable@vger.kernel.org>     # 2.6.39
>>
>> but left it out as I mistakingly thought the net recommendations to do
>> so applied also to wireless.
>
> Ok, I'll add that.

But is 2.6.39 really correct? Shouldn't it be 2.6.39+ so that it means
all versions since 2.6.39?

--=20
Kalle Valo=
