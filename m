Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58959 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2BEPpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 10:45:43 -0500
Received: by qcqw6 with SMTP id w6so2972367qcq.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Feb 2012 07:45:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAObL_7E2eW9aqz3VLsBU-=4+kMXrfPvfz6wCNUEdDHuJWVaSLA@mail.gmail.com>
References: <CAObL_7E2eW9aqz3VLsBU-=4+kMXrfPvfz6wCNUEdDHuJWVaSLA@mail.gmail.com>
Date: Sun, 5 Feb 2012 16:45:42 +0100
Message-ID: <CAFZTsKk9ojw9_XodisHf-dtHpL1n6xSRmmWDVniZ-Ps4-JLwvA@mail.gmail.com> (sfid-20120205_164611_779769_331C8C83)
Subject: Re: 6300agn: queue stuck and driver doesn't recover
From: Alexander Schnaidt <alex.schnaidt@googlemail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 4, 2012 at 11:42 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> I've recently started to notice wireless failures -- after being
> connected for a few minutes, the connection dies.  Other devices on
> the same network continue to work.  'iw dev wlan0 disconnect' will fix
> it.
>
> I'm not at all sure, but I think this is a 3.2 regression.  My kernel
>  is 3.2.2-1.fc16.x86_64.
Hi!

I am experiencing a similar regression on every kernel >=3.2.
Connected to a wpa protected AP, every application
loses it's connection after a period of time. If I let it be, it
eventually reconnects
and continues for a while until the cycle repeats itself.

03:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
        Subsystem: Intel Corporation Device 1011
        Flags: bus master, fast devsel, latency 0, IRQ 48
        Memory at f2500000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: <access denied>
        Kernel driver in use: iwlwifi

Networkmanager, netcfg or wicd do not report any problems. The logs
are clean and only ever mention the reconnection-event itself.

Now, running wpa_supplicant interactively spits out some info:

[alex@lx200s ~]$ sudo wpa_supplicant -D wext -i wlan0 -c wpstest.conf
Password:
Trying to associate with 00:1f:3f:13:47:1d (SSID='MyFancyAP' freq=2417 MHz)
Associated with 00:1f:3f:13:47:1d
WPA: Key negotiation completed with 00:1f:3f:13:47:1d [PTK=TKIP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:1f:3f:13:47:1d
completed (auth) [id=0 id_str=]
WPA: Group rekeying completed with 00:1f:3f:13:47:1d [GTK=TKIP]
WPA: Group rekeying completed with 00:1f:3f:13:47:1d [GTK=TKIP]
CTRL-EVENT-DISCONNECTED bssid=00:1f:3f:13:47:1d reason=0
Trying to associate with 00:1f:3f:13:47:1d (SSID='MyFancyAP' freq=2417 MHz)
Associated with 00:1f:3f:13:47:1d
WPA: Key negotiation completed with 00:1f:3f:13:47:1d [PTK=TKIP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:1f:3f:13:47:1d
completed (reauth) [id=0 id_str=]
^CCTRL-EVENT-TERMINATING - signal 2 received

The connection *always* stalls at the second group rekeying event.
When the third group rekeying happens wpa_supplicant(?) re-associates the
connection and the cycle repeats.

Here's the the dmesg output during the time frame:

[ 126.172145] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[ 126.172530] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0
[ 126.322917] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[ 126.323315] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0
[ 129.644682] wlan0: authenticate with 00:1f:3f:13:47:1d (try 1)
[ 129.647687] wlan0: authenticated
[ 129.649798] wlan0: associate with 00:1f:3f:13:47:1d (try 1)
[ 129.653886] wlan0: RX AssocResp from 00:1f:3f:13:47:1d
(capab=0x31 status=0 aid=2)
[ 129.653895] wlan0: associated
[ 1506.536175] wlan0: deauthenticated from 00:1f:3f:13:47:1d (Reason: 2)
[ 1506.600035] cfg80211: Calling CRDA to update world regulatory domain
[ 1509.857439] wlan0: authenticate with 00:1f:3f:13:47:1d (try 1)
[ 1509.860511] wlan0: authenticated
[ 1509.862438] wlan0: associate with 00:1f:3f:13:47:1d (try 1)
[ 1509.866443] wlan0: RX AssocResp from 00:1f:3f:13:47:1d
(capab=0x31 status=0 aid=2)
[ 1509.866451] wlan0: associated

At 1506.5 the re-association happens.

I can't influence the interval of the wpa rekeying of my wlan-router, so I'm
not sure if this is related.
The amount of network traffic doesn't seem to influence this behavior, either.

I tried to bisect it but ended up at:

commit 3c607d27c818cf4a5d28f2c73b18a88f8fbdfa33
Author: Don Fry <donald.h.fry@intel.com>
Date:   Fri Sep 30 11:40:20 2011 -0700

    iwlagn: rename iwlagn module iwlwifi and alias to iwlagn.

    Rename the iwlagn module as iwlwifi in preparation for future
    changes.  Add an alias to iwlagn for backward compatibility.

    Signed-off-by: Don Fry <donald.h.fry@intel.com>
    Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

That doesn't make a lot of sense to me but I wanted to mention it

I'll gladly provide more info.

alex
