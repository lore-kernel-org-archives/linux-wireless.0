Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47212 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2FNR5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 13:57:42 -0400
Received: by yenl2 with SMTP id l2so1167852yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 10:57:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339696366-26970-1-git-send-email-ozancag@gmail.com>
References: <1339696366-26970-1-git-send-email-ozancag@gmail.com>
Date: Thu, 14 Jun 2012 20:57:41 +0300
Message-ID: <CAFub=KTfG_D9HC_7gHELmiEROBnFbr5WrxLe5YDkfN-NaSw-Bw@mail.gmail.com> (sfid-20120614_195744_637082_92E608E0)
Subject: Re: [PATCH 1/3] compat: Backport vga_switcheroo_client_ops
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 14, 2012 at 8:52 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> This backports:
>
>  From 26ec685ff9d9c16525d8ec4c97e52fcdb187b302 Mon Sep 17 00:00:00
>
>  From: Takashi Iwai <tiwai@suse.de>
>  Date: Fri, 11 May 2012 07:51:17 +0200
>  Subject: [PATCH] vga_switcheroo: Introduce struct vga_switcheroo_client_ops
>
>  only for kernels >= 2.6.34 in which vga_switcheroo is available.

Do you accept conditional additions like this into compat? If not,
what is the proper way of doing this?

Another question, the vga_switcheroo.h which is included here for the
enum declaration is not guarded against multiple inclusion. So when
building compat-drm/drm/i915, I get nested declaration error. I looked
at other headers and they are all guarded, so I sent a patch to
dri-devel which adds ifndef guard in vga_switcheroo.h. Is this the
correct way of fixing a second inclusion of an header file which gets
already included through compat?

Thanks :)



-- 
Ozan Çağlayan
