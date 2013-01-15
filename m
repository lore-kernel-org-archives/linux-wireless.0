Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:51451 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3AOWGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 17:06:37 -0500
Received: by mail-ie0-f172.google.com with SMTP id c13so1230215ieb.3
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2013 14:06:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
From: Robert Shade <robert.shade@gmail.com>
Date: Tue, 15 Jan 2013 17:06:16 -0500
Message-ID: <CAMgrJ3YQ5oua0MJvmVcbb-GuQ8Rr5vwAO3Jy1vs0w-VRRDdcMg@mail.gmail.com> (sfid-20130115_230641_516866_784168B3)
Subject: Auth Packet TX Delay
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm seeing a periodic issue where the device seems to get stuck in a
state where the TX of authentication packets is delayed so that
authentication fails.  The log snippet below shows the auth packets
getting queued after each "wlan0: send auth to XX", but they're not
actually sent until after it gives up and restarts scanning.  Once the
device gets into this state, it stays in a SCAN->AUTH->AUTH
FAILED->SCAN cycle indefinitely.  However, if I do a ifconfig wlan0
down, the device usually recovers and works correctly for a few minutes to
hours.

This is with the latest compat-drivers.  The authentication is EAP-TLS
and it's in an environment where it periodically roams using
wpa_supplicant's bgscan.

Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TX queue: 0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: tx ok 0x0 err 0x0 desc
0x10f eol 0x10f urn 0x0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TX queue: 1
Nov 20 11:24:33 MR89253 kernel: ath: phy0: tx ok 0x0 err 0x0 desc
0x10f eol 0x10f urn 0x0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TX queue: 2
Nov 20 11:24:33 MR89253 kernel: ath: phy0: tx ok 0x0 err 0x0 desc
0x10f eol 0x10f urn 0x0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TX queue: 3
Nov 20 11:24:33 MR89253 kernel: ath: phy0: tx ok 0x0 err 0x0 desc
0x10f eol 0x10f urn 0x0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TXQ, inactive queue: 4
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TXQ, inactive queue: 5
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TXQ, inactive queue: 6
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TXQ, inactive queue: 7
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TX queue: 8
Nov 20 11:24:33 MR89253 kernel: ath: phy0: tx ok 0x0 err 0x0 desc
0x10f eol 0x10f urn 0x0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Reset TX queue: 9
Nov 20 11:24:33 MR89253 kernel: ath: phy0: tx ok 0x0 err 0x0 desc
0x10f eol 0x10f urn 0x0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ver 64.1 opmode 2 chan 2437 Mhz/0xc0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ah->misc_mode 0x4
Nov 20 11:24:33 MR89253 kernel: ath: phy0: enabling ADC Gain Calibration
Nov 20 11:24:33 MR89253 kernel: ath: phy0: enabling ADC DC Calibration
Nov 20 11:24:33 MR89253 kernel: ath: phy0: enabling IQ Calibration
Nov 20 11:24:33 MR89253 kernel: ath: phy0: starting ADC Gain Calibration
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Enable MIB counters
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Restore history: opmode 2
chan 2437 Mhz/0xc0 is_scanning=0 ofdm:8 cck:6
Nov 20 11:24:33 MR89253 kernel: ath: phy0: **** ofdmlevel 8=>8,
rssi=67[lo=7 hi=40]
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ** ch 2437: level
3=>7[def:3] cycpwrThr1[level]=14 ini=6
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ** ch 2437: level
3=>7[def:3] cycpwrThr1Ext[level]=14 ini=6
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ANI parameters: SI=7,
ofdmWS=on FS=2 MRCcck=off listenTime=0 ofdmErrs=0 cckErrs=0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ** ch 2437: level
2=>6[def:2] firstep[level]=10 ini=2
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ** ch 2437: level
2=>6[def:2] firstep_low[level]=14 ini=6
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ANI parameters: SI=7,
ofdmWS=on FS=6 MRCcck=off listenTime=0 ofdmErrs=0 cckErrs=0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ** ch 2437: ofdm weak signal: on=>off
Nov 20 11:24:33 MR89253 kernel: ath: phy0: ANI parameters: SI=7,
ofdmWS=off FS=6 MRCcck=off listenTime=0 ofdmErrs=0 cckErrs=0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: **** ccklevel 6=>6,
rssi=67[lo=7 hi=40]
Nov 20 11:24:33 MR89253 kernel: ath: phy0: New interrupt mask 0xf4040071
Nov 20 11:24:33 MR89253 kernel: ath: phy0: new IMR 0x918404b0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Do not enable IER ref count -1
Nov 20 11:24:33 MR89253 kernel: ath: phy0: STA is not yet
associated..skipping beacon config
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Beacon already configured
for a station interface
Nov 20 11:24:33 MR89253 kernel: wlan0: Inserted STA 00:24:6c:74:0a:40
Nov 20 11:24:33 MR89253 kernel: wlan0: send auth to 00:24:6c:74:0a:40 (try 1/3)
Nov 20 11:24:33 MR89253 kernel: ath: phy0: transmitting packet, skb:
ffff880137846a80
Nov 20 11:24:33 MR89253 kernel: ath: phy0: qnum: 0, txq depth: 0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: TXDP[0] = 378480c8 (ffff8800378480c8)
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Enable TXE on queue: 0
Nov 20 11:24:33 MR89253 NetworkManager[1821]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: RTM_NEWLINK: operstate=0
ifi_flags=0x1003 ([UP])
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: RTM_NEWLINK,
IFLA_IFNAME: Interface 'wlan0' added
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: if_removed
already cleared - ignore event
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Event message available
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: New station
00:24:6c:74:0a:40
Nov 20 11:24:33 MR89253 kernel: wlan0: send auth to 00:24:6c:74:0a:40 (try 2/3)
Nov 20 11:24:33 MR89253 kernel: ath: phy0: transmitting packet, skb:
ffff8801265cc2c0
Nov 20 11:24:33 MR89253 kernel: ath: phy0: qnum: 0, txq depth: 1
Nov 20 11:24:33 MR89253 kernel: ath: phy0: link[0]
(ffff8800378480c8)=37847568 (ffff880037847568)
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Enable TXE on queue: 0
Nov 20 11:24:33 MR89253 kernel: wlan0: send auth to 00:24:6c:74:0a:40 (try 3/3)
Nov 20 11:24:33 MR89253 kernel: ath: phy0: transmitting packet, skb:
ffff8801261aac80
Nov 20 11:24:33 MR89253 kernel: ath: phy0: qnum: 0, txq depth: 2
Nov 20 11:24:33 MR89253 kernel: ath: phy0: link[0]
(ffff880037847568)=378465f8 (ffff8800378465f8)
Nov 20 11:24:33 MR89253 kernel: ath: phy0: Enable TXE on queue: 0
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Event message available
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Delete station
00:24:6c:74:0a:40
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Event message available
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: MLME event 37;
timeout with 00:24:6c:74:0a:40
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: wlan0: Event
AUTH_TIMED_OUT (14) received
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: wlan0: SME:
Authentication timed out
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: Added BSSID
00:24:6c:74:0a:40 into blacklist
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: wlan0: Another BSS in
this ESS has been seen; try it next
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: BSSID 00:24:6c:74:0a:40
blacklist count incremented to 2
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: wlan0: Setting scan
request: 0 sec 100000 usec
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: wlan0: State:
AUTHENTICATING -> DISCONNECTED
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]:
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: netlink: Operstate:
linkmode=-1, operstate=5
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: EAPOL: External
notification - portEnabled=0
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: EAPOL: Supplicant port
status: Unauthorized
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: EAPOL: External
notification - portValid=0
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: EAPOL: Supplicant port
status: Unauthorized
Nov 20 11:24:33 MR89253 kernel: wlan0: authentication with
00:24:6c:74:0a:40 timed out
Nov 20 11:24:33 MR89253 kernel: wlan0: Removed STA 00:24:6c:74:0a:40
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: dbus:
flush_object_timeout_handler: Timeout - sending changed properties of
object /fi/w1/wpa_supplicant1/Interfaces/1
Nov 20 11:24:33 MR89253 NetworkManager[1821]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: wlan0: State:
DISCONNECTED -> SCANNING
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: wlan0: Starting AP scan
for wildcard SSID
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2412 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2417 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2422 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2427 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2432 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2437 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2442 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2447 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2452 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2457 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2462 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2467 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2472 MHz
Nov 20 11:24:33 MR89253 wpa_supplicant[1841]: nl80211: Scan frequency 2484 MHz
Nov 20 11:24:34 MR89253 kernel: ath: phy0: AWAKE -> FULL-SLEEP
Nov 20 11:24:34 MR89253 kernel: wlan0: Destroyed STA 00:24:6c:74:0a:40
Nov 20 11:24:34 MR89253 kernel: ath: phy0: FULL-SLEEP -> AWAKE
Nov 20 11:24:34 MR89253 kernel: ath: phy0: AWAKE -> FULL-SLEEP
Nov 20 11:24:34 MR89253 kernel: ath: phy0: FULL-SLEEP -> AWAKE
Nov 20 11:24:34 MR89253 kernel: ath: phy0: Set channel: 2437 MHz type: 0
Nov 20 11:24:34 MR89253 kernel: ath: phy0: NF calibrated [ctl] [chain 0] is -50
Nov 20 11:24:34 MR89253 kernel: ath: phy0: NF[0] (-50) > MAX (-80),
correcting to MAX
Nov 20 11:24:34 MR89253 kernel: ath: phy0: NF calibrated [ctl] [chain 1] is -50
Nov 20 11:24:34 MR89253 kernel: ath: phy0: NF[1] (-50) > MAX (-80),
correcting to MAX
Nov 20 11:24:34 MR89253 kernel: ath: phy0: NF calibrated [ctl] [chain 2] is -50
Nov 20 11:24:34 MR89253 kernel: ath: phy0: NF[2] (-50) > MAX (-80),
correcting to MAX
Nov 20 11:24:34 MR89253 kernel: ath: phy0: Stopping ANI
Nov 20 11:24:34 MR89253 kernel: ath: phy0: disable IER
Nov 20 11:24:34 MR89253 kernel: ath: phy0: Disable MIB counters
Nov 20 11:24:34 MR89253 kernel: ath: phy0: TX complete: skb: ffff880137846a80
Nov 20 11:24:34 MR89253 kernel: ath: phy0: TX complete: skb: ffff8801265cc2c0
Nov 20 11:24:34 MR89253 kernel: ath: phy0: TX complete: skb: ffff8801261aac80

