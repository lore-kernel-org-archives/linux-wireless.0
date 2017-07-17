Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:35406 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdGQTx7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 15:53:59 -0400
Received: by mail-wr0-f177.google.com with SMTP id w4so27761820wrb.2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 12:53:59 -0700 (PDT)
Subject: Re: BUG: brcmfmac: add firmware feature detection for gscan feature
 breaks 43430a1
To: Ian Molton <ian@mnementh.co.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <25c47ffe-af3e-fb85-ed5b-ff1987cfd93f@mnementh.co.uk>
 <e6635794-7c35-1a46-2d5b-68824c7b0657@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ff344ee3-3feb-6886-8007-d8ed00386424@broadcom.com> (sfid-20170717_215408_691378_ABA7AABB)
Date: Mon, 17 Jul 2017 21:53:56 +0200
MIME-Version: 1.0
In-Reply-To: <e6635794-7c35-1a46-2d5b-68824c7b0657@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-07-17 20:31, Ian Molton wrote:
> On 17/07/17 18:50, Ian Molton wrote:
>> Resent due to subject error. Apologies, Hante :)
>>
>> Hi Folks,
>>
>> 9fe929aaace6  brcmfmac: add firmware feature detection for gscan feature
>>
>> Completely breaks 43430a1 support.
> 
> Digging a bit deeper, this would *appear* to be one of a couple of
> possibilities;
> 
> 1) brcmf_sdio_hostmail() is missing code to handle a response of type
>    0x40012
> 2) The firmware is failing when asked to handle the new requiests, and
>    is going to la-la land.

taken a wrong turn straight into la-la land.

> Decoding the reply gives us HMB_DATA_DEVREADY or-ed with 0x40010
> 
> Since the upper half-word is masked, that leaves us with 0x10 which does
> not appear to be a defined state.
> 
> The driver does not handle this well, in any event.
> 
> My guess is that you are working on top of newer firmware than I have.
> Can you let me know what the latest public firmware is, and where I can
> get it?
> 
> I have version wl0: Aug 29 2016 20:48:16 version 7.45.41.26 (r640327)
> FWID 01-4527cfab

Not so much newer firmware, but I used a different chip when
implementing the multi-scheduled scan patches. I tried some other
devices, but not the bcm4343{0,8}. Now as far as I can see over here the
brcmfmac43430-sdio.bin is not built with gscan support so it should just
return firmware errorcode, ie. -23. So it would be interesting to see
what firmware has to say. Can you load the driver with
ignore_probe_fail=1 and dump the forensics file in debugfs.

Regards,
Arend
