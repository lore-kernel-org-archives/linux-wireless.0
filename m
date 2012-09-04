Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2IDIPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 04:15:03 -0400
Message-ID: <1346746540.3737.3.camel@jlt4.sipsolutions.net> (sfid-20120904_101519_839432_6A03EECB)
Subject: Re: [RFC][PATCH] rtl8192cu: completing beaconing support
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: coekbe <coekbe@gmail.com>, linux-wireless@vger.kernel.org
Date: Tue, 04 Sep 2012 10:15:40 +0200
In-Reply-To: <50440156.5020300@lwfinger.net> (sfid-20120903_030117_121240_2694CB76)
References: <CAK678xg-uD6rKdcZVksAdAwMtsvmcn6GmYsSa1gWS=CNTLpenw@mail.gmail.com>
	  <5043E582.6070205@lwfinger.net>
	 (sfid-20120903_010233_586023_7DF08501) <1346628057.10113.13.camel@jlt4.sipsolutions.net>
	 <50440156.5020300@lwfinger.net> (sfid-20120903_030117_121240_2694CB76)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-02 at 20:01 -0500, Larry Finger wrote:
> On 09/02/2012 06:20 PM, Johannes Berg wrote:
> >
> > Just FYI -- that's not guaranteed if "iw scan" returns results, you'd
> > have to run "iw scan passive" to make sure you pick up beacons rather
> > than just probe responses.
> 
> That is good to know. Unfortunately, 'iw wlan0 scan passive' run as an 
> unprivileged user results in "command failed: Operation not permitted (-1)". 
> When I run it as root, then I get "command failed: Operation not supported 
> (-95)". I am assuming that my version of iw (0.9.22) is not new enough.

Seems like, though it's a bit strange that'd you'd get operation not
supported. Not sure why that is.

> When I run 'iwlist scan' in unprivileged mode, I did see the beacon, thus I got 
> the right answer.

You can't run "iwlist scan" in unprivileged mode either, in this mode
it'll just return the existing results list that is still there due to
wpa_supplicant (or some other process) triggering a scan.

If you want to check if you saw a beacon, you can run

iw wlan0 scan dump -b

and check if it prints
"Information elements from Beacon frame:"

for that AP.

johannes

