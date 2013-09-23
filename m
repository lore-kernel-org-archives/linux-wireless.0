Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab3IWQI7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 12:08:59 -0400
Message-ID: <1379952829.2475.16.camel@dcbw.foobar.com> (sfid-20130923_180903_556457_20E454DD)
Subject: Re: NetworkManager not listing access points
From: Dan Williams <dcbw@redhat.com>
To: Detlev Casanova <detlev.casanova@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, laurent.pinchart@ideasonboard.com
Date: Mon, 23 Sep 2013 11:13:49 -0500
In-Reply-To: <3006906.Q9n0kfrGGo@naboo>
References: <31357461.i5mG9q5IfA@naboo> <5951977.8jla5cTcNa@naboo>
	 <1379796719.4699.0.camel@jlt4.sipsolutions.net> <3006906.Q9n0kfrGGo@naboo>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-09-22 at 16:20 +0200, Detlev Casanova wrote:
> Le samedi 21 septembre 2013 22:51:59 Johannes Berg a écrit :
> > On Thu, 2013-09-19 at 07:58 +0200, Detlev Casanova wrote:
> > > Here is the output (attached file for formatting)
> > 
> > Was that from the good case? The bad case would have been 
> more
> > interesting.
> 
> This is both cases. I made another one and here, I can give more 
> details:
> 
> Network manager is trying to list APs and fails until time 
> 1379858724.386569

Ok, the logs indicate that the driver simply doesn't see any scan
results:

1379858724.381522: Received scan results (0 BSSes)

Then 20 seconds later (after the explicit iwlist), it finds some scan
results:

1379858746.953924: Received scan results (3 BSSes)

So I'm not sure what's going on here, but I don't think NetworkManager
is the issue; it's likely in the supplicant's scanning code or in the
driver itself.  NetworkManager asks the supplicant to scan with both the
wildcard SSID and any hidden-tagged SSID, and the wildcard SSID should
ensure that all available APs are found.

Johannes, does anything else jump out at you in the logs?

Dan

> The The first "iwlist wlan0 scan" is done juste after the log line 
> (1379858738.682054). It lists the APs in range in the console but 
> not in the Network Manager ui.
> 
> The second "iwlist wlan0 scan" is done at time 1379858739.802067 
> and APs are being listed in the console and in the Network Manager 
> UI.
> 
> After that, NM will connect to the acces point with SSID "Maison".
> 
> It also looks like the listing in Network Manager comes between the 
> moment "iwlist wlan0 scan" is run for the second time and the 
> moment is shows its output on the console.
> 
> Detlev.


