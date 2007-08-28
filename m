Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.173]:65353 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbXH1QIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 12:08:19 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: mac80211 AP mode powersaving problems?
References: <1186990509.27916.38.camel@johannes.berg>
	<87lkccf30m.fsf@tikku.osso.net>
	<1187270479.5141.44.camel@johannes.berg> <87643f4kkh.fsf@nokia.com>
	<1187275344.23489.6.camel@johannes.berg> <871wdphsus.fsf@nokia.com>
	<1188290911.7837.65.camel@johannes.berg> <87absbsz5f.fsf@nokia.com>
	<1188299159.7837.96.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Tue, 28 Aug 2007 19:06:39 +0300
In-Reply-To: <1188299159.7837.96.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 28 Aug 2007 13\:05\:59 +0200")
Message-ID: <87sl63prsg.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> > In any case, I'm fairly sure the TIM is just wrong, if you have a third
>> > device you could try capturing the beacons and check that the TIM is
>> > never updated.

Ok, I finally managed to test it. Hardware was Nokia N800 and Broadcom
4318 in an x86 laptop. I used b43 from wireless-dev#everything commit
0347a7c86f8406 and hostapd from commit 62897a2a1a0e. I tested running
ping and arping from the laptop to N800.

Everything works fine when N800 has WLAN PSM disabled. When WLAN PSM
is enabled, TIM for AID is not set in beacons, just like you said.

But that's not all, also multicast frames (including ARP broadcast)
are not buffered correctly. They are sent randomly instead of directly
after a DTIM beacon. Also Multicast bit is not set and DTIM is always
zero even though DTIM period is two.

I also some really odd frames sent by b43 when N800 had PSM enabled.
Never seen it before, no idea what it is. Dump at the of this message.

Here's one beacon taken with madwifi and formatted with wireshark to
show that the TIM is not set:

No.     Time     Source                Destination           Protocol Info
    628 0.102    Belkin_f4:c2:42       Broadcast             IEEE 802.11 Beacon frame,SN=1177,FN=0,BI=100, SSID: "valo-test"

Frame 628 (245 bytes on wire, 245 bytes captured)
    Arrival Time: Aug 28, 2007 18:32:54.271060000
    [Time delta from previous captured frame: 0.080321000 seconds]
    [Time delta from previous displayed frame: 0.102410000 seconds]
    [Time since reference or first frame: 13.005208000 seconds]
    Frame Number: 628
    Frame Length: 245 bytes
    Capture Length: 245 bytes
    [Frame is marked: False]
    [Protocols in frame: prism:wlan]
Prism Monitoring Header
    Message Code: 68
    Message Length: 144
    Device: ath3
    Host Time: 0x2d9cf73 (DID 0x10044, Status 0x0, Length 0x4)
    MAC Time: 0x2f0d213a (DID 0x20044, Status 0x0, Length 0x4)
    Channel: 0x5 (DID 0x30044, Status 0x0, Length 0x4)
    RSSI: 0x3b (DID 0x40044, Status 0x0, Length 0x4)
    SQ: 0x0 (DID 0x0, Status 0x0, Length 0x0)
    Signal: 0xffffffdb (DID 0x60044, Status 0x0, Length 0x4)
    Noise: 0xffffffa0 (DID 0x70044, Status 0x0, Length 0x4)
    Data Rate: 1.0 Mb/s
    IsTX: 0x0 (DID 0x90044, Status 0x0, Length 0x4)
    Frame Length: 0x69 (DID 0xa0044, Status 0x0, Length 0x4)
IEEE 802.11
    Type/Subtype: Beacon frame (0x08)
    Frame Control: 0x0080 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 8
        Flags: 0x0
            DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Destination address: Broadcast (ff:ff:ff:ff:ff:ff)
    Source address: Belkin_f4:c2:42 (00:11:50:f4:c2:42)
    BSS Id: Belkin_f4:c2:42 (00:11:50:f4:c2:42)
    Fragment number: 0
    Sequence number: 1177
