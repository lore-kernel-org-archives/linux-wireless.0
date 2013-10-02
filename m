Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35345 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3JBJJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:09:05 -0400
Message-ID: <1380704936.13329.14.camel@jlt4.sipsolutions.net> (sfid-20131002_110909_980058_E454483E)
Subject: Re: NetworkManager not listing access points
From: Johannes Berg <johannes@sipsolutions.net>
To: Detlev Casanova <detlev.casanova@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Date: Wed, 02 Oct 2013 11:08:56 +0200
In-Reply-To: <3913713.WUui18VufC@naboo> (sfid-20130929_212901_767553_941F79A4)
References: <31357461.i5mG9q5IfA@naboo> <3006906.Q9n0kfrGGo@naboo>
	 <1379952829.2475.16.camel@dcbw.foobar.com> <3913713.WUui18VufC@naboo>
	 (sfid-20130929_212901_767553_941F79A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-09-29 at 21:29 +0200, Detlev Casanova wrote:

> > So I'm not sure what's going on here, but I don't think NetworkManager
> > is the issue; it's likely in the supplicant's scanning code or in the
> > driver itself.  NetworkManager asks the supplicant to scan with both the
> > wildcard SSID and any hidden-tagged SSID, and the wildcard SSID should
> > ensure that all available APs are found.
> 
> Yes and the problem is most likely to be in the driver because it doesn't 
> occur before commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8 ("cfg80211: use 
> DS or HT operation IEs to determine BSS channel")

Does it work on a newer kernel if you revert that commit? I really see
nothing wrong with that commit ...

Failing all else, since I can't reproduce the issue, can you please
compare the output of "iw list" before and after the failure (on the
failing kernel)? Maybe all channels are marked disabled or something?
But that really should've been the same behaviour before the patch too.

Also, tracing would be good (trace-cmd record -e cfg80211 -e mac80211,
compress trace.dat and send it to me)

johannes