17:00.0 Network controller: Atheros Communications Inc. AR9160
Wireless Network Adapter [AR9001 802.11(a)bgn] (rev 01)
        Subsystem: Ubiquiti Networks, Inc. SR71-A 802.11abgn Wireless
Mini PCI Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fd5f0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=100mA
PME(D0+,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ath9k
        Kernel modules: ath9k

The last time I saw this on a device that I could debug with, I saw
the following in the log just before it entered this state:

Jan 15 16:36:53 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9860: 0x00048d21 & 0x00000001 != 0x00000000
Jan 15 16:36:53 MR89251 kernel: ath: phy1: Unable to reset channel,
reset status -5
Jan 15 16:36:53 MR89251 kernel: ath: phy1: Unable to set channel
Jan 15 16:36:54 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9c20: 0x00000000 & 0x00000001 != 0x00000001
Jan 15 16:36:54 MR89251 kernel: ath: phy1: Could not kill baseband RX
Jan 15 16:36:54 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9860: 0x00048d21 & 0x00000001 != 0x00000000
Jan 15 16:36:54 MR89251 kernel: ath: phy1: Unable to reset channel,
reset status -5
Jan 15 16:36:54 MR89251 kernel: ath: phy1: Unable to set channel
Jan 15 16:36:54 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9860: 0x00048d21 & 0x00000001 != 0x00000000
Jan 15 16:36:54 MR89251 kernel: ath: phy1: Unable to reset channel,
reset status -5
Jan 15 16:36:54 MR89251 kernel: ath: phy1: Unable to set channel
Jan 15 16:36:54 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9c20: 0x00000000 & 0x00000001 != 0x00000001
Jan 15 16:36:54 MR89251 kernel: ath: phy1: Could not kill baseband RX
Jan 15 16:36:54 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9860: 0x00048d21 & 0x00000001 != 0x00000000
Jan 15 16:36:54 MR89251 kernel: ath: phy1: Unable to reset channel,
reset status -5
Jan 15 16:36:54 MR89251 kernel: ath: phy1: Unable to set channel
Jan 15 16:36:55 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9860: 0x00048d21 & 0x00000001 != 0x00000000
Jan 15 16:36:55 MR89251 kernel: ath: phy1: Unable to reset channel,
reset status -5
Jan 15 16:36:55 MR89251 kernel: ath: phy1: Unable to set channel
Jan 15 16:36:55 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9c20: 0x00000000 & 0x00000001 != 0x00000001
Jan 15 16:36:55 MR89251 kernel: ath: phy1: Could not kill baseband RX
Jan 15 16:36:55 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9860: 0x00048d21 & 0x00000001 != 0x00000000
Jan 15 16:36:55 MR89251 kernel: ath: phy1: Unable to reset channel,
reset status -5
Jan 15 16:36:55 MR89251 kernel: ath: phy1: Unable to set channel
Jan 15 16:36:55 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9860: 0x00048d21 & 0x00000001 != 0x00000000
Jan 15 16:36:55 MR89251 kernel: ath: phy1: Unable to reset channel,
reset status -5
Jan 15 16:36:55 MR89251 kernel: ath: phy1: Unable to set channel
Jan 15 16:36:56 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9c20: 0x00000000 & 0x00000001 != 0x00000001
Jan 15 16:36:56 MR89251 kernel: ath: phy1: Could not kill baseband RX
Jan 15 16:36:56 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9860: 0x00048d21 & 0x00000001 != 0x00000000
Jan 15 16:36:56 MR89251 kernel: ath: phy1: Unable to reset channel,
reset status -5
Jan 15 16:36:56 MR89251 kernel: ath: phy1: Unable to set channel
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Event message available
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: New scan
results available
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Event
SCAN_RESULTS (3) received
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Associated on 2412 MHz
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Associated with
00:17:59:2c:c3:20
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Received scan
results (45 BSSes)
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Scan results
indicate BSS status with 00:17:59:2c:c3:20 as associated
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: New scan results available
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: bgscan simple: scan
result notification
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Selecting BSS
from priority group 0
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: 0:
00:17:59:2c:c3:20 ssid='l0c0m0t1v3' wpa_ie_len=24 rsn_ie_len=0
caps=0xc31 level=-56
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0:    selected based on WPA IE
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0:    selected BSS
00:17:59:2c:c3:20 ssid='l0c0m0t1v3'
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Checking for
other virtual interfaces sharing same radio (phy1) in
event_scan_results
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: dbus:
flush_object_timeout_handler: Timeout - sending changed properties of
object /fi/w1/wpa_supplicant1/Interfaces/1
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: RTM_NEWLINK: operstate=1
ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: RTM_NEWLINK,
IFLA_IFNAME: Interface 'wlan0' added
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: if_removed
already cleared - ignore event
Jan 15 16:36:56 MR89251 kernel: ath: phy1: timeout (100000 us) on reg
0x9860: 0x00048d21 & 0x00000001 != 0x00000000
Jan 15 16:36:56 MR89251 kernel: ath: phy1: Unable to reset channel,
reset status -5
Jan 15 16:36:56 MR89251 kernel: ath: phy1: Unable to set channel
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Event message available
Jan 15 16:36:56 MR89251 kernel: wlan0: Failed to send nullfunc to AP
00:17:59:2c:c3:20 after 500ms, disconnecting
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Event message available
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Delete station
00:17:59:2c:c3:20
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Event message available
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: MLME event 39
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: MLME event
frame - hexdump(len=26): c0 00 00 00 00 17 59 2c c3 20 00 15 6d 84 d7
14 00 17 59 2c c3 20 00 00 04 00
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: nl80211: Deauthenticate event
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Event DEAUTH (12) received
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Deauthentication
notification
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0:  * reason 4
(locally generated)
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0:  * address
00:17:59:2c:c3:20
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: Deauthentication frame
IE(s) - hexdump(len=0): [NULL]
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=00:17:59:2c:c3:20 reason=4
locally_generated=1
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Auto connect
enabled: try to reconnect (wps=0 wpa_state=9)
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Setting scan
request: 0 sec 100000 usec
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: Added BSSID
00:17:59:2c:c3:20 into blacklist
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Another BSS in
this ESS has been seen; try it next
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: BSSID 00:17:59:2c:c3:20
blacklist count incremented to 2
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Not rescheduling
scan to ensure that specific SSID scans occur
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]: wlan0: Disconnect event
- remove keys
Jan 15 16:36:56 MR89251 wpa_supplicant[1964]:
wpa_driver_nl80211_set_key: ifindex=13 alg=0 addr=(nil) key_idx=0
set_tx=0 seq_len=0 key_len=0
Jan 15 16:36:56 MR89251 kernel: wlan0: moving STA 00:17:59:2c:c3:20 to state 3
Jan 15 16:36:56 MR89251 kernel: wlan0: moving STA 00:17:59:2c:c3:20 to state 2
Jan 15 16:36:56 MR89251 kernel: wlan0: moving STA 00:17:59:2c:c3:20 to state 1
Jan 15 16:36:56 MR89251 kernel: wlan0: Removed STA 00:17:59:2c:c3:20
(goes into associate timeout loop)

Please let me know if you need any additional information or testing
done.  Thanks.
