Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:61872 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbZIHIRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 04:17:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 323EB3A005
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2009 10:17:09 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mni8xL3vkDwl for <linux-wireless@vger.kernel.org>;
	Tue,  8 Sep 2009 10:17:09 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95FA395.dip0.t-ipconnect.de [217.95.163.149])
	by mx51.mymxserver.com (Postfix) with ESMTP id 6FA1E3A003
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2009 10:17:07 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 4B3C71E004F
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2009 10:16:53 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Possible WEP encryption error with wpa_supplicant -Dnl80211
Date: Tue, 8 Sep 2009 10:16:36 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909081016.37204.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are some details on my ping problem: I seem to be associated
successfully to an Cisco 1231 AP, but no pings are going through
if I use nl80211.

----------------------------------- test.conf
ctrl_interface=/var/run/wpa_supplicant
network={
        ssid="TEST"
        key_mgmt=NONE
        wep_key0="99999"
}
------------------------------------- test.sh
#!/bin/sh
ifconfig eth1 10.2.1.2 netmask 255.255.255.0 up
./wpa_supplicant \
        -D nl80211 \
        -i eth1 \
        -c test.conf \
        -P /var/run/wpa_supplicant.eth1.pid \
        -C /var/run/wpa_supplicant
---------------------------------------------

# ./TEST.sh
CTRL-EVENT-SCAN-RESULTS
Trying to authenticate with 00:13:19:80:da:30 (SSID='TEST' freq=2412 MHz)
Trying to associate with 00:13:19:80:da:30 (SSID='TEST' freq=2412 MHz)
Associated with 00:13:19:80:da:30
CTRL-EVENT-CONNECTED - Connection to 00:1b:53:11:dc:40 completed (auth) [id=0 id_str=]

$ ping -c 5 10.2.1.1
PING 10.2.1.1 (10.2.1.1) 56(84) bytes of data.
>From 10.2.1.2 icmp_seq=1 Destination Host Unreachable
>From 10.2.1.2 icmp_seq=2 Destination Host Unreachable
>From 10.2.1.2 icmp_seq=3 Destination Host Unreachable
>From 10.2.1.2 icmp_seq=4 Destination Host Unreachable
>From 10.2.1.2 icmp_seq=5 Destination Host Unreachable

--- 10.2.1.1 ping statistics ---
5 packets transmitted, 0 received, +5 errors, 100% packet loss, time 4023ms, pipe 3



While this was happening, I used another wireless card monitor
the channel. I then saw ARP packets, but AFAIK they haven't been
encrypted:

Frame 319 (85 bytes on wire, 85 bytes captured)
    Arrival Time: Sep  8, 2009 09:07:34.529847000
    [Time delta from previous packet: 0.012281000 seconds]
    [Time since reference or first frame: 5.988251000 seconds]
    Frame Number: 319
    Packet Length: 85 bytes
    Capture Length: 85 bytes
    [Frame is marked: False]
    [Protocols in frame: radiotap:wlan:llc:arp]
Radiotap Header v0, Length 25
    Header revision: 0
    Header pad: 0
    Header length: 25
    Present flags: 0x0000086f
        .... .... .... .... .... .... .... ...1 = TSFT: True
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = DBM Antenna Signal: True
        .... .... .... .... .... .... .1.. .... = DBM Antenna Noise: True
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = DBM TX Attenuation: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = DB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = DB Antenna Noise: False
        .... .... .... .... .0.. .... .... .... = FCS in header: False
        0... .... .... .... .... .... .... .... = Ext: False
    MAC timestamp: 0
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
    Data Rate: 11.0 Mb/s
    Channel: 2412 (chan 1)
    Channel type: 802.11b (0x00a0)
    SSI Signal: -17 dBm
    SSI Noise: 0 dBm
    Antenna: 2
IEEE 802.11
    Type/Subtype: Data (32)
    Frame Control: 0x0108 (Normal)
        Version: 0
        Type: Data frame (2)
        Subtype: 0
        Flags: 0x1
            DS status: Frame from STA to DS via an AP (To DS: 1 From DS: 0) (0x01)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 213
    BSS Id: 00:1b:53:11:dc:40 (00:1b:53:11:dc:40)
    Source address: Proxim_a0:6d:40 (00:20:a6:a0:6d:40)
    Destination address: Broadcast (ff:ff:ff:ff:ff:ff)
    Fragment number: 0
    Sequence number: 120
Logical-Link Control
    DSAP: SNAP (0xaa)
    IG Bit: Individual
    SSAP: SNAP (0xaa)
    CR Bit: Command
    Control field: U, func=UI (0x03)
        000. 00.. = Command: Unnumbered Information (0x00)
        .... ..11 = Frame type: Unnumbered frame (0x03)
    Organization Code: Encapsulated Ethernet (0x000000)
    Type: ARP (0x0806)
Address Resolution Protocol (request)
    Hardware type: Ethernet (0x0001)
    Protocol type: IP (0x0800)
    Hardware size: 6
    Protocol size: 4
    Opcode: request (0x0001)
    Sender MAC address: Proxim_a0:6d:40 (00:20:a6:a0:6d:40)
    Sender IP address: 10.2.1.2 (10.2.1.2)
    Target MAC address: 00:00:00_00:00:00 (00:00:00:00:00:00)
    Target IP address: 10.2.1.1 (10.2.1.1)






After removing all kernel modules and reloading them again (ath5k,
mac80211, ath, cfg80211) and replacing the "-D nl80211" with "-D wext",
the ping works.

# ./TEST.sh
ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
ioctl[SIOCSIWSCAN]: Device or resource busy
Failed to initiate AP scan.
CTRL-EVENT-SCAN-RESULTS
Trying to associate with 00:1b:53:11:dc:40 (SSID='TEST' freq=2412 MHz)
CTRL-EVENT-SCAN-RESULTS
Trying to associate with 00:13:19:80:da:30 (SSID='TEST' freq=2412 MHz)
Associated with 00:13:19:80:da:30
CTRL-EVENT-CONNECTED - Connection to 00:13:19:80:da:30 completed (auth) [id=0 id_str=]

-- 
http://www.holgerschurig.de
