Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaKKNJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 08:09:10 -0500
Date: Tue, 11 Nov 2014 14:06:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Mark Asselstine <asselsm@gmail.com>,
	"Antti S. Lankila" <alankila@bel.fi>
Subject: Re: [PATCH] rt2x00: do not align payload on modern H/W
Message-ID: <20141111130605.GA2892@redhat.com> (sfid-20141111_140917_550278_0B321B84)
References: <20141102123846.GB9242@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141102123846.GB9242@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 02, 2014 at 01:38:47PM +0100, Stanislaw Gruszka wrote:
> RT2800 and newer hardware require padding between header and payload if
> header length is not multiple of 4.
> 
> For historical reasons we also align payload to to 4 bytes boundary, but
> such alignment is not needed on modern H/W.
> 
> Patch improve performance on embedded CPUs and _possibly_ fixes
> skb_under_panic problems reported from time to time:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=84911
> https://bugzilla.kernel.org/show_bug.cgi?id=72471
> http://marc.info/?l=linux-wireless&m=139108549530402&w=2
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1087591
> 
> But we can not explain or otherwise confirm the patch fixes this panic
> issue for sure.

Antti on https://bugzilla.kernel.org/show_bug.cgi?id=72471 tested patch
and confirm it fixes the panic, he also provided traces showing that we
really eat headroom on each retransmission in some special case - no
payload and header length not being multiple of 4.

Taking that and since this patch was not yet applied I'll repost it with
updated changelog and direct to 3.18 stream and -stable.

Stanislaw

