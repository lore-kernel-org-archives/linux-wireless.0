Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1EKRRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 13:17:30 -0400
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4DCAC2F0.7090308@candelatech.com>
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	 <4DC81A61.9080101@candelatech.com>
	 <1304959783.12202.7.camel@jlt3.sipsolutions.net>
	 <BANLkTinHqMi=sy=sEzQPTz4QEsoucQXYVA@mail.gmail.com>
	 (sfid-20110511_175913_191261_9D02A924) <1305132500.17892.1.camel@jlt3.sipsolutions.net>
	 <4DCAC2F0.7090308@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 19:17:27 +0200
Message-ID: <1305134247.17892.4.camel@jlt3.sipsolutions.net> (sfid-20110511_192024_639224_FE13F2E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 10:10 -0700, Ben Greear wrote:
> On 05/11/2011 09:48 AM, Johannes Berg wrote:
> > On Wed, 2011-05-11 at 17:58 +0200, Björn Smedman wrote:
> >
> >>> Yes, in theory that's possible, but apparently no driver actually did
> >>> this correctly. Also, it didn't seem like anyone really cares, and we
> >>> need to enforce some restrictions because otherwise drivers will end up
> >>> doing it wrong, and you'll end up having a beacon interval of 200 while
> >>> advertising 150 for example, which will totally throw off powersaving
> >>> clients.
> >>
> >> I'm very interested in having multiple AP vifs with different beacon
> >> intervals. If we're going to just fail anyway in this case can't we do
> >> that from the drivers instead? I would also prefer that from an
> >> aesthetic point of view, instead of having broken logic in the drivers
> >> "protected" by extra verification in cfg80211.
> >
> > We can't fail from the drivers, they don't have a failure path.
> 
> Maybe we could treat the beacon interval setting as a requested
> value, and give the caller some way to know the actual value
> that is used by the hardware?

No, not really, the value needs to be in the beacon data.

johannes

