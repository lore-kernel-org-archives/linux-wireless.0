Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab1LBTjb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 14:39:31 -0500
Message-ID: <1322854811.1883.29.camel@dcbw.foobar.com> (sfid-20111202_203936_401195_D7DE54D3)
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
From: Dan Williams <dcbw@redhat.com>
To: AndrewL733 <AndrewL733@aol.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Date: Fri, 02 Dec 2011 13:40:11 -0600
In-Reply-To: <4ED921B8.6060107@aol.com>
References: <4ED3A6E8.4050000@aol.com>
	 <CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com>
	 <CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com>
	 <4ED3B33E.8020309@lwfinger.net> <4ED3FA65.7010104@aol.com>
	 <CACna6rw1gEjd_hcX=5hLHt0YwUqDaVBs7_MO50GLKeok57YtVw@mail.gmail.com>
	 <4ED51DB5.5090202@aol.com> <4ED52FBD.5030302@lwfinger.net>
	 <4ED5535E.50605@aol.com> <4ED56E02.6040601@lwfinger.net>
	 <CACna6rxEW9Bc6vZRPR=t=zfnA3RJoWO4Rd6m7SuY2+6_uoxuLg@mail.gmail.com>
	 <4ED9152F.5060104@aol.com> <4ED921B8.6060107@aol.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-02 at 14:06 -0500, AndrewL733 wrote:
> Hi
> >
> > After unininstalling Network Manager, I can now get a reliable 
> > connection to my office network by running
> >
> > "iwconfig wlan0 essid mynetworkname", then
> > "wpa_supplicant -Dwext -i wlan0 -c /etc/wpa_supplicant.conf" (to not 
> > run in the background)
> > "dhclient wlan0"
> >
> > Now the connection is stable.  The question is, why is it unstable 
> > with Network Manager?  Any ideas?  Is it related to the way Network 
> > Manager is working with the 4331 chipset?  I have an identical 
> > Mandriva 2011 OS installed on a slightly older Macbook Pro 5,1 with 
> > the Broadcom 4322 chipset, also using the b43 driver, and Network 
> > Manager does not cause these disconnections. Is there another forum 
> > where it would be better to post this question?
> >
> The problem is definitely with Network Manager.  Re-installing Network 
> Manager causes the same disconnection problem again, even when running 
> wpa_supplicant manually.  Who should I report this to?

See my other mail on this... it's not really NM, but I believe it's a
bug in the driver exposed by some behavior that NM has that static
wpa_supplicant does not.  You should be able to trigger the same
behavior by periodically executing 'iwlist wlan0 scan' on the command
line, or by asking wpa_supplicant to scan by using wpa_cli.

Grabbing more debugging info using "-dddt" as arguments to the
supplicant would help.

Also, are you sure your manually started copy of wpa_supplicant is the
only copy that's running?

> wpa on the command line:
> 
> [root@andynewmac andy]# wpa_supplicant -Dwext -i wlan0 -c 
> /etc/wpa_supplicant.conf
> CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=0
> ioctl[SIOCSIWSCAN]: Device or resource busy
> Failed to initiate AP scan.
> ioctl[SIOCSIWSCAN]: Device or resource busy
> Failed to initiate AP scan.

These aren't necessarily a good start, though sometimes they are
expected.

