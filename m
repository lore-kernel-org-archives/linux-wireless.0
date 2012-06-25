Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2FYH1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 03:27:08 -0400
Message-ID: <1340609223.4589.1.camel@jlt3.sipsolutions.net> (sfid-20120625_092712_412107_CA17401D)
Subject: Re: [RFCv2 13/13] cfg80211: respect iface combinations when
 starting operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 25 Jun 2012 09:27:03 +0200
In-Reply-To: <4FE80DBA.8040703@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	  <1340172859-18146-14-git-send-email-michal.kazior@tieto.com>
	 <1340291183.4489.39.camel@jlt3.sipsolutions.net>
	 <4FE80DBA.8040703@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 09:05 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
> >
> >> +++ b/net/wireless/mlme.c
> >> @@ -302,8 +302,14 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
> >>   	if (!req.bss)
> >>   		return -ENOENT;
> >>
> >> +	err = cfg80211_can_use_chan(rdev, wdev, req.bss->channel,
> >> +				    CHAN_MODE_SHARED);
> >> +	if (err)
> >> +		goto end;
> >
> > I think you need it in assoc too?
> 
> Hmm.. I didn't think it's possible for bss to change channels in between 
> auth and assoc. I'll add the check for assoc too then.

There's no guarantee we ever go through auth, since we could be doing
FT-over-the-DS, in which case we only come through assoc.

johannes

