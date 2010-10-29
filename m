Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39008 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0J2A57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 20:57:59 -0400
Received: by iwn10 with SMTP id 10so2964946iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 17:57:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CCA0B26.5010008@openwrt.org>
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3> <20101005131744.GB4074@tuxdriver.com>
 <20101005195039.GD11831@tux> <AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com>
 <4CB0890D.3050208@openwrt.org> <4CCA0908.6000105@candelatech.com> <4CCA0B26.5010008@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Oct 2010 17:57:37 -0700
Message-ID: <AANLkTinu4_EcvzgS6AhxRYtSg=y=iwfcFtk0AhgOK-bS@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma descriptors
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 28, 2010 at 4:45 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-10-29 1:36 AM, Ben Greear wrote:
>> On 10/09/2010 08:23 AM, Felix Fietkau wrote:
>>> On 2010-10-09 5:19 PM, Björn Smedman wrote:
>>>> On Tue, Oct 5, 2010 at 9:50 PM, Luis R. Rodriguez
>>>> <lrodriguez@atheros.com>  wrote:
>>>>> Felix is more familiar with this area so I'll let him chime with
>>>>> his ACK/NACK.
>>>>>
>>>>>   Luis
>>>>
>>>> So Felix, what do you think? I realize it may not be a common problem
>>>> on any currently popular platform, but don't you agree it is in
>>>> principle unsafe to write to the ds_link field of dma descriptors
>>>> without a guarantee that those writes will be performed in the
>>>> intended order?
>>> Haven't had time to review this in detail yet. I'll take another look at
>>> it later...
>>
>> Had a chance to look at it?  I've been carrying this in my
>> tree and it hasn't caused any obvious problems, for what that's
>> worth...
> Not sure if the patch helps with anything, but I think it can go in...

I'd rather not add it if its not fixing anything. I hate code that is
there just because we have a fuzzy feeling it helps.

So NACK unless it fixes something.

 Luis
