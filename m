Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58920 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2KAHzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 03:55:37 -0400
Message-ID: <50922AAF.3060605@ti.com> (sfid-20121101_085546_572289_8EC21A1D)
Date: Thu, 1 Nov 2012 09:54:23 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"adrian.chadd@gmail.com" <adrian.chadd@gmail.com>,
	"j@w1.fi" <j@w1.fi>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"coelho@ti.com" <coelho@ti.com>, "igalc@ti.com" <igalc@ti.com>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	"nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
References: <1350226137-13704-1-git-send-email-victorg@ti.com> <1350226137-13704-6-git-send-email-victorg@ti.com> <5086371D.2080108@tieto.com>
In-Reply-To: <5086371D.2080108@tieto.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23/10/2012 08:20, Michal Kazior wrote:
> On 14/10/12 16:48, Victor Goldenshtein wrote:
>> +static int nl80211_ap_channel_switch(struct sk_buff *skb,
>> +                     struct genl_info *info)
>> +{
>
> This function should probably enforce interface combinations with
> `cfg80211_can_use_chan()`. Otherwise we might end up in a state which
> doesn't correspond to any interface combination - and won't be able to
> bring up new interfaces.
>

I guess you're right, we probably should check here whether we can 
switch to the next channel (with cfg80211_can_use_chan) and in the case 
we're not, the AP/GO should be disabled.

> This however introduces a new problem. Let's suppose we have 2 APs on
> channel 1. The device doesn't support multi-channel. We won't be able to
> switch channel on these APs at all.
>
> We might want to change the channel switch to resolve around the channel
> itself (not the interface) - so we'd be saying "move all interfaces with
> channel X to channel Y" instead of "move interface X to channel Y".
>
> Or we could let the driver decide what it'll do - e.g. silently switch
> more than one interface to a different channel (which makes sense with
> AP/DFS I guess) and just notify cfg/userspace about it. That would
> require us to provide a way to switch interfaces (atomically possibly)
> between channels while keeping in sync with interface combinations though.
>

If the driver/device supports MR only on a SC - means it doesn't 
supports channel switch in MR, so basically the radar detection event 
triggers AP channel switch which fails (with this new check) and the AP 
shut down.
Of course there are possible driver specific workarounds (as you 
mentioned above) but these are not part of this series.

Just for interest's sake, what is the use case having two APs on the 
same channel?

-- 
Thanks,
Victor.
