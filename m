Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:35169 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab2EXH5r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 03:57:47 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SXSvZ-0004EF-CW
	for linux-wireless@vger.kernel.org; Thu, 24 May 2012 09:57:45 +0200
Received: from localhost ([::1]:59016 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SXSvZ-0001RC-76
	for linux-wireless@vger.kernel.org; Thu, 24 May 2012 09:57:45 +0200
Received: from [195.4.92.15] (port=38217 helo=5.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SXSss-0000ak-9L
	for linux-wireless@vger.kernel.org; Thu, 24 May 2012 09:54:58 +0200
Received: from [2002:4fde:1635:2:5054:ff:feb8:40bd] (port=34388 helo=mail.maya.org)
	by 5.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SXSsr-0004Jc-Ae
	for linux-wireless@vger.kernel.org; Thu, 24 May 2012 09:54:58 +0200
Message-Id: <201205240754.q4O7sqrd003652@mail.maya.org> (sfid-20120524_095752_085187_3EDD92BC)
Date: Thu, 24 May 2012 09:54:50 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [PATCH][RFC/RFT] rt2800: Enable support for
 802.11w (MFP)
In-Reply-To: <201205101720.q4AHKTZp003261@mail.maya.org>
References: <201205101720.q4AHKTZp003261@mail.maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Hartmann wrote:
> This patch adds support for 802.11w for rt2800. This is achieved by
> using the 802.11w implementation in mac80211.
> 
> To get this working, it is necessary that hw encryption of
> rt2800pci / rt2800usb is disabled, because I don't know of any support
> in hardware for 802.11w and therefore let mac80211 do the whole job.
> 
> The user can enable 802.11w support by disabling hw encryption by
> setting module parameter nohwcrypt=1.
> 
> Tested with rt2860 and rt3572.
> 
> This is a workaround as long as there isn't hardware support implemented
> in the driver.

Did anybody do some testing?

My long term test showed up one critical issue: If there is network load
during 4 way handshake (EAP-TLS), the 4 way handshake breaks most of the
time, because AP doesn't get the 4/4-package sent by the supplicant
(this is an old problem and not related to MFP).

This means:
supplicant operates with new keys, AP uses the old ones. Hence,
deauth-package of AP -> STA isn't understood by STA and therefore
ignored. Consequence: the connection is broken. You have to restart the
supplicant to get it working again.

Following the log of the AP:

1336729364.917156: IEEE 802.1X: 48:5d:60:11:22:33 REAUTH_TIMER entering state REAUTHENTICATE
1336729364.917173: 1336729364.917204: WPA: 48:5d:60:11:22:33 WPA_PTK entering state AUTHENTICATION2
1336729364.917559: WPA: Assign ANonce - hexdump(len=32): 2f 7a be 8a 70 c8 14 63 3b af 3e fc 0e 4d a0 68 71 b0 c6 f9 16 08 c8 2a f6 b5 60 67 72 03 50 1d
1336729364.917567: IEEE 802.1X: 48:5d:60:11:22:33 AUTH_PAE entering state RESTART
1336729364.917570: IEEE 802.1X: 48:5d:60:11:22:33 REAUTH_TIMER entering state INITIALIZE
1336729364.917572: EAP: EAP entering state INITIALIZE

1336729364.917576: wlan0: CTRL-EVENT-EAP-STARTED 48:5d:60:11:22:33
1336729364.917578: EAP: EAP entering state SELECT_ACTION
1336729364.917579: EAP: getDecision: no identity known yet -> CONTINUE
1336729364.917581: EAP: EAP entering state PROPOSE_METHOD
1336729364.917582: EAP: getNextMethod: vendor 0 type 1

1336729364.917585: wlan0: CTRL-EVENT-EAP-PROPOSED-METHOD vendor=0 method=1
1336729364.917586: EAP: EAP entering state METHOD_REQUEST
1336729364.917588: EAP: building EAP-Request: Identifier 90
1336729364.917593: EAP: EAP entering state SEND_REQUEST
1336729364.917595: EAP: EAP entering state IDLE
1336729364.917596: EAP: retransmit timeout 3 seconds (from dynamic back off; retransCount=0)
1336729364.917598: IEEE 802.1X: 48:5d:60:11:22:33 AUTH_PAE entering state CONNECTING
1336729364.917600: IEEE 802.1X: 48:5d:60:11:22:33 AUTH_PAE entering state AUTHENTICATING
1336729364.917602: IEEE 802.1X: 48:5d:60:11:22:33 BE_AUTH entering state REQUEST

1336729364.917606: 1336729364.958554: wlan0: Event EAPOL_RX (27) received
1336729364.958565: IEEE 802.1X: 27 bytes from 48:5d:60:11:22:33
1336729364.958571:    IEEE 802.1X: version=1 type=0 length=23
1336729364.958575: EAP: code=2 identifier=90 length=23
1336729364.958578:  (response)
1336729364.958587: 1336729364.958619: IEEE 802.1X: 48:5d:60:11:22:33 BE_AUTH entering state RESPONSE
1336729364.958627: EAP: EAP entering state RECEIVED
1336729364.958630: EAP: parseEapResp: rxResp=1 respId=90 respMethod=1 respVendor=0 respVendorMethod=0
1336729364.958636: EAP: EAP entering state INTEGRITY_CHECK
1336729364.958640: EAP: EAP entering state METHOD_RESPONSE
1336729364.958644: EAP-Identity: Peer identity - hexdump_ascii(len=18):
     ...
1336729364.958662: EAP: EAP entering state SELECT_ACTION
1336729364.958665: EAP: getDecision: -> PASSTHROUGH
1336729364.958669: EAP: EAP entering state INITIALIZE_PASSTHROUGH
1336729364.958673: EAP: EAP entering state AAA_REQUEST
1336729364.958677: EAP: EAP entering state AAA_IDLE
1336729364.958687: 1336729364.958700: Encapsulating EAP message into a RADIUS packet
1336729364.958734: 1336729364.958776: 1336729364.960027: 1336729364.960039: 1336729364.960047: 1336729364.960057: RADIUS packet matching with station 48:5d:60:11:22:33
1336729364.960067: 1336729364.960077: EAP: EAP entering state AAA_RESPONSE
1336729364.960080: EAP: getId: id=91
1336729364.960081: EAP: EAP entering state SEND_REQUEST2
1336729364.960083: EAP: EAP entering state IDLE2
1336729364.960085: EAP: retransmit timeout 3 seconds (from dynamic back off; retransCount=0)
1336729364.960087: IEEE 802.1X: 48:5d:60:11:22:33 BE_AUTH entering state REQUEST

1336729364.960092: 1336729365.000720: wlan0: Event EAPOL_RX (27) received
1336729365.000735: IEEE 802.1X: 250 bytes from 48:5d:60:11:22:33
1336729365.000742:    IEEE 802.1X: version=1 type=0 length=246
1336729365.000747: EAP: code=2 identifier=91 length=246
1336729365.000751:  (response)
1336729365.000761: 1336729365.000800: IEEE 802.1X: 48:5d:60:11:22:33 BE_AUTH entering state RESPONSE
1336729365.000810: EAP: EAP entering state RECEIVED2
1336729365.000814: EAP: parseEapResp: rxResp=1 respId=91 respMethod=13 respVendor=0 respVendorMethod=0
1336729365.000820: EAP: EAP entering state AAA_REQUEST
1336729365.000826: EAP: EAP entering state AAA_IDLE
1336729365.000832: Encapsulating EAP message into a RADIUS packet
1336729365.000858: Copied RADIUS State Attribute
1336729365.000874: 1336729365.000926: 1336729365.002215: 1336729365.002243: 1336729365.002264: 1336729365.002291: RADIUS packet matching with station 48:5d:60:11:22:33
1336729365.002313: 1336729365.002338: EAP: EAP entering state AAA_RESPONSE
1336729365.002346: EAP: getId: id=92
1336729365.002375: EAP: EAP entering state SEND_REQUEST2
1336729365.002383: EAP: EAP entering state IDLE2
1336729365.002388: EAP: retransmit timeout 3 seconds (from dynamic back off; retransCount=0)
1336729365.002393: IEEE 802.1X: 48:5d:60:11:22:33 BE_AUTH entering state REQUEST

1336729365.002407: 1336729365.071186: wlan0: Event EAPOL_RX (27) received
1336729365.071201: IEEE 802.1X: 69 bytes from 48:5d:60:11:22:33
1336729365.071208:    IEEE 802.1X: version=1 type=0 length=65
1336729365.071213: EAP: code=2 identifier=92 length=65
1336729365.071216:  (response)
1336729365.071227: 1336729365.071265: IEEE 802.1X: 48:5d:60:11:22:33 BE_AUTH entering state RESPONSE
1336729365.071277: EAP: EAP entering state RECEIVED2
1336729365.071282: EAP: parseEapResp: rxResp=1 respId=92 respMethod=13 respVendor=0 respVendorMethod=0
1336729365.071298: EAP: EAP entering state AAA_REQUEST
1336729365.071306: EAP: EAP entering state AAA_IDLE
1336729365.071312: Encapsulating EAP message into a RADIUS packet
1336729365.071339: Copied RADIUS State Attribute
1336729365.071396: 1336729365.071449: 1336729365.072682: 1336729365.072719: 1336729365.072741: 1336729365.072754: RADIUS packet matching with station 48:5d:60:11:22:33
1336729365.072764: MS-MPPE-Send-Key - hexdump(len=32): [REMOVED]
1336729365.072767: MS-MPPE-Recv-Key - hexdump(len=32): [REMOVED]
1336729365.072772: 1336729365.072781: 1336729365.072791: EAP: EAP entering state SUCCESS2
1336729365.072794: IEEE 802.1X: 48:5d:60:11:22:33 BE_AUTH entering state SUCCESS
1336729365.072800: 1336729365.072819: IEEE 802.1X: 48:5d:60:11:22:33 AUTH_PAE entering state AUTHENTICATED
1336729365.072865: 1336729365.072902: 1336729365.072918: RSN: added PMKSA cache entry for 48:5d:60:11:22:33
1336729365.072922: RSN: added PMKID - hexdump(len=16): 5e c4 b7 eb 46 bf e4 20 c9 5e d8 ca f2 13 3b 42
1336729365.072929: 1336729365.072934: IEEE 802.1X: 48:5d:60:11:22:33 BE_AUTH entering state IDLE
1336729365.072942: WPA: 48:5d:60:11:22:33 WPA_PTK entering state INITPMK
1336729365.072946: WPA: PMK from EAPOL state machine (len=64)
1336729365.072948: WPA: 48:5d:60:11:22:33 WPA_PTK entering state PTKSTART
1336729365.072953: 1336729365.072962: WPA: Send EAPOL(version=3 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=22 keyidx=0 encr=0)
1336729365.072975: WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)

1336729365.134552: wlan0: Event EAPOL_RX (27) received
1336729365.134558: IEEE 802.1X: 127 bytes from 48:5d:60:11:22:33
1336729365.134561:    IEEE 802.1X: version=1 type=3 length=123
1336729365.134563: WPA: Received EAPOL-Key from 48:5d:60:11:22:33 key_info=0x10b type=2 key_data_length=28
1336729365.134565: WPA: Received Key Nonce - hexdump(len=32): 10 fa 2a b7 96 a5 21 0b 38 87 86 3c 88 8a ba 75 bc 75 77 89 40 b5 4c 1a 4a ff 17 3a 1b 30 1d c3
1336729365.134570: WPA: Received Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 09
1336729365.134576: 1336729365.134590: WPA: 48:5d:60:11:22:33 WPA_PTK entering state PTKCALCNEGOTIATING
1336729365.134603: WPA: PTK derivation - A1=96:2d:a6:46:e4:d1 A2=48:5d:60:11:22:33
1336729365.134606: WPA: Nonce1 - hexdump(len=32): 2f 7a be 8a 70 c8 14 63 3b af 3e fc 0e 4d a0 68 71 b0 c6 f9 16 08 c8 2a f6 b5 60 67 72 03 50 1d
1336729365.134612: WPA: Nonce2 - hexdump(len=32): 10 fa 2a b7 96 a5 21 0b 38 87 86 3c 88 8a ba 75 bc 75 77 89 40 b5 4c 1a 4a ff 17 3a 1b 30 1d c3
1336729365.134618: WPA: PMK - hexdump(len=32): [REMOVED]
1336729365.134619: WPA: PTK - hexdump(len=48): [REMOVED]
1336729365.134626: WPA: 48:5d:60:11:22:33 WPA_PTK entering state PTKCALCNEGOTIATING2
1336729365.134629: WPA: 48:5d:60:11:22:33 WPA_PTK entering state PTKINITNEGOTIATING
1336729365.134664: 1336729365.134784: WPA: Send EAPOL(version=3 secure=1 mic=1 ack=1 install=1 pairwise=8 kde_len=86 keyidx=1 encr=1)
1336729365.134793: Plaintext EAPOL-Key Key Data - hexdump(len=96): [REMOVED]
1336729365.134818: WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 1)

