Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2FTIXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:23:11 -0400
Message-ID: <1340180588.4655.26.camel@jlt3.sipsolutions.net> (sfid-20120620_102317_348560_63F2E292)
Subject: Re: [RFCv2] respect channels in iface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 10:23:08 +0200
In-Reply-To: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

> I've addressed the issue with non-fixed channel IBSS.
> Channels are now cosidered either shared or exclusive. An
> exclusive channel always takes a channel resource (when
> accouting interface combinations and
> num_different_channels). Exclusive channel could also be
> called hopping but I thought the first one fits better as it
> explicitly states code logic decisions.
> 
> I've also refactored and fixed interface combination
> checking. There are now functions like
> cfg80211_can_use_chan, cfg80211_can_use_iftype_chan.
> 
> Monitor channel is now always defined. When there are
> only monitors running we set a channel (first we can find in
> supported bands structures). This way the corner case
> (of a monitor not having a channel and .get_channel
> returning NULL) mentioned by Johannes is fixed.

Thanks!

I've looked over it briefly and sent a few comments, but I still need to
look at patches 6, 10, 12 and 13 in more detail.

johannes

