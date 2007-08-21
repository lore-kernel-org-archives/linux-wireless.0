Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 84-16-245-18.internetserviceteam.com ([84.16.245.18]:50069 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559AbXHUQbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 12:31:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by hauke-m.de (Postfix) with ESMTP id 11278C92D
	for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2007 18:05:45 +0200 (CEST)
Received: from hauke-m.de ([84.16.245.18])
	by localhost (vs9007.vserver4free.de [84.16.245.18]) (amavisd-new, port 10024)
	with ESMTP id WMdgl3l8wjrq for <linux-wireless@vger.kernel.org>;
	Tue, 21 Aug 2007 18:05:39 +0200 (CEST)
Received: from [192.168.0.2] (p54808278.dip0.t-ipconnect.de [84.128.130.120])
	by hauke-m.de (Postfix) with ESMTP id F3446C92A
	for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2007 18:05:37 +0200 (CEST)
Message-ID: <46CB0D50.1010201@hauke-m.de>
Date: Tue, 21 Aug 2007 18:05:36 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Bug in rtl8187 driver in Kernel 2.6.23-rc3-git1
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi list

I was surfing in the internet when suddenly the connection was lost. I
am going through a Wireless LAN with a rtl8187 based card(ASUS P5B
Deluxe WIFI board) into the internet and it often crashes ( round about
every 3 hours, but somedays it's running stable for a hole day)

iwconfig outputs the following:

wlan0     IEEE 802.11g  ESSID:"mehrtenswlan"
          Mode:Managed  Frequency:2.462 GHz  Access Point:
00:1A:92:EA:73:12
          Bit Rate=3D11 Mb/s
          Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B
          Link Quality=3D45/64  Signal level=3D20/65
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

The Link Quality is changing a little bit but the Signal level stays
constantly at 20/65

A ping to a network device outputs the following:

 ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
- From 192.168.0.2 icmp_seq=3D11 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D12 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D13 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D14 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D16 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D17 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D18 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D19 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D20 Destination Host Unreachable
ping: sendmsg: No buffer space available
ping: sendmsg: No buffer space available
ping: sendmsg: No buffer space available
ping: sendmsg: No buffer space available
ping: sendmsg: No buffer space available
 ....

stopping ping and restart it again outputs the following:

ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
- From 192.168.0.2 icmp_seq=3D13 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D14 Destination Host Unreachable
- From 192.168.0.2 icmp_seq=3D15 Destination Host Unreachable
ping: sendmsg: No buffer space available
ping: sendmsg: No buffer space available
ping: sendmsg: No buffer space available
ping: sendmsg: No buffer space available

Because I often have this error and I can't reproduce it I changed the
mac80211 framework to debug mode:

and here is the dmesg output:

[ 1735.702932] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3Dff:ff:f=
f:ff:ff:ff
[ 1736.699612] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3Dff:ff:f=
f:ff:ff:ff
[ 1737.697027] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3Dff:ff:f=
f:ff:ff:ff
[ 1740.693280] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3Dff:ff:f=
f:ff:ff:ff
[ 1741.686700] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3Dff:ff:f=
f:ff:ff:ff
[ 1742.684651] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3Dff:ff:f=
f:ff:ff:ff
[ 1745.676361] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3Dff:ff:f=
f:ff:ff:ff
[ 1746.677767] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3Dff:ff:f=
f:ff:ff:ff
[ 1747.671195] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3Dff:ff:f=
f:ff:ff:ff
[ 1758.047746] TKIP decrypt: data(len=3D56) 05 25 66 60 00 00 00 00 24 =
06
86 ba 1c b8 b7 5d d7 f4 f7 3c c5 78 10 59 f8 f3 5a 10 70 e1 99 3f 4a 8c
b4 84 a5 c6 56 9e 31 55 18 74 54 cf 9e 25 8b 91 03 86 77 7f 5c 99
[ 1758.047771] TKIP decrypt: iv16=3D0566 iv32=3D00000000
[ 1758.047774] TKIP decrypt: Phase2 rc4key=3D05 25 66 e0 0a 6c ca 92 ce=
 1e
3e 4e d6 9f f9 24
[ 1758.047812] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1759.069453] TKIP decrypt: data(len=3D56) 05 25 68 60 00 00 00 00 98 =
27
33 9b 7b 81 8b 31 6a cb a3 ab 1c c1 ce b4 e6 39 14 21 11 44 b8 0c 6b 27
03 d2 b3 36 54 1d 07 98 ce c9 1b 0f b3 83 f5 7b 04 3b 10 71 d1 6e
[ 1759.069474] TKIP decrypt: iv16=3D0568 iv32=3D00000000
[ 1759.069476] TKIP decrypt: Phase2 rc4key=3D05 25 68 43 3e ff 9b f3 7e=
 93
82 5d f3 bc be 81
[ 1759.069511] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1759.988429] TKIP decrypt: data(len=3D56) 05 25 69 60 00 00 00 00 fd =
e9
93 5d c1 f9 bd 63 25 79 7e 73 50 5a 4e c6 3a 9b 77 12 05 97 d1 f7 56 3b
c0 cd 30 e1 43 1d e0 2b 9e 7f f3 cc d1 f3 05 0e 57 f3 a5 98 dc a7
[ 1759.988454] TKIP decrypt: iv16=3D0569 iv32=3D00000000
[ 1759.988457] TKIP decrypt: Phase2 rc4key=3D05 25 69 79 03 4b 2c 3f 06=
 12
