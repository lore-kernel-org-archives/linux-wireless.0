Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab2BFCCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 21:02:37 -0500
Subject: Re: [Ilw] Re: 6300agn: queue stuck and driver doesn't recover
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Alexander Schnaidt <alex.schnaidt@googlemail.com>
Cc: Andrew Lutomirski <luto@mit.edu>, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAFZTsKmjsBufp+JVS+ZWJyM561RSCDwM=ZQ89G0W0brHuy2RSQ@mail.gmail.com>
References: <CAObL_7E2eW9aqz3VLsBU-=4+kMXrfPvfz6wCNUEdDHuJWVaSLA@mail.gmail.com>
	 <CAFZTsKk9ojw9_XodisHf-dtHpL1n6xSRmmWDVniZ-Ps4-JLwvA@mail.gmail.com>
	 <1328455870.7290.43.camel@wwguy-huron>
	 <CAFZTsKmjsBufp+JVS+ZWJyM561RSCDwM=ZQ89G0W0brHuy2RSQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Feb 2012 16:54:38 -0800
Message-ID: <1328489678.7290.47.camel@wwguy-huron> (sfid-20120206_030240_838479_62A774A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

how about use "swcrypto=1"

Wey


On Sun, 2012-02-05 at 19:27 +0100, Alexander Schnaidt wrote:
> On Sun, Feb 5, 2012 at 4:31 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> > Hi,
> >
> > On Sun, 2012-02-05 at 16:45 +0100, Alexander Schnaidt wrote:
> >> On Sat, Feb 4, 2012 at 11:42 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> >> >
> >> > I've recently started to notice wireless failures -- after being
> >> > connected for a few minutes, the connection dies.  Other devices on
> >> > the same network continue to work.  'iw dev wlan0 disconnect' will fix
> >> > it.
> >> >
> >> > I'm not at all sure, but I think this is a 3.2 regression.  My kernel
> >> >  is 3.2.2-1.fc16.x86_64.
> >> Hi!
> >>
> >> I am experiencing a similar regression on every kernel >=3.2.
> >> Connected to a wpa protected AP, every application
> >> loses it's connection after a period of time. If I let it be, it
> >> eventually reconnects
> >> and continues for a while until the cycle repeats itself.
> >>
> >> 03:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
> >>         Subsystem: Intel Corporation Device 1011
> >>         Flags: bus master, fast devsel, latency 0, IRQ 48
> >>         Memory at f2500000 (64-bit, non-prefetchable) [size=8K]
> >>         Capabilities: <access denied>
> >>         Kernel driver in use: iwlwifi
> >>
> >> Networkmanager, netcfg or wicd do not report any problems. The logs
> >> are clean and only ever mention the reconnection-event itself.
> >>
> >> Now, running wpa_supplicant interactively spits out some info:
> >>
> >> [alex@lx200s ~]$ sudo wpa_supplicant -D wext -i wlan0 -c wpstest.conf
> >> Password:
> >> Trying to associate with 00:1f:3f:13:47:1d (SSID='MyFancyAP' freq=2417 MHz)
> >> Associated with 00:1f:3f:13:47:1d
> >> WPA: Key negotiation completed with 00:1f:3f:13:47:1d [PTK=TKIP GTK=TKIP]
> >> CTRL-EVENT-CONNECTED - Connection to 00:1f:3f:13:47:1d
> >> completed (auth) [id=0 id_str=]
> >> WPA: Group rekeying completed with 00:1f:3f:13:47:1d [GTK=TKIP]
> >> WPA: Group rekeying completed with 00:1f:3f:13:47:1d [GTK=TKIP]
> >> CTRL-EVENT-DISCONNECTED bssid=00:1f:3f:13:47:1d reason=0
> >> Trying to associate with 00:1f:3f:13:47:1d (SSID='MyFancyAP' freq=2417 MHz)
> >> Associated with 00:1f:3f:13:47:1d
> >> WPA: Key negotiation completed with 00:1f:3f:13:47:1d [PTK=TKIP GTK=TKIP]
> >> CTRL-EVENT-CONNECTED - Connection to 00:1f:3f:13:47:1d
> >> completed (reauth) [id=0 id_str=]
> >> ^CCTRL-EVENT-TERMINATING - signal 2 received
> >>
> >> The connection *always* stalls at the second group rekeying event.
> >> When the third group rekeying happens wpa_supplicant(?) re-associates the
> >> connection and the cycle repeats.
> >>
> >> Here's the the dmesg output during the time frame:
> >>
> >> [ 126.172145] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> >> [ 126.172530] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0
> >> [ 126.322917] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> >> [ 126.323315] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0
> >> [ 129.644682] wlan0: authenticate with 00:1f:3f:13:47:1d (try 1)
> >> [ 129.647687] wlan0: authenticated
> >> [ 129.649798] wlan0: associate with 00:1f:3f:13:47:1d (try 1)
> >> [ 129.653886] wlan0: RX AssocResp from 00:1f:3f:13:47:1d
> >> (capab=0x31 status=0 aid=2)
> >> [ 129.653895] wlan0: associated
> >> [ 1506.536175] wlan0: deauthenticated from 00:1f:3f:13:47:1d (Reason: 2)
> >> [ 1506.600035] cfg80211: Calling CRDA to update world regulatory domain
> >> [ 1509.857439] wlan0: authenticate with 00:1f:3f:13:47:1d (try 1)
> >> [ 1509.860511] wlan0: authenticated
> >> [ 1509.862438] wlan0: associate with 00:1f:3f:13:47:1d (try 1)
> >> [ 1509.866443] wlan0: RX AssocResp from 00:1f:3f:13:47:1d
> >> (capab=0x31 status=0 aid=2)
> >> [ 1509.866451] wlan0: associated
> >>
> >> At 1506.5 the re-association happens.
> >>
> >> I can't influence the interval of the wpa rekeying of my wlan-router, so I'm
> >> not sure if this is related.
> >> The amount of network traffic doesn't seem to influence this behavior, either.
> >>
> >> I tried to bisect it but ended up at:
> >>
> >> commit 3c607d27c818cf4a5d28f2c73b18a88f8fbdfa33
> >> Author: Don Fry <donald.h.fry@intel.com>
> >> Date:   Fri Sep 30 11:40:20 2011 -0700
> >>
> >>     iwlagn: rename iwlagn module iwlwifi and alias to iwlagn.
> >>
> >>     Rename the iwlagn module as iwlwifi in preparation for future
> >>     changes.  Add an alias to iwlagn for backward compatibility.
> >>
> >>     Signed-off-by: Don Fry <donald.h.fry@intel.com>
> >>     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> >>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >>
> >> That doesn't make a lot of sense to me but I wanted to mention it
> >>
> >> I'll gladly provide more info.
> >
> > I agree that does not make much sense, but we will take a look into it.
> > btw, could you try the attach patch and see if it help?
> >
> > thanks
> > Wey
> >>
> >> _______________________________________________
> >> ilw mailing list
> >> ilw@linux.intel.com
> >> http://linux.intel.com/mailman/listinfo/ilw
> >
> 
> Applied the patch against 3.2-rc2.
> Observing the same behavior; dmesg gained some extended output.
> Here is a complete cycle from loading the module to re-association.
> 
> [  368.927325] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [  368.927707] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0
> [  369.074907] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [  369.075332] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0
> [  369.119379] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  372.475697] wlan0: authenticate with 00:1f:3f:13:47:1d (try 1)
> [  372.478739] wlan0: authenticated
> [  372.480701] wlan0: associate with 00:1f:3f:13:47:1d (try 1)
> [  372.484821] wlan0: RX AssocResp from 00:1f:3f:13:47:1d
> (capab=0x31 status=0 aid=2)
> [  372.484830] wlan0: associated
> [  372.484838] wlan0: moving STA 00:1f:3f:13:47:1d to state 1
> [  372.484843] wlan0: moving STA 00:1f:3f:13:47:1d to state 2
> [  372.484849] wlan0: moving STA 00:1f:3f:13:47:1d to state 3
> [  372.494324] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  382.786111] wlan0: no IPv6 routers present
> [ 1644.937825] wlan0: deauthenticated from 00:1f:3f:13:47:1d (Reason: 2)
> [ 1644.948276] wlan0: moving STA 00:1f:3f:13:47:1d to state 2
> [ 1644.948284] wlan0: moving STA 00:1f:3f:13:47:1d to state 1
> [ 1644.948289] wlan0: moving STA 00:1f:3f:13:47:1d to state 0
> [ 1644.963173] cfg80211: Calling CRDA to update world regulatory domain
> [ 1648.242734] wlan0: authenticate with 00:1f:3f:13:47:1d (try 1)
> [ 1648.245786] wlan0: authenticated
> [ 1648.247750] wlan0: associate with 00:1f:3f:13:47:1d (try 1)
> [ 1648.251843] wlan0: RX AssocResp from 00:1f:3f:13:47:1d (capab=0x31
> status=0 aid=2)
> [ 1648.251852] wlan0: associated
> [ 1648.251859] wlan0: moving STA 00:1f:3f:13:47:1d to state 1
> [ 1648.251865] wlan0: moving STA 00:1f:3f:13:47:1d to state 2
> [ 1648.251871] wlan0: moving STA 00:1f:3f:13:47:1d to state 3
> 
> Thanks
> 
> alex


