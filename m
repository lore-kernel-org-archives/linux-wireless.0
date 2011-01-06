Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62114 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab1AFQbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 11:31:23 -0500
Received: by iyi12 with SMTP id 12so15000567iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 08:31:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=-raYOK7p2e+3B2vRG2L+wJ6TApHj4LHd2NP53@mail.gmail.com>
References: <AANLkTim0AM3=T=TMu79ZQi79+CKANamBcz620n2xm8bW@mail.gmail.com>
	<201101041946.56978.helmut.schaa@googlemail.com>
	<AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
	<AANLkTi=KFG-7GPw2=6VTZqEceEcJM6OdWoTQaN_83NqP@mail.gmail.com>
	<AANLkTikREOFV+WGWgo9yh9bTrz346kF0muKE8gs5N+km@mail.gmail.com>
	<AANLkTikCcgEiqeJLDn0Pes_2=usj6ZXo7hhL48MBnH_-@mail.gmail.com>
	<AANLkTin0W1_Tjr1zj0D0U+VeBpoGFRmB9iCdOfnMB-nR@mail.gmail.com>
	<AANLkTimCsvR2zBfS+oCudhcUz68qPJhXM9-eu1L-FWHp@mail.gmail.com>
	<AANLkTimdEcj4k09ZyHQTXnbaeNj4CCrAm=mRTw+R5j6L@mail.gmail.com>
	<AANLkTimaWy33vYaM=bCPd0VooyR9QVw99YB1fSOj42Fo@mail.gmail.com>
	<AANLkTi=-raYOK7p2e+3B2vRG2L+wJ6TApHj4LHd2NP53@mail.gmail.com>
Date: Thu, 6 Jan 2011 08:31:22 -0800
Message-ID: <AANLkTin8JO4UHUYLufSmPhRw0ZndDdjTpueSOHNQbDiZ@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
From: Aleksandar Milivojevic <alex@milivojevic.org>
To: Wolfgang Kufner <wolfgang.kufner@gmail.com>
Cc: Luis Correia <buga@loide.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Playing with it a bit more this morning.  Looks like the connection
from wireless adapter to my AP drops periodically.  Sometimes it
recovers (sometimes after several attempts), sometimes it does not.
Seems to be very random:

# egrep 'authent|associat' /var/log/debug
Jan  6 08:00:54 toporko kernel: [   47.570810] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  6 08:00:54 toporko kernel: [   47.571321] wlan0: authenticated
Jan  6 08:00:56 toporko kernel: [   49.174175] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  6 08:00:56 toporko kernel: [   49.175536] wlan0: associated
Jan  6 08:06:01 toporko kernel: [  354.230874] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  6 08:06:01 toporko kernel: [  354.231364] wlan0: authenticated
Jan  6 08:06:01 toporko kernel: [  354.236066] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  6 08:06:01 toporko kernel: [  354.236865] wlan0: associated
Jan  6 08:09:36 toporko kernel: [  569.868923] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  6 08:09:36 toporko kernel: [  569.869416] wlan0: authenticated
Jan  6 08:09:36 toporko kernel: [  569.873736] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  6 08:09:36 toporko kernel: [  569.874507] wlan0: associated
Jan  6 08:09:46 toporko kernel: [  579.233563] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  6 08:09:46 toporko kernel: [  579.235574] wlan0: authenticated
Jan  6 08:09:46 toporko kernel: [  579.240737] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  6 08:09:46 toporko kernel: [  579.241518] wlan0: associated
Jan  6 08:09:57 toporko kernel: [  590.830933] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  6 08:09:57 toporko kernel: [  590.831435] wlan0: authenticated
Jan  6 08:09:57 toporko kernel: [  590.839102] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  6 08:09:57 toporko kernel: [  590.839881] wlan0: associated
Jan  6 08:21:29 toporko kernel: [ 1282.823289] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  6 08:21:29 toporko kernel: [ 1282.823783] wlan0: authenticated
Jan  6 08:21:29 toporko kernel: [ 1282.828990] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  6 08:21:29 toporko kernel: [ 1282.830132] wlan0: associated
Jan  6 08:25:30 toporko kernel: [ 1523.433931] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  6 08:25:30 toporko kernel: [ 1523.434930] wlan0: authenticated
Jan  6 08:25:30 toporko kernel: [ 1523.439868] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  6 08:25:30 toporko kernel: [ 1523.440652] wlan0: associated

So far, it managed to re-connect every time.  Though, I'm rather sure
if I leave it long enough, the last night's case of connection dropped
completely would repeat sooner or later (even last night, there were
some connect/disconnect events before connection was dropped
permanently).

The AP reports signal from wireless card between -70 and -75dB, noise
at -96dB, and speed at 120mbps (with occasional drop to 45mbps).
These numbers sound about OK for the location (on the other side of my
apartment, few walls in between).  For comparison, if I position my
MacBook at same location (right next to my Linux box), AP reports
signal from its AirPort card at about -60dB and speed in about 100mbps
range and no drops.
