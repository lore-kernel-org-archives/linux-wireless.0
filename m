Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [69.41.248.30] ([69.41.248.30]:37949 "HELO
	gateway07.websitewelcome.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S1754729AbZANXCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 18:02:30 -0500
Received: from 96-26-216-101.sea.clearwire-dns.net ([96.26.216.101]:44769 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LNEjj-0006PH-Vw
	for linux-wireless@vger.kernel.org; Wed, 14 Jan 2009 17:01:24 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: linux-wireless@vger.kernel.org
Subject: Re: 'N' Mode and 5GHz, Also WPA2
Date: Wed, 14 Jan 2009 15:01:16 -0800
References: <200901131502.01047.Info@delphi-real-estate.com> <200901140921.21823.Info@delphi-real-estate.com> <1231972274.20912.142.camel@rc-desk>
In-Reply-To: <1231972274.20912.142.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901141501.16207.Info@delphi-real-estate.com> (sfid-20090115_000235_958826_4F6C776D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wednesday 14 January 2009 2:31:14 pm you wrote:
> Could you please send some debug logs of the association attempts
> (driver and wpa_supplicant) for us to look at? When you do, please
> consider filing a bug at http://www.intellinuxwireless.org/bugzilla/ to
> help us keep track of it.

I am not an expert, and the best way I know of evidencing the failure is
	ifdown wlan0 && ifconfig wlan0 down
	Kill any existing processes:  ps aux |grep wpa
	# wpa_supplicant -c/etc/wpa_supplicant/wpa_supplicant.conf -iwlan0 -d

Is this the best way?

ifup --verbose and /var/log/wpa_action.log don't seem like alot of use for this.

Best,

Bill


/etc/network/interfaces:
----------------------------------------------------------------------------------------
iface wlan0 inet manual
	# Linux drivers are moving to use generic wireless extensions
	wpa-driver wext
	# The file which contains roaming information.
	# We are not really concerned about roaming, but
	# this file contains all of our preferred networks
	# to which wpa_supplicant will connect automatically.
	wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf

	# "home" is a keyword which is used in /etc/wpa_supplicant/wpa_supplicant.conf
	#  to tie this entry and a network definition in wpa_supplicant.conf
iface home inet static
	address 192.168.1.1
	netmask 255.255.255.0
	network 192.168.1.0
	broadcast 192.168.1.255
	gateway 192.168.1.5

        # Reconfigure firewall after interface has been created
#        post-up /etc/init.d/shorewall restart

iface Opensystem inet dhcp


/etc/wpa_supplicant/wpa_supplicant.conf:
----------------------------------------------------------------------------------------

ctrl_interface=/var/run/wpa_supplicant
update_config=0

	# Cloaked Accesspoint
	ap_scan=1

# This is our primary (home) network
network={
	# Accesspoint's SSID (cloaked)
	ssid="Hex"
	scan_ssid=1
	# id_str refers to the entry in /etc/network/interfaces
	id_str="home"
	# Generate key: wpa_passphrase <your_essid> <your_ascii_key>
	psk="Freeasinbeer"
	# Protocol, keymanagement and ciphers. Must match those that the
	# accesspoint uses
	proto=WPA
	# WPA-PSK=="WPA-Personal"
	key_mgmt=WPA-PSK
	# Give this network the highest priority
	priority=100
}

network={
	ssid="any"
	scan_ssid=1
	id_str="Opensystem"
	key_mgmt=NONE
	priority=99
}






