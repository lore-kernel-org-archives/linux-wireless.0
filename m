Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaAMT6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 14:58:51 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: David Herrmann <dh.herrmann@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: iwlwifi: P2P group-formation timeout
Date: Mon, 13 Jan 2014 19:58:46 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A0333565A8@HASMSX106.ger.corp.intel.com> (sfid-20140113_205855_794333_D30B1C22)
References: <CANq1E4Rhja6XZPq9sXfycK_wWNB3nsjpQFr2XnzOXLHUnm__mw@mail.gmail.com>
 <CANq1E4STKqci55ZbGP9Siorf3ABptHHTAuOg_4-bbbEiw93w+A@mail.gmail.com>
In-Reply-To: <CANq1E4STKqci55ZbGP9Siorf3ABptHHTAuOg_4-bbbEiw93w+A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David, 

My guess is that the root cause of the failure is the fact that the GoN ended with the local side trying to instantiate a GO on freq=5180 which probably not supported by your SKU. To verify this can u please send me the output of 'iw phy0 info'? Also can you please send the full log of the wpa_supplicant?

One way to avoid this is to call  'wpa_cli set disallow_freq 5180-5800' before the GoN. Another way is to force the operating channel in the configuration file or in the p2p_connect command. You could also try to set a low go_intent so that the otherside would become a GO.
 
Thanks in advance,

Ilan.

> > I run wpa_supplicant as:
> >   wpa_supplicant -d -Dnl80211 -c wpa.conf -i wlan0 -p
> > p2p_device=1,use_p2p_group_interface=1
> >

You can probably remove the use_p2p_group_interface=1 (although I need to see iw phy0 info output to make sure).

> > My wpa.conf is:
> >   ctrl_interface=/run/wpa_supplicant
> >   ap_scan=1
> >   p2p_go_ht40=1
> >   device_name=david-ub
> >   device_type=1-0050F204-1
> >
> > In wpa_cli I run:
> >   p2p_find
> >   p2p_connect 12:68:3f:4e:39:f2 pbc
> >

To start with, can you please verify that setting up a standalone GO works? You can do that using: wpa_cli p2p_group_add.

> >
> > Lemme know if iwlwifi-debug options should be enabled and I can
> > provide a full debug log.
> > There are a bunch of errors in the wpa_supplicant log during startup,
> > but I think they're related to nl80211+P2P_DEVICE and expected?

No. Using the latest wpa_supplicant I do not see these warnings.  

> > These include:
> >   Could not read interface p2p-dev-wlan0 flags: No such device
> >   nl80211: Use separate P2P group interface (driver advertised support)
> >   nl80211: interface p2p-dev-wlan0 in phy phy0
> >   nl80211: Set mode ifindex 0 iftype 10 (P2P_DEVICE)
> >   nl80211: Failed to set interface 0 to mode 10: -22 (Invalid
> > argument)
> >
> > The GO-negotiation itself succeeds. However, the following
> > group-formation fails, the relevant part of the log is probably this:
> >
> > P2P-GO-NEG-SUCCESS role=GO freq=5180 ht40=0
> peer_dev=12:68:3f:4e:39:f2

Here you can see that there is an attempt to start the GO on 5180.

> >
> > Any hints are welcome. If there's any debug-option I should enable to
> > provide more logs, lemme know. I can also give iwlwifi-next a try if
> > there're any important patches pending. The p2p-dev-wlan0 related
> > errors are quite confusing, but I think they're caused by the fact

Need to see the full log, to try and get a better grasp of these warinings.

> > that there's no netdev for the device. At least I only have wlan0 and
> > p2p-wlan0-0 during runtime, a p2p-dev-wlan0 never shows up.
> >

P2p-dev-wlan0 should not show up. It is an internal interface in the wpa_supplicant that is not associated to a network interface (and it shouldn't). The proper way to trigger P2P device flows is to do so using the global control interface of the wpa_supplicant.

