Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56199 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab0EMWIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 18:08:18 -0400
Subject: Re: Possible issue with mac80211 and certain access points
From: Marcel Holtmann <marcel@holtmann.org>
To: Chad Koehler <chad.koehler@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTim6GiiFR0zWVqlmIJr-sk1ThwO3GAA97aJwWg3U@mail.gmail.com>
References: <AANLkTim6GiiFR0zWVqlmIJr-sk1ThwO3GAA97aJwWg3U@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 00:07:40 +0200
Message-ID: <1273788460.375.76.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chad,

> Recently purchased a Palm Pre and immediately found some issues with
> connecting to the Wifi Hotspot.  Connecting to other access points
> would work flawlessly.
> 
> Using the Palm Pre hotspot, I can get connected, but the connection
> will drop after a very short period of time.  There are messages in
> the system log whenever the connection drops:
> 
> No probe response from AP <address> after 500ms, disconnecting.
> 
> An internet search turned up several results for people with the same
> issue, different wireless drivers and different access point types.
> 
> I traced this message down to mac80211/mlme.c, to the
> ieee80211_sta_work() function, and was able to determine that for some
> reason this particular AP was not responding to probe requests.  This
> let me further on to the function ieee80211_mgd_probe_ap_send(), which
> sends a direct probe request to the AP -- this probe request was being
> sent and never responded to.
> 
> If I change this function to send a probe request to the broadcast
> address, in a similar manner to what is done in
> ieee80211_direct_probe(), then the access point responds and works
> without issue.
> 
> Due to the volume of issues on the internet that I see with the same
> underlying symptoms, I wonder if there are some small amount of access
> points that will not respond to a direct packet probe request even
> when associated.
> 
> I admittedly know very little about wireless networking internals, so
> I am hesitant to state that this fix is necessary or appropriate, but
> it does solve the issue for me and I am able to remain connected to
> the Palm Pre hotspot, as well as other access points that I have
> tried.
> 
> Please let me know if I can provide further information in this space.

actually I ran into the same issue two days ago and was going to post
it. So what I am seeing with the Palm Pre is that when we actually scan
while connected to the Palm Pre, a second later we end up disconnected.

Regards

Marcel


