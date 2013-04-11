Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3DKMfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 08:35:00 -0400
Message-ID: <1365683696.8272.41.camel@jlt4.sipsolutions.net> (sfid-20130411_143505_992432_D838A97F)
Subject: Re: [PATCH] cfg80211: introduce critical protocol indication from
 user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 11 Apr 2013 14:34:56 +0200
In-Reply-To: <516694BF.7090701@broadcom.com>
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
	 <1365501997.8465.23.camel@jlt4.sipsolutions.net>
	 <516694BF.7090701@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-11 at 12:47 +0200, Arend van Spriel wrote:
> On 04/09/2013 12:06 PM, Johannes Berg wrote:
> > On Mon, 2013-04-08 at 11:09 +0200, Arend van Spriel wrote:
> >> +void cfg80211_crit_proto_stopped(struct wireless_dev *wdev)
> >> +{
> >> +	struct cfg80211_registered_device *rdev;
> >> +
> >> +	rdev = wiphy_to_dev(wdev->wiphy);
> >> +	WARN_ON(!rdev->crit_proto_started);
> >> +	rdev->crit_proto_started = false;
> >> +}
> >
> > Oh, so you don't want to tell userspace?
> 
> Just an observation will looking for an example of netlink event 
> messaging to user-space. I noticed that the cfg80211_ft_event() function 
> used fixed GFP_KERNEL value. Should event functions always have a gfp_t 
> parameter?

Well I guess in general I would add it (unless there are other reasons
it needs to be able to sleep). OTOH, if all drivers always call it in a
context where they can sleep, it's safe to just use GFP_KERNEL, so for
the ft_event it probably doesn't actually matter.

johannes

