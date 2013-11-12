Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51001 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3KLUGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 15:06:05 -0500
Message-ID: <52828A27.1040103@candelatech.com> (sfid-20131112_210611_272643_62580B00)
Date: Tue, 12 Nov 2013 12:05:59 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Association often fails first time when roaming with 802.11r.
References: <52828324.3060105@candelatech.com> <1384285594.14301.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1384285594.14301.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2013 11:46 AM, Johannes Berg wrote:
> On Tue, 2013-11-12 at 11:36 -0800, Ben Greear wrote:
> 
>> 1384284459.394826: sta1: Considering connect request: reassociate: 1  selected: dc:a5:f4:ff:4f:ad  bssid: dc:a5:f4:ff:4f:ad  pending: 00:00:00:00:00:00
> 
> You hacked those messages?
> 
>> 1384284459.394835: sta1: Request association: reassociate: 1  selected: dc:a5:f4:ff:4f:ad  bssid: dc:a5:f4:ff:4f:ad  pending: 00:00:00:00:00:00  wpa_state:
> 
> I don't see this one upstream.

Yes, it looks like I modified the logging a bit in this area.

> 
>> 1384284459.396010: sta1: nl80211: MLME command failed (auth): ret=-114 (Operation already in progress)
> 
> This is typically the case when you're already connected to the AP, and
> in the log above the new/old BSSID seem identical?

Ahh, you are right, I picked a bad set of logs to investigate.

A more correct roam also takes about 150ms, but at least not because of the
error in my previous email.  Seems it takes it 100+ms to go if-up after
the assoc-request is sent.  I'll go dig into that further.


1384286148.066987: sta1: Trying to associate with dc:a5:f4:ff:4f:ad (SSID='aironet1-5' freq=5180 MHz)
1384286148.066994: sta1: State: AUTHENTICATING -> ASSOCIATING
1384286148.067000: wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
1384286148.067005: netlink: Operstate: linkmode=-1, operstate=5
1384286148.067020: WPA: set own WPA/RSN IE - hexdump(len=40): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 03 00 00 01 00 73 98 4e fb 91 97 86 5c dd
46 82 be 2e 95 04 f9
1384286148.067037: nl80211: Associate (ifindex=6)
1384286148.067041:   * bssid=dc:a5:f4:ff:4f:ad
1384286148.067045:   * freq=5180
1384286148.067048:   * SSID - hexdump_ascii(len=10):
     61 69 72 6f 6e 65 74 31 2d 35                     aironet1-5
