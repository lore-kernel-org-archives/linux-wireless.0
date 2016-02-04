Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44644 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965221AbcBDJCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:02:05 -0500
Message-ID: <1454576521.2564.6.camel@sipsolutions.net> (sfid-20160204_100210_865865_46F03904)
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when
 building IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 04 Feb 2016 10:02:01 +0100
In-Reply-To: <56A78E8F.1080505@candelatech.com>
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
	 <1453807009.2759.23.camel@sipsolutions.net>
	 <56A78E8F.1080505@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-26 at 07:19 -0800, Ben Greear wrote:

> As far as I can tell, that will not work, because I want to have
> multiple station devices per radio, and have each of them be able to
> use a different configuration.  So, one station may be /g, and
> another /n and another /AC.  Same with APs.  In addition, some
> stations may want to use all available rates for their mode, and
> others may want to use a fixed rate or subset of available rates.

So let's agree that we're splitting the *used* rates (which we have
today) and the *advertised* rates/modes/...

Even if we can't modify the wiphy capabilities, perhaps we could still
handle it more consistently at mac80211 level, e.g. by introducing and
using "sdata->capa.bands" (and similar for all the other wiphy
capabilities you want to manipulate), and then allowing that to point
to something modified?

johannes
