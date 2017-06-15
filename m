Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.santannapisa.it ([193.205.80.98]:64171 "EHLO
        mail.santannapisa.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFOONF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 10:13:05 -0400
Received: from [10.30.2.127] (account fr.marino@santannapisa.it)
  by santannapisa.it (CommuniGate Pro WEBUSER 6.1.11)
  with HTTP id 121819314 for linux-wireless@vger.kernel.org; Thu, 15 Jun 2017 15:12:50 +0200
From: "Francesco Marino" <fr.marino@santannapisa.it>
Subject: WPA: EAPOL-Key timeout
To: linux-wireless@vger.kernel.org
Date: Thu, 15 Jun 2017 15:12:50 +0200
Message-ID: <web-121819319@ucs.santannapisa.it> (sfid-20170615_161309_453151_A9003597)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to use hostapd to set up a wifi access point 
on my Beaglebone Black. With no WPA security everything 
works fine. When I add WPA security, I can't log into my 
wifi network anymore.

This is my /etc/hostapd/hostapd.conf file

interface=wlan2
driver=nl80211
ssid=virtual_serial_port_br38400
hw_mode=g
channel=11
wpa=1
wpa_passphrase=password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
wpa_ptk_rekey=600

and this is hostapd log when I try to access the network 
through my smartphone.
There are several WPA: EAPOL-Key timeout error messages. 
How can I fix this problem?

nl80211: Frame TX command accepted; cookie 0xdcb23100
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) 
received for wlan2
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on 
wlan2(40:5d:82:d6:88:73) A1=ec:9b:f3:87:e1:1c 
A2=40:5d:82:d6:88:73
nl80211: MLME event frame - hexdump(len=125): 50 00 3a 01 
ec 9b f3 87 e1 1c 40 5d 82 d6 88 73 40 5d 82 d6 88 73 20 
46 00 00 00 00 00 00 00 00 64 00 11 04 00 1b 76 69 72 74 
75 61 6c 5f 73 65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 
38 34 30 30 01 08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 
04 32 04 30 48 60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 
02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 
00 00 00 00 00 00 40
nl80211: Frame TX status event
wlan2: Event TX_STATUS (18) received
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=40:5d:82:d6:88:73 
A2=ec:9b:f3:87:e1:1c
nl80211: MLME event frame - hexdump(len=41): b0 00 3a 01 
40 5d 82 d6 88 73 ec 9b f3 87 e1 1c 40 5d 82 d6 88 73 70 
69 00 00 01 00 00 00 dd 09 00 10 18 02 00 00 10 00 00
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-48 stype=11 len=41
wlan2: Event RX_MGMT (20) received
mgmt::auth
authentication: STA=ec:9b:f3:87:e1:1c auth_alg=0 
auth_transaction=1 status_code=0 wep=0
   New STA
ap_sta_add: register ap_handle_timer timeout for 
ec:9b:f3:87:e1:1c (300 seconds - ap_max_inactivity)
wlan2: STA ec:9b:f3:87:e1:1c IEEE 802.11: authentication 
OK (open system)
wlan2: STA ec:9b:f3:87:e1:1c MLME: 
MLME-AUTHENTICATE.indication(ec:9b:f3:87:e1:1c, 
OPEN_SYSTEM)
wlan2: STA ec:9b:f3:87:e1:1c MLME: 
MLME-DELETEKEYS.request(ec:9b:f3:87:e1:1c)
authentication reply: STA=ec:9b:f3:87:e1:1c auth_alg=0 
auth_transaction=2 resp=0 (IE len=0)
nl80211: send_mlme - noack=0 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0xb0 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=0 
offchanok=0
CMD_FRAME - hexdump(len=30): b0 00 00 00 ec 9b f3 87 e1 1c 
40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 02 00 00 
00
nl80211: Frame TX command accepted; cookie 0xdcac1280
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) 
received for wlan2
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on 
wlan2(40:5d:82:d6:88:73) A1=ec:9b:f3:87:e1:1c 
A2=40:5d:82:d6:88:73
nl80211: MLME event frame - hexdump(len=30): b0 00 3a 01 
ec 9b f3 87 e1 1c 40 5d 82 d6 88 73 40 5d 82 d6 88 73 30 
46 00 00 02 00 00 00
nl80211: Frame TX status event
wlan2: Event TX_STATUS (18) received
mgmt::auth cb
wlan2: STA ec:9b:f3:87:e1:1c IEEE 802.11: authenticated
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=40:5d:82:d6:88:73 
A2=ec:9b:f3:87:e1:1c
nl80211: MLME event frame - hexdump(len=119): 00 00 3a 01 
40 5d 82 d6 88 73 ec 9b f3 87 e1 1c 40 5d 82 d6 88 73 80 
69 31 04 0a 00 00 1b 76 69 72 74 75 61 6c 5f 73 65 72 69 
61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 08 82 84 
8b 96 24 30 48 6c 32 04 0c 12 18 60 21 02 09 13 24 02 01 
0d 6b 01 0f dd 09 00 10 18 02 00 00 10 00 00 dd 16 00 50 
f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 
02
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-50 stype=0 len=119
wlan2: Event RX_MGMT (20) received
mgmt::assoc_req
association request: STA=ec:9b:f3:87:e1:1c 
capab_info=0x431 listen_interval=10
   new AID 1
