Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:36654 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751684AbdHSU1D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 16:27:03 -0400
Subject: Re: [PATCH 14/34] brcmfmac: Remove brcmf_sdiod_addrprep()
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-15-ian@mnementh.co.uk> <59884E86.9040502@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <5a49f7ef-bddf-f5ba-95e1-0875a6379643@mnementh.co.uk> (sfid-20170819_222707_555904_A8B30DCB)
Date: Sat, 19 Aug 2017 21:27:01 +0100
MIME-Version: 1.0
In-Reply-To: <59884E86.9040502@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 12:27, Arend van Spriel wrote:
> On 7/26/2017 10:25 PM, Ian Molton wrote:
>> This function has become trivial enough that it may as well be pushed
>> into
>> its callers, which has the side-benefit of clarifying what's going on.
>>
>> Remove it, and rename brcmf_sdiod_set_sbaddr_window() to
>> brcmf_sdiod_set_backplane_window() as it's easier to understand.
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> 
> comments below...
> 

>> -    if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
>> -        return -ENOMEDIUM;
> 
> So now you are dropping the state check here, which seems significant
> enough to mention in the commit log. We need to discuss that. The idea
> of it was to refrain from using IO function of the MMC stack when we no
> there is no longer a device, ie. when stack has previously returned a
> -ENOMEDIUM.

Yeah, that code is broken (see earlier email) AFAICT anyway, and we
should probably handle losing our card a lot more gracefully in general.

>> +    if (bar0 == sdiodev->sbwad)
>> +        return 0;
>>
>> -    addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
>> +    v = bar0 >> 8;
> 
> why introducing a new variable on the stack. You actually don't need any
> and just mask and shift the addr variable passed to the function.

Linux code *generally* doesn't do this. Its stylistic anyway, since the
compiler certainly won't be dumb enough to allocate another register (or
stack space) in this instance.

>>       if (!retval)
>>           data = sdio_readl(sdiodev->func[1], addr, &retval);
> 
> The if-statement is now redundant here...

Good catch! :)

-Ian
