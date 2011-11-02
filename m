Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52793 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276Ab1KBLyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 07:54:51 -0400
Received: by mail-bw0-f44.google.com with SMTP id t8so63653bka.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2011 04:54:48 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] nl80211: Add probe response offload attribute
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Guy Eilam <guy@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1320228817.3950.38.camel@jlt3.sipsolutions.net>
References: <1319313081-28722-1-git-send-email-guy@wizery.com>
	 <1320055498.2672.10.camel@cumari>
	 <1320228817.3950.38.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 13:54:45 +0200
Message-ID: <1320234885.6647.14.camel@cumari> (sfid-20111102_125454_844335_51B536D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 11:13 +0100, Johannes Berg wrote: 
> On Mon, 2011-10-31 at 12:04 +0200, Luciano Coelho wrote:
> 
> > > + * @NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT: Indicates the support
> > > + *	of probe response offloading by the driver/firmware.
> > > + *	In addition this attribute holds a bitmap of the supported protocols
> > > + *	for offloading using &enum nl80211_probe_resp_offload_support_attr.
> > > + *
> 
> > I'm not sure I understand why we need this.  Why aren't the flags
> > themselves enough?
> 
> Not sure I understand the question?

It was what I meant (and you answered) below. :)


> > Johannes wrote, on a separate thread:
> > > Oh, and probably a regular WIPHY flag that indicates whether the
> > > attribute should be added at all so that it can also be 0 but present
> > > (presence with 0 value indicates something other than not present).
> > 
> > What would be the meaning when the WIPHY flag is set but the attributes
> > are all 0? Wouldn't it mean that we don't support probe_resp offload at
> > all? Or would it mean that we support probe_resp offloading in normal
> > cases (ie. not WCS nor P2P)? If the latter is the case, why not add a
> > bit in the attributes to indicate that "normal" probe_resp offloading is
> > supported? I think this would be cleaner because there wouldn't be any
> > implicit semantics.
> 
> It would mean we don't support probe response offload at all, and as a
> consequence would be more or less equivalent to having 0xfffffff as the
> flags mask (everything is "supported").
> 
> Adding a flag for "normal" doesn't make sense: you can only ever reply
> to "normal" probe requests, you need to send any "special" ones up to
> the host. So each bit in this bitfield essentially says "I support this
> by passing it to the host" -- a bit for "normal" doesn't make sense in
> that context.

Okay, I get it now.  So the flags are actually telling which types of
probe responses the hardware can pass up to the host when probe_resp
offload is in use.

My confusion was because I thought the flags were actually telling which
type of probe_resps the HW could offload.

Thanks for clarifying.

-- 
Cheers,
Luca.

