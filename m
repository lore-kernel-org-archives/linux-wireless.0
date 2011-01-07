Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59555 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab1AGKMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 05:12:30 -0500
Received: by fxm20 with SMTP id 20so16794050fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 02:12:29 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
Date: Fri, 7 Jan 2011 11:11:17 +0100
Cc: Aleksandar Milivojevic <alex@milivojevic.org>,
	Wolfgang Kufner <wolfgang.kufner@gmail.com>,
	Luis Correia <buga@loide.net>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com> <AANLkTin8JO4UHUYLufSmPhRw0ZndDdjTpueSOHNQbDiZ@mail.gmail.com> <20110107024432.GC20431@tux>
In-Reply-To: <20110107024432.GC20431@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101071111.17423.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 7. Januar 2011 schrieb Luis R. Rodriguez:
> On Thu, Jan 06, 2011 at 08:31:22AM -0800, Aleksandar Milivojevic wrote:
> > Playing with it a bit more this morning.  Looks like the connection
> > from wireless adapter to my AP drops periodically.  Sometimes it
> > recovers (sometimes after several attempts), sometimes it does not.
> > Seems to be very random:
> > 
> > # egrep 'authent|associat' /var/log/debug
> > Jan  6 08:00:54 toporko kernel: [   47.570810] wlan0: authenticate
> > with 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:00:54 toporko kernel: [   47.571321] wlan0: authenticated
> > Jan  6 08:00:56 toporko kernel: [   49.174175] wlan0: associate with
> > 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:00:56 toporko kernel: [   49.175536] wlan0: associated
> > Jan  6 08:06:01 toporko kernel: [  354.230874] wlan0: authenticate
> > with 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:06:01 toporko kernel: [  354.231364] wlan0: authenticated
> > Jan  6 08:06:01 toporko kernel: [  354.236066] wlan0: associate with
> > 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:06:01 toporko kernel: [  354.236865] wlan0: associated
> > Jan  6 08:09:36 toporko kernel: [  569.868923] wlan0: authenticate
> > with 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:09:36 toporko kernel: [  569.869416] wlan0: authenticated
> > Jan  6 08:09:36 toporko kernel: [  569.873736] wlan0: associate with
> > 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:09:36 toporko kernel: [  569.874507] wlan0: associated
> > Jan  6 08:09:46 toporko kernel: [  579.233563] wlan0: authenticate
> > with 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:09:46 toporko kernel: [  579.235574] wlan0: authenticated
> > Jan  6 08:09:46 toporko kernel: [  579.240737] wlan0: associate with
> > 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:09:46 toporko kernel: [  579.241518] wlan0: associated
> > Jan  6 08:09:57 toporko kernel: [  590.830933] wlan0: authenticate
> > with 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:09:57 toporko kernel: [  590.831435] wlan0: authenticated
> > Jan  6 08:09:57 toporko kernel: [  590.839102] wlan0: associate with
> > 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:09:57 toporko kernel: [  590.839881] wlan0: associated
> > Jan  6 08:21:29 toporko kernel: [ 1282.823289] wlan0: authenticate
> > with 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:21:29 toporko kernel: [ 1282.823783] wlan0: authenticated
> > Jan  6 08:21:29 toporko kernel: [ 1282.828990] wlan0: associate with
> > 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:21:29 toporko kernel: [ 1282.830132] wlan0: associated
> > Jan  6 08:25:30 toporko kernel: [ 1523.433931] wlan0: authenticate
> > with 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:25:30 toporko kernel: [ 1523.434930] wlan0: authenticated
> > Jan  6 08:25:30 toporko kernel: [ 1523.439868] wlan0: associate with
> > 00:1e:52:79:e9:ff (try 1)
> > Jan  6 08:25:30 toporko kernel: [ 1523.440652] wlan0: associated
> > 
> > So far, it managed to re-connect every time.  Though, I'm rather sure
> > if I leave it long enough, the last night's case of connection dropped
> > completely would repeat sooner or later (even last night, there were
> > some connect/disconnect events before connection was dropped
> > permanently).
> > 
> > The AP reports signal from wireless card between -70 and -75dB, noise
> > at -96dB, and speed at 120mbps (with occasional drop to 45mbps).
> > These numbers sound about OK for the location (on the other side of my
> > apartment, few walls in between).  For comparison, if I position my
> > MacBook at same location (right next to my Linux box), AP reports
> > signal from its AirPort card at about -60dB and speed in about 100mbps
> > range and no drops.
> 
> The Linux regulatory code only relies on the Country IE from the AP you
> decide to associate to, that's it. Then, as for all the regulatory stuff
> popping out once you are associated, its happening because as I see it
> you are being disconnected from the AP. The Linux regulatory code will
> reset the regulatory settings after you disconnect from an AP.
> 
> The disconnect issues should not be regularory related from what I see.
> Seems like a general disconnect issue with your driver.

Sounds reasonable. Thanks for the update Luis. So, it's more likely a
rt2x00 or mac80211 issue.

Helmut
