Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:61507 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbXDIVvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 17:51:05 -0400
Message-ID: <461AB589.20405@lwfinger.net>
Date: Mon, 09 Apr 2007 16:52:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Problem with wpa_supplicant on bcm43xx-mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni,

I'm having a problem authenticating with my AP using WPA-PSK TKIP and the bcm43xx-mac80211 driver. 
The system works fine with bcm43xx-softmac - thus I know my wpa_supplicant.conf file is OK.

I have turned on full (-ddd) debugging of wpa_supplicant. In my log, I see the following sequence of 
outputs for both the good and the bad examples:

logger: State: ASSOCIATED -> 4WAY_HANDSHAKE
logger: WPA: RX message 1 of 4-Way Handshake from 00:14:bf:85:49:fa (ver=1)
logger: WPA: Renewed SNonce - hexdump(len=32): 5e ca e4 8d 31 e3 05 5b e4 1f b0 80 56 94 14 fa 51 23 
81 d6 2d a5 5f 68 3c 02 fe ef 04 56 3e 6e
logger: WPA: PMK - hexdump(len=32): [REMOVED]
logger: WPA: PTK - hexdump(len=64): [REMOVED]
logger: WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 
f2 02 01 0000 50 f2 02
logger: WPA: Sending EAPOL-Key 2/4

At this point, the two cases diverge. The bad example has a 4 second delay, then I get the following:

kernel: eth1: RX deauthentication from 00:14:bf:85:49:fa (reason=15)
kernel: eth1: deauthenticated
logger: WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 09 00 20 00 00 00 00 00 00 00 16 5e 
ca e4 8d 31 e3 05 5b e4 1f b0 80 56 94 14 fa 51 23 81 d6 2d a5 5f 68 3c 02 fe ef 04 56 3e 6e 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 09 9d 33 23 c2 dc 6b ca 26 19 5f d9 a4 1b 85 11 00 18 dd 
16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
logger: EAPOL: startWhen --> 0
logger: EAPOL: SUPP_PAE entering state CONNECTING
logger: EAPOL: txStart
logger: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
logger: RTM_NEWLINK: operstate=0 ifi_flags=0x1023 ([UP])
logger: Wireless event: cmd=0x8b15 len=24
logger: Wireless event: new AP: 00:00:00:00:00:00

 From here, the process repeats over and over without success.

With the driver that works, the output continues with:

logger: WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 09 00 20 00 00 00 00 00 00 00 0e fd 
80 70 69 ec e0 6d 0d 4b ec 66 c3 0d 8a 46 82 11 6e a8 e8 97 be 20 5a 19 4f a3 99 c5 4e 39 e4 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 fe 58 da 6c 96 95 93 66 96 d5 46 a3 e0 18 32 bd 00 18 dd 
16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
logger: RX EAPOL from 00:14:bf:85:49:fa
logger: RX EAPOL - hexdump(len=125): 01 03 00 79 fe 01 c9 00 20 00 00 00 00 00 00 00 0f 57 6f 04 92 
27 6b 80 c0 19 de 3c 7f e8 22 2b e0 ce 47 09 1e 68 fc bf 4a 1e 3d ca 4d d3 21 b3 dd 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 33 bb 6b 6a 3d 36 6a 41 32 ab d0 7a 51 a1 b5 cf 00 1a dd 18 00 50 
f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
logger: IEEE 802.1X RX: version=1 type=3 length=121

 From here if finishes the authentication and communication is established.

Do you know why the supplicant waits the 4 seconds between the "sending key 2/4" message and the 
actual transmission of it? Do you think that is important, or is it a false lead? I would appreciate 
any debugging leads you might offer.

I'm using wpa_supplicant 0.5.7 and running 2.6.21-rc5 on an openSUSE 10.2 distribution.

Thanks,

Larry
