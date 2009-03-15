Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20046 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZCOHWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 03:22:53 -0400
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
References: <20090314171234.11126.21125.stgit@tikku>
	<20090314171452.11126.11618.stgit@tikku>
	<43e72e890903141318n25fa5f4bi7903eee2ef216040@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 15 Mar 2009 09:22:38 +0200
In-Reply-To: <43e72e890903141318n25fa5f4bi7903eee2ef216040@mail.gmail.com> (ext Luis R. Rodriguez's message of "Sat\, 14 Mar 2009 21\:18\:14 +0100")
Message-ID: <87r60z1c8x.fsf@nokia.com> (sfid-20090315_082320_267807_7BB45258)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

> Last we reviewed this it seemed we were set on only allowing this for
> hardware which supports beacon filtering with support for checksumming
> of the beacons. Reason checksumming is important is for considerations
> of DFS with the channel switch announcements, HT with with channel width
> changes. In fact I'm curious why checksumming would be required for 2.4 GHz
> single band devices. Kalle, do you happen to know?

In my opinion also 2.4 GHz band needs checksum support. At least ERP
protection changes come to my mind, but maybe there are also others.

> Considering that power saving features are important I think its
> worth to revisit this position in detail.
>
> An alternative to this above position is that if the devices do not
> support checksumming of the beacons to let the driver figure when
> this should be enabled dynamically. For example if devices do not
> support checksumming but are single 2.4 GHz band non-HT capable
> devices we should let drivers enable this feature.
>
> Other devices which do not support checksumming should only enable this only
> when associating to an AP on non-DFS channels and when not using HT.

I'm not fully convinced about this.

> In practice this would mean allowing both ath5k and ath9k to take advantage
> of this feature.

Do you mean that they have beacon filter support but do not do any
checksumming in hardware?

Other option is that the hardware which does not support checksumming
would just pass beacons periodically to the stack, for example every 5
seconds. Even though beacon filter is enabled in mac80211 it does not
prevent hardware from sending beacons. This is not the most optimal
solution, but there's not much choices if the hardware doesn't support
checksumming.

> Technically we could move the conditional logic check when this
> should be enabled to mac80211 as well. When we reviewed this it was
> seen as unnecessary complexity, I actually don't see it as too
> complex and think the the advantage is worth to consider.
>
> Thoughts?

I think this is future stuff, I would like to get the basic (and the
simplest) implementation to the tree first and then we can start
improving and extending it.

-- 
Kalle Valo
