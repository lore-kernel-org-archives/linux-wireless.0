Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:38992 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752357AbdHSUbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 16:31:31 -0400
Subject: Re: [PATCH 29/34] brcmfmac: stabilise the value of ->sbwad in use for
 some xfer routines.
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-30-ian@mnementh.co.uk> <59885DC2.6040600@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <139a4c30-c0df-8a9c-2eac-6cd888238038@mnementh.co.uk> (sfid-20170819_223134_633668_26A5B470)
Date: Sat, 19 Aug 2017 21:31:29 +0100
MIME-Version: 1.0
In-Reply-To: <59885DC2.6040600@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 13:32, Arend van Spriel wrote:
> 
> We actually just need the chipcommon base address so why not have that
> here, ie.:
> +    u32 cc_base;

I see no advantage to that - the u32 is the same size as (or not much
bigger than the pointer to the struct brcmf_core, and my approach makes
it clear where the value came from rather than making another copy of it.

> Another option is to simple use SI_ENUM_BASE as the chipcommon base
> address will always be 0x18000000 for the SDIO chips.

I don't like this approach. Why bother probing the core if we then dont
use the values returned? May as well hard code everything... Also not
futureproof.

-Ian