1336729366.135174: 1336729366.135211: WPA: 48:5d:60:11:22:33 WPA_PTK entering state PTKINITNEGOTIATING
1336729366.135322: 1336729366.135406: WPA: Send EAPOL(version=3 secure=1 mic=1 ack=1 install=1 pairwise=8 kde_len=86 keyidx=1 encr=1)
1336729366.135421: Plaintext EAPOL-Key Key Data - hexdump(len=96): [REMOVED]
1336729366.135489: WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 2)

1336729367.135845: 1336729367.135882: WPA: 48:5d:60:11:22:33 WPA_PTK entering state PTKINITNEGOTIATING
1336729367.135986: 1336729367.136045: WPA: Send EAPOL(version=3 secure=1 mic=1 ack=1 install=1 pairwise=8 kde_len=86 keyidx=1 encr=1)
1336729367.136058: Plaintext EAPOL-Key Key Data - hexdump(len=96): [REMOVED]
1336729367.136127: WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 3)
1336729367.920344: IEEE 802.1X: 48:5d:60:11:22:33 - (EAP) retransWhile --> 0

1336729368.136312: 1336729368.136348: WPA: 48:5d:60:11:22:33 WPA_PTK entering state PTKINITNEGOTIATING
1336729368.136482: 1336729368.136542: WPA: Send EAPOL(version=3 secure=1 mic=1 ack=1 install=1 pairwise=8 kde_len=86 keyidx=1 encr=1)
1336729368.136557: Plaintext EAPOL-Key Key Data - hexdump(len=96): [REMOVED]
1336729368.136626: WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 4)

