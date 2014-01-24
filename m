Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaAXPRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 10:17:50 -0500
Message-ID: <1390576663.4257.55.camel@jlt4.sipsolutions.net> (sfid-20140124_161753_559323_BE70761E)
Subject: Re: [RFC 2/3] cfg80211: MinChannelTime and MaxChannelTime for scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 Jan 2014 16:17:43 +0100
In-Reply-To: <20140107162655.GB9092@w1.fi>
References: <20140106075126.GA31046@w1.fi>
	 <1389110387.4645.26.camel@jlt4.sipsolutions.net>
	 <20140107162655.GB9092@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-07 at 18:26 +0200, Jouni Malinen wrote:

> I don't have any specific use case in mind. These are parameters
> included in the standard and there are various new use cases coming up
> for IEEE 802.11 scanning and those could potentially be able to use this
> type of parameters. 

Right, I know they're included there, was mostly wondering about the
particular cases that would use it.

Are we OK with these things then completely killing any optimisation,
and in fact drivers being allowed to refuse the scan? Or should the
driver in that case ignore the parameters? Similarly, what should happen
if the driver doesn't (want to) support these parameters at all?

I think the answers to these questions should also be captured in the
nl80211 documentation (and possibly code, if there needs to be a feature
flag etc.)

> Similarly, I'd actually like to see quite a bit
> additional flexibility in scanning operations like partial scan reports
> (event notification of updated BSSes per channel etc.) and aborting
> scans, etc., that has also come up in the past.

Right, those are useful, but that's pretty much orthogonal to this
issue. I'd welcome patches for all of these.

> > Would you expect these to always be specified, to the point where our
> > driver no longer has any flexibility in adjusting things internally?
> 
> Maybe for some use cases, but unlikely for the find an AP to connect to
> case.

Ok.

> > > + * @NL80211_ATTR_MIN_CHANNEL_TIME: MinChannelTime - Minimum time (in TU) to
> > > + *	spend on each channel when scanning (used for active scans). If not
> > > + *	included, the driver will use its default value. u32 attribute.
> > 
> > What about passive scans?
> 
> As defined in IEEE Std 802.11-2012.. In other words, MinChannelTime is
> not used with passive scans. As you can see from the mac80211
> implementation in the following patch, that does not use this
> MinChannelTime even for active scans. This could be used for the
> optimization where CCA detection could be used to stop an Active scan
> more quickly. I'm not sure whether we'd ever use this, but well, it was
> easy to include for completeness sake.

Ok.

> > If you specify a very long min_chan_time, that's unlikely to please
> > drivers. Especially if multi-channel mode is implemented, maybe in
> > conjunction with operating as a GO or a client that wants to hear DTIM
> > beacons, this might become very complicated.
> 
> Agreed. I was thinking of adding some limits on how large a value could
> be set, but could not come up with any specific, justifiable value. (And
> the standard was not very helpful either with the "N/A" as the valid
> range ;-).

Heh :)

> That would require knowing the specific use cases first.. :)  In
> general, I'd expect to see need for doing scans that take less time even
> if that results in smaller likelihood of seeing BSSes on the first
> attempt. I could come up with much more difficult designs for the
> driver/firmware to handle, but I'm not sure whether something more
> flexible would be available unless someone can first articulate specific
> use cases.

Hmm. That particular use case ("take less time") doesn't seem very well
defined. Do you mean while already associated? If so, then this could
also be interpreted to mean "I don't care about data traffic much, just
quickly scan everything". Or I guess you more meant it to mean "I care
only about APs that are fast enough", or something similar ...

I'm not totally against this idea, but I think blindly adding the values
isn't a good idea. Some drivers/devices may do some optimisations on
their own without losing much "accuracy" and specifying dwell times
might disable those. So I'd say that at least we should specify that
'normal' scans (for some value of normal) shouldn't be using these
parameters?

johannes

