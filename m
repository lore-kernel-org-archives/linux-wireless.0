Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35637 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761183AbZLJSey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 13:34:54 -0500
Received: by ewy19 with SMTP id 19so153304ewy.21
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2009 10:35:00 -0800 (PST)
Message-ID: <4B213F4D.2000707@gmail.com>
Date: Thu, 10 Dec 2009 18:34:53 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] orinoco: fix GFP_KERNEL in orinoco_set_key with interrupts
 disabled
References: <200912101955.01325.arvidjaar@mail.ru>
In-Reply-To: <200912101955.01325.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> I had to resurrect old notebook and immediately hit this under 2.6.32:
> 
> [   77.254109] WARNING: at /home/bor/src/linux-git/kernel/lockdep.c:2465 
> lockdep
> _trace_alloc+0x9a/0xa0()
> 
> Until orinoco_lock can be converted from spinlock into mutex, this patch 
> is the most simple solution.

Thank you Andrey. The patch is correct (though it could clean up the
misdirected comment 4 or 5 lines above).

Is it worth pushing this to stable?


Dave.
