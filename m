Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37857 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055Ab0DGIaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 04:30:04 -0400
Date: Wed, 7 Apr 2010 10:29:59 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Pavel Roskin <proski@gnu.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org
Subject: Re: [PATCH v2] crypto: add blkcipher implementation of ARC4
Message-ID: <20100407082959.GC6619@Chamillionaire.breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
 <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc>
 <20100405084209.GA16788@gondor.apana.org.au>
 <20100405170406.GA24215@Chamillionaire.breakpoint.cc>
 <1270621195.31184.45.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1270621195.31184.45.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Pavel Roskin | 2010-04-07 02:19:55 [-0400]:

>On Mon, 2010-04-05 at 19:04 +0200, Sebastian Andrzej Siewior wrote:
>
>> +module_init(arc4_init);
>> +module_exit(arc4_exit);
>
>I'm feelings uneasy about using the same module init/exit functions
>names in arc4blk.c and arc4cip.c.
>
>Even though it doesn't break for me on x86_64 (whether I'm compiling
>modules or a solid kernel), and even though the potential name conflict
Take a look at
- sd_mod_init
- via_init
- watchdog_init

just to name a few. There is no conflict because those functions are not
global. The only problem you have is in the backtrace since you can't
distinguish them.

Sebastian
