Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbYCESdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 13:33:35 -0500
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Joonwoo Park <joonwpark81@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1204715825.25502.69.camel@johannes.berg>
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
	 <1204710843.25502.50.camel@johannes.berg>
	 <b25c3fa70803050310i71023046gc3f40d4042038ba6@mail.gmail.com>
	 (sfid-20080305_111045_653557_3B0AF33B)  <1204715825.25502.69.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 13:29:00 -0500
Message-Id: <1204741740.9378.19.camel@localhost.localdomain> (sfid-20080305_183338_367171_5FB10CD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-05 at 12:17 +0100, Johannes Berg wrote:
> > > This looks wrong. You could restart association when a key is set but
> > > really the race is by design in WEXT so the only way to fix it is to set
> > > the key first.
> > >
> > 
> > Do you mean fix iwconfig to always do set key before set essid?
> 
> Well, no, I think it's more of a user error, I always do 
>    iwconfig enc ENC; iwconfig essid SSID
> in that order.
> 
> > But, doing It cannot solve a race from two seperated iwconfig process, I think.
> > (eg: iwconfig essid ESSID; iwconfig enc ENC)
> 
> Yeah, that's pretty ugly to start with.

See below for a partial solution; but even with nl80211/cfg80211, if you
have more than one process trying to control the wireless card
concurrently you have already lost.  Don't Do That.

> > Moreover, now we just wake auth request task up and return when setting essid.
> > Don't we need to wait a moment until the task is scheduled to be
> > polite to iwconifg? :)
> 
> I think the only way to properly handle it is to reset the association
> state machine when a key is added. Dan, what's the expected behaviour?

The best way to implement the WEXT stuff is to have a timeout of about
500ms - 700ms or so to batch WEXT stuff together.  Each new WEXT command
that comes in before the timeout pushes the timeout back.  When the
timeout triggers, all the new commands are executed in the driver in the
order the driver expects.  That fixes most issues with chaining WEXT
commands and makes all of these Just Work:

iwconfig wlan0 essid foo key 253325353 open channel 11
iwconfig wlan0 key 253325353 open essid foo channel 11
iwconfig wlan0 channel 11 key 253325353 open essid foo

Later on if you issue just 'iwconfig wlan0 channel 6' the driver waits
500ms, the timeout triggers, and the driver changes to channel 6 and
starts the association process all over with the current settings (keys,
BSSID/SSID, bitrate, etc), and issues the SIOCGIWBSSID association event
on both success and failure.

If you just do 'iwconfig wlan0 rate 11' then of course the driver
doesn't need to trigger reassociation after the WEXT command timeout, it
just needs to lock the bitrate.

The _explicit_ triggers for association/reassociation are setting the
BSSID or the SSID.  In that case, the driver takes the new BSSID/SSID
and all the cached config, and tries to associate with that after the
timeout triggers.  The driver may choose to trigger reassociation if a
WEXT command would require so, but it shouldn't do the reassociation
until the timeout occurs.

I've implemented this in the libertas driver's assoc.c/wext.c if you
want to take a look at what's happening there.  The implementation isn't
perfect, but it's about what's required to work properly with WEXT.

Dan


