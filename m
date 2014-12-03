Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:62086 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaLCQ6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 11:58:02 -0500
Received: by mail-qg0-f43.google.com with SMTP id q108so11220832qgd.16
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2014 08:58:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP+RiCDFPX0r82eNwoNPv=YrE3xjfAztH_VghVNa__UKzKZBQA@mail.gmail.com>
References: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com>
	<CAP+RiCDMerG_8EYi=0Ta3BvAwuWinNPYuNevjF85w08HsX4f2Q@mail.gmail.com>
	<CABPxzY+oxDH7QysFNWQg6fMWpsQDSFm5YgOusaz0KibEnH++yQ@mail.gmail.com>
	<CAP+RiCCD7EefqNKKXonrvd9T3G=+4aKZQXe0QbXBKKCzHvgAzQ@mail.gmail.com>
	<CABPxzY+Eimssqcxs0W79_5zGBHmFnrTc5+qeTnmYr_UH_9ti6A@mail.gmail.com>
	<CAP+RiCC4KmgNMGCiCzDeL_0-frGw7acoZf5FDv4OTmauQPU5Hw@mail.gmail.com>
	<1417563128.32003.8.camel@dcbw.local>
	<CAP+RiCD2vtZyVOTykKwBcm12g8mpPKc8ZBWUgFL90TU0C5ciUw@mail.gmail.com>
	<87h9xdl30j.fsf@kamboji.qca.qualcomm.com>
	<CAP+RiCCE1Z96z6+YX=Cfnb0O3vGdnZeivJH5T3XQ5DWbCbbH_w@mail.gmail.com>
	<878uipl2dl.fsf@kamboji.qca.qualcomm.com>
	<CAP+RiCDFPX0r82eNwoNPv=YrE3xjfAztH_VghVNa__UKzKZBQA@mail.gmail.com>
Date: Wed, 3 Dec 2014 10:58:01 -0600
Message-ID: <CAP+RiCC5Ck97dKaQStu07RnO9aDOLAeo25CfuMuY+VnEEb10_Q@mail.gmail.com> (sfid-20141203_175808_807541_240593FD)
Subject: Re: Laptop disassociating by local choice (reason=17)
From: Brent Taylor <motobud@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	ath6kl@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 3, 2014 at 8:05 AM, Brent Taylor <motobud@gmail.com> wrote:
> On Tue, Dec 2, 2014 at 11:37 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Brent Taylor <motobud@gmail.com> writes:
>>
>>> On Dec 2, 2014 11:24 PM, "Kalle Valo" <kvalo@qca.qualcomm.com> wrote:
>>>>
>>>> Brent Taylor <motobud@gmail.com> writes:
>>>>
>>>> >    I actually ran the wpa_supplicant with -ddddt as the parameter not
>>>> > knowing how many 'd's I could put there before I hit the limit of the
>>>> > debugging.  The wpa_supplicant on the ubuntu laptop is v0.7.3.  I'll
>>>> > change the -ddddt to just -dddt and re-run the test again.
>>>>
>>>> IMHO 0.7.3 is ancient. Please use something more recent.
>>>
>>> Ancient it may be, but why would it work with the ath9k chip and not
>>> the ath6kl chip?
>>
>> Because of a bug we are not aware of? ath6kl and ath9k are very
>> different drivers and 0.7.3 might have some problem which only comes
>> with ath6kl. Up to you, but I would not waste time testing on that old
>> wpasupplicant.
>>
>> --
>> Kalle Valo
>
> Apologies for my last reply not making it through the mailing lists, I
> sent it from my phone and it was automatically formatted in HTML and
> not Plain Text.
>
> The ultimate goal is to use an Android device to communicate with my
> custom device being the Access Point.  The laptop is easier to debug
> (at the moment) than an Android device.  I'm currently using a Samsung
> S4 running 4.4.4 and it was not able to complete the authentication
> step either.  This is when I turned to using the laptop.  Any idea
> what version of the wpa_supplicant is running on Kit Kat?
>
> -- Brent Taylor


Here is another log capture from the device and the laptop.  This time
both were using -dddt as the debug parameter to wpa_supplicant.

Laptop wpa_supplicant Log

1417624587.555713: ssid - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417624587.555788: PSK (ASCII passphrase) - hexdump_ascii(len=10):
     74 65 73 74 69 6e 67 31 32 33                     testing123