1336729369.136869: 1336729369.136885: WPA: 48:5d:60:11:22:33 WPA_PTK entering state PTKINITNEGOTIATING
1336729369.136896: 1336729369.136902: WPA: 48:5d:60:11:22:33 WPA_PTK entering state DISCONNECT
1336729369.136905: wpa_sta_disconnect STA 48:5d:60:11:22:33
1336729369.136907: hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect: STA 48:5d:60:11:22:33 reason 2
1336729369.136937: nl80211: Frame TX command accepted; cookie 0xffff88015c3193c0
1336729369.136942: wlan0: AP-STA-DISCONNECTED 48:5d:60:11:22:33
1336729369.136948: 1336729369.136964: wpa_driver_nl80211_set_key: ifindex=15 alg=0 addr=0x673fc0 key_idx=0 set_tx=1 seq_len=0 key_len=0
1336729369.136969:    addr=48:5d:60:11:22:33
1336729369.136980: WPA: wpa_sm_step() called recursively
1336729369.136983: WPA: 48:5d:60:11:22:33 WPA_PTK entering state DISCONNECTED
1336729369.136986: WPA: 48:5d:60:11:22:33 WPA_PTK entering state INITIALIZE
1336729369.136994: wpa_driver_nl80211_set_key: ifindex=15 alg=0 addr=0x673fc0 key_idx=0 set_tx=1 seq_len=0 key_len=0
1336729369.136998:    addr=48:5d:60:11:22:33
1336729369.137010: IEEE 802.1X: 48:5d:60:11:22:33 AUTH_PAE entering state INITIALIZE
1336729369.137014: EAP: EAP entering state DISABLED

