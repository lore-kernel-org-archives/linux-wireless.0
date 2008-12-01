Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58604 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbYLAPm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 10:42:56 -0500
To: "Vivek Natarajan" <vnatarajan@atheros.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
References: <20081202011754.GA9382@myhost.users.atheros.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 01 Dec 2008 17:42:35 +0200
In-Reply-To: <20081202011754.GA9382@myhost.users.atheros.com> (ext Vivek Natarajan's message of "Mon\, 1 Dec 2008 17\:17\:54 -0800")
Message-ID: <87wsej6gwk.fsf@nokia.com> (sfid-20081201_164259_068520_00CF0430)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vnatarajan@atheros.com> writes:

> This patch is based on Kalle's initial RFC patches on dynamic power save.
> Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
> frame, it is appropriate to do it from mac80211. 

Yes, I agree. Actually the way I implemented this in stlc45xx was to
use PS-Poll. In future, it would be nice to have it supported as well,
but we can add it later.

> +	directed_tim = check_tim(&elems, ifsta->aid, &is_mc);
> +
> +	if (directed_tim || is_mc) {
> +		if (local->hw.conf.flags && IEEE80211_CONF_PS) {
> +			local->hw.conf.flags &= ~IEEE80211_CONF_PS;
> +			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +			ieee80211_send_nullfunc(local, sdata, 0);
> +		}
> +	}

Maybe I have been working too much with slow embedded hardware, but can
ath5k really wake up for the beacon, send the beacon to the host,
mac80211 read the beacon and then wakeup the hardware to listen for
multicast frames following the beacon? The multicast frames are sent
immeaditely after the dtim beacon, so this should happen really quick.
But most probably I'm just missing something here.

In stlc45xx the firmware listens automatically for the multicast
beacons following dtim beacons and mac80211 doesn't have to do
anything for them.

> -		ret = ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +			ret = ieee80211_hw_config(local,
> +						  IEEE80211_CONF_CHANGE_PS);
> +			ieee80211_send_nullfunc(local, sdata, 0);

Maybe we should have a seperate function for enabling and disabling
power save mode. So that we don't forget sending of the null frame.

-- 
Kalle Valo
