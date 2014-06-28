Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52181 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaF1CpH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 22:45:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1X0idT-0007p7-Ir
	for linux-wireless@vger.kernel.org; Sat, 28 Jun 2014 04:45:04 +0200
Received: from 64-31-120-162.static-ip.telepacific.net ([64.31.120.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 04:45:03 +0200
Received: from frodo.lai by 64-31-120-162.static-ip.telepacific.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 04:45:03 +0200
To: linux-wireless@vger.kernel.org
From: frodo <frodo.lai@gmail.com>
Subject: Re: Integrate Intel 3160 Freescale imx.6 with AOSP 4.3 (3.0.35 kernel) and backports 3.14.1
Date: Sat, 28 Jun 2014 02:39:34 +0000 (UTC)
Message-ID: <loom.20140628T041047-206@post.gmane.org> (sfid-20140628_044524_663409_B76AB023)
References: <43860A184C2C6446B49A5DEBD1F0DA6B815E766D@PDIMBX.PDIARM.local> <CANUX_P0N6oqDHOSJ-=bM11uf730ishMxwWD_yLtwYZrK02qp=Q@mail.gmail.com> <43860A184C2C6446B49A5DEBD1F0DA6B815E76D0@PDIMBX.PDIARM.local> <CB3B3D4774441E42AA3EA0E1BA8230A0333FC1FA@HASMSX106.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Peer, Ilan <ilan.peer@...> writes:

> 
> Hi Rob,
> 
> From the logcat output below it looks like u are using a version of 
wpa_supplicant that does not include some
> fixes that are required for properly setting up the P2P_DEVICE interface.
> 
> Can you try switching to using the upstream hostap repository? Using the 
upstream version you should
> enable the p2p_device=1 driver parameter and in addition pass the P2P 
Device configuration file using
> the -m option. Something like this:
> 
> wpa_supplicant -i wlan0 -c <conf> ....  -pp2p_device=1 ... -m <p2p config 
file>
> 
> The wpa_supplicant will create the P2P Device interface and start it so no 
need to add the interface using
> iw. Note that the name of the created interface is p2p-dev-wlan0 (or 
something like that) so you'll need to
> tweak it so that Android framework would be happy.
> 
> Regards,
> 
> Ilan.
> 


Hi Ilan,

I checkout the branch android-kk from hostap repository and tried the 
wpa_supplicant command with -m option:
/system/bin/wpa_supplicant -dt -i wlan0 -Dnl80211 -
c/data/misc/wifi/wpa_supplicant.conf -pp2p_device=1 -
m/data/misc/wifi/p2p_supplicant.conf -O/data/misc/wifi/sockets -B

I got two interfaces in /data/misc/wifi/sockets
130|root@ar6mx:/ # ls /data/misc/wifi/sockets/
p2p-dev-wlan0
wlan0

However, the wpa_supplicant failed to create P2P_DEVICE wit error "Invalid 
argumen". How can I debug this? Thanks.

D/wpa_supplicant( 3843): nl80211: Create interface iftype 10 (P2P_DEVICE)
D/wpa_supplicant( 3843): nl80211: New P2P Device interface p2p-dev-wlan0 
(0x4) created
D/wpa_supplicant( 3843): Override interface parameter: ctrl_interface 
('(null)' -> '/data/misc/wifi/sockets')
D/wpa_supplicant( 3843): Initializing interface 'p2p-dev-wlan0' conf 
'/data/misc/wifi/p2p_supplicant.conf' driver 'nl80211' ctrl_interface 
'/data/misc/wifi/sockets' bridge 'N/A'
D/wpa_supplicant( 3843): Configuration file 
'/data/misc/wifi/p2p_supplicant.conf' -> 
'/data/misc/wifi/p2p_supplicant.conf'
D/wpa_supplicant( 3843): Reading configuration file 
'/data/misc/wifi/p2p_supplicant.conf'
D/wpa_supplicant( 3843): ctrl_interface='/data/system/wpa_supplicant'
D/wpa_supplicant( 3843): update_config=1
D/wpa_supplicant( 3843): ap_scan=1
I/wpa_supplicant( 3843): rfkill: Cannot open RFKILL control device
D/wpa_supplicant( 3843): nl80211: RFKILL status not available
E/wpa_supplicant( 3843): Could not read interface p2p-dev-wlan0 flags: No 
such device
D/wpa_supplicant( 3843): nl80211: Supported cipher 00-0f-ac:4
D/wpa_supplicant( 3843): nl80211: Supported cipher 00-0f-ac:2
D/wpa_supplicant( 3843): nl80211: Supported cipher 00-0f-ac:1
D/wpa_supplicant( 3843): nl80211: Supported cipher 00-0f-ac:5
D/wpa_supplicant( 3843): nl80211: Supported cipher 00-0f-ac:6
D/wpa_supplicant( 3843): nl80211: Supported cipher 00-14-72:1
D/wpa_supplicant( 3843): nl80211: Using driver-based off-channel TX
I/wpa_supplicant( 3843): nl80211: send_and_recv->nl_recvmsgs failed: 20
D/wpa_supplicant( 3843): nl80211: Use separate P2P group interface (driver 
advertised support)
D/wpa_supplicant( 3843): nl80211: interface p2p-dev-wlan0 in phy phy0
D/wpa_supplicant( 3843): nl80211: Set mode ifindex 0 iftype 10 (P2P_DEVICE)
I/wpa_supplicant( 3843): nl80211: send_and_recv->nl_recvmsgs failed: -22
D/wpa_supplicant( 3843): nl80211: Failed to set interface 0 to mode 10: -22 
(Invalid argument)

Frodo


