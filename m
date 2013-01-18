Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([125.18.18.171]:5938 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3ARPQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 10:16:41 -0500
From: Girish Bn <Girish.BN@lnties.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wl12xx : ping to wlan0(Station) doesn't work after creating wlan1
 interface
Date: Fri, 18 Jan 2013 15:17:20 +0000
Message-ID: <45566970CF58C74CB52107862E0541CD1D1EB092@POCITMSEXMB02.LntUniverse.com> (sfid-20130118_161645_333151_BFF00BBE)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Details of our platform is as follows
1. Hardware Platform: LPC313X
2. Kernel Version: 2.6.28.2
3. Compat Wireless package version: compat-wireless-3.5-rc5-1
Taken from http://linuxwireless.org/en/users/Download/stable/
4. WL1271 Firmware Revisions
a) Single Role : X.3.7.0.105 (Rev 6.3.7.0.105)
b) Multi-Role:  X.5.5.0.21 (Rev 6.5.3.0.21)

5. WPA Supplicant Version: wpa_supplicant_1.1
6. IW Tool Version: 3.2

We are enabling multi-role operation(Station and AP(P2P GO) mode) using the following commands
1.      Load the Compat wireless drivers (compat.ko,cfg80211.ko,mac80211.ko,compat_firmware_class.ko,rfkill_backport.ko, wlcore.ko,wl12xx.ko and wlcore_sdio.ko)

2.      Set wlan0 as station
#ifconfig wlan0 hw ether 08:00:28:34:56:22
#ifconfig wlan0 10.2.30.34 netmask 255.255.255.0 up

3.      Disable power save mode on wlan0
#iw wlan0 set power_save off

4.      wlan1 as GO (Group Owner)
Create a new interface called wlan1 which would be configured as a GO(Group Owner)
#iw phy0 interface add wlan1 type managed

Configure Ethernet and IP address of the wlan1 interface
#ifconfig wlan1 hw ether 08:00:28:44:56:83

5.      Start the interfaces

Start wlan0 as Station mode (run the WPA supplicant)
#./wpa_supplicant -d -Dnl80211 -c/wlan/wpa_supplicant_station.conf -iwlan0 -B

The wpa_supplicant_station.conf file contents is as follows
        ctrl_interface=/var/run/wpa_supplicant
        ap_scan=1

        network={
                ssid="Cisco_WPA2-TKIP/AES"
                psk="abcdefghijklmn*1234567890"
                proto=RSN
                key_mgmt=WPA-PSK
                pairwise=TKIP
                group=TKIP
                auth_alg=OPEN
        }
Get the ip addres for Station from AP
# udhcpc -i wlan0 -b

Start wlan1 in GO mode using the previously created p2p.conf(attached the file) file
#./wpa_supplicant -Dnl80211 -iwlan1 -c /wlan/p2p.conf &
The contents of p2p.conf is as follows
        ctrl_interface=/var/run/wpa_supplicant
        ap_scan=1
        device_name=TI_WLAN_P2P
        device_type=1-0050F204-1

        config_methods=label push_button

        # optional, can be useful for monitoring, forces
        # wpa_supplicant to use only channel 1 rather than
        # 1, 6 and 11:
        #p2p_listen_reg_class=81
        #p2p_listen_channel=1
        p2p_oper_reg_class=81
        p2p_oper_channel=1

        network={
                mode=3
                disabled=2
                ssid="DIRECT-BN"
                key_mgmt=WPA-PSK
                proto=RSN
                pairwise=CCMP
                group=CCMP TKIP
                psk="12345678"
        }

#./wpa_cli -i wlan1 p2p_group_add persistent=0 freq=2412

With the above steps the Role 1 and Role 2 will be started successfully
1.      Start the UDHCPD server
#echo 1 > /proc/sys/net/ipv4/ip_forward
#ifconfig wlan1 10.4.30.39
#udhcpd /wlan/udhcpd.conf


The issue is, after starting P2P GO, may be after 2 to 3mins, the ping operation from any other PC/Laptop which is connected to the same AP as Station(wlan0) fails.
However, if I start the ping from my device to the PC/Laptop, ping operation succeeds and also ping from other side works(which failed before).
We suspect some issue while creating the multi-role interface(wlan1 for P2P GO) is causing the problem.
Any suggestions are welcome

Thanks & Regards,
Girish
L&T IES,
KIADB Industrial Area,
Hebbal-Hootagalli, Mysore - 570 018
Telephone :  DID+91-821-2405552
Mobile: +91-9741206402
E-mail ID :Girish.BN@lnties.com
www.lnties.com

This mail is classified as :
(  ) L&T IES Proprietary
(  ) L&T IES Confidential
(X) L&T IES Internal Use
( ) L&T IES General Business

Larsen & Toubro Limited

www.larsentoubro.com

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
