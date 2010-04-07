Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15279 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932693Ab0DGQb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 12:31:56 -0400
Subject: Re: [PATCH v2] crypto: add blkcipher implementation of ARC4
From: Pavel Roskin <proski@gnu.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org
In-Reply-To: <20100407082959.GC6619@Chamillionaire.breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
	 <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc>
	 <20100405084209.GA16788@gondor.apana.org.au>
	 <20100405170406.GA24215@Chamillionaire.breakpoint.cc>
	 <1270621195.31184.45.camel@mj>
	 <20100407082959.GC6619@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 12:31:54 -0400
Message-Id: <1270657914.12126.9.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-04-07 at 10:29 +0200, Sebastian Andrzej Siewior wrote:
> * Pavel Roskin | 2010-04-07 02:19:55 [-0400]:
> 
> >On Mon, 2010-04-05 at 19:04 +0200, Sebastian Andrzej Siewior wrote:
> >
> >> +module_init(arc4_init);
> >> +module_exit(arc4_exit);
> >
> >I'm feelings uneasy about using the same module init/exit functions
> >names in arc4blk.c and arc4cip.c.
> >
> >Even though it doesn't break for me on x86_64 (whether I'm compiling
> >modules or a solid kernel), and even though the potential name conflict
> Take a look at
> - sd_mod_init
> - via_init
> - watchdog_init
> 
> just to name a few. There is no conflict because those functions are not
> global. The only problem you have is in the backtrace since you can't
> distinguish them.

Touché :-)

-- 
Regards,
Pavel Roskin
