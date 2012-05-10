Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab2EJK5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 06:57:48 -0400
Message-ID: <1336647466.4334.16.camel@jlt3.sipsolutions.net> (sfid-20120510_125752_362456_81225E06)
Subject: Re: [PATCH 5/7] cfg80211: extend get_channel to take wdev argument
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 10 May 2012 12:57:46 +0200
In-Reply-To: <4FAB84EA.4060306@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
	  <1336632282-2278-6-git-send-email-michal.kazior@tieto.com>
	 <1336634995.4334.7.camel@jlt3.sipsolutions.net>
	 <4FAB84EA.4060306@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 11:05 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> >
> >>   	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy,
> >> -					       enum nl80211_channel_type *type);
> >> +						 struct wireless_dev *wdev,
> >> +						 enum nl80211_channel_type *type);
> >
> > Hmm. This is mostly used for monitor mode, and there we would have to
> > return NULL anyway while using multiple channels at the same time. Is it
> > really worth the complexity?
> 
> Would we really have to return NULL? With my last patch that moves 
> oper_channel to sdata it can return proper channel.
> 
> But then monitor mode.. ugh.

Well, we could return something proper for everything but monitor, but
we probably don't really care much in those cases?

For monitor we should return something if there's just a single channel
in use, and NULL otherwise I guess.

johannes

