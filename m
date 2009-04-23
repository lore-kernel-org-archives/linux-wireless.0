Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:2852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbZDWSS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 14:18:29 -0400
Received: by fg-out-1718.google.com with SMTP id d23so41463fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 11:18:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090423180928.GA22426@jm.kir.nu>
References: <69e28c910904231035u7ff2d9bbnbf1a74ece718659@mail.gmail.com>
	<20090423180928.GA22426@jm.kir.nu>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 23 Apr 2009 20:18:12 +0200
Message-ID: <69e28c910904231118p59695f58q6f0b34f5ff9c953a@mail.gmail.com> (sfid-20090423_201837_770423_4669C569)
Subject: Re: [PATCH 0/5] mac80211, iwlwifi, ath9k: Fix rate scaling for
	IEEE80211_TX_CTL_NO_ACK packets
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/23 Jouni Malinen <j@w1.fi>:
> On Thu, Apr 23, 2009 at 07:35:55PM +0200, G=E1bor Stefanik wrote:
>> Handling of multicast/NO_ACK packets by mac80211 rate scaling is a
>> mess. Basically, the rule of thumb is that any packet with
>> IEEE80211_TX_CTL_NO_ACK (including multicasts and broadcasts, which
>> always have this flag set) should be sent at lowest rate (unless
>> overridden by radiotap - this is not covered in this patchset), with
>> no retries.
>
> While this may be the case with the current rate control
> implementations, this is not a good assumption to make.
> Multicast/broadcast frames could (and often really should) be
> transmitted at higher rate, i.e., the rate control algorithm could
> figure out that all associated STAs should be able to receive frames =
at
> a higher basic rate.
>
> As far as unicast no-ACK frames are concerned, those could (and again=
,
> should) be sent at higher rate, too, if the receiving STA can be assu=
med
> to be able to receive the frame with "large enough" probability.
>
>> So, the right thing to do in any rate scaling algorithm:
>> =A0* Check for IEEE80211_TX_CTL_NO_ACK. No need to check
>> is_multicast_ether_addr, as multicasts always have NO_ACK set.
>> =A0* If it is set, select the lowest available rate (unless overridd=
en
>> by radiotap), with a retry count of 0 (total try count of 1).
>
> I would not agree with these as general rules for all rate control
> algorithms.
>
> --
> Jouni Malinen =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PGP id EFC895FA
>

Yes, I agree what you write - but the point of the patchset is to make
sure that (1) all NO_ACK frames get correct treatment, not just
multicasts and (2) NO_ACK/multicast frames aren't requested to be
retried (which is obviously wrong, and results in always retrying till
the limit is reached). Developing an algorithm to allow NO_ACKs to be
transmitted at a higher rate is beyond the scope of this patchset.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
