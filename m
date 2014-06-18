Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:8183 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755142AbaFRUvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 16:51:31 -0400
Message-ID: <2f52376ba13cf8814471ea684d86ad3b.squirrel@www.infidigm.net> (sfid-20140618_225135_601448_474A7F76)
In-Reply-To: <87k38eehth.fsf@kamboji.qca.qualcomm.com>
References: <63ed0fb1a4c098dd260f249546408de5.squirrel@www.infidigm.net>
    <87k38eehth.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 18 Jun 2014 16:31:17 -0400
Subject: Re: QCA ar9375 in Ubuntu 14.04 beta 2 not working
From: drwho@infidigm.net
To: "Kalle Valo" <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> At first I was getting an error about not being able find the firmware
>> file, so I renamed your fw-5.bin to fw.ram.bin.
>
> You should not rename the firmware file, it will break everything if you
> do that. This is what you should see:
>
> [  364.432845] usb 2-1.4: new high-speed USB device number 4 using
> ehci-pci
> [  364.510168] usb 2-1.4: New USB device found, idVendor=0cf3,
> idProduct=9375
> [  364.510232] usb 2-1.4: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [  364.510289] usb 2-1.4: Product: USBWLAN
> [  364.510346] usb 2-1.4: Manufacturer: Qualcomm Atheros.
> [  364.510430] usb 2-1.4: SerialNumber: 12345678
> [  364.835598] ath6kl: ar6004 hw 3.0 usb fw 3.5.0.349-1 api 5
> [  364.835710] ath6kl: firmware supports:
> 64bit-rates,map-lp-endpoint,ratetable-mcs15,no-ip-checksum
>
> My first guess is that something went wrong in the kernel compilation
> and the new patches are not actually applied. Double check that you
> really have the new hw3.0 support in place, for example by adding few
> printks and making sure that you see them in dmesg.

The firmware files were corrupt.  After copying the firmware directly from
the git repo, I've got the 9375 working in Ubuntu 14.04 and on an arm SoC
using backports-3.11. After some testing (downloading a large file from a
local server repeatedly), I've discovered that after 10-40min the 9375
device becomes "stuck".  This happens on Ubuntu x86 and on the arm SoC
using backports.  I've tried it with a TP-WR1043ND router and a Ubiquity
UAP.  The issue happens when associated to either AP.  Something similar
happens using the driver ATH6KL-LSDK-WLAN-AIO-OSR-5.0.0.110 as well.  
Once in the stuck state...

- wpa_supplicant can no longer connect.
- iw wlan0 scan ....never returns or returns with device is busy.

then if I wait 10-30min, the device is functional again, scan works and
wpa_supplicant can connect.  I also noticed that the Ubuntu machine will
reconnect eventually as well.  I can do a sniff / capture with a device in
monitor mode if you think that is useful.

wpa_supplicant / console log from arm SoC at the point of failure.....

Connecting to 192.168.13.164:12345 (192.168.13.164:12345)

null                   2% |                               |  2167k 
0:00:44 ETA
null                   4% |*                              |  4454k 
0:00:41 ETA
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=00:27:22:f1:f7:91 index=0 preauth=0
RSN: Ignored PMKID candidate without preauth flag

null                   5% |*                              |  4980k 
0:00:55 ETA
null                   5% |*                              |  4980k 
0:01:14 ETA
null                   5% |*                              |  4980k 
0:01:33 ETA
null                   5% |*                              |  4980k 
0:01:51 ETA
null                   5% |*                              |  4980k 
0:02:10 ETA
null                   5% |*                              |  4980k  -
stalled -
null                   5% |*                              |  4980k  -
stalled -
null                   5% |*                              |  4980k  -
stalled -
null                   5% |*                              |  4980k  -
stalled -
null                   5% |*                              |  4980k  -
stalled -
null                   5% |*                              |  4980k  -
stalled -
null                   5% |*                              |  4980k  -
stalled -
null                   5% |*                              |  4980k  -
stalled -
null                   5% |*                              |  4980k  -
stalled -
null                   5% |*                              |  4980k  -
stalled -

