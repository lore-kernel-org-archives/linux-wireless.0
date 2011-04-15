Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:60505 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1DOK7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 06:59:43 -0400
Date: Fri, 15 Apr 2011 16:21:44 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
Message-ID: <20110415105140.GD11576@hertz.marvell.com>
References: <20110415045321.GA11504@hertz.marvell.com>
 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
 <20110415084005.GC11576@hertz.marvell.com>
 <1302857554.3572.14.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1302857554.3572.14.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 15, 2011 at 01:52:34AM -0700, Johannes Berg wrote:
> On Fri, 2011-04-15 at 14:10 +0530, Yogesh Ashok Powar wrote:
> 
> > Define a flag say IEEE80211_CRYPTO_NO_TAILROOM_NEEDED per key. Drivers
> > need to set this flag in set_key handler for the keys which requires no
> > extra tailroom.
> 
> This isn't necessary. You already know from the existing flags, the only
> relevant one is IEEE80211_KEY_FLAG_GENERATE_MMIC which must be unset.
Ok. We will use this flag.

> 
> > Then Skip the code which expands the skb iff
> > IEEE80211_CRYPTO_NO_TAILROOM_NEEDED is set and the key is programmed
> > into the hardware (checking KEY_FLAG_UPLOADED_TO_HARDWARE).
> 
> You don't know the key at this point, so you have to keep track of
> whether this is true for all keys, which depends on whether or not
> they're already programmed into the HW (since for SW crypto we need the
> tailroom)
>From this it seems that we do not reserve tailroom iff
IEEE80211_KEY_FLAG_GENERATE_MMIC flag is unset for all keys and all the keys
are programmed into the hardware.

Also, say in mixed mode if TKIP and CCMP keys are configured and this
flag is set for TKIP MMIC, we will end up reserving tailroom even for
CCMP.  Is my understanding correct?

Also, though I have not looked into this part of the code very closely,
how about deriving key information at this place? Will that be feasible?

Thanks
Yogesh
