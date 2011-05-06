Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab1EFNnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 09:43:24 -0400
Subject: Re: [PATCH 2.6.39] mac80211: always clear PS filtering for non-AP
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	greearb@candelatech.com
In-Reply-To: <4DC3F93B.10308@openwrt.org>
References: <1304642474-32935-1-git-send-email-nbd@openwrt.org>
	 <201105061508.20010.chunkeey@googlemail.com> <4DC3F58F.4010007@openwrt.org>
	 <1304688387.3595.8.camel@jlt3.sipsolutions.net>
	 <4DC3F93B.10308@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 15:43:22 +0200
Message-ID: <1304689402.3595.12.camel@jlt3.sipsolutions.net> (sfid-20110506_154327_839291_C63C73D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-06 at 15:35 +0200, Felix Fietkau wrote:

> >>  >>   +		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;

> Rely on what being set in AP mode only? The patch ensures that the flag 
> for *clearing* PS filtering gets set for all non-AP modes. This flag 
> already gets set whenever tx->sta is unset, so I think it also makes 
> sense to extend that for other cases where the hardware is not supposed 
> to enable any PS filtering on its own.

I didn't remember/know about the case where sta is unset, but still,
what if the driver checks for the flag and does something that's only
valid in AP mode? I'm thinking firmware API here, not HW like ath9k.

> > Your patch makes those drivers responsible for checking the mode, but
> > that makes less sense than having drivers that need to do some magic in
> > all modes, no?
> How does my patch make drivers responsible for checking the mode?

Well, say I implement the clearing by sending something command to the
device, like p54. If that's only valid in AP mode in the firmware, now
this driver has to check that it's AP mode, where before it didn't have
to. That's not counting the sta==NULL case I guess.

OTOH, we only have two drivers using the flag anyway. Go figure it out
between those two :)

johannes

