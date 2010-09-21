Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0IURtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 13:49:02 -0400
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285088605.12764.5.camel@jlt3.sipsolutions.net>
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>
	 <4C98DC5D.2000108@candelatech.com>
	 <1285086618.12764.3.camel@jlt3.sipsolutions.net>
	 <4C98E05B.8050609@candelatech.com>
	 <1285088605.12764.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 19:49:01 +0200
Message-ID: <1285091341.12764.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 19:03 +0200, Johannes Berg wrote:

> > >>> -	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
> > >>> +	snprintf(mac, sizeof(mac), "%pM-%s",
> > >>> +		 sta->sta.addr, sta->sdata->name);
> > >>>
> > >>>    	/*
> > >>>    	 * This might fail due to a race condition:
> > >>
> > >> I got to thinking:  Is there any reason to put the sta.addr in there?
> > >>
> > >> Maybe just use sta->sdata->name?  Seems it might be easier for
> > >> scripts to deal with?
> > >
> > > APs have many STAs
> > 
> > So, when in STA mode, sta_info are related to local VIFs, but
> > in AP mode, they represent the remote wireless devices, with sdata pointing
> > to the local AP interface?
> 
> No, there's a sta_info for each peer, which in STA mode is only the AP.

maybe the stations should be moved from phy0/stations/ to
phy0/wlan0/stations/ instead?

johannes

