Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3HSPus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 11:50:48 -0400
Message-ID: <1376927430.14734.15.camel@jlt4.sipsolutions.net> (sfid-20130819_175051_990561_2DFFDBDB)
Subject: Re: Wireless disassociations..
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
	John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Mon, 19 Aug 2013 17:50:30 +0200
In-Reply-To: <CA+55aFwSF9e5hHMQgmbmoyPm0Z-YJK43ycgnB8ZkXtsL6xSaTA@mail.gmail.com> (sfid-20130819_174540_576480_952E41DA)
References: <CA+55aFwSF9e5hHMQgmbmoyPm0Z-YJK43ycgnB8ZkXtsL6xSaTA@mail.gmail.com>
	 (sfid-20130819_174540_576480_952E41DA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-08-19 at 08:45 -0700, Linus Torvalds wrote:
> Is anybody following this bugzilla?
> 
>    https://bugzilla.kernel.org/show_bug.cgi?id=60690
> 
> it has a bisection in it, and a patch?

It just came back to me and I commented on it - I think/hope that
commits
ddfe49b42d8ad4bfdf92d63d4a74f162660d878d (mac80211: continue using disabled channels while connected)
5cdaed1e878d723d56d04ae0be1738124acf9f46 (mac80211: ignore HT primary channel while connected)

will have fixed this case as well as
https://bugzilla.redhat.com/show_bug.cgi?id=981445

> The patch is a bit odd, but quite frankly, the current values for
> IEEE80211_HT_PARAM_CHA_SEC_xxx are (a) odd and (b) used very oddly
> too. Is it possible that that 0x03 really should be 0x02?

The patch basically removes the code, the value really should be 0x3 as
defined by the 802.11 spec table 8-130:

        Set to 1 (SCA) if the secondary channel is secondary channel
        relative to above the primary channel the primary channel.
        
        Set to 3 (SCB) if the secondary channel is below the primary
        channel
        
        Set to 0 (SCN) if no secondary channel is present
        
        The value 2 is reserved

(it's a two-bit field)

johannes

