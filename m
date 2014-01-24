Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaAXPXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 10:23:25 -0500
Message-ID: <1390577001.4257.61.camel@jlt4.sipsolutions.net> (sfid-20140124_162328_529265_B705E593)
Subject: Re: [RFC 2/3] cfg80211: MinChannelTime and MaxChannelTime for scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Laudin Alessandro Molina T <laudin.molina@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Date: Fri, 24 Jan 2014 16:23:21 +0100
In-Reply-To: <CACX7s6MHvzeBf1m4K3t=ZBS5g_WJGdse9S-sOLiH+X22mgwUKA@mail.gmail.com> (sfid-20140109_172331_159132_99EAF1FA)
References: <20140106075126.GA31046@w1.fi>
	 <1389110387.4645.26.camel@jlt4.sipsolutions.net>
	 <20140107162655.GB9092@w1.fi>
	 <CACX7s6MHvzeBf1m4K3t=ZBS5g_WJGdse9S-sOLiH+X22mgwUKA@mail.gmail.com>
	 (sfid-20140109_172331_159132_99EAF1FA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-09 at 17:23 +0100, Laudin Alessandro Molina T wrote:

> As M. Stewart said in a previous mail, there are some scenarios where
> the scanning algorithms depends on the application priorities, to add
> another examples:
> 
> - A mobile station is moving (for example someone is walking on the
> street with some available community networks) so, to take advantage
> of an eventual connection the scanning needs to be very fast, then it
> might need a list of candidate APs ASAP, no matter if the list in
> incomplete. In this scenario the values for Min/MaxChannelTime should
> be short enough to accomplish time restrictions.
> 
> - On the other side, the same station could arrive to one specific
> place (for example an office or home) so the user might prefer the
> full AP list, so it could choose to connect to the best one.

I'm not convinced that the completeness of the scan list would be the
main concern here. Additionally, it will be difficult for anyone to tell
whether the device is moving or not. I think for this particular use
case, trying to adjust dwell times is probably not a good idea. Having
some form of continuous background scan, so a roaming candidate is
always available, would probably be a better solution to the first
scenario.

As far as the second scenario goes, the user is probably not connected
anyway, and in that case most devices/drivers wouldn't really be
concerned with traffic (which usually drives optimisations.)

> > Agreed. I was thinking of adding some limits on how large a value could
> > be set, but could not come up with any specific, justifiable value. (And
> > the standard was not very helpful either with the "N/A" as the valid
> > range ;-).
> 
> We have seen Probe Responses arriving after 300ms, although in a city
> center spontaneous deployment ~90% of the Probe Responses arrive
> before 50ms. Anyway, I would only suggest to check for positive
> values.

300ms is far too long for that AP to be useful at all, most likely :)

> Another questions:
> 
> - What about IEEE80211_PROBE_DELAY (Probe Delay)? Why won't allow to
> adjust this value? I'm not sure about the definition/use of this
> delay. Could any of you help me with an explanation of this?

We don't have proper CCA in software scans, so this is needed. It's
fairly implicit in the standard, but you can find it (somewhere)

johannes

