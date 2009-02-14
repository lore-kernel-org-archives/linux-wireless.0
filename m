Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:60539 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZBNDIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 22:08:24 -0500
Received: by yx-out-2324.google.com with SMTP id 8so732411yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 19:08:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49962FC9.2040406@erley.org>
References: <1925ef8a0902130015o6df0c962n3fe05ec420d0aef@mail.gmail.com>
	 <43e72e890902130023w3c192b04r3a41b4643eedb530@mail.gmail.com>
	 <1925ef8a0902130454i7b72a7fftb13cc6b77413b70c@mail.gmail.com>
	 <43e72e890902131449n153b606fne9a6dba1af071915@mail.gmail.com>
	 <49962FC9.2040406@erley.org>
Date: Fri, 13 Feb 2009 19:08:21 -0800
Message-ID: <43e72e890902131908n3ca09f43w9ac5165b3f03ac66@mail.gmail.com> (sfid-20090214_040835_896443_54FAEA1C)
Subject: Re: compat-wireless with CONFIG_MAC80211disabled
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: pat-lkml <pat-lkml@erley.org>
Cc: Vitja Makarov <vitja.makarov@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 6:43 PM, pat-lkml <pat-lkml@erley.org> wrote:
> Luis R. Rodriguez wrote:
>> On Fri, Feb 13, 2009 at 4:54 AM, Vitja Makarov <vitja.makarov@gmail.com> wrote:
>>> This should be problem for 2.6.27 too.
>>
>> modified for 27 and applied, thanks
>
> I didn't run into this problem with 2.6.28-gentoo-r1... I've been running
> compat-wireless from git since the 4th on this kernel, with no mac80211
> enabled and had no problems.

Oh interesting, because skb->do_not_encrypt was there on 27, and
skb->requeue was added as of 28. Since config.mk was enforcing it to
be enabled and since compat-wireless uses its own
include/linux/compat_autoconf.h with values derived from config.mk
when building compat-wireless you were getting

#define CONFIG_MAC80211 1

and therefore compat-wireless did build correctly assuming your
kernel's skb_buff had skb->do_not_encrypt and skb->requeue although
the reality of it is that it didn't therefore probably forcing
mac80211 to mess around with other nearby fields in the skb_buff like
the skb->dma_cookie, skb->secmark or skb->mark, depending on whether
CONFIG_NET_DMA, CONFIG_NETWORK_SECMARK or neither were enabled
respectively.

So it seems it was working by chance as your kernel's skbs were being
raped by mac80211 in their sleep.

> Is there interest in a patch allowing you to
> set something like FORCE=y on the CLI to override these patches?

Do you have CONFIG_NET_DMA?
If not do you have CONFIG_NETWORK_SECMARK?

It'd be interesting to see what net core is doing due to the rape and
it'd be even more interesting if we can determine the rape is allowed
during certain circumstances, therefore allowing us to hack config.mk
to allow for such atrocities to go on.

 Luis
