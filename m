Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2JYOsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 10:48:13 -0400
Message-ID: <1351176524.10421.8.camel@jlt4.sipsolutions.net> (sfid-20121025_164817_584309_F6B77824)
Subject: Re: TR: Clear data transit during WPA negociation in case of
 reassociation
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?C=E9dric?= Debarge - ACKSYS
	<cedric.debarge@acksys.fr>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Date: Thu, 25 Oct 2012 16:48:44 +0200
In-Reply-To: <01e901cdb2b6$a41df0b0$ec59d210$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A31901411778@sbs2003.acksys.local>
		 (sfid-20121018_094934_139014_F8666167) <1350996238.10322.7.camel@jlt4.sipsolutions.net>
	 <01e901cdb2b6$a41df0b0$ec59d210$@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cédric,


> 	PS : the attached file is not taken from the previous test but I get it in the same way.

Thanks. It looks like a supplicant problem, since we see this in the
log:

nl80211: Associate (ifindex=5)
  * bssid=90:a4:de:aa:42:94
  * freq=5660
  * SSID - hexdump_ascii(len=6):
     63 64 74 65 73 74                                 cdtest          
...
  * pairwise=0xfac04
  * group=0xfac04
  * prev_bssid=00:1b:b1:58:f6:dd

...

FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Operating frequency changed from 5680 to 5660 MHz
nl80211: Associated on 5660 MHz
nl80211: Associated with 90:a4:de:aa:42:94

...

wlan0: Associated to a new BSS: BSSID=90:a4:de:aa:42:94

...

wlan0: WPA: Association event - clear replay counter
wlan0: WPA: Clear old PTK
...
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)
wlan0: RX EAPOL from 90:a4:de:aa:42:94
...
wlan0: Setting authentication timeout: 70 sec 0 usec
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines
wlan0: IEEE 802.1X RX: version=2 type=3 length=117
wlan0:   EAPOL-Key type=2
wlan0:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
wlan0:   key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): dd 19 32 48 51 93 fb 35 a5 24 94 dc 28 0c ab 09 c9 a1 4d fd 3d f9 4c 95 13 8b 0a 76 fb 1a 07 d6
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 dd 19 32 48 51 93 fb 35 a5 24 94 dc 28 0c ab 09 c9 a1 4d fd 3d f9 4c 95 13 8b 0a 76 fb 1a 07 d6 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 11 1c 5b ea 4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f
wlan0: State: ASSOCIATED -> 4WAY_HANDSHAKE
wlan0: WPA: RX message 1 of 4-Way Handshake from 90:a4:de:aa:42:94 (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 11 1c 5b ea 4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f
WPA: PMKID in EAPOL-Key - hexdump(len=22): dd 14 00 0f ac 04 11 1c 5b ea 4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f
RSN: PMKID from Authenticator - hexdump(len=16): 11 1c 5b ea 4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f
RSN: matched PMKID - hexdump(len=16): 11 1c 5b ea 4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f
RSN: PMK from PMKSA cache - hexdump(len=32): [REMOVED]
EAPOL: PMKSA caching was used - skip EAPOL
EAPOL: Supplicant port status: Authorized

Here it's already setting authorized, which seems wrong.

Jouni and I just talked about it and he'll have a patch for you to test,
I think.

johannes

