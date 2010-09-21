Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:47117 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0IUTt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:49:56 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Patch to get iw building on Fedora 8
References: <4C98DFB6.10902@candelatech.com>
Date: Tue, 21 Sep 2010 21:49:55 +0200
In-Reply-To: <4C98DFB6.10902@candelatech.com> (Ben Greear's message of "Tue,
	21 Sep 2010 09:39:18 -0700")
Message-ID: <m2wrqej2qk.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> writes:

> I need this in order to get iw to build on Fedora 8.
>
> [greearb@fs2 iw]$ git diff
> diff --git a/bitrate.c b/bitrate.c
> index 8de8839..9b6defc 100644
> --- a/bitrate.c
> +++ b/bitrate.c
> @@ -1,4 +1,6 @@
>  #include <errno.h>
> +#define  __USE_ISOC99

This is wrong.  You must never define internal glibc macros.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
