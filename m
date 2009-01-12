Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45347 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbZALPD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 10:03:59 -0500
Date: Mon, 12 Jan 2009 17:03:48 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: New command for adding extra IE(s) into
	management frames
Message-ID: <20090112150348.GA14029@jm.kir.nu> (sfid-20090112_160404_393934_1A9ADAB5)
References: <20090112122605.GB9153@jm.kir.nu> <1231765724.2998.10.camel@home.berg> <20090112142646.GB12109@jm.kir.nu> <1231771702.3591.2.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231771702.3591.2.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 12, 2009 at 03:48:22PM +0100, Johannes Berg wrote:
> On Mon, 2009-01-12 at 16:26 +0200, Jouni Malinen wrote:
> > +	/* Extra IE data for management frames */
> > +	u8 *ie_probereq;
> > +	size_t ie_probereq_len;
> > +	u8 *ie_proberesp;
> > +	size_t ie_proberesp_len;

> It'd be more memory efficient on 64-bit to not alternate between 64 and
> 32 bit values, but I don't really care too much in this struct.

Yeah.. I could reorder or even change the _len to be u16, but it is
probably cleaner to just leave it as-is taken into account there is only
one of these structs per virtual interface.

> Should we sanity-check the input? E.g. in nl80211, ensure that it's
> (<type><len><data...>)* with <len> being correct and no final padding?
> And maybe that there isn't anything in those IEs that we've already
> added, like an SSID?

I would actually like to be able to include invalid data for testing
purposes and some frames might even not require an IE in the end. Action
frames would be an example of this, but those would require category and
code fields to allow more detailed selection of which frames to extend.
That can be added in the future, if a reasonable use is found. Anyway, I
would not bother adding validating the provided input.

As far as figuring out whether there are any IEs that we (as in
mac80211) have added gets bit complex taken into account that we do not
know that at the time this command is run. It is even more complex for
firmware-generated frames. Furthermore, it is unclear what exactly we
should do if a duplicate IE is found. With some IEs, it is actually find
to have multiple occurrences in the same frame.

If we would like to provide more intelligent processing of such things,
it would probably have to be done on case by case basis and with
different rules for each IE depending on the subtype. For example, some
IEs might be used to replace the generated IE while others would be
added and some might trigger some kind of error notification to
userspace when the frame is being transmitted, etc. This gets very
complex and I would rather not go there before someone comes with a very
good justification and use case explaining why it is needed..

-- 
Jouni Malinen                                            PGP id EFC895FA
