Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50213 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab1EFNrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 09:47:45 -0400
Message-ID: <4DC3FBFF.1010504@openwrt.org> (sfid-20110506_154748_604664_DD10023B)
Date: Fri, 06 May 2011 15:47:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	greearb@candelatech.com
Subject: Re: [PATCH 2.6.39] mac80211: always clear PS filtering for non-AP
 interfaces
References: <1304642474-32935-1-git-send-email-nbd@openwrt.org>	 <201105061508.20010.chunkeey@googlemail.com> <4DC3F58F.4010007@openwrt.org>	 <1304688387.3595.8.camel@jlt3.sipsolutions.net>	 <4DC3F93B.10308@openwrt.org> <1304689402.3595.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1304689402.3595.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-06 3:43 PM, Johannes Berg wrote:
> On Fri, 2011-05-06 at 15:35 +0200, Felix Fietkau wrote:
>
>>  >>   >>    +		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>
>>  Rely on what being set in AP mode only? The patch ensures that the flag
>>  for *clearing* PS filtering gets set for all non-AP modes. This flag
>>  already gets set whenever tx->sta is unset, so I think it also makes
>>  sense to extend that for other cases where the hardware is not supposed
>>  to enable any PS filtering on its own.
>
> I didn't remember/know about the case where sta is unset, but still,
> what if the driver checks for the flag and does something that's only
> valid in AP mode? I'm thinking firmware API here, not HW like ath9k.
>
>>  >  Your patch makes those drivers responsible for checking the mode, but
>>  >  that makes less sense than having drivers that need to do some magic in
>>  >  all modes, no?
>>  How does my patch make drivers responsible for checking the mode?
>
> Well, say I implement the clearing by sending something command to the
> device, like p54. If that's only valid in AP mode in the firmware, now
> this driver has to check that it's AP mode, where before it didn't have
> to. That's not counting the sta==NULL case I guess.
>
> OTOH, we only have two drivers using the flag anyway. Go figure it out
> between those two :)
mac80211 already sets the flag for all modes. If drivers were depending 
on it being set only for AP mode, then those drivers would break even 
without my patch.

- Felix
