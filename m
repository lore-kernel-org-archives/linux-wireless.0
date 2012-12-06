Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab2LFMZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 07:25:41 -0500
Date: Thu, 6 Dec 2012 13:25:29 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Fix ethtool stats and other ops.
Message-ID: <20121206122528.GG2502@redhat.com> (sfid-20121206_132545_618137_5ACA193A)
References: <1354729192-22945-1-git-send-email-greearb@candelatech.com>
 <87a9ts4c1q.fsf@nemi.mork.no>
 <50BF8C18.9060504@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <50BF8C18.9060504@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 05, 2012 at 10:02:00AM -0800, Ben Greear wrote:
> On 12/05/2012 09:57 AM, Bjørn Mork wrote:
> >Ben Greear <greearb@candelatech.com> writes:
> >
> >>net/core/dev.c now assigns a default ethtool ops, so
> >>the net/wireless/core.c check for existing ops is always true
> >>so the wireless ops would never be assigned.
> >>
> >>Simply remove the check for existing ops and always assign
> >>the wireless ops.
> >>
> >>Signed-off-by: Ben Greear <greearb@candelatech.com>
> >>---
> >>  net/wireless/core.c |    3 +--
> >>  1 files changed, 1 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/net/wireless/core.c b/net/wireless/core.c
> >>index 4e6fe62..6309699 100644
> >>--- a/net/wireless/core.c
> >>+++ b/net/wireless/core.c
> >>@@ -863,8 +863,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
> >>  		/* allow mac80211 to determine the timeout */
> >>  		wdev->ps_timeout = -1;
> >>
> >>-		if (!dev->ethtool_ops)
> >>-			dev->ethtool_ops = &cfg80211_ethtool_ops;
> >>+		dev->ethtool_ops = &cfg80211_ethtool_ops;
> >>
> >>  		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
> >>  		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
> >
> >
> >Won't this break drivers which for some reason have their own
> >ethtool_ops?
> 
> I guess it will.  What a mess.
> 
> Maybe we could assign individual method pointers in the ethtool_ops
> struct if it already exists (and if those pointers are NULL)?

We should probably assing ethtool_ops before wireless core will
call alloc_netdev.

Stanislaw
