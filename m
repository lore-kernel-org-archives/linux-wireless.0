Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1KBKNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 06:13:43 -0400
Subject: Re: [PATCH v2 1/3] nl80211: Add probe response offload attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: Guy Eilam <guy@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1320055498.2672.10.camel@cumari>
References: <1319313081-28722-1-git-send-email-guy@wizery.com>
	 <1320055498.2672.10.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 11:13:37 +0100
Message-ID: <1320228817.3950.38.camel@jlt3.sipsolutions.net> (sfid-20111102_111347_098197_AD456333)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-31 at 12:04 +0200, Luciano Coelho wrote:

> > + * @NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT: Indicates the support
> > + *	of probe response offloading by the driver/firmware.
> > + *	In addition this attribute holds a bitmap of the supported protocols
> > + *	for offloading using &enum nl80211_probe_resp_offload_support_attr.
> > + *

> I'm not sure I understand why we need this.  Why aren't the flags
> themselves enough?

Not sure I understand the question?

> Johannes wrote, on a separate thread:
> > Oh, and probably a regular WIPHY flag that indicates whether the
> > attribute should be added at all so that it can also be 0 but present
> > (presence with 0 value indicates something other than not present).
> 
> What would be the meaning when the WIPHY flag is set but the attributes
> are all 0? Wouldn't it mean that we don't support probe_resp offload at
> all? Or would it mean that we support probe_resp offloading in normal
> cases (ie. not WCS nor P2P)? If the latter is the case, why not add a
> bit in the attributes to indicate that "normal" probe_resp offloading is
> supported? I think this would be cleaner because there wouldn't be any
> implicit semantics.

It would mean we don't support probe response offload at all, and as a
consequence would be more or less equivalent to having 0xfffffff as the
flags mask (everything is "supported").

Adding a flag for "normal" doesn't make sense: you can only ever reply
to "normal" probe requests, you need to send any "special" ones up to
the host. So each bit in this bitfield essentially says "I support this
by passing it to the host" -- a bit for "normal" doesn't make sense in
that context.

johannes

