Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43654 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbbBYHw0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 02:52:26 -0500
Message-ID: <1424850736.2050.0.camel@sipsolutions.net> (sfid-20150225_085230_511466_DDD7DFE7)
Subject: Re: [RFC] zero-copy AMSDU processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
Date: Wed, 25 Feb 2015 08:52:16 +0100
In-Reply-To: <3723348.23HgaGqW1o@lx-wigig-72>
References: <1708052.J876aMsZU2@lx-wigig-72>
	 <1424680539.2782.1.camel@sipsolutions.net> <3723348.23HgaGqW1o@lx-wigig-72>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-02-25 at 09:07 +0200, Vladimir Kondratiev wrote:
> On Monday, February 23, 2015 09:35:39 AM Johannes Berg wrote:
> > If the SKB has pages (rather than being linear, as
> > ieee80211_amsdu_to_8023s() assumes) then what Emmanuel said would
> > probably be the best approach, although it could be possible that would
> > mess up truesize accounting and lead to lower performance. Certainly
> > you'd want to do it only for suitably large packets (at least bigger
> > than 128 bytes or so)
> 
> Why is it important whether it has pages? Looks like I can play with
> pointers to the linear part as well.

I don't think that will work - it would crash later trying to free that
page, no?

Oh - you mean just skb_pull() and friends? That might actually work,
yeah.

johannes

