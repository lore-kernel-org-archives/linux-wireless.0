Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49689 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZAaVqC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 16:46:02 -0500
Message-ID: <4984C684.5060601@openwrt.org> (sfid-20090131_224609_098565_7359E5DA)
Date: Sat, 31 Jan 2009 22:45:40 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
References: <20090131023147.GE3342@makis>	 <20090131170802.GA16826@hash.localnet>	 <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>	 <49849ED9.6080300@openwrt.org> <40f31dec0901311250q6a669849x1dfbf08d967787be@mail.gmail.com>
In-Reply-To: <40f31dec0901311250q6a669849x1dfbf08d967787be@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:
>>> My intention is to reimplement hw_htoclock to account for half/quarter
>>> rate so it'll soon be
>>> clock = ath5k_hw_htoclock(1, channel->hw_value);
>> AFAIK Sam's HAL might have a bug there. If I remember correctly, the MAC
>> runs at the same clock speed with Half/Quarter rate.
>> It's done that way in the legacy HAL. Though there is a possibility of
>> it being hardware dependent, I'm pretty sure that it is that way at least
>> on 5413.
>>
> 
> Both HALs tweak clock this way on ar5212SetDeltaSlope on all chips. If
> clock depends on channel bandwidth for turbo it makes sense to also
> change on half/quarter rate operation.
Yeah, for the delta slope it may be the same, but not for the MAC, IMHO.
Check out ath_hal_mac_clks in the legacy HAL and Sam's HAL. I believe
the legacy HAL variant is correct in this case.

- Felix
