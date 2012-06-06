Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2FFJCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:02:25 -0400
Message-ID: <1338973343.4513.34.camel@jlt3.sipsolutions.net> (sfid-20120606_110239_623792_92D4E15B)
Subject: Re: [RFC 01/14] cfg80211: respect intf combinations for 1 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 06 Jun 2012 11:02:23 +0200
In-Reply-To: <4FCF1B2B.7030803@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	  <1338203942-5667-2-git-send-email-michal.kazior@tieto.com>
	 <1338972702.4513.24.camel@jlt3.sipsolutions.net>
	 <4FCF1B2B.7030803@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 10:56 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> >> Don't ignore interface combinations when only one
> >> interface is up. Otherwise we may call a driver to
> >> create (or change) interface type to something it
> >> didn't report in interface combinations it
> >> reported.
> >
> > We still check wiphy.interface_modes before we even go into this
> > function, no? Arguably we should move the check into the function, but
> > I'm not sure what you're fixing here.
> 
> Suppose a driver advertises support for AP and STA. Without the patch 
> it's possible to bring up e.g. IBSS interface.

I don't think so?

main.c:1005
        case NETDEV_PRE_UP:
                if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
                        return notifier_from_errno(-EOPNOTSUPP);

But it does make sense to move that into the function.

johannes

