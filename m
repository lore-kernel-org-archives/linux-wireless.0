Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3856 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYLIQbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 11:31:51 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
Subject: Re: [PATCH 1/2] mac80211: add suspend/resume callbacks
Date: Tue, 9 Dec 2008 11:29:31 -0500
Message-Id: <20081209161636.M22933@bobcopeland.com> (sfid-20081209_173156_452704_79F08123)
In-Reply-To: <1228838346.1029.10.camel@johannes.berg>
References: <1227415286-30179-2-git-send-email-me@bobcopeland.com> (sfid-20081123_054218_217354_D63E2DF4) <1227431953.3599.37.camel@johannes.berg> <20081209152908.M73523@bobcopeland.com> <1228838346.1029.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 09 Dec 2008 16:59:06 +0100, Johannes Berg wrote
> > Is this what you had in mind? (now on top of your cfg80211 patch, btw
> > it called ->suspend() in the resume hook)
> 
> Can you adopt that patch too?

Yeah, I already have it in my tree, I just didn't repost it because my 
webmail sucks.

> > +	/* remove all interfaces */
> > +	list_for_each_entry(sdata, &local->interfaces, list) {
> > +
> > +		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> > +		    sdata->vif.type == NL80211_IFTYPE_MONITOR &&
> > +		    netif_running(sdata->dev)) {
> 
> But shouldn't that be != _AP_VLAN && != _MONITOR && running?

Oops, of course it should; that if() started life as continue.  
But that would just mean a missed call to remove_interface()... 
in the driver, which for ath5k just clears the mac, so I don't 
know why it would affect the running state of the interface.

> I'd just add those to ieee80211_i.h, and I don't think you really need
> to protect them with #ifdef CONFIG_PM

Will do, thanks for the review.

-- 
Bob Copeland %% www.bobcopeland.com


