Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ibawizard.net ([82.208.49.253]:49321 "EHLO
	mengele.ibawizard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2KYTKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 14:10:17 -0500
Date: Sun, 25 Nov 2012 20:00:19 +0100
From: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Subject: Multi-bss operation issue with rt2x00 and hostapd on rt305x
	platform
Message-ID: <20121125190019.GQ8292@ibawizard.net> (sfid-20121125_201043_358797_A470E889)
Reply-To: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mhOzvPhkurUs4vA9"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--mhOzvPhkurUs4vA9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

first of all, I apologize for cross posting. Please kindly keep me in the Cc
loop as I'm not subscribed to the mailing lists.

For the past week I'm trying to get multi-bss working on ramips platform, it's
a Carambola(from 8Devices) board with rt3050 SOC, which use rt2x00 driver for
wireless. I use OpenWRT, which currently have 3.3.8 kernel and compat-wireless
from 2012-09-07. On top of this I've applied following patches (otherwise it's
not even possible to create the wlan0-1 and wlan0-2 interfaces):

3e4c4151e56ff367fb1487ea79134eea7410407	[PATCH] rt2x00: Deprecate max_sta_intf field of struct rt2x00_ops
55d2e9da744ba11eae900b4bfc2da72eace3c1e1 [PATCH] rt2x00: Replace open coded interface checking with interface combinations

It's kind of working now, but not completly. I've setup with 3 VAPs:

wlan0:   SSID "wlan0-bad"
wlan0-1: SSID "wlan01-ok"
wlan0-2: SSID "wlan02-ok"

just basic configuration and no encryption, attached is complete hostapd's
config file. As you can guess from the SSID names, the first one always
doesn't work, client assoc ends with the following error:

hostapd: wlan0: STA <STA_MAC> IEEE 802.11: did not acknowledge authentication response

but the next two SSIDs works just fine. The wireless stack is quite complex, so
before I'll dive deeper, any hints what should cause this issue? I simply don't
believe, that it's caused by the hostapd, since the same hostapd config works
fine on AR7240 chipset.

I'm attaching debug logs from hostapd and pcaps also. What I've observed so far
is, that in working case(wlan1-ok, wlan2-ok) the frame flow is different:

	...
	mgmt::auth
	authentication: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=1 status_code=0 wep=0
	  New STA 
	ap_sta_add: register ap_handle_timer timeout for 78:d6:f0:09:a2:27 (300 seconds - ap_max_inactivity)
	authentication reply: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
	nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
	nl80211: Frame TX command accepted; cookie 0x81937c00
	Add randomness: count=39 entropy=38
	nl80211: Event message available
-->	nl80211: MLME event 60 (NL80211_CMD_REGISTER_FRAME)
	mgmt::auth cb
	wlan0-1: STA 78:d6:f0:09:a2:27 IEEE 802.11: authenticated
	...

and this is for non-working case (wlan0-bad)

	...
	mgmt::auth
	authentication: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=1 status_code=0 wep=0
	  New STA 
	ap_sta_add: register ap_handle_timer timeout for 78:d6:f0:09:a2:27 (300 seconds - ap_max_inactivity)
	authentication reply: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
	nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
	nl80211: Frame TX command accepted; cookie 0x81a089c0
	Add randomness: count=12 entropy=11
	nl80211: Event message available
-->	nl80211: MLME event 59 (NL80211_CMD_SET_TX_BITRATE_MASK)                            
	mgmt::auth
	...

I've also observed in the pcaps, that in the working case there's
Authentication sent before Association request and in the non-working case
there's Association request going first and then Authentication request. Any
clue what could cause this? Thank you for any pointers.

As I've seen on the Google, this issue is hanging there for some time already
so I would really like to help and get it fixed finally. Thanks.

-- ynezz

--mhOzvPhkurUs4vA9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hostapd-phy0.conf"

ctrl_interface=/var/run/hostapd-phy0
driver=nl80211
wmm_ac_bk_cwmin=4
wmm_ac_bk_cwmax=10
wmm_ac_bk_aifs=7
wmm_ac_bk_txop_limit=0
wmm_ac_bk_acm=0
wmm_ac_be_aifs=3
wmm_ac_be_cwmin=4
wmm_ac_be_cwmax=10
wmm_ac_be_txop_limit=0
wmm_ac_be_acm=0
wmm_ac_vi_aifs=2
wmm_ac_vi_cwmin=3
wmm_ac_vi_cwmax=4
wmm_ac_vi_txop_limit=94
wmm_ac_vi_acm=0
wmm_ac_vo_aifs=2
wmm_ac_vo_cwmin=2
wmm_ac_vo_cwmax=3
wmm_ac_vo_txop_limit=47
wmm_ac_vo_acm=0
tx_queue_data3_aifs=7
tx_queue_data3_cwmin=15
tx_queue_data3_cwmax=1023
tx_queue_data3_burst=0
tx_queue_data2_aifs=3
tx_queue_data2_cwmin=15
tx_queue_data2_cwmax=63
tx_queue_data2_burst=0
tx_queue_data1_aifs=1
tx_queue_data1_cwmin=7
tx_queue_data1_cwmax=15
tx_queue_data1_burst=3.0
tx_queue_data0_aifs=1
tx_queue_data0_cwmin=3
tx_queue_data0_cwmax=7
tx_queue_data0_burst=1.5
hw_mode=g
channel=10




logger_syslog=127
logger_syslog_level=2
logger_stdout=127
logger_stdout_level=2
ieee80211n=1
ht_capab=[HT20][GF][SHORT-GI-20][SHORT-GI-40][RX-STBC1]
preamble=0

interface=wlan0
ctrl_interface=/var/run/hostapd-phy0
ap_isolate=1
disassoc_low_ack=1
auth_algs=1
wpa=0
ssid=wlan0-bad
wmm_enabled=1
bssid=c4:93:00:11:01:88
ignore_broadcast_ssid=1



bss=wlan0-1
ctrl_interface=/var/run/hostapd-phy0
ap_isolate=1
disassoc_low_ack=1
auth_algs=1
wpa=0
ssid=wlan01-ok
wmm_enabled=1
bssid=c6:93:00:11:01:89
ignore_broadcast_ssid=0



bss=wlan0-2
ctrl_interface=/var/run/hostapd-phy0
ap_isolate=1
disassoc_low_ack=1
auth_algs=1
wpa=0
ssid=wlan02-ok
wmm_enabled=1
bssid=c6:93:00:11:01:8a
ignore_broadcast_ssid=0




--mhOzvPhkurUs4vA9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wlan02-ok.hostapd.txt"

STA 78:d6:f0:09:a2:27 sent probe request for our SSID
Add randomness: count=37 entropy=36
nl80211: Event message available
nl80211: MLME event 59
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
nl80211: Frame TX command accepted; cookie 0x81937d80
STA 78:d6:f0:09:a2:27 sent probe request for our SSID
Add randomness: count=38 entropy=37
nl80211: Event message available
nl80211: MLME event 60
mgmt::proberesp cb
nl80211: Event message available
nl80211: MLME event 60
mgmt::proberesp cb
nl80211: Event message available
nl80211: MLME event 59
mgmt::auth
authentication: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
ap_sta_add: register ap_handle_timer timeout for 78:d6:f0:09:a2:27 (300 seconds - ap_max_inactivity)
authentication reply: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
nl80211: Frame TX command accepted; cookie 0x81937c00
Add randomness: count=39 entropy=38
nl80211: Event message available
nl80211: MLME event 60
mgmt::auth cb
wlan0-1: STA 78:d6:f0:09:a2:27 IEEE 802.11: authenticated
nl80211: Event message available
nl80211: MLME event 59
mgmt::assoc_req
association request: STA=78:d6:f0:09:a2:27 capab_info=0x421 listen_interval=10
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
Validating WMM IE: OUI 00:50:f2  OUI type 2  OUI sub-type 0  version 1  QoS info 0x0
  new AID 1
nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
nl80211: Frame TX command accepted; cookie 0x81937d80
Add randomness: count=40 entropy=39
nl80211: Event message available
nl80211: MLME event 60
mgmt::assoc_resp cb
wlan0-1: STA 78:d6:f0:09:a2:27 IEEE 802.11: associated (aid 1)
wlan0: AP-STA-CONNECTED 78:d6:f0:09:a2:27
wlan0-1: STA 78:d6:f0:09:a2:27 RADIUS: starting accounting session 50AFD50A-00000000
IEEE 802.1X: Ignore STA - 802.1X not enabled or forced for WPS
hostapd_new_assoc_sta: reschedule ap_handle_timer timeout for 78:d6:f0:09:a2:27 (300 seconds - ap_max_inactivity)

--mhOzvPhkurUs4vA9
Content-Type: application/cap
Content-Disposition: attachment; filename="wlan02-ok.pcap"
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAP//AAB/AAAA+zGyUDrpAwAwAAAAMAAAAAAAEgAuSAAAAAKZCaAA
4gYAALAAOgF41vAJoifGkwARAYrGkwARAYqgEQAAAgAAAPsxslB+6gMAHAAAABwAAAAAABIA
LkgAAAACmQmgAOQGAADUAAAAxpMAEQGK+zGyUOrvAwCZAAAAmQAAAAAAEgAuSAAAAAKZCaAA
5QYAAAAAOgHGkwARAYp41vAJoifGkwARAYqAEyEECgAACXdsYW4wMi1vawEIgoSLliQwSGwy
BAwSGGAtGiwYG/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAA3QkAEBgCAAAAAADdHgCQTDMsGBv/
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAN0HAFDyAgABAPsxslAf8QMAHAAAABwAAAAAABIALkgA
AAACmQmgAOEGAADUAAAAeNbwCaIn+zGyUL0JBACOAAAAjgAAAAAAEgAuSAAAAAKZCaAA4gYA
ABAAOgF41vAJoifGkwARAYrGkwARAYqwEQEEAAABwAEIgoSLlgwSGCQyBDBIYGwtGnwBE/8A
AAABAAAAAAAAAAMAAAAAAAAAAAAAPRYKAAQAAAAAAAAAAAAAAAAAAAAAAAAA3RgAUPICAQEA
AAOkAAAnpAAAQkNeAGIyLwD7MbJQ6goEABwAAAAcAAAAAAASAC5IAAAAApkJoADlBgAA1AAA
AMaTABEBivsxslA4/gcALQAAAC0AAAAAABUAKkgIAAAAmQmABN8GAAAHAAdIESwAxpMAEQGK
eNbwCaInxpMAEQGKkBP7MbJQRP4HAC0AAAAtAAAAAAAVACpICAAAAJkJgATfBgAABwAHSBks
AMaTABEBinjW8AmiJ8aTABEBipAT+zGyUEr+BwAcAAAAHAAAAAAAEgAuSAAAAAyZCcAA4gYA
ANQAAAB41vAJoif/MbJQOocEADMAAAAzAAAAAAASAC5IAAAAApkJoADlBgAA0AA6AcaTABEB
injW8AmiJ8aTABEBiqATAwA/AhAAAAAA/zGyUICLBAAzAAAAMwAAAAAAEgAuSAAAAAKZCaAA
5QYAANAIOgHGkwARAYp41vAJoifGkwARAYqgEwMAPwIQAAAAAP8xslDRjAQAHAAAABwAAAAA
ABIALkgAAAACmQmgAOIGAADUAAAAeNbwCaIn/zGyUAqOBAB/AQAAfwEAAAAAFQAqSAgAAACZ
CYAE4AYAAAcAB4gBLADGkwARAYp41vAJoif///////8AAAAAqqoDAAAACABFAAFIGbwAAEAR
X+oAAAAA/////wBEAEMBNCwVAQEGAPnByIEADAAAAAAAAAAAAAAAAAAAAAAAAHjW8AmiJwAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABjglNjNQEBOQIF3DwNZGhj
cGNkLTUuMi4xMAwXYW5kcm9pZC1kMTBlMDcwN2QzMmZmZDE3CQEhAwYPHDM6O/8A/zGyUBWO
BAAcAAAAHAAAAAAAEgAuSAAAAAyZCcAA4gYAANQAAAB41vAJoic=

--mhOzvPhkurUs4vA9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wlan02-ok.txt"

No.     Time        Source                Destination           Protocol Length Info
   5739 41.378848   c6:93:00:11:01:8a     SamsungE_09:a2:27     802.11   48     Authentication, SN=282, FN=0, Flags=........

