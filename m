Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57203 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbbCCTQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 14:16:59 -0500
Message-ID: <1425410210.2450.51.camel@sipsolutions.net> (sfid-20150303_201727_450037_7AB6C9C5)
Subject: Re: [PATCH net-next 13/14] wireless: Use eth_<foo>_addr instead of
 memset
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2015 20:16:50 +0100
In-Reply-To: <20150303.135737.630359651880852880.davem@davemloft.net>
References: <cover.1425354527.git.joe@perches.com>
	 <0c710456e4875ff00c1a9fcff9378ed15110dcd3.1425354528.git.joe@perches.com>
	 <1425370617.2450.3.camel@sipsolutions.net>
	 <20150303.135737.630359651880852880.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-03 at 13:57 -0500, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Tue, 03 Mar 2015 09:16:57 +0100
> 
> > Other than that, I guess I'll apply this, but I really wish there was a
> > way to distinguish more easily which of these require alignment and
> > which don't.
> 
> You can't apply "this" without the dependency patch #1.

Actually, this is the first time I see patch #1, but since it depends on
HAVE_EFFICIENT_UNALIGNED_ACCESS it doesn't really matter, the functions
already exist.

I'm not even sure that the memset in patch #1 really gets more efficient
with the u32/u16 write (and if it does, why doesn't the compiler know
it) so I guess I'm not even sure I see much point in patch #1, but that
doesn't really matter.

Anyway, I don't mind if you want to take this directly either, just let
me know.

johannes