> Trying to associate with 48:5b:39:5b:67:27 (SSID='es-network2' freq=2412 
> MHz)
> Associated with 48:5b:39:5b:67:27
> WPA: Key negotiation completed with 48:5b:39:5b:67:27 [PTK=CCMP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 48:5b:39:5b:67:27 completed (auth) 
> [id=1 id_str=]
> CTRL-EVENT-DISCONNECTED bssid=48:5b:39:5b:67:27 reason=0
> ioctl[SIOCSIWSCAN]: Device or resource busy
> Failed to initiate AP scan.
> ioctl[SIOCSIWSCAN]: Device or resource busy
> Failed to initiate AP scan.

There's not enough debugging output from the supplicant to figure out
why the disconnect event occurred though.  That's the real reason there
are problems here.  WEXT doesn't give us enough information about why
the disconnect occurred.  Instead of using "-Dwext", can you use
"-Dnl80211" instead?  WEXT is an old API and is replaced by nl80211,
which gives us much more usable information.

Dan

> Trying to associate with 48:5b:39:5b:67:27 (SSID='es-network2' freq=2412 
> MHz)
> Associated with 48:5b:39:5b:67:27
> WPA: Key negotiation completed with 48:5b:39:5b:67:27 [PTK=CCMP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 48:5b:39:5b:67:27 completed 
> (reauth) [id=1 id_str=]
> CTRL-EVENT-DISCONNECTED bssid=48:5b:39:5b:67:27 reason=0
> ioctl[SIOCSIWSCAN]: Device or resource busy
> Failed to initiate AP scan.
> ioctl[SIOCSIWSCAN]: Device or resource busy
> Failed to initiate AP scan.
> Trying to associate with 48:5b:39:5b:67:27 (SSID='es-network2' freq=2412 
> MHz)
> Associated with 48:5b:39:5b:67:27
> WPA: Invalid EAPOL-Key MIC when using TPTK - ignoring TPTK
> WPA: Could not verify EAPOL-Key MIC - dropping packet
> Authentication with 48:5b:39:5b:67:27 timed out.
> CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=0
> Trying to associate with 48:5b:39:5b:67:27 (SSID='es-network2' freq=2412 
> MHz)
> Associated with 48:5b:39:5b:67:27
> WPA: Key negotiation completed with 48:5b:39:5b:67:27 [PTK=CCMP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 48:5b:39:5b:67:27 completed 
> (reauth) [id=1 id_str=]
> 
> In /var/log/messages:
> 
> Dec  2 18:47:06 andynewmac kernel: [  211.957785] cfg80211: Calling CRDA 
> to update world regulatory domain
> Dec  2 18:47:06 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  completed -> disconnected
> Dec  2 18:47:06 andynewmac kernel: [  211.961641] cfg80211: World 
> regulatory domain updated:
> Dec  2 18:47:06 andynewmac kernel: [  211.961643] cfg80211:     
> (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> Dec  2 18:47:06 andynewmac kernel: [  211.961646] cfg80211:     (2402000 
> KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:06 andynewmac kernel: [  211.961648] cfg80211:     (2457000 
> KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:06 andynewmac kernel: [  211.961650] cfg80211:     (2474000 
> KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:06 andynewmac kernel: [  211.961651] cfg80211:     (5170000 
> KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:06 andynewmac kernel: [  211.961653] cfg80211:     (5735000 
> KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:06 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:06 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:07 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:07 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:07 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> associating
> Dec  2 18:47:07 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  associating -> associated
> Dec  2 18:47:07 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  associated -> 4-way handshake
> Dec  2 18:47:08 andynewmac kernel: [  213.594392] cfg80211: Calling CRDA 
> to update world regulatory domain
> Dec  2 18:47:08 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  4-way handshake -> disconnected
> Dec  2 18:47:08 andynewmac kernel: [  213.598387] cfg80211: World 
> regulatory domain updated:
> Dec  2 18:47:08 andynewmac kernel: [  213.598390] cfg80211:     
> (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> Dec  2 18:47:08 andynewmac kernel: [  213.598392] cfg80211:     (2402000 
> KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:08 andynewmac kernel: [  213.598394] cfg80211:     (2457000 
> KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:08 andynewmac kernel: [  213.598396] cfg80211:     (2474000 
> KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:08 andynewmac kernel: [  213.598398] cfg80211:     (5170000 
> KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:08 andynewmac kernel: [  213.598400] cfg80211:     (5735000 
> KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Dec  2 18:47:08 andynewmac avahi-daemon[2391]: Interface wlan0.IPv4 no 
> longer relevant for mDNS.
> Dec  2 18:47:08 andynewmac avahi-daemon[2391]: Leaving mDNS multicast 
> group on interface wlan0.IPv4 with address 10.42.66.138.
> Dec  2 18:47:08 andynewmac dhclient: receive_packet failed on wlan0: 
> Network is down
> Dec  2 18:47:08 andynewmac avahi-daemon[2391]: Withdrawing address 
> record for 10.42.66.138 on wlan0.
> Dec  2 18:47:08 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:08 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:09 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:09 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:10 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:10 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:11 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:11 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:12 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:12 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:12 andynewmac NetworkManager[2513]: <info> (wlan0): roamed 
> from BSSID 48:5B:39:5B:67:27 (es-network2) to (none) ((none))
> Dec  2 18:47:13 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:13 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:14 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:14 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:14 andynewmac drakconf.real[9067]: ### Program is starting ###
> Dec  2 18:47:15 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:15 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:16 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:16 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:17 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:17 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:18 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:18 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:18 andynewmac drakconf.real[9354]: ### Program is starting ###
> Dec  2 18:47:19 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:19 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:20 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:20 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:21 andynewmac rpmdrake[9366]: ### Program is starting ###
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> disconnected
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> (wlan0): device 
> state change: 8 -> 3 (reason 11)
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> (wlan0): 
> deactivating device (reason: 11).
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> (wlan0): 
> canceled DHCP transaction, DHCP client pid 8334
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> (wlan0): 
> removing resolv.conf from /sbin/resolvconf
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) starting connection 'System es-network2'
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> (wlan0): device 
> state change: 3 -> 4 (reason 0)
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 1 of 5 (Device Prepare) scheduled...
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 1 of 5 (Device Prepare) started...
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 2 of 5 (Device Configure) scheduled...
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 1 of 5 (Device Prepare) complete.
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 2 of 5 (Device Configure) starting...
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> (wlan0): device 
> state change: 4 -> 5 (reason 0)
> Dec  2 18:47:21 andynewmac NetworkManager[2513]: <info> (wlan0): 
> bringing up device.
> Dec  2 18:47:22 andynewmac kernel: [  227.305220] b43-phy0: Loading 
> firmware version 666.2 (2011-02-23 01:15:07)
> Dec  2 18:47:22 andynewmac kernel: [  227.345070] ADDRCONF(NETDEV_UP): 
> wlan0: link is not ready
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0/wireless): access point 'System es-network2' has security, but 
> secrets are required.
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> (wlan0): device 
> state change: 5 -> 6 (reason 0)
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 2 of 5 (Device Configure) complete.
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 1 of 5 (Device Prepare) scheduled...
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 1 of 5 (Device Prepare) started...
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> (wlan0): device 
> state change: 6 -> 4 (reason 0)
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 2 of 5 (Device Configure) scheduled...
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 1 of 5 (Device Prepare) complete.
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 2 of 5 (Device Configure) starting...
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> (wlan0): device 
> state change: 4 -> 5 (reason 0)
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0/wireless): connection 'System es-network2' has security, and 
> secrets exist.  No new secrets needed.
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Config: added 
> 'ssid' value 'es-network2'
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Config: added 
> 'scan_ssid' value '1'
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Config: added 
> 'key_mgmt' value 'WPA-PSK'
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Config: added 
> 'psk' value '<omitted>'
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Config: added 
> 'proto' value 'WPA RSN'
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 2 of 5 (Device Configure) complete.
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> Config: set 
> interface ap_scan to 1
> Dec  2 18:47:22 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  disconnected -> scanning
> Dec  2 18:47:22 andynewmac rpmdrake[9366]: opening the RPM database
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  scanning -> associating
> Dec  2 18:47:23 andynewmac kernel: [  228.848305] 
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  associating -> associated
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  associated -> 4-way handshake
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  4-way handshake -> group handshake
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> (wlan0): 
> supplicant connection state:  group handshake -> completed
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0/wireless) Stage 2 of 5 (Device Configure) successful.  Connected 
> to wireless network 'es-network2'.
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 3 of 5 (IP Configure Start) started...
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> (wlan0): device 
> state change: 5 -> 7 (reason 0)
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> dhclient started 
> with pid 9446
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 3 of 5 (IP Configure Start) complete.
> Dec  2 18:47:23 andynewmac dhclient: Internet Systems Consortium DHCP 
> Client 4.2.1-P1
> Dec  2 18:47:23 andynewmac dhclient: Copyright 2004-2011 Internet 
> Systems Consortium.
> Dec  2 18:47:23 andynewmac dhclient: All rights reserved.
> Dec  2 18:47:23 andynewmac dhclient: For info, please visit 
> https://www.isc.org/software/dhcp/
> Dec  2 18:47:23 andynewmac dhclient:
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> (wlan0): DHCPv4 
> state changed nbi -> preinit
> Dec  2 18:47:23 andynewmac dhclient: Listening on 
> LPF/wlan0/68:a8:6d:24:e7:0a
> Dec  2 18:47:23 andynewmac dhclient: Sending on   
> LPF/wlan0/68:a8:6d:24:e7:0a
> Dec  2 18:47:23 andynewmac dhclient: Sending on   Socket/fallback
> Dec  2 18:47:23 andynewmac dhclient: DHCPREQUEST on wlan0 to 
> 255.255.255.255 port 67
> Dec  2 18:47:23 andynewmac dhclient: DHCPACK from 10.42.66.1
> Dec  2 18:47:23 andynewmac dhclient: bound to 10.42.66.138 -- renewal in 
> 127382 seconds.
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> (wlan0): DHCPv4 
> state changed preinit -> reboot
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 4 of 5 (IP4 Configure Get) scheduled...
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 4 of 5 (IP4 Configure Get) started...
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info>   address 
> 10.42.66.138
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info>   prefix 24 
> (255.255.255.0)
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info>   gateway 10.42.66.1
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info>   hostname 
> 'andynewmac'
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info>   nameserver 
> '10.42.66.1'
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info>   domain name 
> 'editshare.boston'
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Scheduling stage 5
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 5 of 5 (IP Configure Commit) scheduled...
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Done scheduling 
> stage 5
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 4 of 5 (IP4 Configure Get) complete.
> Dec  2 18:47:23 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 5 of 5 (IP Configure Commit) started...
> Dec  2 18:47:23 andynewmac avahi-daemon[2391]: Joining mDNS multicast 
> group on interface wlan0.IPv4 with address 10.42.66.138.
> Dec  2 18:47:23 andynewmac avahi-daemon[2391]: New relevant interface 
> wlan0.IPv4 for mDNS.
> Dec  2 18:47:23 andynewmac avahi-daemon[2391]: Registering new address 
> record for 10.42.66.138 on wlan0.IPv4.
> Dec  2 18:47:24 andynewmac NetworkManager[2513]: <info> (wlan0): writing 
> resolv.conf to /sbin/resolvconf
> Dec  2 18:47:24 andynewmac NetworkManager[2513]: <info> (wlan0): device 
> state change: 7 -> 8 (reason 0)
> Dec  2 18:47:24 andynewmac NetworkManager[2513]: <info> Policy set 
> 'System es-network2' (wlan0) as default for IPv4 routing and DNS.
> Dec  2 18:47:24 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) successful, device activated.
> Dec  2 18:47:24 andynewmac NetworkManager[2513]: <info> Activation 
> (wlan0) Stage 5 of 5 (IP Configure Commit) complete.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


