Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:24266 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbYCBH0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 02:26:05 -0500
Received: by rv-out-0910.google.com with SMTP id k20so3295156rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Mar 2008 23:26:05 -0800 (PST)
Message-ID: <3cc280290803012326n1a4ad659t1f964d513b4c7b17@mail.gmail.com> (sfid-20080302_072615_285954_E2948A9A)
Date: Sun, 2 Mar 2008 15:26:05 +0800
From: "far seer" <seerfar@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: strange disassociate after associate under mac80211
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, All,
Now I am developing a wireless driver under mac80211
statck(http://linuxwireless.org/).
After the associate the stack, the host send a probe package , the AP
echo a probe-resp package.
Then the mac80211 say disassociate it{wlan0: disassociate(reason=3)}.
The dmes is below, any suggestion is welcomed.

wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1d:0f:61:91:38
phy5: TX to low-level driver (len=30) FC=0x00b0 DUR=0x013a
A1=00:1d:0f:61:91:38 A2=00:11:50:26:7d:57 A3=00:1d:0f:61:91:38
agnx: skb len is 30
agnx: TX_PACKET: b0 00 3a 01 00 1d 0f 61 91 38 00 11 50 26 7d 57
..:....a.8..P&}W
agnx: TX_PACKET: 00 1d 0f 61 91 38 b0 00 00 00 01 00 00 00        ...a.8........
agnx: RX MGMT SubType: AUTH FC=0x08b0 DUR=0x013a A1=00:11:50:26:7d:57
A2=00:1d:0f:61:91:38 A3=00:1d:0f:61:91:38
wlan0: RX authentication from 00:1d:0f:61:91:38 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:1d:0f:61:91:38
phy5: TX to low-level driver (len=52) FC=0x0000 DUR=0x013a
A1=00:1d:0f:61:91:38 A2=00:11:50:26:7d:57 A3=00:1d:0f:61:91:38
agnx: skb len is 52
agnx: TX_PACKET: 00 00 3a 01 00 1d 0f 61 91 38 00 11 50 26 7d 57
..:....a.8..P&}W
agnx: TX_PACKET: 00 1d 0f 61 91 38 c0 00 21 04 01 00 00 07 54 50
...a.8..!.....TP
agnx: TX_PACKET: 2d 4c 49 4e 4b 01 08 02 04 0b 16 0c 12 18 24 32
-LINK.........$2
agnx: TX_PACKET: 03 48 60 6c                                      .H`l
agnx: Interrupt reason is 0x802
agnx: RX MGMT SubType: ASSOC_RESP FC=0x0010 DUR=0x013a
A1=00:11:50:26:7d:57 A2=00:1d:0f:61:91:38 A3=00:1d:0f:61:91:38
wlan0: RX AssocResp from 00:1d:0f:61:91:38 (capab=0x421 status=0 aid=1)
wlan0: associated
wlan0: switched to short barker preamble (BSSID=00:1d:0f:61:91:38)
phy5: Added STA 00:1d:0f:61:91:38
phy5: TX to low-level driver (len=41) FC=0x0040 DUR=0x00da
A1=00:1d:0f:61:91:38 A2=00:11:50:26:7d:57 A3=00:1d:0f:61:91:38
agnx: skb len is 41
agnx: TX_PACKET: 40 00 da 00 00 1d 0f 61 91 38 00 11 50 26 7d 57
@......a.8..P&}W
agnx: TX_PACKET: 00 1d 0f 61 91 38 d0 00 00 00 01 08 02 04 0b 16
...a.8..........
agnx: TX_PACKET: 0c 12 18 24 32 03 48 60 6c                       ...$2.H`l
agnx: Interrupt reason is 0x802
agnx: RX MGMT FC=0x0050 DUR=0x013a A1=00:11:50:26:7d:57
A2=00:1d:0f:61:91:38 A3=00:1d:0f:61:91:38
wlan0: disassociate(reason=3)
phy5: TX to low-level driver (len=26) FC=0x00a0 DUR=0x00da
A1=00:1d:0f:61:91:38 A2=00:11:50:26:7d:57 A3=00:1d:0f:61:91:38
agnx: skb len is 26
agnx: TX_PACKET: a0 00 da 00 00 1d 0f 61 91 38 00 11 50 26 7d 57
.......a.8..P&}W
agnx: TX_PACKET: 00 1d 0f 61 91 38 e0 00 03 00                    ...a.8....


Best Regards
Far
