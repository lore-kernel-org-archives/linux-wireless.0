Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:42265 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbbB0K4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 05:56:09 -0500
Message-ID: <54F04AD5.3030406@neratec.com> (sfid-20150227_115618_428572_2EEAB0FA)
Date: Fri, 27 Feb 2015 11:45:41 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath: support new FCC DFS Radar Type 1
References: <1424902634-18275-1-git-send-email-poh@qca.qualcomm.com>
In-Reply-To: <1424902634-18275-1-git-send-email-poh@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2015 11:17 PM, Peter Oh wrote:
> Add support for new FCC DFS rules released on August 14, 2014.
> FCC has added a new radar type named Radar Type 1 and original
> Radar Type 1 is renamed to Radar Type 0 in consequence.
> In fact, the type ID does nothing to functionalities.
> In other words, even if we re-order the IDs, DFS detection will
> work as well, but we give the ID with matching to FCC doc.
> 
> By adding this support, the drivers using this DFS function are
> able to support both of old and new FCC DFS rules simultaneously
> without any other changes.
> 
> [...]

Peter,

while trying to solve detection of the special FCC type 1 radar pattern with the
pri_detector at hand is a valid approach, it is neither suitable nor effective.

It is not suitable because in the way you do, it will not reach the required
detection probability required to pass certification. This is because you take the
very first pri to configure its detector specs, which is way too optimistic. You
have to consider that the detector must be able to detect properly with only 50%
of the pulses seen. In this particular case, you would ignore a lot of type 1
patterns, since the resulting visibility gap causes temporary false PRIs that
won't be considered. You might want to have a look on my slides 15ff in [1] for an
idea what needs to be handled.

Generally, to reach the detection probability requirements, the design of the
PRI-detector at hand follows a full-coverage search with fast cancellation
approach. For that, it allows collecting potential pattern candidates and a
posteriori correction of initial assumptions. It is specifically targeting at
radar patterns defined through PRI-ranges, where constant PRI-ranges are supported
as special cases by setting the same values for pri_min and pri_max (as is done
for pattern 0). With support for PRI-ranges and unique PRIs, everything needed to
detect pattern 1 is there, but defining it as a PRI-range over all the unique 23
PRIs is the wrong way.

The correct approach is more simple, robust, and efficient: define all those 23
unique PRIs as sub-patterns for type 1 with individual specs. Would look like:

#define TYPE1_PPB(X) ((19 * 100000) / (36 * X))
static const struct radar_detector_specs fcc_radar_ref_types[] = {
	FCC_PATTERN(0, 0, 1, 1428, 1428, 1, 18, false),
	FCC_PATTERN(101, 0, 1, 518, 518, 1, TYPE1_PPB(518), false),
	FCC_PATTERN(102, 0, 1, ..., ..., 1, ..., false),
	[...],
	FCC_PATTERN(123, 0, 1, 3066, 3066, 1, TYPE1_PPB(3066), false),
	FCC_PATTERN(2, 0, 5, 150, 230, 1, 23, false),
	FCC_PATTERN(3, 6, 10, 200, 500, 1, 16, false),
	FCC_PATTERN(4, 11, 20, 200, 500, 1, 12, false),
	FCC_PATTERN(5, 50, 100, 1000, 2000, 1, 1, true),
	FCC_PATTERN(6, 0, 1, 333, 333, 1, 9, false),
};


Hope it helps, and sorry I didn't do myself, but so far we are only working in
ETSI domains and ignored FCC completely.


Cheers,
Zefir

[1]
http://linuxwireless.sipsolutions.net/attachments/en/developers/DFS/Vancouver2011-Slides-DFS.pdf