wlan2: STA ec:9b:f3:87:e1:1c IEEE 802.11: association OK 
(aid 1)
nl80211: send_mlme - noack=0 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x10 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=0 
offchanok=0
CMD_FRAME - hexdump(len=56): 10 00 00 00 ec 9b f3 87 e1 1c 
40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 11 04 00 00 01 
c0 01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c 7f 08 
00 00 00 00 00 00 00 40
nl80211: Frame TX command accepted; cookie 0xdcba1dc0
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) 
received for wlan2
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on 
wlan2(40:5d:82:d6:88:73) A1=ec:9b:f3:87:e1:1c 
A2=40:5d:82:d6:88:73
nl80211: MLME event frame - hexdump(len=56): 10 00 3a 01 
ec 9b f3 87 e1 1c 40 5d 82 d6 88 73 40 5d 82 d6 88 73 40 
46 11 04 00 00 01 c0 01 08 82 84 8b 96 0c 12 18 24 32 04 
30 48 60 6c 7f 08 00 00 00 00 00 00 00 40
nl80211: Frame TX status event
wlan2: Event TX_STATUS (18) received
mgmt::assoc_resp cb
wlan2: STA ec:9b:f3:87:e1:1c IEEE 802.11: associated (aid 
1)
wlan2: STA ec:9b:f3:87:e1:1c MLME: 
MLME-ASSOCIATE.indication(ec:9b:f3:87:e1:1c)
wlan2: STA ec:9b:f3:87:e1:1c MLME: 
MLME-DELETEKEYS.request(ec:9b:f3:87:e1:1c)
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=0x1b29c40 key_idx=0 set_tx=1 seq_len=0 key_len=0
    addr=ec:9b:f3:87:e1:1c
nl80211: sta_remove -> DEL_STATION wlan2 ec:9b:f3:87:e1:1c 
--> -2 (No such file or directory)
nl80211: Add STA ec:9b:f3:87:e1:1c
   * supported rates - hexdump(len=12): 82 84 8b 96 24 30 
48 6c 0c 12 18 60
   * aid=1
   * listen_interval=10
   * capability=0x431
   * flags set=0x4 mask=0x4
wlan2: STA ec:9b:f3:87:e1:1c WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=0x1b29c40 key_idx=0 set_tx=1 seq_len=0 key_len=0
    addr=ec:9b:f3:87:e1:1c
IEEE 802.1X: Ignore STA - 802.1X not enabled or forced for 
WPS
wlan2: STA ec:9b:f3:87:e1:1c WPA: start authentication
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=0x1b29c40 key_idx=0 set_tx=1 seq_len=0 key_len=0
    addr=ec:9b:f3:87:e1:1c
