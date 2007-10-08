Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.apprion.com ([204.16.158.2]:10966 "EHLO MEKONG.apprion.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753224AbXJHVe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 17:34:56 -0400
Message-ID: <470A9EB1.4030706@apprion.com> (sfid-20071008_223531_815265_623236BA)
Date: Mon, 08 Oct 2007 14:18:41 -0700
From: Michael Taylor <mike.taylor@apprion.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 2/6] ath5k: Enable radar detection
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo> <20071006011837.GB25022@pogo> <40f31dec0710070256y261199abw54e8e8dafab3ffb6@mail.gmail.com> <40f31dec0710070328r71d986bcm2b3fa78130052cb3@mail.gmail.com> <20071008203415.GA7633@pogo>
In-Reply-To: <20071008203415.GA7633@pogo>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> So far I haven't received one AR5K_INT_RXPHY interrupt yet. Mind you we
> are already setting radar to 1 too -- we do this at the end of
> ath_reset() with ath5k_hw_enable_radar_alert() -- so not sure what's
> going on. I do live in front of a cemetery...
>   
You may be using an AR5210 chip?

Look at madwifi-dfs branch in madwifi.org for an example of how to 
configure the pulse detector. To get radar pulse detection to work you 
have to update the pulse detection configuration, disable the filtering 
of PHY radar errors, and enable the radar detection. Then you should be 
able to get the errors just by playing a video (such as the one provided 
by the FCC) between a client and the AP. You should get enough false 
positives from the pulse detector to notice. You won't get them from an 
idle AP, and you are very unlikely to detect real radar (in my 
experience). I work at NASA Research Park at what was formerly Moffett 
Air Base. There's an airport less than 1 mile away and I've never 
detected true radar.

IMPORTANT: The Atheros hardware 5212 and higher provides only pulse 
detection, NOT radar detection. The 5210 stuff doesn't even provide 
radar errors or pulse detection... it's supposed to be possible to use 
zero-byte packets with PHYERR or something if you disable filtering of 
zero byte packets, but I haven't tried it.

The driver has to match the pulses to known patterns and filter out the 
noise. It has to be able to filter out excess pulses and handle missed 
pulses (you can't detect radar while transmitting). That's why the 
madwifi-dfs branch has been brewing for longer than you might think. The 
Atheros proprietary drivers provide one implementation of matching and 
the madwifi-dfs branch currently works for all short-pulse type radars, 
and isn't quite ready for prime time for long pulse type radars.

BTW, there are a lot more details to DFS than getting a pulse error from 
the hardware... but I'll assume you know what has to happen at the 
higher levels.

For the lower level stuff, feel free to send me any questions you have 
for Atheros radar detection.

- M
> Anyway IMO we shouldn't handle radar detection but simply pass it down
> to the upper layers, in this case mac80211. It seems for DFS this
> would mean to force to change channels and blacklist the channel for
> 30 minutes. If this interrupt *does* prove to be very noisy we can 
> simply disable the AR5K_RX_FILTER_RADARERR and even AR5K_RX_FILTER_PHYERR
> later. Perhaps AR5K_RX_FILTER_RADARERR should be enabled during
> configure_filter() through mac80211 to indicate when we do *need* DFS.
> Right now AR5K_RX_FILTER_PHYERR is enabled when mac80211 tells us
> about FIF_FCSFAIL | FIF_PLCPFAIL, we also keep the current 
> hw settings on AR5K_PHY_ERR_FIL (AR5K_PHY_ERR_FIL_RADAR, 
> AR5K_PHY_ERR_FIL_OFDM or AR5K_PHY_ERR_FIL_CCK).
>
> Comments?
>
>   Luis
>   
