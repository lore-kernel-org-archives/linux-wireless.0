Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:33414 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdHSTwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 15:52:13 -0400
Subject: Re: [PATCH 01/34] brcmfmac: Fix parameter order in
 brcmf_sdiod_f0_writeb()
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-2-ian@mnementh.co.uk> <59884E20.7090108@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <3e7edfe6-ac5b-7d37-38ca-d217aeb1eb27@mnementh.co.uk> (sfid-20170819_215221_855749_43701883)
Date: Sat, 19 Aug 2017 20:52:08 +0100
MIME-Version: 1.0
In-Reply-To: <59884E20.7090108@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 12:25, Arend van Spriel wrote:
>>     All the other IO functions are the other way round in this
>> driver. Make this one match.
> 
> Core SDIO functions are indeed the other way around, but the IO
> functions in this file use (addr, data) pattern. So should we aim to get
> it all consistent with core SDIO or just consistent on its own.

This is preparatory for a later patch that removes this abstraction
altogether, so yes, it should match the SDIO order.

-Ian
