Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbYIOOTy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 10:19:54 -0400
Subject: Re: Channel scan during the AP re-association increases delay
From: Dan Williams <dcbw@redhat.com>
To: Pavan <pavan.k.pujari@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20080915T110100-223@post.gmane.org>
References: <loom.20080915T110100-223@post.gmane.org>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 10:20:32 -0400
Message-Id: <1221488432.10177.37.camel@localhost.localdomain> (sfid-20080915_161956_787826_FEBAE579)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 11:18 +0000, Pavan wrote:
> Hi All,
> 
> I am working on fast handovers to APs during roaming of wireless devices. I have
> been looking through the mac80211 code to understand how the re-associations are
> initiated in wireless STAs. To my surprise, I see that everytime I issue a
> associate command using the `iwconfig' utility, it starts with scanning on all
> channels collecting information from each AP in the ESSID set. Subsequently,

mac80211 should just be scanning for the specified configured SSID or
BSSID.  If it's doing a broadcast passive scan every association, that
seems quite wrong.  By doing the active SSID probe scan you can cut down
the time quite a bit because you're expecting the probe response and you
don't need to eat up the entire dwell time.  The same goes for channel
and everything; if there's a locked channel, the card probably shouldn't
scan any other channel looking for the AP.

It should probably also just be doing the scan-on-associate if the most
recent scan was more than 5 or 10 seconds in the past, or that most
recent scan was was a filtered scan on some other SSID, channel, or
BSSID.

It's useful to scan on the association request to ensure that you have
all the correct information from the AP, like WPA IEs, capability bits,
beacon information, etc.  Without that associations would fail quite a
bit more often due to outdated information.

Summary: I think there's a lot of tweaking that can be done here to
speed things up.

> begins the authentication and association process. This results in large
> re-association delays which is unacceptable to real time traffic like voice.
> 
> As I went through the code, I could trace that `hw->scan' is initiated before
> authentication and association process. I could not figure the exact reason for
> having a channel scan every time an association command is issued, instead it
> could be done passively when the STAs are immobile or experiencing good channel
> conditions (as one of the conditions). This way a lot of time could be saved
> during roaming to bring down the total re-association delays. 

Yes, it could be.  But passive scanning takes a _lot_ more time than
active probe scanning because you have to dwell on each channel for long
enough to get beacons for a good number of APs on the channel.  That's
anywhere from 75 to 200 ms per channel (default beacon interval for most
stuff is 100ms so you should wait at least 105 or 110 or so).  Channel
switch time may take some ms too.  So if you're running VOIP or SSH or
something, you really don't want to start a passive scan.

You can obviously monitor beacons from the channel you're currently on,
but that doesn't help much because if you're doing a handoff the AP
you're going to associate with next is going to be on a different
channel if the network admin is worth anything.

Are you working in SSID -> SSID handoffs, or BSSID -> BSSID handoffs
within the same SSID?  Isn't this some of what pre-auth is supposed to
handle?  It seems to me that the the cfg80211 API needs to be rich
enough for the supplicant to be able to say things like "I know this AP
is in-range and I'm pre-authed with it already, so don't bother to
re-scan".  That sort of thing combined with scan optimizations ought to
cover most things, right?

Dan


