Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46547 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZENSyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 14:54:09 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
In-Reply-To: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 14:54:58 -0400
Message-Id: <1242327298.4227.25.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-14 at 10:52 -0700, Luis R. Rodriguez wrote:
> I'm told Network Manager scans every 60 seconds. When TX'ing or RX'ing
> a lot of data you will see a big dip in throughput and sometimes it
> may cause issues with some connections. Jouni pointed out a possible
> nice option here: split the scans per channel through time. Now with
> nl80211 this is possible but right now Network Manager uses wext
> through wpa_supplicant in many distributions and this won't change for
> a bit (maybe by the next major distribution releases?). Since we're
> stuck with wext for the current distribution releases I'd like to hear
> feedback on a possible nice solution. Should we simply cancel scan?

Libertas splits scans up into 3 parts with a short return to the
operating channel between each part.  There's nothing that requires
cfg80211 for that to work...

Something I've tossed around for a while is counting traffic on the
device and if its over a certain bitrate for a period of time, postpone
the scan for a while.  But after a certain amount of time, there's going
to be a scan no matter what.

The problem here is that at any time an application (say, wifi location
app) could ask for the list of access points.  If you don't scan
periodically, all APs other than your associated AP (and others on the
same channel) will gradually drop off because their beacons are
received.  Hard to wifi position or get area statistics if there's only
one AP in the list.

Secondarily, scanning is a tradeoff between better roaming latency and
continuous high throughput.  If you don't scan, you have no idea what's
around, and when you move and the current AP becomes marginal, you
*have* to take the hit no matter what, so you can scan and find a new AP
to associate with.

I would have though that the periodic scanning would be more of an
annoyance when doing VOIP or SSH other latency sensitive tasks, but when
just downloading a file, a few second drop in transfer rate gets lost in
the bucket in the grand scheme of things.

Dan


