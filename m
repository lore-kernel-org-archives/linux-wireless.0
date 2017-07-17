Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:34477 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdGQMlv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 08:41:51 -0400
Received: by mail-qk0-f181.google.com with SMTP id d78so118714651qkb.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 05:41:50 -0700 (PDT)
Subject: Re: RFC: Broadcom fmac wireless driver cleanup
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170716112129.10206-1-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <72fae7cb-7db0-4979-8e4b-cf26c557634a@broadcom.com> (sfid-20170717_144155_077033_500ACA44)
Date: Mon, 17 Jul 2017 14:41:46 +0200
MIME-Version: 1.0
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-07-17 13:21, Ian Molton wrote:
> Hi folks,
> 
> I've been doing some cleanups in the broadcome brcmfmac driver, trying to
> understand how it works.
> 
> I think this makes the driver a *lot* more readable.

Everyone is entitled to his own opinion. While skimming the patches
terms like horrid, abomination, brain damaged does not really get me
motivated in reviewing it let alone accepting it. Especially when I just
start my vacation, but you could not have known ;-)

> Of note:
> 
> * Gets rid of the arbitrary and completely 1:1 mapping of
>  struct brcmf_{core,chip}_priv/struct brcmf_{core,chip} structures
>  which add unreadability whilst offering no real seperation.

It is maybe 1:1 but it assures that whatever is in the priv structures
in only accessible in chip.c. Why would that not offer any real separation.

> * The patch titled HACK - stabilise the value of ->sbwad in use
>  highlights an issue that is either bizarre undocumented behaviour or a
>  genuine bug - without datasheets, I dont know. Essentially the value of sbwad
>  is taken as the base address in several functions, even though it is subject
>  to change should other IO occur that moves the window offset

Ok. This needs to be looked at, but as I recall sbwad is only changing
when needed. All IO occurs under claimed host lock so I don't expect
there is a bug here, but will look at it more closely.

> Obviously this is a first cut at this and needs substantial cleanup itself,
> however I wanted to get some idea of wether I should continue working on this.

Now this is where a commit message would really help to explain your
train of thought. What is obvious to you, may not be to others. For
instance changing the order of parameters in a function is simply absurd
although that is my opinion.

> I only have a 43430 SDIO WiFi / BT chip to test on, but other chips *should*
> be unaffected by these changes.

I have a decent amount of SDIO chipsets so count on it that I will run
this patch series when I return from my vacation.

I just noticed some earlier reactions and it seems your are easily
offended starting to use *star* quotes. No need to start shouting. There
is stuff in there that I am happy to acknowledge, but some I think is a
matter of taste. Although mostly there are no arguments given to get the
discussion going. I am sure you have them in mind so don't qualm and
just spew them.

Regards,
Arend
