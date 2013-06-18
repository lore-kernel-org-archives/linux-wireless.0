Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39299 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab3FROue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 10:50:34 -0400
Message-ID: <1371567030.8318.34.camel@jlt4.sipsolutions.net> (sfid-20130618_165036_407895_6E5E4CC3)
Subject: Re: [PATCHv2 2/5] nl80211/cfg80211: add channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 18 Jun 2013 16:50:30 +0200
In-Reply-To: <1371212124-26264-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371212124-26264-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * @NL80211_CMD_CHANNEL_SWITCH: Perform a channel switch by announcing the
> + *	the new channel information (Channel Switch Announcement - CSA)
> + *	in the beacon for some time (as defined in the
> + *	%NL80211_ATTR_CH_SWITCH_COUNT parameter) and then change to the
> + *	new channel. Userspace provides the new channel information (using
> + *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel
> + *	width). %NL80211_ATTR_CH_SWITCH_BLOCK_TX may be supplied to inform
> + *	other station that transmission must be blocked until the channel
> + *	switch is complete.

We probably need a flag to indicate that the command is available, since
mac80211 might implement it but not all drivers will?

johannes

