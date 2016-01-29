Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:37447 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbcA2DQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 22:16:00 -0500
Message-ID: <1454037358.30708.1.camel@ellerman.id.au> (sfid-20160129_041627_271566_658BE256)
Subject: Re: [PATCH 3/3] param: convert some "on"/"off" users to strtobool
From: Michael Ellerman <mpe@ellerman.id.au>
To: Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org, Joe Perches <joe@perches.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Steve French <sfrench@samba.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2016 14:15:58 +1100
In-Reply-To: <1453990627-19164-4-git-send-email-keescook@chromium.org>
References: <1453990627-19164-1-git-send-email-keescook@chromium.org>
	 <1453990627-19164-4-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-28 at 06:17 -0800, Kees Cook wrote:

> This changes several users of manual "on"/"off" parsing to use strtobool.

You should probably point out that it's a slight behaviour change for some
users. ie. parameters that previously *only* worked with "on"/"off", can now
also take 0/1/y/n etc.

But I don't think that's a show stopper.


> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: x86@kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-s390@vger.kernel.org
> ---
>  arch/powerpc/kernel/rtasd.c                  | 10 +++-------
>  arch/powerpc/platforms/pseries/hotplug-cpu.c | 11 +++--------

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)


cheers

