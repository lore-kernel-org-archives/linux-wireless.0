Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:47075 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab3A2NOa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 08:14:30 -0500
Message-ID: <5107CB32.2070908@neratec.com> (sfid-20130129_141433_626450_987D89E4)
Date: Tue, 29 Jan 2013 14:14:26 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 0/3] Add DFS master ability
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2013 01:21 PM, Simon Wunderlich wrote:
> [...]
> 
> The channel states are now implemented in cfg80211. Shall we inform userspace
> about channel changes? If yes, how should we do that? We could add channel states
> to the channel list, and give "channel list changed" events to userspace as it
> happens now, or define a new kind of event ("channel-available-again-event").
> Suggestions welcome. :)
> 
An event whenever a channel state changes is perfect, ideally provided with the
time-stamp when this change happened.

With the centralized channel state handling proposed here, the required
modification to allow managed DFS operation can be minimized to a proprietary (or
even upstreamed but CONFIG_CFG80211_CERTIFICATION_ONUS guarded) function to modify
channel states.

Can't contribute much to code review, but full ACK for the updated concept.

> If you prefer, I can split off the channel state stuff from the radar detect
> patches.
> 
> Cheers,
> 	Simon
> 

