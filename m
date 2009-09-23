Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:39630 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZIWHNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 03:13:51 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
Date: Wed, 23 Sep 2009 09:12:57 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
References: <200909181849.22302.hs4233@mail.mn-solutions.de> <200909210946.19675.hs4233@mail.mn-solutions.de> <1253662172.2510.60.camel@localhost.localdomain>
In-Reply-To: <1253662172.2510.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909230912.57417.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 September 2009 01:29:32 Dan Williams wrote:

> So on the supplicant side, this weekend I was discussing with
> Jouni about making the supplicant *not* trigger a completely
> new scan when trying to associate if the scan list was current
> in the past 5 or 10 seconds.  The issue here is that NM
> requests a scan, ... 

I currently center around a setup without NM. Okay, for the
forklift terminals (they are x86-based), NM would be feasible.
But for the handheld terminals (Intel PXA based) I'm not keen
on NM. So I basically develop a simple program that monitors
signal and triggers a scan when signal level is below some
thresshold. This program happens to be linked into
wpa_supplicant, but it can also be a standalone program.

I'm relying on wpa_supplicant's feature to monitor scan-done
events and looking if there's something a better matching BSS
in the result.



But when you take wpa_supplicant, NM and whatever, then maybe the
timestamp idea from Johannes should be used. Any application
that wants to look if it should roam can quickly get the
scan results. By the timestamp of the entries it can then
see how old the entries are. Only if entries are outdated,
it can fire up a scan.

There's just one case: if there is no BSS in the scan list.
Then any app doing a "get scan results" call wouldn't know
if the last scan is ages ago or if there is really no AP
in the vincinity, doing an immediate re-scan. This can be
harmful for battery-driven devices. So maybe a timestamp
"last scan was at timestamp XXX" besides the individual
BSS timestamps would be helpful here.

This way apps can synchronize themselfes and, even if
different apps do scanning, they can say "We don't scan
more often than every N seconds".


> BTW, 10 years ago I did a forklift deployment too with pre-802.11
> Aironet equipment and Netware.  Wasn't that fun to get up and running.
> This was at a paper company too, and guess what huge rolls of paper do?
> They absorb radio waves quite well.  Suck.  And forklifts can go *fast*.

Oh, and a wholesale company for drinks is even more demanding.
Water-based liquid has the nice property of absorbing microwaves
in the 2.4 MHz range extremely nicely, just see your next
microwave oven for a proof ...


The nice thing about this: when you have a working roaming 
(and fast-enought handoff) in a warehouse/fork-lift scenary,
then your can forget about the WLAN problem in other scenarios,
because they are way less demanding. What happens to work in
the forklift case works everywhere else.

-- 
http://www.holgerschurig.de
