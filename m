Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47640 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbZKIKyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 05:54:08 -0500
Date: Mon, 9 Nov 2009 12:54:10 +0200
From: Jouni Malinen <j@w1.fi>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: erraneous connect with short-slot-time fails
Message-ID: <20091109105410.GA1443@jm.kir.nu>
References: <m3zl6wq8x7.wl%holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <m3zl6wq8x7.wl%holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2009 at 11:39:16AM +0100, Holger Schurig wrote:

> wlan0 (phy #4): assoc 00:1b:d4:44:35:90 -> 00:15:e9:84:1a:54 status: 25: Association request rejected due to requesting station not supporting the short slot time option

> First thing: the error message is confused. I turned off
> short-slot-time on the AP, so it's the AP that does not support it.

However, that text is correct as far as the proper use of status 25 is
concerned. Which AP is this?

> However, the real question remains: why does the station
> (ath5k+mac80211) tries to use short-slot-time in the first place? In
> the probe response, the AP says clearly that he doesn't support this.

IEEE 802.11-2007 states that the station indicates its support for short
slot time in (re)association request. This does not depend what the BSS
is currently using (slot time subfield inbeacon/probe
response/(re)association response frames).

> CONCLUSION: mac80211 tries to use short-slot time.

No.. It only indicates that it supports short slot time. It is up to the
AP to decide whether short slot time is used in the BSS.

> CONCLUSION: the AP doesn't like that. And the textual representation
> from tshark for this error as also confused about the roles of AP and
> station :-)

The "AP doesn't like that" part seems correct. The textual
representation may be confusing, but it is correct. The AP behavior is
not.

> Who's the culprit, mac80211 or wpa_supplicant?

Neither, the AP is. Have you verified whether you can work around this
by hardcoding mac80211 to send out zero as the short slot time?

-- 
Jouni Malinen                                            PGP id EFC895FA