1336729369.733812: nl80211: Event message available
1336729369.733846: nl80211: MLME event 60
1336729369.733854: nl80211: MLME event frame - hexdump(len=42): c0 40 30 00 48 5d 60 3e a3 18 96 2d a6 46 e4 d1 96 2d a6 46 e4 d1 c0 2d ca fd 00 20 e4 00 00 00 06 dc 8f 76 18 39 35 c3 79 92
1336729369.733880: wlan0: Event TX_STATUS (18) received
1336729369.733888: mgmt::deauth cb
1336729369.733893: STA 48:5d:60:11:22:33 acknowledged deauth
1336729369.733901: Removing STA 48:5d:60:11:22:33 from kernel driver
1336729369.760615: 1336729369.760651: 1336729369.760686: wpa_driver_nl80211_set_key: ifindex=15 alg=0 addr=0x673fc0 key_idx=0 set_tx=1 seq_len=0 key_len=0
1336729369.760706:    addr=48:5d:60:11:22:33

1336729369.760754: nl80211: Event message available
1336729369.760770: nl80211: Delete station 48:5d:60:11:22:33

1336729369.809948: nl80211: Event message available
1336729369.809982: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729369.809989: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729369.809994: Association Response to the STA has already been sent, but no TX status yet known - ignore Class 3 frame issue with 48:5d:60:11:22:33
1336729369.910003: nl80211: Event message available
1336729369.910036: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729369.910043: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729369.910048: Association Response to the STA has already been sent, but no TX status yet known - ignore Class 3 frame issue with 48:5d:60:11:22:33
1336729370.812457: nl80211: Event message available
1336729370.812495: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729370.812502: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729370.812508: Association Response to the STA has already been sent, but no TX status yet known - ignore Class 3 frame issue with 48:5d:60:11:22:33
1336729370.912038: nl80211: Event message available
1336729370.912071: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729370.912078: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729370.912083: Association Response to the STA has already been sent, but no TX status yet known - ignore Class 3 frame issue with 48:5d:60:11:22:33
1336729374.137324: 1336729374.137484: 1336729374.137552: 1336729374.137575: 1336729374.137628: hostapd_ht_operation_update current operation mode=0x4
1336729374.137642: hostapd_ht_operation_update new operation mode=0x0 changes=1
1336729374.137670: nl80211: Set beacon (beacon_set=1)
1336729374.137750: EAP: Server state machine removed

