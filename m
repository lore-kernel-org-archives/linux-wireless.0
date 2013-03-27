Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40346 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab3C0S6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 14:58:30 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
References: <87li993mug.fsf@sycorax.lbl.gov>
	<1364406146.8388.12.camel@jlt4.sipsolutions.net>
	<87mwto20q1.fsf@sycorax.lbl.gov>
	<1364406895.8388.14.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Mar 2013 11:58:26 -0700
In-Reply-To: <1364406895.8388.14.camel@jlt4.sipsolutions.net> (message from
	Johannes Berg on Wed, 27 Mar 2013 18:54:55 +0100)
Message-ID: <878v58oejx.fsf@sycorax.lbl.gov> (sfid-20130327_195837_883873_BB5C4D99)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Ok, well, that doesn't tell us all that much since you don't have
> sub-second timestamps. Maybe you can enable printk timestamps:
>
> echo Y > /sys/module/printk/parameters/time

in case it helps. first the logs when the card connected on startup:

[   18.198708] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[   18.236585] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[   18.255020] wlan0: authenticated
[   18.271878] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[   18.273285] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x401 status=0 aid=1)
[   18.275783] wlan0: associated

and then when i took the interface down and tried to bring it back up:

[  135.930592] wlan0: deauthenticating from xx:xx:xx:xx:xx:xx by local choice (reason=3)
[  135.938013] cfg80211: Calling CRDA to update world regulatory domain
[  135.951043] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  135.951274] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  136.072911] cfg80211: World regulatory domain updated:
[  136.072924] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  136.072932] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  136.072938] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  136.072944] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  136.072949] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  136.072955] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  144.804742] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[  144.816187] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  144.821469] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
[  144.826866] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
[  144.832539] wlan0: authentication with xx:xx:xx:xx:xx:xx timed out

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
