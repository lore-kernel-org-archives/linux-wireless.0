Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59874 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYEGNsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 09:48:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Date: Wed, 7 May 2008 15:48:06 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
References: <20080430124055.091382000@sipsolutions.net> <1210161133.5642.19.camel@johannes.berg> <20080507130548.GA26977@gondor.apana.org.au>
In-Reply-To: <20080507130548.GA26977@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805071548.06693.mb@bu3sch.de> (sfid-20080507_154745_960805_CE676FCC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 07 May 2008 15:05:48 Herbert Xu wrote:
> On Wed, May 07, 2008 at 01:52:13PM +0200, Johannes Berg wrote:
> >
> > Hmm. Why does busy exist then? Historical accident? I really really
> 
> Yes it's historical baggage.  These days the biggest users would
> be LLTX drivers which should all be converted to non-LLTX and
> drivers that don't keep track of queue status properly.

So there's no way to actually fail in a TX handler? Drivers
are doomed to drop the packet, if they cannot handle it due to
ring overflow?

-- 
Greetings Michael.