1336729374.138723: 1336729374.138754: 1336729374.138775: 1336729374.961061: nl80211: Event message available
1336729374.961088: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729374.961091: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729374.961119: nl80211: Frame TX command accepted; cookie 0xffff88015e2ef2c0

1336729374.961270: nl80211: Event message available
1336729374.961275: nl80211: MLME event 60
1336729374.961277: nl80211: MLME event frame - hexdump(len=26): c0 00 ac 00 48 5d 60 3e a3 18 96 2d a6 46 e4 d1 96 2d a6 46 e4 d1 f0 2d 07 00
1336729374.961283: wlan0: Event TX_STATUS (18) received
1336729374.961285: mgmt::deauth cb
1336729374.961286: handle_deauth_cb: STA 48:5d:60:11:22:33 not found

1336729377.806532: nl80211: Event message available
1336729377.806589: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729377.806597: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729377.806657: nl80211: Frame TX command accepted; cookie 0xffff880148208880

1336729377.806673: nl80211: Event message available
1336729377.806685: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729377.806690: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729377.806722: nl80211: Frame TX command accepted; cookie 0xffff8801f47d9780

1336729377.806811: nl80211: Event message available
1336729377.806823: nl80211: MLME event 60
1336729377.806828: nl80211: MLME event frame - hexdump(len=26): c0 00 ac 00 48 5d 60 3e a3 18 96 2d a6 46 e4 d1 96 2d a6 46 e4 d1 00 2e 07 00
1336729377.806843: wlan0: Event TX_STATUS (18) received
1336729377.806848: mgmt::deauth cb
1336729377.806852: handle_deauth_cb: STA 48:5d:60:11:22:33 not found

