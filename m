Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab1DOLBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 07:01:50 -0400
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20110415105140.GD11576@hertz.marvell.com>
References: <20110415045321.GA11504@hertz.marvell.com>
	 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
	 <20110415084005.GC11576@hertz.marvell.com>
	 <1302857554.3572.14.camel@jlt3.sipsolutions.net>
	 <20110415105140.GD11576@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 13:01:44 +0200
Message-ID: <1302865304.3572.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-15 at 16:21 +0530, Yogesh Ashok Powar wrote:

> > > Then Skip the code which expands the skb iff
> > > IEEE80211_CRYPTO_NO_TAILROOM_NEEDED is set and the key is programmed
> > > into the hardware (checking KEY_FLAG_UPLOADED_TO_HARDWARE).
> > 
> > You don't know the key at this point, so you have to keep track of
> > whether this is true for all keys, which depends on whether or not
> > they're already programmed into the HW (since for SW crypto we need the
> > tailroom)
> From this it seems that we do not reserve tailroom iff
> IEEE80211_KEY_FLAG_GENERATE_MMIC flag is unset for all keys and all the keys
> are programmed into the hardware.
> 
> Also, say in mixed mode if TKIP and CCMP keys are configured and this
> flag is set for TKIP MMIC, we will end up reserving tailroom even for
> CCMP.  Is my understanding correct?

Yes, correct.

> Also, though I have not looked into this part of the code very closely,
> how about deriving key information at this place? Will that be feasible?

No, we can't do it here. I suppose we could postpone it for per key
stuff, but that's more complex and probably good for a separate patch.

johannes

