Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:13724 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYEPXsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 19:48:09 -0400
Received: by wa-out-1112.google.com with SMTP id j37so506492waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 16:48:09 -0700 (PDT)
Subject: Re: [RFC-PATCH] mac80211: add helpers for frame control tests
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210975426.6381.70.camel@johannes.berg>
References: <1210966154.5915.50.camel@brick>
	 <1210966704.5915.51.camel@brick>
	 (sfid-20080516_213833_934385_1E372539)  <1210969866.6381.46.camel@johannes.berg>
	 <1210971848.5915.58.camel@brick>
	 (sfid-20080516_230412_000613_CA74646C)  <1210972335.6381.52.camel@johannes.berg>
	 <1210975040.5915.63.camel@brick>
	 (sfid-20080516_235723_605932_ED6BE89E)  <1210975426.6381.70.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 16 May 2008 16:48:07 -0700
Message-Id: <1210981687.5915.67.camel@brick> (sfid-20080517_014818_368555_683F5D7E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-17 at 00:03 +0200, Johannes Berg wrote:
> On Fri, 2008-05-16 at 14:57 -0700, Harvey Harrison wrote:
> > On Fri, 2008-05-16 at 23:12 +0200, Johannes Berg wrote:
> > > 
> > > Right. Still, I think it should be named with _is_ in there.
> > 
> > Yes, I agree with you, that's what I meant to write.
> 
> Actually, maybe it should be "has" and not "is" since it's being passed
> a frame that can *have* a given frame type, and is a frame of a given
> type. Dunno.

I think _is_ works best, I'll send out a few trial patches, but this
seems to make sense in the places its used.

> 
> > Ahhh, I see what you are getting at now, how about ieee80211_stype_mask?
> > 
> > That makes the & a little clearer and has better semantic meaning.
> > 
> > The other option is still to call it stype_mask, but change it to
> > return a __le16....so tests against != 0 still work and really
> > is just a wrapper around the byteswap of the constant and the &.
> 
> Hmm. I'm not sure, how is all this really used? It seems you want
> 
> ieee80211_has_qos_stype(hdr)
> and
> 
> ieee80211_has_stype(hdr, stype)
> 
> instead, no?

Just the latter I think.  But I'll do a few patches to see how it looks
first.  If there end up being a few common ones (like qos) a few
short-hand versions might be appropriate, I'll see how it goes.

Harvey

