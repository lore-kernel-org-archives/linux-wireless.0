Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40477 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1KQTaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 14:30:10 -0500
Received: by fagn18 with SMTP id n18so3377258fag.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 11:30:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321544493-2238-1-git-send-email-linville@tuxdriver.com>
References: <1321544493-2238-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Thu, 17 Nov 2011 11:29:47 -0800
Message-ID: <CAB=NE6WsN_SvwRavm4SyTobBvNwExzRWa45Yn7wsn0CYDNcJdQ@mail.gmail.com> (sfid-20111117_203023_910163_E2C44B8E)
Subject: Re: [PATCH] compat-wireless: support RHEL6 as a build target
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2011 at 7:41 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> This patch enables compatibility with RHEL6 as a build target.

:) !

>  This
> mostly includes changes to the configuration system, as well as a
> modification of an existing patch for the bluetooth subsystem.
>
> Infrastructure is added to config.mk to provide a series of RHEL
> compatibility definitions (e.g. CONFIG_COMPAT_RHEL_6_1).  Also, this
> provides some new CONFIG_* definitions needed to provide for build
> flexibility required to support RHEL6:
>
>        CONFIG_COMPAT_KFIFO
>        CONFIG_COMPAT_FIRMWARE_DATA_RW_NEEDS_FILP
>        CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN

I hate to ask but can these be dealt with as separate patches?

> Further, CONFIG_COMPAT_FIRMWARE_CLASS has it's leading space removed in
> config.mk so that it will be reflected in compat_autoconf.h as required.

And this one too?

> The latter two definitions also lack leading whitespace for the same
> reason.
>
> Finally, gen-compat-autoconf.sh is modified to correctly handle the
> CONFIG_COMPAT_RHEL_* usage in config.mk.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

If too lazy I'll just merge, but it would make it easier to review /
debug if we have issues later.

  Luis
