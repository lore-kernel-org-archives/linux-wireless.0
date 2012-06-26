Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2FZGxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 02:53:07 -0400
Message-ID: <1340693584.4662.3.camel@jlt3.sipsolutions.net> (sfid-20120626_085310_382195_5051119E)
Subject: Re: Help tracing NL80211_CMD_AUTHENTICATE as event in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Hawkins <hawkinsw@opentechinitiative.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 08:53:04 +0200
In-Reply-To: <24f-4fe93400-17-239c5900@2266046> (sfid-20120626_061218_757773_249E152D)
References: <24f-4fe93400-17-239c5900@2266046>
	 (sfid-20120626_061218_757773_249E152D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The documentation for nl80211 says the following about the
> NL80211_CMD_AUTHENTICATE command:
> "When used as an event, this reports reception of an Authentication
> frame in station and IBSS modes when the local MLME processed the
> frame, i.e., it was for the local STA and was received in correct
> state."
> 
> I very much want this to be true for IBSS modes. However, I cannot
> seem to trace through the source code to confirm that this actually
> happens. I can easily follow the code for the case when the interface
> is in station mode but lose the trail for IBSS. 

I'm afraid that isn't actually true for IBSS. The event you get there
will be NL80211_CMD_NEW_STATION.

> As far as I can tell, the only path to nl80211_send_rx_auth (the only
> place a NL80211_CMD_AUTHENTICATE command is sent to userspace) looks
> like this:
> ieee80211_iface_work invokes ieee80211_sta_rx_queued_mgmt to handle
> queued management packets received on a station interface.
> ieee80211_sta_rx_queued_mgmt (eventually) invokes
> cfg80211_send_rx_auth, after the proper handling. Finally,
> cfg80211_send_rx_auth invokes nl80211_send_rx_auth.

Yes.


I think in your case though, what you really want is a NL80211_CMD_FRAME
event? You register for auth frames, also to prevent mac80211 from
handling them itself, and then they get diverted to cfg80211_rx_mgmt()
and on to nl80211_send_mgmt().

johannes

