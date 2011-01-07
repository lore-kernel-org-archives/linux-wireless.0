Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:10046 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1AGUW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 15:22:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 12:22:09 -0800
Date: Fri, 7 Jan 2011 12:22:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Aleksandar Milivojevic <alex@milivojevic.org>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Wolfgang Kufner <wolfgang.kufner@gmail.com>,
	Luis Correia <buga@loide.net>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
Message-ID: <20110107202224.GI21588@tux>
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
 <AANLkTin8JO4UHUYLufSmPhRw0ZndDdjTpueSOHNQbDiZ@mail.gmail.com>
 <20110107024432.GC20431@tux>
 <201101071111.17423.helmut.schaa@googlemail.com>
 <AANLkTi=cxggOG6xkVQqJ9S+ieg8LD43TSVEYAJW7YFrk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTi=cxggOG6xkVQqJ9S+ieg8LD43TSVEYAJW7YFrk@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 07, 2011 at 11:46:48AM -0800, Aleksandar Milivojevic wrote:
> On Fri, Jan 7, 2011 at 2:11 AM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
> > Am Freitag, 7. Januar 2011 schrieb Luis R. Rodriguez:
> >> On Thu, Jan 06, 2011 at 08:31:22AM -0800, Aleksandar Milivojevic wrote:
> >> > Playing with it a bit more this morning.  Looks like the connection
> >> > from wireless adapter to my AP drops periodically.  Sometimes it
> >> > recovers (sometimes after several attempts), sometimes it does not.
> >> > Seems to be very random:
> >> >
> >> > # egrep 'authent|associat' /var/log/debug
> >> > Jan  6 08:00:54 toporko kernel: [   47.570810] wlan0: authenticate
> >> > with 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:00:54 toporko kernel: [   47.571321] wlan0: authenticated
> >> > Jan  6 08:00:56 toporko kernel: [   49.174175] wlan0: associate with
> >> > 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:00:56 toporko kernel: [   49.175536] wlan0: associated
> >> > Jan  6 08:06:01 toporko kernel: [  354.230874] wlan0: authenticate
> >> > with 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:06:01 toporko kernel: [  354.231364] wlan0: authenticated
> >> > Jan  6 08:06:01 toporko kernel: [  354.236066] wlan0: associate with
> >> > 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:06:01 toporko kernel: [  354.236865] wlan0: associated
> >> > Jan  6 08:09:36 toporko kernel: [  569.868923] wlan0: authenticate
> >> > with 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:09:36 toporko kernel: [  569.869416] wlan0: authenticated
> >> > Jan  6 08:09:36 toporko kernel: [  569.873736] wlan0: associate with
> >> > 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:09:36 toporko kernel: [  569.874507] wlan0: associated
> >> > Jan  6 08:09:46 toporko kernel: [  579.233563] wlan0: authenticate
> >> > with 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:09:46 toporko kernel: [  579.235574] wlan0: authenticated
> >> > Jan  6 08:09:46 toporko kernel: [  579.240737] wlan0: associate with
> >> > 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:09:46 toporko kernel: [  579.241518] wlan0: associated
> >> > Jan  6 08:09:57 toporko kernel: [  590.830933] wlan0: authenticate
> >> > with 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:09:57 toporko kernel: [  590.831435] wlan0: authenticated
> >> > Jan  6 08:09:57 toporko kernel: [  590.839102] wlan0: associate with
> >> > 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:09:57 toporko kernel: [  590.839881] wlan0: associated
> >> > Jan  6 08:21:29 toporko kernel: [ 1282.823289] wlan0: authenticate
> >> > with 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:21:29 toporko kernel: [ 1282.823783] wlan0: authenticated
> >> > Jan  6 08:21:29 toporko kernel: [ 1282.828990] wlan0: associate with
> >> > 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:21:29 toporko kernel: [ 1282.830132] wlan0: associated
> >> > Jan  6 08:25:30 toporko kernel: [ 1523.433931] wlan0: authenticate
> >> > with 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:25:30 toporko kernel: [ 1523.434930] wlan0: authenticated
> >> > Jan  6 08:25:30 toporko kernel: [ 1523.439868] wlan0: associate with
> >> > 00:1e:52:79:e9:ff (try 1)
> >> > Jan  6 08:25:30 toporko kernel: [ 1523.440652] wlan0: associated
> >> >
> >> > So far, it managed to re-connect every time.  Though, I'm rather sure
> >> > if I leave it long enough, the last night's case of connection dropped
> >> > completely would repeat sooner or later (even last night, there were
> >> > some connect/disconnect events before connection was dropped
> >> > permanently).
> >> >
> >> > The AP reports signal from wireless card between -70 and -75dB, noise
> >> > at -96dB, and speed at 120mbps (with occasional drop to 45mbps).
> >> > These numbers sound about OK for the location (on the other side of my
> >> > apartment, few walls in between).  For comparison, if I position my
> >> > MacBook at same location (right next to my Linux box), AP reports
> >> > signal from its AirPort card at about -60dB and speed in about 100mbps
> >> > range and no drops.
> >>
> >> The Linux regulatory code only relies on the Country IE from the AP you
> >> decide to associate to, that's it. Then, as for all the regulatory stuff
> >> popping out once you are associated, its happening because as I see it
> >> you are being disconnected from the AP. The Linux regulatory code will
> >> reset the regulatory settings after you disconnect from an AP.
> >>
> >> The disconnect issues should not be regularory related from what I see.
> >> Seems like a general disconnect issue with your driver.
> >
> > Sounds reasonable. Thanks for the update Luis. So, it's more likely a
> > rt2x00 or mac80211 issue.
> 
> I'd put my vote there too, probably hitting some corner case or
> something specific to either WUSB600N or Airport Extreme or
> combination of the two.  I'd be glad to help debug the issue, and if
> you need any info just give me a shout what to do, what to try out,
> and/or what to look for.
> 
> There was huge improvement in rt2x00 regarding support for Linksys
> WUSB600N over the last half a year or so.  Until several months ago,
> using rt2x00 driver, I wasn't able to connect to my AP at all (I would
> see the list of networks, but would not be able to connect to any of
> them).  The version from 2.6.35 kernel would connect for short period
> of time, but speed was abysmal (in order of few kB/sec), and
> connection would be completely dropped within minutes.  With the
> latest version of driver (compiled from comapt-wireless tarball), I'm
> getting good transfer speeds, and connection to my AP is mostly up
> (there's some flapping every few minutes, as you can see from logs).
> In the last two days, there was only one occurrence where connection
> to my AP was dropped and driver failed to re-connect.

You may want to try checing the 'iw event -t' output while the issue happens.
Maybe it is due to a roaming issue, if you are using a large BSS and roam
in between you may want to try using wpa_supplicant with nl80211 and use
the new bgscan module from wpa_supplicant to trigger you to only switch
based on triggered events from nl80211 like signal rssi changes.

Here is an example supplicant conf that uses the bgscan module:

# WPA-PSK/TKIP

ctrl_interface=/var/run/wpa_supplicant

network={
        ssid="my-corp-cool-bss"
        bgscan="simple:30:-45:300"
        key_mgmt=WPA-PSK
        proto=RSN
        pairwise=CCMP
        group=CCMP
        psk="foobar_is_great"
}

No Linux distributions today uses this other than ChromeOS, but they should
all change to use it.

  Luis
