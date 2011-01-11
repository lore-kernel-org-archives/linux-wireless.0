Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:38419 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab1AKPOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 10:14:09 -0500
Received: by fxm14 with SMTP id 14so6084230fxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 07:14:08 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: Wojciech Dubowik <dubowoj@neratec.com>
Subject: Re: [RFC] mac80211: Wait with enabling beacons on DFS channels
Date: Tue, 11 Jan 2011 16:14:08 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	lrodriguez <lrodriguez@atheros.com>, nbd <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <15461044.40.1294756856032.JavaMail.wlan@CHBU500181>
In-Reply-To: <15461044.40.1294756856032.JavaMail.wlan@CHBU500181>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101111614.09073.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 11, 2011 15:40:56 Wojciech Dubowik wrote:
> Hello,
>   Basic DFS functionality requires that when we change to radar
> enabled channels we need to wait and listen before we can send
> beacons/frames -> Channel Availability Check (CAC).
> There is a case when we can switch to it immediately if we have
> been monitoring it off_channel for specific time. This is bit
> more complicated and doesn't need to be implemented in the first
> place because it's sort of functional optimization.
> 
> Anyway there is a need for mechanism to control when to enable
> beacons if we switch to radar channel.
> 
> Pseudo-code-diff bellow is an example for ath9k where we could enable
> beacons at once or fire a worker to re-enable it after CAC expires
> if radar hasn't been detected. In theory we need only to disable
> beacons because we shouldn't get any directed frames we could reply
> to and stations anyway can't probe directly. In practice to be
> sure it couldn't be probably done with making rx filters more
> restrictive during CAC period. Maybe there are other ways as well.
> 
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -285,8 +285,14 @@
>  	ath9k_hw_set_interrupts(ah, ah->imask);
> 
>  	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
> -		if (sc->sc_flags & SC_OP_BEACONS)
> -			ath_beacon_config(sc, NULL);
> +
> +		if (sc->sc_flags & SC_OP_BEACONS) {
> +			if (channel->flags & IEEE80211_CHAN_RADAR
> +                            && !(channel->flags &
> IEEE80211_CHAN_NOL_FREE)) +				
ieee80211_queue_delayed_work
> +                                      (sc->hw, &sc->dfs_wait_cac_work, 0);
> +			else
> +				ath_beacon_config(sc, NULL);
> +		}
> +
>  		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 
0);
>  		ath_start_ani(common);
>  	}
> 
> 
> 
> Problem with this solution is that every driver would need to do
> their own timers and state machines to get this functionality which
> is shared by all.
> I don't know about other driver's structures but maybe a better way
> would be to implement mac80211 command to disable/enable beacons and
> set rx filters which every driver supporting DFS would have to implement.
> Mac80211 would have then timer which would control when to enable
> beacons. I guess Non Occupancy List (NOL) would be handled there as
> well so all the DFS timers could be in the same place.
> 
> Any comments?

Afaik we did discuss this on IRC a few weeks ago and if I remember correctly 
we decided to discard any configuration request before the CAC is over and the 
channel is marked as 'clean'. As in, hostapd is modified such that it sends a 
'do radar stuff now' command and only if the channel can be marked as clean  
sending the actual configuration, in between those is the CAC period.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
