Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48409 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab0JVP6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:58:08 -0400
Received: by ewy7 with SMTP id 7so1294101ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 08:58:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik_Uj9adCUyOoMyx7t44AReK6yxcv_YLT_+Jm1U@mail.gmail.com>
References: <AANLkTimqQqo2F+UD7j0OUXn_YF3EvkO5z6Njdo-=dhnY@mail.gmail.com>
	<AANLkTik_Uj9adCUyOoMyx7t44AReK6yxcv_YLT_+Jm1U@mail.gmail.com>
Date: Fri, 22 Oct 2010 08:58:06 -0700
Message-ID: <AANLkTi=XU_wmmYfV+dd5yU=ZwjWsm-usxcLY71qCUY_o@mail.gmail.com>
Subject: Re: [PATCH] compat: Fixes missing sem member in struct device for RT
 PREEMPT prior to 2.6.34
From: Blaise Gassend <blaise@willowgarage.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That was a diff against the master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git that I
cloned last night. I produced the patch with git diff. What should I
have diffed against?

Blaise

On Fri, Oct 22, 2010 at 2:36 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Oct 21, 2010 at 10:51 PM, Blaise Gassend
> <blaise@willowgarage.com> wrote:
>> The RT PREEMPT patch eliminates the sem member in struct device
>> breaking device_lock, device_unlock and device_trylock in kernels
>> prior to 2.6.34. The attached patch replaces the use of sem by a use
>> of mutex.
>>
>> Signed-off-by: Blaise Gassend <blaise@willowgarage.com>
>
> Alright, nice, thanks! Patch applied and I also propagated it to the
> linux-2.6.36.y branch so that we can get this fix for the
> compat-wireless-2.6.36 release as well. I should note your patch did
> not apply as the offsets were way off but I did just read the patch
> and merged it manually. What version of compat were you using?
>
>  Luis
>
