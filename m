Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab2EJIDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 04:03:00 -0400
Message-ID: <1336636975.4334.9.camel@jlt3.sipsolutions.net> (sfid-20120510_100306_007666_C9C0097D)
Subject: Re: [PATCH 1/7] mac80211: add tracking of temporary offchannel sdata
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 10 May 2012 10:02:55 +0200
In-Reply-To: <4FAB74FD.7080004@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
	  <1336632282-2278-2-git-send-email-michal.kazior@tieto.com>
	 <1336634791.4334.5.camel@jlt3.sipsolutions.net>
	 <4FAB74FD.7080004@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 09:57 +0200, Michal Kazior wrote:

> >>   	/* Temporary remain-on-channel for off-channel operations */
> >> +	struct ieee80211_sub_if_data *tmp_sdata;
> >>   	struct ieee80211_channel *tmp_channel;
> >>   	enum nl80211_channel_type tmp_channel_type;
> >
> > Do you actually need this? I'm still tempted to not worry about any of
> > this and force drivers to implement remain-on-channel in the driver or
> > device for multi-channel, and this temporary thing is only used for
> > remain-on-channel operations now.
> 
> No I don't. But if it's not done we break the whole thing (sw 
> offchannel/scan) with my next patch. We might as well just remove all 
> the sw offchannel/scan code.
> 
> How many drivers are there that still depend on sw offchannel? Can we 
> just go ahead and break them?

Unfortunately we can't, a lot of them require it for P2P.

I guess I need to look at this in more detail.

johannes

