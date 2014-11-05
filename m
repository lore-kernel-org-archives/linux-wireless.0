Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:37163 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaKEOoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 09:44:34 -0500
Date: Wed, 5 Nov 2014 15:44:28 +0100 (CET)
From: Prigent Xavier MAPS LIS LANNION <labolis2@orange.fr>
Reply-To: Prigent Xavier MAPS LIS LANNION <labolis2@orange.fr>
To: linux-wireless@vger.kernel.org
Message-ID: <408476212.14050.1415198668705.JavaMail.www@wwinf1g12> (sfid-20141105_154527_208244_56951789)
Subject: maximum WiFi associations on AP using ath9k and wpa_supplicant
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,

 

I would like to test how maximum WiFi associations are possible on my AP with security mode. The WiFi authentication, association,4-way handshake are OK but I can not get an IP adress for the second interface.

It's works in open mode using WPA supplicant but not with WPA2 AES security mode. I use an ath9k driver (AR9380) and Ubuntu 14.04 (same issue on debian 7)

 

Could you take a look on the following command line please:

 
#APUT SSID: Livebox-7650_5
wpa_passphrase Livebox-7650_5 123456789 > temp.txt
sed '1ictrl_interface=/run/wpa_supplicant' temp.txt > my.conf
sudo rfkill block wifi
sudo killall wpa_supplicant
sudo rfkill unblock wifi
ifconfig wlan0 down

iw dev wlan0 del
iw phy phy0 interface add wlan0 type managed
sudo wpa_supplicant -B -iwlan0 -c./my.conf
Successfully initialized wpa_supplicant
#get WiFi status on interface wlan0 
iw wlan0 link
Connected to d0:84:b0:05:76:51 (on wlan0)
    SSID: Livebox-7650_5
    freq: 5560
    RX: 29982 bytes (187 packets)
    TX: 5887 bytes (25 packets)
    signal: -40 dBm
    tx bitrate: 65.0 MBit/s MCS 7

    bss flags:    short-slot-time
    dtim period:    0
    beacon int:    100
#dhclient process on interface wlan0 
dhclient wlan0
#get ip on interface wlan0 
ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:03:7f:40:aa:c3  
          inet adr:192.168.1.12  Bcast:192.168.1.255  Masque:255.255.255.0
          adr inet6: fe80::203:7fff:fe40:aac3/64 Scope:Lien
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          Packets reçus:19 erreurs:0 :0 overruns:0 frame:0
          TX packets:27 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:1000 
          Octets reçus:2017 (2.0 KB) Octets transmis:6337 (6.3 KB)

sudo iw dev wlan0 interface add WVSTA1 type station
sudo ifconfig WVSTA1 hw ether 00:03:7f:40:00:01
sudo ifconfig WVSTA1 up
sudo wpa_supplicant -iWVSTA1 -c./my.conf -Dnl80211 &
Successfully initialized wpa_supplicant
WVSTA1: CTRL-EVENT-SCAN-STARTED 
WVSTA1: SME: Trying to authenticate with d0:84:b0:05:76:51 (SSID='Livebox-7650_5' freq=5560 MHz)
WVSTA1: Trying to associate with d0:84:b0:05:76:51 (SSID='Livebox-7650_5' freq=5560 MHz)
WVSTA1: Associated with d0:84:b0:05:76:51
WVSTA1: WPA: Key negotiation completed with d0:84:b0:05:76:51 [PTK=CCMP GTK=TKIP]
WVSTA1: CTRL-EVENT-CONNECTED - Connection to d0:84:b0:05:76:51 completed [id=0 id_str=]
#get WiFi status on interface WVSTA1 
iw WVSTA1 link
Connected to d0:84:b0:05:76:51 (on WVSTA1)
    SSID: Livebox-7650_5
    freq: 5560
    RX: 16381 bytes (97 packets)
    TX: 4560 bytes (21 packets)
    signal: -40 dBm
    tx bitrate: 65.0 MBit/s MCS 7

    bss flags:    short-slot-time
    dtim period:    0
    beacon int:    100
#dhclient process on interface WVSTA1 
dhclient WVSTA1



I cannot have an IP adress, it stops here....Ok in open security mode using WPA_supplicant. Do you have an idea please?

 

Thanks,

 

Regards,

 

Eric & Xav