a7 14 0c 80 cb 2d
[ 1759.988497] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1764.176244] TKIP decrypt: data(len=3D56) 05 25 6c 60 00 00 00 00 d5 =
b4
eb 20 72 63 95 89 59 d8 b3 2b bf 94 d6 e4 67 a8 74 f9 5a 7d d2 25 67 20
05 b2 4c d7 6d 6b 35 af 9e 0d 1c 55 cb d8 cd 88 5b 90 11 0c a1 a5
[ 1764.176270] TKIP decrypt: iv16=3D056c iv32=3D00000000
[ 1764.176272] TKIP decrypt: Phase2 rc4key=3D05 25 6c ab f3 06 1f fc 77=
 e9
35 0d 45 cc 6f 1a
[ 1764.176310] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1765.197203] TKIP decrypt: data(len=3D56) 05 25 6e 60 00 00 00 00 a5 =
36
77 4b 62 18 6d 1c ad 71 43 0e fc a4 44 d5 49 34 a3 33 c8 fb 1b e4 02 98
8a d9 a5 b9 be 06 47 98 3a 2b 1a a3 d3 cc 98 5d 5f b8 c7 3e 88 5c
[ 1765.197224] TKIP decrypt: iv16=3D056e iv32=3D00000000
[ 1765.197226] TKIP decrypt: Phase2 rc4key=3D05 25 6e 7f 89 ff 8c b9 8b=
 46
f7 c4 03 09 c7 8f
[ 1765.197263] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1766.218661] TKIP decrypt: data(len=3D56) 05 25 6f 60 00 00 00 00 17 =
40
a3 96 4c 84 8c 36 92 44 58 5a e2 db 82 7f 8b ac 41 73 d4 66 01 5c ca 91
89 21 c0 20 79 26 0d 98 b4 78 dc c2 73 9e af e8 4b e7 a7 0e fa 7b
[ 1766.218687] TKIP decrypt: iv16=3D056f iv32=3D00000000
[ 1766.218689] TKIP decrypt: Phase2 rc4key=3D05 25 6f 4c a5 63 42 34 b6=
 e9
f9 75 72 84 a0 75
[ 1766.218727] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1768.318208] wmaster0: TX to low-level driver (len=3D54) FC=3D0x0040
DUR=3D0x013a A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1768.721181] wmaster0: TX to low-level driver (len=3D130) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1773.708256] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1774.705672] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12
[ 1775.703090] wmaster0: TX to low-level driver (len=3D80) FC=3D0x4108
DUR=3D0x0102 A1=3D00:1a:92:ea:73:12 A2=3D00:15:af:03:ab:79 A3=3D00:1a:9=
2:ea:73:12


The log is full of these outputs.

I had this error more than 30 time for now, stating with the first
version of the mac80211 based rtl8187 driver.

Most times stopping the device and starting it again helps:
hauke@hauke:~$ sudo ifdown wlan0
Password:
hauke@hauke:~$ sudo ifup wlan0
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not support=
ed
WEXT auth param 5 value 0x1 - RTNETLINK answers: File exists
run-parts: /etc/network/if-up.d/avahi-autoipd exited with return code 2

But now it doesn't work so I have to restart the hole system and them i=
t
is working again.

I am using Ubuntu Feisty with vanilla kernel 2.6.23-rc3-git1 with
wpa_supplicant v0.6.0 and Wireless-Tools version 29
I want to connect to an ASUS WL-500g Premium with OpenWRT 0.9 on it.

- --
Hauke Mehrtens


Hauke Mehrtens
Westpreu=C3=9Fenweg 10
27442 Gnarrenburg
Tel.  : 04763/1745
Mobil : 0151/10778862
ICQ   : 160871207
Web   : www.hauke-m.de
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGyw1QrcX0gpXFjnsRAnJIAJ9clpAVH5MQz6BztAz9squbKaUH5gCfcoRh
GhIR6hyniEB4LSAphR1AnRs=3D
=3DZSO8
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