ping 192.168.13.1
PING 192.168.13.1 (192.168.13.1): 56 data bytes
--- 192.168.13.1 ping statistics ---
5 packets transmitted, 0 packets received, 100% packet loss

nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=00:27:22:f1:f7:91 index=0 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=00:27:22:f1:f7:91 index=0 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=a4:13:4e:01:e6:78 index=1 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=00:27:22:f1:f7:91 index=0 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=a4:13:4e:01:e6:78 index=1 preauth=0
RSN: Ignored PMKID candidate without preauth flag

iw wlan0 link
Connected to 00:27:22:f1:f7:91 (on wlan0)
	SSID: BluOS_1c3f
	freq: 2412
	RX: 1437253037 bytes (3727739 packets)
	TX: 194893624 bytes (1838932 packets)
	signal: -33 dBm

nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=00:27:22:f1:f7:91 index=0 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=a4:13:4e:01:e6:78 index=1 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=00:27:22:f1:f7:91 index=0 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=a4:13:4e:01:e6:78 index=1 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=00:27:22:f1:f7:91 index=0 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=a4:13:4e:01:e6:78 index=1 preauth=0
RSN: Ignored PMKID candidate without preauth flag
wlan0: RX EAPOL from 00:27:22:f1:f7:91
RX EAPOL - hexdump(len=131): 02 03 00 7f 02 13 82 00 10 00 00 00 00 00 00
00 07 b9 1f 38 54 eb 34 b4 ff 54 85 b1 ce 81 58 4d 6f d0 89 ec 5f fa d9 e0
a2 af dc 78 30 b8 66 72 95 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 33 ae 85 78 f0 cc 0f 4e b7
fd 03 e8 d4 a6 ba 42 00 20 53 03 cb aa d2 af 05 60 df 04 88 a6 51 e0 6f 9d
d4 b8 d2 2f 3a 31 15 19 28 fd b3 75 6f df 30 14
wlan0: IEEE 802.1X RX: version=2 type=3 length=127
wlan0:   EAPOL-Key type=2
wlan0:   key_info 0x1382 (ver=2 keyidx=0 rsvd=0 Group Ack MIC Secure Encr)
wlan0:   key_length=16 key_data_length=32
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 07
  key_nonce - hexdump(len=32): b9 1f 38 54 eb 34 b4 ff 54 85 b1 ce 81 58
4d 6f d0 89 ec 5f fa d9 e0 a2 af dc 78 30 b8 66 72 95
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 33 ae 85 78 f0 cc 0f 4e b7 fd 03 e8 d4 a6 ba 42
WPA: RX EAPOL-Key - hexdump(len=131): 02 03 00 7f 02 13 82 00 10 00 00 00
00 00 00 00 07 b9 1f 38 54 eb 34 b4 ff 54 85 b1 ce 81 58 4d 6f d0 89 ec 5f
fa d9 e0 a2 af dc 78 30 b8 66 72 95 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 33 ae 85 78 f0 cc
0f 4e b7 fd 03 e8 d4 a6 ba 42 00 20 53 03 cb aa d2 af 05 60 df 04 88 a6 51
e0 6f 9d d4 b8 d2 2f 3a 31 15 19 28 fd b3 75 6f df 30 14
RSN: encrypted key data - hexdump(len=32): 53 03 cb aa d2 af 05 60 df 04
88 a6 51 e0 6f 9d d4 b8 d2 2f 3a 31 15 19 28 fd b3 75 6f df 30 14
WPA: decrypted EAPOL-Key key data - hexdump(len=24): [REMOVED]
wlan0: WPA: RX message 1 of Group Key Handshake from 00:27:22:f1:f7:91
(ver=2)
RSN: msg 1/2 key data - hexdump(len=24): dd 16 00 0f ac 01 02 00 40 ec df
f1 86 66 ab 8f ec b0 76 5e d4 a9 8d da
WPA: GTK in EAPOL-Key - hexdump(len=24): [REMOVED]
RSN: received GTK in group key handshake - hexdump(len=18): 02 00 40 ec df
f1 86 66 ab 8f ec b0 76 5e d4 a9 8d da
wlan0: State: COMPLETED -> GROUP_HANDSHAKE
WPA: Group Key - hexdump(len=16): [REMOVED]
wlan0: WPA: Installing GTK to the driver (keyidx=2 tx=0 len=16)
WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
wpa_driver_nl80211_set_key: ifindex=3 alg=3 addr=0x58aec key_idx=2
set_tx=0 seq_len=6 key_len=16
   broadcast key