1384286148.067056:   * IEs - hexdump(len=143): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 03 00 00 01 00 73 98 4e fb 91 97 86 5c dd 46 82 be 2e 95
04 f9 36 03 6f c9 00 37 60 00 03 31 bc 1b 1e 9c 27 3b 6c d8 5e 49 a2 d9 ba 78 45 c0 64 52 0a 0a fb 28 d7 00 1e a7 c5 c6 ab 7c 35 c8 32 aa a2 c9 4c 22 26 5b 18
ab 2c b0 a1 76 54 19 69 7f 72 9c 06 c9 f6 f0 d3 e9 c1 49 e4 18 fd 35 b8 f0 83 61 e9 15 5e 85 7b 66 ef 0a 32 a8 35 01 06 50 06 04 cb a8 80 03 04 c0 a8 02 0a
1384286148.067084:   * pairwise=0xfac04
1384286148.067087:   * group=0xfac04
1384286148.067091:   * prev_bssid=dc:a5:f4:f3:ce:9d
1384286148.067112: nl80211: Association request send successfully
1384286148.068498: nl80211: Event message available
1384286148.068523: nl80211: Drv Event 36 (NL80211_CMD_REG_CHANGE) received for sta1
1384286148.068531: nl80211: Regulatory domain change
1384286148.068539: sta1: Event CHANNEL_LIST_CHANGED (31) received
1384286148.068652: nl80211: Regulatory information - country=00
1384286148.068662: nl80211: 2402-2472 @ 40 MHz
1384286148.068669: nl80211: 2457-2482 @ 40 MHz
1384286148.068675: nl80211: 2474-2494 @ 20 MHz
1384286148.068681: nl80211: 5170-5250 @ 40 MHz
1384286148.068686: nl80211: 5735-5835 @ 40 MHz
1384286148.068703: nl80211: Added 802.11b mode based on 802.11g information
1384286148.068711: P2P: Add operating class 81
1384286148.068717: P2P: Channels - hexdump(len=11): 01 02 03 04 05 06 07 08 09 0a 0b
1384286148.068725: P2P: Add operating class 115
1384286148.068730: P2P: Channels - hexdump(len=4): 24 28 2c 30
1384286148.068736: P2P: Add operating class 124
1384286148.068741: P2P: Channels - hexdump(len=4): 95 99 9d a1
1384286148.068747: P2P: Add operating class 116
1384286148.068751: P2P: Channels - hexdump(len=2): 24 2c
1384286148.068756: P2P: Add operating class 117
1384286148.068761: P2P: Channels - hexdump(len=2): 28 30
1384286148.068767: P2P: Add operating class 126
1384286148.068771: P2P: Channels - hexdump(len=2): 95 9d
1384286148.068777: P2P: Add operating class 127
1384286148.068781: P2P: Channels - hexdump(len=2): 99 a1
1384286148.068789: P2P: Update channel list
1384286148.070206: nl80211: Event message available
1384286148.070226: nl80211: Drv Event 36 (NL80211_CMD_REG_CHANGE) received for sta1
1384286148.070234: nl80211: Regulatory domain change
1384286148.070240: sta1: Event CHANNEL_LIST_CHANGED (31) received
1384286148.070348: nl80211: Regulatory information - country=US
1384286148.070359: nl80211: 2402-2472 @ 40 MHz
1384286148.070365: nl80211: 5170-5250 @ 40 MHz
1384286148.070371: nl80211: 5250-5330 @ 40 MHz
1384286148.070377: nl80211: 5490-5600 @ 40 MHz
1384286148.070383: nl80211: 5650-5710 @ 40 MHz
1384286148.070388: nl80211: 5735-5835 @ 40 MHz
1384286148.070393: nl80211: 57240-63720 @ 2160 MHz
1384286148.070411: nl80211: Added 802.11b mode based on 802.11g information
1384286148.070419: P2P: Add operating class 81
1384286148.070425: P2P: Channels - hexdump(len=11): 01 02 03 04 05 06 07 08 09 0a 0b
1384286148.070433: P2P: Add operating class 115
1384286148.070438: P2P: Channels - hexdump(len=4): 24 28 2c 30
1384286148.070443: P2P: Add operating class 124
1384286148.070448: P2P: Channels - hexdump(len=4): 95 99 9d a1
1384286148.070453: P2P: Add operating class 116
1384286148.070458: P2P: Channels - hexdump(len=2): 24 2c
1384286148.070463: P2P: Add operating class 117
1384286148.070468: P2P: Channels - hexdump(len=2): 28 30
1384286148.070473: P2P: Add operating class 126
1384286148.070478: P2P: Channels - hexdump(len=2): 95 9d
1384286148.070483: P2P: Add operating class 127
1384286148.070488: P2P: Channels - hexdump(len=2): 99 a1
1384286148.070495: P2P: Update channel list
1384286148.183963: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1384286148.183984: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1384286148.184013: nl80211: if_removed already cleared - ignore event
1384286148.185900: nl80211: Event message available
1384286148.185929: nl80211: Drv Event 38 (NL80211_CMD_ASSOCIATE) received for sta1
1384286148.185939: nl80211: MLME event 38 (NL80211_CMD_ASSOCIATE) on sta1(00:aa:aa:aa:aa:01) A1=00:aa:aa:aa:aa:01 A2=dc:a5:f4:ff:4f:ad
1384286148.185948: nl80211: MLME event frame - hexdump(len=302): 30 00 3c 00 00 aa aa aa aa 01 dc a5 f4 ff 4f ad dc a5 f4 ff 4f ad e0 cb 11 00 00 00 01 c0 01 08
8c 12 98 24 b0 48 60 6c 2d 1a ee 11 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 24 08 04 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 30 2a 01 00 00 0f ac 04 01 00 00 0f ac 04 02 00 00 0f ac 01
00 0f ac 03 28 00 01 00 73 98 4e fb 91 97 86 5c dd 46 82 be 2e 95 04 f9 36 03 6f c9 00 37 85 00 03 63 f3 17 ff 3e b2 d0 7d 9e d4 b4 34 66 bb 85 e8 c0 64 52 0a
0a fb 28 d7 00 1e a7 c5 c6 ab 7c 35 c8 32 aa a2 c9 4c 22 26 5b 18 ab 2c b0 a1 76 54 19 69 7f 72 9c 06 c9 f6 f0 d3 e9 c1 49 e4 18 fd 35 b8 f0 83 61 e9 15 5e 85
7b 66 ef 0a 32 a8 35 01 06 50 06 04 cb a8 80 03 04 c0 a8 02 0a 02 23 02 00 10 00 00 00 00 00 00 00 00 a9 45 76 93 5d a4 65 f5 58 c2 3c 17 34 cd dc 88 fc 56 cb
0c 30 c3 a0 5a
1384286148.186004: nl80211: Associate event
1384286148.186012: sta1: Event ASSOC (0) received
1384286148.186017: sta1: Association info event
1384286148.186021: resp_ies - hexdump(len=272): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a ee 11 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 3d 16 24 08 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 30 2a
01 00 00 0f ac 04 01 00 00 0f ac 04 02 00 00 0f ac 01 00 0f ac 03 28 00 01 00 73 98 4e fb 91 97 86 5c dd 46 82 be 2e 95 04 f9 36 03 6f c9 00 37 85 00 03 63 f3
17 ff 3e b2 d0 7d 9e d4 b4 34 66 bb 85 e8 c0 64 52 0a 0a fb 28 d7 00 1e a7 c5 c6 ab 7c 35 c8 32 aa a2 c9 4c 22 26 5b 18 ab 2c b0 a1 76 54 19 69 7f 72 9c 06 c9
f6 f0 d3 e9 c1 49 e4 18 fd 35 b8 f0 83 61 e9 15 5e 85 7b 66 ef 0a 32 a8 35 01 06 50 06 04 cb a8 80 03 04 c0 a8 02 0a 02 23 02 00 10 00 00 00 00 00 00 00 00 a9
45 76 93 5d a4 65 f5 58 c2 3c 17 34 cd dc 88 fc 56 cb 0c 30 c3 a0 5a
1384286148.186059: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=24): 3d 16 24 08 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1384286148.186066: WPA: RSN IE in EAPOL-Key - hexdump(len=44): 30 2a 01 00 00 0f ac 04 01 00 00 0f ac 04 02 00 00 0f ac 01 00 0f ac 03 28 00 01 00 73 98 4e fb
91 97 86 5c dd 46 82 be 2e 95 04 f9
1384286148.186075: WPA: MDIE in EAPOL-Key - hexdump(len=5): 36 03 6f c9 00
1384286148.186079: WPA: FTIE in EAPOL-Key - hexdump(len=135): 37 85 00 03 63 f3 17 ff 3e b2 d0 7d 9e d4 b4 34 66 bb 85 e8 c0 64 52 0a 0a fb 28 d7 00 1e a7 c5 c6
ab 7c 35 c8 32 aa a2 c9 4c 22 26 5b 18 ab 2c b0 a1 76 54 19 69 7f 72 9c 06 c9 f6 f0 d3 e9 c1 49 e4 18 fd 35 b8 f0 83 61 e9 15 5e 85 7b 66 ef 0a 32 a8 35 01 06
50 06 04 cb a8 80 03 04 c0 a8 02 0a 02 23 02 00 10 00 00 00 00 00 00 00 00 a9 45 76 93 5d a4 65 f5 58 c2 3c 17 34 cd dc 88 fc 56 cb 0c 30 c3 a0 5a
1384286148.186100: sta1: freq=5180 MHz
1384286148.186105: FT: Response IEs - hexdump(len=272): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a ee 11 1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 3d 16 24 08 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
30 2a 01 00 00 0f ac 04 01 00 00 0f ac 04 02 00 00 0f ac 01 00 0f ac 03 28 00 01 00 73 98 4e fb 91 97 86 5c dd 46 82 be 2e 95 04 f9 36 03 6f c9 00 37 85 00 03
63 f3 17 ff 3e b2 d0 7d 9e d4 b4 34 66 bb 85 e8 c0 64 52 0a 0a fb 28 d7 00 1e a7 c5 c6 ab 7c 35 c8 32 aa a2 c9 4c 22 26 5b 18 ab 2c b0 a1 76 54 19 69 7f 72 9c
06 c9 f6 f0 d3 e9 c1 49 e4 18 fd 35 b8 f0 83 61 e9 15 5e 85 7b 66 ef 0a 32 a8 35 01 06 50 06 04 cb a8 80 03 04 c0 a8 02 0a 02 23 02 00 10 00 00 00 00 00 00 00
00 a9 45 76 93 5d a4 65 f5 58 c2 3c 17 34 cd dc 88 fc 56 cb 0c 30 c3 a0 5a
1384286148.186145: FT: MIC data - hexdump(len=197): 00 aa aa aa aa 01 dc a5 f4 ff 4f ad 06 30 2a 01 00 00 0f ac 04 01 00 00 0f ac 04 02 00 00 0f ac 01 00 0f ac
03 28 00 01 00 73 98 4e fb 91 97 86 5c dd 46 82 be 2e 95 04 f9 36 03 6f c9 00 37 85 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0 64 52 0a 0a fb 28
d7 00 1e a7 c5 c6 ab 7c 35 c8 32 aa a2 c9 4c 22 26 5b 18 ab 2c b0 a1 76 54 19 69 7f 72 9c 06 c9 f6 f0 d3 e9 c1 49 e4 18 fd 35 b8 f0 83 61 e9 15 5e 85 7b 66 ef
0a 32 a8 35 01 06 50 06 04 cb a8 80 03 04 c0 a8 02 0a 02 23 02 00 10 00 00 00 00 00 00 00 00 a9 45 76 93 5d a4 65 f5 58 c2 3c 17 34 cd dc 88 fc 56 cb 0c 30 c3 a0 5a
1384286148.186221: FT: Received GTK in Reassoc Resp - hexdump(len=35): [REMOVED]
1384286148.186237: FT: GTK from Reassoc Resp - hexdump(len=16): [REMOVED]
1384286148.186254: wpa_driver_nl80211_set_key: ifindex=6 (sta1) alg=3 addr=0x559aee key_idx=2 set_tx=0 seq_len=6 key_len=16
1384286148.186264:    broadcast key
1384286148.190137: FT: Try to set PTK again now that we are associated
1384286148.190154: FT: Installing PTK to the driver.
1384286148.190178: wpa_driver_nl80211_set_key: ifindex=6 (sta1) alg=3 addr=0x7fff025b5840 key_idx=0 set_tx=1 seq_len=6 key_len=16
1384286148.190190:    addr=dc:a5:f4:ff:4f:ad
1384286148.190252: FT: Completed successfully
1384286148.190263: FT: Mobility domain - hexdump(len=2): 6f c9
1384286148.190266: FT: Capability and Policy: 0x00
1384286148.190270: FT: R0KH-ID - hexdump(len=4): c0 a8 02 0a
1384286148.190273: FT: R1KH-ID - hexdump(len=6): 50 06 04 cb a8 80
1384286148.190278: FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=140): 36 03 6f c9 00 37 85 00 03 63 f3 17 ff 3e b2 d0 7d 9e d4 b4 34 66
bb 85 e8 c0 64 52 0a 0a fb 28 d7 00 1e a7 c5 c6 ab 7c 35 c8 32 aa a2 c9 4c 22 26 5b 18 ab 2c b0 a1 76 54 19 69 7f 72 9c 06 c9 f6 f0 d3 e9 c1 49 e4 18 fd 35 b8
f0 83 61 e9 15 5e 85 7b 66 ef 0a 32 a8 35 01 06 50 06 04 cb a8 80 03 04 c0 a8 02 0a 02 23 02 00 10 00 00 00 00 00 00 00 00 a9 45 76 93 5d a4 65 f5 58 c2 3c 17
34 cd dc 88 fc 56 cb 0c 30 c3 a0 5a
1384286148.190303: sta1: State: ASSOCIATING -> ASSOCIATED
1384286148.190308: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1384286148.190312: netlink: Operstate: linkmode=-1, operstate=5
1384286148.190325: sta1: Associated to a new BSS: BSSID=dc:a5:f4:ff:4f:ad
1384286148.190373: sta1: Associated with dc:a5:f4:ff:4f:ad
1384286148.190384: sta1: WPA: Association event - clear replay counter
1384286148.190390: EAPOL: External notification - portValid=0
1384286148.190396: EAPOL: SUPP_PAE entering state DISCONNECTED
1384286148.190401: EAPOL: Supplicant port status: Unauthorized
1384286148.190406: nl80211: Set supplicant port unauthorized for dc:a5:f4:ff:4f:ad
1384286148.190440: EAPOL: SUPP_BE entering state INITIALIZE
1384286148.190451: EAPOL: SUPP_PAE entering state CONNECTING
1384286148.190456: EAPOL: enable timer tick
1384286148.190461: EAPOL: SUPP_BE entering state IDLE
1384286148.190470: sta1: WPA: Key negotiation completed with dc:a5:f4:ff:4f:ad [PTK=CCMP GTK=CCMP]
1384286148.190477: sta1: Cancelling authentication timeout
1384286148.190483: Removed BSSID dc:a5:f4:ff:4f:ad from blacklist
1384286148.190488: sta1: State: ASSOCIATED -> COMPLETED
1384286148.190493: sta1: CTRL-EVENT-CONNECTED - Connection to dc:a5:f4:ff:4f:ad completed [id=0 id_str=]
1384286148.190497: wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
1384286148.190501: netlink: Operstate: linkmode=-1, operstate=6
1384286148.190539: sta1: P2P: Station mode scan operation not pending anymore (sta_scan_pending=0 p2p_cb_on_scan_complete=0)
1384286148.190549: EAPOL: External notification - portValid=1
1384286148.190966: SME: FT IEs - hexdump(len=135): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 03 00 00 01 00 af 75 22 e2 29 70 0a 71 a7 ab 72 09
ea da 06 84 36 03 6f c9 00 37 58 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 48 c0 4f 44 67 ef e9 d9 4d 13 1d 26 f8 5a 1f a8 42 e1 2c 86 55 09 4f 15 d4 28 0b df 5d b1 92 c9 03 04 c0 a8 02 0a
1384286148.191430: SME: FT IEs - hexdump(len=135): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 03 00 00 01 00 af 75 22 e2 29 70 0a 71 a7 ab 72 09
ea da 06 84 36 03 6f c9 00 37 58 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 f8 15 25 72 10 15 fe 24 b6 50 d9 80 d7 dc 74 bd 8a b5 e6 94 ed fd ff de 3e 0e c4 c3 5d 5e 84 96 03 04 c0 a8 02 0a
1384286148.191458: TDLS: Remove peers on association
1384286148.191462: EAPOL: External notification - EAP success=0
1384286148.191479: EAPOL: External notification - portEnabled=1
1384286148.191484: sta1: Cancelling scan request
1384286148.191489: sta1: P2P: Station mode scan operation not pending anymore (sta_scan_pending=0 p2p_cb_on_scan_complete=0)
1384286148.191493: sta1: Cancelling authentication timeout
1384286148.191497: sta1: State: COMPLETED -> COMPLETED



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