1336729377.806965: nl80211: Event message available
1336729377.806976: nl80211: MLME event 60
1336729377.806980: nl80211: MLME event frame - hexdump(len=26): c0 00 ac 00 48 5d 60 3e a3 18 96 2d a6 46 e4 d1 96 2d a6 46 e4 d1 10 2e 07 00
1336729377.806994: wlan0: Event TX_STATUS (18) received
1336729377.806998: mgmt::deauth cb
1336729377.807001: handle_deauth_cb: STA 48:5d:60:11:22:33 not found

1336729377.810459: nl80211: Event message available
1336729377.810492: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729377.810499: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729377.810549: nl80211: Frame TX command accepted; cookie 0xffff880148208880

1336729377.810705: nl80211: Event message available
1336729377.810717: nl80211: MLME event 60
1336729377.810722: nl80211: MLME event frame - hexdump(len=26): c0 00 ac 00 48 5d 60 3e a3 18 96 2d a6 46 e4 d1 96 2d a6 46 e4 d1 20 2e 07 00
1336729377.810740: wlan0: Event TX_STATUS (18) received
1336729377.810745: mgmt::deauth cb
1336729377.810748: handle_deauth_cb: STA 48:5d:60:11:22:33 not found

1336729377.909258: nl80211: Event message available
1336729377.909290: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729377.909297: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729377.909347: nl80211: Frame TX command accepted; cookie 0xffff8801fc54ab80

1336729377.909501: nl80211: Event message available
1336729377.909513: nl80211: MLME event 60
1336729377.909518: nl80211: MLME event frame - hexdump(len=26): c0 00 ac 00 48 5d 60 3e a3 18 96 2d a6 46 e4 d1 96 2d a6 46 e4 d1 30 2e 07 00
1336729377.909533: wlan0: Event TX_STATUS (18) received
1336729377.909538: mgmt::deauth cb
1336729377.909542: handle_deauth_cb: STA 48:5d:60:11:22:33 not found

1336729378.135421: nl80211: Event message available
1336729378.135455: wlan0: Event RX_FROM_UNKNOWN (19) received
1336729378.135462: Data/PS-poll frame from not associated STA 48:5d:60:11:22:33
1336729378.135513: nl80211: Frame TX command accepted; cookie 0xffff880220622580

1336729378.135668: nl80211: Event message available
1336729378.135681: nl80211: MLME event 60
1336729378.135685: nl80211: MLME event frame - hexdump(len=26): c0 00 ac 00 48 5d 60 3e a3 18 96 2d a6 46 e4 d1 96 2d a6 46 e4 d1 40 2e 07 00
1336729378.135700: wlan0: Event TX_STATUS (18) received
1336729378.135705: mgmt::deauth cb
1336729378.135709: handle_deauth_cb: STA 48:5d:60:11:22:33 not found

...


Kind regards,
Andreas
