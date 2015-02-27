Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34291 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbbB0TaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 14:30:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YRQbt-0001dh-I1
	for linux-wireless@vger.kernel.org; Fri, 27 Feb 2015 20:30:05 +0100
Received: from c-71-201-164-70.hsd1.il.comcast.net ([71.201.164.70])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2015 20:30:05 +0100
Received: from johnl by c-71-201-164-70.hsd1.il.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2015 20:30:05 +0100
To: linux-wireless@vger.kernel.org
From: John Lempkowski <johnl@memorylink.com>
Subject: Re: [PATCH] mac80211: Send EAPOL frames at lowest rate
Date: Fri, 27 Feb 2015 19:27:32 +0000 (UTC)
Message-ID: <loom.20150227T191942-361@post.gmane.org> (sfid-20150227_203013_613466_7562441F)
References: <1424958650-11165-1-git-send-email-jouni@qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <jouni@...> writes:

> In most cases, minstrel_ht is currently using the initial EAPOL-Key
> frames for probing higher rates and this results in only five link layer
> transmission attempts (one at high(ish) MCS and four at MCS0). While
> this works with most APs, it looks like there are some deployed APs that
> may have issues with the EAPOL frames using HT MCS immediately after
> association. Similarly, there may be issues in cases where the signal
> strength or radio environment is not good enough to be able to get
> frames through even at couple of MCS 0 tries.

This sounds similar to a problem I discovered while hacking on older
software. EAPOL frames were being dropped at a higher rate than were UDP
frames of any size, but only when there was other traffic. Eventually I
proved that most EAPOL frames in my test setup were actually received by
ath9k, but mac80211 did not always pass them up the stack. It turned out
that hostapd and/or wpa_supplicant were getting the EAPOL frames if and only
if they were not the 2nd or later subframe in an A-MPDU. If this has since
been discovered and fixed upstream, I apologize for the noise.

I spent a couple days trying to find a breakage mac80211's rx handlers which
were definitely getting the disappearing EAPOL packets. Eventually I gave up
and hacked the ath9k transmit routine so it breaks from the aggregation
logic and form a new A-MPDU whenever it encounters an EAPOL frame. This
worked around the auth+reauth issues that caused me to investigate.

The software exhibiting this behavior is a hacked OpenWrt checkout using the
following base versions:

Linux version 3.10.21
Compat-wireless 2013-04-16
Hostapd 2.1-devel
    PKG_VERSION:=20130807
    PKG_REV:=d2ba3d6bd9336ef8fd761a0cc7999824d4c4da41)

> It should also be noted that many drivers that do not use minstrel as
> the rate control algorithm are already doing similar workarounds by
> forcing the lowest TX rate to be used for EAPOL frames.

Perhaps this workaround avoids MPDU aggregation in all those drivers as well.

-John


