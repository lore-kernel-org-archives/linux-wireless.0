Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:35040 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752251AbdHHL1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:27:20 -0400
Subject: Re: [PATCH 31/34] brcmfmac: Remove func0 from function array
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-32-ian@mnementh.co.uk>
 <21ea2a49-c797-b427-1ee7-ff8164c8f95c@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <388c6040-1359-ef7d-7a0f-a4b0ac9a9825@mnementh.co.uk> (sfid-20170808_132739_611889_3D35D394)
Date: Tue, 8 Aug 2017 12:27:17 +0100
MIME-Version: 1.0
In-Reply-To: <21ea2a49-c797-b427-1ee7-ff8164c8f95c@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/17 12:19, Arend van Spriel wrote:

>>  #define brcmf_sdiod_func0_rb(sdiodev, addr, r) \
>> -	sdio_f0_readb((sdiodev)->func[0], (addr), (r))
>> +	sdio_f0_readb((sdiodev)->func[1], (addr), (r))
> 
> There is no reason to keep these any longer as these do not provide any
> functionality over the core sdio function unless you consider the
> sdiodev dereference.
> 

I tend to agree, although they're fairly readable anyway. I was trying
to keep the changes small and incremental.

I'll knock up a patch and see how it looks with them converted to the
actual functions when I get back from hoiliday.

-Ian
