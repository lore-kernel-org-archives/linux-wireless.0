Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48126 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbeHMNIf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 09:08:35 -0400
Message-ID: <1534155955.3093.4.camel@sipsolutions.net> (sfid-20180813_122701_373872_C1480C3D)
Subject: Re: help understanding HT capabilities bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Danek Duvall <duvall@comfychair.org>,
        linux-wireless@vger.kernel.org
Date: Mon, 13 Aug 2018 12:25:55 +0200
In-Reply-To: <20180726234329.GA28336@lorien.comfychair.org> (sfid-20180727_015016_083628_F55431C9)
References: <20180726234329.GA28336@lorien.comfychair.org>
         (sfid-20180727_015016_083628_F55431C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-07-26 at 16:43 -0700, Danek Duvall wrote:
> I'm writing a library using the nl80211 family to, well, do basically what
> iw does (I want a reusable Golang-native implementation, which saves me
> from parsing iw's output).  I have most of the bits that I need, but I'd
> like to fill out more of the library and make it useful to others.

Yes please, don't parse iw output :-)

> I'm a bit stuck on properly naming and describing the pieces of the HT
> capabilities represented by NL80211_BAND_ATTR_HT_CAPA.  While being
> generally impressed with the amount of documentation in nl80211.h and other
> places, I've been unable to find any documentation on this particular
> field, other than what iw prints for each bit or bit combination.

This comes straight from the 802.11 spec, and we usually have less info
on fields like that.

> My first thought was that it was the set of per-band capabilities for the
> device (as defined by either the hardware or the driver, but either way
> below me enough that I don't think I care), and for the most part I still
> think that's right.  

Yes.

> But when it came to trying to represent the SMPS bits,
> it occurred to me that perhaps that wasn't right, since one of the
> supported values gets printed as "disabled", which seems more like a state
> than a capability.  

Yes, also true to some extent.

> Also, "static" and "dynamic" are not representable
> separately, and set together, you get "disabled".  But perhaps "disabled"
> is really "unsupported", and "static" and "dynamic" can't both be supported
> on the same band?

No, you really have "disabled", "static" and "dynamic" as three states
represented in the 2 bits.

> Otherwise, how should I interpret this?  I could simply leave it as a 0-3
> value and let consumers handle the interpretation, but I'd like to be a bit
> friendlier than that, if I can.

They're just the (default) state - disabled, static, dynamic (and
reserved).

However, it really is just the default - the (non-AP) device may change
it on the fly using action frames.

It's not going to be very useful to userspace consumers, I think, since
it doesn't reflect the *current* state.

johannes
