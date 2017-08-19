Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:44564 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbdHSUjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 16:39:24 -0400
Subject: Re: [PATCH 34/34] brcmfmac: Reduce the noise from repeatedly
 dereferencing common pointers
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-35-ian@mnementh.co.uk>
 <3fcfb0c3-7cb3-78f0-bc50-c6b7fa4d5ff4@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <9f05fd96-5ed0-1212-192b-aca01ec3c5f4@mnementh.co.uk> (sfid-20170819_223927_949382_B848537C)
Date: Sat, 19 Aug 2017 21:39:22 +0100
MIME-Version: 1.0
In-Reply-To: <3fcfb0c3-7cb3-78f0-bc50-c6b7fa4d5ff4@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/17 13:29, Arend van Spriel wrote:
>>  int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep)
>>  {
>> +	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
>> +	struct sdio_func *func1 = sdiodev->func1;
>
> Actually only wanted to explicitly mention this one. Probably the
> compiler is smart enough to keep sdiodev from the stack, but I would say
> it is a variable you do not really need and also in terms of readability
> it seems clear enough to do it in one assignment.

Yeah, it could be - but as you say, the compiler *will* be smart enough,
and doing it in this manner makes it consistent with all the other code :-)

I'm looking at your other comments atm. :)

-Ian

>>  	int ret;
>>  
>> -	sdio_claim_host(bus->sdiodev->func1);
>> +	sdio_claim_host(func1);
>>  	ret = brcmf_sdio_bus_sleep(bus, sleep, false);
>> -	sdio_release_host(bus->sdiodev->func1);
>> +	sdio_release_host(func1);
>>  