IEEE 802.11 wireless LAN management frame
    Fixed parameters (12 bytes)
        Timestamp: 0x00000000508D6189
        Beacon Interval: 0,102400 [Seconds]
        Capability Information: 0x0401
            .... .... .... ...1 = ESS capabilities: Transmitter is an AP
            .... .... .... ..0. = IBSS status: Transmitter belongs to a BSS
            .... ..0. .... 00.. = CFP participation capabilities: No point coordinator at AP (0x0000)
            .... .... ...0 .... = Privacy: AP/STA cannot support WEP
            .... .... ..0. .... = Short Preamble: Short preamble not allowed
            .... .... .0.. .... = PBCC: PBCC modulation not allowed
            .... .... 0... .... = Channel Agility: Channel agility not in use
            .... ...0 .... .... = Spectrum Management: dot11SpectrumManagementRequired FALSE
            .... .1.. .... .... = Short Slot Time: Short slot time in use
            .... 0... .... .... = Automatic Power Save Delivery: apsd not implemented
            ..0. .... .... .... = DSSS-OFDM: DSSS-OFDM modulation not allowed
            .0.. .... .... .... = Delayed Block Ack: delayed block ack not implemented
            0... .... .... .... = Immediate Block Ack: immediate block ack not implemented
    Tagged parameters (65 bytes)
        SSID parameter set: "valo-test"
            Tag Number: 0 (SSID parameter set)
            Tag length: 9
            Tag interpretation: valo-test
        Supported Rates: 1,0(B) 2,0(B) 5,5(B) 11,0(B) 6,0 9,0 12,0 18,0 
            Tag Number: 1 (Supported Rates)
            Tag length: 8
            Tag interpretation: Supported rates: 1,0(B) 2,0(B) 5,5(B) 11,0(B) 6,0 9,0 12,0 18,0  [Mbit/sec]
        DS Parameter set: Current Channel: 5
            Tag Number: 3 (DS Parameter set)
            Tag length: 1
            Tag interpretation: Current Channel: 5
        Traffic Indication Map (TIM): DTIM 0 of 2 bitmap empty
            Tag Number: 5 (Traffic Indication Map (TIM))
            TIM length: 4
            DTIM count: 0
            DTIM period: 2
            Bitmap Control: 0x00 (mcast:0, bitmap offset 0)
        ERP Information: no Non-ERP STAs, do not use protection, short or long preambles
            Tag Number: 42 (ERP Information)
            Tag length: 1
            Tag interpretation: ERP info: 0x0 (no Non-ERP STAs, do not use protection, short or long preambles)
        Extended Supported Rates: 24,0 36,0 48,0 54,0 
            Tag Number: 50 (Extended Supported Rates)
            Tag length: 4
            Tag interpretation: Supported rates: 24,0 36,0 48,0 54,0  [Mbit/sec]
        Vendor Specific: WME
            Tag Number: 221 (Vendor Specific)
            Tag length: 24
            Tag interpretation: WME PE: type 2, subtype 1, version 1, parameter set 0
            Tag interpretation: WME AC Parameters: ACI 0 (Best Effort), Admission Control not Mandatory, AIFSN 3, ECWmin 4, ECWmax 4, TXOP 0
            Tag interpretation: WME AC Parameters: ACI 1 (Background), Admission Control not Mandatory, AIFSN 7, ECWmin 4, ECWmax 4, TXOP 0
            Tag interpretation: WME AC Parameters: ACI 2 (Video), Admission Control not Mandatory, AIFSN 2, ECWmin 3, ECWmax 3, TXOP 94
            Tag interpretation: WME AC Parameters: ACI 3 (Voice), Admission Control not Mandatory, AIFSN 2, ECWmin 2, ECWmax 2, TXOP 47

