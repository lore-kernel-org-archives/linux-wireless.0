Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab3FRPUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:20:11 -0400
Message-ID: <1371568800.8318.44.camel@jlt4.sipsolutions.net> (sfid-20130618_172025_236593_A568303E)
Subject: Re: [PATCHv2 2/5] nl80211/cfg80211: add channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 18 Jun 2013 17:20:00 +0200
In-Reply-To: <20130618151806.GB27492@pandem0nium>
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371212124-26264-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371567030.8318.34.camel@jlt4.sipsolutions.net>
	 <20130618151806.GB27492@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 17:18 +0200, Simon Wunderlich wrote:
> On Tue, Jun 18, 2013 at 04:50:30PM +0200, Johannes Berg wrote:
> > 
> > > + * @NL80211_CMD_CHANNEL_SWITCH: Perform a channel switch by announcing the
> > > + *	the new channel information (Channel Switch Announcement - CSA)
> > > + *	in the beacon for some time (as defined in the
> > > + *	%NL80211_ATTR_CH_SWITCH_COUNT parameter) and then change to the
> > > + *	new channel. Userspace provides the new channel information (using
> > > + *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel
> > > + *	width). %NL80211_ATTR_CH_SWITCH_BLOCK_TX may be supplied to inform
> > > + *	other station that transmission must be blocked until the channel
> > > + *	switch is complete.
> > 
> > We probably need a flag to indicate that the command is available, since
> > mac80211 might implement it but not all drivers will?
> 
> Yeah ... shall we announce it as CMD() in nl80211_send_wiphy()? Or feature
> flag?

CMD() works (make sure to only put it if split), but need a wiphy flag
since mac80211 always implements it, I think.

johannes