1417624587.574956: PSK (from passphrase) - hexdump(len=32): b7 9d 92
a0 21 ad 3b ce 4b 49 e6 a9 01 ea 68 7f 97 4f ab d1 d7 b5 07 eb a1 05
00 40 60 0e d2 c5
1417624587.576603: Scan SSID - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417624587.576839: nl80211: Scan SSID - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417624587.576897: nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
1417624590.197270: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00
00 0f ac 04 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 00 00
1417624590.197378: WPA: Set own WPA IE default - hexdump(len=22): 30
14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417624590.197412: FT: Stored MDIE and FTIE from (Re)Association
Response - hexdump(len=0):
1417624590.197667:   * SSID - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417624590.197697:   * IEs - hexdump(len=0): [NULL]
1417624590.209534: nl80211: MLME event frame - hexdump(len=30): b0 08
3a 01 00 27 10 75 60 28 00 03 7f be f0 a0 00 03 7f be f0 a0 c0 3d 00
00 02 00 00 00
1417624590.209614: SME: Authentication response IEs - hexdump(len=0): [NULL]
1417624590.209776: WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01
00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417624590.209853:   * SSID - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417624590.209885:   * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04
01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417624590.215806: nl80211: MLME event frame - hexdump(len=72): 10 00
3a 01 00 27 10 75 60 28 00 03 7f be f0 a0 00 03 7f be f0 a0 d0 3d 31
04 00 00 01 c0 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18
00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f
00
1417624590.215901: resp_ies - hexdump(len=42): 01 08 82 84 8b 0c 12 96
18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27
a4 00 00 42 43 5e 00 62 32 2f 00
1417624590.215950: FT: Stored MDIE and FTIE from (Re)Association
Response - hexdump(len=0):
1417624590.231601: RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00
10 00 00 00 00 00 00 00 01 6d 76 bd ac c2 ca c6 41 24 c1 45 6c fd ee
8a 64 de 79 d6 70 d4 7a 04 2a 18 1b 8f 02 ae 2f 0d 97 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1417624590.231764:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
1417624590.231785:   key_nonce - hexdump(len=32): 6d 76 bd ac c2 ca c6
41 24 c1 45 6c fd ee 8a 64 de 79 d6 70 d4 7a 04 2a 18 1b 8f 02 ae 2f
0d 97
1417624590.231814:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
1417624590.231835:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1417624590.231850:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1417624590.231865:   key_mic - hexdump(len=16): 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
1417624590.231888: WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02
00 8a 00 10 00 00 00 00 00 00 00 01 6d 76 bd ac c2 ca c6 41 24 c1 45
6c fd ee 8a 64 de 79 d6 70 d4 7a 04 2a 18 1b 8f 02 ae 2f 0d 97 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00
1417624590.232134: RSN: msg 1/4 key data - hexdump(len=0):
1417624590.233139: WPA: Renewed SNonce - hexdump(len=32): 62 cf af e9
96 cd 04 bc cf 5e 57 0d ae 0e 38 e5 77 eb 45 a3 1c c5 5a 4d e1 52 92
d4 bc 08 ac d6
1417624590.233244: WPA: PMK - hexdump(len=32): b7 9d 92 a0 21 ad 3b ce
4b 49 e6 a9 01 ea 68 7f 97 4f ab d1 d7 b5 07 eb a1 05 00 40 60 0e d2
c5
1417624590.233272: WPA: PTK - hexdump(len=48): f1 aa 93 36 37 80 84 e6
28 da 4e 22 9a 7c cd 44 1d 41 5e 4a 4f 18 be 04 04 2c c3 db 3d 3d 97
10 a6 b2 af 13 5b 47 f3 7b 30 99 22 41 fe 5a 6d 6c
1417624590.233303: WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01
00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417624590.233356: WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75
02 01 0a 00 00 00 00 00 00 00 00 00 01 62 cf af e9 96 cd 04 bc cf 5e
57 0d ae 0e 38 e5 77 eb 45 a3 1c c5 5a 4d e1 52 92 d4 bc 08 ac d6 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 ad 7b 5c bb a4 2f a4 84 dc a8 60 94 70 83 fa
ac 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02
00 00
1417624590.241579: RX EAPOL - hexdump(len=155): 02 03 00 97 02 13 ca
00 10 00 00 00 00 00 00 00 02 6d 76 bd ac c2 ca c6 41 24 c1 45 6c fd
ee 8a 64 de 79 d6 70 d4 7a 04 2a 18 1b 8f 02 ae 2f 0d 97 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 de 15 82 9a 5f 0e fa 84 12 a6 26 09 20 f3 8b 42 00 38
ab 1b 05 98 67 6c 9d d6 9a 7d a6 9a 13 30 ec 02 20 23 60 75 ba 2d f5
4c a0 0a ef b0 ae 1d 07 b0 05 5d 04 c1 fb ad 2f ab c8 17 e0 4d b9 ce
c9 4d eb ab f0 37 a7 f6 85 f4
1417624590.241742:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
1417624590.241758:   key_nonce - hexdump(len=32): 6d 76 bd ac c2 ca c6
41 24 c1 45 6c fd ee 8a 64 de 79 d6 70 d4 7a 04 2a 18 1b 8f 02 ae 2f
0d 97
1417624590.241775:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
1417624590.241786:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1417624590.241794:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1417624590.241802:   key_mic - hexdump(len=16): de 15 82 9a 5f 0e fa
84 12 a6 26 09 20 f3 8b 42
1417624590.241816: WPA: RX EAPOL-Key - hexdump(len=155): 02 03 00 97
02 13 ca 00 10 00 00 00 00 00 00 00 02 6d 76 bd ac c2 ca c6 41 24 c1
45 6c fd ee 8a 64 de 79 d6 70 d4 7a 04 2a 18 1b 8f 02 ae 2f 0d 97 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 de 15 82 9a 5f 0e fa 84 12 a6 26 09 20 f3 8b
42 00 38 ab 1b 05 98 67 6c 9d d6 9a 7d a6 9a 13 30 ec 02 20 23 60 75
ba 2d f5 4c a0 0a ef b0 ae 1d 07 b0 05 5d 04 c1 fb ad 2f ab c8 17 e0
4d b9 ce c9 4d eb ab f0 37 a7 f6 85 f4
1417624590.241885: RSN: encrypted key data - hexdump(len=56): ab 1b 05
98 67 6c 9d d6 9a 7d a6 9a 13 30 ec 02 20 23 60 75 ba 2d f5 4c a0 0a
ef b0 ae 1d 07 b0 05 5d 04 c1 fb ad 2f ab c8 17 e0 4d b9 ce c9 4d eb
ab f0 37 a7 f6 85 f4
1417624590.241969: WPA: decrypted EAPOL-Key key data -
hexdump(len=48): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f
ac 02 00 00 dd 16 00 0f ac 01 01 00 44 86 41 6d 8f 3f 09 5c 43 3e 25
55 f5 ec 4a 2f dd 00
1417624590.242044: WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00
0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 16 00 0f ac 01
01 00 44 86 41 6d 8f 3f 09 5c 43 3e 25 55 f5 ec 4a 2f dd 00
1417624590.242086: WPA: RSN IE in EAPOL-Key - hexdump(len=22): 30 14
01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417624590.242110: WPA: GTK in EAPOL-Key - hexdump(len=24): dd 16 00
0f ac 01 01 00 44 86 41 6d 8f 3f 09 5c 43 3e 25 55 f5 ec 4a 2f
1417624590.242153: WPA: RSN IE in Beacon/ProbeResp - hexdump(len=26):
30 18 01 00 00 0f ac 04 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac
02 00 00
1417624590.242184: WPA: RSN IE in 3/4 msg - hexdump(len=22): 30 14 01
00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417624590.279576: nl80211: MLME event frame - hexdump(len=26): a0 00
00 00 00 03 7f be f0 a0 00 27 10 75 60 28 00 03 7f be f0 a0 00 00 11
00
1417624590.280742: nl80211: MLME event frame - hexdump(len=26): c0 00
3a 01 00 27 10 75 60 28 00 03 7f be f0 a0 00 03 7f be f0 a0 e0 3d 11
00

