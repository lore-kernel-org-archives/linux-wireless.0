Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lorien.comfychair.org ([173.8.144.98]:64457 "EHLO
        lorien.comfychair.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbeHQWcr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Aug 2018 18:32:47 -0400
Date: Fri, 17 Aug 2018 12:22:01 -0700
From: Danek Duvall <duvall@comfychair.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: help understanding HT capabilities bits
Message-ID: <20180817192201.GA12970@lorien.comfychair.org> (sfid-20180817_212904_505465_42C2DDB3)
References: <20180726234329.GA28336@lorien.comfychair.org>
 <1534155955.3093.4.camel@sipsolutions.net>
 <20180813204131.GA10207@lorien.comfychair.org>
 <1534232917.3547.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534232917.3547.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2018 at 09:48:37AM +0200, Johannes Berg wrote:

> Hi,
> 
> > Okay, I think I see: it reflects neither the current state of the device,
> > nor the capabilities of the device, but the initial, default state of the
> > device (at power-on, presumably?).  
> 
> It's really the default state for each new connection, unless it's
> changed. It is actually changed though by mac80211, for example, so it
> probably change these bits before sending them to the AP.
> 
> > Presumably if it doesn't represent the
> > current state, then it also never changes.  I don't understand in what
> > circumstances that's useful.
> 
> It isn't really. It's just a side effect of
>  * the 802.11 protocol including it in the capabilities
>  * nl80211 including the whole protocol struct instead of breaking it up
> 
> > I also think I now see that the current SMPS state comes from the SMPS_MODE
> > attribute, and the device capability comes from the FEATURE_STATIC_SMPS and
> > FEATURE_DYNAMIC_SMPS bits of the FEATURE_FLAGS attribute.  Is that correct?
> 
> Yeah, those are more useful than the capability.
> 
> > Do any of the other fields in HT_CAPA (or VHT_CAPA) have the same kind of
> > meaning as the SMPS bits?  For instance, if the HT20/40 bit is off, then
> > can we say anything about whether the device supports 40MHz channels (as
> > I've been interpreting it)?  Or is it also some sort of default value (and
> > if so, where would I go looking for that particular device capability)?  Is
> > the answer to that question related to HT_CAPABILITY_MASK?  Basically I'm
> > wondering if I should ignore HT_CAPA for my purposes (which are to choose a
> > suitable radio on which to build an AP stack) and pull the data from some
> > other attributes.
> 
> A lot of these might be possible to change, but I think for the most
> part they're static. The 20/40 is a bit special as there's also a
> cfg80211 module parameter that controls it on 2.4 GHz though.

Okay, I think I got it.

Thanks!
Danek
