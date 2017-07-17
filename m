Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49504 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbdGQSbc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 14:31:32 -0400
Subject: Re: BUG: brcmfmac: add firmware feature detection for gscan feature
 breaks 43430a1
From: Ian Molton <ian@mnementh.co.uk>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <25c47ffe-af3e-fb85-ed5b-ff1987cfd93f@mnementh.co.uk>
Message-ID: <e6635794-7c35-1a46-2d5b-68824c7b0657@mnementh.co.uk> (sfid-20170717_203136_249213_16A63D32)
Date: Mon, 17 Jul 2017 19:31:29 +0100
MIME-Version: 1.0
In-Reply-To: <25c47ffe-af3e-fb85-ed5b-ff1987cfd93f@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/17 18:50, Ian Molton wrote:
> Resent due to subject error. Apologies, Hante :)
> 
> Hi Folks,
> 
> 9fe929aaace6  brcmfmac: add firmware feature detection for gscan feature
> 
> Completely breaks 43430a1 support.

Digging a bit deeper, this would *appear* to be one of a couple of
possibilities;

1) brcmf_sdio_hostmail() is missing code to handle a response of type
   0x40012
2) The firmware is failing when asked to handle the new requiests, and
   is going to la-la land.

Decoding the reply gives us HMB_DATA_DEVREADY or-ed with 0x40010

Since the upper half-word is masked, that leaves us with 0x10 which does
not appear to be a defined state.

The driver does not handle this well, in any event.

My guess is that you are working on top of newer firmware than I have.
Can you let me know what the latest public firmware is, and where I can
get it?

I have version wl0: Aug 29 2016 20:48:16 version 7.45.41.26 (r640327)
FWID 01-4527cfab

Thanks,

-Ian