wlan0: WPA: Sending EAPOL-Key 2/2
WPA: KCK - hexdump(len=16): [REMOVED]
WPA: Derived Key MIC - hexdump(len=16): 9b 9b 81 39 aa a8 f4 72 fa d7 7c
69 0c ee 00 5d
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 02 00 00 00 00 00
00 00 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9b 9b 81 39 aa a8
f4 72 fa d7 7c 69 0c ee 00 5d 00 00
wlan0: WPA: Group rekeying completed with 00:27:22:f1:f7:91 [GTK=CCMP]
wlan0: Cancelling authentication timeout
wlan0: State: GROUP_HANDSHAKE -> COMPLETED
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=00:27:22:f1:f7:91 index=0 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: PMKSA candidate event
wlan0: Event PMKID_CANDIDATE (6) received
wlan0: RSN: PMKID candidate event - bssid=a4:13:4e:01:e6:78 index=1 preauth=0
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: Disconnect event
wlan0: Event DEAUTH (12) received
wlan0: Deauthentication notification
wlan0:  * [  204.216766] cfg80211: Calling CRDA for country: US

reason 3
Deauthentication frame IE(s) - hexdump(len=0): [NULL]
wlan0: CTRL-EVENT-DISCONNECTED bssid=00:27:22:f1:f7:91 reason=3
wlan0: Auto connect enabled: try to reconnect (wps=0 wpa_state=9)
wlan0: Setting scan request: 0 sec 100000 usec
Added BSSID 00:27:22:f1:f7:91 into blacklist
wlan0: Blacklist count 1 --> request scan in 100 ms
wlan0: Not rescheduling scan to ensure that specific SSID scans occur
wlan0: Disconnect event - remove keys
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=0 set_tx=0
seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=1 set_tx=0
seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=2 set_tx=0
seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=3 set_tx=0
seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x773d8 key_idx=0
set_tx=0 seq_len=0 key_len=0
   addr=00:27:22:f1:f7:91
wlan0: State: COMPLETED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: if_removed already cleared - ignore event
wlan0: State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=10):
     42 6c 75 4f 53 5f 31 63 33 66                     BluOS_1c3f
wlan0: Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=10):
     42 6c 75 4f 53 5f 31 63 33 66                     BluOS_1c3f
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
wlan0: BSS: Remove id 0 BSSID 00:27:22:f1:f7:91 SSID 'BluOS_1c3f' due to
wpa_bss_flush_by_age

iw wlan0 link
Not connected.

Scan timeout - try to get results
wlan0: Event SCAN_RESULTS (3) received
nl80211: Received scan results (0 BSSes)
wlan0: BSS: Start scan result update 2
BSS: last_scan_res_used=0/32 last_scan_full=0
wlan0: New scan results available
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in
event_scan_results
Scan SSID - hexdump_ascii(len=10):
     42 6c 75 4f 53 5f 31 63 33 66                     BluOS_1c3f
wlan0: Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=10):
     42 6c 75 4f 53 5f 31 63 33 66                     BluOS_1c3f
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
wlan0: Failed to initiate AP scan
wlan0: Setting scan request: 1 sec 0 usec
Scan SSID - hexdump_ascii(len=10):
     42 6c 75 4f 53 5f 31 63 33 66                     BluOS_1c3f
wlan0: Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=10):
     42 6c 75 4f 53 5f 31 63 33 66                     BluOS_1c3f
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
wlan0: Failed to initiate AP scan
wlan0: Setting scan request: 1 sec 0 usec
Scan SSID - hexdump_ascii(len=10):
     42 6c 75 4f 53 5f 31 63 33 66                     BluOS_1c3f
wlan0: Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=10):
     42 6c 75 4f 53 5f 31 63 33 66                     BluOS_1c3f
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
wlan0: Failed to initiate AP scan
wlan0: Setting scan request: 1 sec 0 usec

Jon

