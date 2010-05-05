Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-us.gmx.com ([74.208.5.67]:42004 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751206Ab0EERIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 13:08:46 -0400
Date: Wed, 5 May 2010 12:01:31 -0500
From: pigiron <pigiron@gmx.com>
To: linux-wireless@vger.kernel.org
Subject: The case of the bogus SSID
Message-ID: <20100505120131.2b9f4e06@atom.pigiron.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The kind folks at linux-wireless IRC suggested that I should probably bring this ugly topic over here.

I've been digging into this problem for the last few days, and am now in need of some guidance from you wireless guru's. I hope the you folks can follow my twisted path. Here's the scenario:

SYMPTOMS:
=========

Linux clients (and apparently *only* Linux clients) cannot associate with an AP running a brand new "flavor" of DD-WRT firmware. Myself and others have reported the same problem. The response from the chief DD-WRT person was basically, "tested and works on Windows and OSX, so it must be a Linux problem".

The Wicd network manager displays strange UTF-8 type characters for the SSID. This causes it to create an incorrect WPA PSK.

Also, two ESSIDs are returned for that MAC when running the "iwlist wlan0 scan" command using many different wireless devices. So far, I've found that ipw2200 and rta2870sta seem to be the only devices that don't report an "extra" ESSID with iwlist.

Not surprisingly, I can connect to the router by manually running wpa_supplicant.

The problem still exists when running compat-wireless-2010-04-26.


Here's an example of the "iwlist wlan0 scan" output with the router in it's "default" configuration:

Cell 02 - Address: 00:25:9C:XX:XX:XX
          Channel:6
          Frequency:2.437 GHz (Channel 6)
          Quality=70/70  Signal level=-33 dBm
          Encryption key:off
     ---> ESSID:"dd-wrt"
          Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                    9 Mb/s; 12 Mb/s; 18 Mb/s
          Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
     ---> ESSID:""
          Mode:Unknown/bug
          Extra:tsf=00000064b6ade4fb
          Extra: Last beacon: 4120ms ago
          IE: Unknown: 000664642D777274
          IE: Unknown: 010882848B960C121824
          IE: Unknown: 030106
          IE: Unknown: 2A0100
          IE: Unknown: 32043048606C
          IE: Unknown: DD180050F2020101020003A4000027A4000042435E00623

          IE: Unknown: 331A4C101BFFFF000000000000000000000000000000000

          IE: Unknown: 2D1A4C101BFFFF000000000000000000000000000000000

     >>>> IE: Unknown: 34160600190000000000000000000000000000000000000

          IE: Unknown: 3D160600190000000000000000000000000000000000000

          IE: Unknown: 4A0E14000A002C01C800140005001900
          IE: Unknown: 7F0101
          IE: Unknown: DD0900037F01010000FF7F
          IE: Unknown: DD0A00037F04010000000000

PROBLEM:
========

I tried to narrow the problem by firing up the debugger against iwlist. After iwlist performs a SIOGIWSCAN, it then retreives the AP response, and this contains a second, bogus SSID (specifically a SIOCGIWESSID), with data matching one of the Information Elements above... actually two. But here's the data that I think causes the problem:

          IE: Unknown: 34160600190000000000000000000000000000000000000

Both the Wireshark scan capture and my digging into the 802.11k-2008 specification show that line as being a "Neighbor Report" Information Element (0x34 = 52 decimal = Neighbor Report).

I noticed that decimal 52 is assigned to WLAN_EID_MESH_ID in the ieee80211.h file, and recently the same 52 was also assigned to WLAN_EID_NEIGHBOR_REPORT in the same enumerated ieee80211_eid{} structure.

BUT... before I go kernel diving, I have a question. I guess I'm trying to first determine if the problem may be in the router. From my reading of the 802.11k-2008 specification, I'm thinking that a Neighbor Report should not even be inside a scan response from the AP. Every reference to "Neighbor Report" that I can find in the specification *seems* to state that a Neighbor Report response should only arrive at the STA after the AP receives a "Neighbor Report Request" frame. And it should then be contained inside a  "Neighbor Report Response" frame. Is my thinking correct???  Or am I off base (yet again ;)???


FYI: The router is configured as a simple AP acting as a gateway to a cable modem. No vlans, no hotspot, etc...  i.e. nothing "exotic". In fact, no one has yet found a configuration setting that will make this problem disappear.

OBTW: All beacon frames coming from the router also contain this Neighbor Report.

Also, here is a snippet from a scan report using iw (notice that it's not confused by the Neighbor Report):

--------------------------   BEGIN NETLINK MESSAGE ---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 312
    .nlmsg_type = 24 <0x18>
    .nlmsg_flags = 2 <MULTI>
    .nlmsg_seq = 1273073208
    .nlmsg_pid = 6127
  [PAYLOAD] 296 octets
    22 01 00 00 08 00 2e 00 c5 00 00 00 08 00 03 00 03 00 ".................
    00 00 14 01 2f 00 0a 00 01 00 00 25 9c XX XX XX 00 00 ..../......%......
    ce 00 06 00 00 06 64 64 2d 77 72 74 01 08 82 84 8b 96 ......dd-wrt......
    0c 12 18 24 03 01 06 2a 01 00 32 04 30 48 60 6c dd 18 ...$...*..2.0H`l..
    00 50 f2 02 01 01 02 00 03 a4 00 00 27 a4 00 00 42 43 .P..........'...BC
    5e 00 62 32 2f 00 33 1a 4c 10 1b ff ff 00 00 00 00 00 ^.b2/.3.L.........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a ................-.
    4c 10 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 L.................
    00 00 00 00 00 00 00 00 34 16 06 00 19 00 00 00 00 00 ........4.........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 06 00 ..............=...
    19 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ..................
    00 00 4a 0e 14 00 0a 00 2c 01 c8 00 14 00 05 00 19 00 ..J.....,.........
    7f 01 01 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 ..................
    7f 04 01 00 00 00 00 00 00 00 0c 00 03 00 10 69 af ac ...............i..
    77 00 00 00 06 00 04 00 64 00 00 00 06 00 05 00 21 04 w.......d.......!.
    00 00 08 00 02 00 85 09 00 00 08 00 0a 00 e7 11 00 00 ..................
    08 00 07 00 54 f2 ff ff                               ....T...
---------------------------  END NETLINK MESSAGE   ---------------------------
BSS 00:25:9c:XX:XX:XX (on wlan0)
        TSF: 513998285072 usec (5d, 22:46:38)
        freq: 2437
        beacon interval: 100
        capability: ESS ShortPreamble ShortSlotTime (0x0421)
        signal: -35.00 dBm
        last seen: 4583 ms ago
        SSID: dd-wrt
        Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
        DS Parameter set: channel 6
        ERP: <no flags>
        Extended supported rates: 24.0 36.0 48.0 54.0
        WMM:     * Parameter version 1
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
        Unknown IE (51): 4c 10 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        HT capabilities:
                Capabilities: 0x104c
                        HT20
                        SM Power Save disabled
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 1/2 usec (0x02)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        Unknown IE (52): 06 00 19 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        Unknown IE (61): 06 00 19 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        Unknown IE (74): 14 00 0a 00 2c 01 c8 00 14 00 05 00 19 00
        Extended capabilities: HT Information Exchange Supported
        Vendor specific: OUI 00:03:7f, data: 01 01 00 00 ff 7f
        Vendor specific: OUI 00:03:7f, data: 04 01 00 00 00 00 00
