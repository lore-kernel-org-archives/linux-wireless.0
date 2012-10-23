Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48098 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2JWGUS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 02:20:18 -0400
Message-ID: <5086371D.2080108@tieto.com> (sfid-20121023_082022_834528_AE0F1A66)
Date: Tue, 23 Oct 2012 08:20:13 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"adrian.chadd@gmail.com" <adrian.chadd@gmail.com>,
	"j@w1.fi" <j@w1.fi>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"coelho@ti.com" <coelho@ti.com>, "assaf@ti.com" <assaf@ti.com>,
	"igalc@ti.com" <igalc@ti.com>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	"nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
References: <1350226137-13704-1-git-send-email-victorg@ti.com> <1350226137-13704-6-git-send-email-victorg@ti.com>
In-Reply-To: <1350226137-13704-6-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/10/12 16:48, Victor Goldenshtein wrote:
> +static int nl80211_ap_channel_switch(struct sk_buff *skb,
> +				     struct genl_info *info)
> +{

This function should probably enforce interface combinations with 
`cfg80211_can_use_chan()`. Otherwise we might end up in a state which 
doesn't correspond to any interface combination - and won't be able to 
bring up new interfaces.

This however introduces a new problem. Let's suppose we have 2 APs on 
channel 1. The device doesn't support multi-channel. We won't be able to 
switch channel on these APs at all.

We might want to change the channel switch to resolve around the channel 
itself (not the interface) - so we'd be saying "move all interfaces with 
channel X to channel Y" instead of "move interface X to channel Y".

Or we could let the driver decide what it'll do - e.g. silently switch 
more than one interface to a different channel (which makes sense with 
AP/DFS I guess) and just notify cfg/userspace about it. That would 
require us to provide a way to switch interfaces (atomically possibly) 
between channels while keeping in sync with interface combinations though.

We might try addressing station CSA issue at the same time maybe?


-- Pozdrawiam / Best regards, Michal Kazior.
