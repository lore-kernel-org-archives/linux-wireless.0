Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1DOIwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 04:52:41 -0400
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20110415084005.GC11576@hertz.marvell.com>
References: <20110415045321.GA11504@hertz.marvell.com>
	 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
	 <20110415084005.GC11576@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 10:52:34 +0200
Message-ID: <1302857554.3572.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-15 at 14:10 +0530, Yogesh Ashok Powar wrote:

> Define a flag say IEEE80211_CRYPTO_NO_TAILROOM_NEEDED per key. Drivers
> need to set this flag in set_key handler for the keys which requires no
> extra tailroom.

This isn't necessary. You already know from the existing flags, the only
relevant one is IEEE80211_KEY_FLAG_GENERATE_MMIC which must be unset.

> Then Skip the code which expands the skb iff
> IEEE80211_CRYPTO_NO_TAILROOM_NEEDED is set and the key is programmed
> into the hardware (checking KEY_FLAG_UPLOADED_TO_HARDWARE).

You don't know the key at this point, so you have to keep track of
whether this is true for all keys, which depends on whether or not
they're already programmed into the HW (since for SW crypto we need the
tailroom)

johannes

