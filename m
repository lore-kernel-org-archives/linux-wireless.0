Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3C0NOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 09:14:52 -0400
Message-ID: <1364390086.8388.7.camel@jlt4.sipsolutions.net> (sfid-20130327_141510_198051_190FE596)
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Wed, 27 Mar 2013 14:14:46 +0100
In-Reply-To: <87li993mug.fsf@sycorax.lbl.gov> (sfid-20130326_215912_863066_7A8A33F1)
References: <87li993mug.fsf@sycorax.lbl.gov>
	 (sfid-20130326_215912_863066_7A8A33F1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-26 at 13:52 -0700, Alex Romosan wrote:
> since v3.9-rc1 i have been unable to reconnect to my access point. the
> access point is a netgear n600 and the my card is a Centrino Advanced-N
> 6205 [Taylor Peak] (rev 34). the last kernel that worked was 3.8. when i
> boot up the laptop the connection is established but if i bring down the
> network with ifdown then i cannot reconnect. this is what i see in the
> logs:
> 
>  iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>  iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
>  wlan0: authenticate with xx:xx:xx:xx:xx:xx
>  wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
>  wlan0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
>  wlan0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
>  wlan0: authentication with xx:xx:xx:xx:xx:xx timed out

That sounds like it stopped the queues. Can you check debugfs:

cat /sys/kernel/debug/ieee80211/phy0/queues

when this happens?

> today i discovered that this happens only if i connect to the 5GHz.
> connecting to 2.4GHz works on resume. i tried to do a 'git bisect start
> -- drivers/net/wireless' and i ended up with
> 
> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [e1a0c6b3a4b27ed5f21291d0bbee2167ec201ef5] mac80211: stop toggling IEEE80211_HT_CAP_SUP_WIDTH_20_40
> 
> but i haven't been able to revert it cleanly so i don't know if that's
> the problem or not?

I don't think it can be the problem since this should only affect things
after the association succeeded, but you restricted the bisect to the
drivers which was probably too much.

git bisect start -- drivers/net/wireless net/wireless net/mac80211

would probably have been more successful.

johannes

