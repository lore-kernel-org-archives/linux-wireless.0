Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54083 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbbGCSiF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 14:38:05 -0400
Message-ID: <1435948682.2059.41.camel@sipsolutions.net> (sfid-20150703_203809_214964_C338CD56)
Subject: Re: Q: iw - how to scan for a specific ssid / AP mode scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 03 Jul 2015 20:38:02 +0200
In-Reply-To: <5596BDAB.4020001@neratec.com>
References: <5596BDAB.4020001@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-07-03 at 18:51 +0200, Zefir Kurtisi wrote:
> Folks,
> 
> I have difficulties using iw for a specific use case or fail to 
> understand the documentation correctly.
> 
> My platform is a recent OpenWRT, running ath9k.
> 
> First use case is scanning for a given ssid in managed mode. 
> According do iw's documentation (and the attribute description in 
> nl80211.h), issuing
> 
> iw dev wlan0 scan flush ssid <SSID>
> 
> should do exactly this, but I keep receiving a full list of visible 
> APs.

This is telling it to scan for that particular network, and that's what
it's going to do, but it's still going to report everything that it
heard, for example when hearing beacons while scanning.

> The second issue is about scanning in AP mode. Where I want to go is
> having two
> APs operating on arbitrary DFS channels with periodic scans to 
> discover each
> other. What I observe is
> a) passive scanning: iw dev wlan0 scan flush ap-force passive
>    => does not work - no scan results are provided
> b) active scanning: iw dev wlan0 scan flush ap-force
>   * finds only a subset of APs compared to a scan in managed mode
>   * finds only APs on non-DFS channels
> 
> Again, I might be missing some relevant documentation, but to me the 
> observed results look rather like 'not yet implemented' than inherent
> limitations.
> 

Not sure - but you do need to realize that the AP isn't really allowed
to go off-channel for any period of time (like scanning) so this isn't
really guaranteed to work well. Especially passive scanning seems like
a really bad idea. As to why it's not actually working, I have no idea.

johannes
