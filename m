Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39255 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbZDXRty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 13:49:54 -0400
Message-ID: <49F1F789.6090307@openwrt.org> (sfid-20090424_194958_183483_EAAABFE3)
Date: Fri, 24 Apr 2009 19:31:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 0/5] mac80211, iwlwifi, ath9k: Fix rate scaling for	IEEE80211_TX_CTL_NO_ACK
 packets
References: <69e28c910904231035u7ff2d9bbnbf1a74ece718659@mail.gmail.com> <20090423180928.GA22426@jm.kir.nu>
In-Reply-To: <20090423180928.GA22426@jm.kir.nu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> On Thu, Apr 23, 2009 at 07:35:55PM +0200, G=C3=A1bor Stefanik wrote:
>> Handling of multicast/NO_ACK packets by mac80211 rate scaling is a
>> mess. Basically, the rule of thumb is that any packet with
>> IEEE80211_TX_CTL_NO_ACK (including multicasts and broadcasts, which
>> always have this flag set) should be sent at lowest rate (unless
>> overridden by radiotap - this is not covered in this patchset), with
>> no retries.
>=20
> While this may be the case with the current rate control
> implementations, this is not a good assumption to make.
> Multicast/broadcast frames could (and often really should) be
> transmitted at higher rate, i.e., the rate control algorithm could
> figure out that all associated STAs should be able to receive frames =
at
> a higher basic rate.
Good idea. I should implement this in minstrel and use the minimum valu=
e
of max_prob_rate for all stations as multicast rate ;)

Johannes: Can you think of a good way to fit this into the API?

- Felix
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
