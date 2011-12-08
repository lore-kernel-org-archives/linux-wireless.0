Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:35470 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1LHPlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 10:41:25 -0500
Received: by qadb15 with SMTP id b15so1825398qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 07:41:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFLBHBxy8sOBL-uc6J2veJk3HEHayxX=e8fbRmOyixHq1REfaA@mail.gmail.com>
References: <CAFLBHBxy8sOBL-uc6J2veJk3HEHayxX=e8fbRmOyixHq1REfaA@mail.gmail.com>
Date: Thu, 8 Dec 2011 16:41:24 +0100
Message-ID: <CAFLBHBzCwV8bgpotoMD_ur2P9A-smvCPc0gLuAdpwZcMwYC=yA@mail.gmail.com> (sfid-20111208_164129_179987_6C8C2776)
Subject: Re: Beacon set failed
From: Christopher Blum <christopher@protonet.info>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok. After a couple hours of trial & error I found that commenting out
the following configuration option in the hostapd build config fixes
the problem:
CONFIG_IEEE80211R=y

I don't know how this option is related to the problem.
Maybe there is a hostapd guy on this list who has an explanation for this.

Thanks.


On Wed, Dec 7, 2011 at 12:31 PM, Christopher Blum
<christopher@protonet.info> wrote:
> Hello,
>
> I'm new to this list and I hope this is the correct place to ask for help.
>
> I'm setting up a wifi hotspot on a Ubuntu 10.04 LTS 3.
> It's running on a E35M1-I Deluxe Motherboard with an Atheros AR9285
> chip on board (PCI Express).
> I installed the latest stable Hostapd and compat-wirless.
>
> When I run hostapd I'm getting the following output:
> nl80211: Register Action command failed: ret=-114 (Operation already
> in progress)
> nl80211: Register Action match - hexdump(len=1): 06
> nl80211: Failed to register Action frame processing - ignore for now
> nl80211: Add own interface ifindex 3
> nl80211: New interface mon.wlan0 created: ifindex=11
> nl80211: Add own interface ifindex 11
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Added 802.11b mode based on 802.11g information
> RATE[0] rate=10 flags=0x1
> RATE[1] rate=20 flags=0x1
> RATE[2] rate=55 flags=0x1
> RATE[3] rate=110 flags=0x1
> RATE[4] rate=60 flags=0x0
> RATE[5] rate=90 flags=0x0
> RATE[6] rate=120 flags=0x0
> RATE[7] rate=180 flags=0x0
> RATE[8] rate=240 flags=0x0
> RATE[9] rate=360 flags=0x0
> RATE[10] rate=480 flags=0x0
> RATE[11] rate=540 flags=0x0
> Scan for neighboring BSSes prior to enabling 40 MHz channel
> Scan requested (ret=0) - scan timeout 10 seconds
> Interface initialization will be completed in a callback
> nl80211: Event message available
> nl80211: Scan trigger
> RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
> RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
> RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5
> nl80211: Event message available
> nl80211: New scan results available
> Received scan results (20 BSSes)
> 40 MHz affected channel range: [2402,2452] MHz
> Neighboring BSS: 00:1e:58:c7:16:5f freq=2417 pri=0 sec=0
> Neighboring BSS: b8:c7:5d:02:bd:63 freq=2417 pri=2 sec=0
> Neighboring BSS: 00:15:6d:ea:f4:4b freq=2412 pri=0 sec=0
> Neighboring BSS: 00:50:7f:e0:f6:50 freq=2432 pri=5 sec=9
> 40 MHz pri/sec mismatch with BSS 00:50:7f:e0:f6:50 <2432,2452>
> (chan=5+) vs. <2437,2417>
> 20/40 MHz operation not permitted on channel pri=6 sec=2 based on
> overlapping BSSes
> Completing interface initialization
> Mode: IEEE 802.11g  Channel: 6  Frequency: 2437 MHz
> Flushing old station entries
> Deauthenticate all stations
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=0
> set_tx=1 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=1
> set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=2
> set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=3
> set_tx=0 seq_len=0 key_len=0
> Using interface wlan0 with hwaddr 74:2f:68:4a:d9:aa and ssid 'protonet-private'
> WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
> GMK - hexdump(len=32): [REMOVED]
> GTK - hexdump(len=16): [REMOVED]
> WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
> wpa_driver_nl80211_set_key: ifindex=3 alg=3 addr=(nil) key_idx=1
> set_tx=1 seq_len=0 key_len=16
> Using existing control interface directory.
> ctrl_iface bind(PF_UNIX) failed: Address already in use
> ctrl_iface exists, but does not allow connections - assuming it was
> leftover from forced program termination
> Successfully replaced leftover ctrl_iface socket '/var/run/hostapd/wlan0'
> nl80211: Set beacon (beacon_set=0)
> nl80211: Beacon set failed: -22 (Invalid argument)
> Failed to set beacon head/tail or DTIM period
> wlan0: Setup of interface done.
> RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5
>
>
> The AP is then turned on but not in WPA2 mode (as defined in the
> hostapd config file).
> Note the "nl80211: Beacon set failed: -22 (Invalid argument)" line
> which looks very suspicious to me.
>
>
> My hostapd config looks like this:
> ctrl_interface=/var/run/hostapd
> driver=nl80211
> hw_mode=g
> wme_enabled=1
> ieee80211n=1
> ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]
> channel=6
> ssid=protonet-private
> interface=wlan0
> macaddr_acl=0
> auth_algs=1
> ignore_broadcast_ssid=0
> wpa=2
> wpa_psk=890fcbac9aa7a2a1e9361a957d614a3a525d2f432cb5e639f5a4a5b1f3577559
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP
> rsn_pairwise=CCMP
>
>
> A few more infos:
> * It works when I change the config from wpa=2 to wpa=1
> * I tried an external usb wifi card (AR9271) and still getting the
> exact same "Beacon set failed" error
> * If I plug the same external usb wifi card into a different board
> (Intel D525 MW) it works (with the same exact setup, ubuntu clean
> install)
>
> Thanks in advance.



-- 
Christopher Blum
christopher@protonet.info
+491744771457

protonet @betahaus
Lerchenstrasse 28a
22767 Hamburg
Germany

follow us on twitter: http://twitter.com/protonet or check out our
blog at http://blog.protonet.info!
