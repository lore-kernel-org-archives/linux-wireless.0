Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:36131 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3BTTKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 14:10:35 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so3827910bku.27
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 11:10:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130220171955.GA1556@pandem0nium>
References: <1361197831.8555.23.camel@jlt4.sipsolutions.net>
 <1361197982.8555.24.camel@jlt4.sipsolutions.net> <20130218144622.GA4162@open-mesh.com>
 <1361201387.8555.32.camel@jlt4.sipsolutions.net> <20130218153833.GB4162@open-mesh.com>
 <1361202206.8555.34.camel@jlt4.sipsolutions.net> <20130218154906.GC4162@open-mesh.com>
 <1361203098.8555.35.camel@jlt4.sipsolutions.net> <20130218160705.GD4162@open-mesh.com>
 <1361206302.8555.36.camel@jlt4.sipsolutions.net> <20130220171955.GA1556@pandem0nium>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 20 Feb 2013 11:10:14 -0800
Message-ID: <CAG6hwVPF_kvqCOtWJTWpLChOGbo+P8Du=y6Js0MDiF19_QR=ag@mail.gmail.com> (sfid-20130220_201040_572757_01AC199E)
Subject: Re: [RFC] design discussion: Collecting information for (non-peer) stations
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@open-mesh.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

On Wed, Feb 20, 2013 at 9:19 AM, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:

> To sum from this discussion (I think it's a good idea):
>
>  * embed the stats_entry into the sta_info
>  * update peer-stats by modifying the embedded stats_entry (we do the lookup anyway
>  * keep the non-peer stats in a seperate hash, and only keep stats_entry for them (we don't need
>    the full sta_info after all).
>
> We should consider some corner cases here, e.g. adding stas, then we have to
> copy+remove the stats from the non-peer hash, or removing stas, then we have
> to copy the so-far collected stats to the non-peer hash.
>
> If you are okay with it, we can use the NL80211_CMD_GET_STATION command
> (as in iw station dump), and add a seperate flag to give info for non-peer sta.
>
> What about the other commands I suggested (read+reset, start, stop)? For read+reset,
> we could just send yet another flag (RESET_STATS) with the GET_STATION command, but
> for start/stop we would need new commands? Or would you have any better idea?
>
> @Thomas: Is there anything to consider for 802.11s?

I can't think of anything that would be specifically useful for
802.11s right now, and we can always extend the statistics in the
future. One case where this might be useful is if the driver has a
limited number of station slots, the MPM could monitor neighbor
stations for a more "suitable" peer candidate, but your existing stats
should cover that.

Turning on this feature would add some sort of (internal to mac80211)
monitor interface, or just disable all frame filters on a given PHY?
How does it work now?

-- 
Thomas