wlan2: STA ec:9b:f3:87:e1:1c IEEE 802.1X: unauthorizing 
port
WPA: ec:9b:f3:87:e1:1c WPA_PTK_GROUP entering state IDLE
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state 
AUTHENTICATION
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state 
AUTHENTICATION2
WPA: Re-initialize GMK/Counter on first station
Get randomness: len=32 entropy=216
GMK - hexdump(len=32): [REMOVED]
Get randomness: len=32 entropy=184
Key Counter - hexdump(len=32): [REMOVED]
Get randomness: len=16 entropy=152
GTK - hexdump(len=32): [REMOVED]
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=2 
addr=0x76a80 key_idx=1 set_tx=1 seq_len=0 key_len=32
    broadcast key
Get randomness: len=32 entropy=136
WPA: Assign ANonce - hexdump(len=32): bd cf 22 b5 cf 4e 2b 
6d b1 f3 75 44 aa 84 e0 c4 33 71 fe 85 ce 02 24 c4 f8 fe 
dc a1 c5 67 79 24
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state INITPSK
Searching a PSK for ec:9b:f3:87:e1:1c 
p2p_dev_addr=00:00:00:00:00:00 prev_psk=(nil)
Searching a PSK for ec:9b:f3:87:e1:1c 
p2p_dev_addr=00:00:00:00:00:00 prev_psk=(nil)
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state PTKSTART
wlan2: STA ec:9b:f3:87:e1:1c WPA: sending 1/4 msg of 4-Way 
Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 
pairwise=1 kde_len=0 keyidx=0 encr=0)
WPA: Use EAPOL-Key timeout of 100 ms (retry counter 1)
hostapd_new_assoc_sta: reschedule ap_handle_timer timeout 
for ec:9b:f3:87:e1:1c (300 seconds - ap_max_inactivity)
nl80211: Event message available
nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received 
for wlan2
nl80211: New station ec:9b:f3:87:e1:1c
wlan2: Event EAPOL_TX_STATUS (40) received
IEEE 802.1X: ec:9b:f3:87:e1:1c TX status - version=2 
type=3 length=95 - ack=1
WPA: EAPOL-Key TX status for STA ec:9b:f3:87:e1:1c ack=1
WPA: Increase initial EAPOL-Key 1/4 timeout by 1000 ms 
because of acknowledged frame
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=f0:7d:68:73:90:b4
nl80211: MLME event frame - hexdump(len=57): 40 00 00 00 
ff ff ff ff ff ff f0 7d 68 73 90 b4 ff ff ff ff ff ff 50 
c7 00 0c 53 2e 41 6e 6e 61 20 67 75 65 73 74 01 08 02 04 
0b 16 0c 12 18 24 32 04 30 48 60 6c 03 01 09
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-56 stype=4 len=57
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=f0:7d:68:73:90:b4
nl80211: MLME event frame - hexdump(len=45): 40 00 00 00 
ff ff ff ff ff ff f0 7d 68 73 90 b4 ff ff ff ff ff ff 60 
c7 00 00 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c 
03 01 09
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-56 stype=4 len=45
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 f0 7d 68 73 90 
b4 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=f0:7d:68:73:90:b4
nl80211: MLME event frame - hexdump(len=57): 40 00 00 00 
ff ff ff ff ff ff f0 7d 68 73 90 b4 ff ff ff ff ff ff d0 
c7 00 0c 53 2e 41 6e 6e 61 20 67 75 65 73 74 01 08 02 04 
0b 16 0c 12 18 24 32 04 30 48 60 6c 03 01 0b
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-50 stype=4 len=57
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=f0:7d:68:73:90:b4
nl80211: MLME event frame - hexdump(len=45): 40 00 00 00 
ff ff ff ff ff ff f0 7d 68 73 90 b4 ff ff ff ff ff ff e0 
c7 00 00 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c 
03 01 0b
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-50 stype=4 len=45
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 f0 7d 68 73 90 
b4 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=f0:7d:68:73:90:b4
nl80211: MLME event frame - hexdump(len=57): 40 00 00 00 
ff ff ff ff ff ff f0 7d 68 73 90 b4 ff ff ff ff ff ff 10 
c8 00 0c 53 2e 41 6e 6e 61 20 67 75 65 73 74 01 08 02 04 
0b 16 0c 12 18 24 32 04 30 48 60 6c 03 01 0c
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-50 stype=4 len=57
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=f0:7d:68:73:90:b4
nl80211: MLME event frame - hexdump(len=45): 40 00 00 00 
ff ff ff ff ff ff f0 7d 68 73 90 b4 ff ff ff ff ff ff 20 
c8 00 00 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c 
03 01 0c
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-50 stype=4 len=45
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 f0 7d 68 73 90 
b4 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
wlan2: STA ec:9b:f3:87:e1:1c WPA: EAPOL-Key timeout
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state PTKSTART
wlan2: STA ec:9b:f3:87:e1:1c WPA: sending 1/4 msg of 4-Way 
Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 
pairwise=1 kde_len=0 keyidx=0 encr=0)
WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 2)
wlan2: Event EAPOL_TX_STATUS (40) received
IEEE 802.1X: ec:9b:f3:87:e1:1c TX status - version=2 
type=3 length=95 - ack=1
WPA: EAPOL-Key TX status for STA ec:9b:f3:87:e1:1c ack=1
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=f0:7d:68:73:90:b4
nl80211: MLME event frame - hexdump(len=45): 40 00 00 00 
ff ff ff ff ff ff f0 7d 68 73 90 b4 ff ff ff ff ff ff 90 
c8 00 00 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c 
03 01 0d
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-50 stype=4 len=45
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 f0 7d 68 73 90 
b4 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
wlan2: STA ec:9b:f3:87:e1:1c WPA: EAPOL-Key timeout
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state PTKSTART
wlan2: STA ec:9b:f3:87:e1:1c WPA: sending 1/4 msg of 4-Way 
Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 
pairwise=1 kde_len=0 keyidx=0 encr=0)
WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 3)
wlan2: Event EAPOL_TX_STATUS (40) received
IEEE 802.1X: ec:9b:f3:87:e1:1c TX status - version=2 
type=3 length=95 - ack=1
WPA: EAPOL-Key TX status for STA ec:9b:f3:87:e1:1c ack=1
wlan2: STA ec:9b:f3:87:e1:1c WPA: EAPOL-Key timeout
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state PTKSTART
wlan2: STA ec:9b:f3:87:e1:1c WPA: sending 1/4 msg of 4-Way 
Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 
pairwise=1 kde_len=0 keyidx=0 encr=0)
WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 4)
wlan2: Event EAPOL_TX_STATUS (40) received
IEEE 802.1X: ec:9b:f3:87:e1:1c TX status - version=2 
type=3 length=95 - ack=1
WPA: EAPOL-Key TX status for STA ec:9b:f3:87:e1:1c ack=1
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=44:80:eb:73:69:00
nl80211: MLME event frame - hexdump(len=89): 40 00 00 00 
ff ff ff ff ff ff 44 80 eb 73 69 00 ff ff ff ff ff ff 10 
9f 00 00 01 04 02 04 0b 16 32 08 0c 12 18 24 30 48 60 6c 
03 01 09 2d 1a 2c 01 03 ff 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 dd 07 00 50 f2 08 00 
00 00 7f 05 00 00 0a 02 01
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-84 stype=4 len=89
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 44 80 eb 73 69 
00 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=44:80:eb:73:69:00
nl80211: MLME event frame - hexdump(len=89): 40 00 00 00 
ff ff ff ff ff ff 44 80 eb 73 69 00 ff ff ff ff ff ff 70 
9f 00 00 01 04 02 04 0b 16 32 08 0c 12 18 24 30 48 60 6c 
03 01 0a 2d 1a 2c 01 03 ff 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 dd 07 00 50 f2 08 00 
00 00 7f 05 00 00 0a 02 01
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-68 stype=4 len=89
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 44 80 eb 73 69 
00 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=44:80:eb:73:69:00
nl80211: MLME event frame - hexdump(len=89): 40 00 00 00 
ff ff ff ff ff ff 44 80 eb 73 69 00 ff ff ff ff ff ff 90 
9f 00 00 01 04 02 04 0b 16 32 08 0c 12 18 24 30 48 60 6c 
03 01 0b 2d 1a 2c 01 03 ff 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 dd 07 00 50 f2 08 00 
00 00 7f 05 00 00 0a 02 01
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-68 stype=4 len=89
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 44 80 eb 73 69 
00 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=44:80:eb:73:69:00
nl80211: MLME event frame - hexdump(len=89): 40 00 00 00 
ff ff ff ff ff ff 44 80 eb 73 69 00 ff ff ff ff ff ff b0 
9f 00 00 01 04 02 04 0b 16 32 08 0c 12 18 24 30 48 60 6c 
03 01 0b 2d 1a 2c 01 03 ff 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 dd 07 00 50 f2 08 00 
00 00 7f 05 00 00 0a 02 01
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-72 stype=4 len=89
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 44 80 eb 73 69 
00 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=44:80:eb:73:69:00
nl80211: MLME event frame - hexdump(len=89): 40 00 00 00 
ff ff ff ff ff ff 44 80 eb 73 69 00 ff ff ff ff ff ff 10 
a0 00 00 01 04 02 04 0b 16 32 08 0c 12 18 24 30 48 60 6c 
03 01 0d 2d 1a 2c 01 03 ff 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 dd 07 00 50 f2 08 00 
e8 00 7f 05 00 00 0a 02 01
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-98 stype=4 len=89
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 44 80 eb 73 69 
00 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
wlan2: STA ec:9b:f3:87:e1:1c WPA: EAPOL-Key timeout
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state PTKSTART
wlan2: STA ec:9b:f3:87:e1:1c WPA: PTKSTART: Retry limit 4 
reached
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state DISCONNECT
wpa_sta_disconnect STA ec:9b:f3:87:e1:1c
hostapd_wpa_auth_disconnect: WPA authenticator requests 
disconnect: STA ec:9b:f3:87:e1:1c reason 2
nl80211: send_mlme - noack=0 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0xc0 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=0 
offchanok=0
CMD_FRAME - hexdump(len=26): c0 00 00 00 ec 9b f3 87 e1 1c 
40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 02 00
nl80211: Frame TX command accepted; cookie 0xdcb23b80
wlan2: STA ec:9b:f3:87:e1:1c WPA: event 3 notification
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=0x1b29c40 key_idx=0 set_tx=1 seq_len=0 key_len=0
    addr=ec:9b:f3:87:e1:1c
