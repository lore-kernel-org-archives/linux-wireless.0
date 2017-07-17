Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:36942 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751335AbdGQP4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 11:56:03 -0400
Subject: Re: RFC: Broadcom fmac wireless driver cleanup
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170716112129.10206-1-ian@mnementh.co.uk>
 <72fae7cb-7db0-4979-8e4b-cf26c557634a@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <97ac668c-fef4-37be-06e1-0135dea77527@mnementh.co.uk> (sfid-20170717_175608_018687_68E6A1F9)
Date: Mon, 17 Jul 2017 16:56:00 +0100
MIME-Version: 1.0
In-Reply-To: <72fae7cb-7db0-4979-8e4b-cf26c557634a@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/17 13:41, Arend van Spriel wrote:
>> * Gets rid of the arbitrary and completely 1:1 mapping of
>>  struct brcmf_{core,chip}_priv/struct brcmf_{core,chip} structures
>>  which add unreadability whilst offering no real seperation.
> It is maybe 1:1 but it assures that whatever is in the priv structures
> in only accessible in chip.c. Why would that not offer any real separation.

Ok, I'm going to keep this to technical points from now on, everyones
had a chance to say how they feel about it now :)

To address your specific comment above - "Why would that not offer any
real separation"

The two structures *always* exist together. And yes, preventing access
to the members that we don't want accessed from the wrong layer would
be *possibly* worthwhile, however the driver code as it stands
*constantly* short circuits that with the use of offsetof().

This makes any minimal protection against poor coding practice
completely irrelevant, at the same time as making the code unreadable.

If the separation is to stay, it needs to be re-written such that
offsetof() is not required throughout the code.

I've re-done my patchset, which I'll resubmit in just a moment.

My preferred solution is still removal, as nothing outside this driver
will ever touch these structures anyway, so all they are doing, other
than making the code impossible to maintain, is protecting us from no-one.

-Ian
