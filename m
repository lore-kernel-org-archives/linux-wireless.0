Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38016 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab2FZRDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 13:03:37 -0400
Message-ID: <1340730210.4484.11.camel@jlt3.sipsolutions.net> (sfid-20120626_190341_058895_9317D6CA)
Subject: Re: Help tracing NL80211_CMD_AUTHENTICATE as event in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Hawkins <hawkinsw@opentechinstitute.org>
Cc: Will Hawkins <hawkinsw@opentechinitiative.org>,
	linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 19:03:30 +0200
In-Reply-To: <4FE9E6F0.2070909@opentechinstitute.org>
References: <24f-4fe93400-17-239c5900@2266046>
	   (sfid-20120626_061218_757773_249E152D) <1340693584.4662.3.camel@jlt3.sipsolutions.net>
	  <4FE9E201.1010903@opentechinstitute.org>
	 <1340728873.4484.6.camel@jlt3.sipsolutions.net>
	 <4FE9E6F0.2070909@opentechinstitute.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 12:44 -0400, Will Hawkins wrote:

> > Huh, now I'm confused, why would it need the authenticate frames for
> > IBSS? As far as I can tell, it looks at CMD_NEW_STA, which calls
> > nl80211_new_station_event(), 
> 
> This is what I understand as well.
> 
> which in IBSS sends EVENT_IBSS_RSN_START to
> > the supplicant core -- that will trigger the 4-way-handshake. No? Hence
> > it doesn't need to register for auth frames, it never needs them, since
> > RSN uses open auth, if any is even used in IBSS at all.
> 
> This is where I am still trying to figure out exactly how it works.

I believe that when the new station is added (NEW_STA event), it will
simply send out a 1/4 EAPOL frame. Since both do that, I guess it does
some kind of de-duplication? Whoever sends it first wins or something,
but I don't really know. Maybe we should take the discussion to the
hostap list at this point :-)

johannes

