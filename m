Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:32962 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdAQWlp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 17:41:45 -0500
Received: by mail-ot0-f180.google.com with SMTP id 73so72828967otj.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2017 14:41:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rymMzoYJHBYb3PQpyNomp-HixAFqvtafMw72dySk8MPLQ@mail.gmail.com>
References: <20170117222909.2880-1-gavinli@thegavinli.com> <CACna6rymMzoYJHBYb3PQpyNomp-HixAFqvtafMw72dySk8MPLQ@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 17 Jan 2017 23:41:44 +0100
Message-ID: <CACna6rwmL=ygjCtCCNuDEhBQoe=J4rZEcxGj_Pi3zkvH_e1z9g@mail.gmail.com> (sfid-20170117_234150_402139_55D6DEAF)
Subject: Re: [PATCH] brcmfmac: fix incorrect event channel deduction
To: gavinli@thegavinli.com
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Gavin Li <git@thegavinli.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 January 2017 at 23:41, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wro=
te:
> On 17 January 2017 at 23:29,  <gavinli@thegavinli.com> wrote:
>> From: Gavin Li <git@thegavinli.com>
>>
>> brcmf_sdio_fromevntchan() was being called on the the hardware header
>> rather than the software header, causing some frames to be
>> mischaracterized as on the event channel rather than the data channel.
>> This fixes the performance regression introduced in commit c56caa9d
>> where event processing is done separately.
>
> This should be:
> in commit c56caa9db8ab ("brcmfmac: screening firmware event packet") wher=
e (...)
>
> You should also use
> Fixes: c56caa9db8ab ("brcmfmac: screening firmware event packet") where (=
...)

Oops, copy & paste mistake. Just:
Fixes: c56caa9db8ab ("brcmfmac: screening firmware event packet")

--=20
Rafa=C5=82
