Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:40258 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbaLBWfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 17:35:39 -0500
Received: by mail-qa0-f54.google.com with SMTP id i13so9745631qae.27
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 14:35:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzY+Eimssqcxs0W79_5zGBHmFnrTc5+qeTnmYr_UH_9ti6A@mail.gmail.com>
References: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com>
	<CAP+RiCDMerG_8EYi=0Ta3BvAwuWinNPYuNevjF85w08HsX4f2Q@mail.gmail.com>
	<CABPxzY+oxDH7QysFNWQg6fMWpsQDSFm5YgOusaz0KibEnH++yQ@mail.gmail.com>
	<CAP+RiCCD7EefqNKKXonrvd9T3G=+4aKZQXe0QbXBKKCzHvgAzQ@mail.gmail.com>
	<CABPxzY+Eimssqcxs0W79_5zGBHmFnrTc5+qeTnmYr_UH_9ti6A@mail.gmail.com>
Date: Tue, 2 Dec 2014 16:35:37 -0600
Message-ID: <CAP+RiCC4KmgNMGCiCzDeL_0-frGw7acoZf5FDv4OTmauQPU5Hw@mail.gmail.com> (sfid-20141202_233543_020709_DFE856F0)
Subject: Re: Laptop disassociating by local choice (reason=17)
From: Brent Taylor <motobud@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2014 at 1:39 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Wed, Dec 3, 2014 at 12:48 AM, Brent Taylor <motobud@gmail.com> wrote:
>> On Mon, Dec 1, 2014 at 1:00 PM, Krishna Chaitanya
>> <chaitanya.mgit@gmail.com> wrote:
>>> On Tue, Dec 2, 2014 at 12:19 AM, Brent Taylor <motobud@gmail.com> wrote:
>>>>
>>>> On Mon, Nov 10, 2014 at 12:12 PM, Brent Taylor <motobud@gmail.com> wrote:
>>>> > Resending in plain text mode...
>>>> >
>>>> > Hi Kalle,
>>>> >    I have a custom built board with an AR6003 WiFi chip running
>>>> > linux-3.10.40 and hostapd 2.2 that I'm trying to use as an access
>>>> > point.
>>>> >
>>>> > My configuration file for hostapd is:
>>>> > interface=wlan0
>>>> > driver=nl80211
>>>> > ssid=testssid
>>>> > channel=1
>>>> > own_ip_addr=**********
>>>> > auth_algs=1
>>>> > wpa=2
>>>> > wpa_passphrase=**********
>>>> > wpa_key_mgmt=WPA-PSK
>>>> > wpa_pairwise=TKIP
>>>> > rns_pairwise=CCMP
>>>> > ignore_broadcase_ssid=1
>>>> >
>>>> > I should mention that this configuration works with a USB WiFi stick
>>>> > with an ath9k chipset running the same linux kernel and hostapd
>>>> > binary.
>>>> >
>>>> > When using the AR6003 chipset the client Laptop (HP EliteBook 8440p
>>>> > running ubuntu 12.04.3 LTS) does not connect and prints the message:
>>>> > wlan0: disassociating from <device mac> by local choice (reason=17)
>>>> >
>>>> > Running Wireshark on the Laptop, I see "Key (msg 1/4)", "Key (msg
>>>> > 2/4)", and then "Key (msg 3/4)" before it tries to reauthenticate.
>>>> >
>>>> > On the access point device, I see the logs from WAP that message 3/4
>>>> > was sent and the next message received is NL80211_CMD_DEL_STATION.
>>>> >
>>>> > I've searched online for the reason=17 and haven't come across an
>>>> > answer yet.  The access point device is not connected to a computer
>>>> > that is connected to the internet, so while getting log files is
>>>> > possible, it 's just not the easiest thing to do.  If requested, I
>>>> > could get a log dump from hostapd and/or debug output from the ath6kl
>>>> > driver.
>>>> >
>>>> > Thanks for any help
>>>> > Brent Taylor
>>>>
>>>>
>>>> Does anyone know where the "reason=17" comes from?  I traced it down
>>>> in the kernel and it looks like it comes from the WIFI Chip in the
>>>> Laptop, but I can not find what it means.
>>>>
>>>> Is there more information from somewhere that I provide to get some
>>>> help with this?
>>>>
>>>> Thanks,
>>>> Brent
>>>
>>>
>>> Reason code 17 means:
>>> element in 4-Way Handshake different from (Re)Association
>>> Request/Probe Response/Beacon frame.
>>>
>>> When the MSG 3/4 is received hostapd valdiates the IE stored from the
>>> beacon/probe and if mismatch it issues deauth with reason code 17.
>>>
>>> wpa_supplicant_process_3_of_4: wpa_supplicant_validate_ie in
>>> hostapd/src/rsn_supp/wpa.c
>>> Sniffer capture and hostapd logs might help to try to understand what
>>> is mismatched.
>>

