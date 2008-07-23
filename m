Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:44847 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYGWUmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 16:42:52 -0400
Received: by ug-out-1314.google.com with SMTP id h2so543203ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 13:42:49 -0700 (PDT)
Date: Wed, 23 Jul 2008 22:43:35 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080723204335.GA14788@ami.dom.local> (sfid-20080723_224324_464090_562B0E1A)
References: <1216810696.7257.175.camel@twins> <20080723113519.GE4561@ff.dom.local> <20080723114914.GF4561@ff.dom.local> <20080723.131607.79681752.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080723.131607.79681752.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 01:16:07PM -0700, David Miller wrote:
...
> There will always be a need for a "stop all the TX queues" operation.

The question is if the current way is "all correct". As a matter of
fact I think Peter's doubts could be justified: taking "USHORT_MAX"
locks looks really dubious (so maybe it's not so strange lockdep
didn't get used to this).

Jarek P.
