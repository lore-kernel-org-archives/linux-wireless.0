Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:36382 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751586AbdHSVGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 17:06:43 -0400
Subject: Re: [PATCH 08/34] brcmfmac: Fix uninitialised variable
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-9-ian@mnementh.co.uk> <59884E53.2050209@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <e5c26559-b8f3-9b8c-0d3c-7fcf52dd109e@mnementh.co.uk> (sfid-20170819_230647_320154_3F77BEE2)
Date: Sat, 19 Aug 2017 22:06:40 +0100
MIME-Version: 1.0
In-Reply-To: <59884E53.2050209@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 12:26, Arend van Spriel wrote:
> On 7/26/2017 10:25 PM, Ian Molton wrote:
>>     Unlikely to be a problem, but brcmf_sdiod_regrb() is
>> not symmetric with brcmf_sdiod_regrl() in this regard.
> 
> You are pretty keen on symmetry, but you could also remove the
> initialization in brcmf_sdiod_regrl(). As long as no -Wunitialized pops
> up that would have my preference.

Whilst the compiler does not complain, there are paths through
brcmf_sdiod_reg_read() that do not set *data, so I think it best to
initialise the value, but its not really very important. Code that isn't
checking the return value is asking for it anyway :)

In the later patches we could remove the initialisation, as IIRC the
Linux MMC IO functions do it for us and we don't avoid calling them in
that version of the code.

-Ian
