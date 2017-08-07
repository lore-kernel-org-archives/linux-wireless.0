Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:34074 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751799AbdHGRtI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 13:49:08 -0400
Subject: Re: [PATCH 03/34] brcmfmac: Split brcmf_sdiod_regrw_helper() up.
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-4-ian@mnementh.co.uk> <59884E31.8090205@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <ce1fbd40-23a3-fdf7-ec94-cd2a63e7a64d@mnementh.co.uk> (sfid-20170807_194912_568943_BA6186D8)
Date: Mon, 7 Aug 2017 18:49:05 +0100
MIME-Version: 1.0
In-Reply-To: <59884E31.8090205@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 12:25, Arend van Spriel wrote:
> On 26-07-17 22:25, Ian Molton wrote:
>>     This large function is concealing a LOT of obscure logic about
>> how the hardware functions. Time to split it up.
>>
>> This first patch splits the function into two pieces - read and write,
>> doing away with the rw flag in the process.
> 
> I really don't this it is all that obscure, but alas. Everything is in
> the eye of the beholder. The reason for having the helper was to not
> duplicate code for read and write and different access sizes. So now you
> are duplicating it. In subsequent patches you throw away pieces of this
> helper so duplication is not as bad in the net result. It would have
> been easier if those patches were done before this one.

I agree, this is a big and unwieldy patchset - I've attempted to break
the thing down in such a way that all the steps leading to the end
result are at least sane. I initially did it all in one hit and it was
utterly illegible :-(


> Fix the indent and column align to opening bracket.

I guess a few of these got through. I blame git rebase :)

-Ian
