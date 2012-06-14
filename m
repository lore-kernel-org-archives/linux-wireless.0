Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45794 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab2FNTwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 15:52:03 -0400
Received: by obbtb18 with SMTP id tb18so2843584obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 12:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFub=KTfG_D9HC_7gHELmiEROBnFbr5WrxLe5YDkfN-NaSw-Bw@mail.gmail.com>
References: <1339696366-26970-1-git-send-email-ozancag@gmail.com> <CAFub=KTfG_D9HC_7gHELmiEROBnFbr5WrxLe5YDkfN-NaSw-Bw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 14 Jun 2012 12:51:42 -0700
Message-ID: <CAB=NE6WEu8TfZjPARKwuLEKnbJjSaYFfx+MhFi2vHzm6kBcHog@mail.gmail.com> (sfid-20120614_215207_751466_DD8CC66E)
Subject: Re: [PATCH 1/3] compat: Backport vga_switcheroo_client_ops
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
	Dave Airlie <airlied@redhat.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 14, 2012 at 10:57 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> On Thu, Jun 14, 2012 at 8:52 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>> This backports:
>>
>>  From 26ec685ff9d9c16525d8ec4c97e52fcdb187b302 Mon Sep 17 00:00:00
>>
>>  From: Takashi Iwai <tiwai@suse.de>
>>  Date: Fri, 11 May 2012 07:51:17 +0200
>>  Subject: [PATCH] vga_switcheroo: Introduce struct vga_switcheroo_client_ops
>>
>>  only for kernels >= 2.6.34 in which vga_switcheroo is available.
>
> Do you accept conditional additions like this into compat? If not,
> what is the proper way of doing this?

Sure thing, we do this in numerous places, good stuff!

> Another question, the vga_switcheroo.h which is included here for the
> enum declaration is not guarded against multiple inclusion. So when
> building compat-drm/drm/i915, I get nested declaration error. I looked
> at other headers and they are all guarded, so I sent a patch to
> dri-devel which adds ifndef guard in vga_switcheroo.h. Is this the
> correct way of fixing a second inclusion of an header file which gets
> already included through compat?

Sure thing, the upstream version should have had that check, thanks
for sending that upstream!

I should also note though for future development if you run into a
header that is *not* present on older kernels but you want to bring
forward for older kernels *but* you do not want that compat header to
replace the one on newer kernels you can do something like this (this
is include/linux/kfifo.h on compat.git):

#include <linux/version.h>
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
#include_next <linux/kfifo.h>
#else

/* the rest of the foo kfifo.h */

#endif
#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)) */

In your case you do not seem to need this given that you are not
bringing forward switcheroo to older kernels, but if you could you may
be able to pull it off using a hack like the above.

  Luis