-- snip old log information --

Laptop wpa_supplicant log:

1417557226.372027: Scan SSID - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417557226.372135: nl80211: Scan SSID - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417557226.372166: nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
1417557228.979261: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00
00 0f ac 04 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 00 00
1417557228.979342: WPA: Set own WPA IE default - hexdump(len=22): 30
14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417557228.979370: FT: Stored MDIE and FTIE from (Re)Association
Response - hexdump(len=0):
1417557228.979845:   * SSID - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417557228.979880:   * IEs - hexdump(len=0): [NULL]
1417557228.991852: nl80211: MLME event frame - hexdump(len=30): b0 08
3a 01 00 27 10 75 60 28 00 03 7f be f0 a0 00 03 7f be f0 a0 f0 38 00
00 02 00 00 00
1417557228.991905: SME: Authentication response IEs - hexdump(len=0): [NULL]
1417557228.992083: WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01
00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417557228.992159:   * SSID - hexdump_ascii(len=8):
     74 65 73 74 73 73 69 64                           testssid
1417557228.992195:   * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04
01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417557228.998296: nl80211: MLME event frame - hexdump(len=72): 30 00
3a 01 00 27 10 75 60 28 00 03 7f be f0 a0 00 03 7f be f0 a0 00 39 31
04 00 00 01 c0 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18
00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f
00
1417557228.998395: resp_ies - hexdump(len=42): 01 08 82 84 8b 0c 12 96
18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27
a4 00 00 42 43 5e 00 62 32 2f 00
1417557228.998452: FT: Stored MDIE and FTIE from (Re)Association
Response - hexdump(len=0):
1417557229.333000: RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00
10 00 00 00 00 00 00 00 01 d2 40 cc 74 27 24 e2 79 6f bd f7 82 db 6f
73 62 22 a9 cf 3f 85 21 4d 9f 40 5e 4a 5a af 45 2d e3 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1417557229.333182:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
1417557229.333203:   key_nonce - hexdump(len=32): d2 40 cc 74 27 24 e2
79 6f bd f7 82 db 6f 73 62 22 a9 cf 3f 85 21 4d 9f 40 5e 4a 5a af 45
2d e3
1417557229.333233:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
1417557229.333253:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1417557229.333268:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1417557229.333282:   key_mic - hexdump(len=16): 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
1417557229.333304: WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02
00 8a 00 10 00 00 00 00 00 00 00 01 d2 40 cc 74 27 24 e2 79 6f bd f7
82 db 6f 73 62 22 a9 cf 3f 85 21 4d 9f 40 5e 4a 5a af 45 2d e3 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00
1417557229.333506: RSN: msg 1/4 key data - hexdump(len=0):
1417557229.334841: WPA: Renewed SNonce - hexdump(len=32): 74 40 89 6b
ab de 2b 76 ef 09 1a 37 18 59 7b fa 4a 7e b1 f5 83 59 e5 f7 17 f1 80
11 7a e4 ae 6d
1417557229.334958: WPA: PMK - hexdump(len=32): b7 9d 92 a0 21 ad 3b ce
4b 49 e6 a9 01 ea 68 7f 97 4f ab d1 d7 b5 07 eb a1 05 00 40 60 0e d2
c5
1417557229.334992: WPA: PTK - hexdump(len=48): 27 51 b0 5b 2c 0a fa 68
f2 e1 e9 2c de 95 96 e4 1c 2c 9a a0 e3 b6 21 6f 48 e4 83 53 ff 4d 68
f9 cb e7 2f c3 91 2d 7a 48 28 cd fa 52 c8 8c ff b6
1417557229.335031: WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01
00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417557229.335081: WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75
02 01 0a 00 00 00 00 00 00 00 00 00 01 74 40 89 6b ab de 2b 76 ef 09
1a 37 18 59 7b fa 4a 7e b1 f5 83 59 e5 f7 17 f1 80 11 7a e4 ae 6d 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 8b c7 41 7f 25 45 ed 64 9c 15 d7 25 32 50 30
85 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02
00 00
1417557229.338749: RX EAPOL - hexdump(len=155): 02 03 00 97 02 13 ca
00 10 00 00 00 00 00 00 00 02 d2 40 cc 74 27 24 e2 79 6f bd f7 82 db
6f 73 62 22 a9 cf 3f 85 21 4d 9f 40 5e 4a 5a af 45 2d e3 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 1d 01 37 5e 02 5d af 50 4b 48 87 d8 86 85 43 0f 00 38
72 53 14 63 c6 fd 9b 69 55 dd c0 4c fa 54 e7 e0 26 b2 9a 17 52 d2 c0
2c a6 89 eb 69 3e 7c a2 2f ba 47 72 09 7f 57 9f d1 82 38 ec 4c 42 1b
e8 cc b4 a8 d9 a2 0f d9 7a cc
1417557229.338934:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
1417557229.338944:   key_nonce - hexdump(len=32): d2 40 cc 74 27 24 e2
79 6f bd f7 82 db 6f 73 62 22 a9 cf 3f 85 21 4d 9f 40 5e 4a 5a af 45
2d e3
1417557229.338955:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
1417557229.338962:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1417557229.338967:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1417557229.338973:   key_mic - hexdump(len=16): 1d 01 37 5e 02 5d af
50 4b 48 87 d8 86 85 43 0f
1417557229.338983: WPA: RX EAPOL-Key - hexdump(len=155): 02 03 00 97
02 13 ca 00 10 00 00 00 00 00 00 00 02 d2 40 cc 74 27 24 e2 79 6f bd
f7 82 db 6f 73 62 22 a9 cf 3f 85 21 4d 9f 40 5e 4a 5a af 45 2d e3 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 1d 01 37 5e 02 5d af 50 4b 48 87 d8 86 85 43
0f 00 38 72 53 14 63 c6 fd 9b 69 55 dd c0 4c fa 54 e7 e0 26 b2 9a 17
52 d2 c0 2c a6 89 eb 69 3e 7c a2 2f ba 47 72 09 7f 57 9f d1 82 38 ec
4c 42 1b e8 cc b4 a8 d9 a2 0f d9 7a cc
1417557229.339056: RSN: encrypted key data - hexdump(len=56): 72 53 14
63 c6 fd 9b 69 55 dd c0 4c fa 54 e7 e0 26 b2 9a 17 52 d2 c0 2c a6 89
eb 69 3e 7c a2 2f ba 47 72 09 7f 57 9f d1 82 38 ec 4c 42 1b e8 cc b4
a8 d9 a2 0f d9 7a cc
1417557229.339095: WPA: decrypted EAPOL-Key key data -
hexdump(len=48): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f
ac 02 00 00 dd 16 00 0f ac 01 02 00 4f 1d 5e 07 73 b9 a8 28 2e c4 33
17 51 6a a7 2b dd 00
1417557229.339128: WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00
0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 16 00 0f ac 01
02 00 4f 1d 5e 07 73 b9 a8 28 2e c4 33 17 51 6a a7 2b dd 00
1417557229.339147: WPA: RSN IE in EAPOL-Key - hexdump(len=22): 30 14
01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417557229.339157: WPA: GTK in EAPOL-Key - hexdump(len=24): dd 16 00
0f ac 01 02 00 4f 1d 5e 07 73 b9 a8 28 2e c4 33 17 51 6a a7 2b
1417557229.339179: WPA: RSN IE in Beacon/ProbeResp - hexdump(len=26):
30 18 01 00 00 0f ac 04 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac
02 00 00
1417557229.339192: WPA: RSN IE in 3/4 msg - hexdump(len=22): 30 14 01
00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1417557229.388018: nl80211: MLME event frame - hexdump(len=26): a0 00
00 00 00 03 7f be f0 a0 00 27 10 75 60 28 00 03 7f be f0 a0 00 00 11
00
1417557229.389152: nl80211: MLME event frame - hexdump(len=26): c0 00
3a 01 00 27 10 75 60 28 00 03 7f be f0 a0 00 03 7f be f0 a0 50 39 11
00


