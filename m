Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33779 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbZGGTZ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 15:25:26 -0400
Subject: Re: ath5k and ap mode
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: tomek <paladyn11@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0907070719l2db5aec3rc20160eabd41fd0a@mail.gmail.com>
References: <1246959589.4686.1.camel@debian-tomek>
	 <b6c5339f0907070719l2db5aec3rc20160eabd41fd0a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 15:25:23 -0400
Message-Id: <1246994723.3393.14.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-07 at 10:19 -0400, Bob Copeland wrote:
> On Tue, Jul 7, 2009 at 5:39 AM, tomek<paladyn11@gmail.com> wrote:
> > Hi.
> >
> > When ap-mode will working in driver ath5k?
> 
> It will be enabled in 2.6.31... whether it works then or not is
> anyone's guess :)

I've just tested the mainline Linux git
(git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git)
and indeed, the AP support is there, so it will be in 2.6.31.

> (fyi, I'm currently waiting on some hw to arrive to do thorough
> testing of ath5k AP mode; some people say it works for them, but I'm
> still seeing some bugs here.)

My testing shows that ath5k is very unreliable in the AP mode, unlike
MadWifi.  Sometimes hostapd reports this:

wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: associated (aid 1)
wlan3: STA 00:17:c4:3b:fc:88 WPA: received EAPOL-Key 2/4 Pairwise with unexpected replay counter
wlan3: STA 00:17:c4:3b:fc:88 WPA: received EAPOL-Key 2/4 Pairwise with unexpected replay counter
wlan3: STA 00:17:c4:3b:fc:88 RADIUS: starting accounting session 4A538811-00000003
wlan3: STA 00:17:c4:3b:fc:88 WPA: pairwise key handshake completed (WPA)
wlan3: STA 00:17:c4:3b:fc:88 WPA: received EAPOL-Key 4/4 Pairwise with unexpected replay counter
wlan3: STA 00:17:c4:3b:fc:88 WPA: group key handshake completed (WPA)

At other times, it prints stuff like this:

wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: authenticated
wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: authenticated
wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: authenticated
wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: authenticated
wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: authenticated
wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: authenticated
wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: associated (aid 1)
wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: associated (aid 1)
wlan3: STA 00:17:c4:3b:fc:88 IEEE 802.11: deauthenticated due to local deauth request

wpa_supplicant on the client side reports strange messages too, for
instance:

Authentication with 00:00:00:00:00:00 timed out.

or

WPA: Countermeasures - dropped EAPOL request.

I'm using WPA-PSK (WPA1 only) to simplify the configuration.  My
impression is that we need a serious effort to weed out such problems.

Also, I'm running the current wireless-testing.git on the client side,
and it take some time for wpa_supplicant to start, as it reports:

ioctl[SIOCSIWSCAN]: Device or resource busy
Failed to initiate AP scan.

It looks like the station spends too much time in the busy state.  It
used to work better in the 2.6.30-rcX-wl days.

That's not meant to be a bugreport, more like a summary of all issues
I've seen.

-- 
Regards,
Pavel Roskin
