Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55730 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137AbZJBUsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:48:23 -0400
Received: by iwn8 with SMTP id 8so804947iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2009 13:48:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ac55601.EpUUwD1vnjBKSXDy%Larry.Finger@lwfinger.net>
References: <4ac55601.EpUUwD1vnjBKSXDy%Larry.Finger@lwfinger.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 2 Oct 2009 13:48:07 -0700
Message-ID: <43e72e890910021348g2054234ew88167df1a7c75e0d@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: Fix the bleeding-edge version to build
	on 2.6.27
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 1, 2009 at 6:23 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> I checked these patches on 2.6.27 and 2.6.31, but not for the intermediate
> releases.

That works for me thanks, applied with some minor modifications.

> Index: compat-wireless-2009-09-05/include/net/compat-2.6.28.h
> ===================================================================
> --- compat-wireless-2009-09-05.orig/include/net/compat-2.6.28.h
> +++ compat-wireless-2009-09-05/include/net/compat-2.6.28.h


> Index: compat-wireless-2009-09-05/net/wireless/compat-2.6.28.c
> ===================================================================
> --- compat-wireless-2009-09-05.orig/net/wireless/compat-2.6.28.c
> +++ compat-wireless-2009-09-05/net/wireless/compat-2.6.28.c

Just a heads up, I don't keep these file at include/net or
net/wireless on my git tree, instead I stash them into compat/. The
./scripts/admin-update.sh then is used to cp then. I did this to make
it clear that the compat stuff comes from outside.

> Index: compat-wireless-2009-09-05/net/wireless/scan.c
> ===================================================================
> --- compat-wireless-2009-09-05.orig/net/wireless/scan.c
> +++ compat-wireless-2009-09-05/net/wireless/scan.c
> @@ -499,8 +499,10 @@ cfg80211_inform_bss(struct wiphy *wiphy,
>
>        kref_init(&res->ref);
>
> +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
>        /* cfg80211_bss_update() eats up res - we ensure we free it there */
>        kmemleak_ignore(res);
> +#endif

And this hunk should no longer be present on bleeding edge.

Thanks!

  Luis
