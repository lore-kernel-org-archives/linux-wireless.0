Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58342 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbZDTS3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 14:29:51 -0400
Date: Mon, 20 Apr 2009 21:29:37 +0300
From: Jouni Malinen <j@w1.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
Message-ID: <20090420182937.GA30428@jm.kir.nu> (sfid-20090420_202954_255965_F3B20A5F)
References: <1239837672.11795.46.camel@violet> <1239875168.9737.10.camel@johannes.local> <1240247636.5260.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1240247636.5260.11.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 20, 2009 at 06:13:56PM +0100, Marcel Holtmann wrote:

> so I had time to log the details now. I still have the problem that the
> association only works once. If it ever breaks it never works again. I
> hope this is not something stupid in the iwlagn driver for the 5350
> hardware.

Is the problem you described in the first message on this thread
something different or is this still expected to be the same issue? I'm
trying to understand the part about this being somehow tied to scanning
(NM enabled vs. disabled). Does this happen if you have NM disabled
(i.e., nothing triggering background scans)?


> This is from wpa_supplicant (latest version from GIT of course):
> 
> CTRL-EVENT-SCAN-RESULTS 

..

When you have a chance to run this again, I would be interested in
seeing more details debug log from wpa_supplicant (-ddt on command
line). From this excerpt, it seems like the issue would not be in
association, but on something after that. This kind of log could be
produced, e.g., when EAPOL frames are not delivered at all for some
reason, but the log does not have enough details to confirm whether that
was the case.

> Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
> Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
> Associated with 00:1f:3f:19:d8:b7
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys

Would you happen to have any idea on how timing for the last two
entries, i.e., how long time it took from association to disconnection?


> wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
> wlan0: associated

> wlan0: deauthenticated (Reason: 2)

This would indicate that the AP accepted association, but for some
reason, decided to kick the STA out. Which AP is it?

If the deauthentication did not happen immediately after association,
this could be indication of failed 4-way handshake; wpa_supplicant debug
log would hopefully help in figuring out whether that is the case. If
wpa_supplicant log does not show any EAPOL frames, it would be
interesting to see a wireless capture log showing all the frames the AP
is sending out during the authentication process.

-- 
Jouni Malinen                                            PGP id EFC895FA