0000  44 00 00 00 90 00 00 00 61 74 68 33 00 00 00 00   D.......ath3....
0010  00 00 00 00 00 00 00 00 44 00 01 00 00 00 04 00   ........D.......
0020  73 cf d9 02 44 00 02 00 00 00 04 00 3a 21 0d 2f   s...D.......:!./
0030  44 00 03 00 00 00 04 00 05 00 00 00 44 00 04 00   D...........D...
0040  00 00 04 00 3b 00 00 00 00 00 00 00 00 00 00 00   ....;...........
0050  00 00 00 00 44 00 06 00 00 00 04 00 db ff ff ff   ....D...........
0060  44 00 07 00 00 00 04 00 a0 ff ff ff 44 00 08 00   D...........D...
0070  00 00 04 00 02 00 00 00 44 00 09 00 00 00 04 00   ........D.......
0080  00 00 00 00 44 00 0a 00 00 00 04 00 69 00 00 00   ....D.......i...
0090  80 00 00 00 ff ff ff ff ff ff 00 11 50 f4 c2 42   ............P..B
00a0  00 11 50 f4 c2 42 90 49 89 61 8d 50 00 00 00 00   ..P..B.I.a.P....
00b0  64 00 01 04 00 09 76 61 6c 6f 2d 74 65 73 74 01   d.....valo-test.
00c0  08 82 84 8b 96 0c 12 18 24 03 01 05 05 04 00 02   ........$.......
00d0  00 00 2a 01 00 32 04 30 48 60 6c dd 18 00 50 f2   ..*..2.0H`l...P.
00e0  02 01 01 00 d9 03 a4 00 00 27 a4 00 00 42 43 5e   .........'...BC^
00f0  00 62 32 2f 00                                    .b2/.

And here's a dump about the odd frames I saw:

No.     Time     Source                Destination           Protocol Info
    653 0.001    Belkin_f4:c2:42       Nokia_fe:b8:19        LLC      [Packet size limited during capture]

Frame 653 (262 bytes on wire, 262 bytes captured)
    Arrival Time: Aug 28, 2007 18:32:54.601251000
    [Time delta from previous captured frame: 0.001532000 seconds]
    [Time delta from previous displayed frame: 0.001545000 seconds]
    [Time since reference or first frame: 13.335399000 seconds]
    Frame Number: 653
    Frame Length: 262 bytes
    Capture Length: 262 bytes
    [Frame is marked: False]
    [Protocols in frame: prism:wlan:llc]
Prism Monitoring Header
    Message Code: 68
    Message Length: 144
    Device: ath3
    Host Time: 0x2d9cfc6 (DID 0x10044, Status 0x0, Length 0x4)
    MAC Time: 0x2f122afb (DID 0x20044, Status 0x0, Length 0x4)
    Channel: 0x5 (DID 0x30044, Status 0x0, Length 0x4)
    RSSI: 0x3b (DID 0x40044, Status 0x0, Length 0x4)
    SQ: 0x0 (DID 0x0, Status 0x0, Length 0x0)
    Signal: 0xffffffdb (DID 0x60044, Status 0x0, Length 0x4)
    Noise: 0xffffffa0 (DID 0x70044, Status 0x0, Length 0x4)
    Data Rate: 1.0 Mb/s
    IsTX: 0x0 (DID 0x90044, Status 0x0, Length 0x4)
    Frame Length: 0x7a (DID 0xa0044, Status 0x0, Length 0x4)
IEEE 802.11
    Type/Subtype: QoS Data (0x28)
    Frame Control: 0x0A88 (Normal)
        Version: 0
        Type: Data frame (2)
        Subtype: 8
        Flags: 0xA
            DS status: Frame from DS to a STA via AP(To DS: 0 From DS: 1) (0x02)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: Nokia_fe:b8:19 (00:15:2a:fe:b8:19)
    BSS Id: Belkin_f4:c2:42 (00:11:50:f4:c2:42)
    Source address: Belkin_f4:c2:42 (00:11:50:f4:c2:42)
    Fragment number: 0
    Sequence number: 1182
    QoS Control
        Priority: 4 (Controlled Load) (Video)
        .... 0... = EOSP: Service period
        Ack Policy: Block Ack (0x03)
        Payload Type: A-MSDU
        QAP PS Buffer State: 0xd5
IEEE 802.11 Aggregate MSDU
    A-MSDU Subframe #1
        Destination address: aa:aa:03:00:00:00 (aa:aa:03:00:00:00)
        Source address: Concurre_00:00:54 (08:00:45:00:00:54)
        MSDU length: 0x0000
[Packet size limited during capture: LLC truncated]

0000  44 00 00 00 90 00 00 00 61 74 68 33 00 00 00 00   D.......ath3....
0010  00 00 00 00 00 00 00 00 44 00 01 00 00 00 04 00   ........D.......
0020  c6 cf d9 02 44 00 02 00 00 00 04 00 fb 2a 12 2f   ....D........*./
0030  44 00 03 00 00 00 04 00 05 00 00 00 44 00 04 00   D...........D...
0040  00 00 04 00 3b 00 00 00 00 00 00 00 00 00 00 00   ....;...........
0050  00 00 00 00 44 00 06 00 00 00 04 00 db ff ff ff   ....D...........
0060  44 00 07 00 00 00 04 00 a0 ff ff ff 44 00 08 00   D...........D...
0070  00 00 04 00 02 00 00 00 44 00 09 00 00 00 04 00   ........D.......
0080  00 00 00 00 44 00 0a 00 00 00 04 00 7a 00 00 00   ....D.......z...
0090  88 0a 3a 01 00 15 2a fe b8 19 00 11 50 f4 c2 42   ..:...*.....P..B
00a0  00 11 50 f4 c2 42 e0 49 fc d5 aa aa 03 00 00 00   ..P..B.I........
00b0  08 00 45 00 00 54 00 00 40 00 40 01 a3 55 c0 a8   ..E..T..@.@..U..
00c0  0b 01 c0 a8 0b 02 08 00 45 31 95 16 00 01 1d 40   ........E1.....@
00d0  d4 46 3b 2d 06 00 08 09 0a 0b 0c 0d 0e 0f 10 11   .F;-............
00e0  12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21   .............. !
00f0  22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31   "#$%&'()*+,-./01
0100  32 33 34 35 36 37                                 234567
