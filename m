Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li674-96.members.linode.com ([212.71.239.96]:44309 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbaAGQ05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 11:26:57 -0500
Date: Tue, 7 Jan 2014 18:26:55 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/3] cfg80211: MinChannelTime and MaxChannelTime for scan
 requests
Message-ID: <20140107162655.GB9092@w1.fi> (sfid-20140107_172700_839144_85ED0FEB)
References: <20140106075126.GA31046@w1.fi>
 <1389110387.4645.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389110387.4645.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 07, 2014 at 04:59:47PM +0100, Johannes Berg wrote:
> On Mon, 2014-01-06 at 09:51 +0200, Jouni Malinen wrote:
> > This adds new nl80211 attributes to allow MinChannelTime and
> > MaxChannelTime to be specified for scan requests. The parameters can be
> > used to control the amount of time spent on each channel during a scan
> > as specified in the IEEE Std 802.11-2012 MLME-SCAN.request() primitive.
> 
> What are the specific use cases for this? Our driver is likely to muck
> around with these in the future, possibly depending on traffic levels
> etc., so I wonder what this addresses and whether it can be unified in
> some way?

I don't have any specific use case in mind. These are parameters
included in the standard and there are various new use cases coming up
for IEEE 802.11 scanning and those could potentially be able to use this
type of parameters. Similarly, I'd actually like to see quite a bit
additional flexibility in scanning operations like partial scan reports
(event notification of updated BSSes per channel etc.) and aborting
scans, etc., that has also come up in the past.

> Would you expect these to always be specified, to the point where our
> driver no longer has any flexibility in adjusting things internally?

Maybe for some use cases, but unlikely for the find an AP to connect to
case.

> > + * @min_chan_time: MinChannelTime in TUs; time to spend waiting for
> > + * PHY-CCA.indication (channel busy) in Active scan; 0 to indicate that driver
> > + * default value to be used
> > + * @max_chan_time: MaxChannelTime in TUs; time to spend waiting for Beacon or
> > + * Probe Response frames; 0 to indicate that driver default value to be used
> 
> missing some indentation

Different coding styles.. I can handle this whenever there is an example
close-by, but this structure did not have one :).

> > + * @NL80211_ATTR_MIN_CHANNEL_TIME: MinChannelTime - Minimum time (in TU) to
> > + *	spend on each channel when scanning (used for active scans). If not
> > + *	included, the driver will use its default value. u32 attribute.
> 
> What about passive scans?

As defined in IEEE Std 802.11-2012.. In other words, MinChannelTime is
not used with passive scans. As you can see from the mac80211
implementation in the following patch, that does not use this
MinChannelTime even for active scans. This could be used for the
optimization where CCA detection could be used to stop an Active scan
more quickly. I'm not sure whether we'd ever use this, but well, it was
easy to include for completeness sake.

> If you specify a very long min_chan_time, that's unlikely to please
> drivers. Especially if multi-channel mode is implemented, maybe in
> conjunction with operating as a GO or a client that wants to hear DTIM
> beacons, this might become very complicated.

Agreed. I was thinking of adding some limits on how large a value could
be set, but could not come up with any specific, justifiable value. (And
the standard was not very helpful either with the "N/A" as the valid
range ;-).

> I'd be really interested in seeing if we can address the use cases here
> in a different way that keeps more flexibility in the
> driver/firmware/... implementation of scan.

That would require knowing the specific use cases first.. :)  In
general, I'd expect to see need for doing scans that take less time even
if that results in smaller likelihood of seeing BSSes on the first
attempt. I could come up with much more difficult designs for the
driver/firmware to handle, but I'm not sure whether something more
flexible would be available unless someone can first articulate specific
use cases.

-- 
Jouni Malinen                                            PGP id EFC895FA