Frame 5739: 48 bytes on wire (384 bits), 48 bytes captured (384 bits)
    Arrival Time: Nov 25, 2012 15:58:03.256314000 CET
    Epoch Time: 1353855483.256314000 seconds
    [Time delta from previous captured frame: 0.000543000 seconds]
    [Time delta from previous displayed frame: 0.000543000 seconds]
    [Time since reference or first frame: 41.378848000 seconds]
    Frame Number: 5739
    Frame Length: 48 bytes (384 bits)
    Capture Length: 48 bytes (384 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -30 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Authentication, Flags: ........
    Type/Subtype: Authentication (0x0b)
    Frame Control: 0x00B0 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 11
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    BSS Id: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Fragment number: 0
    Sequence number: 282
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Authentication Algorithm: Open System (0)
        Authentication SEQ: 0x0002
        Status code: Successful (0x0000)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e2 06   .....H..........
0010  00 00 b0 00 3a 01 78 d6 f0 09 a2 27 c6 93 00 11   ....:.x....'....
0020  01 8a c6 93 00 11 01 8a a0 11 00 00 02 00 00 00   ................

No.     Time        Source                Destination           Protocol Length Info
   5740 41.379172                         c6:93:00:11:01:8a (RA) 802.11   28     Acknowledgement, Flags=........

Frame 5740: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:03.256638000 CET
    Epoch Time: 1353855483.256638000 seconds
    [Time delta from previous captured frame: 0.000324000 seconds]
    [Time delta from previous displayed frame: 0.000324000 seconds]
    [Time since reference or first frame: 41.379172000 seconds]
    Frame Number: 5740
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -28 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: c6:93:00:11:01:8a (c6:93:00:11:01:8a)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e4 06   .....H..........
0010  00 00 d4 00 00 00 c6 93 00 11 01 8a               ............

No.     Time        Source                Destination           Protocol Length Info
   5741 41.380560   SamsungE_09:a2:27     c6:93:00:11:01:8a     802.11   153    Association Request, SN=312, FN=0, Flags=........, SSID=wlan02-ok

Frame 5741: 153 bytes on wire (1224 bits), 153 bytes captured (1224 bits)
    Arrival Time: Nov 25, 2012 15:58:03.258026000 CET
    Epoch Time: 1353855483.258026000 seconds
    [Time delta from previous captured frame: 0.001388000 seconds]
    [Time delta from previous displayed frame: 0.001388000 seconds]
    [Time since reference or first frame: 41.380560000 seconds]
    Frame Number: 5741
    Frame Length: 153 bytes (1224 bits)
    Capture Length: 153 bytes (1224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -27 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Association Request, Flags: ........
    Type/Subtype: Association Request (0x00)
    Frame Control: 0x0000 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 0
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Source address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    BSS Id: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Fragment number: 0
    Sequence number: 312
IEEE 802.11 wireless LAN management frame
    Fixed parameters (4 bytes)
        Capabilities Information: 0x0421
            .... .... .... ...1 = ESS capabilities: Transmitter is an AP
            .... .... .... ..0. = IBSS status: Transmitter belongs to a BSS
            .... ..0. .... 00.. = CFP participation capabilities: No point coordinator at AP (0x0000)
            .... .... ...0 .... = Privacy: AP/STA cannot support WEP
            .... .... ..1. .... = Short Preamble: Short preamble allowed
            .... .... .0.. .... = PBCC: PBCC modulation not allowed
            .... .... 0... .... = Channel Agility: Channel agility not in use
            .... ...0 .... .... = Spectrum Management: dot11SpectrumManagementRequired FALSE
            .... .1.. .... .... = Short Slot Time: Short slot time in use
            .... 0... .... .... = Automatic Power Save Delivery: apsd not implemented
            ..0. .... .... .... = DSSS-OFDM: DSSS-OFDM modulation not allowed
            .0.. .... .... .... = Delayed Block Ack: delayed block ack not implemented
            0... .... .... .... = Immediate Block Ack: immediate block ack not implemented
        Listen Interval: 0x000a
    Tagged parameters (107 bytes)
        Tag: SSID parameter set: wlan02-ok
            Tag Number: SSID parameter set (0)
            Tag length: 9
            SSID: wlan02-ok
        Tag: Supported Rates 1(B), 2(B), 5.5(B), 11(B), 18, 24, 36, 54, [Mbit/sec]
            Tag Number: Supported Rates (1)
            Tag length: 8
            Supported Rates: 1(B)
            Supported Rates: 2(B)
            Supported Rates: 5.5(B)
            Supported Rates: 11(B)
            Supported Rates: 18
            Supported Rates: 24
            Supported Rates: 36
            Supported Rates: 54
        Tag: Extended Supported Rates 6, 9, 12, 48, [Mbit/sec]
            Tag Number: Extended Supported Rates (50)
            Tag length: 4
            Extented Supported Rates: 6
            Extented Supported Rates: 9
            Extented Supported Rates: 12
            Extented Supported Rates: 48
        Tag: HT Capabilities (802.11n D1.10)
            Tag Number: HT Capabilities (802.11n D1.10) (45)
            Tag length: 26
            HT Capabilities Info: 0x182c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...0 .... = HT Green Field: Transmitter is not able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .0.. .... = HT Short GI for 40MHz: Not supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..00 .... .... = HT Rx STBC: No Rx STBC support (0x0000)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 1... .... .... = HT Max A-MSDU length: 7935 bytes
                ...1 .... .... .... = HT DSSS/CCK mode in 40MHz: Will/Can use DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters: 0x001b
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 10.. = MPDU Density: 8 [usec] (0x06)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set: MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities: 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities: 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities: 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: Vendor Specific: Broadcom
            Tag Number: Vendor Specific (221)
            Tag length: 9
            OUI: 00-10-18 (Broadcom)
            Vendor Specific OUI Type: 2
            Tag interpretation: Not interpreted
        Tag: Vendor Specific: Epigram: HT Capabilities (802.11n D1.10)
            Tag Number: Vendor Specific (221)
            Tag length: 30
            OUI: 00-90-4c (Epigram)
            Vendor Specific OUI Type: 51
            Tag interpretation: 802.11n (Pre) OUI
            Tag interpretation: 802.11n (Pre) HT information
            HT Capabilities Info (VS): 0x182c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...0 .... = HT Green Field: Transmitter is not able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .0.. .... = HT Short GI for 40MHz: Not supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..00 .... .... = HT Rx STBC: No Rx STBC support (0x0000)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 1... .... .... = HT Max A-MSDU length: 7935 bytes
                ...1 .... .... .... = HT DSSS/CCK mode in 40MHz: Will/Can use DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters (VS): 0x001b
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 10.. = MPDU Density: 8 [usec] (0x06)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set (VS): MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities (VS): 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities (VS): 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities (VS): 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: Vendor Specific: Microsof: WMM/WME: Information Element
            Tag Number: Vendor Specific (221)
            Tag length: 7
            OUI: 00-50-f2 (Microsof)
            Vendor Specific OUI Type: 2
            Type: WMM/WME (0x02)
            WME Subtype: Information Element (0)
            WME Version: 1
            WME QoS Info: 0x00
                .00. .... = Max SP Length: WMM AP may deliver all buffered frames (MSDUs and MMPDUs) (0x00)
                .... 0... = AC_BE: non-WMM PS
                .... .0.. = AC_BK: non-WMM PS
                .... ..0. = AC_VI: non-WMM PS
                .... ...0 = AC_VO: non-WMM PS
                0..0 .... = Reserved: 0x00

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e5 06   .....H..........
0010  00 00 00 00 3a 01 c6 93 00 11 01 8a 78 d6 f0 09   ....:.......x...
0020  a2 27 c6 93 00 11 01 8a 80 13 21 04 0a 00 00 09   .'........!.....
0030  77 6c 61 6e 30 32 2d 6f 6b 01 08 82 84 8b 96 24   wlan02-ok......$
0040  30 48 6c 32 04 0c 12 18 60 2d 1a 2c 18 1b ff 00   0Hl2....`-.,....
0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0060  00 00 00 00 00 dd 09 00 10 18 02 00 00 00 00 00   ................
0070  dd 1e 00 90 4c 33 2c 18 1b ff 00 00 00 00 00 00   ....L3,.........
0080  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0090  dd 07 00 50 f2 02 00 01 00                        ...P.....

No.     Time        Source                Destination           Protocol Length Info
   5742 41.380869                         SamsungE_09:a2:27 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 5742: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:03.258335000 CET
    Epoch Time: 1353855483.258335000 seconds
    [Time delta from previous captured frame: 0.000309000 seconds]
    [Time delta from previous displayed frame: 0.000309000 seconds]
    [Time since reference or first frame: 41.380869000 seconds]
    Frame Number: 5742
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -31 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e1 06   .....H..........
0010  00 00 d4 00 00 00 78 d6 f0 09 a2 27               ......x....'

No.     Time        Source                Destination           Protocol Length Info
   5743 41.387171   c6:93:00:11:01:8a     SamsungE_09:a2:27     802.11   142    Association Response, SN=283, FN=0, Flags=........

Frame 5743: 142 bytes on wire (1136 bits), 142 bytes captured (1136 bits)
    Arrival Time: Nov 25, 2012 15:58:03.264637000 CET
    Epoch Time: 1353855483.264637000 seconds
    [Time delta from previous captured frame: 0.006302000 seconds]
    [Time delta from previous displayed frame: 0.006302000 seconds]
    [Time since reference or first frame: 41.387171000 seconds]
    Frame Number: 5743
    Frame Length: 142 bytes (1136 bits)
    Capture Length: 142 bytes (1136 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -30 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Association Response, Flags: ........
    Type/Subtype: Association Response (0x01)
    Frame Control: 0x0010 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 1
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    BSS Id: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Fragment number: 0
    Sequence number: 283
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Capabilities Information: 0x0401
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
        Status code: Successful (0x0000)
        ..00 0000 0000 0001 = Association ID: 0x0001
    Tagged parameters (94 bytes)
        Tag: Supported Rates 1(B), 2(B), 5.5(B), 11(B), 6, 9, 12, 18, [Mbit/sec]
            Tag Number: Supported Rates (1)
            Tag length: 8
            Supported Rates: 1(B)
            Supported Rates: 2(B)
            Supported Rates: 5.5(B)
            Supported Rates: 11(B)
            Supported Rates: 6
            Supported Rates: 9
            Supported Rates: 12
            Supported Rates: 18
        Tag: Extended Supported Rates 24, 36, 48, 54, [Mbit/sec]
            Tag Number: Extended Supported Rates (50)
            Tag length: 4
            Extented Supported Rates: 24
            Extented Supported Rates: 36
            Extented Supported Rates: 48
            Extented Supported Rates: 54
        Tag: HT Capabilities (802.11n D1.10)
            Tag Number: HT Capabilities (802.11n D1.10) (45)
            Tag length: 26
            HT Capabilities Info: 0x017c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...1 .... = HT Green Field: Transmitter is able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .1.. .... = HT Short GI for 40MHz: Supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..01 .... .... = HT Rx STBC: Rx support of one spatial stream (0x0001)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 0... .... .... = HT Max A-MSDU length: 3839 bytes
                ...0 .... .... .... = HT DSSS/CCK mode in 40MHz: Won't/Can't use of DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters: 0x0013
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 00.. = MPDU Density: 2 [usec] (0x04)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set: MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...1 = Rx Bitmask Bit 32: 0x00000001
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...1 = Tx Supported MCS Set: Defined
                .... .... .... ..1. = Tx and Rx MCS Set: Not Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities: 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities: 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities: 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: HT Information (802.11n D1.10)
            Tag Number: HT Information (802.11n D1.10) (61)
            Tag length: 22
            Primary Channel: 10
            HT Information Subset (1 of 3): 0x00
                .... ..00 = Secondary channel offset: No secondary channel (0x00)
                .... .0.. = Supported channel width: 20 MHz channel width only
                .... 0... = Reduced Interframe Spacing (RIFS): Prohibited
                ...0 .... = Power Save Multi-Poll (PSMP) stations only: Association requests are accepted regardless of PSMP capability
                000. .... = Shortest service interval: 5 ms (0x00)
            HT Information Subset (2 of 3): 0x0004
                .... .... .... ..00 = Operating mode of BSS: All STAs are - 20/40 MHz HT or in a 20/40 MHz BSS or are 20 MHz HT in a 20 MHz BSS (0x0000)
                .... .... .... .1.. = Non-greenfield STAs present: One or more associated STAs are not greenfield capable
                .... .... .... 0... = Transmit burst limit: No limit
                .... .... ...0 .... = OBSS non-HT STAs present: Use of protection for non-HT STAs by overlapping BSSs is not needed
                0000 0000 000. .... = Reserved: 0x0000
            HT Information Subset (3 of 3): 0x0000
                .... .... ..00 0000 = Reserved: 0x0000
                .... .... .0.. .... = Dual beacon: No second beacon is transmitted
                .... .... 0... .... = Dual Clear To Send (CTS) protection: Not required
                .... ...0 .... .... = Beacon ID: Primary beacon
                .... ..0. .... .... = L-SIG TXOP Protection Full Support: One or more HT STAs in the BSS do not support L-SIG TXOP protection
                .... .0.. .... .... = Phased Coexistence Operation (PCO): Inactive
                .... 0... .... .... = Phased Coexistence Operation (PCO) Phase: Switch to or continue 20 MHz phase
                0000 .... .... .... = Reserved: 0x0000
            Rx Supported Modulation and Coding Scheme Set: Basic MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 0000 0000 = Rx Bitmask Bits 0-7: 0x00000000
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
        Tag: Vendor Specific: Microsof: WMM/WME: Parameter Element
            Tag Number: Vendor Specific (221)
            Tag length: 24
            OUI: 00-50-f2 (Microsof)
            Vendor Specific OUI Type: 2
            Type: WMM/WME (0x02)
            WME Subtype: Parameter Element (1)
            WME Version: 1
            WME QoS Info: 0x00
                0... .... = U-APSD: Disabled
                .... 0000 = Parameter Set Count: 0x00
                .000 .... = Reserved: 0x00
            Reserved: 00
            Ac Parameters ACI 0 (Best Effort), ACM no , AIFSN 3, ECWmin 4 ,ECWmax 10, TXOP 0
                ACI / AIFSN Field: 0x03
                    .00. .... = ACI: Best Effort (0)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0011 = AIFSN: 3
                    0... .... = Reserved: 0
                ECW: 0xa4
                    1010 .... = ECW Max: 10
                    .... 0100 = ECW Min: 4
                TXOP Limit: 0
            Ac Parameters ACI 1 (Background), ACM no , AIFSN 7, ECWmin 4 ,ECWmax 10, TXOP 0
                ACI / AIFSN Field: 0x27
                    .01. .... = ACI: Background (1)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0111 = AIFSN: 7
                    0... .... = Reserved: 0
                ECW: 0xa4
                    1010 .... = ECW Max: 10
                    .... 0100 = ECW Min: 4
                TXOP Limit: 0
            Ac Parameters ACI 2 (Video), ACM no , AIFSN 2, ECWmin 3 ,ECWmax 4, TXOP 94
                ACI / AIFSN Field: 0x42
                    .10. .... = ACI: Video (2)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0010 = AIFSN: 2
                    0... .... = Reserved: 0
                ECW: 0x43
                    0100 .... = ECW Max: 4
                    .... 0011 = ECW Min: 3
                TXOP Limit: 94
            Ac Parameters ACI 3 (Voice), ACM no , AIFSN 2, ECWmin 2 ,ECWmax 3, TXOP 47
                ACI / AIFSN Field: 0x62
                    .11. .... = ACI: Voice (3)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0010 = AIFSN: 2
                    0... .... = Reserved: 0
                ECW: 0x32
                    0011 .... = ECW Max: 3
                    .... 0010 = ECW Min: 2
                TXOP Limit: 47

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e2 06   .....H..........
0010  00 00 10 00 3a 01 78 d6 f0 09 a2 27 c6 93 00 11   ....:.x....'....
0020  01 8a c6 93 00 11 01 8a b0 11 01 04 00 00 01 c0   ................
0030  01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c   .........$2.0H`l
0040  2d 1a 7c 01 13 ff 00 00 00 01 00 00 00 00 00 00   -.|.............
0050  00 03 00 00 00 00 00 00 00 00 00 00 3d 16 0a 00   ............=...
0060  04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0070  00 00 00 00 dd 18 00 50 f2 02 01 01 00 00 03 a4   .......P........
0080  00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00         ..'...BC^.b2/.

No.     Time        Source                Destination           Protocol Length Info
   5744 41.387472                         c6:93:00:11:01:8a (RA) 802.11   28     Acknowledgement, Flags=........

Frame 5744: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:03.264938000 CET
    Epoch Time: 1353855483.264938000 seconds
    [Time delta from previous captured frame: 0.000301000 seconds]
    [Time delta from previous displayed frame: 0.000301000 seconds]
    [Time since reference or first frame: 41.387472000 seconds]
    Frame Number: 5744
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -27 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: c6:93:00:11:01:8a (c6:93:00:11:01:8a)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e5 06   .....H..........
0010  00 00 d4 00 00 00 c6 93 00 11 01 8a               ............

No.     Time        Source                Destination           Protocol Length Info
   5756 41.646366   SamsungE_09:a2:27     c6:93:00:11:01:8a     802.11   45     Null function (No data), SN=313, FN=0, Flags=...P...T

Frame 5756: 45 bytes on wire (360 bits), 45 bytes captured (360 bits)
    Arrival Time: Nov 25, 2012 15:58:03.523832000 CET
    Epoch Time: 1353855483.523832000 seconds
    [Time delta from previous captured frame: 0.001943000 seconds]
    [Time delta from previous displayed frame: 0.258894000 seconds]
    [Time since reference or first frame: 41.646366000 seconds]
    Frame Number: 5756
    Frame Length: 45 bytes (360 bits)
    Capture Length: 45 bytes (360 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 21
    Header revision: 0
    Header pad: 0
    Header length: 21
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .0.. = Rate: False
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 1... .... .... .... .... = HT information: True
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11g (0x0480)
        .... .... ...0 .... = Turbo: False
        .... .... ..0. .... = Complementary Code Keying (CCK): False
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .1.. .... .... = Dynamic CCK-OFDM: True
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -33 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
    MCS information
        Known MCS information: 0x07
            .... ...1 = Bandwidth: True
            .... ..1. = MCS index: True
            .... .1.. = Guard interval: True
            .... 0... = Format: False
            ...0 .... = FEC: False
        .... ..00 = Bandwidth: 20 MHz (0)
        .... .0.. = Guard interval: long (0)
        MCS index: 7
    [Data Rate: 65.0 Mb/s]
IEEE 802.11 Null function (No data), Flags: ...P...T
    Type/Subtype: Null function (No data) (0x24)
    Frame Control: 0x1148 (Normal)
        Version: 0
        Type: Data frame (2)
        Subtype: 4
        Flags: 0x11
            .... ..01 = DS status: Frame from STA to DS via an AP (To DS: 1 From DS: 0) (0x01)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...1 .... = PWR MGT: STA will go to sleep
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 44
    BSS Id: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Source address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Destination address: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Fragment number: 0
    Sequence number: 313

0000  00 00 15 00 2a 48 08 00 00 00 99 09 80 04 df 06   ....*H..........
0010  00 00 07 00 07 48 11 2c 00 c6 93 00 11 01 8a 78   .....H.,.......x
0020  d6 f0 09 a2 27 c6 93 00 11 01 8a 90 13            ....'........

No.     Time        Source                Destination           Protocol Length Info
   5757 41.646378   SamsungE_09:a2:27     c6:93:00:11:01:8a     802.11   45     Null function (No data), SN=313, FN=0, Flags=...PR..T

Frame 5757: 45 bytes on wire (360 bits), 45 bytes captured (360 bits)
    Arrival Time: Nov 25, 2012 15:58:03.523844000 CET
    Epoch Time: 1353855483.523844000 seconds
    [Time delta from previous captured frame: 0.000012000 seconds]
    [Time delta from previous displayed frame: 0.000012000 seconds]
    [Time since reference or first frame: 41.646378000 seconds]
    Frame Number: 5757
    Frame Length: 45 bytes (360 bits)
    Capture Length: 45 bytes (360 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 21
    Header revision: 0
    Header pad: 0
    Header length: 21
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .0.. = Rate: False
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 1... .... .... .... .... = HT information: True
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11g (0x0480)
        .... .... ...0 .... = Turbo: False
        .... .... ..0. .... = Complementary Code Keying (CCK): False
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .1.. .... .... = Dynamic CCK-OFDM: True
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -33 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
    MCS information
        Known MCS information: 0x07
            .... ...1 = Bandwidth: True
            .... ..1. = MCS index: True
            .... .1.. = Guard interval: True
            .... 0... = Format: False
            ...0 .... = FEC: False
        .... ..00 = Bandwidth: 20 MHz (0)
        .... .0.. = Guard interval: long (0)
        MCS index: 7
    [Data Rate: 65.0 Mb/s]
IEEE 802.11 Null function (No data), Flags: ...PR..T
    Type/Subtype: Null function (No data) (0x24)
    Frame Control: 0x1948 (Normal)
        Version: 0
        Type: Data frame (2)
        Subtype: 4
        Flags: 0x19
            .... ..01 = DS status: Frame from STA to DS via an AP (To DS: 1 From DS: 0) (0x01)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...1 .... = PWR MGT: STA will go to sleep
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 44
    BSS Id: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Source address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Destination address: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Fragment number: 0
    Sequence number: 313

0000  00 00 15 00 2a 48 08 00 00 00 99 09 80 04 df 06   ....*H..........
0010  00 00 07 00 07 48 19 2c 00 c6 93 00 11 01 8a 78   .....H.,.......x
0020  d6 f0 09 a2 27 c6 93 00 11 01 8a 90 13            ....'........

No.     Time        Source                Destination           Protocol Length Info
   5758 41.646384                         SamsungE_09:a2:27 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 5758: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:03.523850000 CET
    Epoch Time: 1353855483.523850000 seconds
    [Time delta from previous captured frame: 0.000006000 seconds]
    [Time delta from previous displayed frame: 0.000006000 seconds]
    [Time since reference or first frame: 41.646384000 seconds]
    Frame Number: 5758
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 6.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11g (pure-g) (0x00c0)
        .... .... ...0 .... = Turbo: False
        .... .... ..0. .... = Complementary Code Keying (CCK): False
        .... .... .1.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): True
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -30 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)

0000  00 00 12 00 2e 48 00 00 00 0c 99 09 c0 00 e2 06   .....H..........
0010  00 00 d4 00 00 00 78 d6 f0 09 a2 27               ......x....'

No.     Time        Source                Destination           Protocol Length Info
   5883 45.419296   SamsungE_09:a2:27     c6:93:00:11:01:8a     802.11   51     Action, SN=314, FN=0, Flags=........

Frame 5883: 51 bytes on wire (408 bits), 51 bytes captured (408 bits)
    Arrival Time: Nov 25, 2012 15:58:07.296762000 CET
    Epoch Time: 1353855487.296762000 seconds
    [Time delta from previous captured frame: 0.086902000 seconds]
    [Time delta from previous displayed frame: 3.772912000 seconds]
    [Time since reference or first frame: 45.419296000 seconds]
    Frame Number: 5883
    Frame Length: 51 bytes (408 bits)
    Capture Length: 51 bytes (408 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -27 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Action, Flags: ........
    Type/Subtype: Action (0x0d)
    Frame Control: 0x00D0 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Source address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    BSS Id: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Fragment number: 0
    Sequence number: 314
IEEE 802.11 wireless LAN management frame
    Fixed parameters
        Action: 0x03
            Category code: Block Ack (3)
            Action code: Add Block Ack Request (0x00)
            Dialog token: 0x3f
            Block Ack Parameters: 0x1002
                .... .... .... ...0 = A-MSDUs: Not Permitted
                .... .... .... ..1. = Block Ack Policy: Immediate Block Ack
                .... .... ..00 00.. = Traffic Identifier: 0x0000
                0001 0000 00.. .... = Number of Buffers (1 Buffer = 2304 Bytes): 64
            Block Ack Timeout: 0x0000
            Block Ack Starting Sequence Control (SSC): 0x0000
                .... .... .... 0000 = Fragment: 0
                0000 0000 0000 .... = Starting Sequence Number: 0

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e5 06   .....H..........
0010  00 00 d0 00 3a 01 c6 93 00 11 01 8a 78 d6 f0 09   ....:.......x...
0020  a2 27 c6 93 00 11 01 8a a0 13 03 00 3f 02 10 00   .'..........?...
0030  00 00 00                                          ...

No.     Time        Source                Destination           Protocol Length Info
   5884 45.420390   SamsungE_09:a2:27     c6:93:00:11:01:8a     802.11   51     Action, SN=314, FN=0, Flags=....R...

Frame 5884: 51 bytes on wire (408 bits), 51 bytes captured (408 bits)
    Arrival Time: Nov 25, 2012 15:58:07.297856000 CET
    Epoch Time: 1353855487.297856000 seconds
    [Time delta from previous captured frame: 0.001094000 seconds]
    [Time delta from previous displayed frame: 0.001094000 seconds]
    [Time since reference or first frame: 45.420390000 seconds]
    Frame Number: 5884
    Frame Length: 51 bytes (408 bits)
    Capture Length: 51 bytes (408 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -27 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Action, Flags: ....R...
    Type/Subtype: Action (0x0d)
    Frame Control: 0x08D0 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 13
        Flags: 0x8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Source address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    BSS Id: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Fragment number: 0
    Sequence number: 314
IEEE 802.11 wireless LAN management frame
    Fixed parameters
        Action: 0x03
            Category code: Block Ack (3)
            Action code: Add Block Ack Request (0x00)
            Dialog token: 0x3f
            Block Ack Parameters: 0x1002
                .... .... .... ...0 = A-MSDUs: Not Permitted
                .... .... .... ..1. = Block Ack Policy: Immediate Block Ack
                .... .... ..00 00.. = Traffic Identifier: 0x0000
                0001 0000 00.. .... = Number of Buffers (1 Buffer = 2304 Bytes): 64
            Block Ack Timeout: 0x0000
            Block Ack Starting Sequence Control (SSC): 0x0000
                .... .... .... 0000 = Fragment: 0
                0000 0000 0000 .... = Starting Sequence Number: 0

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e5 06   .....H..........
0010  00 00 d0 08 3a 01 c6 93 00 11 01 8a 78 d6 f0 09   ....:.......x...
0020  a2 27 c6 93 00 11 01 8a a0 13 03 00 3f 02 10 00   .'..........?...
0030  00 00 00                                          ...

No.     Time        Source                Destination           Protocol Length Info
   5885 45.420727                         SamsungE_09:a2:27 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 5885: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:07.298193000 CET
    Epoch Time: 1353855487.298193000 seconds
    [Time delta from previous captured frame: 0.000337000 seconds]
    [Time delta from previous displayed frame: 0.000337000 seconds]
    [Time since reference or first frame: 45.420727000 seconds]
    Frame Number: 5885
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -30 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e2 06   .....H..........
0010  00 00 d4 00 00 00 78 d6 f0 09 a2 27               ......x....'

No.     Time        Source                Destination           Protocol Length Info
   5886 45.421040   0.0.0.0               255.255.255.255       DHCP     383    DHCP Discover - Transaction ID 0xf9c1c881

Frame 5886: 383 bytes on wire (3064 bits), 383 bytes captured (3064 bits)
    Arrival Time: Nov 25, 2012 15:58:07.298506000 CET
    Epoch Time: 1353855487.298506000 seconds
    [Time delta from previous captured frame: 0.000313000 seconds]
    [Time delta from previous displayed frame: 0.000313000 seconds]
    [Time since reference or first frame: 45.421040000 seconds]
    Frame Number: 5886
    Frame Length: 383 bytes (3064 bits)
    Capture Length: 383 bytes (3064 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan:llc:ip:udp:bootp]
    [Coloring Rule Name: UDP]
    [Coloring Rule String: udp]
Radiotap Header v0, Length 21
    Header revision: 0
    Header pad: 0
    Header length: 21
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .0.. = Rate: False
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 1... .... .... .... .... = HT information: True
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11g (0x0480)
        .... .... ...0 .... = Turbo: False
        .... .... ..0. .... = Complementary Code Keying (CCK): False
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .1.. .... .... = Dynamic CCK-OFDM: True
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -32 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
    MCS information
        Known MCS information: 0x07
            .... ...1 = Bandwidth: True
            .... ..1. = MCS index: True
            .... .1.. = Guard interval: True
            .... 0... = Format: False
            ...0 .... = FEC: False
        .... ..00 = Bandwidth: 20 MHz (0)
        .... .0.. = Guard interval: long (0)
        MCS index: 7
    [Data Rate: 65.0 Mb/s]
IEEE 802.11 QoS Data, Flags: .......T
    Type/Subtype: QoS Data (0x28)
    Frame Control: 0x0188 (Normal)
        Version: 0
        Type: Data frame (2)
        Subtype: 8
        Flags: 0x1
            .... ..01 = DS status: Frame from STA to DS via an AP (To DS: 1 From DS: 0) (0x01)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 44
    BSS Id: c6:93:00:11:01:8a (c6:93:00:11:01:8a)
    Source address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Destination address: Broadcast (ff:ff:ff:ff:ff:ff)
    Fragment number: 0
    Sequence number: 0
    QoS Control
        TID: 0
        Priority: 0 (Best Effort) (Best Effort)
        ...0 .... = QoS bit 4: Bits 8-15 of QoS Control field are TXOP Duration Requested
        Ack Policy: Normal Ack (0x00)
        Payload Type: MSDU
        TXOP Duration Requested: no TXOP requested (0)
Logical-Link Control
    DSAP: SNAP (0xaa)
    IG Bit: Individual
    SSAP: SNAP (0xaa)
    CR Bit: Command
    Control field: U, func=UI (0x03)
        000. 00.. = Command: Unnumbered Information (0x00)
        .... ..11 = Frame type: Unnumbered frame (0x03)
    Organization Code: Encapsulated Ethernet (0x000000)
    Type: IP (0x0800)
Internet Protocol Version 4, Src: 0.0.0.0 (0.0.0.0), Dst: 255.255.255.255 (255.255.255.255)
    Version: 4
    Header length: 20 bytes
    Differentiated Services Field: 0x00 (DSCP 0x00: Default; ECN: 0x00: Not-ECT (Not ECN-Capable Transport))
        0000 00.. = Differentiated Services Codepoint: Default (0x00)
        .... ..00 = Explicit Congestion Notification: Not-ECT (Not ECN-Capable Transport) (0x00)
    Total Length: 328
    Identification: 0x19bc (6588)
    Flags: 0x00
        0... .... = Reserved bit: Not set
        .0.. .... = Don't fragment: Not set
        ..0. .... = More fragments: Not set
    Fragment offset: 0
    Time to live: 64
    Protocol: UDP (17)
    Header checksum: 0x5fea [correct]
        [Good: True]
        [Bad: False]
    Source: 0.0.0.0 (0.0.0.0)
    Destination: 255.255.255.255 (255.255.255.255)
User Datagram Protocol, Src Port: bootpc (68), Dst Port: bootps (67)
    Source port: bootpc (68)
    Destination port: bootps (67)
    Length: 308
    Checksum: 0x2c15 [validation disabled]
        [Good Checksum: False]
        [Bad Checksum: False]
Bootstrap Protocol
    Message type: Boot Request (1)
    Hardware type: Ethernet
    Hardware address length: 6
    Hops: 0
    Transaction ID: 0xf9c1c881
    Seconds elapsed: 12
    Bootp flags: 0x0000 (Unicast)
        0... .... .... .... = Broadcast flag: Unicast
        .000 0000 0000 0000 = Reserved flags: 0x0000
    Client IP address: 0.0.0.0 (0.0.0.0)
    Your (client) IP address: 0.0.0.0 (0.0.0.0)
    Next server IP address: 0.0.0.0 (0.0.0.0)
    Relay agent IP address: 0.0.0.0 (0.0.0.0)
    Client MAC address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Client hardware address padding: 00000000000000000000
    Server host name not given
    Boot file name not given
    Magic cookie: DHCP
    Option: (t=53,l=1) DHCP Message Type = DHCP Discover
        Option: (53) DHCP Message Type
        Length: 1
        Value: 01
    Option: (t=57,l=2) Maximum DHCP Message Size = 1500
        Option: (57) Maximum DHCP Message Size
        Length: 2
        Value: 05dc
    Option: (t=60,l=13) Vendor class identifier = "dhcpcd-5.2.10"
        Option: (60) Vendor class identifier
        Length: 13
        Value: 6468637063642d352e322e3130
    Option: (t=12,l=23) Host Name = "android-d10e0707d32ffd1"
        Option: (12) Host Name
        Length: 23
        Value: 616e64726f69642d643130653037303764333266666431
    Option: (t=55,l=9) Parameter Request List
        Option: (55) Parameter Request List
        Length: 9
        Value: 012103060f1c333a3b
        1 = Subnet Mask
        33 = Static Route
        3 = Router
        6 = Domain Name Server
        15 = Domain Name
        28 = Broadcast Address
        51 = IP Address Lease Time
        58 = Renewal Time Value
        59 = Rebinding Time Value
    End Option
    Padding

0000  00 00 15 00 2a 48 08 00 00 00 99 09 80 04 e0 06   ....*H..........
0010  00 00 07 00 07 88 01 2c 00 c6 93 00 11 01 8a 78   .......,.......x
0020  d6 f0 09 a2 27 ff ff ff ff ff ff 00 00 00 00 aa   ....'...........
0030  aa 03 00 00 00 08 00 45 00 01 48 19 bc 00 00 40   .......E..H....@
0040  11 5f ea 00 00 00 00 ff ff ff ff 00 44 00 43 01   ._..........D.C.
0050  34 2c 15 01 01 06 00 f9 c1 c8 81 00 0c 00 00 00   4,..............
0060  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 78   ...............x
0070  d6 f0 09 a2 27 00 00 00 00 00 00 00 00 00 00 00   ....'...........
0080  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0090  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
00a0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
00b0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
00c0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
00d0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
00e0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
00f0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0100  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0110  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0120  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0130  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 63   ...............c
0140  82 53 63 35 01 01 39 02 05 dc 3c 0d 64 68 63 70   .Sc5..9...<.dhcp
0150  63 64 2d 35 2e 32 2e 31 30 0c 17 61 6e 64 72 6f   cd-5.2.10..andro
0160  69 64 2d 64 31 30 65 30 37 30 37 64 33 32 66 66   id-d10e0707d32ff
0170  64 31 37 09 01 21 03 06 0f 1c 33 3a 3b ff 00      d17..!....3:;..

No.     Time        Source                Destination           Protocol Length Info
   5887 45.421051                         SamsungE_09:a2:27 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 5887: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:07.298517000 CET
    Epoch Time: 1353855487.298517000 seconds
    [Time delta from previous captured frame: 0.000011000 seconds]
    [Time delta from previous displayed frame: 0.000011000 seconds]
    [Time since reference or first frame: 45.421051000 seconds]
    Frame Number: 5887
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 6.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11g (pure-g) (0x00c0)
        .... .... ...0 .... = Turbo: False
        .... .... ..0. .... = Complementary Code Keying (CCK): False
        .... .... .1.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): True
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -30 dBm
    Antenna: 6
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)

0000  00 00 12 00 2e 48 00 00 00 0c 99 09 c0 00 e2 06   .....H..........
0010  00 00 d4 00 00 00 78 d6 f0 09 a2 27               ......x....'

--mhOzvPhkurUs4vA9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wlan0-bad.hostapd.txt"

STA 78:d6:f0:09:a2:27 sent probe request for our SSID
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
Add randomness: count=11 entropy=10
nl80211: Event message available
nl80211: MLME event 60 (NL80211_CMD_REGISTER_FRAME)
mgmt::proberesp cb
nl80211: Event message available
nl80211: MLME event 60 (NL80211_CMD_REGISTER_FRAME)
mgmt::proberesp cb
nl80211: Event message available
nl80211: MLME event 59 (NL80211_CMD_SET_TX_BITRATE_MASK)
mgmt::auth
authentication: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
ap_sta_add: register ap_handle_timer timeout for 78:d6:f0:09:a2:27 (300 seconds - ap_max_inactivity)
authentication reply: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
nl80211: Frame TX command accepted; cookie 0x81a089c0
Add randomness: count=12 entropy=11
nl80211: Event message available
nl80211: MLME event 59 (NL80211_CMD_SET_TX_BITRATE_MASK)
mgmt::auth
authentication: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=1 status_code=0 wep=0
authentication reply: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
nl80211: Frame TX command accepted; cookie 0x80e246c0
Add randomness: count=13 entropy=12
nl80211: Event message available
nl80211: MLME event 59 (NL80211_CMD_SET_TX_BITRATE_MASK)
mgmt::auth
authentication: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=1 status_code=0 wep=0
authentication reply: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
nl80211: Frame TX command accepted; cookie 0x81a05b40
Add randomness: count=14 entropy=13
nl80211: Event message available
nl80211: MLME event 60 (NL80211_CMD_REGISTER_FRAME)
mgmt::auth cb
wlan0: STA 78:d6:f0:09:a2:27 IEEE 802.11: did not acknowledge authentication response
nl80211: Event message available
nl80211: MLME event 60 (NL80211_CMD_REGISTER_FRAME)
mgmt::auth cb
wlan0: STA 78:d6:f0:09:a2:27 IEEE 802.11: did not acknowledge authentication response
nl80211: Event message available
nl80211: MLME event 60 (NL80211_CMD_REGISTER_FRAME)
mgmt::auth cb
wlan0: STA 78:d6:f0:09:a2:27 IEEE 802.11: did not acknowledge authentication response
nl80211: Event message available
nl80211: MLME event 59 (NL80211_CMD_SET_TX_BITRATE_MASK)
mgmt::auth
authentication: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=1 status_code=0 wep=0
authentication reply: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
nl80211: Frame TX command accepted; cookie 0x81936480
Add randomness: count=15 entropy=14
nl80211: Event message available
nl80211: MLME event 59 (NL80211_CMD_SET_TX_BITRATE_MASK)
mgmt::auth
authentication: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=1 status_code=0 wep=0
authentication reply: STA=78:d6:f0:09:a2:27 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
nl80211: Frame TX command accepted; cookie 0x81937540
Add randomness: count=16 entropy=15
nl80211: Event message available
nl80211: MLME event 59 (NL80211_CMD_SET_TX_BITRATE_MASK)

--mhOzvPhkurUs4vA9
Content-Type: application/cap
Content-Disposition: attachment; filename="wlan0-bad.pcap"
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAP//AAB/AAAAITKyUCpEBQCZAAAAmQAAAAAAEgAuSAAAAAKZCaAA
6QQAAAAAOgHEkwARAYh41vAJoifEkwARAYgwLSEECgAACXdsYW4wLWJhZAEIgoSLliQwSGwy
BAwSGGAtGiwYG/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAA3QkAEBgCAAAAAADdHgCQTDMsGBv/
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAN0HAFDyAgABACEyslBJRwUAMAAAADAAAAAAABIALkgA
AAACmQmgAOIEAACwCDoBeNbwCaInxJMAEQGIxJMAEQGI4G0AAAIAAAAhMrJQpEgFABwAAAAc
AAAAAAASAC5IAAAAApkJoADpBAAA1AAAAMSTABEBiCEyslCfSgUAMAAAADAAAAAAABIALkgA
AAACmQmgAOEEAACwCDoBeNbwCaInxJMAEQGIxJMAEQGI4G0AAAIAAAAhMrJQ30sFABwAAAAc
AAAAAAASAC5IAAAAApkJoADoBAAA1AAAAMSTABEBiCEyslDzTQUAMAAAADAAAAAAABIALkgA
AAACmQmgAOEEAACwCDoBeNbwCaInxJMAEQGIxJMAEQGI4G0AAAIAAAAhMrJQPU8FABwAAAAc
AAAAAAASAC5IAAAAApkJoADoBAAA1AAAAMSTABEBiCEyslBEUQUAMAAAADAAAAAAABIALkgA
AAACmQmgAOEEAACwCDoBeNbwCaInxJMAEQGIxJMAEQGI4G0AAAIAAAAhMrJQilIFABwAAAAc
AAAAAAASAC5IAAAAApkJoADoBAAA1AAAAMSTABEBiCEyslCHVAUAMAAAADAAAAAAABIALkgA
AAACmQmgAOEEAACwCDoBeNbwCaInxJMAEQGIxJMAEQGI4G0AAAIAAAAhMrJQzVUFABwAAAAc
AAAAAAASAC5IAAAAApkJoADoBAAA1AAAAMSTABEBiCEyslDFWgUAjgAAAI4AAAAAABIALkgA
AAACmQmgAOEEAAAQADoBeNbwCaInxJMAEQGIxJMAEQGI8G0BBAAAAcABCIKEi5YMEhgkMgQw
SGBsLRp8ARP/AAAAAQAAAAAAAAADAAAAAAAAAAAAAD0WCgAEAAAAAAAAAAAAAAAAAAAAAAAA
AN0YAFDyAgEBAAADpAAAJ6QAAEJDXgBiMi8AITKyUPRbBQAcAAAAHAAAAAAAEgAuSAAAAAKZ
CaAA6QQAANQAAADEkwARAYghMrJQ82AFAI4AAACOAAAAAAASAC5IAAAAApkJoADhBAAAEAg6
AXjW8AmiJ8STABEBiMSTABEBiPBtAQQAAAHAAQiChIuWDBIYJDIEMEhgbC0afAET/wAAAAEA
AAAAAAAAAwAAAAAAAAAAAAA9FgoABAAAAAAAAAAAAAAAAAAAAAAAAADdGABQ8gIBAQAAA6QA
ACekAABCQ14AYjIvACEyslBcZgUAmQAAAJkAAAAAABIALkgAAAACmQmgAOkEAAAACDoBxJMA
EQGIeNbwCaInxJMAEQGIMC0hBAoAAAl3bGFuMC1iYWQBCIKEi5YkMEhsMgQMEhhgLRosGBv/
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAN0JABAYAgAAAAAA3R4AkEwzLBgb/wAAAAAAAAAAAAAA
AAAAAAAAAAAAAADdBwBQ8gIAAQAhMrJQWmwFAI4AAACOAAAAAAASAC5IAAAAApkJoADhBAAA
EAg6AXjW8AmiJ8STABEBiMSTABEBiPBtAQQAAAHAAQiChIuWDBIYJDIEMEhgbC0afAET/wAA
AAEAAAAAAAAAAwAAAAAAAAAAAAA9FgoABAAAAAAAAAAAAAAAAAAAAAAAAADdGABQ8gIBAQAA
A6QAACekAABCQ14AYjIvAA==

--mhOzvPhkurUs4vA9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wlan0-bad.txt"

No.     Time        Source                Destination           Protocol Length Info
  10011 79.467664   SamsungE_09:a2:27     8devices_11:01:88     802.11   153    Association Request, SN=723, FN=0, Flags=........, SSID=wlan0-bad

Frame 10011: 153 bytes on wire (1224 bits), 153 bytes captured (1224 bits)
    Arrival Time: Nov 25, 2012 15:58:41.345130000 CET
    Epoch Time: 1353855521.345130000 seconds
    [Time delta from previous captured frame: 0.001400000 seconds]
    [Time delta from previous displayed frame: 0.001400000 seconds]
    [Time since reference or first frame: 79.467664000 seconds]
    Frame Number: 10011
    Frame Length: 153 bytes (1224 bits)
    Capture Length: 153 bytes (1224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -23 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Association Request, Flags: ........
    Type/Subtype: Association Request (0x00)
    Frame Control: 0x0000 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 0
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: 8devices_11:01:88 (c4:93:00:11:01:88)
    Source address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 723
IEEE 802.11 wireless LAN management frame
    Fixed parameters (4 bytes)
        Capabilities Information: 0x0421
            .... .... .... ...1 = ESS capabilities: Transmitter is an AP
            .... .... .... ..0. = IBSS status: Transmitter belongs to a BSS
            .... ..0. .... 00.. = CFP participation capabilities: No point coordinator at AP (0x0000)
            .... .... ...0 .... = Privacy: AP/STA cannot support WEP
            .... .... ..1. .... = Short Preamble: Short preamble allowed
            .... .... .0.. .... = PBCC: PBCC modulation not allowed
            .... .... 0... .... = Channel Agility: Channel agility not in use
            .... ...0 .... .... = Spectrum Management: dot11SpectrumManagementRequired FALSE
            .... .1.. .... .... = Short Slot Time: Short slot time in use
            .... 0... .... .... = Automatic Power Save Delivery: apsd not implemented
            ..0. .... .... .... = DSSS-OFDM: DSSS-OFDM modulation not allowed
            .0.. .... .... .... = Delayed Block Ack: delayed block ack not implemented
            0... .... .... .... = Immediate Block Ack: immediate block ack not implemented
        Listen Interval: 0x000a
    Tagged parameters (107 bytes)
        Tag: SSID parameter set: wlan0-bad
            Tag Number: SSID parameter set (0)
            Tag length: 9
            SSID: wlan0-bad
        Tag: Supported Rates 1(B), 2(B), 5.5(B), 11(B), 18, 24, 36, 54, [Mbit/sec]
            Tag Number: Supported Rates (1)
            Tag length: 8
            Supported Rates: 1(B)
            Supported Rates: 2(B)
            Supported Rates: 5.5(B)
            Supported Rates: 11(B)
            Supported Rates: 18
            Supported Rates: 24
            Supported Rates: 36
            Supported Rates: 54
        Tag: Extended Supported Rates 6, 9, 12, 48, [Mbit/sec]
            Tag Number: Extended Supported Rates (50)
            Tag length: 4
            Extented Supported Rates: 6
            Extented Supported Rates: 9
            Extented Supported Rates: 12
            Extented Supported Rates: 48
        Tag: HT Capabilities (802.11n D1.10)
            Tag Number: HT Capabilities (802.11n D1.10) (45)
            Tag length: 26
            HT Capabilities Info: 0x182c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...0 .... = HT Green Field: Transmitter is not able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .0.. .... = HT Short GI for 40MHz: Not supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..00 .... .... = HT Rx STBC: No Rx STBC support (0x0000)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 1... .... .... = HT Max A-MSDU length: 7935 bytes
                ...1 .... .... .... = HT DSSS/CCK mode in 40MHz: Will/Can use DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters: 0x001b
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 10.. = MPDU Density: 8 [usec] (0x06)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set: MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities: 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities: 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities: 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: Vendor Specific: Broadcom
            Tag Number: Vendor Specific (221)
            Tag length: 9
            OUI: 00-10-18 (Broadcom)
            Vendor Specific OUI Type: 2
            Tag interpretation: Not interpreted
        Tag: Vendor Specific: Epigram: HT Capabilities (802.11n D1.10)
            Tag Number: Vendor Specific (221)
            Tag length: 30
            OUI: 00-90-4c (Epigram)
            Vendor Specific OUI Type: 51
            Tag interpretation: 802.11n (Pre) OUI
            Tag interpretation: 802.11n (Pre) HT information
            HT Capabilities Info (VS): 0x182c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...0 .... = HT Green Field: Transmitter is not able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .0.. .... = HT Short GI for 40MHz: Not supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..00 .... .... = HT Rx STBC: No Rx STBC support (0x0000)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 1... .... .... = HT Max A-MSDU length: 7935 bytes
                ...1 .... .... .... = HT DSSS/CCK mode in 40MHz: Will/Can use DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters (VS): 0x001b
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 10.. = MPDU Density: 8 [usec] (0x06)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set (VS): MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities (VS): 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities (VS): 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities (VS): 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: Vendor Specific: Microsof: WMM/WME: Information Element
            Tag Number: Vendor Specific (221)
            Tag length: 7
            OUI: 00-50-f2 (Microsof)
            Vendor Specific OUI Type: 2
            Type: WMM/WME (0x02)
            WME Subtype: Information Element (0)
            WME Version: 1
            WME QoS Info: 0x00
                .00. .... = Max SP Length: WMM AP may deliver all buffered frames (MSDUs and MMPDUs) (0x00)
                .... 0... = AC_BE: non-WMM PS
                .... .0.. = AC_BK: non-WMM PS
                .... ..0. = AC_VI: non-WMM PS
                .... ...0 = AC_VO: non-WMM PS
                0..0 .... = Reserved: 0x00

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e9 04   .....H..........
0010  00 00 00 00 3a 01 c4 93 00 11 01 88 78 d6 f0 09   ....:.......x...
0020  a2 27 c4 93 00 11 01 88 30 2d 21 04 0a 00 00 09   .'......0-!.....
0030  77 6c 61 6e 30 2d 62 61 64 01 08 82 84 8b 96 24   wlan0-bad......$
0040  30 48 6c 32 04 0c 12 18 60 2d 1a 2c 18 1b ff 00   0Hl2....`-.,....
0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0060  00 00 00 00 00 dd 09 00 10 18 02 00 00 00 00 00   ................
0070  dd 1e 00 90 4c 33 2c 18 1b ff 00 00 00 00 00 00   ....L3,.........
0080  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0090  dd 07 00 50 f2 02 00 01 00                        ...P.....

No.     Time        Source                Destination           Protocol Length Info
  10012 79.468463   8devices_11:01:88     SamsungE_09:a2:27     802.11   48     Authentication, SN=1758, FN=0, Flags=....R...

Frame 10012: 48 bytes on wire (384 bits), 48 bytes captured (384 bits)
    Arrival Time: Nov 25, 2012 15:58:41.345929000 CET
    Epoch Time: 1353855521.345929000 seconds
    [Time delta from previous captured frame: 0.000799000 seconds]
    [Time delta from previous displayed frame: 0.000799000 seconds]
    [Time since reference or first frame: 79.468463000 seconds]
    Frame Number: 10012
    Frame Length: 48 bytes (384 bits)
    Capture Length: 48 bytes (384 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -30 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Authentication, Flags: ....R...
    Type/Subtype: Authentication (0x0b)
    Frame Control: 0x08B0 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 11
        Flags: 0x8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: 8devices_11:01:88 (c4:93:00:11:01:88)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 1758
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Authentication Algorithm: Open System (0)
        Authentication SEQ: 0x0002
        Status code: Successful (0x0000)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e2 04   .....H..........
0010  00 00 b0 08 3a 01 78 d6 f0 09 a2 27 c4 93 00 11   ....:.x....'....
0020  01 88 c4 93 00 11 01 88 e0 6d 00 00 02 00 00 00   .........m......

No.     Time        Source                Destination           Protocol Length Info
  10013 79.468810                         8devices_11:01:88 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 10013: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:41.346276000 CET
    Epoch Time: 1353855521.346276000 seconds
    [Time delta from previous captured frame: 0.000347000 seconds]
    [Time delta from previous displayed frame: 0.000347000 seconds]
    [Time since reference or first frame: 79.468810000 seconds]
    Frame Number: 10013
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -23 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: 8devices_11:01:88 (c4:93:00:11:01:88)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e9 04   .....H..........
0010  00 00 d4 00 00 00 c4 93 00 11 01 88               ............

No.     Time        Source                Destination           Protocol Length Info
  10014 79.469317   8devices_11:01:88     SamsungE_09:a2:27     802.11   48     Authentication, SN=1758, FN=0, Flags=....R...

Frame 10014: 48 bytes on wire (384 bits), 48 bytes captured (384 bits)
    Arrival Time: Nov 25, 2012 15:58:41.346783000 CET
    Epoch Time: 1353855521.346783000 seconds
    [Time delta from previous captured frame: 0.000507000 seconds]
    [Time delta from previous displayed frame: 0.000507000 seconds]
    [Time since reference or first frame: 79.469317000 seconds]
    Frame Number: 10014
    Frame Length: 48 bytes (384 bits)
    Capture Length: 48 bytes (384 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -31 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Authentication, Flags: ....R...
    Type/Subtype: Authentication (0x0b)
    Frame Control: 0x08B0 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 11
        Flags: 0x8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: 8devices_11:01:88 (c4:93:00:11:01:88)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 1758
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Authentication Algorithm: Open System (0)
        Authentication SEQ: 0x0002
        Status code: Successful (0x0000)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e1 04   .....H..........
0010  00 00 b0 08 3a 01 78 d6 f0 09 a2 27 c4 93 00 11   ....:.x....'....
0020  01 88 c4 93 00 11 01 88 e0 6d 00 00 02 00 00 00   .........m......

No.     Time        Source                Destination           Protocol Length Info
  10015 79.469637                         8devices_11:01:88 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 10015: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:41.347103000 CET
    Epoch Time: 1353855521.347103000 seconds
    [Time delta from previous captured frame: 0.000320000 seconds]
    [Time delta from previous displayed frame: 0.000320000 seconds]
    [Time since reference or first frame: 79.469637000 seconds]
    Frame Number: 10015
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -24 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: 8devices_11:01:88 (c4:93:00:11:01:88)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e8 04   .....H..........
0010  00 00 d4 00 00 00 c4 93 00 11 01 88               ............

No.     Time        Source                Destination           Protocol Length Info
  10016 79.470169   8devices_11:01:88     SamsungE_09:a2:27     802.11   48     Authentication, SN=1758, FN=0, Flags=....R...

Frame 10016: 48 bytes on wire (384 bits), 48 bytes captured (384 bits)
    Arrival Time: Nov 25, 2012 15:58:41.347635000 CET
    Epoch Time: 1353855521.347635000 seconds
    [Time delta from previous captured frame: 0.000532000 seconds]
    [Time delta from previous displayed frame: 0.000532000 seconds]
    [Time since reference or first frame: 79.470169000 seconds]
    Frame Number: 10016
    Frame Length: 48 bytes (384 bits)
    Capture Length: 48 bytes (384 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -31 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Authentication, Flags: ....R...
    Type/Subtype: Authentication (0x0b)
    Frame Control: 0x08B0 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 11
        Flags: 0x8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: 8devices_11:01:88 (c4:93:00:11:01:88)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 1758
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Authentication Algorithm: Open System (0)
        Authentication SEQ: 0x0002
        Status code: Successful (0x0000)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e1 04   .....H..........
0010  00 00 b0 08 3a 01 78 d6 f0 09 a2 27 c4 93 00 11   ....:.x....'....
0020  01 88 c4 93 00 11 01 88 e0 6d 00 00 02 00 00 00   .........m......

No.     Time        Source                Destination           Protocol Length Info
  10017 79.470499                         8devices_11:01:88 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 10017: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:41.347965000 CET
    Epoch Time: 1353855521.347965000 seconds
    [Time delta from previous captured frame: 0.000330000 seconds]
    [Time delta from previous displayed frame: 0.000330000 seconds]
    [Time since reference or first frame: 79.470499000 seconds]
    Frame Number: 10017
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -24 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: 8devices_11:01:88 (c4:93:00:11:01:88)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e8 04   .....H..........
0010  00 00 d4 00 00 00 c4 93 00 11 01 88               ............

No.     Time        Source                Destination           Protocol Length Info
  10018 79.471018   8devices_11:01:88     SamsungE_09:a2:27     802.11   48     Authentication, SN=1758, FN=0, Flags=....R...

Frame 10018: 48 bytes on wire (384 bits), 48 bytes captured (384 bits)
    Arrival Time: Nov 25, 2012 15:58:41.348484000 CET
    Epoch Time: 1353855521.348484000 seconds
    [Time delta from previous captured frame: 0.000519000 seconds]
    [Time delta from previous displayed frame: 0.000519000 seconds]
    [Time since reference or first frame: 79.471018000 seconds]
    Frame Number: 10018
    Frame Length: 48 bytes (384 bits)
    Capture Length: 48 bytes (384 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -31 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Authentication, Flags: ....R...
    Type/Subtype: Authentication (0x0b)
    Frame Control: 0x08B0 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 11
        Flags: 0x8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: 8devices_11:01:88 (c4:93:00:11:01:88)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 1758
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Authentication Algorithm: Open System (0)
        Authentication SEQ: 0x0002
        Status code: Successful (0x0000)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e1 04   .....H..........
0010  00 00 b0 08 3a 01 78 d6 f0 09 a2 27 c4 93 00 11   ....:.x....'....
0020  01 88 c4 93 00 11 01 88 e0 6d 00 00 02 00 00 00   .........m......

No.     Time        Source                Destination           Protocol Length Info
  10019 79.471344                         8devices_11:01:88 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 10019: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:41.348810000 CET
    Epoch Time: 1353855521.348810000 seconds
    [Time delta from previous captured frame: 0.000326000 seconds]
    [Time delta from previous displayed frame: 0.000326000 seconds]
    [Time since reference or first frame: 79.471344000 seconds]
    Frame Number: 10019
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -24 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: 8devices_11:01:88 (c4:93:00:11:01:88)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e8 04   .....H..........
0010  00 00 d4 00 00 00 c4 93 00 11 01 88               ............

No.     Time        Source                Destination           Protocol Length Info
  10020 79.471853   8devices_11:01:88     SamsungE_09:a2:27     802.11   48     Authentication, SN=1758, FN=0, Flags=....R...

Frame 10020: 48 bytes on wire (384 bits), 48 bytes captured (384 bits)
    Arrival Time: Nov 25, 2012 15:58:41.349319000 CET
    Epoch Time: 1353855521.349319000 seconds
    [Time delta from previous captured frame: 0.000509000 seconds]
    [Time delta from previous displayed frame: 0.000509000 seconds]
    [Time since reference or first frame: 79.471853000 seconds]
    Frame Number: 10020
    Frame Length: 48 bytes (384 bits)
    Capture Length: 48 bytes (384 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -31 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Authentication, Flags: ....R...
    Type/Subtype: Authentication (0x0b)
    Frame Control: 0x08B0 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 11
        Flags: 0x8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: 8devices_11:01:88 (c4:93:00:11:01:88)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 1758
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Authentication Algorithm: Open System (0)
        Authentication SEQ: 0x0002
        Status code: Successful (0x0000)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e1 04   .....H..........
0010  00 00 b0 08 3a 01 78 d6 f0 09 a2 27 c4 93 00 11   ....:.x....'....
0020  01 88 c4 93 00 11 01 88 e0 6d 00 00 02 00 00 00   .........m......

No.     Time        Source                Destination           Protocol Length Info
  10021 79.472179                         8devices_11:01:88 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 10021: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:41.349645000 CET
    Epoch Time: 1353855521.349645000 seconds
    [Time delta from previous captured frame: 0.000326000 seconds]
    [Time delta from previous displayed frame: 0.000326000 seconds]
    [Time since reference or first frame: 79.472179000 seconds]
    Frame Number: 10021
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -24 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: 8devices_11:01:88 (c4:93:00:11:01:88)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e8 04   .....H..........
0010  00 00 d4 00 00 00 c4 93 00 11 01 88               ............

No.     Time        Source                Destination           Protocol Length Info
  10022 79.473451   8devices_11:01:88     SamsungE_09:a2:27     802.11   142    Association Response, SN=1759, FN=0, Flags=........

Frame 10022: 142 bytes on wire (1136 bits), 142 bytes captured (1136 bits)
    Arrival Time: Nov 25, 2012 15:58:41.350917000 CET
    Epoch Time: 1353855521.350917000 seconds
    [Time delta from previous captured frame: 0.001272000 seconds]
    [Time delta from previous displayed frame: 0.001272000 seconds]
    [Time since reference or first frame: 79.473451000 seconds]
    Frame Number: 10022
    Frame Length: 142 bytes (1136 bits)
    Capture Length: 142 bytes (1136 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -31 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Association Response, Flags: ........
    Type/Subtype: Association Response (0x01)
    Frame Control: 0x0010 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 1
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: 8devices_11:01:88 (c4:93:00:11:01:88)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 1759
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Capabilities Information: 0x0401
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
        Status code: Successful (0x0000)
        ..00 0000 0000 0001 = Association ID: 0x0001
    Tagged parameters (94 bytes)
        Tag: Supported Rates 1(B), 2(B), 5.5(B), 11(B), 6, 9, 12, 18, [Mbit/sec]
            Tag Number: Supported Rates (1)
            Tag length: 8
            Supported Rates: 1(B)
            Supported Rates: 2(B)
            Supported Rates: 5.5(B)
            Supported Rates: 11(B)
            Supported Rates: 6
            Supported Rates: 9
            Supported Rates: 12
            Supported Rates: 18
        Tag: Extended Supported Rates 24, 36, 48, 54, [Mbit/sec]
            Tag Number: Extended Supported Rates (50)
            Tag length: 4
            Extented Supported Rates: 24
            Extented Supported Rates: 36
            Extented Supported Rates: 48
            Extented Supported Rates: 54
        Tag: HT Capabilities (802.11n D1.10)
            Tag Number: HT Capabilities (802.11n D1.10) (45)
            Tag length: 26
            HT Capabilities Info: 0x017c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...1 .... = HT Green Field: Transmitter is able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .1.. .... = HT Short GI for 40MHz: Supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..01 .... .... = HT Rx STBC: Rx support of one spatial stream (0x0001)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 0... .... .... = HT Max A-MSDU length: 3839 bytes
                ...0 .... .... .... = HT DSSS/CCK mode in 40MHz: Won't/Can't use of DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters: 0x0013
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 00.. = MPDU Density: 2 [usec] (0x04)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set: MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...1 = Rx Bitmask Bit 32: 0x00000001
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...1 = Tx Supported MCS Set: Defined
                .... .... .... ..1. = Tx and Rx MCS Set: Not Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities: 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities: 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities: 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: HT Information (802.11n D1.10)
            Tag Number: HT Information (802.11n D1.10) (61)
            Tag length: 22
            Primary Channel: 10
            HT Information Subset (1 of 3): 0x00
                .... ..00 = Secondary channel offset: No secondary channel (0x00)
                .... .0.. = Supported channel width: 20 MHz channel width only
                .... 0... = Reduced Interframe Spacing (RIFS): Prohibited
                ...0 .... = Power Save Multi-Poll (PSMP) stations only: Association requests are accepted regardless of PSMP capability
                000. .... = Shortest service interval: 5 ms (0x00)
            HT Information Subset (2 of 3): 0x0004
                .... .... .... ..00 = Operating mode of BSS: All STAs are - 20/40 MHz HT or in a 20/40 MHz BSS or are 20 MHz HT in a 20 MHz BSS (0x0000)
                .... .... .... .1.. = Non-greenfield STAs present: One or more associated STAs are not greenfield capable
                .... .... .... 0... = Transmit burst limit: No limit
                .... .... ...0 .... = OBSS non-HT STAs present: Use of protection for non-HT STAs by overlapping BSSs is not needed
                0000 0000 000. .... = Reserved: 0x0000
            HT Information Subset (3 of 3): 0x0000
                .... .... ..00 0000 = Reserved: 0x0000
                .... .... .0.. .... = Dual beacon: No second beacon is transmitted
                .... .... 0... .... = Dual Clear To Send (CTS) protection: Not required
                .... ...0 .... .... = Beacon ID: Primary beacon
                .... ..0. .... .... = L-SIG TXOP Protection Full Support: One or more HT STAs in the BSS do not support L-SIG TXOP protection
                .... .0.. .... .... = Phased Coexistence Operation (PCO): Inactive
                .... 0... .... .... = Phased Coexistence Operation (PCO) Phase: Switch to or continue 20 MHz phase
                0000 .... .... .... = Reserved: 0x0000
            Rx Supported Modulation and Coding Scheme Set: Basic MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 0000 0000 = Rx Bitmask Bits 0-7: 0x00000000
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
        Tag: Vendor Specific: Microsof: WMM/WME: Parameter Element
            Tag Number: Vendor Specific (221)
            Tag length: 24
            OUI: 00-50-f2 (Microsof)
            Vendor Specific OUI Type: 2
            Type: WMM/WME (0x02)
            WME Subtype: Parameter Element (1)
            WME Version: 1
            WME QoS Info: 0x00
                0... .... = U-APSD: Disabled
                .... 0000 = Parameter Set Count: 0x00
                .000 .... = Reserved: 0x00
            Reserved: 00
            Ac Parameters ACI 0 (Best Effort), ACM no , AIFSN 3, ECWmin 4 ,ECWmax 10, TXOP 0
                ACI / AIFSN Field: 0x03
                    .00. .... = ACI: Best Effort (0)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0011 = AIFSN: 3
                    0... .... = Reserved: 0
                ECW: 0xa4
                    1010 .... = ECW Max: 10
                    .... 0100 = ECW Min: 4
                TXOP Limit: 0
            Ac Parameters ACI 1 (Background), ACM no , AIFSN 7, ECWmin 4 ,ECWmax 10, TXOP 0
                ACI / AIFSN Field: 0x27
                    .01. .... = ACI: Background (1)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0111 = AIFSN: 7
                    0... .... = Reserved: 0
                ECW: 0xa4
                    1010 .... = ECW Max: 10
                    .... 0100 = ECW Min: 4
                TXOP Limit: 0
            Ac Parameters ACI 2 (Video), ACM no , AIFSN 2, ECWmin 3 ,ECWmax 4, TXOP 94
                ACI / AIFSN Field: 0x42
                    .10. .... = ACI: Video (2)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0010 = AIFSN: 2
                    0... .... = Reserved: 0
                ECW: 0x43
                    0100 .... = ECW Max: 4
                    .... 0011 = ECW Min: 3
                TXOP Limit: 94
            Ac Parameters ACI 3 (Voice), ACM no , AIFSN 2, ECWmin 2 ,ECWmax 3, TXOP 47
                ACI / AIFSN Field: 0x62
                    .11. .... = ACI: Voice (3)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0010 = AIFSN: 2
                    0... .... = Reserved: 0
                ECW: 0x32
                    0011 .... = ECW Max: 3
                    .... 0010 = ECW Min: 2
                TXOP Limit: 47

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e1 04   .....H..........
0010  00 00 10 00 3a 01 78 d6 f0 09 a2 27 c4 93 00 11   ....:.x....'....
0020  01 88 c4 93 00 11 01 88 f0 6d 01 04 00 00 01 c0   .........m......
0030  01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c   .........$2.0H`l
0040  2d 1a 7c 01 13 ff 00 00 00 01 00 00 00 00 00 00   -.|.............
0050  00 03 00 00 00 00 00 00 00 00 00 00 3d 16 0a 00   ............=...
0060  04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0070  00 00 00 00 dd 18 00 50 f2 02 01 01 00 00 03 a4   .......P........
0080  00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00         ..'...BC^.b2/.

No.     Time        Source                Destination           Protocol Length Info
  10023 79.473754                         8devices_11:01:88 (RA) 802.11   28     Acknowledgement, Flags=........

Frame 10023: 28 bytes on wire (224 bits), 28 bytes captured (224 bits)
    Arrival Time: Nov 25, 2012 15:58:41.351220000 CET
    Epoch Time: 1353855521.351220000 seconds
    [Time delta from previous captured frame: 0.000303000 seconds]
    [Time delta from previous displayed frame: 0.000303000 seconds]
    [Time since reference or first frame: 79.473754000 seconds]
    Frame Number: 10023
    Frame Length: 28 bytes (224 bits)
    Capture Length: 28 bytes (224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -23 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Acknowledgement, Flags: ........
    Type/Subtype: Acknowledgement (0x1d)
    Frame Control: 0x00D4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 13
        Flags: 0x0
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Receiver address: 8devices_11:01:88 (c4:93:00:11:01:88)

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e9 04   .....H..........
0010  00 00 d4 00 00 00 c4 93 00 11 01 88               ............

No.     Time        Source                Destination           Protocol Length Info
  10024 79.475033   8devices_11:01:88     SamsungE_09:a2:27     802.11   142    Association Response, SN=1759, FN=0, Flags=....R...

Frame 10024: 142 bytes on wire (1136 bits), 142 bytes captured (1136 bits)
    Arrival Time: Nov 25, 2012 15:58:41.352499000 CET
    Epoch Time: 1353855521.352499000 seconds
    [Time delta from previous captured frame: 0.001279000 seconds]
    [Time delta from previous displayed frame: 0.001279000 seconds]
    [Time since reference or first frame: 79.475033000 seconds]
    Frame Number: 10024
    Frame Length: 142 bytes (1136 bits)
    Capture Length: 142 bytes (1136 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -31 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Association Response, Flags: ....R...
    Type/Subtype: Association Response (0x01)
    Frame Control: 0x0810 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 1
        Flags: 0x8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: 8devices_11:01:88 (c4:93:00:11:01:88)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 1759
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Capabilities Information: 0x0401
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
        Status code: Successful (0x0000)
        ..00 0000 0000 0001 = Association ID: 0x0001
    Tagged parameters (94 bytes)
        Tag: Supported Rates 1(B), 2(B), 5.5(B), 11(B), 6, 9, 12, 18, [Mbit/sec]
            Tag Number: Supported Rates (1)
            Tag length: 8
            Supported Rates: 1(B)
            Supported Rates: 2(B)
            Supported Rates: 5.5(B)
            Supported Rates: 11(B)
            Supported Rates: 6
            Supported Rates: 9
            Supported Rates: 12
            Supported Rates: 18
        Tag: Extended Supported Rates 24, 36, 48, 54, [Mbit/sec]
            Tag Number: Extended Supported Rates (50)
            Tag length: 4
            Extented Supported Rates: 24
            Extented Supported Rates: 36
            Extented Supported Rates: 48
            Extented Supported Rates: 54
        Tag: HT Capabilities (802.11n D1.10)
            Tag Number: HT Capabilities (802.11n D1.10) (45)
            Tag length: 26
            HT Capabilities Info: 0x017c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...1 .... = HT Green Field: Transmitter is able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .1.. .... = HT Short GI for 40MHz: Supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..01 .... .... = HT Rx STBC: Rx support of one spatial stream (0x0001)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 0... .... .... = HT Max A-MSDU length: 3839 bytes
                ...0 .... .... .... = HT DSSS/CCK mode in 40MHz: Won't/Can't use of DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters: 0x0013
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 00.. = MPDU Density: 2 [usec] (0x04)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set: MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...1 = Rx Bitmask Bit 32: 0x00000001
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...1 = Tx Supported MCS Set: Defined
                .... .... .... ..1. = Tx and Rx MCS Set: Not Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities: 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities: 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities: 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: HT Information (802.11n D1.10)
            Tag Number: HT Information (802.11n D1.10) (61)
            Tag length: 22
            Primary Channel: 10
            HT Information Subset (1 of 3): 0x00
                .... ..00 = Secondary channel offset: No secondary channel (0x00)
                .... .0.. = Supported channel width: 20 MHz channel width only
                .... 0... = Reduced Interframe Spacing (RIFS): Prohibited
                ...0 .... = Power Save Multi-Poll (PSMP) stations only: Association requests are accepted regardless of PSMP capability
                000. .... = Shortest service interval: 5 ms (0x00)
            HT Information Subset (2 of 3): 0x0004
                .... .... .... ..00 = Operating mode of BSS: All STAs are - 20/40 MHz HT or in a 20/40 MHz BSS or are 20 MHz HT in a 20 MHz BSS (0x0000)
                .... .... .... .1.. = Non-greenfield STAs present: One or more associated STAs are not greenfield capable
                .... .... .... 0... = Transmit burst limit: No limit
                .... .... ...0 .... = OBSS non-HT STAs present: Use of protection for non-HT STAs by overlapping BSSs is not needed
                0000 0000 000. .... = Reserved: 0x0000
            HT Information Subset (3 of 3): 0x0000
                .... .... ..00 0000 = Reserved: 0x0000
                .... .... .0.. .... = Dual beacon: No second beacon is transmitted
                .... .... 0... .... = Dual Clear To Send (CTS) protection: Not required
                .... ...0 .... .... = Beacon ID: Primary beacon
                .... ..0. .... .... = L-SIG TXOP Protection Full Support: One or more HT STAs in the BSS do not support L-SIG TXOP protection
                .... .0.. .... .... = Phased Coexistence Operation (PCO): Inactive
                .... 0... .... .... = Phased Coexistence Operation (PCO) Phase: Switch to or continue 20 MHz phase
                0000 .... .... .... = Reserved: 0x0000
            Rx Supported Modulation and Coding Scheme Set: Basic MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 0000 0000 = Rx Bitmask Bits 0-7: 0x00000000
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
        Tag: Vendor Specific: Microsof: WMM/WME: Parameter Element
            Tag Number: Vendor Specific (221)
            Tag length: 24
            OUI: 00-50-f2 (Microsof)
            Vendor Specific OUI Type: 2
            Type: WMM/WME (0x02)
            WME Subtype: Parameter Element (1)
            WME Version: 1
            WME QoS Info: 0x00
                0... .... = U-APSD: Disabled
                .... 0000 = Parameter Set Count: 0x00
                .000 .... = Reserved: 0x00
            Reserved: 00
            Ac Parameters ACI 0 (Best Effort), ACM no , AIFSN 3, ECWmin 4 ,ECWmax 10, TXOP 0
                ACI / AIFSN Field: 0x03
                    .00. .... = ACI: Best Effort (0)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0011 = AIFSN: 3
                    0... .... = Reserved: 0
                ECW: 0xa4
                    1010 .... = ECW Max: 10
                    .... 0100 = ECW Min: 4
                TXOP Limit: 0
            Ac Parameters ACI 1 (Background), ACM no , AIFSN 7, ECWmin 4 ,ECWmax 10, TXOP 0
                ACI / AIFSN Field: 0x27
                    .01. .... = ACI: Background (1)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0111 = AIFSN: 7
                    0... .... = Reserved: 0
                ECW: 0xa4
                    1010 .... = ECW Max: 10
                    .... 0100 = ECW Min: 4
                TXOP Limit: 0
            Ac Parameters ACI 2 (Video), ACM no , AIFSN 2, ECWmin 3 ,ECWmax 4, TXOP 94
                ACI / AIFSN Field: 0x42
                    .10. .... = ACI: Video (2)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0010 = AIFSN: 2
                    0... .... = Reserved: 0
                ECW: 0x43
                    0100 .... = ECW Max: 4
                    .... 0011 = ECW Min: 3
                TXOP Limit: 94
            Ac Parameters ACI 3 (Voice), ACM no , AIFSN 2, ECWmin 2 ,ECWmax 3, TXOP 47
                ACI / AIFSN Field: 0x62
                    .11. .... = ACI: Voice (3)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0010 = AIFSN: 2
                    0... .... = Reserved: 0
                ECW: 0x32
                    0011 .... = ECW Max: 3
                    .... 0010 = ECW Min: 2
                TXOP Limit: 47

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e1 04   .....H..........
0010  00 00 10 08 3a 01 78 d6 f0 09 a2 27 c4 93 00 11   ....:.x....'....
0020  01 88 c4 93 00 11 01 88 f0 6d 01 04 00 00 01 c0   .........m......
0030  01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c   .........$2.0H`l
0040  2d 1a 7c 01 13 ff 00 00 00 01 00 00 00 00 00 00   -.|.............
0050  00 03 00 00 00 00 00 00 00 00 00 00 3d 16 0a 00   ............=...
0060  04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0070  00 00 00 00 dd 18 00 50 f2 02 01 01 00 00 03 a4   .......P........
0080  00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00         ..'...BC^.b2/.

No.     Time        Source                Destination           Protocol Length Info
  10025 79.476418   SamsungE_09:a2:27     8devices_11:01:88     802.11   153    Association Request, SN=723, FN=0, Flags=....R..., SSID=wlan0-bad

Frame 10025: 153 bytes on wire (1224 bits), 153 bytes captured (1224 bits)
    Arrival Time: Nov 25, 2012 15:58:41.353884000 CET
    Epoch Time: 1353855521.353884000 seconds
    [Time delta from previous captured frame: 0.001385000 seconds]
    [Time delta from previous displayed frame: 0.001385000 seconds]
    [Time since reference or first frame: 79.476418000 seconds]
    Frame Number: 10025
    Frame Length: 153 bytes (1224 bits)
    Capture Length: 153 bytes (1224 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -23 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Association Request, Flags: ....R...
    Type/Subtype: Association Request (0x00)
    Frame Control: 0x0800 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 0
        Flags: 0x8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: 8devices_11:01:88 (c4:93:00:11:01:88)
    Source address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 723
IEEE 802.11 wireless LAN management frame
    Fixed parameters (4 bytes)
        Capabilities Information: 0x0421
            .... .... .... ...1 = ESS capabilities: Transmitter is an AP
            .... .... .... ..0. = IBSS status: Transmitter belongs to a BSS
            .... ..0. .... 00.. = CFP participation capabilities: No point coordinator at AP (0x0000)
            .... .... ...0 .... = Privacy: AP/STA cannot support WEP
            .... .... ..1. .... = Short Preamble: Short preamble allowed
            .... .... .0.. .... = PBCC: PBCC modulation not allowed
            .... .... 0... .... = Channel Agility: Channel agility not in use
            .... ...0 .... .... = Spectrum Management: dot11SpectrumManagementRequired FALSE
            .... .1.. .... .... = Short Slot Time: Short slot time in use
            .... 0... .... .... = Automatic Power Save Delivery: apsd not implemented
            ..0. .... .... .... = DSSS-OFDM: DSSS-OFDM modulation not allowed
            .0.. .... .... .... = Delayed Block Ack: delayed block ack not implemented
            0... .... .... .... = Immediate Block Ack: immediate block ack not implemented
        Listen Interval: 0x000a
    Tagged parameters (107 bytes)
        Tag: SSID parameter set: wlan0-bad
            Tag Number: SSID parameter set (0)
            Tag length: 9
            SSID: wlan0-bad
        Tag: Supported Rates 1(B), 2(B), 5.5(B), 11(B), 18, 24, 36, 54, [Mbit/sec]
            Tag Number: Supported Rates (1)
            Tag length: 8
            Supported Rates: 1(B)
            Supported Rates: 2(B)
            Supported Rates: 5.5(B)
            Supported Rates: 11(B)
            Supported Rates: 18
            Supported Rates: 24
            Supported Rates: 36
            Supported Rates: 54
        Tag: Extended Supported Rates 6, 9, 12, 48, [Mbit/sec]
            Tag Number: Extended Supported Rates (50)
            Tag length: 4
            Extented Supported Rates: 6
            Extented Supported Rates: 9
            Extented Supported Rates: 12
            Extented Supported Rates: 48
        Tag: HT Capabilities (802.11n D1.10)
            Tag Number: HT Capabilities (802.11n D1.10) (45)
            Tag length: 26
            HT Capabilities Info: 0x182c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...0 .... = HT Green Field: Transmitter is not able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .0.. .... = HT Short GI for 40MHz: Not supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..00 .... .... = HT Rx STBC: No Rx STBC support (0x0000)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 1... .... .... = HT Max A-MSDU length: 7935 bytes
                ...1 .... .... .... = HT DSSS/CCK mode in 40MHz: Will/Can use DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters: 0x001b
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 10.. = MPDU Density: 8 [usec] (0x06)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set: MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities: 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities: 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities: 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: Vendor Specific: Broadcom
            Tag Number: Vendor Specific (221)
            Tag length: 9
            OUI: 00-10-18 (Broadcom)
            Vendor Specific OUI Type: 2
            Tag interpretation: Not interpreted
        Tag: Vendor Specific: Epigram: HT Capabilities (802.11n D1.10)
            Tag Number: Vendor Specific (221)
            Tag length: 30
            OUI: 00-90-4c (Epigram)
            Vendor Specific OUI Type: 51
            Tag interpretation: 802.11n (Pre) OUI
            Tag interpretation: 802.11n (Pre) HT information
            HT Capabilities Info (VS): 0x182c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...0 .... = HT Green Field: Transmitter is not able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .0.. .... = HT Short GI for 40MHz: Not supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..00 .... .... = HT Rx STBC: No Rx STBC support (0x0000)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 1... .... .... = HT Max A-MSDU length: 7935 bytes
                ...1 .... .... .... = HT DSSS/CCK mode in 40MHz: Will/Can use DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters (VS): 0x001b
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 10.. = MPDU Density: 8 [usec] (0x06)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set (VS): MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities (VS): 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities (VS): 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities (VS): 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: Vendor Specific: Microsof: WMM/WME: Information Element
            Tag Number: Vendor Specific (221)
            Tag length: 7
            OUI: 00-50-f2 (Microsof)
            Vendor Specific OUI Type: 2
            Type: WMM/WME (0x02)
            WME Subtype: Information Element (0)
            WME Version: 1
            WME QoS Info: 0x00
                .00. .... = Max SP Length: WMM AP may deliver all buffered frames (MSDUs and MMPDUs) (0x00)
                .... 0... = AC_BE: non-WMM PS
                .... .0.. = AC_BK: non-WMM PS
                .... ..0. = AC_VI: non-WMM PS
                .... ...0 = AC_VO: non-WMM PS
                0..0 .... = Reserved: 0x00

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e9 04   .....H..........
0010  00 00 00 08 3a 01 c4 93 00 11 01 88 78 d6 f0 09   ....:.......x...
0020  a2 27 c4 93 00 11 01 88 30 2d 21 04 0a 00 00 09   .'......0-!.....
0030  77 6c 61 6e 30 2d 62 61 64 01 08 82 84 8b 96 24   wlan0-bad......$
0040  30 48 6c 32 04 0c 12 18 60 2d 1a 2c 18 1b ff 00   0Hl2....`-.,....
0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0060  00 00 00 00 00 dd 09 00 10 18 02 00 00 00 00 00   ................
0070  dd 1e 00 90 4c 33 2c 18 1b ff 00 00 00 00 00 00   ....L3,.........
0080  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0090  dd 07 00 50 f2 02 00 01 00                        ...P.....

No.     Time        Source                Destination           Protocol Length Info
  10026 79.477952   8devices_11:01:88     SamsungE_09:a2:27     802.11   142    Association Response, SN=1759, FN=0, Flags=....R...

Frame 10026: 142 bytes on wire (1136 bits), 142 bytes captured (1136 bits)
    Arrival Time: Nov 25, 2012 15:58:41.355418000 CET
    Epoch Time: 1353855521.355418000 seconds
    [Time delta from previous captured frame: 0.001534000 seconds]
    [Time delta from previous displayed frame: 0.001534000 seconds]
    [Time since reference or first frame: 79.477952000 seconds]
    Frame Number: 10026
    Frame Length: 142 bytes (1136 bits)
    Capture Length: 142 bytes (1136 bits)
    [Frame is marked: True]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 18
    Header revision: 0
    Header pad: 0
    Header length: 18
    Present flags
        .... .... .... .... .... .... .... ...0 = TSFT: False
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = dBm Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = dBm Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = dB TX Attenuation: False
        .... .... .... .... .... .0.. .... .... = dBm TX Power: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = dB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = dB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    Flags: 0x00
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...0 .... = FCS at end: False
        ..0. .... = Data Pad: False
        .0.. .... = Bad FCS: False
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2457 [BG 10]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -31 dBm
    Antenna: 4
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Association Response, Flags: ....R...
    Type/Subtype: Association Response (0x01)
    Frame Control: 0x0810 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 1
        Flags: 0x8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 314
    Destination address: SamsungE_09:a2:27 (78:d6:f0:09:a2:27)
    Source address: 8devices_11:01:88 (c4:93:00:11:01:88)
    BSS Id: 8devices_11:01:88 (c4:93:00:11:01:88)
    Fragment number: 0
    Sequence number: 1759
IEEE 802.11 wireless LAN management frame
    Fixed parameters (6 bytes)
        Capabilities Information: 0x0401
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
        Status code: Successful (0x0000)
        ..00 0000 0000 0001 = Association ID: 0x0001
    Tagged parameters (94 bytes)
        Tag: Supported Rates 1(B), 2(B), 5.5(B), 11(B), 6, 9, 12, 18, [Mbit/sec]
            Tag Number: Supported Rates (1)
            Tag length: 8
            Supported Rates: 1(B)
            Supported Rates: 2(B)
            Supported Rates: 5.5(B)
            Supported Rates: 11(B)
            Supported Rates: 6
            Supported Rates: 9
            Supported Rates: 12
            Supported Rates: 18
        Tag: Extended Supported Rates 24, 36, 48, 54, [Mbit/sec]
            Tag Number: Extended Supported Rates (50)
            Tag length: 4
            Extented Supported Rates: 24
            Extented Supported Rates: 36
            Extented Supported Rates: 48
            Extented Supported Rates: 54
        Tag: HT Capabilities (802.11n D1.10)
            Tag Number: HT Capabilities (802.11n D1.10) (45)
            Tag length: 26
            HT Capabilities Info: 0x017c
                .... .... .... ...0 = HT LDPC coding capability: Transmitter does not support receiving LDPC coded packets
                .... .... .... ..0. = HT Support channel width: Transmitter only supports 20MHz operation
                .... .... .... 11.. = HT SM Power Save: SM Power Save disabled (0x0003)
                .... .... ...1 .... = HT Green Field: Transmitter is able to receive PPDUs with Green Field (GF) preamble
                .... .... ..1. .... = HT Short GI for 20MHz: Supported
                .... .... .1.. .... = HT Short GI for 40MHz: Supported
                .... .... 0... .... = HT Tx STBC: Not supported
                .... ..01 .... .... = HT Rx STBC: Rx support of one spatial stream (0x0001)
                .... .0.. .... .... = HT Delayed Block ACK: Transmitter does not support HT-Delayed BlockAck
                .... 0... .... .... = HT Max A-MSDU length: 3839 bytes
                ...0 .... .... .... = HT DSSS/CCK mode in 40MHz: Won't/Can't use of DSSS/CCK in 40 MHz
                ..0. .... .... .... = HT PSMP Support: Won't/Can't support PSMP operation
                .0.. .... .... .... = HT Forty MHz Intolerant: Use of 40 MHz transmissions unrestricted/allowed
                0... .... .... .... = HT L-SIG TXOP Protection support: Not supported
            A-MPDU Parameters: 0x0013
                .... ..11 = Maximum Rx A-MPDU Length: 65535 [Bytes]
                ...1 00.. = MPDU Density: 2 [usec] (0x04)
                000. .... = Reserved: 0x00
            Rx Supported Modulation and Coding Scheme Set: MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 1111 1111 = Rx Bitmask Bits 0-7: 0x000000ff
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...1 = Rx Bitmask Bit 32: 0x00000001
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...1 = Tx Supported MCS Set: Defined
                .... .... .... ..1. = Tx and Rx MCS Set: Not Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
            HT Extended Capabilities: 0x0000
                .... .... .... ...0 = Transmitter supports PCO: Not supported
                .... .... .... .00. = Time needed to transition between 20MHz and 40MHz: No Transition (0x0000)
                .... ..00 .... .... = MCS Feedback capability: STA does not provide MCS feedback (0x0000)
                .... .0.. .... .... = High Throughput: Not supported
                .... 0... .... .... = Reverse Direction Responder: Not supported
            Transmit Beam Forming (TxBF) Capabilities: 0x0000
                .... .... .... .... .... .... .... ...0 = Transmit Beamforming: Not supported
                .... .... .... .... .... .... .... ..0. = Receive Staggered Sounding: Not supported
                .... .... .... .... .... .... .... .0.. = Transmit Staggered Sounding: Not supported
                .... .... .... .... .... .... .... 0... = Receive Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ...0 .... = Transmit Null Data packet (NDP): Not supported
                .... .... .... .... .... .... ..0. .... = Implicit TxBF capable: Not supported
                .... .... .... .... .... .... 00.. .... = Calibration: incapable (0x00000000)
                .... .... .... .... .... ...0 .... .... = STA can apply TxBF using CSI explicit feedback: Not supported
                .... .... .... .... .... ..0. .... .... = STA can apply TxBF using uncompressed beamforming feedback matrix: Not supported
                .... .... .... .... .... .0.. .... .... = STA can apply TxBF using compressed beamforming feedback matrix: Not supported
                .... .... .... .... ...0 0... .... .... = Receiver can return explicit CSI feedback: not supported (0x00000000)
                .... .... .... .... .00. .... .... .... = Receiver can return explicit uncompressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... ...0 0... .... .... .... = STA can compress and use compressed Beamforming Feedback Matrix: not supported (0x00000000)
                .... .... .... .00. .... .... .... .... = Minimal grouping used for explicit feedback reports: No grouping supported (0x00000000)
                .... .... ...0 0... .... .... .... .... = Max antennae STA can support when CSI feedback required: 1 TX antenna sounding (0x00000000)
                .... .... .00. .... .... .... .... .... = Max antennae STA can support when uncompressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... ...0 0... .... .... .... .... .... = Max antennae STA can support when compressed Beamforming feedback required: 1 TX antenna sounding (0x00000000)
                .... .00. .... .... .... .... .... .... = Maximum number of rows of CSI explicit feedback: 1 row of CSI (0x00000000)
                ...0 0... .... .... .... .... .... .... = Maximum number of space time streams for which channel dimensions can be simultaneously estimated: 1 space time stream (0x00000000)
                000. .... .... .... .... .... .... .... = Reserved: 0x00000000
            Antenna Selection (ASEL) Capabilities: 0x00
                .... ...0 = Antenna Selection Capable: Not supported
                .... ..0. = Explicit CSI Feedback Based Tx ASEL: Not supported
                .... .0.. = Antenna Indices Feedback Based Tx ASEL: Not supported
                .... 0... = Explicit CSI Feedback: Not supported
                ...0 .... = Antenna Indices Feedback: Not supported
                ..0. .... = Rx ASEL: Not supported
                .0.. .... = Tx Sounding PPDUs: Not supported
                0... .... = Reserved: 0x00
        Tag: HT Information (802.11n D1.10)
            Tag Number: HT Information (802.11n D1.10) (61)
            Tag length: 22
            Primary Channel: 10
            HT Information Subset (1 of 3): 0x00
                .... ..00 = Secondary channel offset: No secondary channel (0x00)
                .... .0.. = Supported channel width: 20 MHz channel width only
                .... 0... = Reduced Interframe Spacing (RIFS): Prohibited
                ...0 .... = Power Save Multi-Poll (PSMP) stations only: Association requests are accepted regardless of PSMP capability
                000. .... = Shortest service interval: 5 ms (0x00)
            HT Information Subset (2 of 3): 0x0004
                .... .... .... ..00 = Operating mode of BSS: All STAs are - 20/40 MHz HT or in a 20/40 MHz BSS or are 20 MHz HT in a 20 MHz BSS (0x0000)
                .... .... .... .1.. = Non-greenfield STAs present: One or more associated STAs are not greenfield capable
                .... .... .... 0... = Transmit burst limit: No limit
                .... .... ...0 .... = OBSS non-HT STAs present: Use of protection for non-HT STAs by overlapping BSSs is not needed
                0000 0000 000. .... = Reserved: 0x0000
            HT Information Subset (3 of 3): 0x0000
                .... .... ..00 0000 = Reserved: 0x0000
                .... .... .0.. .... = Dual beacon: No second beacon is transmitted
                .... .... 0... .... = Dual Clear To Send (CTS) protection: Not required
                .... ...0 .... .... = Beacon ID: Primary beacon
                .... ..0. .... .... = L-SIG TXOP Protection Full Support: One or more HT STAs in the BSS do not support L-SIG TXOP protection
                .... .0.. .... .... = Phased Coexistence Operation (PCO): Inactive
                .... 0... .... .... = Phased Coexistence Operation (PCO) Phase: Switch to or continue 20 MHz phase
                0000 .... .... .... = Reserved: 0x0000
            Rx Supported Modulation and Coding Scheme Set: Basic MCS Set
                Tag interpretation: Rx Modulation and Coding Scheme (One bit per modulation)
                    .... .... .... .... .... .... 0000 0000 = Rx Bitmask Bits 0-7: 0x00000000
                    .... .... .... .... 0000 0000 .... .... = Rx Bitmask Bits 8-15: 0x00000000
                    .... .... 0000 0000 .... .... .... .... = Rx Bitmask Bits 16-23: 0x00000000
                    0000 0000 .... .... .... .... .... .... = Rx Bitmask Bits 24-31: 0x00000000
                    .... .... .... .... .... .... .... ...0 = Rx Bitmask Bit 32: 0x00000000
                    .... .... .... .... .... .... .000 000. = Rx Bitmask Bits 33-38: 0x00000000
                    .... .... ...0 0000 0000 0000 0... .... = Rx Bitmask Bits 39-52: 0x00000000
                    ...0 0000 0000 0000 0000 0000 000. .... = Rx Bitmask Bits 53-76: 0x00000000
                Highest Supported Data Rate: 0x0000
                .... .... .... ...0 = Tx Supported MCS Set: Not Defined
                .... .... .... ..0. = Tx and Rx MCS Set: Equal
                .... .... .... 00.. = Tx Maximum Number of Spatial Streams Supported: 1 spatial stream (0x0000)
                .... .... ...0 .... = Unequal Modulation: Not supported
        Tag: Vendor Specific: Microsof: WMM/WME: Parameter Element
            Tag Number: Vendor Specific (221)
            Tag length: 24
            OUI: 00-50-f2 (Microsof)
            Vendor Specific OUI Type: 2
            Type: WMM/WME (0x02)
            WME Subtype: Parameter Element (1)
            WME Version: 1
            WME QoS Info: 0x00
                0... .... = U-APSD: Disabled
                .... 0000 = Parameter Set Count: 0x00
                .000 .... = Reserved: 0x00
            Reserved: 00
            Ac Parameters ACI 0 (Best Effort), ACM no , AIFSN 3, ECWmin 4 ,ECWmax 10, TXOP 0
                ACI / AIFSN Field: 0x03
                    .00. .... = ACI: Best Effort (0)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0011 = AIFSN: 3
                    0... .... = Reserved: 0
                ECW: 0xa4
                    1010 .... = ECW Max: 10
                    .... 0100 = ECW Min: 4
                TXOP Limit: 0
            Ac Parameters ACI 1 (Background), ACM no , AIFSN 7, ECWmin 4 ,ECWmax 10, TXOP 0
                ACI / AIFSN Field: 0x27
                    .01. .... = ACI: Background (1)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0111 = AIFSN: 7
                    0... .... = Reserved: 0
                ECW: 0xa4
                    1010 .... = ECW Max: 10
                    .... 0100 = ECW Min: 4
                TXOP Limit: 0
            Ac Parameters ACI 2 (Video), ACM no , AIFSN 2, ECWmin 3 ,ECWmax 4, TXOP 94
                ACI / AIFSN Field: 0x42
                    .10. .... = ACI: Video (2)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0010 = AIFSN: 2
                    0... .... = Reserved: 0
                ECW: 0x43
                    0100 .... = ECW Max: 4
                    .... 0011 = ECW Min: 3
                TXOP Limit: 94
            Ac Parameters ACI 3 (Voice), ACM no , AIFSN 2, ECWmin 2 ,ECWmax 3, TXOP 47
                ACI / AIFSN Field: 0x62
                    .11. .... = ACI: Voice (3)
                    ...0 .... = Admission Control Mandatory: No
                    .... 0010 = AIFSN: 2
                    0... .... = Reserved: 0
                ECW: 0x32
                    0011 .... = ECW Max: 3
                    .... 0010 = ECW Min: 2
                TXOP Limit: 47

0000  00 00 12 00 2e 48 00 00 00 02 99 09 a0 00 e1 04   .....H..........
0010  00 00 10 08 3a 01 78 d6 f0 09 a2 27 c4 93 00 11   ....:.x....'....
0020  01 88 c4 93 00 11 01 88 f0 6d 01 04 00 00 01 c0   .........m......
0030  01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c   .........$2.0H`l
0040  2d 1a 7c 01 13 ff 00 00 00 01 00 00 00 00 00 00   -.|.............
0050  00 03 00 00 00 00 00 00 00 00 00 00 3d 16 0a 00   ............=...
0060  04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0070  00 00 00 00 dd 18 00 50 f2 02 01 01 00 00 03 a4   .......P........
0080  00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00         ..'...BC^.b2/.

--mhOzvPhkurUs4vA9--
