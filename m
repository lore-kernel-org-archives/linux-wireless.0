Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34007 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752755AbeFYIVM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 04:21:12 -0400
Received: by mail-ed1-f65.google.com with SMTP id q24-v6so3178585edr.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 01:21:12 -0700 (PDT)
Subject: Re: [PATCH 6/6] brcmfmac: fallback mechanism to determine monitor
 mode features
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
 <1529693004-20569-7-git-send-email-arend.vanspriel@broadcom.com>
 <CACna6rxi88e6oek8zt_7KG6PY4ih_ehpsd67hK2DXGHKQZhSSg@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B30A5F5.9080404@broadcom.com> (sfid-20180625_102151_452894_FAF1DCD2)
Date: Mon, 25 Jun 2018 10:21:09 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rxi88e6oek8zt_7KG6PY4ih_ehpsd67hK2DXGHKQZhSSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/24/2018 4:08 PM, Rafał Miłecki wrote:
> On Fri, 22 Jun 2018 at 20:45, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> Firmwares may not provide all monitor mode features in the "cap" iovar.
>> For those this fallback mechanism uses "sta_monitor" iovar. If firmware
>> is compiled with stamon, this iovar will fail with BCME_NOTUP; Otherwise
>> it fails with BCME_UNSUPPORTED.
>
> It's probably not the first time ever, but it appears your research
> (theory) doesn't match my experience (practice) ;) I'm afraid you
> missed some important check when analyzing firmware code.

It was not all theory ;-) but apparently I did not cover all bases. I 
only checked with 4366c0 (actually with 43664 aka 4366E) on the release 
branch I am working on.

> I've just tested all firmwares I got (for 43602a1, 4366b1 and 4366c0)
> and all of them return -4 (BCME_NOTUP) for "sta_monitor" when
> firmware/interface is down. It appears this test requires bringing
> firmware/interface up to make it reliable. Apparently even firmwares
> *without* sta_monitor return -4 (BCME_NOTUP) when firmware/interface
> is down.

That is crap. So back to the drawing board. Thanks for keeping the taps 
on this.

Regards,
Arend
