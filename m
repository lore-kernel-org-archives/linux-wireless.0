Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53020 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbZDWSKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 14:10:03 -0400
Date: Thu, 23 Apr 2009 21:09:28 +0300
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?B?R8OhYm9y?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 0/5] mac80211, iwlwifi, ath9k: Fix rate scaling for
	IEEE80211_TX_CTL_NO_ACK packets
Message-ID: <20090423180928.GA22426@jm.kir.nu> (sfid-20090423_201009_177116_78071BF9)
References: <69e28c910904231035u7ff2d9bbnbf1a74ece718659@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <69e28c910904231035u7ff2d9bbnbf1a74ece718659@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 23, 2009 at 07:35:55PM +0200, G=C3=A1bor Stefanik wrote:
> Handling of multicast/NO_ACK packets by mac80211 rate scaling is a
> mess. Basically, the rule of thumb is that any packet with
> IEEE80211_TX_CTL_NO_ACK (including multicasts and broadcasts, which
> always have this flag set) should be sent at lowest rate (unless
> overridden by radiotap - this is not covered in this patchset), with
> no retries.

While this may be the case with the current rate control
implementations, this is not a good assumption to make.
Multicast/broadcast frames could (and often really should) be
transmitted at higher rate, i.e., the rate control algorithm could
figure out that all associated STAs should be able to receive frames at
a higher basic rate.

As far as unicast no-ACK frames are concerned, those could (and again,
should) be sent at higher rate, too, if the receiving STA can be assume=
d
to be able to receive the frame with "large enough" probability.

> So, the right thing to do in any rate scaling algorithm:
>  * Check for IEEE80211_TX_CTL_NO_ACK. No need to check
> is_multicast_ether_addr, as multicasts always have NO_ACK set.
>  * If it is set, select the lowest available rate (unless overridden
> by radiotap), with a retry count of 0 (total try count of 1).

I would not agree with these as general rules for all rate control
algorithms.

--=20
Jouni Malinen                                            PGP id EFC895F=
A
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
