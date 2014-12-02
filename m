Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39160 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933642AbaLBTjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 14:39:32 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so29142931wiv.12
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 11:39:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP+RiCCD7EefqNKKXonrvd9T3G=+4aKZQXe0QbXBKKCzHvgAzQ@mail.gmail.com>
References: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com>
 <CAP+RiCDMerG_8EYi=0Ta3BvAwuWinNPYuNevjF85w08HsX4f2Q@mail.gmail.com>
 <CABPxzY+oxDH7QysFNWQg6fMWpsQDSFm5YgOusaz0KibEnH++yQ@mail.gmail.com> <CAP+RiCCD7EefqNKKXonrvd9T3G=+4aKZQXe0QbXBKKCzHvgAzQ@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 3 Dec 2014 01:09:10 +0530
Message-ID: <CABPxzY+Eimssqcxs0W79_5zGBHmFnrTc5+qeTnmYr_UH_9ti6A@mail.gmail.com> (sfid-20141202_203947_169443_5272DF12)
Subject: Re: Laptop disassociating by local choice (reason=17)
To: Brent Taylor <motobud@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 3, 2014 at 12:48 AM, Brent Taylor <motobud@gmail.com> wrote:
> On Mon, Dec 1, 2014 at 1:00 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> On Tue, Dec 2, 2014 at 12:19 AM, Brent Taylor <motobud@gmail.com> wrote:
>>>
>>> On Mon, Nov 10, 2014 at 12:12 PM, Brent Taylor <motobud@gmail.com> wrote:
>>> > Resending in plain text mode...
>>> >
>>> > Hi Kalle,
>>> >    I have a custom built board with an AR6003 WiFi chip running
>>> > linux-3.10.40 and hostapd 2.2 that I'm trying to use as an access
>>> > point.
>>> >
>>> > My configuration file for hostapd is:
>>> > interface=wlan0
>>> > driver=nl80211
>>> > ssid=testssid
>>> > channel=1
>>> > own_ip_addr=**********
>>> > auth_algs=1
>>> > wpa=2
>>> > wpa_passphrase=**********
>>> > wpa_key_mgmt=WPA-PSK
>>> > wpa_pairwise=TKIP
>>> > rns_pairwise=CCMP
>>> > ignore_broadcase_ssid=1
>>> >
>>> > I should mention that this configuration works with a USB WiFi stick
>>> > with an ath9k chipset running the same linux kernel and hostapd
>>> > binary.
>>> >
>>> > When using the AR6003 chipset the client Laptop (HP EliteBook 8440p
>>> > running ubuntu 12.04.3 LTS) does not connect and prints the message:
>>> > wlan0: disassociating from <device mac> by local choice (reason=17)
>>> >
>>> > Running Wireshark on the Laptop, I see "Key (msg 1/4)", "Key (msg
>>> > 2/4)", and then "Key (msg 3/4)" before it tries to reauthenticate.
>>> >
>>> > On the access point device, I see the logs from WAP that message 3/4
>>> > was sent and the next message received is NL80211_CMD_DEL_STATION.
>>> >
>>> > I've searched online for the reason=17 and haven't come across an
>>> > answer yet.  The access point device is not connected to a computer
>>> > that is connected to the internet, so while getting log files is
>>> > possible, it 's just not the easiest thing to do.  If requested, I
>>> > could get a log dump from hostapd and/or debug output from the ath6kl
>>> > driver.
>>> >
>>> > Thanks for any help
>>> > Brent Taylor
>>>
>>>
>>> Does anyone know where the "reason=17" comes from?  I traced it down
>>> in the kernel and it looks like it comes from the WIFI Chip in the
>>> Laptop, but I can not find what it means.
>>>
>>> Is there more information from somewhere that I provide to get some
>>> help with this?
>>>
>>> Thanks,
>>> Brent
>>
>>
>> Reason code 17 means:
>> element in 4-Way Handshake different from (Re)Association
>> Request/Probe Response/Beacon frame.
>>
>> When the MSG 3/4 is received hostapd valdiates the IE stored from the
>> beacon/probe and if mismatch it issues deauth with reason code 17.
>>
>> wpa_supplicant_process_3_of_4: wpa_supplicant_validate_ie in
>> hostapd/src/rsn_supp/wpa.c
>> Sniffer capture and hostapd logs might help to try to understand what
>> is mismatched.
>
> Thanks for the explanation, here is a capture from hostapd-2.2
>
> [linux][~> hostapd -dddd  /etc/myapd.conf
> random: Trying to read entropy from /dev/random
> Configuration file: /etc/myapd.conf
> nl80211: Could not add multicast membership for vendor events: -2 (No
> such file or directory)
> rfkill: Cannot open RFKILL control device
> nl80211: RFKILL status not available
> nl80211: Using driver-based roaming
> nl80211: Supported cipher 00-0f-ac:1
> nl80211: Supported cipher 00-0f-ac:5
> nl80211: Supported cipher 00-0f-ac:2
> nl80211: Supported cipher 00-0f-ac:4
> nl80211: Supported cipher 00-40-96:255
> nl80211: Supported cipher 00-14-72:1
> nl80211: Supports Probe Response offload in AP mode
> nl80211: Disable use_monitor with device_ap_sme since no monitor mode
> support detected
> nl80211: interface wlan0 in phy phy1
> nl80211: Set mode ifindex 4 iftype 3 (AP)
> nl80211: Setup AP(wlan0) - device_ap_sme=1 use_monitor=0
> nl80211: Subscribe to mgmt frames with AP handle 0x6807c8 (device SME)
> nl80211: Register frame type=0xd0 nl_handle=0x6807c8 match=
> nl80211: Enable Probe Request reporting nl_preq=0x67f8c8
> nl80211: Register frame type=0x40 nl_handle=0x67f8c8 match=
> nl80211: Add own interface ifindex 4
> nl80211: if_indices[16]: 4
> phy: phy1
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Regulatory information - country=00
> nl80211: 2402-2472 @ 40 MHz 20 mBm
> nl80211: 2457-2482 @ 40 MHz 20 mBm (no IR)
> nl80211: 2474-2494 @ 20 MHz 20 mBm (no OFDM) (no IR)
> nl80211: 5170-5250 @ 80 MHz 20 mBm (no IR)
> nl80211: 5735-5835 @ 80 MHz 20 mBm (no IR)
> nl80211: 57240-63720 @ 2160 MHz 0 mBm
> nl80211: Added 802.11b mode based on 802.11g information
> Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
> Completing interface initialization
> Mode: IEEE 802.11b  Channel: 1  Frequency: 2412 MHz
> DFS 0 channels required radar detection
> nl80211: Set freq 2412 (ht_enabled=0, vht_enabled=0, bandwidth=20 MHz,
> cf1=2412 MHz, cf2=0 MHz)
> RATE[0] rate=10 flags=0x1
> RATE[1] rate=20 flags=0x1
> RATE[2] rate=55 flags=0x0
> RATE[3] rate=110 flags=0x0
> hostapd_setup_bss(hapd=0x67fdd8 (wlan0), first=1)
> wlan0: Flushing old station entries
> nl80211: flush -> DEL_STATION wlan0 (all)
> wlan0: Deauthenticate all stations
> nl80211: sta_remove -> DEL_STATION wlan0 ff:ff:ff:ff:ff:ff --> 0 (Success)
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
> key_idx=0 set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
> key_idx=1 set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
> key_idx=2 set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
> key_idx=3 set_tx=0 seq_len=0 key_len=0
> Using interface wlan0 with hwaddr 00:03:7f:be:f0:a0 and ssid "testssid"
> Deriving WPA PSK based on passphrase
> SSID - hexdump_ascii(len=8):
>      74 65 73 74 73 73 69 64                           testssid
> PSK (ASCII passphrase) - hexdump_ascii(len=10): [REMOVED]
> PSK (from passphrase) - hexdump(len=32): [REMOVED]
> random: Got 18/20 bytes from /dev/random
> random: Only 18/20 bytes of strong random data available from /dev/random
> random: Not enough entropy pool available for secure operations
> WPA: Not enough entropy in random pool for secure operations - update
> keys later when the first station connects
> Get randomness: len=32 entropy=0
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> GMK - hexdump(len=32): [REMOVED]
> Get randomness: len=32 entropy=0
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> Key Counter - hexdump(len=32): [REMOVED]
> WPA: Delay group state machine start until Beacon frames have been configured
> nl80211: Set beacon (beacon_set=0)
> nl80211: Beacon head - hexdump(len=55): 80 00 00 00 ff ff ff ff ff ff
> 00 03 7f be f0 a0 00 03 7f be f0 a0 00 00 00 00 00 00 00 00 00 00 64
> 00 11 00 00 08 74 65 73 74 73 73 69 64 01 04 82 84 0b 16 03 01 01
> nl80211: Beacon tail - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00
> 00 0f ac 04 01 00 00 0f ac 02 00 00
> nl80211: ifindex=4
> nl80211: beacon_int=100
> nl80211: dtim_period=2
> nl80211: ssid - hexdump_ascii(len=8):
>      74 65 73 74 73 73 69 64                           testssid
> nl80211: proberesp (offload) - hexdump(len=77): 50 00 00 00 00 00 00
> 00 00 00 00 03 7f be f0 a0 00 03 7f be f0 a0 00 00 00 00 00 00 00 00
> 00 00 64 00 11 00 00 08 74 65 73 74 73 73 69 64 01 04 82 84 0b 16 03
> 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00
> 00
> nl80211: hidden SSID not in use
> nl80211: privacy=1
> nl80211: auth_algs=0x1
> nl80211: wpa_version=0x2
> nl80211: key_mgmt_suites=0x2
> nl80211: pairwise_ciphers=0x18
> nl80211: group_cipher=0x10
> WPA: Start group state machine to set initial keys
> WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
> Get randomness: len=16 entropy=0
> random from os_get_random - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=16): [REMOVED]
> GTK - hexdump(len=16): [REMOVED]
> WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=3 addr=0xa305c
> key_idx=1 set_tx=1 seq_len=0 key_len=16
> nl80211: KEY_DATA - hexdump(len=16): [REMOVED]
>    broadcast key
> nl80211: Set wlan0 operstate 0->1 (UP)
> netlink: Operstate: ifindex=4 linkmode=-1 (no change), operstate=6 (IF_OPER_UP)
> Failed to set TX queue parameters for queue 0.
> Failed to set TX queue parameters for queue 1.
> Failed to set TX queue parameters for queue 2.
> Failed to set TX queue parameters for queue 3.
> wlan0: interface state UNINITIALIZED->ENABLED
> wlan0: AP-ENABLED
> wlan0: Setup of interface done.
> ctrl_iface not configured!
> nl80211: Event message available
> nl80211: Drv Event 88 (NL80211_CMD_CH_SWITCH_NOTIFY) received for wlan0
> nl80211: Channel switch event
> wlan0: Event CH_SWITCH (41) received
> wlan0: IEEE 802.11 driver had channel switch: freq=2412, ht=1,
> offset=0, width=1, cf1=2412, cf2=0
>
>
> nl80211: Event message available
> nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received for wlan0
> nl80211: New station 00:27:10:75:60:28
> nl80211: Assoc Req IEs - hexdump(len=57): 00 08 74 65 73 74 73 73 69
> 64 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c 30 14 01 00 00 0f
> ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00
> 01 00
> wlan0: Event ASSOC (0) received
> Add randomness: count=1 entropy=0
> random pool - hexdump(len=128): [REMOVED]
> random_mix_pool - hexdump(len=8): [REMOVED]
> random_mix_pool - hexdump(len=6): [REMOVED]
> random pool - hexdump(len=128): [REMOVED]
> wlan0: STA 00:27:10:75:60:28 IEEE 802.11: associated
> STA included RSN IE in (Re)AssocReq
>   New STA
> ap_sta_add: register ap_handle_timer timeout for 00:27:10:75:60:28
> (300 seconds - ap_max_inactivity)
> wlan0: STA 00:27:10:75:60:28 WPA: event 1 notification
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> IEEE 802.1X: Ignore STA - 802.1X not enabled or forced for WPS
> wlan0: STA 00:27:10:75:60:28 WPA: start authentication
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> wlan0: STA 00:27:10:75:60:28 IEEE 802.1X: unauthorizing port
> WPA: 00:27:10:75:60:28 WPA_PTK_GROUP entering state IDLE
> WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION
> WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION2
> WPA: Re-initialize GMK/Counter on first station
> random: Cannot read from /dev/random: Resource temporarily unavailable
> random: Got 0/2 bytes from /dev/random
> random: Only 18/20 bytes of strong random data available from /dev/random
> random: Not enough entropy pool available for secure operations
> WPA: Not enough entropy in random pool to proceed - reject first 4-way handshake
> Get randomness: len=32 entropy=1
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> GMK - hexdump(len=32): [REMOVED]
> Get randomness: len=32 entropy=0
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> Key Counter - hexdump(len=32): [REMOVED]
> Get randomness: len=16 entropy=0
> random from os_get_random - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=16): [REMOVED]
> GTK - hexdump(len=16): [REMOVED]
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=3 addr=0xa305c
> key_idx=1 set_tx=1 seq_len=0 key_len=16
> nl80211: KEY_DATA - hexdump(len=16): [REMOVED]
>    broadcast key
> Get randomness: len=32 entropy=0
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> WPA: Assign ANonce - hexdump(len=32): 60 b4 5b f8 1d 19 7e e6 ba 2e a8
> ec b7 a3 69 e5 37 dc a8 c1 4f b2 16 79 73 67 c4 56 a2 2e 55 dd
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITPSK
> Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
> Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
> WPA: 00:27:10:75:60:28 WPA_PTK entering state PTKSTART
> wlan0: STA 00:27:10:75:60:28 WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=1
> kde_len=0 keyidx=0 encr=0)
> WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)
> hostapd_new_assoc_sta: reschedule ap_handle_timer timeout for
> 00:27:10:75:60:28 (300 seconds - ap_max_inactivity)
> wlan0: Event EAPOL_RX (26) received
> IEEE 802.1X: 121 bytes from 00:27:10:75:60:28
>    IEEE 802.1X: version=1 type=3 length=117
> WPA: Received EAPOL-Key from 00:27:10:75:60:28 key_info=0x10a type=2
> key_data_length=22
> WPA: Received Key Nonce - hexdump(len=32): 40 6b 10 a0 8f a6 a5 75 6f
> 72 a0 86 ae ff e1 3e 2c 66 79 77 20 94 27 1c 7f 7d fa e3 61 88 6d b2
> WPA: Received Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 01
> Add randomness: count=2 entropy=0
> random pool - hexdump(len=128): [REMOVED]
> random_mix_pool - hexdump(len=8): [REMOVED]
> random_mix_pool - hexdump(len=32): [REMOVED]
> random pool - hexdump(len=128): [REMOVED]
> WPA: Reject 4-way handshake to collect more entropy for random number generation
> random: Mark internal entropy pool to be ready (count=1/2)
> wpa_sta_disconnect STA 00:27:10:75:60:28
> hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect:
> STA 00:27:10:75:60:28 reason 2
> nl80211: sta_remove -> DEL_STATION wlan0 00:27:10:75:60:28 --> 0 (Success)
> wlan0: STA 00:27:10:75:60:28 WPA: event 3 notification
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> WPA: 00:27:10:75:60:28 WPA_PTK entering state DISCONNECTED
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> wlan0: STA 00:27:10:75:60:28 IEEE 802.1X: unauthorizing port
> ap_sta_disconnect: reschedule ap_handle_timer timeout for
> 00:27:10:75:60:28 (5 seconds - AP_MAX_INACTIVITY_AFTER_DEAUTH)
> Removing STA 00:27:10:75:60:28 from kernel driver
> nl80211: sta_remove -> DEL_STATION wlan0 00:27:10:75:60:28 --> 0 (Success)
> wlan0: STA 00:27:10:75:60:28 MLME:
> MLME-DEAUTHENTICATE.indication(00:27:10:75:60:28, 2)
> wlan0: STA 00:27:10:75:60:28 MLME: MLME-DELETEKEYS.request(00:27:10:75:60:28)
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> nl80211: Event message available
> nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION) received for wlan0
> nl80211: Delete station 00:27:10:75:60:28
> wlan0: Event DISASSOC (1) received
> wlan0: STA 00:27:10:75:60:28 IEEE 802.11: disassociated
> wlan0: STA 00:27:10:75:60:28 WPA: event 2 notification
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> WPA: 00:27:10:75:60:28 WPA_PTK entering state DISCONNECTED
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> wlan0: STA 00:27:10:75:60:28 IEEE 802.1X: unauthorizing port
> nl80211: sta_remove -> DEL_STATION wlan0 00:27:10:75:60:28 --> 0 (Success)
> ap_free_sta: cancel ap_handle_timer for 00:27:10:75:60:28
> nl80211: Event message available
> nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received for wlan0
> nl80211: New station 00:27:10:75:60:28
> nl80211: Assoc Req IEs - hexdump(len=57): 00 08 74 65 73 74 73 73 69
> 64 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c 30 14 01 00 00 0f
> ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00
> 01 00
> wlan0: Event ASSOC (0) received
> Add randomness: count=3 entropy=1
> random pool - hexdump(len=128): [REMOVED]
> random_mix_pool - hexdump(len=8): [REMOVED]
> random_mix_pool - hexdump(len=6): [REMOVED]
> random pool - hexdump(len=128): [REMOVED]
> wlan0: STA 00:27:10:75:60:28 IEEE 802.11: associated
> STA included RSN IE in (Re)AssocReq
>   New STA
> ap_sta_add: register ap_handle_timer timeout for 00:27:10:75:60:28
> (300 seconds - ap_max_inactivity)
> wlan0: STA 00:27:10:75:60:28 WPA: event 1 notification
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> IEEE 802.1X: Ignore STA - 802.1X not enabled or forced for WPS
> wlan0: STA 00:27:10:75:60:28 WPA: start authentication
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> wlan0: STA 00:27:10:75:60:28 IEEE 802.1X: unauthorizing port
> WPA: 00:27:10:75:60:28 WPA_PTK_GROUP entering state IDLE
> WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION
> WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION2
> WPA: Re-initialize GMK/Counter on first station
> random: Cannot read from /dev/random: Resource temporarily unavailable
> random: Got 0/2 bytes from /dev/random
> random: Only 18/20 bytes of strong random data available from /dev/random
> random: Not enough entropy pool available for secure operations
> WPA: Not enough entropy in random pool to proceed - reject first 4-way handshake
> Get randomness: len=32 entropy=2
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> GMK - hexdump(len=32): [REMOVED]
> Get randomness: len=32 entropy=0
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> Key Counter - hexdump(len=32): [REMOVED]
> Get randomness: len=16 entropy=0
> random from os_get_random - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=16): [REMOVED]
> GTK - hexdump(len=16): [REMOVED]
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=3 addr=0xa305c
> key_idx=1 set_tx=1 seq_len=0 key_len=16
> nl80211: KEY_DATA - hexdump(len=16): [REMOVED]
>    broadcast key
> Get randomness: len=32 entropy=0
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> WPA: Assign ANonce - hexdump(len=32): fb e1 df 2b 38 e9 ba 57 64 eb f9
> e1 8b 6b c8 1e 45 88 b9 6f 77 d1 85 8a ad fb f2 1f e0 ec 3e 42
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITPSK
> Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
> Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
> WPA: 00:27:10:75:60:28 WPA_PTK entering state PTKSTART
> wlan0: STA 00:27:10:75:60:28 WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=1
> kde_len=0 keyidx=0 encr=0)
> WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)
> hostapd_new_assoc_sta: reschedule ap_handle_timer timeout for
> 00:27:10:75:60:28 (300 seconds - ap_max_inactivity)
> wlan0: Event EAPOL_RX (26) received
> IEEE 802.1X: 121 bytes from 00:27:10:75:60:28
>    IEEE 802.1X: version=1 type=3 length=117
> WPA: Received EAPOL-Key from 00:27:10:75:60:28 key_info=0x10a type=2
> key_data_length=22
> WPA: Received Key Nonce - hexdump(len=32): 5c b7 3a 2d 8b ec 17 5f 68
> 44 0e 88 7c 0a 42 67 a7 aa 59 f6 17 64 ab a5 85 8b 86 5c 84 8d 5d 84
> WPA: Received Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 01
> Add randomness: count=4 entropy=0
> random pool - hexdump(len=128): [REMOVED]
> random_mix_pool - hexdump(len=8): [REMOVED]
> random_mix_pool - hexdump(len=32): [REMOVED]
> random pool - hexdump(len=128): [REMOVED]
> WPA: Reject 4-way handshake to collect more entropy for random number generation
> random: Mark internal entropy pool to be ready (count=2/2)
> wpa_sta_disconnect STA 00:27:10:75:60:28
> hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect:
> STA 00:27:10:75:60:28 reason 2
> nl80211: sta_remove -> DEL_STATION wlan0 00:27:10:75:60:28 --> 0 (Success)
> wlan0: STA 00:27:10:75:60:28 WPA: event 3 notification
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> WPA: 00:27:10:75:60:28 WPA_PTK entering state DISCONNECTED
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> wlan0: STA 00:27:10:75:60:28 IEEE 802.1X: unauthorizing port
> ap_sta_disconnect: reschedule ap_handle_timer timeout for
> 00:27:10:75:60:28 (5 seconds - AP_MAX_INACTIVITY_AFTER_DEAUTH)
> Removing STA 00:27:10:75:60:28 from kernel driver
> nl80211: sta_remove -> DEL_STATION wlan0 00:27:10:75:60:28 --> 0 (Success)
> wlan0: STA 00:27:10:75:60:28 MLME:
> MLME-DEAUTHENTICATE.indication(00:27:10:75:60:28, 2)
> wlan0: STA 00:27:10:75:60:28 MLME: MLME-DELETEKEYS.request(00:27:10:75:60:28)
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> nl80211: Event message available
> nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION) received for wlan0
> nl80211: Delete station 00:27:10:75:60:28
> wlan0: Event DISASSOC (1) received
> wlan0: STA 00:27:10:75:60:28 IEEE 802.11: disassociated
> wlan0: STA 00:27:10:75:60:28 WPA: event 2 notification
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> WPA: 00:27:10:75:60:28 WPA_PTK entering state DISCONNECTED
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> wlan0: STA 00:27:10:75:60:28 IEEE 802.1X: unauthorizing port
> nl80211: sta_remove -> DEL_STATION wlan0 00:27:10:75:60:28 --> 0 (Success)
> ap_free_sta: cancel ap_handle_timer for 00:27:10:75:60:28
> nl80211: Event message available
> nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received for wlan0
> nl80211: New station 00:27:10:75:60:28
> nl80211: Assoc Req IEs - hexdump(len=57): 00 08 74 65 73 74 73 73 69
> 64 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c 30 14 01 00 00 0f
> ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00
> 01 00
> wlan0: Event ASSOC (0) received
> Add randomness: count=5 entropy=1
> random pool - hexdump(len=128): [REMOVED]
> random_mix_pool - hexdump(len=8): [REMOVED]
> random_mix_pool - hexdump(len=6): [REMOVED]
> random pool - hexdump(len=128): [REMOVED]
> wlan0: STA 00:27:10:75:60:28 IEEE 802.11: associated
> STA included RSN IE in (Re)AssocReq
>   New STA
> ap_sta_add: register ap_handle_timer timeout for 00:27:10:75:60:28
> (300 seconds - ap_max_inactivity)
> wlan0: STA 00:27:10:75:60:28 WPA: event 1 notification
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> IEEE 802.1X: Ignore STA - 802.1X not enabled or forced for WPS
> wlan0: STA 00:27:10:75:60:28 WPA: start authentication
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> wlan0: STA 00:27:10:75:60:28 IEEE 802.1X: unauthorizing port
> WPA: 00:27:10:75:60:28 WPA_PTK_GROUP entering state IDLE
> WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION
> WPA: 00:27:10:75:60:28 WPA_PTK entering state AUTHENTICATION2
> WPA: Re-initialize GMK/Counter on first station
> random: Cannot read from /dev/random: Resource temporarily unavailable
> random: Got 0/2 bytes from /dev/random
> random: Only 18/20 bytes of strong random data available from /dev/random
> random: Allow operation to proceed based on internal entropy
> Get randomness: len=32 entropy=2
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> GMK - hexdump(len=32): [REMOVED]
> Get randomness: len=32 entropy=0
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> Key Counter - hexdump(len=32): [REMOVED]
> Get randomness: len=16 entropy=0
> random from os_get_random - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=16): [REMOVED]
> GTK - hexdump(len=16): [REMOVED]
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=3 addr=0xa305c
> key_idx=1 set_tx=1 seq_len=0 key_len=16
> nl80211: KEY_DATA - hexdump(len=16): [REMOVED]
>    broadcast key
> Get randomness: len=32 entropy=0
> random from os_get_random - hexdump(len=32): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> random_mix_pool - hexdump(len=20): [REMOVED]
> random from internal pool - hexdump(len=16): [REMOVED]
> mixed random - hexdump(len=32): [REMOVED]
> WPA: Assign ANonce - hexdump(len=32): 1f a4 1c 80 42 c3 fe 2b 64 3e 5c
> 23 6f d4 55 7d 6f 16 21 05 2d 88 08 2a d1 ae 47 6b 7e 52 26 61
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITPSK
> Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
> Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
> WPA: 00:27:10:75:60:28 WPA_PTK entering state PTKSTART
> wlan0: STA 00:27:10:75:60:28 WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=1
> kde_len=0 keyidx=0 encr=0)
> WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)
> hostapd_new_assoc_sta: reschedule ap_handle_timer timeout for
> 00:27:10:75:60:28 (300 seconds - ap_max_inactivity)
> wlan0: Event EAPOL_RX (26) received
> IEEE 802.1X: 121 bytes from 00:27:10:75:60:28
>    IEEE 802.1X: version=1 type=3 length=117
> WPA: Received EAPOL-Key from 00:27:10:75:60:28 key_info=0x10a type=2
> key_data_length=22
> WPA: Received Key Nonce - hexdump(len=32): 76 5f b9 4a d6 73 01 1e d4
> bd 44 78 c4 35 41 05 eb 57 c2 6c 70 4b be bb 3a 36 bc 56 35 23 35 0c
> WPA: Received Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 01
> Add randomness: count=6 entropy=0
> random pool - hexdump(len=128): [REMOVED]
> random_mix_pool - hexdump(len=8): [REMOVED]
> random_mix_pool - hexdump(len=32): [REMOVED]
> random pool - hexdump(len=128): [REMOVED]
> wlan0: STA 00:27:10:75:60:28 WPA: received EAPOL-Key frame (2/4 Pairwise)
> WPA: 00:27:10:75:60:28 WPA_PTK entering state PTKCALCNEGOTIATING
> Searching a PSK for 00:27:10:75:60:28 prev_psk=(nil)
> WPA: PTK derivation - A1=00:03:7f:be:f0:a0 A2=00:27:10:75:60:28
> WPA: Nonce1 - hexdump(len=32): 1f a4 1c 80 42 c3 fe 2b 64 3e 5c 23 6f
> d4 55 7d 6f 16 21 05 2d 88 08 2a d1 ae 47 6b 7e 52 26 61
> WPA: Nonce2 - hexdump(len=32): 76 5f b9 4a d6 73 01 1e d4 bd 44 78 c4
> 35 41 05 eb 57 c2 6c 70 4b be bb 3a 36 bc 56 35 23 35 0c
> WPA: PMK - hexdump(len=32): [REMOVED]
> WPA: PTK - hexdump(len=48): [REMOVED]
> WPA: 00:27:10:75:60:28 WPA_PTK entering state PTKCALCNEGOTIATING2
> WPA: 00:27:10:75:60:28 WPA_PTK entering state PTKINITNEGOTIATING
> wlan0: STA 00:27:10:75:60:28 WPA: sending 3/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=1 pairwise=1
> kde_len=46 keyidx=1 encr=1)
> Plaintext EAPOL-Key Key Data - hexdump(len=56): [REMOVED]
> WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)
> nl80211: Event message available
> nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION) received for wlan0
> nl80211: Delete station 00:27:10:75:60:28
> wlan0: Event DISASSOC (1) received
> wlan0: STA 00:27:10:75:60:28 IEEE 802.11: disassociated
> wlan0: STA 00:27:10:75:60:28 WPA: event 2 notification
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> WPA: 00:27:10:75:60:28 WPA_PTK entering state DISCONNECTED
> WPA: 00:27:10:75:60:28 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=0x6822c8
> key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=00:27:10:75:60:28
> wlan0: STA 00:27:10:75:60:28 IEEE 802.1X: unauthorizing port
> nl80211: sta_remove -> DEL_STATION wlan0 00:27:10:75:60:28 --> 0 (Success)
> ap_free_sta: cancel ap_handle_timer for 00:27:10:75:60:28
>
>
> And here is the capture from wireshark from the Laptop:
>
> No.     Time        Source                Destination
> Protocol Length Info
>       5 6.248045    AtherosC_be:f0:a0     IntelCor_75:60:28     EAPOL
>   113    Key (msg 1/4)
>
> Frame 5: 113 bytes on wire (904 bits), 113 bytes captured (904 bits)
>     Arrival Time: Dec  2, 2014 18:53:45.046303000 UTC
>     Epoch Time: 1417546425.046303000 seconds
>     [Time delta from previous captured frame: 3.113203000 seconds]
>     [Time delta from previous displayed frame: 3.113203000 seconds]
>     [Time since reference or first frame: 6.248045000 seconds]
>     Frame Number: 5
>     Frame Length: 113 bytes (904 bits)
>     Capture Length: 113 bytes (904 bits)
>     [Frame is marked: True]
>     [Frame is ignored: False]
>     [Protocols in frame: eth:eapol]
> Ethernet II, Src: AtherosC_be:f0:a0 (00:03:7f:be:f0:a0), Dst:
> IntelCor_75:60:28 (00:27:10:75:60:28)
>     Destination: IntelCor_75:60:28 (00:27:10:75:60:28)
>         Address: IntelCor_75:60:28 (00:27:10:75:60:28)
>         .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>         .... ..0. .... .... .... .... = LG bit: Globally unique
> address (factory default)
>     Source: AtherosC_be:f0:a0 (00:03:7f:be:f0:a0)
>         Address: AtherosC_be:f0:a0 (00:03:7f:be:f0:a0)
>         .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>         .... ..0. .... .... .... .... = LG bit: Globally unique
> address (factory default)
>     Type: 802.1X Authentication (0x888e)
> 802.1X Authentication
>     Version: 2
>     Type: Key (3)
>     Length: 95
>     Descriptor Type: EAPOL RSN key (2)
>     Key Information: 0x008a
>         .... .... .... .010 = Key Descriptor Version: HMAC-SHA1 for
> MIC and AES key wrap for encryption (2)
>         .... .... .... 1... = Key Type: Pairwise key
>         .... .... ..00 .... = Key Index: 0
>         .... .... .0.. .... = Install flag: Not set
>         .... .... 1... .... = Key Ack flag: Set
>         .... ...0 .... .... = Key MIC flag: Not set
>         .... ..0. .... .... = Secure flag: Not set
>         .... .0.. .... .... = Error flag: Not set
>         .... 0... .... .... = Request flag: Not set
>         ...0 .... .... .... = Encrypted Key Data flag: Not set
>     Key Length: 16
>     Replay Counter: 1
>     Nonce: 1fa41c8042c3fe2b643e5c236fd4557d6f1621052d88082a...
>     Key IV: 00000000000000000000000000000000
>     WPA Key RSC: 0000000000000000
>     WPA Key ID: 0000000000000000
>     WPA Key MIC: 00000000000000000000000000000000
>     WPA Key Length: 0
>
> 0000  00 27 10 75 60 28 00 03 7f be f0 a0 88 8e 02 03   .'.u`(..........
> 0010  00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 1f   ._..............
> 0020  a4 1c 80 42 c3 fe 2b 64 3e 5c 23 6f d4 55 7d 6f   ...B..+d>\#o.U}o
> 0030  16 21 05 2d 88 08 2a d1 ae 47 6b 7e 52 26 61 00   .!.-..*..Gk~R&a.
> 0040  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
> 0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
> 0060  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
> 0070  00                                                .
>
> No.     Time        Source                Destination
> Protocol Length Info
>       6 6.249396    IntelCor_75:60:28     AtherosC_be:f0:a0     EAPOL
>   135    Key (msg 2/4)
>
> Frame 6: 135 bytes on wire (1080 bits), 135 bytes captured (1080 bits)
>     Arrival Time: Dec  2, 2014 18:53:45.047654000 UTC
>     Epoch Time: 1417546425.047654000 seconds
>     [Time delta from previous captured frame: 0.001351000 seconds]
>     [Time delta from previous displayed frame: 0.001351000 seconds]
>     [Time since reference or first frame: 6.249396000 seconds]
>     Frame Number: 6
>     Frame Length: 135 bytes (1080 bits)
>     Capture Length: 135 bytes (1080 bits)
>     [Frame is marked: True]
>     [Frame is ignored: False]
>     [Protocols in frame: eth:eapol]
> Ethernet II, Src: IntelCor_75:60:28 (00:27:10:75:60:28), Dst:
> AtherosC_be:f0:a0 (00:03:7f:be:f0:a0)
>     Destination: AtherosC_be:f0:a0 (00:03:7f:be:f0:a0)
>         Address: AtherosC_be:f0:a0 (00:03:7f:be:f0:a0)
>         .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>         .... ..0. .... .... .... .... = LG bit: Globally unique
> address (factory default)
>     Source: IntelCor_75:60:28 (00:27:10:75:60:28)
>         Address: IntelCor_75:60:28 (00:27:10:75:60:28)
>         .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>         .... ..0. .... .... .... .... = LG bit: Globally unique
> address (factory default)
>     Type: 802.1X Authentication (0x888e)
> 802.1X Authentication
>     Version: 1
>     Type: Key (3)
>     Length: 117
>     Descriptor Type: EAPOL RSN key (2)
>     Key Information: 0x010a
>         .... .... .... .010 = Key Descriptor Version: HMAC-SHA1 for
> MIC and AES key wrap for encryption (2)
>         .... .... .... 1... = Key Type: Pairwise key
>         .... .... ..00 .... = Key Index: 0
>         .... .... .0.. .... = Install flag: Not set
>         .... .... 0... .... = Key Ack flag: Not set
>         .... ...1 .... .... = Key MIC flag: Set
>         .... ..0. .... .... = Secure flag: Not set
>         .... .0.. .... .... = Error flag: Not set
>         .... 0... .... .... = Request flag: Not set
>         ...0 .... .... .... = Encrypted Key Data flag: Not set
>     Key Length: 0
>     Replay Counter: 1
>     Nonce: 765fb94ad673011ed4bd4478c4354105eb57c26c704bbebb...
>     Key IV: 00000000000000000000000000000000
>     WPA Key RSC: 0000000000000000
>     WPA Key ID: 0000000000000000
>     WPA Key MIC: 7ac0bc8b21e5af46ff4e82259762ad8a
>     WPA Key Length: 22
>     WPA Key: 30140100000fac040100000fac040100000fac020000
>         Tag: RSN Information
>             Tag Number: RSN Information (48)
>             Tag length: 20
>             RSN Version: 1
>             Group Cipher Suite: 00-0f-ac (Ieee8021) AES (CCM)
>                 Group Cipher Suite OUI: 00-0f-ac (Ieee8021)
>                 Group Cipher Suite type: AES (CCM) (4)
>             Pairwise Cipher Suite Count: 1
>             Pairwise Cipher Suite List 00-0f-ac (Ieee8021) AES (CCM)
>                 Pairwise Cipher Suite: 00-0f-ac (Ieee8021) AES (CCM)
>                     Pairwise Cipher Suite OUI: 00-0f-ac (Ieee8021)
>                     Pairwise Cipher Suite type: AES (CCM) (4)
>             Auth Key Management (AKM) Suite Count: 1
>             Auth Key Management (AKM) List 00-0f-ac (Ieee8021) PSK
>                 Auth Key Management (AKM) Suite: 00-0f-ac (Ieee8021) PSK
>                     Auth Key Management (AKM) OUI: 00-0f-ac (Ieee8021)
>                     Auth Key Management (AKM) type: PSK (2)
>             RSN Capabilities: 0x0000
>                 .... .... .... ...0 = RSN Pre-Auth capabilities:
> Transmitter does not support pre-authentication
>                 .... .... .... ..0. = RSN No Pairwise capabilities:
> Transmitter can support WEP default key 0 simultaneously with Pairwise
> key
>                 .... .... .... 00.. = RSN PTKSA Replay Counter
> capabilities: 1 replay counter per PTKSA/GTKSA/STAKeySA (0x0000)
>                 .... .... ..00 .... = RSN GTKSA Replay Counter
> capabilities: 1 replay counter per PTKSA/GTKSA/STAKeySA (0x0000)
>                 .... .... .0.. .... = Management Frame Protection
> Required: False
>                 .... .... 0... .... = Management Frame Protection Capable: False
>                 .... ..0. .... .... = PeerKey Enabled: False
>
> 0000  00 03 7f be f0 a0 00 27 10 75 60 28 88 8e 01 03   .......'.u`(....
> 0010  00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 76   .u.............v
> 0020  5f b9 4a d6 73 01 1e d4 bd 44 78 c4 35 41 05 eb   _.J.s....Dx.5A..
> 0030  57 c2 6c 70 4b be bb 3a 36 bc 56 35 23 35 0c 00   W.lpK..:6.V5#5..
> 0040  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
> 0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7a   ...............z
> 0060  c0 bc 8b 21 e5 af 46 ff 4e 82 25 97 62 ad 8a 00   ...!..F.N.%.b...
> 0070  16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01   .0..............
> 0080  00 00 0f ac 02 00 00                              .......
>
> No.     Time        Source                Destination
> Protocol Length Info
>       7 6.586001    AtherosC_be:f0:a0     IntelCor_75:60:28     EAPOL
>   169    Key (msg 3/4)
>
> Frame 7: 169 bytes on wire (1352 bits), 169 bytes captured (1352 bits)
>     Arrival Time: Dec  2, 2014 18:53:45.384259000 UTC
>     Epoch Time: 1417546425.384259000 seconds
>     [Time delta from previous captured frame: 0.336605000 seconds]
>     [Time delta from previous displayed frame: 0.336605000 seconds]
>     [Time since reference or first frame: 6.586001000 seconds]
>     Frame Number: 7
>     Frame Length: 169 bytes (1352 bits)
>     Capture Length: 169 bytes (1352 bits)
>     [Frame is marked: True]
>     [Frame is ignored: False]
>     [Protocols in frame: eth:eapol]
> Ethernet II, Src: AtherosC_be:f0:a0 (00:03:7f:be:f0:a0), Dst:
> IntelCor_75:60:28 (00:27:10:75:60:28)
>     Destination: IntelCor_75:60:28 (00:27:10:75:60:28)
>         Address: IntelCor_75:60:28 (00:27:10:75:60:28)
>         .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>         .... ..0. .... .... .... .... = LG bit: Globally unique
> address (factory default)
>     Source: AtherosC_be:f0:a0 (00:03:7f:be:f0:a0)
>         Address: AtherosC_be:f0:a0 (00:03:7f:be:f0:a0)
>         .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>         .... ..0. .... .... .... .... = LG bit: Globally unique
> address (factory default)
>     Type: 802.1X Authentication (0x888e)
> 802.1X Authentication
>     Version: 2
>     Type: Key (3)
>     Length: 151
>     Descriptor Type: EAPOL RSN key (2)
>     Key Information: 0x13ca
>         .... .... .... .010 = Key Descriptor Version: HMAC-SHA1 for
> MIC and AES key wrap for encryption (2)
>         .... .... .... 1... = Key Type: Pairwise key
>         .... .... ..00 .... = Key Index: 0
>         .... .... .1.. .... = Install flag: Set
>         .... .... 1... .... = Key Ack flag: Set
>         .... ...1 .... .... = Key MIC flag: Set
>         .... ..1. .... .... = Secure flag: Set
>         .... .0.. .... .... = Error flag: Not set
>         .... 0... .... .... = Request flag: Not set
>         ...1 .... .... .... = Encrypted Key Data flag: Set
>     Key Length: 16
>     Replay Counter: 2
>     Nonce: 1fa41c8042c3fe2b643e5c236fd4557d6f1621052d88082a...
>     Key IV: 00000000000000000000000000000000
>     WPA Key RSC: 0000000000000000
>     WPA Key ID: 0000000000000000
>     WPA Key MIC: 59ea20877a955f12c8947d38d1235da9
>     WPA Key Length: 56
>     WPA Key: d95c249b5103ec9f435a98d90c728ddc239d9b68598447f5...
>
> 0000  00 27 10 75 60 28 00 03 7f be f0 a0 88 8e 02 03   .'.u`(..........
> 0010  00 97 02 13 ca 00 10 00 00 00 00 00 00 00 02 1f   ................
> 0020  a4 1c 80 42 c3 fe 2b 64 3e 5c 23 6f d4 55 7d 6f   ...B..+d>\#o.U}o
> 0030  16 21 05 2d 88 08 2a d1 ae 47 6b 7e 52 26 61 00   .!.-..*..Gk~R&a.
> 0040  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
> 0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 59   ...............Y
> 0060  ea 20 87 7a 95 5f 12 c8 94 7d 38 d1 23 5d a9 00   . .z._...}8.#]..
> 0070  38 d9 5c 24 9b 51 03 ec 9f 43 5a 98 d9 0c 72 8d   8.\$.Q...CZ...r.
> 0080  dc 23 9d 9b 68 59 84 47 f5 6e 58 95 aa 71 e7 b5   .#..hY.G.nX..q..
> 0090  cd 08 e2 29 19 d1 f7 77 fc 62 3c ea 30 00 c3 f4   ...)...w.b<.0...
> 00a0  22 6d 0b 0b 97 6d 01 de e3                        "m...m...

Sorry i meant wpa_supplicant logs on STA side. Hostapd is sending 3/4
but STA is rejecting it.
Is it possible to share the pcap file from connection attempt,
we need to check the IE at connection time w.r.t M3/4?

-- 
Thanks,
Regards,
Chaitanya T K.
