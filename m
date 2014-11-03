Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f196.google.com ([209.85.212.196]:37417 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaKCHet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 02:34:49 -0500
Received: by mail-wi0-f196.google.com with SMTP id h11so2128433wiw.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2014 23:34:48 -0800 (PST)
Message-ID: <54573016.7060400@gmail.com> (sfid-20141103_083500_436713_3D6D3FBB)
Date: Mon, 03 Nov 2014 08:34:46 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] Ralink RT3070(rt2800usb) - The Tortoise and the
 Hare
References: <5455C833.2080706@gmail.com> <20141102130003.GA10104@redhat.com> <54564C6E.6010904@gmail.com> <5456A7B0.5020909@gmail.com>
In-Reply-To: <5456A7B0.5020909@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Comparing

- 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter
  & rt2800usb.ko & Co. / rt2870.bin

- 0bda:8171 Realtek Semiconductor Corp. RTL8188SU 802.11n WLAN Adapter
  & r8712u.ko / rtl8712u.bin

Realtek RTL8188SU easily outperformes Ralink RT3070
in managed i.e. Station (STA) infrastructure mode, despite 
...
r8712u: module is from the staging directory, the quality is unknown, you have been warned.
r8712u: Staging version
...

With the very same Access Point - AP1.

In this test, Realtek is the king of the road.

- Net draft
  RT3070/RTL8188SU Wi-Fi <~20cm LOS~> AP1 Wi-Fi <-> 100Mbit Ethernet switch <-> Ethernet


°°°°°°°°°°°°°°°

$ iperf -s -i 1
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.5 port 5001 connected with 192.168.2.43 port 43008
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 1.0 sec  11.0 MBytes  92.3 Mbits/sec
[  4]  1.0- 2.0 sec  11.2 MBytes  94.0 Mbits/sec
[  4]  2.0- 3.0 sec  11.2 MBytes  94.2 Mbits/sec
[  4]  3.0- 4.0 sec  10.0 MBytes  83.9 Mbits/sec
[  4]  4.0- 5.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  5.0- 6.0 sec  11.2 MBytes  94.2 Mbits/sec
[  4]  6.0- 7.0 sec  11.2 MBytes  94.2 Mbits/sec
[  4]  7.0- 8.0 sec  11.2 MBytes  94.2 Mbits/sec
[  4]  8.0- 9.0 sec  11.2 MBytes  94.2 Mbits/sec
[  4]  9.0-10.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  0.0-10.1 sec   112 MBytes  92.9 Mbits/sec

°°°°°°°°°°°°°°°°°°°°°°°°°°°

$ iperf -c 192.168.2.5 -i 1
------------------------------------------------------------
Client connecting to 192.168.2.5, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.43 port 43008 connected with 192.168.2.5 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  11.5 MBytes  96.5 Mbits/sec
[  3]  1.0- 2.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  2.0- 3.0 sec  11.4 MBytes  95.4 Mbits/sec
[  3]  3.0- 4.0 sec  9.88 MBytes  82.8 Mbits/sec
[  3]  4.0- 5.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  5.0- 6.0 sec  11.1 MBytes  93.3 Mbits/sec
[  3]  6.0- 7.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  7.0- 8.0 sec  11.4 MBytes  95.4 Mbits/sec
[  3]  8.0- 9.0 sec  11.1 MBytes  93.3 Mbits/sec
[  3]  9.0-10.0 sec  11.4 MBytes  95.4 Mbits/sec
[  3]  0.0-10.0 sec   112 MBytes  93.5 Mbits/sec

°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

$ iperf -s -i 1
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.43 port 5001 connected with 192.168.2.5 port 47065
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 1.0 sec  9.34 MBytes  78.3 Mbits/sec
[  4]  1.0- 2.0 sec  10.5 MBytes  88.5 Mbits/sec
[  4]  2.0- 3.0 sec  11.0 MBytes  92.6 Mbits/sec
[  4]  3.0- 4.0 sec  11.0 MBytes  92.4 Mbits/sec
[  4]  4.0- 5.0 sec  11.1 MBytes  93.3 Mbits/sec
[  4]  5.0- 6.0 sec  10.9 MBytes  91.7 Mbits/sec
[  4]  6.0- 7.0 sec  11.2 MBytes  93.9 Mbits/sec
[  4]  7.0- 8.0 sec  11.2 MBytes  93.6 Mbits/sec
[  4]  8.0- 9.0 sec  11.0 MBytes  92.7 Mbits/sec
[  4]  9.0-10.0 sec  11.2 MBytes  93.6 Mbits/sec
[  4]  0.0-10.1 sec   110 MBytes  91.1 Mbits/sec

