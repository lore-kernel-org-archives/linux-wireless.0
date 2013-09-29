Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57958 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab3I2T3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:02 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so2889129wid.15
        for <linux-wireless@vger.kernel.org>; Sun, 29 Sep 2013 12:29:01 -0700 (PDT)
From: Detlev Casanova <detlev.casanova@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: NetworkManager not listing access points
Date: Sun, 29 Sep 2013 21:29:17 +0200
Message-ID: <3913713.WUui18VufC@naboo> (sfid-20130929_214415_668531_EAD52444)
In-Reply-To: <1379952829.2475.16.camel@dcbw.foobar.com>
References: <31357461.i5mG9q5IfA@naboo> <3006906.Q9n0kfrGGo@naboo> <1379952829.2475.16.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le lundi 23 septembre 2013 11:13:49 Dan Williams a écrit :
> On Sun, 2013-09-22 at 16:20 +0200, Detlev Casanova wrote:
> > Le samedi 21 septembre 2013 22:51:59 Johannes Berg a écrit :
> > > On Thu, 2013-09-19 at 07:58 +0200, Detlev Casanova wrote:
> > > > Here is the output (attached file for formatting)
> > > 
> > > Was that from the good case? The bad case would have been
> > 
> > more
> > 
> > > interesting.
> > 
> > This is both cases. I made another one and here, I can give more
> > details:
> > 
> > Network manager is trying to list APs and fails until time
> > 1379858724.386569
> 
> Ok, the logs indicate that the driver simply doesn't see any scan
> results:
> 
> 1379858724.381522: Received scan results (0 BSSes)
> 
> Then 20 seconds later (after the explicit iwlist), it finds some scan
> results:
> 
> 1379858746.953924: Received scan results (3 BSSes)
> 
> So I'm not sure what's going on here, but I don't think NetworkManager
> is the issue; it's likely in the supplicant's scanning code or in the
> driver itself.  NetworkManager asks the supplicant to scan with both the
> wildcard SSID and any hidden-tagged SSID, and the wildcard SSID should
> ensure that all available APs are found.

Yes and the problem is most likely to be in the driver because it doesn't 
occur before commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8 ("cfg80211: use 
DS or HT operation IEs to determine BSS channel")

> Johannes, does anything else jump out at you in the logs?
> 
> Dan
> 
> > The The first "iwlist wlan0 scan" is done juste after the log line
> > (1379858738.682054). It lists the APs in range in the console but
> > not in the Network Manager ui.
> > 
> > The second "iwlist wlan0 scan" is done at time 1379858739.802067
> > and APs are being listed in the console and in the Network Manager
> > UI.
> > 
> > After that, NM will connect to the acces point with SSID "Maison".
> > 
> > It also looks like the listing in Network Manager comes between the
> > moment "iwlist wlan0 scan" is run for the second time and the
> > moment is shows its output on the console.
> > 
> > Detlev.

