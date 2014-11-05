Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50922 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbaKEQvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 11:51:07 -0500
Message-ID: <545A557A.1010001@candelatech.com> (sfid-20141105_175111_782611_EF7EF389)
Date: Wed, 05 Nov 2014 08:51:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Prigent Xavier MAPS LIS LANNION <labolis2@orange.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: maximum WiFi associations on AP using ath9k and wpa_supplicant
References: <408476212.14050.1415198668705.JavaMail.www@wwinf1g12>
In-Reply-To: <408476212.14050.1415198668705.JavaMail.www@wwinf1g12>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2014 06:44 AM, Prigent Xavier MAPS LIS LANNION wrote:
> Hello All,
> 
>  
> 
> I would like to test how maximum WiFi associations are possible on my AP with security mode. The WiFi authentication, association,4-way handshake are OK but I can not get an IP adress for the second interface.
> 
> It's works in open mode using WPA supplicant but not with WPA2 AES security mode. I use an ath9k driver (AR9380) and Ubuntu 14.04 (same issue on debian 7)

Are you trying to use multiple stations on a single radio?

If so, you need to disable hardware crypt with module option.

Thanks,
Ben

> 
>  
> 
> Could you take a look on the following command line please:
> 
>  
> #APUT SSID: Livebox-7650_5
> wpa_passphrase Livebox-7650_5 123456789 > temp.txt
> sed '1ictrl_interface=/run/wpa_supplicant' temp.txt > my.conf
> sudo rfkill block wifi
> sudo killall wpa_supplicant
> sudo rfkill unblock wifi
> ifconfig wlan0 down
> 
> iw dev wlan0 del
> iw phy phy0 interface add wlan0 type managed
> sudo wpa_supplicant -B -iwlan0 -c./my.conf
> Successfully initialized wpa_supplicant
> #get WiFi status on interface wlan0 
> iw wlan0 link
> Connected to d0:84:b0:05:76:51 (on wlan0)
>     SSID: Livebox-7650_5
>     freq: 5560
>     RX: 29982 bytes (187 packets)
>     TX: 5887 bytes (25 packets)
>     signal: -40 dBm
>     tx bitrate: 65.0 MBit/s MCS 7
> 
>     bss flags:    short-slot-time
>     dtim period:    0
>     beacon int:    100
> #dhclient process on interface wlan0 
> dhclient wlan0
> #get ip on interface wlan0 
> ifconfig wlan0
> wlan0     Link encap:Ethernet  HWaddr 00:03:7f:40:aa:c3  
>           inet adr:192.168.1.12  Bcast:192.168.1.255  Masque:255.255.255.0
>           adr inet6: fe80::203:7fff:fe40:aac3/64 Scope:Lien
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           Packets reçus:19 erreurs:0 :0 overruns:0 frame:0
>           TX packets:27 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 lg file transmission:1000 
>           Octets reçus:2017 (2.0 KB) Octets transmis:6337 (6.3 KB)
> 
> sudo iw dev wlan0 interface add WVSTA1 type station
> sudo ifconfig WVSTA1 hw ether 00:03:7f:40:00:01
> sudo ifconfig WVSTA1 up
> sudo wpa_supplicant -iWVSTA1 -c./my.conf -Dnl80211 &
> Successfully initialized wpa_supplicant
> WVSTA1: CTRL-EVENT-SCAN-STARTED 
> WVSTA1: SME: Trying to authenticate with d0:84:b0:05:76:51 (SSID='Livebox-7650_5' freq=5560 MHz)
> WVSTA1: Trying to associate with d0:84:b0:05:76:51 (SSID='Livebox-7650_5' freq=5560 MHz)
> WVSTA1: Associated with d0:84:b0:05:76:51
> WVSTA1: WPA: Key negotiation completed with d0:84:b0:05:76:51 [PTK=CCMP GTK=TKIP]
> WVSTA1: CTRL-EVENT-CONNECTED - Connection to d0:84:b0:05:76:51 completed [id=0 id_str=]
> #get WiFi status on interface WVSTA1 
> iw WVSTA1 link
> Connected to d0:84:b0:05:76:51 (on WVSTA1)
>     SSID: Livebox-7650_5
>     freq: 5560
>     RX: 16381 bytes (97 packets)
>     TX: 4560 bytes (21 packets)
>     signal: -40 dBm
>     tx bitrate: 65.0 MBit/s MCS 7
> 
>     bss flags:    short-slot-time
>     dtim period:    0
>     beacon int:    100
> #dhclient process on interface WVSTA1 
> dhclient WVSTA1
> 
> 
> 
> I cannot have an IP adress, it stops here....Ok in open security mode using WPA_supplicant. Do you have an idea please?
> 
>  
> 
> Thanks,
> 
>  
> 
> Regards,
> 
>  
> 
> Eric & Xav
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

