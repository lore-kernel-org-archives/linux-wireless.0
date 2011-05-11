Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab1EKQsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:48:25 -0400
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTinHqMi=sy=sEzQPTz4QEsoucQXYVA@mail.gmail.com> (sfid-20110511_175913_191261_9D02A924)
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	 <4DC81A61.9080101@candelatech.com>
	 <1304959783.12202.7.camel@jlt3.sipsolutions.net>
	 <BANLkTinHqMi=sy=sEzQPTz4QEsoucQXYVA@mail.gmail.com>
	 (sfid-20110511_175913_191261_9D02A924)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 18:48:20 +0200
Message-ID: <1305132500.17892.1.camel@jlt3.sipsolutions.net> (sfid-20110511_184829_056213_EBBF237D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 17:58 +0200, Björn Smedman wrote:

> > Yes, in theory that's possible, but apparently no driver actually did
> > this correctly. Also, it didn't seem like anyone really cares, and we
> > need to enforce some restrictions because otherwise drivers will end up
> > doing it wrong, and you'll end up having a beacon interval of 200 while
> > advertising 150 for example, which will totally throw off powersaving
> > clients.
> 
> I'm very interested in having multiple AP vifs with different beacon
> intervals. If we're going to just fail anyway in this case can't we do
> that from the drivers instead? I would also prefer that from an
> aesthetic point of view, instead of having broken logic in the drivers
> "protected" by extra verification in cfg80211.

We can't fail from the drivers, they don't have a failure path.

johannes

