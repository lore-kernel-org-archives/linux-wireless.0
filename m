Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:57815 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZAMTex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:34:53 -0500
Received: by ewy10 with SMTP id 10so223114ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:34:51 -0800 (PST)
Message-ID: <496CECD6.5060802@gmail.com> (sfid-20090113_203459_363340_A75784E1)
Date: Tue, 13 Jan 2009 20:34:46 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
Subject: p54usb and hostapd
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[resend w/ correct list address this time]

>> > hmm... OT: who old is your hostapd version? As far as I can tell AP-mode is still WIP.
> 
> hostap-0_6_6-148-g3cf8523 ie git build from ~ dec 24.
> 
>> > Maybe you can save you alot trouble if your mobile can connect to ad-hoc wifis.
> 
> It can, but i'd like to try to get hostap running w/ this hw anyway...
> 
>>>>> >>>> so to test the device further i set up hostapd, which mostly worked; after 
>>>>> >>>> a few tweaks (eg patching out country code setting in hostapd)
>>>> >>> patching out country code?! why that?
>>>> >>> currently, hostapd is the only thing that works out-of-the-box :-D
>>> >> hostapd was aborting no matter what country code i configured, so i
>>> >> disabled that, leaving figuring this out for later.
>> > have you installed crda and udev on your box?
>> > ( http://wireless.kernel.org/en/developers/Regulatory/CRDA )
> 
> yes, but only after patching hostapd; the lockups prevented further
> testing...
> 
>>> >> [also hostapd is reporting some TX failures, didn't investigate yet]
>> > TX failures? do you have hostapd's log of it?
> 
> I'll send it in a few minutes, as soon as i'll reproduce it.

[Hmm, hostapd seems to include sensitive info in its log like passphrase.]
I managed to connect the client and kill hostapd before it hang and the
log looks like this:

Configuration file: /xxx/xxx/xxx/hostapd.conf
ctrl_interface_group=0
Opening raw packet socket for ifindex 0
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
Failed to set country code
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=27 dBm
RATE[0] rate=10 flags=0x6
RATE[1] rate=20 flags=0x6
RATE[2] rate=55 flags=0x6
RATE[3] rate=110 flags=0x6
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Passive scanning not supported
Flushing old station entries
Deauthenticate all stations
Mode: IEEE 802.11g  Channel: 6  Frequency: 2437 MHz
Using interface ap0 with hwaddr 00:30:f1:12:34:56 and ssid 'xxxxxxxx'
SSID - hexdump_ascii(len=3):
[...]
PSK (ASCII passphrase) - hexdump_ascii(len=8):
[...]
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=16): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
Using existing control interface directory.
ap0: Setup of interface done.
MGMT (TX callback) ACK
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:53 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:76 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
MGMT
mgmt::auth
authentication: STA=xx:xx:xx:xx:xx:76 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
ap0: STA xx:xx:xx:xx:xx:76 IEEE 802.11: authentication OK (open system)
ap0: STA xx:xx:xx:xx:xx:76 MLME: MLME-AUTHENTICATE.indication(xx:xx:xx:xx:xx:76, OPEN_SYSTEM)
ap0: STA xx:xx:xx:xx:xx:76 MLME: MLME-DELETEKEYS.request(xx:xx:xx:xx:xx:76)
authentication reply: STA=xx:xx:xx:xx:xx:76 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
ap0: STA xx:xx:xx:xx:xx:76 IEEE 802.11: authenticated
MGMT
mgmt::assoc_req
association request: STA=xx:xx:xx:xx:xx:76 capab_info=0x431 listen_interval=3
WME IE - hexdump(len=7): 00 50 f2 02 00 01 00
Validating WME IE: OUI 00:50:f2  OUI type 2  OUI sub-type 0  version 1
  new AID 1
ap0: STA xx:xx:xx:xx:xx:76 IEEE 802.11: association OK (aid 1)
MGMT (TX callback) ACK
mgmt::assoc_resp cb
ap0: STA xx:xx:xx:xx:xx:76 IEEE 802.11: associated (aid 1)
ap0: STA xx:xx:xx:xx:xx:76 MLME: MLME-ASSOCIATE.indication(xx:xx:xx:xx:xx:76)
ap0: STA xx:xx:xx:xx:xx:76 MLME: MLME-DELETEKEYS.request(xx:xx:xx:xx:xx:76)
ap0: STA xx:xx:xx:xx:xx:76 WPA: event 1 notification
ap0: STA xx:xx:xx:xx:xx:76 WPA: start authentication
WPA: xx:xx:xx:xx:xx:76 WPA_PTK entering state INITIALIZE
ap0: STA xx:xx:xx:xx:xx:76 IEEE 802.1X: unauthorizing port
WPA: xx:xx:xx:xx:xx:76 WPA_PTK_GROUP entering state IDLE
WPA: xx:xx:xx:xx:xx:76 WPA_PTK entering state AUTHENTICATION
WPA: xx:xx:xx:xx:xx:76 WPA_PTK entering state AUTHENTICATION2
WPA: xx:xx:xx:xx:xx:76 WPA_PTK entering state INITPSK
WPA: xx:xx:xx:xx:xx:76 WPA_PTK entering state PTKSTART
ap0: STA xx:xx:xx:xx:xx:76 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 123 bytes from xx:xx:xx:xx:xx:76
   IEEE 802.1X: version=1 type=3 length=119
ap0: STA xx:xx:xx:xx:xx:76 WPA: received EAPOL-Key frame (2/4 Pairwise)
WPA: xx:xx:xx:xx:xx:76 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=xx:xx:xx:xx:xx:e6 A2=xx:xx:xx:xx:xx:76
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: xx:xx:xx:xx:xx:76 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: xx:xx:xx:xx:xx:76 WPA_PTK entering state PTKINITNEGOTIATING
ap0: STA xx:xx:xx:xx:xx:76 WPA: sending 3/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=24 keyidx=0 encr=0)
IEEE 802.1X: 99 bytes from xx:xx:xx:xx:xx:76
   IEEE 802.1X: version=1 type=3 length=95
