Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from farad.et-inf.fho-emden.de ([139.13.80.1]:44177 "EHLO
	farad.et-inf.fho-emden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3KOJZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:25:03 -0500
Received: from mke-x61t ([139.13.74.206])
	(authenticated bits=0)
	by farad.et-inf.fho-emden.de (8.13.8/8.13.8/Debian-3) with ESMTP id rAF9I3pT030240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 10:18:04 +0100
Date: Fri, 15 Nov 2013 10:18:03 +0100
From: mkettn@technik-emden.de
To: linux-wireless@vger.kernel.org
Subject: WPA_Supplicant: no unicast with wpa encryption
Message-ID: <20131115101803.66967a4e@mke-x61t> (sfid-20131115_102509_646800_659DBE79)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I want to use wpa_supplicant to encrypt a ad-hoc network with WPA.
Each device is also a router (using babeld). 
With encryption the support for unicast packages drops. I've used
tshark to monitor the traffic of two devices (A and B):

when A wants to ping B it broadcasts a ask for the MAC-address of B.
B sends the MAC-address successfully but A doesn't care.

I see the reply of B in tshark (running on B), but the ARP-package
doesn't show up on tshark on A.

this only happens with wpa_supplicant enabled.

The wpa_supplicant.conf looks like this:
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

# use 'ap_scan=2' on all devices connected to the network
ap_scan=2

network={
    ssid="mesh-wpa"
    mode=1
    frequency=2432
    proto=WPA
    key_mgmt=WPA-NONE
    pairwise=NONE
    group=TKIP
    psk="secret passphrase"
}


and the /etc/network/interfaces like this:
auto lo

iface lo inet loopback
iface eth0 inet dhcp

allow-hotplug wlan0
iface wlan0 inet static
    address 192.168.13.37
    netmask 255.255.255.255

    # Load WPA-Supplicant for WPA in Ad-Hoc Mode
    wpa-driver wext
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

iface default inet dhcp


I'm using two RaspberryPis with Raspbian Linux 3.6.11+.
Here is the device descriptor of the wlan usb stick:
lsusb -v -d 0cf3:9271 - http://pastebin.com/nfvVp80u

the output of wpa_supplicant -i wlan0 -D wext
-c /etc/wpa_supplicant/wpa_supplicant.conf brings:

ioctl[SIOCSIWPMKSA]: Invalid argument
ioctl[SIOCSIWENCODEEXT]: Invalid argument
ioctl[SIOCSIWENCODEEXT]: Invalid argument
wlan0: Trying to associate with SSID 'mesh-wpa'
ioctl[SIOCSIWGENIE]: Operation not supported
wlan0: Association request to the driver failed
wlan0: CTRL-EVENT-CONNECTED - Connection to 00:00:00:00:00:00 completed
(auth) [id=-1 id_str=] wlan0: Trying to associate with SSID 'mesh-wpa'
ioctl[SIOCSIWENCODEEXT]: Invalid argument
ioctl[SIOCSIWENCODEEXT]: Invalid argument
ioctl[SIOCSIWGENIE]: Operation not supported
wlan0: Association request to the driver failed
wlan0: CTRL-EVENT-CONNECTED - Connection to 00:00:00:00:00:00 completed
(reauth) [id=0 id_str=]

-Mark
