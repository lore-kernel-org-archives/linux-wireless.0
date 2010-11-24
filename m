Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:49473
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab0KXCut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 21:50:49 -0500
Date: Wed, 24 Nov 2010 13:41:22 +1100
From: Daniel Dalton <d.dalton@iinet.net.au>
To: linux-wireless@vger.kernel.org
Subject: Problems connecting to WPA2 networks (possibly atheros drivers)
Message-ID: <20101124024122.GA26665@gwsc.vic.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi, 

I'm having difficulty connecting to a WPA2 enterprise network. The
system is fine connecting to standard WPA and open networks, but refuses
to connect to my school's WPA2 network. 
We tried with another machine using different wireless chipset and that
works fine. 
When connecting my syslog fills with the following messages:

Oct  4 08:14:40 debian-eeepc kernel: [  265.678837] wlan0: direct probe
to AP c4:7d:4f:8a:3b:40 (try 1)
Oct  4 08:14:40 debian-eeepc kernel: [  265.876159] wlan0: direct probe
to AP c4:7d:4f:8a:3b:40 (try 2)
Oct  4 08:14:40 debian-eeepc kernel: [  265.882235] wlan0: direct probe
responded
Oct  4 08:14:40 debian-eeepc kernel: [  265.882249] wlan0: authenticate
with AP c4:7d:4f:8a:3b:40 (try 1)
Oct  4 08:14:40 debian-eeepc kernel: [  265.884259] wlan0: authenticated
Oct  4 08:14:40 debian-eeepc kernel: [  265.884326] wlan0: associate
with AP c4:7d:4f:8a:3b:40 (try 1)
Oct  4 08:14:40 debian-eeepc kernel: [  265.886698] wlan0: RX AssocResp
from c4:7d:4f:8a:3b:40 (capab=0x431 status=13 aid=0)
Oct  4 08:14:40 debian-eeepc kernel: [  265.886709] wlan0: AP denied
association (code=13)
Oct  4 08:14:40 debian-eeepc kernel: [  265.886748] wlan0:
deauthenticating from c4:7d:4f:8a:3b:40 by local choice (reason=3)

Regarding the wireless network device inside my netbook, here is output
of lspci:
01:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless
Network Adapter (PCI-Express) (rev 01)

When I google Atheros Ar9285 with WPA2 I learn that there are problems
with this device. I came across the following link:
http://ubuntuforums.org/showthread.php?t=1244686

I should also say that I tested this machine with a live version of
ubuntu off the cd, with kernel 2.6.35 and experienced exactly the same
problems. I'm using wpasupplicant to connect, as well as tried with the
gui on ubuntu. No luck with any. 

I'm running debian Testing (Squeeze), and kernel version:
Linux debian-eeepc 2.6.32-5-686 #1 SMP Sat Oct 30 22:47:19 UTC 2010 i686
GNU/Linux

I believe a possible solution is to use backports as suggested by the
page I pasted I believe. Is this the best solution? If so how can I
apply it to a debian system? 
Does it look like there is a problem with the atheros drivers for this
device...?

Finally, if required below my name is my Wpa_supplicant configuration
along with my /etc/network/interfaces file.

If anyone can assist me with this issue I'd greatly appreciate it!

Cheers, 
Dan

# /etc/network/interfaces:
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback
# eth0
allow-hotplug eth0
iface eth0 inet dhcp
#  address 192.168.2.2
#  netmask 255.255.255.0
#  network 192.168.2.1
#  broadcast 192.168.2.255
#  gateway 192.168.2.1
#  dns-search lan
#  dns-nameservers 203.0.178.191

  post-up /sbin/fw-start.sh # firewall 

allow-hotplug wlan0
iface wlan0 inet manual
        wpa-driver wext
       wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
#  post-up /sbin/fw-start.sh
# no id_str, 'default' is used as the fallback mapping target
iface default inet dhcp
iface school inet dhcp

# id_str="home"
iface home inet static
  address 192.168.2.11
  netmask 255.255.255.0
  network 192.168.2.1
  broadcast 192.168.2.255
  gateway 192.168.2.1
  dns-search lan
  dns-nameservers 203.0.178.191
 
# /etc/wpa_supplicant/wpa_supplicant.conf 

ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=root

# Default behaviour is to associate with any open access point, further
# networks can be configured with wpa_cli/wpa_gui.
#
 fast_reauth=1
network={
        key_mgmt=NONE
}

# This is the network I'm having trouble connecting to
 network={
      ssid="ssid_of_school_network"
      key_mgmt=IEEE8021X
      eap=TLS
      identity="eepc" #(name of the certificate/zipfile)
 client_cert="/home/daniel/network/certs/usercert.pem"
      ca_cert="/home/daniel/network/certs/root.pem"
      private_key="/home/daniel/network/certs/userkey.pem"
      private_key_passwd="psk"
      eapol_flags=3
#       id_str="school"
 }

# Wep
 #network={
#       ssid="Example WEP Network"
#       key_mgmt=NONE
#       wep_key0=6162636465
#       wep_tx_keyidx=0
#       id_str="johns_house"
#}

# the following works fine
network={
       ssid="home_ssid"
       psk="PSK_for_home_network"
       id_str="home"
}
 