ap0: STA xx:xx:xx:xx:xx:76 WPA: received EAPOL-Key frame (4/4 Pairwise)
WPA: xx:xx:xx:xx:xx:76 WPA_PTK entering state PTKINITDONE
ap0: STA xx:xx:xx:xx:xx:76 IEEE 802.1X: authorizing port
ap0: STA xx:xx:xx:xx:xx:76 RADIUS: starting accounting session 496CE665-00000000
ap0: STA xx:xx:xx:xx:xx:76 WPA: pairwise key handshake completed (WPA)
WPA: xx:xx:xx:xx:xx:76 WPA_PTK_GROUP entering state REKEYNEGOTIATING
ap0: STA xx:xx:xx:xx:xx:76 WPA: sending 1/2 msg of Group Key Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=16 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=24): [REMOVED]
ap0: STA xx:xx:xx:xx:xx:76 WPA: EAPOL-Key timeout
WPA: xx:xx:xx:xx:xx:76 WPA_PTK_GROUP entering state REKEYNEGOTIATING
ap0: STA xx:xx:xx:xx:xx:76 WPA: sending 1/2 msg of Group Key Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=16 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=24): [REMOVED]
IEEE 802.1X: 99 bytes from xx:xx:xx:xx:xx:76
   IEEE 802.1X: version=1 type=3 length=95
ap0: STA xx:xx:xx:xx:xx:76 WPA: received EAPOL-Key frame (2/2 Group)
WPA: xx:xx:xx:xx:xx:76 WPA_PTK_GROUP entering state REKEYESTABLISHED
ap0: STA xx:xx:xx:xx:xx:76 WPA: group key handshake completed (WPA)
WPA: xx:xx:xx:xx:xx:76 WPA_PTK_GROUP entering state IDLE
IEEE 802.1X: 99 bytes from xx:xx:xx:xx:xx:76
   IEEE 802.1X: version=1 type=3 length=95
ap0: STA xx:xx:xx:xx:xx:76 WPA: received EAPOL-Key 2/2 Group with unexpected replay counter
received replay counter - hexdump(len=8): 00 00 00 00 00 00 00 04
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:53 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:53 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
Signal 15 received - terminating
ap0: STA xx:xx:xx:xx:xx:76 MLME: MLME-DEAUTHENTICATE.indication(xx:xx:xx:xx:xx:76, 1)
ap0: STA xx:xx:xx:xx:xx:76 MLME: MLME-DELETEKEYS.request(xx:xx:xx:xx:xx:76)
Removing station xx:xx:xx:xx:xx:76
Flushing old station entries
Deauthenticate all stations


artur

