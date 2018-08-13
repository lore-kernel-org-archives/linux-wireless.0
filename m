Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lorien.comfychair.org ([173.8.144.98]:65145 "EHLO
        lorien.comfychair.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728772AbeHMX25 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 19:28:57 -0400
Date: Mon, 13 Aug 2018 13:41:32 -0700
From: Danek Duvall <duvall@comfychair.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: help understanding HT capabilities bits
Message-ID: <20180813204131.GA10207@lorien.comfychair.org> (sfid-20180813_224511_544271_9A01FBD4)
References: <20180726234329.GA28336@lorien.comfychair.org>
 <1534155955.3093.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534155955.3093.4.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2018 at 12:25:55PM +0200, Johannes Berg wrote:

> On Thu, 2018-07-26 at 16:43 -0700, Danek Duvall wrote:
> > I'm writing a library using the nl80211 family to, well, do basically what
> > iw does (I want a reusable Golang-native implementation, which saves me
> > from parsing iw's output).  I have most of the bits that I need, but I'd
> > like to fill out more of the library and make it useful to others.
> 
> Yes please, don't parse iw output :-)

Believe me, I'm trying to get away from that as fast as possible.  :)

> [ ... ]
> > Otherwise, how should I interpret this?  I could simply leave it as a 0-3
> > value and let consumers handle the interpretation, but I'd like to be a bit
> > friendlier than that, if I can.
> 
> They're just the (default) state - disabled, static, dynamic (and
> reserved).
> 
> However, it really is just the default - the (non-AP) device may change
> it on the fly using action frames.
> 
> It's not going to be very useful to userspace consumers, I think, since
> it doesn't reflect the *current* state.

Okay, I think I see: it reflects neither the current state of the device,
nor the capabilities of the device, but the initial, default state of the
device (at power-on, presumably?).  Presumably if it doesn't represent the
current state, then it also never changes.  I don't understand in what
circumstances that's useful.

I also think I now see that the current SMPS state comes from the SMPS_MODE
attribute, and the device capability comes from the FEATURE_STATIC_SMPS and
FEATURE_DYNAMIC_SMPS bits of the FEATURE_FLAGS attribute.  Is that correct?

Do any of the other fields in HT_CAPA (or VHT_CAPA) have the same kind of
meaning as the SMPS bits?  For instance, if the HT20/40 bit is off, then
can we say anything about whether the device supports 40MHz channels (as
I've been interpreting it)?  Or is it also some sort of default value (and
if so, where would I go looking for that particular device capability)?  Is
the answer to that question related to HT_CAPABILITY_MASK?  Basically I'm
wondering if I should ignore HT_CAPA for my purposes (which are to choose a
suitable radio on which to build an AP stack) and pull the data from some
other attributes.

Thanks,
Danek
