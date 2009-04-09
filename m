Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:65314 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933712AbZDIKh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 06:37:57 -0400
Received: by ewy9 with SMTP id 9so600328ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2009 03:37:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DD149B.2060300@lwfinger.net>
References: <20090408182021.GA4112@aragorn.home.lxtec.de>
	 <200904082050.00327.mb@bu3sch.de> <49DCF537.8000702@lwfinger.net>
	 <20090408192634.GB3717@samweis.home.lxtec.de>
	 <49DD149B.2060300@lwfinger.net>
Date: Thu, 9 Apr 2009 12:37:54 +0200
Message-ID: <2d0a357f0904090337q5a97240bo417428b8952c9e93@mail.gmail.com> (sfid-20090409_123817_084251_149AB997)
Subject: Re: Problems with 2.6.30-rc1
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46YI: For Linux-2.6.30-rc1 vanilla kernel users

In the meantime Andreas Schwab's Patch is applied into Rusty Russell's
"linux-2.6-module-and-param.git" GIT-branch (see [0], [1] and [2]):

"module: fix try_then_request_module"

Impact: fix wireless modules, broken by acae05156551fd7528fbb616271e672=
789388e3c

=46ix try_then_request_module to use waiting __request_module again.

Hope this patch will be applied to Linus GIT-tree soon.

-- Sedat

[0] http://marc.info/?l=3Dlinux-kernel&m=3D123924185913668&w=3D2
[1] module: fix try_then_request_module Patch
http://git.kernel.org/?p=3Dlinux/kernel/git/rusty/linux-2.6-module-and-=
param.git;a=3Dcommit;h=3D8188c26f4bdd6ea8ae9f018e24ee8609394020f4
[2] Browesable GIT-branch:
http://git.kernel.org/?p=3Dlinux/kernel/git/rusty/linux-2.6-module-and-=
param.git;a=3Dsummary


On Wed, Apr 8, 2009 at 11:18 PM, Larry Finger <Larry.Finger@lwfinger.ne=
t> wrote:
>
> If you are having problems with wireless networking using 2.6.30-rc1 =
from
> Linus's Linux-2.6 git tree, the fix is the following (Note: This is _=
NOT_ needed
> for wireless-testing!!!):
>
> ---
> Fix try_then_request_module to use waiting __request_module again.
>
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
> =C2=A0include/linux/kmod.h | =C2=A0 =C2=A02 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6.30-rc1/include/linux/kmod.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.30-rc1.orig/include/linux/kmod.h =C2=A02009-04-08 12:47=
:54.000000000 +0200
> +++ linux-2.6.30-rc1/include/linux/kmod.h =C2=A0 =C2=A0 =C2=A0 2009-0=
4-08 17:39:35.000000000 +0200
> @@ -34,7 +34,7 @@ extern int __request_module(bool wait, c
> =C2=A0#define request_module(mod...) __request_module(true, mod)
> =C2=A0#define request_module_nowait(mod...) __request_module(false, m=
od)
> =C2=A0#define try_then_request_module(x, mod...) \
> - =C2=A0 =C2=A0 =C2=A0 ((x) ?: (__request_module(false, mod), (x)))
> + =C2=A0 =C2=A0 =C2=A0 ((x) ?: (__request_module(true, mod), (x)))
> =C2=A0#else
> =C2=A0static inline int request_module(const char *name, ...) { retur=
n -ENOSYS; }
> =C2=A0static inline int request_module_nowait(const char *name, ...) =
{ return -ENOSYS; }
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
