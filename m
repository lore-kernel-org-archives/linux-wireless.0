Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49654 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab2HFTHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:07:42 -0400
Received: by obbuo13 with SMTP id uo13so6284071obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:07:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502011EA.90507@hauke-m.de>
References: <1343924881-31418-1-git-send-email-hauke@hauke-m.de>
 <CAB=NE6Wj3tFVUWNTE1dDk2VopeqPvc4g57hwaETQQR4vA=tcJA@mail.gmail.com> <502011EA.90507@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Aug 2012 12:07:21 -0700
Message-ID: <CAB=NE6WbBFhcAJ7HeNGmLSrX1ydKTnokZT3mzrrjjE8SLW-Xgg@mail.gmail.com> (sfid-20120806_210745_691233_47BB2A99)
Subject: Re: [PATCH 1/2] compat: remove backport of irq_modify_status
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 11:50 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 08/06/2012 08:33 PM, Luis R. Rodriguez wrote:
>> On Thu, Aug 2, 2012 at 9:28 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>> Only kernel >= 2.6.39 irq_to_desc or irq_desc are exporting, so that
>>> compat is not able to access this on the kernel versions where it is
>>> needed. irq_to_desc and irq_desc are defined in the header files so
>>> compilation works, but the module is not loadable because of the
>>> missing exported symbol which make compat unusable on all these kernel
>>> versions. Remove this function, no driver seams to need it.
>>>
>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>
>> Thanks, if you look at my patch 3e3c23e042 on compat.git it says that
>> I added this stuff due to the patch that is now merged on linux.git
>> ee9c8a04 -- wl1251: fix oops on early interrupt. That patch was a
>> stable fix merged down to v3.4.6. The implications of your tests are
>> that wl1251 must be disabled on older kernel or another equivalent
>> stable fix must be backported for that driver into
>> compat-wireless.git.
>>
>> I frankly have too much patch catching up to so I cannot take care of
>> this right now so what I will do is disable wl1251 on the updated
>> stable releases for kernels older than v2.6.38 which require all this
>> backport work. I welcome patches to properly backpor this though.
>>
>> I should point out too that this patch was a linux-next.git patch that
>> got marked as stable and once merged onto v3.4.6 it required a *new*
>> backport change that was not required on a release based on v3.4.5.
>> This means that *any* stable fix on older kernels could potentially
>> regress stable compat releases. The only way to not regress stable
>> compat releases then is if there is no delta from the pulled upstream
>> code as there is no gaurantee a stable fix did not implement usage of
>> a feature implemented or available only on certain newer kernels.
>>
>> Luca, for what kernels do you guys really need wl1251 enabled for?
>>
>>   Luis
>>
> Hi Luis,
>
> I later tried to deactivate wl1251, but is was already deactivated for
> such old kernel versions so there is nothing to do any more after this
> patch is applied. Somehow compat contained a not so god backport and
> compat-wireless contained this patch:
>
> commit 0a374b9445c78a8e90495bd7d4be00a4f67f2b9b
> Author: Hauke Mehrtens <hauke@hauke-m.de>
> Date:   Wed May 30 00:39:37 2012 +0200
>
>     compat-wireless: deactivate wl1251 for kernel < 2.6.37
>
>     wl1251_sdio and wl1251_spi are depending on irq_set_status_flags() since
>
> It looks like you tried to backport irq_modify_status() and I
> deactivated the users of this function. ;-)

Heh thanks, in that case closed for this change. Thanks!

  Luis
