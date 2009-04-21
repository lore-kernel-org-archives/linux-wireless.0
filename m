Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40655 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZDUKrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 06:47:33 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090420182937.GA30428@jm.kir.nu>
References: <1239837672.11795.46.camel@violet>
	 <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <20090420182937.GA30428@jm.kir.nu>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 11:47:30 +0100
Message-Id: <1240310850.5260.21.camel@localhost.localdomain> (sfid-20090421_124737_260312_F4F65C99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> > so I had time to log the details now. I still have the problem that the
> > association only works once. If it ever breaks it never works again. I
> > hope this is not something stupid in the iwlagn driver for the 5350
> > hardware.
> 
> Is the problem you described in the first message on this thread
> something different or is this still expected to be the same issue? I'm
> trying to understand the part about this being somehow tied to scanning
> (NM enabled vs. disabled). Does this happen if you have NM disabled
> (i.e., nothing triggering background scans)?

the scanning comes into play since it triggers the initial
disassociation. You can do that manually by killing wpa_supplicant and
get the same effect.

> > This is from wpa_supplicant (latest version from GIT of course):
> > 
> > CTRL-EVENT-SCAN-RESULTS 
> 
> ..
> 
> When you have a chance to run this again, I would be interested in
> seeing more details debug log from wpa_supplicant (-ddt on command
> line). From this excerpt, it seems like the issue would not be in
> association, but on something after that. This kind of log could be
> produced, e.g., when EAPOL frames are not delivered at all for some
> reason, but the log does not have enough details to confirm whether that
> was the case.

I will try to get you the detailed logs. I am not at home right now, but
hopefully my travel access points lets me reproduce it. However I do
have seen the same thing with an AP not using any security at all.

> > Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
> > Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
> > Associated with 00:1f:3f:19:d8:b7
> > CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> 
> Would you happen to have any idea on how timing for the last two
> entries, i.e., how long time it took from association to disconnection?

Like 2-5 seconds. Not more.

> > wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
> > wlan0: associated
> 
> > wlan0: deauthenticated (Reason: 2)
> 
> This would indicate that the AP accepted association, but for some
> reason, decided to kick the STA out. Which AP is it?

It is an AVM Fritz!Box 7270 with their latest firmware. Could the
enabled WPS mess things up here?

> If the deauthentication did not happen immediately after association,
> this could be indication of failed 4-way handshake; wpa_supplicant debug
> log would hopefully help in figuring out whether that is the case. If
> wpa_supplicant log does not show any EAPOL frames, it would be
> interesting to see a wireless capture log showing all the frames the AP
> is sending out during the authentication process.

Will try to get you all the details needed. Funny part here is that the
problems stated with my 5350 card. The old 4965 in my X61 used to work
perfectly fine with the exact same access point.

Regards

Marcel


