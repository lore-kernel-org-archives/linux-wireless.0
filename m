Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f43.google.com ([209.85.212.43]:38363 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1IKBLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Sep 2011 21:11:38 -0400
Received: by vws10 with SMTP id 10so3032628vws.2
        for <linux-wireless@vger.kernel.org>; Sat, 10 Sep 2011 18:11:37 -0700 (PDT)
Message-ID: <4E6C0AC8.9050805@coincident.com> (sfid-20110911_031142_514240_024F780B)
Date: Sat, 10 Sep 2011 21:11:36 -0400
From: "Steven A. Falco" <sfalco@coincident.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [Question] Realtek USB 0bda:8176 as AP?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am attempting to use a Realtek USB dongle as an access point on
a PC running Fedora 15, with hostapd as the user-layer SW.

The USB ID is 0bda:8176, which makes this an rtlwifi:rtl8192cu
device.

It works fine in station mode - I can connect to a WPA network.
It also works fine as an AP, but only with security disabled.
As soon as I enable WPA in the hostapd config file, I can no
longer connect.

I've logged both the hostapd and wpa_supplicant sides of the
conversation.  I'm using the same type of Realtek dongle for
both sides.

On the hostapd side, I see "sending 1/4 msg of 4-Way Handshake"

On the wpa_supplicant side, I see "RX message 1 of 4-Way Handshake"
followed by "Sending EAPOL-Key 2/4".

However, this message is not received by the hostapd side.  Instead
I see "WPA: EAPOL-Key timeout" and the association drops.

I went to the IRC group, and got the suggestion to sniff the
traffic from a third PC.  I've done that, and can make the trace
available if anyone wants to see it.  Basically, I can see the
EAPOL-Key 2/4 in Wireshark, but the packet as received on the AP
looks a bit garbled.

Here is what wireshark shows (and it decodes it as msg 2/4):

0000  00 00 1a 00 2f 48 00 00  84 c4 a2 82 00 00 00 00   ..../H.. ........
0010  10 6c 71 09 c0 00 d9 01  00 00 08 01 00 00 00 e0   .lq..... ........
0020  4c 05 d6 1f 00 e0 4c 05  de d6 00 e0 4c 05 d6 1f   L.....L. ....L...
0030  90 01 aa aa 03 00 00 00  88 8e 01 03 00 75 02 01   ........ .....u..
0040  0a 00 00 00 00 00 00 00  00 00 01 03 92 92 c7 23   ........ .......#
0050  6b 98 cb b3 05 a0 3a a3  28 4a 73 25 49 d7 2a bb   k.....:. (Js%I.*.
0060  b1 e5 0c d0 7c 4a d9 b7  af 21 bc 00 00 00 00 00   ....|J.. .!......
0070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ........ ........
0080  00 00 00 00 00 00 00 00  00 00 00 03 35 84 ee 8c   ........ ....5...
0090  17 d3 83 13 e0 40 80 ca  96 c3 6e 00 16 30 14 01   .....@.. ..n..0..
00a0  00 00 0f ac 02 01 00 00  0f ac 04 01 00 00 0f ac   ........ ........
00b0  02 00 00 95 52 78 36                               ....Rx6          

and here is what hostapd sees (but it prints EAPOL-Key timeout):

00000000: 00 00 0d 00 04 80 02 00 6c 00 00 00 00 08 02 34 
00000010: 00 00 e0 4c 05 de d6 00 e0 4c 05 d6 1f 00 e0 4c 
00000020: 05 d6 1f e0 05 aa aa 03 00 00 00 88 8e 02 03 00 
00000030: 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 3f 42 
00000040: f6 a8 72 f2 68 22 e8 f4 4f 3f 44 21 7a 82 01 34 
00000050: fb 99 dd f0 60 dc f3 28 81 7e d4 ca 6f 35 00 00 
00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

A lot of the data match up, but a lot don't.  I believe I have
synchronized the wireshark and hostapd logs, because the messages
before and after this one do match.  Also, wireshark shows four
attempts at EAPOL-Key 2/4, and hostapd shows four of these
strange frames.

Has anyone been successful with these chips in AP mode with security?

Any suggestions on things to try?  It was suggested to turn off HW
crypto, but that doesn't appear to be possible in the rtl8192cu driver,
although other rtl8192 devices do support it.

Or should I use a different chipset altogether?  Realtek Semi appears
to have helped the community, so I don't want to abandon them, but I
also need this to work. :-)

	Steve