WPA: wpa_sm_step() called recursively
ap_sta_disconnect: reschedule ap_handle_timer timeout for 
ec:9b:f3:87:e1:1c (5 seconds - 
AP_MAX_INACTIVITY_AFTER_DEAUTH)
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state DISCONNECTED
WPA: ec:9b:f3:87:e1:1c WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=0x1b29c40 key_idx=0 set_tx=1 seq_len=0 key_len=0
    addr=ec:9b:f3:87:e1:1c
wlan2: STA ec:9b:f3:87:e1:1c IEEE 802.1X: unauthorizing 
port
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) 
received for wlan2
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on 
wlan2(40:5d:82:d6:88:73) A1=ec:9b:f3:87:e1:1c 
A2=40:5d:82:d6:88:73
nl80211: MLME event frame - hexdump(len=26): c0 00 3a 01 
ec 9b f3 87 e1 1c 40 5d 82 d6 88 73 40 5d 82 d6 88 73 20 
47 02 00
nl80211: Frame TX status event
wlan2: Event TX_STATUS (18) received
mgmt::deauth cb
STA ec:9b:f3:87:e1:1c acknowledged deauth
Removing STA ec:9b:f3:87:e1:1c from kernel driver
nl80211: sta_remove -> DEL_STATION wlan2 ec:9b:f3:87:e1:1c 
--> 0 (Success)
wlan2: STA ec:9b:f3:87:e1:1c MLME: 
MLME-DEAUTHENTICATE.indication(ec:9b:f3:87:e1:1c, 2)
wlan2: STA ec:9b:f3:87:e1:1c MLME: 
MLME-DELETEKEYS.request(ec:9b:f3:87:e1:1c)
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=0x1b29c40 key_idx=0 set_tx=1 seq_len=0 key_len=0
    addr=ec:9b:f3:87:e1:1c
