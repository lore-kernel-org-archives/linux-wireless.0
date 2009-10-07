Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:8327 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbZJGT3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 15:29:32 -0400
Received: by ey-out-2122.google.com with SMTP id 4so1099278eyf.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 12:28:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com>
References: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com>
Date: Wed, 7 Oct 2009 20:28:24 +0100
Message-ID: <3ace41890910071228i786d4097w69dc7a3dfeb64afe@mail.gmail.com>
Subject: Re: NULL pointer deref at wext ioctl (Re: [PATCH] compat-2.6: adding
	ethtool.h to compat-2.6.31.h)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 7, 2009 at 8:16 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:

> It is probably just a transient problem with recent activities - I had
> a NULL pointer deref from loading rtl8187 of compat-wireless
> v2.6.32-rc3-39563-g98c2609 -
>
> BUG: unable to handle kernel NULL pointer dereference at 000000000000003d
> IP: [<ffffffff8147822c>] wext_ioctl_dispatch+0xd9/0x180
> PGD 61c2b067 PUD 6246f067 PMD 0
> Oops: 0000 [#1] SMP
> ...
> Call Trace:
>  [<ffffffff814783f5>] wext_handle_ioctl+0x4d/0x98
>  [<ffffffff813e53a5>] dev_ioctl+0x625/0x662
>  [<ffffffff813cfa45>] sock_ioctl+0x225/0x248
>  [<ffffffff811237a3>] vfs_ioctl+0x31/0xaa
>  [<ffffffff811e1801>] ? security_d_instantiate+0x37/0x4d
>  [<ffffffff81123c88>] do_vfs_ioctl+0x46c/0x4c3
>  [<ffffffff81123d44>] sys_ioctl+0x65/0x9c
>  [<ffffffff81012082>] system_call_fastpath+0x16/0x1b
>
> I'm sure whatever changes made this happen will go away soon, so I'll
> just re-try in a few days... but if anybody knows what commit causes
> this (and what fixes it!), I'd like to know.
>

Hiya, It looks like I last used compat-wireless successfully was on
25th (I am not saying it breaks after - I just haven't tried until
yesterday, possibly), and most of the recent changes are per-driver,
but there is a big code drop from Johannes dated 27th on 'wext:
refactor' . Changes from that or dependent changes?