Host APD Log

[linux][~> hostapd -dddt -K /etc/myapd.conf
1417603224.341394: random: Trying to read entropy from /dev/random
1417603224.341640: Configuration file: /etc/myapd.conf
1417603224.343872: nl80211: Could not add multicast membership for
vendor events: -2 (No such file or directory)
1417603224.344348: rfkill: Cannot open RFKILL control device
1417603224.344709: nl80211: RFKILL status not available
1417603224.345349: nl80211: Using driver-based roaming
1417603224.345661: nl80211: Supported cipher 00-0f-ac:1
1417603224.345973: nl80211: Supported cipher 00-0f-ac:5
1417603224.346235: nl80211: Supported cipher 00-0f-ac:2
1417603224.346514: nl80211: Supported cipher 00-0f-ac:4
1417603224.346777: nl80211: Supported cipher 00-40-96:255
1417603224.347039: nl80211: Supported cipher 00-14-72:1
1417603224.347269: nl80211: Supports Probe Response offload in AP mode
1417603224.347696: nl80211: Disable use_monitor with device_ap_sme
since no monitor mode support detected
1417603224.347975: nl80211: interface wlan0 in phy phy0
1417603224.348336: nl80211: Set mode ifindex 3 iftype 3 (AP)
1417603224.348680: nl80211: Setup AP(wlan0) - device_ap_sme=1 use_monitor=0
1417603224.349025: nl80211: Subscribe to mgmt frames with AP handle
0x11097c8 (device SME)
1417603224.349304: nl80211: Register frame type=0xd0 nl_handle=0x11097c8 match=
1417603224.349649: nl80211: Enable Probe Request reporting nl_preq=0x11088c8
1417603224.349944: nl80211: Register frame type=0x40 nl_handle=0x11088c8 match=
1417603224.350469: nl80211: Add own interface ifindex 3
1417603224.350748: nl80211: if_indices[16]: 3
1417603224.351060: phy: phy0
1417603224.351355: BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
1417603224.352094: nl80211: Regulatory information - country=00
1417603224.352373: nl80211: 2402-2472 @ 40 MHz 20 mBm
1417603224.352652: nl80211: 2457-2482 @ 40 MHz 20 mBm (no IR)
1417603224.352898: nl80211: 2474-2494 @ 20 MHz 20 mBm (no OFDM) (no IR)
1417603224.353193: nl80211: 5170-5250 @ 80 MHz 20 mBm (no IR)
1417603224.353439: nl80211: 5735-5835 @ 80 MHz 20 mBm (no IR)
1417603224.353686: nl80211: 57240-63720 @ 2160 MHz 0 mBm
1417603224.354030: nl80211: Added 802.11b mode based on 802.11g information
1417603224.354309: Allowed channel: mode=1 chan=1 freq=2412 MHz
max_tx_power=20 dBm
1417603224.354605: Allowed channel: mode=1 chan=2 freq=2417 MHz
max_tx_power=20 dBm
1417603224.354867: Allowed channel: mode=1 chan=3 freq=2422 MHz
max_tx_power=20 dBm
1417603224.354916: Allowed channel: mode=1 chan=4 freq=2427 MHz
max_tx_power=20 dBm
1417603224.354966: Allowed channel: mode=1 chan=5 freq=2432 MHz
max_tx_power=20 dBm
1417603224.354998: Allowed channel: mode=1 chan=6 freq=2437 MHz
max_tx_power=20 dBm
1417603224.355179: Allowed channel: mode=1 chan=7 freq=2442 MHz
max_tx_power=20 dBm
1417603224.355228: Allowed channel: mode=1 chan=8 freq=2447 MHz
max_tx_power=20 dBm
1417603224.355261: Allowed channel: mode=1 chan=9 freq=2452 MHz
max_tx_power=20 dBm
1417603224.355294: Allowed channel: mode=1 chan=10 freq=2457 MHz
max_tx_power=20 dBm
1417603224.355474: Allowed channel: mode=1 chan=11 freq=2462 MHz
max_tx_power=20 dBm
1417603224.355524: Allowed channel: mode=0 chan=1 freq=2412 MHz
max_tx_power=20 dBm
1417603224.355573: Allowed channel: mode=0 chan=2 freq=2417 MHz
max_tx_power=20 dBm
1417603224.355606: Allowed channel: mode=0 chan=3 freq=2422 MHz
max_tx_power=20 dBm
1417603224.355671: Allowed channel: mode=0 chan=4 freq=2427 MHz
max_tx_power=20 dBm
1417603224.355819: Allowed channel: mode=0 chan=5 freq=2432 MHz
max_tx_power=20 dBm
1417603224.355885: Allowed channel: mode=0 chan=6 freq=2437 MHz
max_tx_power=20 dBm
1417603224.355917: Allowed channel: mode=0 chan=7 freq=2442 MHz
max_tx_power=20 dBm
1417603224.355950: Allowed channel: mode=0 chan=8 freq=2447 MHz
max_tx_power=20 dBm
1417603224.356098: Allowed channel: mode=0 chan=9 freq=2452 MHz
max_tx_power=20 dBm
1417603224.356164: Allowed channel: mode=0 chan=10 freq=2457 MHz
max_tx_power=20 dBm
1417603224.356229: Allowed channel: mode=0 chan=11 freq=2462 MHz
max_tx_power=20 dBm
1417603224.356393: Completing interface initialization
1417603224.356459: Mode: IEEE 802.11b  Channel: 1  Frequency: 2412 MHz
1417603224.356656: DFS 0 channels required radar detection
1417603224.356738: nl80211: Set freq 2412 (ht_enabled=0,
vht_enabled=0, bandwidth=20 MHz, cf1=2412 MHz, cf2=0 MHz)
1417603224.356984: RATE[0] rate=10 flags=0x1
1417603224.357148: RATE[1] rate=20 flags=0x1
1417603224.357181: RATE[2] rate=55 flags=0x0
1417603224.357345: RATE[3] rate=110 flags=0x0
1417603224.357394: hostapd_setup_bss(hapd=0x1108dd8 (wlan0), first=1)
1417603224.357476: wlan0: Flushing old station entries
1417603224.357673: nl80211: flush -> DEL_STATION wlan0 (all)
1417603224.358133: wlan0: Deauthenticate all stations
1417603224.358477: nl80211: sta_remove -> DEL_STATION wlan0
ff:ff:ff:ff:ff:ff --> 0 (Success)
1417603224.358740: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
1417603224.358855: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
1417603224.359479: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
1417603224.359593: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
1417603224.359823: Using interface wlan0 with hwaddr 00:03:7f:be:f0:a0
and ssid "testssid"
1417603224.359987: Deriving WPA PSK based on passphrase
1417603224.360036: SSID - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417603224.360315: PSK (ASCII passphrase) - hexdump_ascii(len=10):
     74 65 73 74 69 6e 67 31 32 33                     testing123
1417603224.439807: PSK (from passphrase) - hexdump(len=32): b7 9d 92
a0 21 ad 3b ce 4b 49 e6 a9 01 ea 68 7f 97 4f ab d1 d7 b5 07 eb a1 05
00 40 60 0e d2 c5
1417603224.440300: random: Got 20/20 bytes from /dev/random
1417603224.440644: Get randomness: len=32 entropy=0
1417603224.443467: random from os_get_random - hexdump(len=32): ab 53
c5 45 c8 0c 8c 03 70 fb 16 52 60 a0 d0 5d fc 52 c3 b2 b4 86 d3 10 f0
e9 ec 65 23 82 07 47
1417603224.443861: random_mix_pool - hexdump(len=20): 05 2f 25 05 07
70 66 c0 6f 4e 0d 20 91 6c 24 9f c7 e6 21 bd
1417603224.444189: random from internal pool - hexdump(len=16): 2e 63
8e 56 40 38 4f 30 86 ad be 93 53 1c b0 53
1417603224.444517: random_mix_pool - hexdump(len=20): b7 bb b0 d1 fa
9b 6b cd 40 f2 58 d2 5e 38 c3 11 37 66 a2 3d
1417603224.444829: random from internal pool - hexdump(len=16): 71 9b
1a 64 08 47 d5 d6 6f d4 f6 35 84 5d 5b 82
1417603224.445141: mixed random - hexdump(len=32): 85 30 4b 13 88 34
c3 33 f6 56 a8 c1 33 bc 60 0e 8d c9 d9 d6 bc c1 06 c6 9f 3d 1a 50 a7
df 5c c5
1417603224.445436: GMK - hexdump(len=32): 85 30 4b 13 88 34 c3 33 f6
56 a8 c1 33 bc 60 0e 8d c9 d9 d6 bc c1 06 c6 9f 3d 1a 50 a7 df 5c c5
1417603224.445764: Get randomness: len=32 entropy=0
1417603224.448505: random from os_get_random - hexdump(len=32): 2e 0e
20 7f f5 62 5f 18 2f f4 dc 63 65 c3 3a c2 66 c7 93 4f fe cc 28 fd 33
de 70 e1 df d4 3c 06
1417603224.448817: random_mix_pool - hexdump(len=20): ef cb d3 6c f9
c5 74 ff 60 aa 2d 84 5c 03 83 ca 38 9e 0a 9f
1417603224.449145: random from internal pool - hexdump(len=16): bc 1e
b0 97 5d f9 46 97 4e 80 e9 de 23 d8 e5 c9
1417603224.449457: random_mix_pool - hexdump(len=20): 71 50 bd b3 96
55 f0 ed 44 8c b9 53 5d 37 5b aa 17 6b 1b f8
1417603224.449785: random from internal pool - hexdump(len=16): a2 d7
14 97 18 21 f0 9c 01 53 66 98 63 a9 69 3f
1417603224.450064: mixed random - hexdump(len=32): 92 10 90 e8 a8 9b
19 8f 61 74 35 bd 46 1b df 0b c4 10 87 d8 e6 ed d8 61 32 8d 16 79 bc
7d 55 39
1417603224.450441: Key Counter - hexdump(len=32): 1b 83 19 4f 43 9d 8f
fc fc 3b a3 fd 14 7b ab b8 98 4c 14 11 ea ad 91 70 f2 9e c7 1d cc f8
b1 60
1417603224.450737: WPA: Delay group state machine start until Beacon
frames have been configured
1417603224.451147: nl80211: Set beacon (beacon_set=0)
1417603224.451442: nl80211: Beacon head - hexdump(len=55): 80 00 00 00
ff ff ff ff ff ff 00 03 7f be f0 a0 00 03 7f be f0 a0 00 00 00 00 00
00 00 00 00 00 64 00 11 00 00 08 74 65 73 74 73 73 69 64 01 04 82 84
0b 16 03 01 01
1417603224.451787: nl80211: Beacon tail - hexdump(len=22): 30 14 01 00
00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417603224.452132: nl80211: ifindex=3
1417603224.452394: nl80211: beacon_int=100
1417603224.452640: nl80211: dtim_period=2
1417603224.452936: nl80211: ssid - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417603224.453461: nl80211: proberesp (offload) - hexdump(len=77): 50
00 00 00 00 00 00 00 00 00 00 03 7f be f0 a0 00 03 7f be f0 a0 00 00
00 00 00 00 00 00 00 00 64 00 11 00 00 08 74 65 73 74 73 73 69 64 01
04 82 84 0b 16 03 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01
00 00 0f ac 02 00 00
1417603224.453838: nl80211: hidden SSID not in use
1417603224.454084: nl80211: privacy=1
1417603224.454347: nl80211: auth_algs=0x1
1417603224.454610: nl80211: wpa_version=0x2
1417603224.454872: nl80211: key_mgmt_suites=0x2
1417603224.455135: nl80211: pairwise_ciphers=0x18
1417603224.455299: nl80211: group_cipher=0x10
1417603224.456628: WPA: Start group state machine to set initial keys
1417603224.456923: WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
1417603224.457202: Get randomness: len=16 entropy=0
1417603224.459959: random from os_get_random - hexdump(len=16): 25 1c
90 24 a9 53 e3 15 e7 f9 42 6d 11 97 77 2b
1417603224.460271: random_mix_pool - hexdump(len=20): 82 a9 1b c3 ac
6a b4 33 e4 00 5e d1 cd a6 a4 27 8d 7b cd 6d
1417603224.460747: random from internal pool - hexdump(len=16): 9f bf
3c e5 e9 1d 08 a7 74 28 3c 24 07 51 cf fe
1417603224.461042: mixed random - hexdump(len=16): ba a3 ac c1 40 4e
eb b2 93 d1 7e 49 16 c6 b8 d5
1417603224.461354: GTK - hexdump(len=16): 14 4a d4 da eb 5d bb e4 2a
b2 fb 7f d3 30 1f af
1417603224.461633: WPA: group state machine entering state SETKEYSDONE
(VLAN-ID 0)
1417603224.462388: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=3
addr=0xa305c key_idx=1 set_tx=1 seq_len=0 key_len=16
1417603224.462683: nl80211: KEY_DATA - hexdump(len=16): 14 4a d4 da eb
5d bb e4 2a b2 fb 7f d3 30 1f af
1417603224.462979:    broadcast key
1417603224.463586: nl80211: Set wlan0 operstate 0->1 (UP)
1417603224.464357: netlink: Operstate: ifindex=3 linkmode=-1 (no
change), operstate=6 (IF_OPER_UP)
1417603224.464800: Failed to set TX queue parameters for queue 0.
1417603224.465161: Failed to set TX queue parameters for queue 1.
1417603224.465539: Failed to set TX queue parameters for queue 2.
1417603224.465883: Failed to set TX queue parameters for queue 3.
1417603224.466179: wlan0: interface state UNINITIALIZED->ENABLED
1417603224.466458: wlan0: AP-ENABLED
1417603224.466704: wlan0: Setup of interface done.
1417603224.466967: ctrl_iface not configured!
1417603224.467344: nl80211: Event message available
1417603224.467656: nl80211: Drv Event 88
(NL80211_CMD_CH_SWITCH_NOTIFY) received for wlan0
1417603224.467820: nl80211: Channel switch event
1417603224.468017: wlan0: Event CH_SWITCH (41) received
1417603224.468082: 1417603224.468082: wlan0: IEEE 802.11 driver had
channel switch: freq=2412, ht=1, offset=0, width=1, cf1=2412, cf2=0

1417603247.029351: nl80211: Event message available
1417603247.029416: nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION)
received for wlan0
1417603247.029449: nl80211: New station 00:27:10:75:60:28
1417603247.029482: nl80211: Assoc Req IEs - hexdump(len=57): 00 08 74
65 73 74 73 73 69 64 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c
30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd
07 00 50 f2 02 00 01 00
1417603247.029564: wlan0: Event ASSOC (0) received
1417603247.029580: Add randomness: count=1 entropy=0
1417603247.029597: random pool - hexdump(len=128): e9 af 70 97 0f b1
a6 d7 21 48 8f af aa 47 ee ff 09 ee ee df 1e 5f 41 51 72 49 c3 98 40
61 e6 c3 f5 f9 9d 05 29 5f d3 01 63 de da 0c b7 de ad 45 73 8e 5c 69
39 d1 ed f6 cb 2c ab ed 6d e5 1d 54 33 9a f1 ee 6d c7 07 96 de c7 fb
dc 50 fd b4 2a 5f 2a 77 b4 d3 20 bb dd 51 9e fe a7 43 55 45 45 37 90
39 3c 99 60 33 b7 11 4c 02 d9 c4 50 11 4b 34 b6 fb 27 23 f1 b4 70 8f
8f 08 b0 e4 3e 3f 7c
1417603247.029745: random_mix_pool - hexdump(len=8): af e8 7e 54 9d 73 00 00
1417603247.029777: random_mix_pool - hexdump(len=6): 00 27 10 75 60 28
1417603247.029794: random pool - hexdump(len=128): e9 af 70 97 0f b1
a6 d7 21 48 8f af aa 47 ee ff 09 ee ee df 1e 5f 41 51 72 49 c3 98 40
61 e6 c3 f5 f9 9d 05 29 5f d3 01 63 de da 0c b7 de ad 45 73 8e 5c 69
39 d1 ed f6 1c 31 b4 41 94 e8 31 20 84 2f 77 83 3e 9f 20 fc 6f f8 a3
87 38 4b ba e2 7c a5 1d e7 9c 41 01 21 a8 61 1b 83 ee dd 72 b1 bf 60
b7 f5 f0 32 17 ad 9e 19 12 57 38 c4 e6 87 34 b6 fb 27 23 f1 b4 70 8f
8f 08 b0 e4 3e 3f 7c
1417603247.029958: 1417603247.029958: wlan0: STA 00:27:10:75:60:28
IEEE 802.11: associated
1417603247.030023: STA included RSN IE in (Re)AssocReq
1417603247.030056:   New STA
1417603247.030073: ap_sta_add: register ap_handle_timer timeout for
00:27:10:75:60:28 (300 seconds - ap_max_inactivity)
1417603247.030122: 1417603247.030138: wlan0: STA 00:27:10:75:60:28
WPA: event 1 notification
1417603247.030204: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=0x110b2c8 key_idx=0 set_tx=1 seq_len=0 key_len=0
1417603247.030237:    addr=00:27:10:75:60:28
1417603247.030335: IEEE 802.1X: Ignore STA - 802.1X not enabled or
forced for WPS
1417603247.030368: 1417603247.030368: wlan0: STA 00:27:10:75:60:28
WPA: start authentication
1417603247.030385: WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
1417603247.030434: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=0x110b2c8 key_idx=0 set_tx=1 seq_len=0 key_len=0
1417603247.030467:    addr=00:27:10:75:60:28
1417603247.030942: 1417603247.030942: wlan0: STA 00:27:10:75:60:28
IEEE 802.1X: unauthorizing port
1417603247.030959: WPA: 00:27:10:75:60:28 WPA_PTK_GROUP entering state IDLE
1417603247.030992: WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION
1417603247.031008: WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION2
1417603247.031025: WPA: Re-initialize GMK/Counter on first station
1417603247.031041: Get randomness: len=32 entropy=1
1417603247.033568: random from os_get_random - hexdump(len=32): b1 ee
13 91 e8 7e df db 3e 6b 9b c6 4a ce 38 db 08 9d d6 80 6a 6b 7d 3b 15
76 be be 6a 14 16 2f
1417603247.033650: random_mix_pool - hexdump(len=20): f9 af ed 36 be
42 2f 34 81 b1 d0 05 c9 8e 39 88 8e 08 25 9a
1417603247.033716: random from internal pool - hexdump(len=16): 65 46
ce a4 d2 6c cf 83 78 e8 81 73 fc 87 59 ca
1417603247.033781: random_mix_pool - hexdump(len=20): b5 43 d9 7e a0
32 4a 20 d0 ba 3a 10 be 1d 0e ef 8b 59 e9 18
1417603247.033831: random from internal pool - hexdump(len=16): fe f8
80 b0 14 bf 86 f2 e9 58 f4 4d c1 0d 82 b1
1417603247.033864: mixed random - hexdump(len=32): d4 a8 dd 35 3a 12
10 58 46 83 1a b5 b6 49 61 11 f6 65 56 30 7e d4 fb c9 fc 2e 4a f3 ab
19 94 9e
1417603247.033913: GMK - hexdump(len=32): d4 a8 dd 35 3a 12 10 58 46
83 1a b5 b6 49 61 11 f6 65 56 30 7e d4 fb c9 fc 2e 4a f3 ab 19 94 9e
1417603247.033962: Get randomness: len=32 entropy=0
1417603247.036407: random from os_get_random - hexdump(len=32): c6 6f
e4 1e 49 f0 98 0e 05 6e 12 b3 45 3d e8 55 11 f8 64 3b 00 48 c7 da 01
f6 36 42 32 b5 f8 99
1417603247.036489: random_mix_pool - hexdump(len=20): c8 d9 43 81 02
90 26 66 34 84 28 ba 0e 10 4b 6c ab 18 dc 87
1417603247.036555: random from internal pool - hexdump(len=16): 9e 12
32 69 b5 b5 a4 84 50 43 a0 22 38 07 f2 b4
1417603247.036604: random_mix_pool - hexdump(len=20): 3e cc fa 2e 40
87 ef 6e 77 3a 69 3c 10 f2 0f 09 9c 32 d2 6b
1417603247.036653: random from internal pool - hexdump(len=16): c5 f3
65 1e 9f 03 e3 d6 86 3e fd 29 58 ce c9 43
1417603247.036686: mixed random - hexdump(len=32): 58 7d d6 77 fc 45
3c 8a 55 2d b2 91 7d 3a 1a e1 d4 0b 01 25 9f 4b 24 0c 87 c8 cb 6b 6a
7b 31 da
1417603247.036768: Key Counter - hexdump(len=32): dd 56 df 47 f3 e2 47
10 dd eb 18 2c 29 84 4f 8b 38 fd ed ae 2b fb a7 65 ae cf 79 9d 32 39
65 09
1417603247.036817: Get randomness: len=16 entropy=0
1417603247.039263: random from os_get_random - hexdump(len=16): 36 48
ed df 78 f0 33 f6 98 ec 18 5b f0 86 67 9e
1417603247.039312: random_mix_pool - hexdump(len=20): ed 00 0a ac fb
02 55 df 65 a8 63 ce f1 10 a1 6b 30 d9 35 21
1417603247.039377: random from internal pool - hexdump(len=16): dc 37
b1 2f 8e 08 e7 0c 4d 1d b5 70 f1 c0 1e 0a
1417603247.039410: mixed random - hexdump(len=16): ea 7f 5c f0 f6 f8
d4 fa d5 f1 ad 2b 01 46 79 94
1417603247.039459: GTK - hexdump(len=16): 44 86 41 6d 8f 3f 09 5c 43
3e 25 55 f5 ec 4a 2f
1417603247.039525: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=3
addr=0xa305c key_idx=1 set_tx=1 seq_len=0 key_len=16
1417603247.039558: nl80211: KEY_DATA - hexdump(len=16): 44 86 41 6d 8f
3f 09 5c 43 3e 25 55 f5 ec 4a 2f
1417603247.039607:    broadcast key
1417603247.040772: Get randomness: len=32 entropy=0
1417603247.044317: random from os_get_random - hexdump(len=32): b2 18
32 0a c6 cf 61 b5 e5 dd 01 aa 1b b3 eb 12 f1 ef 0a 4e 3a 0f ce 37 ee
e5 bf 76 74 51 9b 97
1417603247.044662: random_mix_pool - hexdump(len=20): 0f dc 96 bf c1
b5 47 fa c1 22 19 77 b6 1d 03 d2 1e bd f7 8d
1417603247.045023: random from internal pool - hexdump(len=16): df 6e
8f a6 04 05 a7 f4 c1 1c 44 c6 e6 5d 61 76
1417603247.045384: random_mix_pool - hexdump(len=20): 48 be d3 0f 03
fe e9 a2 ca 52 d6 90 66 67 d7 1f 22 df 48 40
1417603247.045712: random from internal pool - hexdump(len=16): 2f 96
dc 3e ee 75 ca 1d f6 fe 30 74 da 7e 96 00
1417603247.046007: mixed random - hexdump(len=32): 6d 76 bd ac c2 ca
c6 41 24 c1 45 6c fd ee 8a 64 de 79 d6 70 d4 7a 04 2a 18 1b 8f 02 ae
2f 0d 97
1417603247.046319: WPA: Assign ANonce - hexdump(len=32): 6d 76 bd ac
c2 ca c6 41 24 c1 45 6c fd ee 8a 64 de 79 d6 70 d4 7a 04 2a 18 1b 8f
02 ae 2f 0d 97
1417603247.046631: WPA: 00:27:10:75:60:28 WPA_PTK entering state INITPSK
1417603247.046893: Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
1417603247.047156: Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
1417603247.047419: WPA: 00:27:10:75:60:28 WPA_PTK entering state PTKSTART
1417603247.047714: 1417603247.047714: wlan0: STA 00:27:10:75:60:28
WPA: sending 1/4 msg of 4-Way Handshake
1417603247.047993: WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1
install=0 pairwise=1 kde_len=0 keyidx=0 encr=0)
1417603247.048403: WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)
1417603247.048879: hostapd_new_assoc_sta: reschedule ap_handle_timer
timeout for 00:27:10:75:60:28 (300 seconds - ap_max_inactivity)
1417603247.052391: wlan0: Event EAPOL_RX (26) received
1417603247.052670: IEEE 802.1X: 121 bytes from 00:27:10:75:60:28
1417603247.052932:    IEEE 802.1X: version=1 type=3 length=117
1417603247.053211: WPA: Received EAPOL-Key from 00:27:10:75:60:28
key_info=0x10a type=2 key_data_length=22
1417603247.053523: WPA: Received Key Nonce - hexdump(len=32): 62 cf af
e9 96 cd 04 bc cf 5e 57 0d ae 0e 38 e5 77 eb 45 a3 1c c5 5a 4d e1 52
92 d4 bc 08 ac d6
1417603247.053819: WPA: Received Replay Counter - hexdump(len=8): 00
00 00 00 00 00 00 01
1417603247.054098: Add randomness: count=2 entropy=0
1417603247.054360: random pool - hexdump(len=128): 54 d1 9e c9 5f 2e
0b 37 ea 5d 7c d8 a6 6b 86 70 3e 0f f9 33 b2 b8 f8 1e f3 ef c1 49 d0
68 73 95 07 75 36 1e e0 77 18 1d a4 8a 11 62 c0 53 e8 29 dd e0 6f 08
49 c2 c8 6f c3 d5 ff b4 e0 31 8e 67 fe 1d c7 80 c6 ae 95 bf 60 2d 2c
23 b7 08 74 31 9c 4c 77 40 d1 36 a1 cf 3d 91 2b 5b 57 76 20 df 92 e4
5d 39 8f c3 28 2b 42 eb 7f 57 9e 5a da 77 0a ed bc d2 f4 43 80 4d 25
36 80 77 e6 fb 1f 4b
1417603247.054787: random_mix_pool - hexdump(len=8): af e8 7e 54 58 d4 00 00
1417603247.054967: random_mix_pool - hexdump(len=32): 62 cf af e9 96
cd 04 bc cf 5e 57 0d ae 0e 38 e5 77 eb 45 a3 1c c5 5a 4d e1 52 92 d4
bc 08 ac d6
1417603247.055148: random pool - hexdump(len=128): f2 17 95 c7 c5 10
87 3c b2 69 d2 ea f9 05 33 21 00 24 2e b5 e3 f7 86 f8 76 17 13 e3 10
2a 25 f5 47 6f de 95 b4 62 f2 58 5c b3 2a af 1c 12 6e 3f e6 ed a3 0a
67 35 31 e3 30 08 1e 3b 3f e2 d9 be 00 9d 5f cf da fa 80 f1 71 3d a7
e8 7a 89 2f a8 d3 4e 0e 75 f0 3a b8 ff 13 a5 a1 66 f3 ba b6 1c 73 95
c0 15 b8 4e 35 61 86 6e 7c 65 32 26 83 56 72 cb 2d f9 02 ae 58 f0 ab
88 ea d6 12 19 e9 fe
1417603247.055624: 1417603247.055624: wlan0: STA 00:27:10:75:60:28
WPA: received EAPOL-Key frame (2/4 Pairwise)
1417603247.055804: WPA: 00:27:10:75:60:28 WPA_PTK entering state
PTKCALCNEGOTIATING
1417603247.055853: Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
1417603247.055968: WPA: PTK derivation - A1=00:03:7f:be:f0:a0
A2=00:27:10:75:60:28
1417603247.056165: WPA: Nonce1 - hexdump(len=32): 6d 76 bd ac c2 ca c6
41 24 c1 45 6c fd ee 8a 64 de 79 d6 70 d4 7a 04 2a 18 1b 8f 02 ae 2f
0d 97
1417603247.056395: WPA: Nonce2 - hexdump(len=32): 62 cf af e9 96 cd 04
bc cf 5e 57 0d ae 0e 38 e5 77 eb 45 a3 1c c5 5a 4d e1 52 92 d4 bc 08
ac d6
1417603247.056461: WPA: PMK - hexdump(len=32): b7 9d 92 a0 21 ad 3b ce
4b 49 e6 a9 01 ea 68 7f 97 4f ab d1 d7 b5 07 eb a1 05 00 40 60 0e d2
c5
1417603247.056690: WPA: PTK - hexdump(len=48): f1 aa 93 36 37 80 84 e6
28 da 4e 22 9a 7c cd 44 1d 41 5e 4a 4f 18 be 04 04 2c c3 db 3d 3d 97
10 a6 b2 af 13 5b 47 f3 7b 30 99 22 41 fe 5a 6d 6c
1417603247.056937: WPA: 00:27:10:75:60:28 WPA_PTK entering state
PTKCALCNEGOTIATING2
1417603247.057117: WPA: 00:27:10:75:60:28 WPA_PTK entering state
PTKINITNEGOTIATING
1417603247.057330: 1417603247.057330: wlan0: STA 00:27:10:75:60:28
WPA: sending 3/4 msg of 4-Way Handshake
1417603247.057609: WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1
install=1 pairwise=1 kde_len=46 keyidx=1 encr=1)
1417603247.057790: Plaintext EAPOL-Key Key Data - hexdump(len=56): 30
14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 16
00 0f ac 01 01 00 44 86 41 6d 8f 3f 09 5c 43 3e 25 55 f5 ec 4a 2f dd
00 00 00 00 00 00 00 00 00
1417603247.058463: WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)
1417603247.062418: nl80211: Event message available
1417603247.062779: nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION)
received for wlan0
1417603247.062828: nl80211: Delete station 00:27:10:75:60:28
1417603247.063025: wlan0: Event DISASSOC (1) received
1417603247.063074: 1417603247.063074: wlan0: STA 00:27:10:75:60:28
IEEE 802.11: disassociated
1417603247.063369: 1417603247.063386: wlan0: STA 00:27:10:75:60:28
WPA: event 2 notification
1417603247.063616: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=0x110b2c8 key_idx=0 set_tx=1 seq_len=0 key_len=0
1417603247.063796:    addr=00:27:10:75:60:28
1417603247.063927: WPA: 00:27:10:75:60:28 WPA_PTK entering state DISCONNECTED
1417603247.064190: WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
1417603247.064272: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=0x110b2c8 key_idx=0 set_tx=1 seq_len=0 key_len=0
1417603247.064469:    addr=00:27:10:75:60:28
1417603247.064846: 1417603247.064846: wlan0: STA 00:27:10:75:60:28
IEEE 802.1X: unauthorizing port
1417603247.065289: nl80211: sta_remove -> DEL_STATION wlan0
00:27:10:75:60:28 --> 0 (Success)
1417603247.065536: ap_free_sta: cancel ap_handle_timer for 00:27:10:75:60:28