nl80211: Event message available
nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION) received 
for wlan2
nl80211: Delete station ec:9b:f3:87:e1:1c
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for 
wlan2
nl80211: MLME event 59 (NL80211_CMD_FRAME) on 
wlan2(40:5d:82:d6:88:73) A1=ff:ff:ff:ff:ff:ff 
A2=ec:9b:f3:87:e1:1c
nl80211: MLME event frame - hexdump(len=151): 40 00 00 00 
ff ff ff ff ff ff ec 9b f3 87 e1 1c ff ff ff ff ff ff e0 
69 00 1b 76 69 72 74 75 61 6c 5f 73 65 72 69 61 6c 5f 70 
6f 72 74 5f 62 72 33 38 34 30 30 01 04 02 04 0b 16 32 08 
0c 12 18 24 30 48 60 6c 03 01 0b 2d 1a 2d 00 17 ff ff 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 6b 01 0f dd 05 50 6f 9a 10 10 dd 13 00 90 4c 04 08 bf 
0c 32 58 81 0f fa ff 00 00 fa ff 00 00 dd 07 00 50 f2 08 
00 11 00 dd 09 00 10 18 02 00 00 10 00 00
nl80211: Frame event
nl80211: RX frame freq=2462 ssi_signal=-98 stype=4 len=132
nl80211: send_mlme - noack=1 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0x50 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=1 
offchanok=0
CMD_FRAME - hexdump(len=125): 50 00 00 00 ec 1f 72 9b 19 
10 40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 00 00 00 00 
00 00 00 00 64 00 11 04 00 1b 76 69 72 74 75 61 6c 5f 73 
65 72 69 61 6c 5f 70 6f 72 74 5f 62 72 33 38 34 30 30 01 
08 82 84 8b 96 0c 12 18 24 03 01 0b 2a 01 04 32 04 30 48 
60 6c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
04 00 50 f2 02 01 00 00 50 f2 02 7f 08 00 00 00 00 00 00 
00 40
nl80211: Frame TX command accepted (no ACK); cookie 0x0
ap_handle_timer: ec:9b:f3:87:e1:1c flags=0x8080 
timeout_next=3
wlan2: STA ec:9b:f3:87:e1:1c IEEE 802.11: deauthenticated 
due to local deauth request
nl80211: sta_remove -> DEL_STATION wlan2 ec:9b:f3:87:e1:1c 
--> -2 (No such file or directory)
ap_free_sta: cancel ap_handle_timer for ec:9b:f3:87:e1:1c
Signal 2 received - terminating
hostapd_interface_deinit_free(0x1b276f0)
hostapd_interface_deinit_free: num_bss=1 conf->num_bss=1
hostapd_interface_deinit(0x1b276f0)
hostapd_bss_deinit: deinit bss wlan2
wlan2: Flushing old station entries
nl80211: flush -> DEL_STATION wlan2 (all)
wlan2: Deauthenticate all stations
nl80211: send_mlme - noack=0 freq=0 no_cck=0 offchanok=0 
wait_time=0 fc=0xc0 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=2462
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=2462 wait=0 no_cck=0 no_ack=0 
offchanok=0
CMD_FRAME - hexdump(len=26): c0 00 00 00 ff ff ff ff ff ff 
40 5d 82 d6 88 73 40 5d 82 d6 88 73 00 00 03 00
nl80211: Frame TX command accepted; cookie 0xdcbb4f40
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan2) alg=0 
addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
hostapd_cleanup(hapd=0x1b28300 (wlan2))
hostapd_free_hapd_data(wlan2)
hostapd_interface_deinit_free: driver=0x85458 
drv_priv=0x1b28b68 -> hapd_deinit
nl80211: Remove monitor interface: refcount=0
nl80211: Remove beacon (ifindex=3)
netlink: Operstate: ifindex=3 linkmode=0 (kernel-control), 
operstate=6 (IF_OPER_UP)
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Teardown AP(wlan2) - device_ap_sme=0 
use_monitor=0
nl80211: Unsubscribe mgmt frames handle 0x893a05e9 (AP 
teardown)
hostapd_interface_free(0x1b276f0)
hostapd_interface_free: free hapd 0x1b28300
hostapd_cleanup_iface(0x1b276f0)
hostapd_cleanup_iface_partial(0x1b276f0)
hostapd_cleanup_iface: free iface=0x1b276f0
