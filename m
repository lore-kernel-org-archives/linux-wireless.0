Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab3KOJmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:42:54 -0500
Message-ID: <5285EC8C.3050708@lri.fr> (sfid-20131115_104311_219483_637B9386)
Date: Fri, 15 Nov 2013 10:42:36 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: mkettn@technik-emden.de
CC: linux-wireless@vger.kernel.org
Subject: Re: WPA_Supplicant: no unicast with wpa encryption
References: <20131115101803.66967a4e@mke-x61t>
In-Reply-To: <20131115101803.66967a4e@mke-x61t>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/11/2013 10:18, mkettn@technik-emden.de wrote:
> Hello,
> 
> I want to use wpa_supplicant to encrypt a ad-hoc network with WPA.
> Each device is also a router (using babeld). 
> With encryption the support for unicast packages drops. I've used
> tshark to monitor the traffic of two devices (A and B):
> 
> when A wants to ping B it broadcasts a ask for the MAC-address of B.
> B sends the MAC-address successfully but A doesn't care.
> 
> I see the reply of B in tshark (running on B), but the ARP-package
> doesn't show up on tshark on A.
> 
> this only happens with wpa_supplicant enabled.
> 
> The wpa_supplicant.conf looks like this:
> ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
> update_config=1
> 
> # use 'ap_scan=2' on all devices connected to the network
> ap_scan=2
> 
> network={
>     ssid="mesh-wpa"
>     mode=1
>     frequency=2432
>     proto=WPA
>     key_mgmt=WPA-NONE

WPA-NONE is not true WPA. Support for it was broken in wpasupplicant for a long time,
and the kernel does not support it anymore. Use IBSS RSN instead :

proto=RSN
key_mgmt=WPA-PSK
pairwise=CCMP
group=CCMP

> and the /etc/network/interfaces like this:
> auto lo
> 
> iface lo inet loopback
> iface eth0 inet dhcp
> 
> allow-hotplug wlan0
> iface wlan0 inet static
>     address 192.168.13.37
>     netmask 255.255.255.255
> 
>     # Load WPA-Supplicant for WPA in Ad-Hoc Mode
>     wpa-driver wext

wext is deprecated, use nl80211 instead.