Device Host APD 2.2 Log:

1417535885.275867: nl80211: Event message available
1417535885.275965: nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION)
received for wlan0
1417535885.275998: nl80211: New station 00:27:10:75:60:28
1417535885.276014: nl80211: Assoc Req IEs - hexdump(len=57): 00 08 74
65 73 74 73 73 69 64 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c
30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd
07 00 50 f2 02 00 01 00
1417535885.276113: wlan0: Event ASSOC (0) received
1417535885.276129: Add randomness: count=71 entropy=1
1417535885.276145: random pool - hexdump(len=128): 9a 14 47 7a e2 b2
dd b5 23 ab c0 71 69 25 c0 c7 e0 98 6d 40 58 75 55 3a 69 f1 1b 46 fe
96 04 d4 f9 b4 9d 66 c2 5d 2f 56 3f a3 61 3b 78 d9 4a b1 58 46 de af
d9 13 f5 f9 dd ba 02 e3 4c 48 31 34 b6 2f 83 7c 0b e3 f4 20 3e 41 6c
3d 09 ce 3d 42 f1 f4 00 8a 57 c5 6c 0e 3f 72 e1 6b dd 07 a5 46 2d 79
29 c5 10 a0 a7 03 26 77 94 cb 1c 7b 97 09 c4 a6 84 f1 ae 36 0d 38 5f
96 c5 ae c5 e9 41 f5
1417535885.276293: random_mix_pool - hexdump(len=8): 8d e1 7d 54 b1 36 04 00
1417535885.276326: random_mix_pool - hexdump(len=6): 00 27 10 75 60 28
1417535885.276342: random pool - hexdump(len=128): 9a 14 47 7a e2 b2
dd b5 23 ab c0 71 69 25 c0 c7 e0 98 6d 40 58 75 55 3a 69 f1 1b 46 fe
96 04 d4 f9 b4 9d 66 c2 5d 2f 56 3f a3 61 3b 78 d9 4a b1 58 46 de af
d9 13 f5 f9 e5 05 a3 26 bb 0e b2 ff 29 18 b2 37 23 af 73 26 98 cf 6e
d8 7c 58 4a a8 2d 02 0c a0 39 24 00 14 bc 72 35 fa 1c ea 0c e8 2f 96
28 6e 1c db 67 73 c6 2b 18 38 60 77 68 6a c4 a6 84 f1 ae 36 0d 38 5f
96 c5 ae c5 e9 41 f5
1417535885.276490: 1417535885.276507: wlan0: STA 00:27:10:75:60:28
IEEE 802.11: associated
1417535885.276572: STA included RSN IE in (Re)AssocReq
1417535885.276589:   New STA
1417535885.276605: ap_sta_add: register ap_handle_timer timeout for
00:27:10:75:60:28 (300 seconds - ap_max_inactivity)
1417535885.276671: 1417535885.276671: wlan0: STA 00:27:10:75:60:28
WPA: event 1 notification
1417535885.276736: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=0x13e72c8 key_idx=0 set_tx=1 seq_len=0 key_len=0
1417535885.276785:    addr=00:27:10:75:60:28
1417535885.276868: IEEE 802.1X: Ignore STA - 802.1X not enabled or
forced for WPS
1417535885.276900: 1417535885.276900: wlan0: STA 00:27:10:75:60:28
WPA: start authentication
1417535885.276917: WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
1417535885.276966: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=0x13e72c8 key_idx=0 set_tx=1 seq_len=0 key_len=0
1417535885.276999:    addr=00:27:10:75:60:28
1417535885.277508: 1417535885.277508: wlan0: STA 00:27:10:75:60:28
IEEE 802.1X: unauthorizing port
1417535885.277540: WPA: 00:27:10:75:60:28 WPA_PTK_GROUP entering state IDLE
1417535885.277557: WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION
1417535885.277573: WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION2
1417535885.277590: Get randomness: len=32 entropy=2
1417535885.280084: random from os_get_random - hexdump(len=32): b1 b2
5c 9b 30 5c 2b e8 d1 92 91 1e a8 62 f0 3c b4 ed 46 04 9d 50 c8 47 41
99 28 23 76 3f ec d4
1417535885.280199: random_mix_pool - hexdump(len=20): 0c 08 62 e3 5a
21 11 c8 66 98 5c 80 ca ab 4f a7 7c 35 a1 e4
1417535885.280264: random from internal pool - hexdump(len=16): 63 f2
90 ef 17 78 c9 91 be 2f 66 9c 73 0d 83 5e
1417535885.280314: random_mix_pool - hexdump(len=20): 44 55 9e 91 da
10 1e e7 e3 af 87 8a b8 7d 52 49 0d 32 56 41
1417535885.280379: random from internal pool - hexdump(len=16): 96 44
89 3b 18 71 85 d8 01 c7 62 79 d9 7a c1 37
1417535885.280412: mixed random - hexdump(len=32): d2 40 cc 74 27 24
e2 79 6f bd f7 82 db 6f 73 62 22 a9 cf 3f 85 21 4d 9f 40 5e 4a 5a af
45 2d e3
1417535885.280445: WPA: Assign ANonce - hexdump(len=32): d2 40 cc 74
27 24 e2 79 6f bd f7 82 db 6f 73 62 22 a9 cf 3f 85 21 4d 9f 40 5e 4a
5a af 45 2d e3
1417535885.280511: WPA: 00:27:10:75:60:28 WPA_PTK entering state INITPSK
1417535885.280527: Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
1417535885.280543: Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
1417535885.280560: WPA: 00:27:10:75:60:28 WPA_PTK entering state PTKSTART
1417535885.280593: 1417535885.280593: wlan0: STA 00:27:10:75:60:28
WPA: sending 1/4 msg of 4-Way Handshake
1417535885.614101: WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1
install=0 pairwise=1 kde_len=0 keyidx=0 encr=0)
1417535885.614200: WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)
1417535885.614249: hostapd_new_assoc_sta: reschedule ap_handle_timer
timeout for 00:27:10:75:60:28 (300 seconds - ap_max_inactivity)
1417535885.618942: wlan0: Event EAPOL_RX (26) received
1417535885.618991: IEEE 802.1X: 121 bytes from 00:27:10:75:60:28
1417535885.619008:    IEEE 802.1X: version=1 type=3 length=117
1417535885.619024: WPA: Received EAPOL-Key from 00:27:10:75:60:28
key_info=0x10a type=2 key_data_length=22
1417535885.619057: WPA: Received Key Nonce - hexdump(len=32): 74 40 89
6b ab de 2b 76 ef 09 1a 37 18 59 7b fa 4a 7e b1 f5 83 59 e5 f7 17 f1
80 11 7a e4 ae 6d
1417535885.619106: WPA: Received Replay Counter - hexdump(len=8): 00
00 00 00 00 00 00 01
1417535885.619123: Add randomness: count=72 entropy=0
1417535885.619139: random pool - hexdump(len=128): 25 b7 50 e6 d2 21
13 5f 80 58 9d 5b c7 65 36 43 94 3c f4 8f 51 7f 20 b4 49 e2 9d 03 15
0e 0c 6e b8 72 d2 4b cf 72 1d 49 03 42 02 29 fe 9d 82 17 96 6c a6 68
b6 dd 90 13 cd e9 7c 37 c0 46 7c 84 b4 b6 00 6f c6 f5 9e b4 83 38 d0
8a 0f a5 e6 15 1a 71 bf ed fd 59 0c 72 fd bc 40 4e ff 7b 4c 45 1a 53
f8 66 ad c2 15 13 2f 51 3a a9 b6 24 91 05 a4 fc 48 41 42 8e 8c d2 30
dd 1e 13 63 f9 1e 91
1417535885.619287: random_mix_pool - hexdump(len=8): 8d e1 7d 54 83 72 09 00
1417535885.619320: random_mix_pool - hexdump(len=32): 74 40 89 6b ab
de 2b 76 ef 09 1a 37 18 59 7b fa 4a 7e b1 f5 83 59 e5 f7 17 f1 80 11
7a e4 ae 6d
1417535885.619369: random pool - hexdump(len=128): cd 8a 90 a8 9f 92
16 61 d4 00 7e 37 4a 0b d6 2a e0 72 24 b1 4e bf 9d 0e 31 9e 59 67 53
39 7f 5f 7a c0 27 28 c9 68 84 0d 0e 0e e4 54 82 28 df 17 4c 1b 24 83
d9 38 6a ef 6a cd f8 45 f8 6f b6 b4 3e 13 7c 76 4c 09 a1 6e 75 de ea
05 52 86 27 bf bc dc d6 26 95 de de 14 93 bb 02 af 92 e4 5b b7 3c 41
36 00 cc a8 9f 7a df 94 a9 12 21 d2 09 a4 61 ce ac 52 90 21 ce b5 4d
8e 5c e4 d2 93 aa 32
1417535885.619549: 1417535885.619549: wlan0: STA 00:27:10:75:60:28
WPA: received EAPOL-Key frame (2/4 Pairwise)
1417535885.619566: WPA: 00:27:10:75:60:28 WPA_PTK entering state
PTKCALCNEGOTIATING
1417535885.619599: Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
1417535885.619697: WPA: PTK derivation - A1=00:03:7f:be:f0:a0
A2=00:27:10:75:60:28
1417535885.619713: WPA: Nonce1 - hexdump(len=32): d2 40 cc 74 27 24 e2
79 6f bd f7 82 db 6f 73 62 22 a9 cf 3f 85 21 4d 9f 40 5e 4a 5a af 45
2d e3
1417535885.619763: WPA: Nonce2 - hexdump(len=32): 74 40 89 6b ab de 2b
76 ef 09 1a 37 18 59 7b fa 4a 7e b1 f5 83 59 e5 f7 17 f1 80 11 7a e4
ae 6d
1417535885.619812: WPA: PMK - hexdump(len=32): b7 9d 92 a0 21 ad 3b ce
4b 49 e6 a9 01 ea 68 7f 97 4f ab d1 d7 b5 07 eb a1 05 00 40 60 0e d2
c5
1417535885.619861: WPA: PTK - hexdump(len=48): 27 51 b0 5b 2c 0a fa 68
f2 e1 e9 2c de 95 96 e4 1c 2c 9a a0 e3 b6 21 6f 48 e4 83 53 ff 4d 68
f9 cb e7 2f c3 91 2d 7a 48 28 cd fa 52 c8 8c ff b6
1417535885.619943: WPA: 00:27:10:75:60:28 WPA_PTK entering state
PTKCALCNEGOTIATING2
1417535885.619976: WPA: 00:27:10:75:60:28 WPA_PTK entering state
PTKINITNEGOTIATING
1417535885.620157: 1417535885.620157: wlan0: STA 00:27:10:75:60:28
WPA: sending 3/4 msg of 4-Way Handshake
1417535885.620189: WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1
install=1 pairwise=1 kde_len=46 keyidx=2 encr=1)
1417535885.620222: Plaintext EAPOL-Key Key Data - hexdump(len=56): 30
14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 16
00 0f ac 01 02 00 4f 1d 5e 07 73 b9 a8 28 2e c4 33 17 51 6a a7 2b dd
00 00 00 00 00 00 00 00 00
1417535885.620452: WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)
1417535885.626113: nl80211: Event message available
1417535885.626245: nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION)
received for wlan0
1417535885.626261: nl80211: Delete station 00:27:10:75:60:28
1417535885.626294: wlan0: Event DISASSOC (1) received
1417535885.959802: 1417535885.959802: wlan0: STA 00:27:10:75:60:28
IEEE 802.11: disassociated
1417535885.960065: 1417535885.960065: wlan0: STA 00:27:10:75:60:28
WPA: event 2 notification
1417535885.960131: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=0x13e72c8 key_idx=0 set_tx=1 seq_len=0 key_len=0
1417535885.960163:    addr=00:27:10:75:60:28
1417535885.960245: WPA: 00:27:10:75:60:28 WPA_PTK entering state DISCONNECTED
1417535885.960262: WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
1417535885.960311: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0
addr=0x13e72c8 key_idx=0 set_tx=1 seq_len=0 key_len=0
1417535885.960344:    addr=00:27:10:75:60:28
1417535885.960639: 1417535885.960639: wlan0: STA 00:27:10:75:60:28
IEEE 802.1X: unauthorizing port
1417535885.960803: nl80211: sta_remove -> DEL_STATION wlan0
00:27:10:75:60:28 --> 0 (Success)
1417535885.960918: ap_free_sta: cancel ap_handle_timer for 00:27:10:75:60:28

Thank you for looking into this.  I'm not familiar with the details of
the wpa_supplicant or the authentication handshake of a WPA WiFi link.

-- Brent