°°°°°°°°°°°°°°°°°°°°°°°°°°°°

$ iperf -c 192.168.2.43 -i 1
------------------------------------------------------------
Client connecting to 192.168.2.43, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.5 port 47065 connected with 192.168.2.43 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  10.0 MBytes  83.9 Mbits/sec
[  3]  1.0- 2.0 sec  10.4 MBytes  87.0 Mbits/sec
[  3]  2.0- 3.0 sec  11.5 MBytes  96.5 Mbits/sec
[  3]  3.0- 4.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  4.0- 5.0 sec  10.8 MBytes  90.2 Mbits/sec
[  3]  5.0- 6.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  6.0- 7.0 sec  11.4 MBytes  95.4 Mbits/sec
[  3]  7.0- 8.0 sec  11.0 MBytes  92.3 Mbits/sec
[  3]  8.0- 9.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  9.0-10.0 sec  11.1 MBytes  93.3 Mbits/sec
[  3]  0.0-10.0 sec   110 MBytes  91.9 Mbits/sec

°°°°°°°°°°°°°°°°°°°°°

# iwconfig wlp0s4f1u3 
wlp0s4f1u3  IEEE 802.11bgn  ESSID:"AP1"  Nickname:"rtl_wifi"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:01:02:03:04:05   
          Bit Rate:150 Mb/s   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:****-****-****-****-****-****-****-****   Security mode:open
          Power Management:off
          Link Quality=100/100  Signal level=100/100  Noise level=0/100
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

$ dmesg -t | grep 'r8712u\|2-3'
usb 2-3: new high-speed USB device number 3 using ehci-pci
usb 2-3: New USB device found, idVendor=0bda, idProduct=8171
usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-3: Product: RTL8188S WLAN Adapter 
usb 2-3: Manufacturer: Manufacturer Realtek 
usb 2-3: SerialNumber: 00e04c000001
r8712u: module is from the staging directory, the quality is unknown, you have been warned.
r8712u: Staging version
r8712u: register rtl8712_netdev_ops to netdev_ops
usb 2-3: r8712u: USB_SPEED_HIGH with 4 endpoints
usb 2-3: r8712u: Boot from EFUSE: Autoload OK
usb 2-3: r8712u: CustomerID = 0x0000
usb 2-3: r8712u: MAC Address from efuse = 00:01:05:09:0b:0d
usb 2-3: r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
usbcore: registered new interface driver r8712u
r8712u 2-3:1.0 wlp0s4f1u3: renamed from wlan0
r8712u 2-3:1.0 wlp0s4f1u3: 1 RCR=0x153f00e
r8712u 2-3:1.0 wlp0s4f1u3: 2 RCR=0x553f00e

°°°°°°°°°°°°°°°°°°°
$ modinfo r8712u -n
/lib/modules/3.17.2-200.fc20.x86_64/kernel/drivers/staging/rtl8712/r8712u.ko.xz

°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°


However, it is important to note, 
despite the relatively low throughput

- 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter
  & rt2800usb.ko & Co. / rt2870.bin

is the combination full featured 

http://wireless.kernel.org/en/users/Drivers - rt2800usb

°°°°°°°°°°°°°°°°°°

On the other side, 
despite the great throughput

- 0bda:8171 Realtek Semiconductor Corp. RTL8188SU 802.11n WLAN Adapter
  & r8712u.ko / rtl8712u.bin

is the combination supports only managed i.e. Station (STA) infrastructure mode

Besides it needs some help with the suspend/resume cycle

Kernel module(r8712u) reload - suspend/resume - systemd
http://www.spinics.net/lists/linux-wireless/msg128666.html

http://wireless.kernel.org/en/users/Documentation/modes#Station_.28STA.29_infrastructure_mode
http://wireless.kernel.org/en/users/Drivers - r8712u
http://wireless.kernel.org/en/users/Drivers/rtl819x#staging_drivers - r8712u
http://wireless.kernel.org/en/users/Drivers/rtl819x#rtlwifi - rtl8192su

°°°°°°°°°°°         °°°°°°°°°°°°°°°°°°°           °°°°°°°°°°°°°°°°°°°°

- 0bda:8171 Realtek Semiconductor Corp. RTL8188SU 802.11n WLAN Adapter
  & rtl8192su.ko / rtl8192sufw.bin

is the combination supports master i.e. AccessPoint (AP) infrastructure mode, 
and testing has proved, with the very low throughput, but still usable

RTL8188SU(rtl8192su) & rtl8192sufw-ap.bin
http://www.spinics.net/lists/linux-wireless/msg128031.html
http://goo.gl/3O3Tz4


poma


