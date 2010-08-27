Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:43193 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab0H0Vxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 17:53:40 -0400
Date: Fri, 27 Aug 2010 14:53:16 -0700
From: Jean Tourrilhes <jt@hpl.hp.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wireless: fix 64K kernel heap content leak via ioctl
Message-ID: <20100827215316.GA32405@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20100827210240.GC4703@outflux.net> <20100827212254.GB32275@bougret.hpl.hp.com> <20100827214357.GE4703@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100827214357.GE4703@outflux.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 02:43:57PM -0700, Kees Cook wrote:
> Hi Jean,
> 
> The comment should probably be clarified -- it's the caller's iwp->length
> that may be causing problems

	Ha ! I see. It would be for regular iwpoint queries, not for
extended NOMAX queries (scan is a extended NOMAX query).
	Note that I don't like the idea of reducing the mallocated
size, especially with regular queries, as I know that some driver may
expect a fixed size in extra and may memcpy to it without double
checking.

> Regardless, the above patch would appear to limit the copy_to_user
> to only the kzalloced region.

	I'm glad you like it.

> Thanks!
> 
> -Kees

	Regards,

	Jean
