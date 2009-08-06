Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aramid.it ([213.21.189.122]:2903 "EHLO aramid.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZHFLrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 07:47:45 -0400
Date: Thu, 6 Aug 2009 13:47:22 +0200
From: Andrea Rossato <mailing_list@istitutocolli.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>
Subject: Re: [ath5k-devel] a possible regression in managed mode ?
Message-ID: <20090806114722.GA3789@eeepc.nowhwre.net>
References: <43e72e890908050810h29c28945o4732f8606caab9fb@mail.gmail.com> <20090805155330.GC4727@mosca>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vGgW1X5XWziG23Ko"
In-Reply-To: <20090805155330.GC4727@mosca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Aug 05, 2009 at 05:53:31PM +0200, Luis R. Rodriguez wrote:
> > Can you try with -D nl80211 and see if that fixes your issue?

No it doesn't.

> Also please install iw, and provide 'iw event -t' log.

attached you'll find a few files:

 1. the logs of wap_supplicant, iwevent (here 'iw event -t' seems not
    to be working with 2.6.29.4), and the Access Point log of a
    section with a linux-2.6.29.4 kernel. As you can see
    reassociationn happens immediately after 'wpa_cli reassociate' is
    run;

 2. the logs of wpa_supplicant, 'iw event -t' (iw was compiled from
    today's git repository), and the Ap logs of a session with the
    wireless-testing git kernel. As you can see the reassociation
    doesn't take place immediately - there are so many authentication
    timeouts - but eventually reassociation may/will happen.

To summarize, with 2.6.29.4 association and reassociation happen
instantly. With wireless-testing association may happen immediately at
the first run, but reassociation almost always will produce a timeout
error.

As I said I'm not an expert of this wireless stuff and so my results
seem to be very strange. Hopefully there could be enough information
in those logs to understand if something wrong is going on.

If I can provide more info please let me know.

Thanks for you patience.

Andrea

ps: in the AP logs you will also see another station associating (I
could not turn it off. It's mac is 00:22:43:6d:1c:7e). The one that
shows the issue is the 00:22:43:4e:b6:68 one.

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="log-2.6.29.4_supplicant"

1249557766.776683: CTRL-EVENT-SCAN-RESULTS 
1249557766.776839: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249557766.825737: Associated with 00:22:b0:70:1f:67
1249557766.839122: WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
1249557766.839161: CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (auth) [id=1 id_str=]
1249557772.060875: CTRL-EVENT-SCAN-RESULTS 
1249557772.061021: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249557772.100681: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
1249557772.118855: Associated with 00:22:b0:70:1f:67
1249557772.249862: WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
1249557772.249915: CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (reauth) [id=1 id_str=]
1249557774.628521: CTRL-EVENT-SCAN-RESULTS 
1249557774.628647: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249557774.668602: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
1249557774.680332: Associated with 00:22:b0:70:1f:67
1249557774.811357: WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
1249557774.811443: CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (reauth) [id=1 id_str=]
1249557778.268446: CTRL-EVENT-SCAN-RESULTS 
1249557778.268544: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249557778.300564: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
1249557778.316556: Associated with 00:22:b0:70:1f:67
1249557778.444969: WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
1249557778.445045: CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (reauth) [id=1 id_str=]
1249557780.932380: CTRL-EVENT-SCAN-RESULTS 
1249557780.932478: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249557780.960615: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
1249557780.979314: Associated with 00:22:b0:70:1f:67
1249557781.105587: WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
1249557781.105653: CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (reauth) [id=1 id_str=]
1249557783.936608: CTRL-EVENT-SCAN-RESULTS 
1249557783.936804: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249557783.980487: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
1249557783.999426: Associated with 00:22:b0:70:1f:67
1249557784.122183: WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
1249557784.122242: CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (reauth) [id=1 id_str=]
1249557787.899799: CTRL-EVENT-TERMINATING - signal 2 received

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="log-2.6.29.4_event"

13:22:45.774021   wlan0    Scan request completed
13:22:46.768827   wlan0    Scan request completed
13:22:46.800552   wlan0    Set Frequency:2.427 GHz (Channel 4)
13:22:46.825791   wlan0    Custom driver event:ASSOCINFO(ReqIEs=000e497374697475746f20436f6c6c69010802040b160c12182432043048606cdd160050f20101000050f20201000050f20401000050f202 RespIEs=010882848b960c12182432043048606c)
13:22:46.825878   wlan0    New Access Point/Cell address:00:22:B0:70:1F:67
13:22:52.085662   wlan0    Scan request completed
13:22:52.085801   wlan0    New Access Point/Cell address:Not-Associated
13:22:52.101091   wlan0    Set Frequency:2.427 GHz (Channel 4)
13:22:52.117956   wlan0    Custom driver event:ASSOCINFO(ReqIEs=000e497374697475746f20436f6c6c69010802040b160c12182432043048606cdd160050f20101000050f20201000050f20401000050f202 RespIEs=010882848b960c12182432043048606c)
13:22:52.118068   wlan0    New Access Point/Cell address:00:22:B0:70:1F:67
13:22:54.633394   wlan0    Scan request completed
13:22:54.633507   wlan0    New Access Point/Cell address:Not-Associated
13:22:54.673402   wlan0    Set Frequency:2.427 GHz (Channel 4)
13:22:54.679979   wlan0    Custom driver event:ASSOCINFO(ReqIEs=000e497374697475746f20436f6c6c69010802040b160c12182432043048606cdd160050f20101000050f20201000050f20401000050f202 RespIEs=010882848b960c12182432043048606c)
13:22:54.680098   wlan0    New Access Point/Cell address:00:22:B0:70:1F:67
13:22:58.260623   wlan0    Scan request completed
13:22:58.276654   wlan0    New Access Point/Cell address:Not-Associated
13:22:58.301027   wlan0    Set Frequency:2.427 GHz (Channel 4)
13:22:58.316168   wlan0    Custom driver event:ASSOCINFO(ReqIEs=000e497374697475746f20436f6c6c69010802040b160c12182432043048606cdd160050f20101000050f20201000050f20401000050f202 RespIEs=010882848b960c12182432043048606c)
13:22:58.316319   wlan0    New Access Point/Cell address:00:22:B0:70:1F:67
13:23:00.924561   wlan0    Scan request completed
13:23:00.940303   wlan0    New Access Point/Cell address:Not-Associated
13:23:00.961068   wlan0    Set Frequency:2.427 GHz (Channel 4)
13:23:00.978983   wlan0    Custom driver event:ASSOCINFO(ReqIEs=000e497374697475746f20436f6c6c69010802040b160c12182432043048606cdd160050f20101000050f20201000050f20401000050f202 RespIEs=010882848b960c12182432043048606c)
13:23:00.979081   wlan0    New Access Point/Cell address:00:22:B0:70:1F:67
13:23:03.937877   wlan0    Scan request completed
13:23:03.939425   wlan0    New Access Point/Cell address:Not-Associated
13:23:03.980885   wlan0    Set Frequency:2.427 GHz (Channel 4)
13:23:03.993544   wlan0    Custom driver event:ASSOCINFO(ReqIEs=000e497374697475746f20436f6c6c69010802040b160c12182432043048606cdd160050f20101000050f20201000050f20401000050f202 RespIEs=010882848b960c12182432043048606c)
13:23:03.993629   wlan0    New Access Point/Cell address:00:22:B0:70:1F:67
13:23:07.932134   wlan0    New Access Point/Cell address:Not-Associated

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="logAP_2.6.29.4"

Configuration file: /etc/hostapd.conf
Line 13: DEPRECATED: 'debug' configuration variable is not used anymore
ctrl_interface_group=0
Opening raw packet socket for ifindex 209
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=12 freq=2467 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=13 freq=2472 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=12 freq=2467 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=13 freq=2472 MHz max_tx_power=18 dBm
RATE[0] rate=10 flags=0x2
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
Mode: IEEE 802.11g  Channel: 4  Frequency: 2427 MHz
Using interface wlan0 with hwaddr 00:22:b0:70:1f:67 and ssid 'Istituto Colli'
SSID - hexdump_ascii(len=14):
     49 73 74 69 74 75 74 6f 20 43 6f 6c 6c 69         Istituto Colli  
PSK (ASCII passphrase) - hexdump_ascii(len=18):
     74 61 63 69 2c 20 74 75 6c 6c 69 61 20 64 6f 72   taci, tullia dor
     6d 65                                             me              
PSK (from passphrase) - hexdump(len=32): 19 f6 ff fb 3e 49 0d 36 7b ff 05 20 de 3d 4c 93 56 62 04 30 18 ad 42 e5 a7 12 79 4d 8b c8 80 d2
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wlan0: Setup of interface done.
MGMT (TX callback) ACK
STA 00:22:43:6d:1c:7e sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:6d:1c:7e sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::auth
authentication: STA=00:22:43:6d:1c:7e auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:6d:1c:7e auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::assoc_req
association request: STA=00:22:43:6d:1c:7e capab_info=0x411 listen_interval=3
unknown vendor specific information element ignored (vendor OUI 00:0c:43 len=7)
  new AID 1
MGMT (TX callback) ACK
mgmt::assoc_resp cb
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state INITIALIZE
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state INITPSK
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:6d:1c:7e TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:6d:1c:7e TX status - version=2 type=3 length=95 - ack=1
STA 00:22:43:6d:1c:7e sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:6d:1c:7e TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:6d:1c:7e TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKSTART
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state DISCONNECT
hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect: STA 00:22:43:6d:1c:7e reason 2
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state INITIALIZE
MGMT (TX callback) ACK
STA 00:22:43:6d:1c:7e sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::auth
authentication: STA=00:22:43:6d:1c:7e auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:6d:1c:7e auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::assoc_req
association request: STA=00:22:43:6d:1c:7e capab_info=0x411 listen_interval=3
unknown vendor specific information element ignored (vendor OUI 00:0c:43 len=7)
  new AID 1
MGMT (TX callback) ACK
mgmt::assoc_resp cb
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state INITIALIZE
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state INITPSK
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:6d:1c:7e TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:6d:1c:7e TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:6d:1c:7e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:6d:1c:7e TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::assoc_req
association request: STA=00:22:43:4e:b6:68 capab_info=0x431 listen_interval=1
  new AID 2
MGMT (TX callback) ACK
mgmt::assoc_resp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITPSK
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:4e:b6:68
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::reassoc_req
reassociation request: STA=00:22:43:4e:b6:68 capab_info=0x431 listen_interval=1 current_ap=00:22:b0:70:1f:67
  new AID 2
MGMT (TX callback) ACK
mgmt::reassoc_resp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITPSK
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:4e:b6:68
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::reassoc_req
reassociation request: STA=00:22:43:4e:b6:68 capab_info=0x431 listen_interval=1 current_ap=00:22:b0:70:1f:67
  new AID 2
MGMT (TX callback) ACK
mgmt::reassoc_resp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITPSK
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:4e:b6:68
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::reassoc_req
reassociation request: STA=00:22:43:4e:b6:68 capab_info=0x431 listen_interval=1 current_ap=00:22:b0:70:1f:67
  new AID 2
MGMT (TX callback) ACK
mgmt::reassoc_resp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITPSK
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:4e:b6:68
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::reassoc_req
reassociation request: STA=00:22:43:4e:b6:68 capab_info=0x431 listen_interval=1 current_ap=00:22:b0:70:1f:67
  new AID 2
MGMT (TX callback) ACK
mgmt::reassoc_resp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITPSK
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:4e:b6:68
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT (TX callback) ACK
mgmt::auth cb
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::reassoc_req
reassociation request: STA=00:22:43:4e:b6:68 capab_info=0x431 listen_interval=1 current_ap=00:22:b0:70:1f:67
  new AID 2
MGMT (TX callback) ACK
mgmt::reassoc_resp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITPSK
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:4e:b6:68
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::assoc_req
association request: STA=00:22:43:4e:b6:68 capab_info=0x421 listen_interval=1
Station 00:22:43:4e:b6:68 tried to associate with unknown SSID 'g.isQ.J.)......F|.T.....vZ.c3...'
MGMT (TX callback) ACK
mgmt::assoc_resp cb
Signal 2 received - terminating
Removing station 00:22:43:4e:b6:68
Removing station 00:22:43:6d:1c:7e
Flushing old station entries
Deauthenticate all stations

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="log-2.6.31-rc_supplicant"

1249551558.991225: Failed to set interface wlan0 mode
Could not configure driver to use managed mode
1249551559.142202: CTRL-EVENT-SCAN-RESULTS 
1249551559.142239: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551569.145789: Authentication with 00:22:b0:70:1f:67 timed out.
1249551570.693280: CTRL-EVENT-SCAN-RESULTS 
1249551570.693312: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551570.704020: Associated with 00:22:b0:70:1f:67
1249551570.815526: WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
1249551570.815550: CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (auth) [id=1 id_str=]
1249551593.119329: CTRL-EVENT-SCAN-RESULTS 
1249551593.119359: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551603.129083: Authentication with 00:22:b0:70:1f:67 timed out.
1249551608.828109: CTRL-EVENT-SCAN-RESULTS 
1249551608.828140: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551618.832790: Authentication with 00:22:b0:70:1f:67 timed out.
1249551624.538095: CTRL-EVENT-SCAN-RESULTS 
1249551624.538121: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551634.548425: Authentication with 00:22:b0:70:1f:67 timed out.
1249551640.249570: CTRL-EVENT-SCAN-RESULTS 
1249551640.249600: WPS-AP-AVAILABLE 
1249551640.249618: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551650.260159: Authentication with 00:22:b0:70:1f:67 timed out.
1249551655.958193: CTRL-EVENT-SCAN-RESULTS 
1249551655.958227: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551665.971834: Authentication with 00:22:b0:70:1f:67 timed out.
1249551671.677018: CTRL-EVENT-SCAN-RESULTS 
1249551671.677033: WPS-AP-AVAILABLE 
1249551671.677051: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551681.687517: Authentication with 00:22:b0:70:1f:67 timed out.
1249551687.392821: CTRL-EVENT-SCAN-RESULTS 
1249551687.392837: WPS-AP-AVAILABLE 
1249551687.392860: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551697.403202: Authentication with 00:22:b0:70:1f:67 timed out.
1249551703.100532: CTRL-EVENT-SCAN-RESULTS 
1249551703.100549: WPS-AP-AVAILABLE 
1249551703.100567: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551713.110933: Authentication with 00:22:b0:70:1f:67 timed out.
1249551718.817161: CTRL-EVENT-SCAN-RESULTS 
1249551718.817187: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551728.830567: Authentication with 00:22:b0:70:1f:67 timed out.
1249551734.531741: CTRL-EVENT-SCAN-RESULTS 
1249551734.531755: WPS-AP-AVAILABLE 
1249551734.531773: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551744.542246: Authentication with 00:22:b0:70:1f:67 timed out.
1249551750.247648: CTRL-EVENT-SCAN-RESULTS 
1249551750.247683: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551760.257972: Authentication with 00:22:b0:70:1f:67 timed out.
1249551765.955249: CTRL-EVENT-SCAN-RESULTS 
1249551765.955264: WPS-AP-AVAILABLE 
1249551765.955281: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551775.965622: Authentication with 00:22:b0:70:1f:67 timed out.
1249551781.662997: CTRL-EVENT-SCAN-RESULTS 
1249551781.663011: WPS-AP-AVAILABLE 
1249551781.663033: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551791.673299: Authentication with 00:22:b0:70:1f:67 timed out.
1249551797.375640: CTRL-EVENT-SCAN-RESULTS 
1249551797.375664: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551807.388986: Authentication with 00:22:b0:70:1f:67 timed out.
1249551813.090229: CTRL-EVENT-SCAN-RESULTS 
1249551813.090249: WPS-AP-AVAILABLE 
1249551813.090280: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551823.100685: Authentication with 00:22:b0:70:1f:67 timed out.
1249551828.810839: CTRL-EVENT-SCAN-RESULTS 
1249551828.810863: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551838.824364: Authentication with 00:22:b0:70:1f:67 timed out.
1249551844.529671: CTRL-EVENT-SCAN-RESULTS 
1249551844.529693: WPS-AP-AVAILABLE 
1249551844.529722: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551854.540034: Authentication with 00:22:b0:70:1f:67 timed out.
1249551860.241398: CTRL-EVENT-SCAN-RESULTS 
1249551860.241421: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551870.251709: Authentication with 00:22:b0:70:1f:67 timed out.
1249551875.953273: CTRL-EVENT-SCAN-RESULTS 
1249551875.953287: WPS-AP-AVAILABLE 
1249551875.953326: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551885.967390: Authentication with 00:22:b0:70:1f:67 timed out.
1249551891.672556: CTRL-EVENT-SCAN-RESULTS 
1249551891.672579: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551901.683083: Authentication with 00:22:b0:70:1f:67 timed out.
1249551907.384247: CTRL-EVENT-SCAN-RESULTS 
1249551907.384261: WPS-AP-AVAILABLE 
1249551907.384283: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551917.394761: Authentication with 00:22:b0:70:1f:67 timed out.
1249551923.096442: CTRL-EVENT-SCAN-RESULTS 
1249551923.096466: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551933.110446: Authentication with 00:22:b0:70:1f:67 timed out.
1249551938.816877: CTRL-EVENT-SCAN-RESULTS 
1249551938.816891: WPS-AP-AVAILABLE 
1249551938.816914: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551948.830102: Authentication with 00:22:b0:70:1f:67 timed out.
1249551954.527975: CTRL-EVENT-SCAN-RESULTS 
1249551954.527999: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551964.541810: Authentication with 00:22:b0:70:1f:67 timed out.
1249551970.248059: CTRL-EVENT-SCAN-RESULTS 
1249551970.248074: WPS-AP-AVAILABLE 
1249551970.248097: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551980.261492: Authentication with 00:22:b0:70:1f:67 timed out.
1249551985.966601: CTRL-EVENT-SCAN-RESULTS 
1249551985.966625: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249551995.977290: Authentication with 00:22:b0:70:1f:67 timed out.
1249552001.678662: CTRL-EVENT-SCAN-RESULTS 
1249552001.678677: WPS-AP-AVAILABLE 
1249552001.678699: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249552011.692871: Authentication with 00:22:b0:70:1f:67 timed out.
1249552017.393959: CTRL-EVENT-SCAN-RESULTS 
1249552017.393975: WPS-AP-AVAILABLE 
1249552017.393993: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249552027.404550: Authentication with 00:22:b0:70:1f:67 timed out.
1249552033.105976: CTRL-EVENT-SCAN-RESULTS 
1249552033.106012: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249552043.120236: Authentication with 00:22:b0:70:1f:67 timed out.
1249552048.821525: CTRL-EVENT-SCAN-RESULTS 
1249552048.821539: WPS-AP-AVAILABLE 
1249552048.821557: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249552058.831928: Authentication with 00:22:b0:70:1f:67 timed out.
1249552064.537532: CTRL-EVENT-SCAN-RESULTS 
1249552064.537564: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249552074.551602: Authentication with 00:22:b0:70:1f:67 timed out.
1249552080.253859: CTRL-EVENT-SCAN-RESULTS 
1249552080.253874: WPS-AP-AVAILABLE 
1249552080.253892: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249552090.267282: Authentication with 00:22:b0:70:1f:67 timed out.
1249552095.968726: CTRL-EVENT-SCAN-RESULTS 
1249552095.968758: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249552098.623589: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
1249552105.978973: Authentication with 00:00:00:00:00:00 timed out.
1249552107.512188: CTRL-EVENT-SCAN-RESULTS 
1249552107.512202: WPS-AP-AVAILABLE 
1249552107.512220: Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
1249552107.524272: Associated with 00:22:b0:70:1f:67
1249552107.633550: WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
1249552107.633569: CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (reauth) [id=1 id_str=]
1249552695.494789: WPA: Group rekeying completed with 00:22:b0:70:1f:67 [GTK=TKIP]
1249553295.497882: WPA: Group rekeying completed with 00:22:b0:70:1f:67 [GTK=TKIP]
1249553895.500912: WPA: Group rekeying completed with 00:22:b0:70:1f:67 [GTK=TKIP]
1249554495.504122: WPA: Group rekeying completed with 00:22:b0:70:1f:67 [GTK=TKIP]
1249555095.504186: WPA: Group rekeying completed with 00:22:b0:70:1f:67 [GTK=TKIP]
1249555695.507150: WPA: Group rekeying completed with 00:22:b0:70:1f:67 [GTK=TKIP]
1249556138.297912: CTRL-EVENT-TERMINATING - signal 2 received

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="log-2.6.31-rc_event"

1249551558.946937: wlan0 (phy #0): deauth 00:22:43:4e:b6:68 -> 00:22:b0:70:1f:67 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS
1249551558.947142: wlan0 (phy #0): failed to connect to 00:22:b0:70:1f:67, status: 1: Unspecified failure
1249551559.142396: wlan0 (phy #0): deauth 00:22:43:4e:b6:68 -> 00:22:b0:70:1f:67 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS
1249551559.142476: wlan0 (phy #0): failed to connect to 00:22:b0:70:1f:67, status: 1: Unspecified failure
1249551559.142665: wlan0 (phy #0): deauth 00:22:43:4e:b6:68 -> 00:22:b0:70:1f:67 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS
1249551559.142710: wlan0 (phy #0): failed to connect to 00:22:b0:70:1f:67, status: 1: Unspecified failure
1249551559.742063: wlan0 (phy #0): auth: timed out
1249551559.742181: wlan0 (phy #0): failed to connect to 00:22:b0:70:1f:67, status: 1: Unspecified failure
1249551569.146244: wlan0 (phy #0): scan started
1249551570.693012: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249551570.697708: wlan0 (phy #0): auth 00:22:b0:70:1f:67 -> 00:22:43:4e:b6:68 status: 0: Successful
1249551570.703071: wlan0 (phy #0): assoc 00:22:b0:70:1f:67 -> 00:22:43:4e:b6:68 status: 0: Successful
1249551570.703195: wlan0 (phy #0): connected to 00:22:b0:70:1f:67
1249551587.424259: wlan0 (phy #0): scan started
1249551593.119069: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249551603.129311: wlan0 (phy #0): scan started
1249551608.827843: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249551618.833089: wlan0 (phy #0): scan started
1249551624.537943: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249551634.548605: wlan0 (phy #0): scan started
1249551640.249441: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249551650.260528: wlan0 (phy #0): scan started
1249551655.957187: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249551665.972140: wlan0 (phy #0): scan started
1249551671.676888: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249551681.687872: wlan0 (phy #0): scan started
1249551687.392659: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249551697.403507: wlan0 (phy #0): scan started
1249551703.100410: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249551713.111276: wlan0 (phy #0): scan started
1249551718.816955: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249551728.830929: wlan0 (phy #0): scan started
1249551734.531530: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249551744.542545: wlan0 (phy #0): scan started
1249551750.247395: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249551760.258302: wlan0 (phy #0): scan started
1249551765.955111: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249551775.965925: wlan0 (phy #0): scan started
1249551781.662768: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249551791.673670: wlan0 (phy #0): scan started
1249551797.375520: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249551807.389294: wlan0 (phy #0): scan started
1249551813.090095: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249551823.101047: wlan0 (phy #0): scan started
1249551828.810713: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249551838.824741: wlan0 (phy #0): scan started
1249551844.529412: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249551854.540362: wlan0 (phy #0): scan started
1249551860.241206: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249551870.252056: wlan0 (phy #0): scan started
1249551875.953055: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249551885.967759: wlan0 (phy #0): scan started
1249551891.672353: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249551901.683400: wlan0 (phy #0): scan started
1249551907.384036: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249551917.395075: wlan0 (phy #0): scan started
1249551923.096254: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249551933.110770: wlan0 (phy #0): scan started
1249551938.816683: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249551948.830323: wlan0 (phy #0): scan started
1249551954.527769: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249551964.542113: wlan0 (phy #0): scan started
1249551970.247866: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249551980.261870: wlan0 (phy #0): scan started
1249551985.966478: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249551995.977618: wlan0 (phy #0): scan started
1249552001.678466: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249552011.693235: wlan0 (phy #0): scan started
1249552017.393829: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249552027.404931: wlan0 (phy #0): scan started
1249552033.105717: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249552043.120540: wlan0 (phy #0): scan started
1249552048.821383: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249552058.832267: wlan0 (phy #0): scan started
1249552064.537283: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249552074.551923: wlan0 (phy #0): scan started
1249552080.253647: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "unitn-x"
1249552090.267658: wlan0 (phy #0): scan started
1249552095.968486: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, "Istituto Colli"
1249552098.623109: wlan0 (phy #0): deauth 00:22:b0:70:1f:67 -> 00:22:43:4e:b6:68 reason 2: Previous authentication no longer valid
1249552098.623197: wlan0 (phy #0): disconnected (by AP) reason: 2: Previous authentication no longer valid
1249552105.979359: wlan0 (phy #0): scan started
1249552107.512059: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1249552107.516765: wlan0 (phy #0): auth 00:22:b0:70:1f:67 -> 00:22:43:4e:b6:68 status: 0: Successful
1249552107.523846: wlan0 (phy #0): assoc 00:22:b0:70:1f:67 -> 00:22:43:4e:b6:68 status: 0: Successful
1249552107.523947: wlan0 (phy #0): connected to 00:22:b0:70:1f:67
1249556138.314016: wlan0 (phy #0): deauth 00:22:43:4e:b6:68 -> 00:22:b0:70:1f:67 reason 3: Deauthenticated because sending station is leaving (or has left) the 
--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="logAP_2.6.31-rc"

Configuration file: /etc/hostapd.conf
Line 13: DEPRECATED: 'debug' configuration variable is not used anymore
ctrl_interface_group=0
Opening raw packet socket for ifindex 209
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=12 freq=2467 MHz max_tx_power=18 dBm
Allowed channel: mode=1 chan=13 freq=2472 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=12 freq=2467 MHz max_tx_power=18 dBm
Allowed channel: mode=0 chan=13 freq=2472 MHz max_tx_power=18 dBm
RATE[0] rate=10 flags=0x2
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
Mode: IEEE 802.11g  Channel: 4  Frequency: 2427 MHz
Using interface wlan0 with hwaddr 00:22:b0:70:1f:67 and ssid 'Istituto Colli'
SSID - hexdump_ascii(len=14):
     49 73 74 69 74 75 74 6f 20 43 6f 6c 6c 69         Istituto Colli  
PSK (ASCII passphrase) - hexdump_ascii(len=18):
     74 61 63 69 2c 20 74 75 6c 6c 69 61 20 64 6f 72   taci, tullia dor
     6d 65                                             me              
PSK (from passphrase) - hexdump(len=32): 19 f6 ff fb 3e 49 0d 36 7b ff 05 20 de 3d 4c 93 56 62 04 30 18 ad 42 e5 a7 12 79 4d 8b c8 80 d2
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wlan0: Setup of interface done.
MGMT (TX callback) ACK
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::assoc_req
association request: STA=00:22:43:4e:b6:68 capab_info=0x431 listen_interval=1
  new AID 1
MGMT (TX callback) ACK
mgmt::assoc_resp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITPSK
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:4e:b6:68
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
STA 00:22:43:6d:1c:7e sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:6d:1c:7e sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::auth
authentication: STA=00:22:43:6d:1c:7e auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:6d:1c:7e auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::assoc_req
association request: STA=00:22:43:6d:1c:7e capab_info=0x411 listen_interval=3
unknown vendor specific information element ignored (vendor OUI 00:0c:43 len=7)
  new AID 2
MGMT (TX callback) ACK
mgmt::assoc_resp cb
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state INITIALIZE
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state INITPSK
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:6d:1c:7e TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:6d:1c:7e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:6d:1c:7e TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
Station 00:22:43:4e:b6:68 trying to deauthenticate, but it is not authenticated.
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::assoc_req
association request: STA=00:22:43:4e:b6:68 capab_info=0x431 listen_interval=1
  new AID 1
MGMT (TX callback) ACK
mgmt::assoc_resp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITPSK
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:4e:b6:68
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
WPA: group state machine entering state SETKEYS (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
wpa_group_setkeys: GKeyDoneStations=2
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state KEYERROR
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECT
hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect: STA 00:22:43:4e:b6:68 reason 2
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
MGMT (TX callback) ACK
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::auth
authentication: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
authentication reply: STA=00:22:43:4e:b6:68 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
MGMT
mgmt::assoc_req
association request: STA=00:22:43:4e:b6:68 capab_info=0x431 listen_interval=1
  new AID 1
MGMT (TX callback) ACK
mgmt::assoc_resp cb
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state AUTHENTICATION2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITPSK
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKSTART
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 123 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=119
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:22:b0:70:1f:67 A2=00:22:43:4e:b6:68
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITNEGOTIATING
WPA: Send EAPOL(version=2 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=28 keyidx=0 encr=0)
IEEE 802.1X: 00:22:43:4e:b6:68 TX status - version=2 type=3 length=123 - ack=1
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state PTKINITDONE
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
WPA: group state machine entering state SETKEYS (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
wpa_group_setkeys: GKeyDoneStations=2
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
WPA: group state machine entering state SETKEYS (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
wpa_group_setkeys: GKeyDoneStations=2
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
WPA: group state machine entering state SETKEYS (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
wpa_group_setkeys: GKeyDoneStations=2
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
WPA: group state machine entering state SETKEYS (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
wpa_group_setkeys: GKeyDoneStations=2
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
WPA: group state machine entering state SETKEYS (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
wpa_group_setkeys: GKeyDoneStations=2
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:23:12:a1:8f:aa sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:23:12:a1:8f:aa sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
WPA: group state machine entering state SETKEYS (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=2 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=40): [REMOVED]
wpa_group_setkeys: GKeyDoneStations=2
IEEE 802.1X: 99 bytes from 00:22:43:4e:b6:68
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: 00:22:43:4e:b6:68 WPA_PTK_GROUP entering state IDLE
IEEE 802.1X: 99 bytes from 00:22:43:6d:1c:7e
   IEEE 802.1X: version=1 type=3 length=95
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state REKEYESTABLISHED
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
WPA: 00:22:43:6d:1c:7e WPA_PTK_GROUP entering state IDLE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:6d:1c:7e inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:22:43:4e:b6:68 inactivity:
  Station has been active
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state DISCONNECTED
WPA: 00:22:43:4e:b6:68 WPA_PTK entering state INITIALIZE
STA 00:22:43:4e:b6:68 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT
mgmt::deauth
deauthentication: STA=00:22:43:4e:b6:68 reason_code=3
Station 00:22:43:4e:b6:68 trying to deauthenticate, but it is not authenticated.
Signal 2 received - terminating
Removing station 00:22:43:6d:1c:7e
Flushing old station entries
Deauthenticate all stations

--vGgW1X5XWziG23Ko--
