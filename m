Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:44336 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935107Ab2JYOBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 10:01:45 -0400
Received: from smtp28.msg.oleane.net (smtp28.mail.priv [172.17.20.150])
	by smtp-out06.msg.oleane.net with ESMTP id q9PE1fUo021432
	for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 16:01:41 +0200
From: =?utf-8?Q?C=C3=A9dric_Debarge_-_ACKSYS?= <cedric.debarge@acksys.fr>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A31901411778@sbs2003.acksys.local>	 (sfid-20121018_094934_139014_F8666167) <1350996238.10322.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350996238.10322.7.camel@jlt4.sipsolutions.net>
Subject: RE: TR: Clear data transit during WPA negociation in case of reassociation
Date: Thu, 25 Oct 2012 15:42:56 +0200
Message-ID: <01e901cdb2b6$a41df0b0$ec59d210$@acksys.fr> (sfid-20121025_160151_580755_C002DCC0)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_01EA_01CDB2C7.67A86E60"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_01EA_01CDB2C7.67A86E60
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

	Thanks for answering.
=09
	Please find attached the wpa_supplicant log file (it is quite big =
because of the EAP-TLS) you asked for.
=09
	Here are some explanations :=20
		AP1 : BSSID =3D 00:1B:B1:58:F6:DD, channel 136, 802.11a
		AP2 : BSSID =3D 90:A4:DE:AA:42:94, channel 132, 802.11a
=09
	I simply ask the client to roam using the wpa_cli roam command.
	The first roam on each AP is ok (line 167 & line 641) but when the =
client comes back to the first one (line 1116), I can see unencrypted =
frames as I've described in the previous email.
	Next roams (line 1505 & line 1712) have the same problem.

	PS : the attached file is not taken from the previous test but I get it =
in the same way.

Regards,

C=C3=A9dric DEBARGE

-----Message d'origine-----
De : Johannes Berg [mailto:johannes@sipsolutions.net]=20
Envoy=C3=A9 : mardi 23 octobre 2012 14:44
=C3=80 : Cedric Debarge
Cc : linux-wireless@vger.kernel.org
Objet : Re: TR: Clear data transit during WPA negociation in case of =
reassociation

On Thu, 2012-10-18 at 09:30 +0200, Cedric Debarge wrote:
> Hi all,
>=20
> 	I am not sure if this is the right place to post my question. Please =
forgive me if not.
>=20
> 	I am experimenting roaming between two APs with wpa_supplicant (WPA2 =
+ EAP-TLS).
> 	When WPA_Supplicant come back from an AP for which it has already =
cached the key, I saw that during WPA2 4 Handshake (in case of =
reassociation), data are sent through wpa_supplicant unencrypted.
>=20
> 	As soon as the WPA2 successfully ends its negotiation, the data are =
sent encrypted back.
>=20
> 	I attached to this email a Wireshark capture of the wireless =
transaction. Before this capture the frames were correctly encrypted.=20
> 	You can see the start of the WPA2 4 Handshake protocol at packet =
number 10.
> 	During this 4 Handshake protocol you could see unencrypted iperf (UDP =
5001) packets N=C2=B012/17/18/22/24.. until packet 55.=20
> 	4 Handshake protocol ends at packet 49.
>=20
> 	Can you give me some clue how to work it out ?

Can you show the wpa_supplicant debug log for this?

johannes


------=_NextPart_000_01EA_01CDB2C7.67A86E60
Content-Type: text/plain;
	name="dump.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dump.txt"

wpa_supplicant v2.0-devel=0A=
random: Trying to read entropy from /dev/random=0A=
Successfully initialized wpa_supplicant=0A=
Initializing interface 'wlan0' conf '/var/run/wpa_supplicant-wlan0.conf' =
driver 'default' ctrl_interface 'N/A' bridge 'br-lan'=0A=
Configuration file '/var/run/wpa_supplicant-wlan0.conf' -> =
'/var/run/wpa_supplicant-wlan0.conf'=0A=
Reading configuration file '/var/run/wpa_supplicant-wlan0.conf'=0A=
ctrl_interface=3D'/var/run/wpa_supplicant-wlan0'=0A=
Line: 3 - start of a new network block=0A=
scan_ssid=3D1 (0x1)=0A=
ssid - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
key_mgmt: 0x1=0A=
proto: 0x2=0A=
frequency=3D5660 (0x161c)=0A=
pairwise: 0x10=0A=
group: 0x10=0A=
eap methods - hexdump(len=3D16): 00 00 00 00 00 00 00 0d 00 00 00 00 00 =
00 00 00=0A=
ca_cert - hexdump_ascii(len=3D46):=0A=
     2f 6c 69 62 2f 75 63 69 2f 75 70 6c 6f 61 64 2f   /lib/uci/upload/=0A=
     63 62 69 64 2e 77 69 72 65 6c 65 73 73 2e 72 61   cbid.wireless.ra=0A=
     64 69 6f 30 77 30 2e 63 61 5f 63 65 72 74         dio0w0.ca_cert  =0A=
client_cert - hexdump_ascii(len=3D50):=0A=
     2f 6c 69 62 2f 75 63 69 2f 75 70 6c 6f 61 64 2f   /lib/uci/upload/=0A=
     63 62 69 64 2e 77 69 72 65 6c 65 73 73 2e 72 61   cbid.wireless.ra=0A=
     64 69 6f 30 77 30 2e 63 6c 69 65 6e 74 5f 63 65   dio0w0.client_ce=0A=
     72 74                                             rt              =0A=
private_key - hexdump_ascii(len=3D47):=0A=
     2f 6c 69 62 2f 75 63 69 2f 75 70 6c 6f 61 64 2f   /lib/uci/upload/=0A=
     63 62 69 64 2e 77 69 72 65 6c 65 73 73 2e 72 61   cbid.wireless.ra=0A=
     64 69 6f 30 77 30 2e 70 72 69 76 5f 6b 65 79      dio0w0.priv_key =0A=
private_key_passwd - hexdump_ascii(len=3D7): [REMOVED]=0A=
identity - hexdump_ascii(len=3D9):=0A=
     61 6e 6f 6e 79 6d 6f 75 73                        anonymous       =0A=
Priority group 0=0A=
   id=3D0 ssid=3D'cdtest'=0A=
nl80211: interface wlan0 in phy phy0=0A=
nl80211: Set mode ifindex 5 iftype 2 (STATION)=0A=
nl80211: Subscribe to mgmt frames with non-AP handle 0x10426ca0=0A=
nl80211: Register frame type=3D0xd0 nl_handle=3D0x10426ca0=0A=
nl80211: Register frame match - hexdump(len=3D2): 08 01=0A=
nl80211: Register frame type=3D0xd0 nl_handle=3D0x10426ca0=0A=
nl80211: Register frame match - hexdump(len=3D1): 06=0A=
nl80211: Register frame type=3D0xd0 nl_handle=3D0x10426ca0=0A=
nl80211: Register frame match - hexdump(len=3D2): 0a 07=0A=
netlink: Operstate: linkmode=3D1, operstate=3D5=0A=
nl80211: Using driver-based off-channel TX=0A=
nl80211: Use separate P2P group interface (driver advertised support)=0A=
nl80211: TDLS supported=0A=
nl80211: TDLS external setup=0A=
nl80211: driver param=3D'(null)'=0A=
nl80211: Regulatory information - country=3DFR=0A=
nl80211: 2402-2482 @ 40 MHz=0A=
nl80211: 5170-5250 @ 40 MHz=0A=
nl80211: 5250-5330 @ 40 MHz=0A=
nl80211: 5490-5710 @ 40 MHz=0A=
nl80211: Added 802.11b mode based on 802.11g information=0A=
wlan0: Own MAC address: 90:a4:de:21:4f:53=0A=
wlan0: Receiving packets from bridge interface 'br-lan'=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D4 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D5 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wlan0: RSN: flushing PMKID list in the driver=0A=
nl80211: Flush PMKIDs=0A=
bgscan_acksys: autoscan_acksys_init: start=0A=
wlan0: Setting scan request: 0 sec 100000 usec=0A=
WPS: Set UUID for interface wlan0=0A=
WPS: UUID based on MAC address - hexdump(len=3D16): e7 02 d4 23 1b 23 50 =
fe 97 04 b8 1a f4 f3 de 06=0A=
EAPOL: SUPP_PAE entering state DISCONNECTED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: KEY_RX entering state NO_KEY_RECEIVE=0A=
EAPOL: SUPP_BE entering state INITIALIZE=0A=
EAP: EAP entering state DISABLED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
wlan0: Added interface wlan0=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1002 ()=0A=
nl80211: Ignore interface down event since interface wlan0 is up=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
wlan0: State: DISCONNECTED -> SCANNING=0A=
Scan SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
wlan0: Starting AP scan for wildcard SSID=0A=
nl80211: Scan SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
Scan requested (ret=3D0) - scan timeout 10 seconds=0A=
nl80211: Event message available=0A=
nl80211: Scan trigger=0A=
EAPOL: disable timer tick=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
nl80211: Event message available=0A=
nl80211: New scan results available=0A=
wlan0: Event SCAN_RESULTS (3) received=0A=
nl80211: Received scan results (13 BSSes)=0A=
wlan0: BSS: Start scan result update 1=0A=
wlan0: BSS: Add new id 0 BSSID 00:1b:b1:58:f6:dd SSID 'cdtest'=0A=
wlan0: BSS: Add new id 1 BSSID 90:a4:de:aa:42:94 SSID 'cdtest'=0A=
wlan0: BSS: Add new id 2 BSSID 00:0e:8e:0a:3a:a1 SSID =
'acksyssalledereunion'=0A=
wlan0: BSS: Add new id 3 BSSID f4:ca:e5:d2:12:2e SSID 'FreeWifi_secure'=0A=
wlan0: BSS: Add new id 4 BSSID 00:80:48:64:22:5a SSID 'az12@bjKm'=0A=
wlan0: BSS: Add new id 5 BSSID 00:19:70:32:b3:a2 SSID 'Livebox-cdd8'=0A=
wlan0: BSS: Add new id 6 BSSID 00:1c:f0:08:cf:10 SSID 'MDY'=0A=
wlan0: BSS: Add new id 7 BSSID f4:ca:e5:d2:12:2c SSID 'lemezo'=0A=
wlan0: BSS: Add new id 8 BSSID 00:1b:b1:58:f6:cb SSID 'acksys'=0A=
wlan0: BSS: Add new id 9 BSSID 90:a4:de:21:4e:f7 SSID 'acksys'=0A=
wlan0: BSS: Add new id 10 BSSID 90:a4:de:21:4f:11 SSID 'PRO4500Z1'=0A=
wlan0: BSS: Add new id 11 BSSID 00:1b:b1:58:f6:05 SSID 'acksys'=0A=
wlan0: BSS: Add new id 12 BSSID f4:ca:e5:d2:12:2d SSID 'FreeWifi'=0A=
wlan0: New scan results available=0A=
wlan0: Selecting BSS from priority group 0=0A=
wlan0: 0: 00:1b:b1:58:f6:dd ssid=3D'cdtest' wpa_ie_len=3D0 =
rsn_ie_len=3D20 caps=3D0x11 level=3D-47=0A=
wlan0:    selected based on RSN IE=0A=
wlan0:    selected BSS 00:1b:b1:58:f6:dd ssid=3D'cdtest'=0A=
wlan0: Request association: reassociate: 0  selected: 00:1b:b1:58:f6:dd  =
bssid: 00:00:00:00:00:00  pending: 00:00:00:00:00:00  wpa_state: SCANNING=0A=
wlan0: Automatic auth_alg selection: 0x1=0A=
RSN: PMKSA cache search - network_ctx=3D(nil) try_opportunistic=3D0=0A=
RSN: Search for BSSID 00:1b:b1:58:f6:dd=0A=
RSN: No PMKSA cache entry found=0A=
wlan0: RSN: using IEEE 802.11i/D9.0=0A=
wlan0: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 1 =
proto 2=0A=
wlan0: WPA: clearing AP WPA IE=0A=
WPA: set AP RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 00 00 =
0f ac 04 01 00 00 0f ac 01 0c 00=0A=
wlan0: WPA: using GTK CCMP=0A=
wlan0: WPA: using PTK CCMP=0A=
wlan0: WPA: using KEY_MGMT 802.1X=0A=
wlan0: WPA: not using MGMT group cipher=0A=
WPA: Set own WPA IE default - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
wlan0: Cancelling scan request=0A=
wlan0: SME: Trying to authenticate with 00:1b:b1:58:f6:dd =
(SSID=3D'cdtest' freq=3D5680 MHz)=0A=
wlan0: No keys have been configured - skip key clearing=0A=
wlan0: State: SCANNING -> AUTHENTICATING=0A=
EAPOL: External notification - EAP success=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - EAP fail=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portControl=3DAuto=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
nl80211: Authenticate (ifindex=3D5)=0A=
  * bssid=3D00:1b:b1:58:f6:dd=0A=
  * freq=3D5680=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D0): [NULL]=0A=
  * Auth Type 0=0A=
nl80211: Authentication request send successfully=0A=
RSN: Ignored PMKID candidate without preauth flag=0A=
RSN: Ignored PMKID candidate without preauth flag=0A=
wlan0: Checking for other virtual interfaces sharing same radio (phy0) =
in event_scan_results=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: New station 00:1b:b1:58:f6:dd=0A=
nl80211: Event message available=0A=
nl80211: MLME event 37=0A=
nl80211: MLME event frame - hexdump(len=3D30): b0 00 3c 00 90 a4 de 21 =
4f 53 00 1b b1 58 f6 dd 00 1b b1 58 f6 dd 60 15 00 00 02 00 00 00=0A=
wlan0: Event AUTH (11) received=0A=
wlan0: SME: Authentication response: peer=3D00:1b:b1:58:f6:dd =
auth_type=3D0 status_code=3D0=0A=
SME: Authentication response IEs - hexdump(len=3D0): [NULL]=0A=
wlan0: Trying to associate with 00:1b:b1:58:f6:dd (SSID=3D'cdtest' =
freq=3D5680 MHz)=0A=
wlan0: State: AUTHENTICATING -> ASSOCIATING=0A=
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
WPA: set own WPA/RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00=0A=
nl80211: Associate (ifindex=3D5)=0A=
  * bssid=3D00:1b:b1:58:f6:dd=0A=
  * freq=3D5680=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 =
01 00 00 0f ac 01 00 00=0A=
  * pairwise=3D0xfac04=0A=
  * group=3D0xfac04=0A=
nl80211: Association request send successfully=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: MLME event 38=0A=
nl80211: MLME event frame - hexdump(len=3D66): 10 00 3c 00 90 a4 de 21 =
4f 53 00 1b b1 58 f6 dd 00 1b b1 58 f6 dd 70 15 11 00 00 00 01 c0 01 08 =
8c 12 98 24 b0 48 60 6c dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 =
00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: Event ASSOC (0) received=0A=
wlan0: Association info event=0A=
resp_ies - hexdump(len=3D36): 01 08 8c 12 98 24 b0 48 60 6c dd 18 00 50 =
f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: freq=3D5680 MHz=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
wlan0: State: ASSOCIATING -> ASSOCIATED=0A=
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
wlan0: Associated to a new BSS: BSSID=3D00:1b:b1:58:f6:dd=0A=
wlan0: No keys have been configured - skip key clearing=0A=
wlan0: Associated with 00:1b:b1:58:f6:dd=0A=
wlan0: WPA: Association event - clear replay counter=0A=
wlan0: WPA: Clear old PTK=0A=
EAPOL: External notification - portEnabled=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portValid=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portEnabled=3D1=0A=
EAPOL: SUPP_PAE entering state CONNECTING=0A=
EAPOL: enable timer tick=0A=
EAPOL: SUPP_BE entering state IDLE=0A=
EAP: EAP entering state INITIALIZE=0A=
EAP: EAP entering state IDLE=0A=
wlan0: Setting authentication timeout: 10 sec 0 usec=0A=
wlan0: Cancelling scan request=0A=
nl80211: Event message available=0A=
nl80211: Ignore connect event (cmd=3D46) when using userspace SME=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D9): 02 00 00 05 01 7c 00 05 01=0A=
wlan0: Setting authentication timeout: 70 sec 0 usec=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_PAE entering state RESTART=0A=
EAP: EAP entering state INITIALIZE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_PAE entering state AUTHENTICATING=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D124 method=3D1 vendor=3D0 vendorMethod=3D0=0A=
EAP: EAP entering state IDENTITY=0A=
wlan0: CTRL-EVENT-EAP-STARTED EAP authentication started=0A=
EAP: EAP-Request Identity data - hexdump_ascii(len=3D0):=0A=
EAP: using real identity - hexdump_ascii(len=3D9):=0A=
     61 6e 6f 6e 79 6d 6f 75 73                        anonymous       =0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D00:1b:b1:58:f6:dd=0A=
TX EAPOL - hexdump(len=3D18): 01 00 00 0e 02 7c 00 0e 01 61 6e 6f 6e 79 =
6d 6f 75 73=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D10): 02 00 00 06 01 7d 00 06 0d 20=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D125 method=3D13 vendor=3D0 =
vendorMethod=3D0=0A=
EAP: EAP entering state GET_METHOD=0A=
wlan0: CTRL-EVENT-EAP-PROPOSED-METHOD vendor=3D0 method=3D13=0A=
EAP: Initialize selected EAP method: vendor 0 method 13 (TLS)=0A=
TLS: using phase1 config options=0A=
TLS: Trusted root certificate(s) loaded=0A=
OpenSSL: SSL_use_certificate_file (PEM) --> OK=0A=
OpenSSL: SSL_use_PrivateKey_File (PEM) --> OK=0A=
SSL: Private key loaded successfully=0A=
wlan0: CTRL-EVENT-EAP-METHOD EAP vendor 0 method 13 (TLS) selected=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D6) - Flags 0x20=0A=
EAP-TLS: Start=0A=
SSL: (where=3D0x10 ret=3D0x1)=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:before/connect initialization=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write client hello A=0A=
SSL: (where=3D0x1002 ret=3D0xffffffff)=0A=
SSL: SSL_connect:error in SSLv3 read server hello A=0A=
SSL: SSL_connect - want more data=0A=
SSL: 95 bytes pending from ssl_out=0A=
SSL: 95 bytes left to be sent out (of total 95 bytes)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D00:1b:b1:58:f6:dd=0A=
TX EAPOL - hexdump(len=3D105): 01 00 00 65 02 7d 00 65 0d 00 16 03 01 00 =
5a 01 00 00 56 03 01 50 3c d6 6c 5f 6a ee 28 3d c5 3e 84 19 ea 54 d3 92 =
81 58 8d 46 0c 04 9a f1 4c fa b0 0c 66 8d f9 00 00 28 00 39 00 38 00 35 =
00 16 00 13 00 0a 00 33 00 32 00 2f 00 05 00 04 00 15 00 12 00 09 00 14 =
00 11 00 08 00 06 00 03 00 ff 02 01 00 00 04 00 23 00 00=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D1028): 02 00 04 00 01 7e 04 00 0d c0 00 00 0b =
57 16 03 01 00 31 02 00 00 2d 03 01 50 89 2f 7d a1 34 a4 63 3d 51 35 b5 =
a9 aa a3 47 14 63 71 74 4b 81 94 98 e7 6b ea 1c 43 16 d0 6b 00 00 39 01 =
00 05 ff 01 00 01 00 16 03 01 08 5e 0b 00 08 5a 00 08 57 00 03 a6 30 82 =
03 a2 30 82 02 8a a0 03 02 01 02 02 01 01 30 0d 06 09 2a 86 48 86 f7 0d =
01 01 04 05 00 30 81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 =
0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 =
09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 =
6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 =
16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 =
03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 =
65 20 41 75 74 68 6f 72 69 74 79 30 1e 17 0d 31 32 30 35 30 33 31 33 34 =
39 35 37 5a 17 0d 31 33 30 35 30 33 31 33 34 39 35 37 5a 30 7c 31 0b 30 =
09 06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 =
69 75 73 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e =
63 2e 31 23 30 21 06 03 55 04 03 13 1a 45 78 61 6d 70 6c 65 20 53 65 72 =
76 65 72 20 43 65 72 74 69 66 69 63 61 74 65 31 20 30 1e 06 09 2a 86 48 =
86 f7 0d 01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f =
6d 30 82 01 22 30 0d 06 09 2a 86 48 86 f7 0d 01 01 01 05 00 03 82 01 0f =
00 30 82 01 0a 02 82 01 01 00 ca 02 3e d7 9b 0a bd ac fa b8 a6 be 93 5b =
09 24 1e 83 df 4d 17 b2 11 ea cb f4 f8 b2 e6 59 bd 18 2e 30 66 cd 7d 40 =
97 1b a0 53 d7 80 2f 30 32 6a ae 74 dc 9b ac 2e 73 ed e2 c6 bf d6 e6 d6 =
51 33 08 4c 65 73 40 0f e0 58 b4 51 a5 e1 67 1b 1e 49 13 c4 72 d3 51 a5 =
28 84 96 4b 00 0d 81 4a 9e b6 a2 9f fa e0 71 4c 2d d4 d1 7a 1a 29 5b 55 =
14 63 e1 07 20 68 68 ae 55 14 1a 4f be e4 0e 73 88 80 1a c9 eb 92 cd e1 =
e9 2b 1b 32 28 af 8d e9 cd 10 4b 6a 2f 24 06 2a 15 79 8f fd 53 f4 94 e5 =
54 d0 5d cb 42 bf f0 d6 85 1c 2b e1 2c 8d d7 97 6a 2a 67 f1 ba 5c c7 c9 =
f3 85 88 69 5e b6 4f c1 bd cd 49 9a 4e 36 62 a9 10 0f 28 cc e0 5b e3 5b =
39 66 be 4a 61 c4 b7 53 f4 1c b9 bf b3 3e e7 e7 b4 cd c0 6c 3c 39 d4 0b =
aa 99 80 8f de 34 4d f3 ec ad 15 3a 55 af 0b 28 f5 e5 3e 26 c8 85 7f d5 =
a1 c3 02 03 01 00 01 a3 17 30 15 30 13 06 03 55 1d 25 04 0c 30 0a 06 08 =
2b 06 01 05 05 07 03 01 30 0d 06 09 2a 86 48 86 f7 0d 01 01 04 05 00 03 =
82 01 01 00 6e 45 2e 1e fc 39 3e fa db 63 0e c7 f9 65 f3 9a 0f 57 40 b4 =
6c 98 fd bd fd 76 dc d6 8a 82 1b 58 32 c9 37 d3 c9 0e ac a9 4e 28 8c 56 =
6b 55 08 82 ce 23 87 3c 9e ca 43 7f 9f 6c 04 42 23 8c c7 03 b5 9c 10 0b =
f7 ff 38 c2 7a 88 0a c4 62 a0 bd cc f2 54 98 2c 20 33 9a 17 fe 35 27 f5 =
b9 4c 39 44 77 35 cf 45 f1 69 4c 4b af 35 3d d6 3b 38 90 72 9f 56 02 15 =
9d 32 2f b0 cc 17 b8 d0 ee c4 35 29 08 0b 42 5f 05 cd 7a 73 0d bf ad 1d =
a4 6c 98 04 2c 0f 6c 75 c0 0b 41 d4 53 9a 81 31 ea 5d 51 27 ab 1e a6 4d =
1a 9f b7 c3 bc e7 8b 64 2d 32 6e 19 73 58 ad 22 f7 e1 52 6e 60 55 b1 0e =
cc c9 b2 ac c2 55 60 d9 0c 42 32 a3 d5 df 35 ca 0e ef c3 3a 00 9b 2d 46 =
dc 7e 59 6e fd d0 d7 03 03 96 17 2d 53 7b 40 52 6d 69 22 3e 0d 40 db e0 =
03 ab 7c 4a b9 8d 08 7e f4 f7 24 71 1d 3d 1c 17 de 57 5a 90 00 04 ab 30 =
82 04 a7 30 82 03 8f=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D126 method=3D13 vendor=3D0 =
vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D1024) - Flags 0xc0=0A=
SSL: TLS Message Length: 2903=0A=
SSL: Need 1889 bytes more input data=0A=
SSL: Building ACK (type=3D13 id=3D126 ver=3D0)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D00:1b:b1:58:f6:dd=0A=
TX EAPOL - hexdump(len=3D10): 01 00 00 06 02 7e 00 06 0d 00=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D1028): 02 00 04 00 01 7f 04 00 0d c0 00 00 0b =
57 a0 03 02 01 02 02 09 00 89 95 bd d4 00 94 4a 26 30 0d 06 09 2a 86 48 =
86 f7 0d 01 01 05 05 00 30 81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 =
31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 =
04 07 13 09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c =
45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d =
01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 =
30 24 06 03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 =
63 61 74 65 20 41 75 74 68 6f 72 69 74 79 30 1e 17 0d 31 32 30 35 30 33 =
31 33 34 39 35 37 5a 17 0d 31 33 30 35 30 33 31 33 34 39 35 37 5a 30 81 =
93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 =
06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 68 =
65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e =
63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 6e =
40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d 45 =
78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 6f =
72 69 74 79 30 82 01 22 30 0d 06 09 2a 86 48 86 f7 0d 01 01 01 05 00 03 =
82 01 0f 00 30 82 01 0a 02 82 01 01 00 9e 34 8e d1 c3 75 3a 22 29 b2 dd =
98 e2 01 2d 9d 6c 91 c5 89 b4 15 a2 5b c5 78 80 cd de cf a1 b7 59 70 b2 =
8a 97 64 df c5 22 40 39 d0 e6 b3 b4 e6 44 55 d1 23 36 fa f8 e8 ae 72 6a =
b2 1e 16 a5 ab 3f 76 8b 30 a6 4c a9 27 7d 52 0e bf e7 0c 52 52 5b 23 42 =
18 f9 a7 0c 1e f3 c3 21 00 a6 ac 11 e0 56 4f 34 04 c0 a4 ae ce 6c 9f b6 =
ba 57 c9 08 11 a9 99 0d cb c1 a2 0e fa 33 a8 c3 9b ec 37 95 ac f6 91 d1 =
1b b7 76 00 48 5b b4 07 8e bf bb 12 fa 57 35 d5 59 de 2f 12 a1 0e 72 ac =
7a 91 b8 b3 66 31 e5 19 be dd 0a c2 67 f5 0f 0c 6b 62 d8 1f 6c 30 3d bf =
ef 7a dc 9a ac d5 b6 06 f2 43 28 ab e0 90 42 c8 0b 68 23 e9 4c a4 1e 62 =
a6 c2 01 aa a0 c5 12 ca d0 ac 46 7e ef b0 6b 86 aa 67 79 33 56 eb fb 1f =
b8 57 66 fd 2d e3 c7 a2 37 e6 1b bf 14 32 7b 1e f9 7a c3 02 e6 f3 4c 09 =
d7 75 05 d2 5d 02 03 01 00 01 a3 81 fb 30 81 f8 30 1d 06 03 55 1d 0e 04 =
16 04 14 b5 52 d1 e7 e5 76 8b d1 01 80 79 1b 24 ea 53 a8 76 34 2b 67 30 =
81 c8 06 03 55 1d 23 04 81 c0 30 81 bd 80 14 b5 52 d1 e7 e5 76 8b d1 01 =
80 79 1b 24 ea 53 a8 76 34 2b 67 a1 81 99 a4 81 96 30 81 93 31 0b 30 09 =
06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 =
75 73 31 12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 68 65 72 65 31 15 =
30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 20 30 =
1e 06 09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d =
70 6c 65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d 45 78 61 6d 70 6c =
65 20 43 65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 6f 72 69 74 79 82 =
09 00 89 95 bd d4 00 94 4a 26 30 0c 06 03 55 1d 13 04 05 30 03 01 01 ff =
30 0d 06 09 2a 86 48 86 f7 0d 01 01 05 05 00 03 82 01 01 00 40 28 ff 3b =
19 ba 33 5e ab fc ad 60 14 53 fa 1b b4 55 d0 49 5d 66 dd 49 e7 b1 8d 61 =
ed ef bc fb 7d 56 22 05 d9 3d fd f6 a3 be c6 3a 1d c6 c9 64 36 c4 d4 61 =
d2 3a f9 c1 57 e5 bc 44 e2 53 06 60 f6 19 33 b4 ba 0a 4f 5c 3c 2d e8 4d =
05 38 14 e6 ff 7d 6a=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D127 method=3D13 vendor=3D0 =
vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D1024) - Flags 0xc0=0A=
SSL: TLS Message Length: 2903=0A=
SSL: Need 875 bytes more input data=0A=
SSL: Building ACK (type=3D13 id=3D127 ver=3D0)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D00:1b:b1:58:f6:dd=0A=
TX EAPOL - hexdump(len=3D10): 01 00 00 06 02 7f 00 06 0d 00=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
EAPOL: startWhen --> 0=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D889): 02 00 03 75 01 80 03 75 0d 80 00 00 0b 57 =
c1 72 0e 02 9e 28 1b a9 12 30 1a a4 c8 c8 92 85 d6 dd 80 ea 26 45 b9 4f =
61 82 aa ea 96 d9 0e bf 68 03 70 ab 23 a6 33 09 79 fb f9 c9 c0 20 e9 6f =
98 3c eb 54 29 c8 fd 1d 26 f2 c1 ec 29 fc 0e 18 cc b2 4a f1 57 41 0c 7f =
d2 04 12 33 90 23 f8 ca 8b 0a 92 80 51 1f 5c a9 9e 2a 93 7c ae 6a 44 19 =
b1 c9 17 df 44 ce 7c e5 c5 f7 a7 64 ea 89 34 bf 0c 39 f1 e2 ec e0 11 ab =
58 54 80 5f 3b e8 6b a7 43 4a 42 e3 d7 8c 19 33 28 0b 97 e0 34 cc 43 fe =
05 b6 b5 8c 06 b6 2a 55 eb ed ec 64 36 2e 26 e7 72 37 57 40 f2 22 e7 f6 =
4e 21 96 21 a3 16 03 01 02 0d 0c 00 02 09 00 80 84 08 0b 02 7c 50 a4 b3 =
5b 96 b4 55 e7 79 7a 40 e0 b4 30 c6 8a d9 42 84 10 17 22 34 28 b5 bc 1a =
8b 12 d3 00 15 23 1e 03 f2 5c 7e 43 d8 5b 07 58 df f3 c1 4d 48 ec df 2b =
3e 1c 0a 45 ab e7 d7 78 3d d4 b8 99 33 a3 69 9a 10 c8 c8 72 0c 76 2b 4f =
8e 18 f9 94 d0 8d 11 f0 46 30 52 d9 a7 17 29 70 a2 8c d8 1a 6f a6 88 94 =
f1 1c 32 4b 4d 55 10 6d 6a 40 78 e9 85 a9 1b 62 3f 0b 5b ba 59 8b f2 e3 =
00 01 02 00 80 43 76 c3 fc 46 61 d2 3e 12 31 d2 2e 87 02 27 ce f1 44 3f =
0f 3b 08 6b 29 3f 4e f0 06 65 f0 d3 21 63 ea 91 5b 62 c1 87 2d 0a a5 31 =
c3 df 14 08 91 70 4b 5c 73 a8 05 d3 e9 2a f0 d5 6b 3a 7e 22 02 9e 2c 30 =
1f f2 5e 95 dc c7 c4 bd 0b 89 dc 15 9a 59 d4 cd 26 ca 48 3b 53 f9 84 36 =
7a f7 5a 66 f1 07 97 e3 a9 65 5f 3e 21 66 e8 ec 4e b0 24 9b c3 ee 14 59 =
6f 5d 68 a3 16 52 30 fd 2a 50 76 32 69 01 00 49 6b dc 4c e3 ec cd cd 51 =
64 24 25 bc 4e a9 16 32 46 7e 9b 28 a2 f8 d2 bc 58 3a bb c8 ae c2 f7 2f =
0b d9 4e 36 7f 44 1a ec 97 cb bb 76 b1 90 42 38 30 48 12 1d 93 fd 5e 88 =
be a6 42 7f 35 cf 38 f3 ff 9c 73 bb a5 34 48 13 c8 43 61 d2 1e df c7 64 =
68 a3 bc 04 ca 69 43 a8 e2 8f 37 e3 e5 a1 90 2d b2 ed 67 cc 3e 19 8f 0a =
91 70 69 52 73 a4 33 96 bc f8 fd 98 4f 5b 6c a5 6d cd b1 61 9e 1f 20 44 =
8f f1 53 5c e9 e0 20 0d 9c 5f d6 14 0b d3 58 00 30 79 39 f5 6f 71 74 b2 =
b2 13 d4 e6 76 ea 5d d1 84 57 b2 ae e4 38 ee a7 03 30 ae 93 69 e0 07 8f =
36 f3 80 c2 09 1c f4 8c 24 73 21 11 25 1c 5f 43 f4 91 80 97 bb 9a ff 56 =
b6 08 49 47 96 9f 0c b2 ca 3b 24 e5 1d 74 70 37 f5 0f 46 de 45 1f 38 46 =
31 f3 ee ad b0 26 89 74 16 74 4b 48 a7 23 d7 4f 94 35 df c6 d1 46 a4 b4 =
21 50 54 8f 0e d6 a2 16 03 01 00 a7 0d 00 00 9f 04 03 04 01 02 00 98 00 =
96 30 81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 =
04 08 13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 09 53 6f 6d =
65 77 68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 =
20 49 6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 =
6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 =
13 1d 45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 65 20 41 75 =
74 68 6f 72 69 74 79 0e 00 00 00=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D128 method=3D13 vendor=3D0 =
vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D885) - Flags 0x80=0A=
SSL: TLS Message Length: 2903=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server hello A=0A=
TLS: tls_verify_cb - preverify_ok=3D1 err=3D0 (ok) ca_cert_verify=3D1 =
depth=3D1 buf=3D'/C=3DFR/ST=3DRadius/L=3DSomewhere/O=3DExample =
Inc./emailAddress=3Dadmin@example.com/CN=3DExample Certificate Authority'=0A=
wlan0: CTRL-EVENT-EAP-PEER-CERT depth=3D1 =
subject=3D'/C=3DFR/ST=3DRadius/L=3DSomewhere/O=3DExample =
Inc./emailAddress=3Dadmin@example.com/CN=3DExample Certificate Authority'=0A=
TLS: tls_verify_cb - preverify_ok=3D1 err=3D0 (ok) ca_cert_verify=3D1 =
depth=3D0 buf=3D'/C=3DFR/ST=3DRadius/O=3DExample Inc./CN=3DExample =
Server Certificate/emailAddress=3Dadmin@example.com'=0A=
wlan0: CTRL-EVENT-EAP-PEER-CERT depth=3D0 =
subject=3D'/C=3DFR/ST=3DRadius/O=3DExample Inc./CN=3DExample Server =
Certificate/emailAddress=3Dadmin@example.com'=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server certificate A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server key exchange A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server certificate request A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server done A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write client certificate A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write client key exchange A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write certificate verify A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write change cipher spec A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write finished A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 flush data=0A=
SSL: (where=3D0x1002 ret=3D0xffffffff)=0A=
SSL: SSL_connect:error in SSLv3 read finished A=0A=
SSL: SSL_connect - want more data=0A=
SSL: 2595 bytes pending from ssl_out=0A=
SSL: 2595 bytes left to be sent out (of total 2595 bytes)=0A=
SSL: sending 1398 bytes, more fragments will follow=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D00:1b:b1:58:f6:dd=0A=
TX EAPOL - hexdump(len=3D1412): 01 00 05 80 02 80 05 80 0d c0 00 00 0a =
23 16 03 01 08 4d 0b 00 08 49 00 08 46 00 03 95 30 82 03 91 30 82 02 79 =
a0 03 02 01 02 02 01 03 30 0d 06 09 2a 86 48 86 f7 0d 01 01 04 05 00 30 =
81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 =
13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 =
68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 =
6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 =
6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d =
45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 =
6f 72 69 74 79 30 1e 17 0d 31 32 30 35 30 33 31 35 35 37 33 32 5a 17 0d =
31 33 30 35 30 33 31 35 35 37 33 32 5a 30 6b 31 0b 30 09 06 03 55 04 06 =
13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 15 30 =
13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 10 30 0e =
06 03 55 04 03 13 07 74 68 65 75 73 65 72 31 22 30 20 06 09 2a 86 48 86 =
f7 0d 01 09 01 16 13 74 68 65 75 73 65 72 40 65 78 61 6d 70 6c 65 2e 63 =
6f 6d 30 82 01 22 30 0d 06 09 2a 86 48 86 f7 0d 01 01 01 05 00 03 82 01 =
0f 00 30 82 01 0a 02 82 01 01 00 c9 2d 5a aa e6 0a 9a 1b 4b 95 91 a0 bd =
79 79 75 ae e8 f4 87 bc 6b de 20 eb fd bf 77 5c 20 85 06 ed 24 56 c2 38 =
66 70 05 b4 c2 bb 6b ea 36 d5 bf 49 15 ad 45 d6 22 b0 4c 2c 2a 17 f3 3e =
b0 34 be e3 8e 2c 87 5a ff 27 ce 19 00 dd b3 5c 90 8b 28 ae 6d c4 f6 45 =
ce 88 11 25 c7 01 ba 31 2f 06 a6 be bb 32 88 50 97 e9 69 df 62 c8 5d a3 =
00 1b 2f 4b 1d 25 86 f3 16 59 6c 31 d7 9e b4 7e 54 2e de b3 42 2f e5 d2 =
7e 5c 04 06 ea 31 35 d6 1b f0 02 c9 97 84 bc 62 ce 24 71 4f 7d 5f 22 70 =
ed eb 7d c9 0d 6c b5 13 10 79 5d 5a 10 72 21 c2 6b e6 c1 3c c8 1e 94 89 =
36 62 85 44 e1 c8 d1 7b 61 8a af a1 20 bd fa d0 d4 de e4 ae 52 c1 33 6e =
c2 72 e6 1e 1c be 46 47 56 8e e1 36 74 0f be b0 d9 96 61 ad 27 29 29 0c =
98 53 a1 c9 92 cb 92 f0 64 2b a1 16 65 06 8e d6 7f 5b 75 40 f6 94 6d 3f =
a3 64 95 02 03 01 00 01 a3 17 30 15 30 13 06 03 55 1d 25 04 0c 30 0a 06 =
08 2b 06 01 05 05 07 03 02 30 0d 06 09 2a 86 48 86 f7 0d 01 01 04 05 00 =
03 82 01 01 00 4f ca f0 54 de dd 9a 32 a4 b3 74 76 5c 97 82 84 c7 08 7f =
c9 aa 1b 77 18 eb 4f fb e2 c2 5b 0b bb 39 68 45 15 76 8c 32 f4 b5 d7 d6 =
7e 92 ff c7 d1 e6 a7 13 89 f0 ab 57 a0 fd dc 63 7c 60 53 17 78 9f 85 e7 =
c2 2d 16 62 66 35 54 f9 3a fa 8e f8 a2 25 50 d7 73 00 fd 42 94 3a 95 1d =
ad 00 95 8b 77 d7 72 2c 2b df 0d cd de e8 6b f7 16 71 8a db c3 8e 0b 67 =
1a 3b 3b 8d 91 90 87 c5 7f 6b bc 94 e1 12 b8 8d 0b c6 a7 30 f3 68 68 41 =
9b 0a 6d 93 71 fc ab f3 c3 cf a7 5d cf ae bb 2c 18 e1 bd e5 a9 66 11 1e =
38 b8 7b a2 43 c6 98 d9 37 cd 69 4c 4a b3 4e 1c ef 31 ed d7 70 f7 e4 2f =
a6 f8 40 e6 41 f0 a7 6b 7b c7 d9 84 ff 53 3d ba db ee 50 24 2b 8f 5a 42 =
77 b2 78 ce 32 37 ae c4 54 f6 7d 61 9e 58 20 5e af 72 d5 42 cf 87 9d 96 =
8f 02 88 de e5 0c f1 3b 39 3f 43 df 22 f6 79 03 06 07 2a 28 e2 00 04 ab =
30 82 04 a7 30 82 03 8f a0 03 02 01 02 02 09 00 89 95 bd d4 00 94 4a 26 =
30 0d 06 09 2a 86 48 86 f7 0d 01 01 05 05 00 30 81 93 31 0b 30 09 06 03 =
55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 75 73 =
31 12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 =
06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 =
09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c =
65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 =
43 65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 6f 72 69 74 79 30 1e 17 =
0d 31 32 30 35 30 33 31 33 34 39 35 37 5a 17 0d 31 33 30 35 30 33 31 33 =
34 39 35 37 5a 30 81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 =
0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 =
09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 =
6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 =
16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 =
03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 =
65 20 41 75 74 68 6f 72 69 74 79 30 82 01 22 30 0d 06 09 2a 86 48 86 f7 =
0d 01 01 01 05 00 03 82 01 0f 00 30 82 01 0a 02 82 01 01 00 9e 34 8e d1 =
c3 75 3a 22 29 b2 dd 98 e2 01 2d 9d 6c 91 c5 89 b4 15 a2 5b c5 78 80 cd =
de cf a1 b7 59 70 b2 8a 97 64 df c5 22 40 39 d0 e6 b3 b4 e6 44 55 d1 23 =
36 fa f8 e8 ae 72 6a=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D10): 02 00 00 06 01 81 00 06 0d 00=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D129 method=3D13 vendor=3D0 =
vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D6) - Flags 0x00=0A=
SSL: 1197 bytes left to be sent out (of total 2595 bytes)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D00:1b:b1:58:f6:dd=0A=
TX EAPOL - hexdump(len=3D1207): 01 00 04 b3 02 81 04 b3 0d 00 b2 1e 16 =
a5 ab 3f 76 8b 30 a6 4c a9 27 7d 52 0e bf e7 0c 52 52 5b 23 42 18 f9 a7 =
0c 1e f3 c3 21 00 a6 ac 11 e0 56 4f 34 04 c0 a4 ae ce 6c 9f b6 ba 57 c9 =
08 11 a9 99 0d cb c1 a2 0e fa 33 a8 c3 9b ec 37 95 ac f6 91 d1 1b b7 76 =
00 48 5b b4 07 8e bf bb 12 fa 57 35 d5 59 de 2f 12 a1 0e 72 ac 7a 91 b8 =
b3 66 31 e5 19 be dd 0a c2 67 f5 0f 0c 6b 62 d8 1f 6c 30 3d bf ef 7a dc =
9a ac d5 b6 06 f2 43 28 ab e0 90 42 c8 0b 68 23 e9 4c a4 1e 62 a6 c2 01 =
aa a0 c5 12 ca d0 ac 46 7e ef b0 6b 86 aa 67 79 33 56 eb fb 1f b8 57 66 =
fd 2d e3 c7 a2 37 e6 1b bf 14 32 7b 1e f9 7a c3 02 e6 f3 4c 09 d7 75 05 =
d2 5d 02 03 01 00 01 a3 81 fb 30 81 f8 30 1d 06 03 55 1d 0e 04 16 04 14 =
b5 52 d1 e7 e5 76 8b d1 01 80 79 1b 24 ea 53 a8 76 34 2b 67 30 81 c8 06 =
03 55 1d 23 04 81 c0 30 81 bd 80 14 b5 52 d1 e7 e5 76 8b d1 01 80 79 1b =
24 ea 53 a8 76 34 2b 67 a1 81 99 a4 81 96 30 81 93 31 0b 30 09 06 03 55 =
04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 =
12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 06 =
03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 09 =
2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 =
2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 43 =
65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 6f 72 69 74 79 82 09 00 89 =
95 bd d4 00 94 4a 26 30 0c 06 03 55 1d 13 04 05 30 03 01 01 ff 30 0d 06 =
09 2a 86 48 86 f7 0d 01 01 05 05 00 03 82 01 01 00 40 28 ff 3b 19 ba 33 =
5e ab fc ad 60 14 53 fa 1b b4 55 d0 49 5d 66 dd 49 e7 b1 8d 61 ed ef bc =
fb 7d 56 22 05 d9 3d fd f6 a3 be c6 3a 1d c6 c9 64 36 c4 d4 61 d2 3a f9 =
c1 57 e5 bc 44 e2 53 06 60 f6 19 33 b4 ba 0a 4f 5c 3c 2d e8 4d 05 38 14 =
e6 ff 7d 6a c1 72 0e 02 9e 28 1b a9 12 30 1a a4 c8 c8 92 85 d6 dd 80 ea =
26 45 b9 4f 61 82 aa ea 96 d9 0e bf 68 03 70 ab 23 a6 33 09 79 fb f9 c9 =
c0 20 e9 6f 98 3c eb 54 29 c8 fd 1d 26 f2 c1 ec 29 fc 0e 18 cc b2 4a f1 =
57 41 0c 7f d2 04 12 33 90 23 f8 ca 8b 0a 92 80 51 1f 5c a9 9e 2a 93 7c =
ae 6a 44 19 b1 c9 17 df 44 ce 7c e5 c5 f7 a7 64 ea 89 34 bf 0c 39 f1 e2 =
ec e0 11 ab 58 54 80 5f 3b e8 6b a7 43 4a 42 e3 d7 8c 19 33 28 0b 97 e0 =
34 cc 43 fe 05 b6 b5 8c 06 b6 2a 55 eb ed ec 64 36 2e 26 e7 72 37 57 40 =
f2 22 e7 f6 4e 21 96 21 a3 16 03 01 00 86 10 00 00 82 00 80 40 ac 96 36 =
8a 6b 08 41 2d 44 e1 4f d4 04 74 13 cf 30 31 74 f6 a4 81 30 de c4 45 4e =
fa 1b 21 76 46 da 9b bc 8f 02 a8 dc 94 41 4f 19 ff 85 36 18 4b 6b 87 88 =
2d ec 2e 10 c9 2b 28 e3 3e d4 ea 1d 88 e5 89 8a bb 07 b6 0c 45 64 30 b1 =
16 65 8b 63 8e 17 a0 da de 82 59 26 49 79 b7 c1 9b 63 33 f1 69 ed 13 25 =
12 4c bd 8c d6 66 0a 8d 5a a5 44 b8 da f7 be ed 56 cb e4 4a c2 04 71 9e =
3a 8e 7e 71 16 03 01 01 06 0f 00 01 02 01 00 21 e4 3b 65 ee 7c 03 3d 94 =
87 29 99 ae e1 ad e7 60 6a 90 43 f4 1f 29 2a 61 63 a8 be 73 23 2d 66 2d =
ab 7d f9 28 bc e9 3a 82 ee b9 6b 7c c4 f7 d6 f6 8b 71 e7 78 4b 80 e0 57 =
8d 68 df 4b ed 9e 27 9a 2d 81 d1 bf d6 6b 69 0e 1b 41 96 63 78 d8 c4 0e =
79 0d a3 7e 55 5c 53 de 1b 2c c7 78 e8 46 ad 86 13 74 6a c5 c5 0b 84 d4 =
85 ed 72 ca 46 f9 94 c9 ea 0e 75 20 79 e2 5e b7 ba 59 db 45 ce 9c 24 d6 =
1a 53 d4 fa 82 62 19 77 1a 07 43 5f 9e eb 00 44 fe e6 74 89 a2 e1 a4 75 =
3e 60 58 aa 78 2d e8 5f a2 a7 b5 ef fa 66 d0 05 8d 71 50 e2 d9 15 0e c7 =
a2 ed 8c cc 0d b9 2b 38 62 43 50 60 fe fb 68 7a 08 c0 8e 2b 2b 62 62 c5 =
eb 73 61 3e c8 5b 23 6c d9 5d bf 7d 5b 93 49 e7 d4 11 20 5a 83 5c 3d 67 =
88 d5 9a 39 da 1b 3c f6 7b 25 5c 62 a6 fb e4 b1 f8 f5 1b 57 7a 07 f9 14 =
da ad c4 2f 44 44 ae 14 03 01 00 01 01 16 03 01 00 30 4a ff 2e 05 72 75 =
81 2a 3c b7 b1 21 5b 7b 38 4c 41 bd 9a de 71 cd 98 b4 c5 24 e1 23 08 c1 =
92 5a 70 a1 6d 25 cd 06 51 a4 21 89 df f9 18 69 4c bf=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D73): 02 00 00 45 01 82 00 45 0d 80 00 00 00 3b =
14 03 01 00 01 01 16 03 01 00 30 e7 a2 48 f0 4c 26 21 46 d0 39 ee 0f a0 =
97 a4 3e 62 c2 f1 c4 b3 ea fc 5e 2f bc 44 b7 a1 92 00 d5 4e 4e dc c5 3b =
60 99 ba fe a9 41 f3 d1 26 39 96=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D130 method=3D13 vendor=3D0 =
vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D69) - Flags 0x80=0A=
SSL: TLS Message Length: 59=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read finished A=0A=
SSL: (where=3D0x20 ret=3D0x1)=0A=
SSL: (where=3D0x1002 ret=3D0x1)=0A=
SSL: 0 bytes pending from ssl_out=0A=
SSL: No Application Data included=0A=
SSL: No data to be sent out=0A=
EAP-TLS: Done=0A=
EAP-TLS: Derived key - hexdump(len=3D64): [REMOVED]=0A=
EAP-TLS: Derived EMSK - hexdump(len=3D64): [REMOVED]=0A=
SSL: Building ACK (type=3D13 id=3D130 ver=3D0)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DDONE =
decision=3DUNCOND_SUCC=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D00:1b:b1:58:f6:dd=0A=
TX EAPOL - hexdump(len=3D10): 01 00 00 06 02 82 00 06 0d 00=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D8): 02 00 00 04 03 82 00 04=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Success=0A=
EAP: EAP entering state SUCCESS=0A=
wlan0: CTRL-EVENT-EAP-SUCCESS EAP authentication completed successfully=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
EAPOL: SUPP_BE entering state SUCCESS=0A=
EAPOL: SUPP_BE entering state IDLE=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 =
00 00 01 c2 34 e5 ca 5a 8c a4 68 d6 49 b6 16 be 00 57 18 0b 0f 84 56 77 =
8e 11 e7 22 4b 33 81 0f c6 7c 66 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 d5 64 6e 8a ac =
6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D117=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x8a (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Ack)=0A=
wlan0:   key_length=3D16 key_data_length=3D22=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01=0A=
  key_nonce - hexdump(len=3D32): c2 34 e5 ca 5a 8c a4 68 d6 49 b6 16 be =
00 57 18 0b 0f 84 56 77 8e 11 e7 22 4b 33 81 0f c6 7c 66=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
WPA: RX EAPOL-Key - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 =
00 00 00 00 00 01 c2 34 e5 ca 5a 8c a4 68 d6 49 b6 16 be 00 57 18 0b 0f =
84 56 77 8e 11 e7 22 4b 33 81 0f c6 7c 66 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 d5 64 =
6e 8a ac 6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
wlan0: State: ASSOCIATED -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 1 of 4-Way Handshake from 00:1b:b1:58:f6:dd =
(ver=3D2)=0A=
RSN: msg 1/4 key data - hexdump(len=3D22): dd 14 00 0f ac 04 d5 64 6e 8a =
ac 6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
WPA: PMKID in EAPOL-Key - hexdump(len=3D22): dd 14 00 0f ac 04 d5 64 6e =
8a ac 6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
RSN: PMKID from Authenticator - hexdump(len=3D16): d5 64 6e 8a ac 6c db =
b7 1d e0 2d e8 0c 36 d4 a5=0A=
wlan0: RSN: no matching PMKID found=0A=
EAPOL: Successfully fetched key (len=3D32)=0A=
EAPOL: Successfully fetched key (len=3D64)=0A=
WPA: PMK from EAPOL state machines - hexdump(len=3D32): [REMOVED]=0A=
RSN: Added PMKSA cache entry for 00:1b:b1:58:f6:dd =
network_ctx=3D0x10427908=0A=
nl80211: Add PMKID for 00:1b:b1:58:f6:dd=0A=
wlan0: RSN: the new PMK matches with the PMKID=0A=
Get randomness: len=3D32 entropy=3D11=0A=
WPA: Renewed SNonce - hexdump(len=3D32): 55 9e 8f e9 25 3e bd 44 ae e7 =
e5 5a 72 26 36 14 1b 2e bf 60 4e 37 b3 f5 20 ad 4d a9 e4 33 33 9d=0A=
WPA: PTK derivation - A1=3D90:a4:de:21:4f:53 A2=3D00:1b:b1:58:f6:dd=0A=
WPA: Nonce1 - hexdump(len=3D32): 55 9e 8f e9 25 3e bd 44 ae e7 e5 5a 72 =
26 36 14 1b 2e bf 60 4e 37 b3 f5 20 ad 4d a9 e4 33 33 9d=0A=
WPA: Nonce2 - hexdump(len=3D32): c2 34 e5 ca 5a 8c a4 68 d6 49 b6 16 be =
00 57 18 0b 0f 84 56 77 8e 11 e7 22 4b 33 81 0f c6 7c 66=0A=
WPA: PMK - hexdump(len=3D32): [REMOVED]=0A=
WPA: PTK - hexdump(len=3D48): [REMOVED]=0A=
WPA: WPA IE for msg 2/4 - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00=0A=
WPA: Replay Counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01=0A=
wlan0: WPA: Sending EAPOL-Key 2/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): 3b e4 01 19 08 ab 14 67 7b c2 =
0b 69 19 d2 ad 5f=0A=
WPA: TX EAPOL-Key - hexdump(len=3D121): 01 03 00 75 02 01 0a 00 00 00 00 =
00 00 00 00 00 01 55 9e 8f e9 25 3e bd 44 ae e7 e5 5a 72 26 36 14 1b 2e =
bf 60 4e 37 b3 f5 20 ad 4d a9 e4 33 33 9d 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3b e4 =
01 19 08 ab 14 67 7b c2 0b 69 19 d2 ad 5f 00 16 30 14 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 =
00 00 02 c2 34 e5 ca 5a 8c a4 68 d6 49 b6 16 be 00 57 18 0b 0f 84 56 77 =
8e 11 e7 22 4b 33 81 0f c6 7c 66 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 29 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a0 23 87 aa 2c =
56 c3 6f 70 32 97 92 f8 1a c8 6b 00 38 f6 2d 0e 38 e2 7c 25 bb 94 88 da =
31 00 c1 c5 88 a9 12 11 6c 27 f8 86 65 4d 67 41 fe 0b c3 92 03 b4 d3 37 =
89 49 02 86 e8 f8 fe 15 27 e6 9a ce 70 b6 a0 2e c7 cc c4 e3 19=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D151=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x13ca (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Install =
Ack MIC Secure Encr)=0A=
wlan0:   key_length=3D16 key_data_length=3D56=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 02=0A=
  key_nonce - hexdump(len=3D32): c2 34 e5 ca 5a 8c a4 68 d6 49 b6 16 be =
00 57 18 0b 0f 84 56 77 8e 11 e7 22 4b 33 81 0f c6 7c 66=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 29 01 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): a0 23 87 aa 2c 56 c3 6f 70 32 97 92 f8 1a =
c8 6b=0A=
WPA: RX EAPOL-Key - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 =
00 00 00 00 00 02 c2 34 e5 ca 5a 8c a4 68 d6 49 b6 16 be 00 57 18 0b 0f =
84 56 77 8e 11 e7 22 4b 33 81 0f c6 7c 66 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 29 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a0 23 =
87 aa 2c 56 c3 6f 70 32 97 92 f8 1a c8 6b 00 38 f6 2d 0e 38 e2 7c 25 bb =
94 88 da 31 00 c1 c5 88 a9 12 11 6c 27 f8 86 65 4d 67 41 fe 0b c3 92 03 =
b4 d3 37 89 49 02 86 e8 f8 fe 15 27 e6 9a ce 70 b6 a0 2e c7 cc c4 e3 19=0A=
RSN: encrypted key data - hexdump(len=3D56): f6 2d 0e 38 e2 7c 25 bb 94 =
88 da 31 00 c1 c5 88 a9 12 11 6c 27 f8 86 65 4d 67 41 fe 0b c3 92 03 b4 =
d3 37 89 49 02 86 e8 f8 fe 15 27 e6 9a ce 70 b6 a0 2e c7 cc c4 e3 19=0A=
WPA: decrypted EAPOL-Key key data - hexdump(len=3D48): [REMOVED]=0A=
wlan0: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 3 of 4-Way Handshake from 00:1b:b1:58:f6:dd =
(ver=3D2)=0A=
WPA: IE KeyData - hexdump(len=3D48): 30 14 01 00 00 0f ac 04 01 00 00 0f =
ac 04 01 00 00 0f ac 01 0c 00 dd 16 00 0f ac 01 01 00 f7 ed fd 17 1b 8a =
08 77 c5 02 48 f8 0e de 04 2c dd 00=0A=
WPA: RSN IE in EAPOL-Key - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 0c 00=0A=
WPA: GTK in EAPOL-Key - hexdump(len=3D24): [REMOVED]=0A=
wlan0: WPA: Sending EAPOL-Key 4/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): 48 2a 79 47 0e 8a 27 71 57 3a =
40 fc 79 f5 05 55=0A=
WPA: TX EAPOL-Key - hexdump(len=3D99): 01 03 00 5f 02 03 0a 00 00 00 00 =
00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 48 2a =
79 47 0e 8a 27 71 57 3a 40 fc 79 f5 05 55 00 00=0A=
wlan0: WPA: Installing PTK to the driver=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10426f28 =
key_idx=3D0 set_tx=3D1 seq_len=3D6 key_len=3D16=0A=
   addr=3D00:1b:b1:58:f6:dd=0A=
EAPOL: External notification - portValid=3D1=0A=
EAPOL: SUPP_PAE entering state AUTHENTICATED=0A=
EAPOL: Supplicant port status: Authorized=0A=
EAPOL authentication completed successfully=0A=
wlan0: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE=0A=
RSN: received GTK in pairwise handshake - hexdump(len=3D18): [REMOVED]=0A=
WPA: Group Key - hexdump(len=3D16): [REMOVED]=0A=
wlan0: WPA: Installing GTK to the driver (keyidx=3D1 tx=3D0 len=3D16)=0A=
WPA: RSC - hexdump(len=3D6): 29 01 00 00 00 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10082f30 =
key_idx=3D1 set_tx=3D0 seq_len=3D6 key_len=3D16=0A=
   broadcast key=0A=
wlan0: WPA: Key negotiation completed with 00:1b:b1:58:f6:dd [PTK=3DCCMP =
GTK=3DCCMP]=0A=
wlan0: Cancelling authentication timeout=0A=
wlan0: State: GROUP_HANDSHAKE -> COMPLETED=0A=
wlan0: CTRL-EVENT-CONNECTED - Connection to 00:1b:b1:58:f6:dd completed =
(auth) [id=3D0 id_str=3D]=0A=
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D6=0A=
EAPOL: External notification - portValid=3D1=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
CTRL_IFACE monitor attached - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 =
5f 63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
EAPOL: authWhile --> 0=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D22):=0A=
     52 4f 41 4d 20 39 30 3a 41 34 3a 44 45 3a 41 41   ROAM 90:A4:DE:AA=0A=
     3a 34 32 3a 39 34                                 :42:94          =0A=
CTRL_IFACE ROAM 90:a4:de:aa:42:94=0A=
wlan0: Request association: reassociate: 1  selected: 90:a4:de:aa:42:94  =
bssid: 00:1b:b1:58:f6:dd  pending: 00:00:00:00:00:00  wpa_state: =
COMPLETED=0A=
wlan0: Automatic auth_alg selection: 0x1=0A=
RSN: PMKSA cache search - network_ctx=3D0x10427908 try_opportunistic=3D0=0A=
RSN: Search for BSSID 90:a4:de:aa:42:94=0A=
RSN: No PMKSA cache entry found=0A=
wlan0: RSN: using IEEE 802.11i/D9.0=0A=
wlan0: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 1 =
proto 2=0A=
wlan0: WPA: clearing AP WPA IE=0A=
WPA: set AP RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 00 00 =
0f ac 04 01 00 00 0f ac 01 0c 00=0A=
wlan0: WPA: using GTK CCMP=0A=
wlan0: WPA: using PTK CCMP=0A=
wlan0: WPA: using KEY_MGMT 802.1X=0A=
wlan0: WPA: not using MGMT group cipher=0A=
WPA: Set own WPA IE default - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
wlan0: Cancelling scan request=0A=
wlan0: SME: Trying to authenticate with 90:a4:de:aa:42:94 =
(SSID=3D'cdtest' freq=3D5660 MHz)=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D4 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D5 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D0x1042a680 =
key_idx=3D0 set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
   addr=3D90:a4:de:aa:42:94=0A=
wlan0: State: COMPLETED -> AUTHENTICATING=0A=
EAPOL: External notification - EAP success=3D0=0A=
EAPOL: External notification - EAP fail=3D0=0A=
EAPOL: External notification - portControl=3DAuto=0A=
nl80211: Authenticate (ifindex=3D5)=0A=
  * bssid=3D90:a4:de:aa:42:94=0A=
  * freq=3D5660=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D0): [NULL]=0A=
  * Auth Type 0=0A=
wlan0: nl80211: MLME command failed (auth): ret=3D-2 (No such file or =
directory)=0A=
nl80211: Trigger single channel scan to refresh cfg80211 BSS entry=0A=
nl80211: Scan SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
nl80211: Scan frequency 5660 MHz=0A=
Scan requested (ret=3D0) - scan timeout 30 seconds=0A=
nl80211: Event message available=0A=
nl80211: Scan trigger=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: Beacon loss event=0A=
wlan0: Event BEACON_LOSS (49) received=0A=
nl80211: Event message available=0A=
nl80211: New scan results available=0A=
nl80211: Scan results for missing cfg80211 BSS entry=0A=
nl80211: Try to authenticate again=0A=
nl80211: Authenticate (ifindex=3D5)=0A=
  * bssid=3D90:a4:de:aa:42:94=0A=
  * freq=3D5660=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D0): [NULL]=0A=
  * Auth Type 0=0A=
nl80211: Authentication request send successfully=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x1003 ([UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: Delete station 00:1b:b1:58:f6:dd=0A=
nl80211: Event message available=0A=
nl80211: New station 90:a4:de:aa:42:94=0A=
nl80211: Event message available=0A=
nl80211: MLME event 37=0A=
nl80211: MLME event frame - hexdump(len=3D30): b0 00 3c 00 90 a4 de 21 =
4f 53 90 a4 de aa 42 94 90 a4 de aa 42 94 00 1f 00 00 02 00 00 00=0A=
wlan0: Event AUTH (11) received=0A=
wlan0: SME: Authentication response: peer=3D90:a4:de:aa:42:94 =
auth_type=3D0 status_code=3D0=0A=
SME: Authentication response IEs - hexdump(len=3D0): [NULL]=0A=
wlan0: Trying to associate with 90:a4:de:aa:42:94 (SSID=3D'cdtest' =
freq=3D5660 MHz)=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: State: AUTHENTICATING -> ASSOCIATING=0A=
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
WPA: set own WPA/RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00=0A=
nl80211: Associate (ifindex=3D5)=0A=
  * bssid=3D90:a4:de:aa:42:94=0A=
  * freq=3D5660=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 =
01 00 00 0f ac 01 00 00=0A=
  * pairwise=3D0xfac04=0A=
  * group=3D0xfac04=0A=
  * prev_bssid=3D00:1b:b1:58:f6:dd=0A=
nl80211: Association request send successfully=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: MLME event 38=0A=
nl80211: MLME event frame - hexdump(len=3D66): 30 00 3c 00 90 a4 de 21 =
4f 53 90 a4 de aa 42 94 90 a4 de aa 42 94 10 1f 11 00 00 00 01 c0 01 08 =
8c 12 98 24 b0 48 60 6c dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 =
00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: Event ASSOC (0) received=0A=
wlan0: Association info event=0A=
resp_ies - hexdump(len=3D36): 01 08 8c 12 98 24 b0 48 60 6c dd 18 00 50 =
f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: freq=3D5660 MHz=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
Operating frequency changed from 5680 to 5660 MHz=0A=
nl80211: Associated on 5660 MHz=0A=
nl80211: Associated with 90:a4:de:aa:42:94=0A=
nl80211: Received scan results (1 BSSes)=0A=
nl80211: Scan results indicate BSS status with 90:a4:de:aa:42:94 as =
associated=0A=
wlan0: BSS: Start scan result update 2=0A=
wlan0: State: ASSOCIATING -> ASSOCIATED=0A=
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
wlan0: Associated to a new BSS: BSSID=3D90:a4:de:aa:42:94=0A=
wlan0: No keys have been configured - skip key clearing=0A=
wlan0: Associated with 90:a4:de:aa:42:94=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: WPA: Association event - clear replay counter=0A=
wlan0: WPA: Clear old PTK=0A=
EAPOL: External notification - portEnabled=3D0=0A=
EAPOL: SUPP_PAE entering state DISCONNECTED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: SUPP_BE entering state INITIALIZE=0A=
EAP: EAP entering state DISABLED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portValid=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portEnabled=3D1=0A=
EAPOL: SUPP_PAE entering state CONNECTING=0A=
EAPOL: SUPP_BE entering state IDLE=0A=
EAP: EAP entering state INITIALIZE=0A=
EAP: maintaining EAP method data for fast reauthentication=0A=
EAP: EAP entering state IDLE=0A=
wlan0: Setting authentication timeout: 10 sec 0 usec=0A=
wlan0: Cancelling scan request=0A=
nl80211: Event message available=0A=
nl80211: Ignore connect event (cmd=3D46) when using userspace SME=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D9): 02 00 00 05 01 29 00 05 01=0A=
wlan0: Setting authentication timeout: 70 sec 0 usec=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_PAE entering state RESTART=0A=
EAP: EAP entering state INITIALIZE=0A=
EAP: maintaining EAP method data for fast reauthentication=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_PAE entering state AUTHENTICATING=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D41 method=3D1 vendor=3D0 vendorMethod=3D0=0A=
EAP: EAP entering state IDENTITY=0A=
wlan0: CTRL-EVENT-EAP-STARTED EAP authentication started=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
EAP: EAP-Request Identity data - hexdump_ascii(len=3D0):=0A=
EAP: using real identity - hexdump_ascii(len=3D9):=0A=
     61 6e 6f 6e 79 6d 6f 75 73                        anonymous       =0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D90:a4:de:aa:42:94=0A=
TX EAPOL - hexdump(len=3D18): 01 00 00 0e 02 29 00 0e 01 61 6e 6f 6e 79 =
6d 6f 75 73=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D10): 02 00 00 06 01 2a 00 06 0d 20=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D42 method=3D13 vendor=3D0 vendorMethod=3D0=0A=
EAP: EAP entering state GET_METHOD=0A=
wlan0: CTRL-EVENT-EAP-PROPOSED-METHOD vendor=3D0 method=3D13=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
EAP: Using previous method data for fast re-authentication=0A=
EAP: Initialize selected EAP method: vendor 0 method 13 (TLS)=0A=
wlan0: CTRL-EVENT-EAP-METHOD EAP vendor 0 method 13 (TLS) selected=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D6) - Flags 0x20=0A=
EAP-TLS: Start=0A=
SSL: (where=3D0x10 ret=3D0x1)=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:before/connect initialization=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write client hello A=0A=
SSL: (where=3D0x1002 ret=3D0xffffffff)=0A=
SSL: SSL_connect:error in SSLv3 read server hello A=0A=
SSL: SSL_connect - want more data=0A=
SSL: 95 bytes pending from ssl_out=0A=
SSL: 95 bytes left to be sent out (of total 95 bytes)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D90:a4:de:aa:42:94=0A=
TX EAPOL - hexdump(len=3D105): 01 00 00 65 02 2a 00 65 0d 00 16 03 01 00 =
5a 01 00 00 56 03 01 50 3c d6 99 65 8d b5 f5 48 fb 09 51 dd a3 96 86 b2 =
70 7a 54 18 30 00 3c 09 78 49 fd aa 90 68 c5 00 00 28 00 39 00 38 00 35 =
00 16 00 13 00 0a 00 33 00 32 00 2f 00 05 00 04 00 15 00 12 00 09 00 14 =
00 11 00 08 00 06 00 03 00 ff 02 01 00 00 04 00 23 00 00=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
EAPOL: startWhen --> 0=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D1028): 02 00 04 00 01 2b 04 00 0d c0 00 00 0b =
57 16 03 01 00 31 02 00 00 2d 03 01 50 89 2f ab b2 f1 61 cd 6d cd 61 88 =
f3 bf 78 21 90 b4 72 95 bf ee 64 4b b8 88 45 2b 3e ee da 47 00 00 39 01 =
00 05 ff 01 00 01 00 16 03 01 08 5e 0b 00 08 5a 00 08 57 00 03 a6 30 82 =
03 a2 30 82 02 8a a0 03 02 01 02 02 01 01 30 0d 06 09 2a 86 48 86 f7 0d =
01 01 04 05 00 30 81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 =
0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 =
09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 =
6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 =
16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 =
03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 =
65 20 41 75 74 68 6f 72 69 74 79 30 1e 17 0d 31 32 30 35 30 33 31 33 34 =
39 35 37 5a 17 0d 31 33 30 35 30 33 31 33 34 39 35 37 5a 30 7c 31 0b 30 =
09 06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 =
69 75 73 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e =
63 2e 31 23 30 21 06 03 55 04 03 13 1a 45 78 61 6d 70 6c 65 20 53 65 72 =
76 65 72 20 43 65 72 74 69 66 69 63 61 74 65 31 20 30 1e 06 09 2a 86 48 =
86 f7 0d 01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f =
6d 30 82 01 22 30 0d 06 09 2a 86 48 86 f7 0d 01 01 01 05 00 03 82 01 0f =
00 30 82 01 0a 02 82 01 01 00 ca 02 3e d7 9b 0a bd ac fa b8 a6 be 93 5b =
09 24 1e 83 df 4d 17 b2 11 ea cb f4 f8 b2 e6 59 bd 18 2e 30 66 cd 7d 40 =
97 1b a0 53 d7 80 2f 30 32 6a ae 74 dc 9b ac 2e 73 ed e2 c6 bf d6 e6 d6 =
51 33 08 4c 65 73 40 0f e0 58 b4 51 a5 e1 67 1b 1e 49 13 c4 72 d3 51 a5 =
28 84 96 4b 00 0d 81 4a 9e b6 a2 9f fa e0 71 4c 2d d4 d1 7a 1a 29 5b 55 =
14 63 e1 07 20 68 68 ae 55 14 1a 4f be e4 0e 73 88 80 1a c9 eb 92 cd e1 =
e9 2b 1b 32 28 af 8d e9 cd 10 4b 6a 2f 24 06 2a 15 79 8f fd 53 f4 94 e5 =
54 d0 5d cb 42 bf f0 d6 85 1c 2b e1 2c 8d d7 97 6a 2a 67 f1 ba 5c c7 c9 =
f3 85 88 69 5e b6 4f c1 bd cd 49 9a 4e 36 62 a9 10 0f 28 cc e0 5b e3 5b =
39 66 be 4a 61 c4 b7 53 f4 1c b9 bf b3 3e e7 e7 b4 cd c0 6c 3c 39 d4 0b =
aa 99 80 8f de 34 4d f3 ec ad 15 3a 55 af 0b 28 f5 e5 3e 26 c8 85 7f d5 =
a1 c3 02 03 01 00 01 a3 17 30 15 30 13 06 03 55 1d 25 04 0c 30 0a 06 08 =
2b 06 01 05 05 07 03 01 30 0d 06 09 2a 86 48 86 f7 0d 01 01 04 05 00 03 =
82 01 01 00 6e 45 2e 1e fc 39 3e fa db 63 0e c7 f9 65 f3 9a 0f 57 40 b4 =
6c 98 fd bd fd 76 dc d6 8a 82 1b 58 32 c9 37 d3 c9 0e ac a9 4e 28 8c 56 =
6b 55 08 82 ce 23 87 3c 9e ca 43 7f 9f 6c 04 42 23 8c c7 03 b5 9c 10 0b =
f7 ff 38 c2 7a 88 0a c4 62 a0 bd cc f2 54 98 2c 20 33 9a 17 fe 35 27 f5 =
b9 4c 39 44 77 35 cf 45 f1 69 4c 4b af 35 3d d6 3b 38 90 72 9f 56 02 15 =
9d 32 2f b0 cc 17 b8 d0 ee c4 35 29 08 0b 42 5f 05 cd 7a 73 0d bf ad 1d =
a4 6c 98 04 2c 0f 6c 75 c0 0b 41 d4 53 9a 81 31 ea 5d 51 27 ab 1e a6 4d =
1a 9f b7 c3 bc e7 8b 64 2d 32 6e 19 73 58 ad 22 f7 e1 52 6e 60 55 b1 0e =
cc c9 b2 ac c2 55 60 d9 0c 42 32 a3 d5 df 35 ca 0e ef c3 3a 00 9b 2d 46 =
dc 7e 59 6e fd d0 d7 03 03 96 17 2d 53 7b 40 52 6d 69 22 3e 0d 40 db e0 =
03 ab 7c 4a b9 8d 08 7e f4 f7 24 71 1d 3d 1c 17 de 57 5a 90 00 04 ab 30 =
82 04 a7 30 82 03 8f=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D43 method=3D13 vendor=3D0 vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D1024) - Flags 0xc0=0A=
SSL: TLS Message Length: 2903=0A=
SSL: Need 1889 bytes more input data=0A=
SSL: Building ACK (type=3D13 id=3D43 ver=3D0)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D90:a4:de:aa:42:94=0A=
TX EAPOL - hexdump(len=3D10): 01 00 00 06 02 2b 00 06 0d 00=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D1028): 02 00 04 00 01 2c 04 00 0d c0 00 00 0b =
57 a0 03 02 01 02 02 09 00 89 95 bd d4 00 94 4a 26 30 0d 06 09 2a 86 48 =
86 f7 0d 01 01 05 05 00 30 81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 =
31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 =
04 07 13 09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c =
45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d =
01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 =
30 24 06 03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 =
63 61 74 65 20 41 75 74 68 6f 72 69 74 79 30 1e 17 0d 31 32 30 35 30 33 =
31 33 34 39 35 37 5a 17 0d 31 33 30 35 30 33 31 33 34 39 35 37 5a 30 81 =
93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 =
06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 68 =
65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e =
63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 6e =
40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d 45 =
78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 6f =
72 69 74 79 30 82 01 22 30 0d 06 09 2a 86 48 86 f7 0d 01 01 01 05 00 03 =
82 01 0f 00 30 82 01 0a 02 82 01 01 00 9e 34 8e d1 c3 75 3a 22 29 b2 dd =
98 e2 01 2d 9d 6c 91 c5 89 b4 15 a2 5b c5 78 80 cd de cf a1 b7 59 70 b2 =
8a 97 64 df c5 22 40 39 d0 e6 b3 b4 e6 44 55 d1 23 36 fa f8 e8 ae 72 6a =
b2 1e 16 a5 ab 3f 76 8b 30 a6 4c a9 27 7d 52 0e bf e7 0c 52 52 5b 23 42 =
18 f9 a7 0c 1e f3 c3 21 00 a6 ac 11 e0 56 4f 34 04 c0 a4 ae ce 6c 9f b6 =
ba 57 c9 08 11 a9 99 0d cb c1 a2 0e fa 33 a8 c3 9b ec 37 95 ac f6 91 d1 =
1b b7 76 00 48 5b b4 07 8e bf bb 12 fa 57 35 d5 59 de 2f 12 a1 0e 72 ac =
7a 91 b8 b3 66 31 e5 19 be dd 0a c2 67 f5 0f 0c 6b 62 d8 1f 6c 30 3d bf =
ef 7a dc 9a ac d5 b6 06 f2 43 28 ab e0 90 42 c8 0b 68 23 e9 4c a4 1e 62 =
a6 c2 01 aa a0 c5 12 ca d0 ac 46 7e ef b0 6b 86 aa 67 79 33 56 eb fb 1f =
b8 57 66 fd 2d e3 c7 a2 37 e6 1b bf 14 32 7b 1e f9 7a c3 02 e6 f3 4c 09 =
d7 75 05 d2 5d 02 03 01 00 01 a3 81 fb 30 81 f8 30 1d 06 03 55 1d 0e 04 =
16 04 14 b5 52 d1 e7 e5 76 8b d1 01 80 79 1b 24 ea 53 a8 76 34 2b 67 30 =
81 c8 06 03 55 1d 23 04 81 c0 30 81 bd 80 14 b5 52 d1 e7 e5 76 8b d1 01 =
80 79 1b 24 ea 53 a8 76 34 2b 67 a1 81 99 a4 81 96 30 81 93 31 0b 30 09 =
06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 =
75 73 31 12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 68 65 72 65 31 15 =
30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 20 30 =
1e 06 09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d =
70 6c 65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d 45 78 61 6d 70 6c =
65 20 43 65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 6f 72 69 74 79 82 =
09 00 89 95 bd d4 00 94 4a 26 30 0c 06 03 55 1d 13 04 05 30 03 01 01 ff =
30 0d 06 09 2a 86 48 86 f7 0d 01 01 05 05 00 03 82 01 01 00 40 28 ff 3b =
19 ba 33 5e ab fc ad 60 14 53 fa 1b b4 55 d0 49 5d 66 dd 49 e7 b1 8d 61 =
ed ef bc fb 7d 56 22 05 d9 3d fd f6 a3 be c6 3a 1d c6 c9 64 36 c4 d4 61 =
d2 3a f9 c1 57 e5 bc 44 e2 53 06 60 f6 19 33 b4 ba 0a 4f 5c 3c 2d e8 4d =
05 38 14 e6 ff 7d 6a=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D44 method=3D13 vendor=3D0 vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D1024) - Flags 0xc0=0A=
SSL: TLS Message Length: 2903=0A=
SSL: Need 875 bytes more input data=0A=
SSL: Building ACK (type=3D13 id=3D44 ver=3D0)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D90:a4:de:aa:42:94=0A=
TX EAPOL - hexdump(len=3D10): 01 00 00 06 02 2c 00 06 0d 00=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D889): 02 00 03 75 01 2d 03 75 0d 80 00 00 0b 57 =
c1 72 0e 02 9e 28 1b a9 12 30 1a a4 c8 c8 92 85 d6 dd 80 ea 26 45 b9 4f =
61 82 aa ea 96 d9 0e bf 68 03 70 ab 23 a6 33 09 79 fb f9 c9 c0 20 e9 6f =
98 3c eb 54 29 c8 fd 1d 26 f2 c1 ec 29 fc 0e 18 cc b2 4a f1 57 41 0c 7f =
d2 04 12 33 90 23 f8 ca 8b 0a 92 80 51 1f 5c a9 9e 2a 93 7c ae 6a 44 19 =
b1 c9 17 df 44 ce 7c e5 c5 f7 a7 64 ea 89 34 bf 0c 39 f1 e2 ec e0 11 ab =
58 54 80 5f 3b e8 6b a7 43 4a 42 e3 d7 8c 19 33 28 0b 97 e0 34 cc 43 fe =
05 b6 b5 8c 06 b6 2a 55 eb ed ec 64 36 2e 26 e7 72 37 57 40 f2 22 e7 f6 =
4e 21 96 21 a3 16 03 01 02 0d 0c 00 02 09 00 80 84 08 0b 02 7c 50 a4 b3 =
5b 96 b4 55 e7 79 7a 40 e0 b4 30 c6 8a d9 42 84 10 17 22 34 28 b5 bc 1a =
8b 12 d3 00 15 23 1e 03 f2 5c 7e 43 d8 5b 07 58 df f3 c1 4d 48 ec df 2b =
3e 1c 0a 45 ab e7 d7 78 3d d4 b8 99 33 a3 69 9a 10 c8 c8 72 0c 76 2b 4f =
8e 18 f9 94 d0 8d 11 f0 46 30 52 d9 a7 17 29 70 a2 8c d8 1a 6f a6 88 94 =
f1 1c 32 4b 4d 55 10 6d 6a 40 78 e9 85 a9 1b 62 3f 0b 5b ba 59 8b f2 e3 =
00 01 02 00 80 74 b3 d7 50 ae ca 1d e1 b9 c8 f8 1c 4f f8 67 18 ad 0a e5 =
ae fd 4e 01 2e eb 08 52 f4 bb b5 7f f3 50 fa 56 f3 c6 e3 80 34 e0 83 58 =
27 3e 26 ce 2a 6a c3 6a 1d ee ed 28 a1 31 1a 94 ff dc db 2c 40 4b 59 3e =
71 f0 fa b2 b3 d7 2a 28 75 0d 27 99 0f b8 b8 98 88 69 21 ba 61 38 5f e1 =
d2 00 3d 44 0e e4 5f 29 c7 63 0f 8a 26 8c fa ed 31 8e 57 0e a2 ea b7 01 =
ce 18 95 12 12 ec 10 3a ae 30 66 e3 ec 01 00 87 67 2c c0 90 05 be ac 3f =
e0 66 b6 95 1f 9e 15 7e 16 97 89 59 f5 8d 6e 08 51 6d be 34 6e f8 d5 30 =
5e 05 b9 a6 93 a2 75 82 b0 07 41 e0 e4 38 77 3c e3 08 23 6d d9 9d 78 70 =
3c e2 86 a3 ad 8d b0 bb 96 00 ed 20 f0 26 8c f4 d3 f7 17 d6 21 97 16 00 =
ff d2 2b 24 20 98 d1 95 13 56 a7 14 1b 00 7a 86 89 0a 07 73 2d 3c 1a 83 =
6e 9b c2 52 70 d5 fa 7b fd 3e 61 f0 2d d3 2c 6e ec 8f f5 08 8f 64 b8 3f =
f6 0a 24 b9 33 90 96 da 16 cd 12 64 21 6d cb 39 ad 34 00 ed 2d 69 b0 71 =
39 66 92 4d 6f 93 43 e0 c3 43 be 89 e4 9a 25 5e 9c 93 a1 34 78 2c 8f f4 =
53 ac aa de 4e 30 b5 00 66 07 9a 02 bc f7 f2 7e 3d dc 5a e3 34 e9 f7 29 =
8d 64 fc 2b 4b 8c d3 5f ed b7 81 72 91 ea b0 7f 8d 8d be 3c 86 4a 8c 7e =
10 77 d8 a5 8e c6 3d 87 0f a0 b0 10 c6 b1 40 31 c5 d0 81 8b 10 ad d8 6c =
d1 d7 e0 e6 f1 6e 4b 16 03 01 00 a7 0d 00 00 9f 04 03 04 01 02 00 98 00 =
96 30 81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 =
04 08 13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 09 53 6f 6d =
65 77 68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 =
20 49 6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 =
6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 =
13 1d 45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 65 20 41 75 =
74 68 6f 72 69 74 79 0e 00 00 00=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D45 method=3D13 vendor=3D0 vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D885) - Flags 0x80=0A=
SSL: TLS Message Length: 2903=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server hello A=0A=
TLS: tls_verify_cb - preverify_ok=3D1 err=3D0 (ok) ca_cert_verify=3D1 =
depth=3D1 buf=3D'/C=3DFR/ST=3DRadius/L=3DSomewhere/O=3DExample =
Inc./emailAddress=3Dadmin@example.com/CN=3DExample Certificate Authority'=0A=
wlan0: CTRL-EVENT-EAP-PEER-CERT depth=3D1 =
subject=3D'/C=3DFR/ST=3DRadius/L=3DSomewhere/O=3DExample =
Inc./emailAddress=3Dadmin@example.com/CN=3DExample Certificate Authority'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
TLS: tls_verify_cb - preverify_ok=3D1 err=3D0 (ok) ca_cert_verify=3D1 =
depth=3D0 buf=3D'/C=3DFR/ST=3DRadius/O=3DExample Inc./CN=3DExample =
Server Certificate/emailAddress=3Dadmin@example.com'=0A=
wlan0: CTRL-EVENT-EAP-PEER-CERT depth=3D0 =
subject=3D'/C=3DFR/ST=3DRadius/O=3DExample Inc./CN=3DExample Server =
Certificate/emailAddress=3Dadmin@example.com'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server certificate A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server key exchange A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server certificate request A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read server done A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write client certificate A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write client key exchange A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write certificate verify A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write change cipher spec A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 write finished A=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 flush data=0A=
SSL: (where=3D0x1002 ret=3D0xffffffff)=0A=
SSL: SSL_connect:error in SSLv3 read finished A=0A=
SSL: SSL_connect - want more data=0A=
SSL: 2595 bytes pending from ssl_out=0A=
SSL: 2595 bytes left to be sent out (of total 2595 bytes)=0A=
SSL: sending 1398 bytes, more fragments will follow=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D90:a4:de:aa:42:94=0A=
TX EAPOL - hexdump(len=3D1412): 01 00 05 80 02 2d 05 80 0d c0 00 00 0a =
23 16 03 01 08 4d 0b 00 08 49 00 08 46 00 03 95 30 82 03 91 30 82 02 79 =
a0 03 02 01 02 02 01 03 30 0d 06 09 2a 86 48 86 f7 0d 01 01 04 05 00 30 =
81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 =
13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 =
68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 =
6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 =
6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d =
45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 =
6f 72 69 74 79 30 1e 17 0d 31 32 30 35 30 33 31 35 35 37 33 32 5a 17 0d =
31 33 30 35 30 33 31 35 35 37 33 32 5a 30 6b 31 0b 30 09 06 03 55 04 06 =
13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 15 30 =
13 06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 10 30 0e =
06 03 55 04 03 13 07 74 68 65 75 73 65 72 31 22 30 20 06 09 2a 86 48 86 =
f7 0d 01 09 01 16 13 74 68 65 75 73 65 72 40 65 78 61 6d 70 6c 65 2e 63 =
6f 6d 30 82 01 22 30 0d 06 09 2a 86 48 86 f7 0d 01 01 01 05 00 03 82 01 =
0f 00 30 82 01 0a 02 82 01 01 00 c9 2d 5a aa e6 0a 9a 1b 4b 95 91 a0 bd =
79 79 75 ae e8 f4 87 bc 6b de 20 eb fd bf 77 5c 20 85 06 ed 24 56 c2 38 =
66 70 05 b4 c2 bb 6b ea 36 d5 bf 49 15 ad 45 d6 22 b0 4c 2c 2a 17 f3 3e =
b0 34 be e3 8e 2c 87 5a ff 27 ce 19 00 dd b3 5c 90 8b 28 ae 6d c4 f6 45 =
ce 88 11 25 c7 01 ba 31 2f 06 a6 be bb 32 88 50 97 e9 69 df 62 c8 5d a3 =
00 1b 2f 4b 1d 25 86 f3 16 59 6c 31 d7 9e b4 7e 54 2e de b3 42 2f e5 d2 =
7e 5c 04 06 ea 31 35 d6 1b f0 02 c9 97 84 bc 62 ce 24 71 4f 7d 5f 22 70 =
ed eb 7d c9 0d 6c b5 13 10 79 5d 5a 10 72 21 c2 6b e6 c1 3c c8 1e 94 89 =
36 62 85 44 e1 c8 d1 7b 61 8a af a1 20 bd fa d0 d4 de e4 ae 52 c1 33 6e =
c2 72 e6 1e 1c be 46 47 56 8e e1 36 74 0f be b0 d9 96 61 ad 27 29 29 0c =
98 53 a1 c9 92 cb 92 f0 64 2b a1 16 65 06 8e d6 7f 5b 75 40 f6 94 6d 3f =
a3 64 95 02 03 01 00 01 a3 17 30 15 30 13 06 03 55 1d 25 04 0c 30 0a 06 =
08 2b 06 01 05 05 07 03 02 30 0d 06 09 2a 86 48 86 f7 0d 01 01 04 05 00 =
03 82 01 01 00 4f ca f0 54 de dd 9a 32 a4 b3 74 76 5c 97 82 84 c7 08 7f =
c9 aa 1b 77 18 eb 4f fb e2 c2 5b 0b bb 39 68 45 15 76 8c 32 f4 b5 d7 d6 =
7e 92 ff c7 d1 e6 a7 13 89 f0 ab 57 a0 fd dc 63 7c 60 53 17 78 9f 85 e7 =
c2 2d 16 62 66 35 54 f9 3a fa 8e f8 a2 25 50 d7 73 00 fd 42 94 3a 95 1d =
ad 00 95 8b 77 d7 72 2c 2b df 0d cd de e8 6b f7 16 71 8a db c3 8e 0b 67 =
1a 3b 3b 8d 91 90 87 c5 7f 6b bc 94 e1 12 b8 8d 0b c6 a7 30 f3 68 68 41 =
9b 0a 6d 93 71 fc ab f3 c3 cf a7 5d cf ae bb 2c 18 e1 bd e5 a9 66 11 1e =
38 b8 7b a2 43 c6 98 d9 37 cd 69 4c 4a b3 4e 1c ef 31 ed d7 70 f7 e4 2f =
a6 f8 40 e6 41 f0 a7 6b 7b c7 d9 84 ff 53 3d ba db ee 50 24 2b 8f 5a 42 =
77 b2 78 ce 32 37 ae c4 54 f6 7d 61 9e 58 20 5e af 72 d5 42 cf 87 9d 96 =
8f 02 88 de e5 0c f1 3b 39 3f 43 df 22 f6 79 03 06 07 2a 28 e2 00 04 ab =
30 82 04 a7 30 82 03 8f a0 03 02 01 02 02 09 00 89 95 bd d4 00 94 4a 26 =
30 0d 06 09 2a 86 48 86 f7 0d 01 01 05 05 00 30 81 93 31 0b 30 09 06 03 =
55 04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 75 73 =
31 12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 =
06 03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 =
09 2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c =
65 2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 =
43 65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 6f 72 69 74 79 30 1e 17 =
0d 31 32 30 35 30 33 31 33 34 39 35 37 5a 17 0d 31 33 30 35 30 33 31 33 =
34 39 35 37 5a 30 81 93 31 0b 30 09 06 03 55 04 06 13 02 46 52 31 0f 30 =
0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 12 30 10 06 03 55 04 07 13 =
09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 06 03 55 04 0a 13 0c 45 78 61 =
6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 09 2a 86 48 86 f7 0d 01 09 01 =
16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 2e 63 6f 6d 31 26 30 24 06 =
03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 43 65 72 74 69 66 69 63 61 74 =
65 20 41 75 74 68 6f 72 69 74 79 30 82 01 22 30 0d 06 09 2a 86 48 86 f7 =
0d 01 01 01 05 00 03 82 01 0f 00 30 82 01 0a 02 82 01 01 00 9e 34 8e d1 =
c3 75 3a 22 29 b2 dd 98 e2 01 2d 9d 6c 91 c5 89 b4 15 a2 5b c5 78 80 cd =
de cf a1 b7 59 70 b2 8a 97 64 df c5 22 40 39 d0 e6 b3 b4 e6 44 55 d1 23 =
36 fa f8 e8 ae 72 6a=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D10): 02 00 00 06 01 2e 00 06 0d 00=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D46 method=3D13 vendor=3D0 vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D6) - Flags 0x00=0A=
SSL: 1197 bytes left to be sent out (of total 2595 bytes)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT =
decision=3DFAIL=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D90:a4:de:aa:42:94=0A=
TX EAPOL - hexdump(len=3D1207): 01 00 04 b3 02 2e 04 b3 0d 00 b2 1e 16 =
a5 ab 3f 76 8b 30 a6 4c a9 27 7d 52 0e bf e7 0c 52 52 5b 23 42 18 f9 a7 =
0c 1e f3 c3 21 00 a6 ac 11 e0 56 4f 34 04 c0 a4 ae ce 6c 9f b6 ba 57 c9 =
08 11 a9 99 0d cb c1 a2 0e fa 33 a8 c3 9b ec 37 95 ac f6 91 d1 1b b7 76 =
00 48 5b b4 07 8e bf bb 12 fa 57 35 d5 59 de 2f 12 a1 0e 72 ac 7a 91 b8 =
b3 66 31 e5 19 be dd 0a c2 67 f5 0f 0c 6b 62 d8 1f 6c 30 3d bf ef 7a dc =
9a ac d5 b6 06 f2 43 28 ab e0 90 42 c8 0b 68 23 e9 4c a4 1e 62 a6 c2 01 =
aa a0 c5 12 ca d0 ac 46 7e ef b0 6b 86 aa 67 79 33 56 eb fb 1f b8 57 66 =
fd 2d e3 c7 a2 37 e6 1b bf 14 32 7b 1e f9 7a c3 02 e6 f3 4c 09 d7 75 05 =
d2 5d 02 03 01 00 01 a3 81 fb 30 81 f8 30 1d 06 03 55 1d 0e 04 16 04 14 =
b5 52 d1 e7 e5 76 8b d1 01 80 79 1b 24 ea 53 a8 76 34 2b 67 30 81 c8 06 =
03 55 1d 23 04 81 c0 30 81 bd 80 14 b5 52 d1 e7 e5 76 8b d1 01 80 79 1b =
24 ea 53 a8 76 34 2b 67 a1 81 99 a4 81 96 30 81 93 31 0b 30 09 06 03 55 =
04 06 13 02 46 52 31 0f 30 0d 06 03 55 04 08 13 06 52 61 64 69 75 73 31 =
12 30 10 06 03 55 04 07 13 09 53 6f 6d 65 77 68 65 72 65 31 15 30 13 06 =
03 55 04 0a 13 0c 45 78 61 6d 70 6c 65 20 49 6e 63 2e 31 20 30 1e 06 09 =
2a 86 48 86 f7 0d 01 09 01 16 11 61 64 6d 69 6e 40 65 78 61 6d 70 6c 65 =
2e 63 6f 6d 31 26 30 24 06 03 55 04 03 13 1d 45 78 61 6d 70 6c 65 20 43 =
65 72 74 69 66 69 63 61 74 65 20 41 75 74 68 6f 72 69 74 79 82 09 00 89 =
95 bd d4 00 94 4a 26 30 0c 06 03 55 1d 13 04 05 30 03 01 01 ff 30 0d 06 =
09 2a 86 48 86 f7 0d 01 01 05 05 00 03 82 01 01 00 40 28 ff 3b 19 ba 33 =
5e ab fc ad 60 14 53 fa 1b b4 55 d0 49 5d 66 dd 49 e7 b1 8d 61 ed ef bc =
fb 7d 56 22 05 d9 3d fd f6 a3 be c6 3a 1d c6 c9 64 36 c4 d4 61 d2 3a f9 =
c1 57 e5 bc 44 e2 53 06 60 f6 19 33 b4 ba 0a 4f 5c 3c 2d e8 4d 05 38 14 =
e6 ff 7d 6a c1 72 0e 02 9e 28 1b a9 12 30 1a a4 c8 c8 92 85 d6 dd 80 ea =
26 45 b9 4f 61 82 aa ea 96 d9 0e bf 68 03 70 ab 23 a6 33 09 79 fb f9 c9 =
c0 20 e9 6f 98 3c eb 54 29 c8 fd 1d 26 f2 c1 ec 29 fc 0e 18 cc b2 4a f1 =
57 41 0c 7f d2 04 12 33 90 23 f8 ca 8b 0a 92 80 51 1f 5c a9 9e 2a 93 7c =
ae 6a 44 19 b1 c9 17 df 44 ce 7c e5 c5 f7 a7 64 ea 89 34 bf 0c 39 f1 e2 =
ec e0 11 ab 58 54 80 5f 3b e8 6b a7 43 4a 42 e3 d7 8c 19 33 28 0b 97 e0 =
34 cc 43 fe 05 b6 b5 8c 06 b6 2a 55 eb ed ec 64 36 2e 26 e7 72 37 57 40 =
f2 22 e7 f6 4e 21 96 21 a3 16 03 01 00 86 10 00 00 82 00 80 10 81 f0 8e =
fc 44 90 9b 63 ba 91 03 58 5f 02 48 df c2 7f af f9 f1 5b f5 f6 21 42 02 =
d0 cc ea 52 97 d8 95 df b4 af aa e0 0e eb 72 2f 51 04 6d fe bc 75 71 44 =
74 0a 20 d9 33 58 7c a7 f4 0c b2 03 46 4c 46 7f 4d d5 e2 05 cd c2 fa fb =
60 07 19 c7 c2 cb c7 b9 41 98 df ea e4 92 7d 69 66 20 a4 aa be 06 63 6b =
a8 d5 81 10 7c 3f 38 d5 19 87 5d f0 8a db 54 08 5d 9b 6d bf 2a b7 56 7b =
78 b6 83 3f 16 03 01 01 06 0f 00 01 02 01 00 bf c5 43 20 d0 66 e8 40 24 =
72 9b 00 4a 51 64 ad d7 76 1b b2 c9 57 0b c1 51 92 72 8e dd 29 06 ad dd =
f2 30 a5 db 9e 76 a4 d4 7f 26 4c fe 2a ca 83 5e 36 e6 84 1d 8f 57 56 e4 =
2f 48 13 28 ab 44 1c bb 48 5e 54 22 48 3a c9 f5 a6 d4 11 0d cd 0c 57 5b =
f5 3f 96 d3 8b 49 a0 bb 84 64 79 82 b0 0e 6a 32 5d 47 6c b3 d2 d5 be 6c =
3d 26 41 de 0a 09 d2 ec 8c cf 39 d4 c2 d1 e7 85 0d e7 26 cb 0f f7 16 c0 =
73 e0 b1 aa f8 c1 fa 23 e8 a6 c9 e9 72 71 54 66 67 ba fb bc 46 d9 f3 61 =
32 c8 06 b8 1a 10 37 db 06 ee f5 aa 7c b3 e0 cd 22 2c 87 f1 ac 48 bd 5a =
85 a8 dc 37 e7 1d 9e 61 89 c2 a9 1a 22 04 ca c8 ff 18 17 0c 36 ba 50 80 =
fb fe 10 81 94 b6 e4 d5 2f eb 44 b2 b9 9c a6 2e f2 33 c2 1a 81 60 dd c5 =
5c 39 9e 7b 0f d3 60 3c f5 b3 a6 da c7 07 9c 79 06 4e 0e de 07 f9 fa 6b =
7a 40 ef cb 00 e7 36 14 03 01 00 01 01 16 03 01 00 30 ef c1 b6 02 fa 9b =
ac 51 85 6a 82 82 c7 27 b2 db ff ed dd 24 8e 90 85 1e 2c 4a 9f 07 5a 0a =
10 97 18 04 5a f5 62 6b 2b b9 67 bd 1f 00 25 ed ae 57=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D73): 02 00 00 45 01 2f 00 45 0d 80 00 00 00 3b =
14 03 01 00 01 01 16 03 01 00 30 19 73 22 23 81 bd 41 ee 27 fa a8 7b 94 =
a1 f1 16 cf eb d5 0e 6a 2a 4b 25 97 f1 69 18 f7 3e 3a 9c 3d 93 d4 7a b2 =
ed 02 49 ae c5 df ce e6 64 cc 0a=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Request id=3D47 method=3D13 vendor=3D0 vendorMethod=3D0=0A=
EAP: EAP entering state METHOD=0A=
SSL: Received packet(len=3D69) - Flags 0x80=0A=
SSL: TLS Message Length: 59=0A=
SSL: (where=3D0x1001 ret=3D0x1)=0A=
SSL: SSL_connect:SSLv3 read finished A=0A=
SSL: (where=3D0x20 ret=3D0x1)=0A=
SSL: (where=3D0x1002 ret=3D0x1)=0A=
SSL: 0 bytes pending from ssl_out=0A=
SSL: No Application Data included=0A=
SSL: No data to be sent out=0A=
EAP-TLS: Done=0A=
EAP-TLS: Derived key - hexdump(len=3D64): [REMOVED]=0A=
EAP-TLS: Derived EMSK - hexdump(len=3D64): [REMOVED]=0A=
SSL: Building ACK (type=3D13 id=3D47 ver=3D0)=0A=
EAP: method process -> ignore=3DFALSE methodState=3DDONE =
decision=3DUNCOND_SUCC=0A=
EAP: EAP entering state SEND_RESPONSE=0A=
EAP: EAP entering state IDLE=0A=
EAPOL: SUPP_BE entering state RESPONSE=0A=
EAPOL: txSuppRsp=0A=
TX EAPOL: dst=3D90:a4:de:aa:42:94=0A=
TX EAPOL - hexdump(len=3D10): 01 00 00 06 02 2f 00 06 0d 00=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D8): 02 00 00 04 03 2f 00 04=0A=
EAPOL: Received EAP-Packet frame=0A=
EAPOL: SUPP_BE entering state REQUEST=0A=
EAPOL: getSuppRsp=0A=
EAP: EAP entering state RECEIVED=0A=
EAP: Received EAP-Success=0A=
EAP: EAP entering state SUCCESS=0A=
wlan0: CTRL-EVENT-EAP-SUCCESS EAP authentication completed successfully=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
EAPOL: SUPP_BE entering state RECEIVE=0A=
EAPOL: SUPP_BE entering state SUCCESS=0A=
EAPOL: SUPP_BE entering state IDLE=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 =
00 00 01 f3 36 a6 51 eb 42 9c c6 98 e1 7e 4b 12 88 fc ee 70 4b 17 b4 99 =
86 fe 8f 83 da e9 7f aa 12 29 d3 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 11 1c 5b ea 4c =
1f 0d 2d da d6 00 51 a8 fe 6b 3f=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D117=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x8a (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Ack)=0A=
wlan0:   key_length=3D16 key_data_length=3D22=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01=0A=
  key_nonce - hexdump(len=3D32): f3 36 a6 51 eb 42 9c c6 98 e1 7e 4b 12 =
88 fc ee 70 4b 17 b4 99 86 fe 8f 83 da e9 7f aa 12 29 d3=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
WPA: RX EAPOL-Key - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 =
00 00 00 00 00 01 f3 36 a6 51 eb 42 9c c6 98 e1 7e 4b 12 88 fc ee 70 4b =
17 b4 99 86 fe 8f 83 da e9 7f aa 12 29 d3 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 11 1c =
5b ea 4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f=0A=
wlan0: State: ASSOCIATED -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 1 of 4-Way Handshake from 90:a4:de:aa:42:94 =
(ver=3D2)=0A=
RSN: msg 1/4 key data - hexdump(len=3D22): dd 14 00 0f ac 04 11 1c 5b ea =
4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f=0A=
WPA: PMKID in EAPOL-Key - hexdump(len=3D22): dd 14 00 0f ac 04 11 1c 5b =
ea 4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f=0A=
RSN: PMKID from Authenticator - hexdump(len=3D16): 11 1c 5b ea 4c 1f 0d =
2d da d6 00 51 a8 fe 6b 3f=0A=
wlan0: RSN: no matching PMKID found=0A=
EAPOL: Successfully fetched key (len=3D32)=0A=
EAPOL: Successfully fetched key (len=3D64)=0A=
WPA: PMK from EAPOL state machines - hexdump(len=3D32): [REMOVED]=0A=
RSN: Added PMKSA cache entry for 90:a4:de:aa:42:94 =
network_ctx=3D0x10427908=0A=
nl80211: Add PMKID for 90:a4:de:aa:42:94=0A=
wlan0: RSN: the new PMK matches with the PMKID=0A=
Get randomness: len=3D32 entropy=3D1=0A=
WPA: Renewed SNonce - hexdump(len=3D32): 70 c1 b8 ad 90 f9 39 1c fc e5 =
28 fe c6 77 4a eb 67 04 62 c6 1c 00 30 5d cc b6 49 72 45 ea a9 82=0A=
WPA: PTK derivation - A1=3D90:a4:de:21:4f:53 A2=3D90:a4:de:aa:42:94=0A=
WPA: Nonce1 - hexdump(len=3D32): 70 c1 b8 ad 90 f9 39 1c fc e5 28 fe c6 =
77 4a eb 67 04 62 c6 1c 00 30 5d cc b6 49 72 45 ea a9 82=0A=
WPA: Nonce2 - hexdump(len=3D32): f3 36 a6 51 eb 42 9c c6 98 e1 7e 4b 12 =
88 fc ee 70 4b 17 b4 99 86 fe 8f 83 da e9 7f aa 12 29 d3=0A=
WPA: PMK - hexdump(len=3D32): [REMOVED]=0A=
WPA: PTK - hexdump(len=3D48): [REMOVED]=0A=
WPA: WPA IE for msg 2/4 - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00=0A=
WPA: Replay Counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01=0A=
wlan0: WPA: Sending EAPOL-Key 2/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): 8b 96 3e af f8 7e 76 cc 1a 28 =
35 4d 4c 1c 6d 37=0A=
WPA: TX EAPOL-Key - hexdump(len=3D121): 01 03 00 75 02 01 0a 00 00 00 00 =
00 00 00 00 00 01 70 c1 b8 ad 90 f9 39 1c fc e5 28 fe c6 77 4a eb 67 04 =
62 c6 1c 00 30 5d cc b6 49 72 45 ea a9 82 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8b 96 =
3e af f8 7e 76 cc 1a 28 35 4d 4c 1c 6d 37 00 16 30 14 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 =
00 00 02 f3 36 a6 51 eb 42 9c c6 98 e1 7e 4b 12 88 fc ee 70 4b 17 b4 99 =
86 fe 8f 83 da e9 7f aa 12 29 d3 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 87 fd 73 31 e7 =
22 de 28 f0 1a 6f 13 ef b2 8a af 00 38 6f 12 bd f1 39 0f db e7 b0 e2 45 =
f0 d6 e9 54 6d 1d f1 c8 64 45 49 cb 13 39 59 ae 9d da 6b 02 a7 58 e3 2c =
18 31 99 88 99 24 9b 44 03 d3 20 cd 6a 14 80 d1 36 1c 03 9d 9b=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D151=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x13ca (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Install =
Ack MIC Secure Encr)=0A=
wlan0:   key_length=3D16 key_data_length=3D56=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 02=0A=
  key_nonce - hexdump(len=3D32): f3 36 a6 51 eb 42 9c c6 98 e1 7e 4b 12 =
88 fc ee 70 4b 17 b4 99 86 fe 8f 83 da e9 7f aa 12 29 d3=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): 87 fd 73 31 e7 22 de 28 f0 1a 6f 13 ef b2 =
8a af=0A=
WPA: RX EAPOL-Key - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 =
00 00 00 00 00 02 f3 36 a6 51 eb 42 9c c6 98 e1 7e 4b 12 88 fc ee 70 4b =
17 b4 99 86 fe 8f 83 da e9 7f aa 12 29 d3 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 87 fd =
73 31 e7 22 de 28 f0 1a 6f 13 ef b2 8a af 00 38 6f 12 bd f1 39 0f db e7 =
b0 e2 45 f0 d6 e9 54 6d 1d f1 c8 64 45 49 cb 13 39 59 ae 9d da 6b 02 a7 =
58 e3 2c 18 31 99 88 99 24 9b 44 03 d3 20 cd 6a 14 80 d1 36 1c 03 9d 9b=0A=
RSN: encrypted key data - hexdump(len=3D56): 6f 12 bd f1 39 0f db e7 b0 =
e2 45 f0 d6 e9 54 6d 1d f1 c8 64 45 49 cb 13 39 59 ae 9d da 6b 02 a7 58 =
e3 2c 18 31 99 88 99 24 9b 44 03 d3 20 cd 6a 14 80 d1 36 1c 03 9d 9b=0A=
WPA: decrypted EAPOL-Key key data - hexdump(len=3D48): [REMOVED]=0A=
wlan0: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 3 of 4-Way Handshake from 90:a4:de:aa:42:94 =
(ver=3D2)=0A=
WPA: IE KeyData - hexdump(len=3D48): 30 14 01 00 00 0f ac 04 01 00 00 0f =
ac 04 01 00 00 0f ac 01 0c 00 dd 16 00 0f ac 01 01 00 fa 4b 90 e8 a1 a0 =
bf 85 d6 ee 38 78 fe 1d 61 82 dd 00=0A=
WPA: RSN IE in EAPOL-Key - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 0c 00=0A=
WPA: GTK in EAPOL-Key - hexdump(len=3D24): [REMOVED]=0A=
wlan0: WPA: Sending EAPOL-Key 4/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): df f0 26 76 f4 15 9c e3 7c 27 =
5d 67 03 af d3 d8=0A=
WPA: TX EAPOL-Key - hexdump(len=3D99): 01 03 00 5f 02 03 0a 00 00 00 00 =
00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 df f0 =
26 76 f4 15 9c e3 7c 27 5d 67 03 af d3 d8 00 00=0A=
wlan0: WPA: Installing PTK to the driver=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10426f28 =
key_idx=3D0 set_tx=3D1 seq_len=3D6 key_len=3D16=0A=
   addr=3D90:a4:de:aa:42:94=0A=
EAPOL: External notification - portValid=3D1=0A=
EAPOL: SUPP_PAE entering state AUTHENTICATED=0A=
EAPOL: Supplicant port status: Authorized=0A=
EAPOL authentication completed successfully=0A=
wlan0: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE=0A=
RSN: received GTK in pairwise handshake - hexdump(len=3D18): [REMOVED]=0A=
WPA: Group Key - hexdump(len=3D16): [REMOVED]=0A=
wlan0: WPA: Installing GTK to the driver (keyidx=3D1 tx=3D0 len=3D16)=0A=
WPA: RSC - hexdump(len=3D6): 00 00 00 00 00 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10082f30 =
key_idx=3D1 set_tx=3D0 seq_len=3D6 key_len=3D16=0A=
   broadcast key=0A=
wlan0: WPA: Key negotiation completed with 90:a4:de:aa:42:94 [PTK=3DCCMP =
GTK=3DCCMP]=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: Cancelling authentication timeout=0A=
wlan0: State: GROUP_HANDSHAKE -> COMPLETED=0A=
wlan0: CTRL-EVENT-CONNECTED - Connection to 90:a4:de:aa:42:94 completed =
(reauth) [id=3D0 id_str=3D]=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D6=0A=
EAPOL: External notification - portValid=3D1=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D22):=0A=
     52 4f 41 4d 20 30 30 3a 31 42 3a 42 31 3a 35 38   ROAM 00:1B:B1:58=0A=
     3a 46 36 3a 44 44                                 :F6:DD          =0A=
CTRL_IFACE ROAM 00:1b:b1:58:f6:dd=0A=
wlan0: Request association: reassociate: 1  selected: 00:1b:b1:58:f6:dd  =
bssid: 90:a4:de:aa:42:94  pending: 00:00:00:00:00:00  wpa_state: =
COMPLETED=0A=
wlan0: Automatic auth_alg selection: 0x1=0A=
RSN: PMKSA cache search - network_ctx=3D0x10427908 try_opportunistic=3D0=0A=
RSN: Search for BSSID 00:1b:b1:58:f6:dd=0A=
RSN: PMKSA cache entry found - PMKID - hexdump(len=3D16): d5 64 6e 8a ac =
6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
RSN: Trying to use cached PMKSA=0A=
wlan0: RSN: using IEEE 802.11i/D9.0=0A=
wlan0: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 1 =
proto 2=0A=
wlan0: WPA: clearing AP WPA IE=0A=
WPA: set AP RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 00 00 =
0f ac 04 01 00 00 0f ac 01 0c 00=0A=
wlan0: WPA: using GTK CCMP=0A=
wlan0: WPA: using PTK CCMP=0A=
wlan0: WPA: using KEY_MGMT 802.1X=0A=
wlan0: WPA: not using MGMT group cipher=0A=
WPA: Set own WPA IE default - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 =
1d e0 2d e8 0c 36 d4 a5=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
wlan0: Cancelling scan request=0A=
wlan0: SME: Trying to authenticate with 00:1b:b1:58:f6:dd =
(SSID=3D'cdtest' freq=3D5680 MHz)=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D4 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D5 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D0x1042d058 =
key_idx=3D0 set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
   addr=3D00:1b:b1:58:f6:dd=0A=
wlan0: State: COMPLETED -> AUTHENTICATING=0A=
EAPOL: External notification - EAP success=3D0=0A=
EAPOL: External notification - EAP fail=3D0=0A=
EAPOL: External notification - portControl=3DAuto=0A=
nl80211: Authenticate (ifindex=3D5)=0A=
  * bssid=3D00:1b:b1:58:f6:dd=0A=
  * freq=3D5680=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D0): [NULL]=0A=
  * Auth Type 0=0A=
wlan0: nl80211: MLME command failed (auth): ret=3D-2 (No such file or =
directory)=0A=
nl80211: Trigger single channel scan to refresh cfg80211 BSS entry=0A=
nl80211: Scan SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
nl80211: Scan frequency 5680 MHz=0A=
Scan requested (ret=3D0) - scan timeout 30 seconds=0A=
nl80211: Event message available=0A=
nl80211: Scan trigger=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: Beacon loss event=0A=
wlan0: Event BEACON_LOSS (49) received=0A=
nl80211: Event message available=0A=
nl80211: New scan results available=0A=
nl80211: Scan results for missing cfg80211 BSS entry=0A=
nl80211: Try to authenticate again=0A=
nl80211: Authenticate (ifindex=3D5)=0A=
  * bssid=3D00:1b:b1:58:f6:dd=0A=
  * freq=3D5680=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D0): [NULL]=0A=
  * Auth Type 0=0A=
nl80211: Authentication request send successfully=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x1003 ([UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: Delete station 90:a4:de:aa:42:94=0A=
nl80211: Event message available=0A=
nl80211: New station 00:1b:b1:58:f6:dd=0A=
nl80211: Event message available=0A=
nl80211: MLME event 37=0A=
nl80211: MLME event frame - hexdump(len=3D30): b0 00 3c 00 90 a4 de 21 =
4f 53 00 1b b1 58 f6 dd 00 1b b1 58 f6 dd 30 3e 00 00 02 00 00 00=0A=
wlan0: Event AUTH (11) received=0A=
wlan0: SME: Authentication response: peer=3D00:1b:b1:58:f6:dd =
auth_type=3D0 status_code=3D0=0A=
SME: Authentication response IEs - hexdump(len=3D0): [NULL]=0A=
wlan0: Trying to associate with 00:1b:b1:58:f6:dd (SSID=3D'cdtest' =
freq=3D5680 MHz)=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: State: AUTHENTICATING -> ASSOCIATING=0A=
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
WPA: set own WPA/RSN IE - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 1d =
e0 2d e8 0c 36 d4 a5=0A=
nl80211: Associate (ifindex=3D5)=0A=
  * bssid=3D00:1b:b1:58:f6:dd=0A=
  * freq=3D5680=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 =
01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 1d e0 2d e8 0c 36 =
d4 a5=0A=
  * pairwise=3D0xfac04=0A=
  * group=3D0xfac04=0A=
  * prev_bssid=3D90:a4:de:aa:42:94=0A=
nl80211: Association request send successfully=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: MLME event 38=0A=
nl80211: MLME event frame - hexdump(len=3D66): 30 00 3c 00 90 a4 de 21 =
4f 53 00 1b b1 58 f6 dd 00 1b b1 58 f6 dd 40 3e 11 00 00 00 01 c0 01 08 =
8c 12 98 24 b0 48 60 6c dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 =
00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: Event ASSOC (0) received=0A=
wlan0: Association info event=0A=
resp_ies - hexdump(len=3D36): 01 08 8c 12 98 24 b0 48 60 6c dd 18 00 50 =
f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: freq=3D5680 MHz=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
Operating frequency changed from 5660 to 5680 MHz=0A=
nl80211: Associated on 5680 MHz=0A=
nl80211: Associated with 00:1b:b1:58:f6:dd=0A=
nl80211: Received scan results (2 BSSes)=0A=
nl80211: Scan results indicate BSS status with 00:1b:b1:58:f6:dd as =
associated=0A=
wlan0: BSS: Start scan result update 3=0A=
wlan0: State: ASSOCIATING -> ASSOCIATED=0A=
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
wlan0: Associated to a new BSS: BSSID=3D00:1b:b1:58:f6:dd=0A=
wlan0: No keys have been configured - skip key clearing=0A=
wlan0: Associated with 00:1b:b1:58:f6:dd=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: WPA: Association event - clear replay counter=0A=
wlan0: WPA: Clear old PTK=0A=
EAPOL: External notification - portEnabled=3D0=0A=
EAPOL: SUPP_PAE entering state DISCONNECTED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: SUPP_BE entering state INITIALIZE=0A=
EAP: EAP entering state DISABLED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portValid=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portEnabled=3D1=0A=
EAPOL: SUPP_PAE entering state CONNECTING=0A=
EAPOL: SUPP_BE entering state IDLE=0A=
EAP: EAP entering state INITIALIZE=0A=
EAP: maintaining EAP method data for fast reauthentication=0A=
EAP: EAP entering state IDLE=0A=
wlan0: Setting authentication timeout: 10 sec 0 usec=0A=
wlan0: Cancelling scan request=0A=
nl80211: Event message available=0A=
nl80211: Ignore connect event (cmd=3D46) when using userspace SME=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 =
00 00 03 04 87 cb bd f4 5c 46 b4 ce 1c d5 37 eb 5c 86 85 d4 a4 7c 54 5d =
65 53 ef 36 23 34 71 73 c8 1f da 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 d5 64 6e 8a ac =
6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
wlan0: Setting authentication timeout: 70 sec 0 usec=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D117=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x8a (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Ack)=0A=
wlan0:   key_length=3D16 key_data_length=3D22=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 03=0A=
  key_nonce - hexdump(len=3D32): 04 87 cb bd f4 5c 46 b4 ce 1c d5 37 eb =
5c 86 85 d4 a4 7c 54 5d 65 53 ef 36 23 34 71 73 c8 1f da=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
WPA: RX EAPOL-Key - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 =
00 00 00 00 00 03 04 87 cb bd f4 5c 46 b4 ce 1c d5 37 eb 5c 86 85 d4 a4 =
7c 54 5d 65 53 ef 36 23 34 71 73 c8 1f da 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 d5 64 =
6e 8a ac 6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
wlan0: State: ASSOCIATED -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 1 of 4-Way Handshake from 00:1b:b1:58:f6:dd =
(ver=3D2)=0A=
RSN: msg 1/4 key data - hexdump(len=3D22): dd 14 00 0f ac 04 d5 64 6e 8a =
ac 6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
WPA: PMKID in EAPOL-Key - hexdump(len=3D22): dd 14 00 0f ac 04 d5 64 6e =
8a ac 6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
RSN: PMKID from Authenticator - hexdump(len=3D16): d5 64 6e 8a ac 6c db =
b7 1d e0 2d e8 0c 36 d4 a5=0A=
RSN: matched PMKID - hexdump(len=3D16): d5 64 6e 8a ac 6c db b7 1d e0 2d =
e8 0c 36 d4 a5=0A=
RSN: PMK from PMKSA cache - hexdump(len=3D32): [REMOVED]=0A=
EAPOL: PMKSA caching was used - skip EAPOL=0A=
EAPOL: Supplicant port status: Authorized=0A=
Get randomness: len=3D32 entropy=3D1=0A=
WPA: Renewed SNonce - hexdump(len=3D32): 03 3d 4e 96 12 00 7c 54 4d 45 =
3d 20 f6 51 84 b0 39 54 e7 7a 9c cd 8a 6b b1 24 05 62 0e 8f f4 8d=0A=
WPA: PTK derivation - A1=3D90:a4:de:21:4f:53 A2=3D00:1b:b1:58:f6:dd=0A=
WPA: Nonce1 - hexdump(len=3D32): 03 3d 4e 96 12 00 7c 54 4d 45 3d 20 f6 =
51 84 b0 39 54 e7 7a 9c cd 8a 6b b1 24 05 62 0e 8f f4 8d=0A=
WPA: Nonce2 - hexdump(len=3D32): 04 87 cb bd f4 5c 46 b4 ce 1c d5 37 eb =
5c 86 85 d4 a4 7c 54 5d 65 53 ef 36 23 34 71 73 c8 1f da=0A=
WPA: PMK - hexdump(len=3D32): [REMOVED]=0A=
WPA: PTK - hexdump(len=3D48): [REMOVED]=0A=
WPA: WPA IE for msg 2/4 - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 1d =
e0 2d e8 0c 36 d4 a5=0A=
WPA: Replay Counter - hexdump(len=3D8): 00 00 00 00 00 00 00 03=0A=
wlan0: WPA: Sending EAPOL-Key 2/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): ff 7c cc ed 19 18 0c 3e 6a 96 =
58 de 3d 1b 2d 23=0A=
WPA: TX EAPOL-Key - hexdump(len=3D139): 01 03 00 87 02 01 0a 00 00 00 00 =
00 00 00 00 00 03 03 3d 4e 96 12 00 7c 54 4d 45 3d 20 f6 51 84 b0 39 54 =
e7 7a 9c cd 8a 6b b1 24 05 62 0e 8f f4 8d 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff 7c =
cc ed 19 18 0c 3e 6a 96 58 de 3d 1b 2d 23 00 28 30 26 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 =
1d e0 2d e8 0c 36 d4 a5=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 =
00 00 04 04 87 cb bd f4 5c 46 b4 ce 1c d5 37 eb 5c 86 85 d4 a4 7c 54 5d =
65 53 ef 36 23 34 71 73 c8 1f da 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 2d 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 15 3c ae f1 4b =
b6 85 00 b9 9a cc cd ed 48 7d 7d 00 38 30 87 26 67 cb ff 94 0d 75 4b 5d =
cf 94 09 61 b2 93 af 99 35 ee c6 52 93 c4 f8 bc 49 ba c0 3f 4e 94 8a 17 =
e6 c1 2f 31 22 cb e1 00 9c 13 30 ba e8 37 89 b8 5c 64 ea ba f4=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D151=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x13ca (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Install =
Ack MIC Secure Encr)=0A=
wlan0:   key_length=3D16 key_data_length=3D56=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 04=0A=
  key_nonce - hexdump(len=3D32): 04 87 cb bd f4 5c 46 b4 ce 1c d5 37 eb =
5c 86 85 d4 a4 7c 54 5d 65 53 ef 36 23 34 71 73 c8 1f da=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 2d 01 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): 15 3c ae f1 4b b6 85 00 b9 9a cc cd ed 48 =
7d 7d=0A=
WPA: RX EAPOL-Key - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 =
00 00 00 00 00 04 04 87 cb bd f4 5c 46 b4 ce 1c d5 37 eb 5c 86 85 d4 a4 =
7c 54 5d 65 53 ef 36 23 34 71 73 c8 1f da 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 2d 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 15 3c =
ae f1 4b b6 85 00 b9 9a cc cd ed 48 7d 7d 00 38 30 87 26 67 cb ff 94 0d =
75 4b 5d cf 94 09 61 b2 93 af 99 35 ee c6 52 93 c4 f8 bc 49 ba c0 3f 4e =
94 8a 17 e6 c1 2f 31 22 cb e1 00 9c 13 30 ba e8 37 89 b8 5c 64 ea ba f4=0A=
RSN: encrypted key data - hexdump(len=3D56): 30 87 26 67 cb ff 94 0d 75 =
4b 5d cf 94 09 61 b2 93 af 99 35 ee c6 52 93 c4 f8 bc 49 ba c0 3f 4e 94 =
8a 17 e6 c1 2f 31 22 cb e1 00 9c 13 30 ba e8 37 89 b8 5c 64 ea ba f4=0A=
WPA: decrypted EAPOL-Key key data - hexdump(len=3D48): [REMOVED]=0A=
wlan0: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 3 of 4-Way Handshake from 00:1b:b1:58:f6:dd =
(ver=3D2)=0A=
WPA: IE KeyData - hexdump(len=3D48): 30 14 01 00 00 0f ac 04 01 00 00 0f =
ac 04 01 00 00 0f ac 01 0c 00 dd 16 00 0f ac 01 01 00 f7 ed fd 17 1b 8a =
08 77 c5 02 48 f8 0e de 04 2c dd 00=0A=
WPA: RSN IE in EAPOL-Key - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 0c 00=0A=
WPA: GTK in EAPOL-Key - hexdump(len=3D24): [REMOVED]=0A=
wlan0: WPA: Sending EAPOL-Key 4/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): 2c dd c8 ff e3 e3 72 81 f5 1f =
03 21 2d c9 32 26=0A=
WPA: TX EAPOL-Key - hexdump(len=3D99): 01 03 00 5f 02 03 0a 00 00 00 00 =
00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2c dd =
c8 ff e3 e3 72 81 f5 1f 03 21 2d c9 32 26 00 00=0A=
wlan0: WPA: Installing PTK to the driver=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10426f28 =
key_idx=3D0 set_tx=3D1 seq_len=3D6 key_len=3D16=0A=
   addr=3D00:1b:b1:58:f6:dd=0A=
EAPOL: External notification - portValid=3D1=0A=
wlan0: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE=0A=
RSN: received GTK in pairwise handshake - hexdump(len=3D18): [REMOVED]=0A=
WPA: Group Key - hexdump(len=3D16): [REMOVED]=0A=
wlan0: WPA: Installing GTK to the driver (keyidx=3D1 tx=3D0 len=3D16)=0A=
WPA: RSC - hexdump(len=3D6): 2d 01 00 00 00 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10082f30 =
key_idx=3D1 set_tx=3D0 seq_len=3D6 key_len=3D16=0A=
   broadcast key=0A=
wlan0: WPA: Key negotiation completed with 00:1b:b1:58:f6:dd [PTK=3DCCMP =
GTK=3DCCMP]=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: Cancelling authentication timeout=0A=
wlan0: State: GROUP_HANDSHAKE -> COMPLETED=0A=
wlan0: CTRL-EVENT-CONNECTED - Connection to 00:1b:b1:58:f6:dd completed =
(reauth) [id=3D0 id_str=3D]=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D6=0A=
EAPOL: External notification - portValid=3D1=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
EAPOL: startWhen --> 0=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
EAPOL: idleWhile --> 0=0A=
EAPOL: disable timer tick=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D131): 02 03 00 7f 02 13 82 00 10 00 00 00 00 00 =
00 00 05 04 cd 84 34 06 c3 b5 13 d0 06 78 7d c4 70 8b d9 bd dc 16 3b c1 =
15 b8 21 ab 45 14 5b d2 91 5f 29 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1a ab ee 56 84 =
2c e7 f4 7e c7 f8 a3 2c 56 d1 78 00 20 f4 e2 09 f9 c6 bc da 3a 93 8b c9 =
fd 3e 70 51 6d 8b cd 68 9b 1c 34 9d ef 58 ed 87 fe 89 17 73 f3=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D127=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x1382 (ver=3D2 keyidx=3D0 rsvd=3D0 Group Ack MIC =
Secure Encr)=0A=
wlan0:   key_length=3D16 key_data_length=3D32=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 05=0A=
  key_nonce - hexdump(len=3D32): 04 cd 84 34 06 c3 b5 13 d0 06 78 7d c4 =
70 8b d9 bd dc 16 3b c1 15 b8 21 ab 45 14 5b d2 91 5f 29=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): 1a ab ee 56 84 2c e7 f4 7e c7 f8 a3 2c 56 =
d1 78=0A=
WPA: RX EAPOL-Key - hexdump(len=3D131): 02 03 00 7f 02 13 82 00 10 00 00 =
00 00 00 00 00 05 04 cd 84 34 06 c3 b5 13 d0 06 78 7d c4 70 8b d9 bd dc =
16 3b c1 15 b8 21 ab 45 14 5b d2 91 5f 29 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1a ab =
ee 56 84 2c e7 f4 7e c7 f8 a3 2c 56 d1 78 00 20 f4 e2 09 f9 c6 bc da 3a =
93 8b c9 fd 3e 70 51 6d 8b cd 68 9b 1c 34 9d ef 58 ed 87 fe 89 17 73 f3=0A=
RSN: encrypted key data - hexdump(len=3D32): f4 e2 09 f9 c6 bc da 3a 93 =
8b c9 fd 3e 70 51 6d 8b cd 68 9b 1c 34 9d ef 58 ed 87 fe 89 17 73 f3=0A=
WPA: decrypted EAPOL-Key key data - hexdump(len=3D24): [REMOVED]=0A=
wlan0: WPA: RX message 1 of Group Key Handshake from 00:1b:b1:58:f6:dd =
(ver=3D2)=0A=
RSN: msg 1/2 key data - hexdump(len=3D24): dd 16 00 0f ac 01 02 00 3d d9 =
35 4f 35 e6 81 0b 4c 56 d6 1b e3 8c f1 bc=0A=
WPA: GTK in EAPOL-Key - hexdump(len=3D24): [REMOVED]=0A=
RSN: received GTK in group key handshake - hexdump(len=3D18): 02 00 3d =
d9 35 4f 35 e6 81 0b 4c 56 d6 1b e3 8c f1 bc=0A=
wlan0: State: COMPLETED -> GROUP_HANDSHAKE=0A=
WPA: Group Key - hexdump(len=3D16): [REMOVED]=0A=
wlan0: WPA: Installing GTK to the driver (keyidx=3D2 tx=3D0 len=3D16)=0A=
WPA: RSC - hexdump(len=3D6): 00 00 00 00 00 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10082f30 =
key_idx=3D2 set_tx=3D0 seq_len=3D6 key_len=3D16=0A=
   broadcast key=0A=
wlan0: WPA: Sending EAPOL-Key 2/2=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): 28 80 24 27 74 34 6a 17 fe d7 =
1e 9f 99 d6 83 55=0A=
WPA: TX EAPOL-Key - hexdump(len=3D99): 01 03 00 5f 02 03 02 00 00 00 00 =
00 00 00 00 00 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 28 80 =
24 27 74 34 6a 17 fe d7 1e 9f 99 d6 83 55 00 00=0A=
wlan0: WPA: Group rekeying completed with 00:1b:b1:58:f6:dd [GTK=3DCCMP]=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: Cancelling authentication timeout=0A=
wlan0: State: GROUP_HANDSHAKE -> COMPLETED=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
wlan0: BSS: Expire BSS 2 due to age=0A=
wlan0: BSS: Remove id 2 BSSID 00:0e:8e:0a:3a:a1 SSID =
'acksyssalledereunion'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 3 due to age=0A=
wlan0: BSS: Remove id 3 BSSID f4:ca:e5:d2:12:2e SSID 'FreeWifi_secure'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 4 due to age=0A=
wlan0: BSS: Remove id 4 BSSID 00:80:48:64:22:5a SSID 'az12@bjKm'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 5 due to age=0A=
wlan0: BSS: Remove id 5 BSSID 00:19:70:32:b3:a2 SSID 'Livebox-cdd8'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 6 due to age=0A=
wlan0: BSS: Remove id 6 BSSID 00:1c:f0:08:cf:10 SSID 'MDY'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 7 due to age=0A=
wlan0: BSS: Remove id 7 BSSID f4:ca:e5:d2:12:2c SSID 'lemezo'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 8 due to age=0A=
wlan0: BSS: Remove id 8 BSSID 00:1b:b1:58:f6:cb SSID 'acksys'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 9 due to age=0A=
wlan0: BSS: Remove id 9 BSSID 90:a4:de:21:4e:f7 SSID 'acksys'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 10 due to age=0A=
wlan0: BSS: Remove id 10 BSSID 90:a4:de:21:4f:11 SSID 'PRO4500Z1'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 11 due to age=0A=
wlan0: BSS: Remove id 11 BSSID 00:1b:b1:58:f6:05 SSID 'acksys'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: BSS: Expire BSS 12 due to age=0A=
wlan0: BSS: Remove id 12 BSSID f4:ca:e5:d2:12:2d SSID 'FreeWifi'=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D22):=0A=
     52 4f 41 4d 20 39 30 3a 41 34 3a 44 45 3a 41 41   ROAM 90:A4:DE:AA=0A=
     3a 34 32 3a 39 34                                 :42:94          =0A=
CTRL_IFACE ROAM 90:a4:de:aa:42:94=0A=
wlan0: Request association: reassociate: 1  selected: 90:a4:de:aa:42:94  =
bssid: 00:1b:b1:58:f6:dd  pending: 00:00:00:00:00:00  wpa_state: =
COMPLETED=0A=
wlan0: Automatic auth_alg selection: 0x1=0A=
RSN: PMKSA cache search - network_ctx=3D0x10427908 try_opportunistic=3D0=0A=
RSN: Search for BSSID 90:a4:de:aa:42:94=0A=
RSN: PMKSA cache entry found - PMKID - hexdump(len=3D16): 11 1c 5b ea 4c =
1f 0d 2d da d6 00 51 a8 fe 6b 3f=0A=
RSN: Trying to use cached PMKSA=0A=
wlan0: RSN: using IEEE 802.11i/D9.0=0A=
wlan0: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 1 =
proto 2=0A=
wlan0: WPA: clearing AP WPA IE=0A=
WPA: set AP RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 00 00 =
0f ac 04 01 00 00 0f ac 01 0c 00=0A=
wlan0: WPA: using GTK CCMP=0A=
wlan0: WPA: using PTK CCMP=0A=
wlan0: WPA: using KEY_MGMT 802.1X=0A=
wlan0: WPA: not using MGMT group cipher=0A=
WPA: Set own WPA IE default - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 11 1c 5b ea 4c 1f 0d 2d =
da d6 00 51 a8 fe 6b 3f=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
wlan0: Cancelling scan request=0A=
wlan0: SME: Trying to authenticate with 90:a4:de:aa:42:94 =
(SSID=3D'cdtest' freq=3D5660 MHz)=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D4 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D5 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D0x1042a680 =
key_idx=3D0 set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
   addr=3D90:a4:de:aa:42:94=0A=
wlan0: State: COMPLETED -> AUTHENTICATING=0A=
EAPOL: External notification - EAP success=3D0=0A=
EAPOL: External notification - EAP fail=3D0=0A=
EAPOL: External notification - portControl=3DAuto=0A=
nl80211: Authenticate (ifindex=3D5)=0A=
  * bssid=3D90:a4:de:aa:42:94=0A=
  * freq=3D5660=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D0): [NULL]=0A=
  * Auth Type 0=0A=
wlan0: nl80211: MLME command failed (auth): ret=3D-2 (No such file or =
directory)=0A=
nl80211: Trigger single channel scan to refresh cfg80211 BSS entry=0A=
nl80211: Scan SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
nl80211: Scan frequency 5660 MHz=0A=
Scan requested (ret=3D0) - scan timeout 30 seconds=0A=
nl80211: Event message available=0A=
nl80211: Scan trigger=0A=
nl80211: Event message available=0A=
nl80211: Beacon loss event=0A=
wlan0: Event BEACON_LOSS (49) received=0A=
nl80211: Event message available=0A=
nl80211: New scan results available=0A=
nl80211: Scan results for missing cfg80211 BSS entry=0A=
nl80211: Try to authenticate again=0A=
nl80211: Authenticate (ifindex=3D5)=0A=
  * bssid=3D90:a4:de:aa:42:94=0A=
  * freq=3D5660=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D0): [NULL]=0A=
  * Auth Type 0=0A=
nl80211: Authentication request send successfully=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x1003 ([UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: Delete station 00:1b:b1:58:f6:dd=0A=
nl80211: Event message available=0A=
nl80211: New station 90:a4:de:aa:42:94=0A=
nl80211: Event message available=0A=
nl80211: MLME event 37=0A=
nl80211: MLME event frame - hexdump(len=3D30): b0 00 3c 00 90 a4 de 21 =
4f 53 90 a4 de aa 42 94 90 a4 de aa 42 94 20 79 00 00 02 00 00 00=0A=
wlan0: Event AUTH (11) received=0A=
wlan0: SME: Authentication response: peer=3D90:a4:de:aa:42:94 =
auth_type=3D0 status_code=3D0=0A=
SME: Authentication response IEs - hexdump(len=3D0): [NULL]=0A=
wlan0: Trying to associate with 90:a4:de:aa:42:94 (SSID=3D'cdtest' =
freq=3D5660 MHz)=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: State: AUTHENTICATING -> ASSOCIATING=0A=
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
WPA: set own WPA/RSN IE - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 11 1c 5b ea 4c 1f 0d 2d da =
d6 00 51 a8 fe 6b 3f=0A=
nl80211: Associate (ifindex=3D5)=0A=
  * bssid=3D90:a4:de:aa:42:94=0A=
  * freq=3D5660=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 =
01 00 00 0f ac 01 00 00 01 00 11 1c 5b ea 4c 1f 0d 2d da d6 00 51 a8 fe =
6b 3f=0A=
  * pairwise=3D0xfac04=0A=
  * group=3D0xfac04=0A=
  * prev_bssid=3D00:1b:b1:58:f6:dd=0A=
nl80211: Association request send successfully=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: MLME event 38=0A=
nl80211: MLME event frame - hexdump(len=3D66): 30 00 3c 00 90 a4 de 21 =
4f 53 90 a4 de aa 42 94 90 a4 de aa 42 94 30 79 11 00 00 00 01 c0 01 08 =
8c 12 98 24 b0 48 60 6c dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 =
00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: Event ASSOC (0) received=0A=
wlan0: Association info event=0A=
resp_ies - hexdump(len=3D36): 01 08 8c 12 98 24 b0 48 60 6c dd 18 00 50 =
f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: freq=3D5660 MHz=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
Operating frequency changed from 5680 to 5660 MHz=0A=
nl80211: Associated on 5660 MHz=0A=
nl80211: Associated with 90:a4:de:aa:42:94=0A=
nl80211: Received scan results (2 BSSes)=0A=
nl80211: Scan results indicate BSS status with 90:a4:de:aa:42:94 as =
associated=0A=
wlan0: BSS: Start scan result update 4=0A=
wlan0: State: ASSOCIATING -> ASSOCIATED=0A=
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
wlan0: Associated to a new BSS: BSSID=3D90:a4:de:aa:42:94=0A=
wlan0: No keys have been configured - skip key clearing=0A=
wlan0: Associated with 90:a4:de:aa:42:94=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: WPA: Association event - clear replay counter=0A=
wlan0: WPA: Clear old PTK=0A=
EAPOL: External notification - portEnabled=3D0=0A=
EAPOL: SUPP_PAE entering state DISCONNECTED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: SUPP_BE entering state INITIALIZE=0A=
EAP: EAP entering state DISABLED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portValid=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portEnabled=3D1=0A=
EAPOL: SUPP_PAE entering state CONNECTING=0A=
EAPOL: enable timer tick=0A=
EAPOL: SUPP_BE entering state IDLE=0A=
EAP: EAP entering state INITIALIZE=0A=
EAP: maintaining EAP method data for fast reauthentication=0A=
EAP: EAP entering state IDLE=0A=
wlan0: Setting authentication timeout: 10 sec 0 usec=0A=
wlan0: Cancelling scan request=0A=
nl80211: Event message available=0A=
nl80211: Ignore connect event (cmd=3D46) when using userspace SME=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 =
00 00 01 dd 19 32 48 51 93 fb 35 a5 24 94 dc 28 0c ab 09 c9 a1 4d fd 3d =
f9 4c 95 13 8b 0a 76 fb 1a 07 d6 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 11 1c 5b ea 4c =
1f 0d 2d da d6 00 51 a8 fe 6b 3f=0A=
wlan0: Setting authentication timeout: 70 sec 0 usec=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D117=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x8a (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Ack)=0A=
wlan0:   key_length=3D16 key_data_length=3D22=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01=0A=
  key_nonce - hexdump(len=3D32): dd 19 32 48 51 93 fb 35 a5 24 94 dc 28 =
0c ab 09 c9 a1 4d fd 3d f9 4c 95 13 8b 0a 76 fb 1a 07 d6=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
WPA: RX EAPOL-Key - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 =
00 00 00 00 00 01 dd 19 32 48 51 93 fb 35 a5 24 94 dc 28 0c ab 09 c9 a1 =
4d fd 3d f9 4c 95 13 8b 0a 76 fb 1a 07 d6 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 11 1c =
5b ea 4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f=0A=
wlan0: State: ASSOCIATED -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 1 of 4-Way Handshake from 90:a4:de:aa:42:94 =
(ver=3D2)=0A=
RSN: msg 1/4 key data - hexdump(len=3D22): dd 14 00 0f ac 04 11 1c 5b ea =
4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f=0A=
WPA: PMKID in EAPOL-Key - hexdump(len=3D22): dd 14 00 0f ac 04 11 1c 5b =
ea 4c 1f 0d 2d da d6 00 51 a8 fe 6b 3f=0A=
RSN: PMKID from Authenticator - hexdump(len=3D16): 11 1c 5b ea 4c 1f 0d =
2d da d6 00 51 a8 fe 6b 3f=0A=
RSN: matched PMKID - hexdump(len=3D16): 11 1c 5b ea 4c 1f 0d 2d da d6 00 =
51 a8 fe 6b 3f=0A=
RSN: PMK from PMKSA cache - hexdump(len=3D32): [REMOVED]=0A=
EAPOL: PMKSA caching was used - skip EAPOL=0A=
EAPOL: Supplicant port status: Authorized=0A=
Get randomness: len=3D32 entropy=3D1=0A=
WPA: Renewed SNonce - hexdump(len=3D32): 96 e5 4e 80 cb 95 53 c9 85 12 =
dd 14 97 d9 8b de 9d 10 60 9c 9d c6 b3 50 58 1c b7 47 2a d7 f6 d5=0A=
WPA: PTK derivation - A1=3D90:a4:de:21:4f:53 A2=3D90:a4:de:aa:42:94=0A=
WPA: Nonce1 - hexdump(len=3D32): 96 e5 4e 80 cb 95 53 c9 85 12 dd 14 97 =
d9 8b de 9d 10 60 9c 9d c6 b3 50 58 1c b7 47 2a d7 f6 d5=0A=
WPA: Nonce2 - hexdump(len=3D32): dd 19 32 48 51 93 fb 35 a5 24 94 dc 28 =
0c ab 09 c9 a1 4d fd 3d f9 4c 95 13 8b 0a 76 fb 1a 07 d6=0A=
WPA: PMK - hexdump(len=3D32): [REMOVED]=0A=
WPA: PTK - hexdump(len=3D48): [REMOVED]=0A=
WPA: WPA IE for msg 2/4 - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 11 1c 5b ea 4c 1f 0d 2d da =
d6 00 51 a8 fe 6b 3f=0A=
WPA: Replay Counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01=0A=
wlan0: WPA: Sending EAPOL-Key 2/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): fb be 41 a4 aa ca a4 ea 56 82 =
67 9f ec 94 5c 43=0A=
WPA: TX EAPOL-Key - hexdump(len=3D139): 01 03 00 87 02 01 0a 00 00 00 00 =
00 00 00 00 00 01 96 e5 4e 80 cb 95 53 c9 85 12 dd 14 97 d9 8b de 9d 10 =
60 9c 9d c6 b3 50 58 1c b7 47 2a d7 f6 d5 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fb be =
41 a4 aa ca a4 ea 56 82 67 9f ec 94 5c 43 00 28 30 26 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 11 1c 5b ea 4c 1f 0d 2d =
da d6 00 51 a8 fe 6b 3f=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94 to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 90:a4:de:aa:42:94=0A=
RX EAPOL - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 =
00 00 02 dd 19 32 48 51 93 fb 35 a5 24 94 dc 28 0c ab 09 c9 a1 4d fd 3d =
f9 4c 95 13 8b 0a 76 fb 1a 07 d6 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1b 06 e1 db 7b =
5e 45 bc 28 be 31 b9 1a e3 35 66 00 38 df b9 21 5e 7b 6a ab 2b f4 a1 61 =
29 b4 36 47 e8 ca 95 77 e1 f6 2b 5b cf b2 98 91 e3 7d d0 ec 9c aa da 8f =
07 d2 4a 72 22 25 7c 31 33 78 5e 45 41 7d 09 55 22 ca 01 9f f5=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D151=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x13ca (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Install =
Ack MIC Secure Encr)=0A=
wlan0:   key_length=3D16 key_data_length=3D56=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 02=0A=
  key_nonce - hexdump(len=3D32): dd 19 32 48 51 93 fb 35 a5 24 94 dc 28 =
0c ab 09 c9 a1 4d fd 3d f9 4c 95 13 8b 0a 76 fb 1a 07 d6=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): 1b 06 e1 db 7b 5e 45 bc 28 be 31 b9 1a e3 =
35 66=0A=
WPA: RX EAPOL-Key - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 =
00 00 00 00 00 02 dd 19 32 48 51 93 fb 35 a5 24 94 dc 28 0c ab 09 c9 a1 =
4d fd 3d f9 4c 95 13 8b 0a 76 fb 1a 07 d6 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1b 06 =
e1 db 7b 5e 45 bc 28 be 31 b9 1a e3 35 66 00 38 df b9 21 5e 7b 6a ab 2b =
f4 a1 61 29 b4 36 47 e8 ca 95 77 e1 f6 2b 5b cf b2 98 91 e3 7d d0 ec 9c =
aa da 8f 07 d2 4a 72 22 25 7c 31 33 78 5e 45 41 7d 09 55 22 ca 01 9f f5=0A=
RSN: encrypted key data - hexdump(len=3D56): df b9 21 5e 7b 6a ab 2b f4 =
a1 61 29 b4 36 47 e8 ca 95 77 e1 f6 2b 5b cf b2 98 91 e3 7d d0 ec 9c aa =
da 8f 07 d2 4a 72 22 25 7c 31 33 78 5e 45 41 7d 09 55 22 ca 01 9f f5=0A=
WPA: decrypted EAPOL-Key key data - hexdump(len=3D48): [REMOVED]=0A=
wlan0: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 3 of 4-Way Handshake from 90:a4:de:aa:42:94 =
(ver=3D2)=0A=
WPA: IE KeyData - hexdump(len=3D48): 30 14 01 00 00 0f ac 04 01 00 00 0f =
ac 04 01 00 00 0f ac 01 0c 00 dd 16 00 0f ac 01 02 00 c4 3b d1 4a 78 a6 =
c9 2f e0 ac 67 73 b3 44 ee 2b dd 00=0A=
WPA: RSN IE in EAPOL-Key - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 0c 00=0A=
WPA: GTK in EAPOL-Key - hexdump(len=3D24): [REMOVED]=0A=
wlan0: WPA: Sending EAPOL-Key 4/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): af c7 26 83 0a 61 4d 19 b4 ea =
f2 de a9 cb 07 69=0A=
WPA: TX EAPOL-Key - hexdump(len=3D99): 01 03 00 5f 02 03 0a 00 00 00 00 =
00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 af c7 =
26 83 0a 61 4d 19 b4 ea f2 de a9 cb 07 69 00 00=0A=
wlan0: WPA: Installing PTK to the driver=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10426f28 =
key_idx=3D0 set_tx=3D1 seq_len=3D6 key_len=3D16=0A=
   addr=3D90:a4:de:aa:42:94=0A=
EAPOL: External notification - portValid=3D1=0A=
wlan0: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE=0A=
RSN: received GTK in pairwise handshake - hexdump(len=3D18): [REMOVED]=0A=
WPA: Group Key - hexdump(len=3D16): [REMOVED]=0A=
wlan0: WPA: Installing GTK to the driver (keyidx=3D2 tx=3D0 len=3D16)=0A=
WPA: RSC - hexdump(len=3D6): 00 00 00 00 00 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10082f30 =
key_idx=3D2 set_tx=3D0 seq_len=3D6 key_len=3D16=0A=
   broadcast key=0A=
wlan0: WPA: Key negotiation completed with 90:a4:de:aa:42:94 [PTK=3DCCMP =
GTK=3DCCMP]=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: Cancelling authentication timeout=0A=
wlan0: State: GROUP_HANDSHAKE -> COMPLETED=0A=
wlan0: CTRL-EVENT-CONNECTED - Connection to 90:a4:de:aa:42:94 completed =
(reauth) [id=3D0 id_str=3D]=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D6=0A=
EAPOL: External notification - portValid=3D1=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
EAPOL: startWhen --> 0=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D22):=0A=
     52 4f 41 4d 20 30 30 3a 31 42 3a 42 31 3a 35 38   ROAM 00:1B:B1:58=0A=
     3a 46 36 3a 44 44                                 :F6:DD          =0A=
CTRL_IFACE ROAM 00:1b:b1:58:f6:dd=0A=
wlan0: Request association: reassociate: 1  selected: 00:1b:b1:58:f6:dd  =
bssid: 90:a4:de:aa:42:94  pending: 00:00:00:00:00:00  wpa_state: =
COMPLETED=0A=
wlan0: Automatic auth_alg selection: 0x1=0A=
RSN: PMKSA cache search - network_ctx=3D0x10427908 try_opportunistic=3D0=0A=
RSN: Search for BSSID 00:1b:b1:58:f6:dd=0A=
RSN: PMKSA cache entry found - PMKID - hexdump(len=3D16): d5 64 6e 8a ac =
6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
RSN: Trying to use cached PMKSA=0A=
wlan0: RSN: using IEEE 802.11i/D9.0=0A=
wlan0: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 1 =
proto 2=0A=
wlan0: WPA: clearing AP WPA IE=0A=
WPA: set AP RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 00 00 =
0f ac 04 01 00 00 0f ac 01 0c 00=0A=
wlan0: WPA: using GTK CCMP=0A=
wlan0: WPA: using PTK CCMP=0A=
wlan0: WPA: using KEY_MGMT 802.1X=0A=
wlan0: WPA: not using MGMT group cipher=0A=
WPA: Set own WPA IE default - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 =
1d e0 2d e8 0c 36 d4 a5=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
wlan0: Cancelling scan request=0A=
wlan0: SME: Trying to authenticate with 00:1b:b1:58:f6:dd =
(SSID=3D'cdtest' freq=3D5680 MHz)=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D4 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D5 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D0x1042d058 =
key_idx=3D0 set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
   addr=3D00:1b:b1:58:f6:dd=0A=
wlan0: State: COMPLETED -> AUTHENTICATING=0A=
EAPOL: External notification - EAP success=3D0=0A=
EAPOL: External notification - EAP fail=3D0=0A=
EAPOL: External notification - portControl=3DAuto=0A=
nl80211: Authenticate (ifindex=3D5)=0A=
  * bssid=3D00:1b:b1:58:f6:dd=0A=
  * freq=3D5680=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D0): [NULL]=0A=
  * Auth Type 0=0A=
nl80211: Authentication request send successfully=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x1003 ([UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: Delete station 90:a4:de:aa:42:94=0A=
nl80211: Event message available=0A=
nl80211: New station 00:1b:b1:58:f6:dd=0A=
nl80211: Event message available=0A=
nl80211: MLME event 37=0A=
nl80211: MLME event frame - hexdump(len=3D30): b0 00 3c 00 90 a4 de 21 =
4f 53 00 1b b1 58 f6 dd 00 1b b1 58 f6 dd f0 91 00 00 02 00 00 00=0A=
wlan0: Event AUTH (11) received=0A=
wlan0: SME: Authentication response: peer=3D00:1b:b1:58:f6:dd =
auth_type=3D0 status_code=3D0=0A=
SME: Authentication response IEs - hexdump(len=3D0): [NULL]=0A=
wlan0: Trying to associate with 00:1b:b1:58:f6:dd (SSID=3D'cdtest' =
freq=3D5680 MHz)=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: State: AUTHENTICATING -> ASSOCIATING=0A=
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
WPA: set own WPA/RSN IE - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 1d =
e0 2d e8 0c 36 d4 a5=0A=
nl80211: Associate (ifindex=3D5)=0A=
  * bssid=3D00:1b:b1:58:f6:dd=0A=
  * freq=3D5680=0A=
  * SSID - hexdump_ascii(len=3D6):=0A=
     63 64 74 65 73 74                                 cdtest          =0A=
  * IEs - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 =
01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 1d e0 2d e8 0c 36 =
d4 a5=0A=
  * pairwise=3D0xfac04=0A=
  * group=3D0xfac04=0A=
  * prev_bssid=3D90:a4:de:aa:42:94=0A=
nl80211: Association request send successfully=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
nl80211: Event message available=0A=
nl80211: MLME event 38=0A=
nl80211: MLME event frame - hexdump(len=3D66): 30 00 3c 00 90 a4 de 21 =
4f 53 00 1b b1 58 f6 dd 00 1b b1 58 f6 dd 00 92 11 00 00 00 01 c0 01 08 =
8c 12 98 24 b0 48 60 6c dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 =
00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: Event ASSOC (0) received=0A=
wlan0: Association info event=0A=
resp_ies - hexdump(len=3D36): 01 08 8c 12 98 24 b0 48 60 6c dd 18 00 50 =
f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00=0A=
wlan0: freq=3D5680 MHz=0A=
FT: Stored MDIE and FTIE from (Re)Association Response - =
hexdump(len=3D0):=0A=
Operating frequency changed from 5660 to 5680 MHz=0A=
nl80211: Associated on 5680 MHz=0A=
nl80211: Associated with 00:1b:b1:58:f6:dd=0A=
nl80211: Received scan results (2 BSSes)=0A=
nl80211: Scan results indicate BSS status with 00:1b:b1:58:f6:dd as =
associated=0A=
wlan0: BSS: Start scan result update 5=0A=
wlan0: State: ASSOCIATING -> ASSOCIATED=0A=
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
wlan0: Associated to a new BSS: BSSID=3D00:1b:b1:58:f6:dd=0A=
wlan0: No keys have been configured - skip key clearing=0A=
wlan0: Associated with 00:1b:b1:58:f6:dd=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: WPA: Association event - clear replay counter=0A=
wlan0: WPA: Clear old PTK=0A=
EAPOL: External notification - portEnabled=3D0=0A=
EAPOL: SUPP_PAE entering state DISCONNECTED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: SUPP_BE entering state INITIALIZE=0A=
EAP: EAP entering state DISABLED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portValid=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portEnabled=3D1=0A=
EAPOL: SUPP_PAE entering state CONNECTING=0A=
EAPOL: SUPP_BE entering state IDLE=0A=
EAP: EAP entering state INITIALIZE=0A=
EAP: maintaining EAP method data for fast reauthentication=0A=
EAP: EAP entering state IDLE=0A=
wlan0: Setting authentication timeout: 10 sec 0 usec=0A=
wlan0: Cancelling scan request=0A=
nl80211: Event message available=0A=
nl80211: Ignore connect event (cmd=3D46) when using userspace SME=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 =
00 00 06 b8 36 83 48 f1 8c 35 d0 e0 bd 2f de 97 0d 78 56 19 b7 4c fa ca =
b6 86 9a 61 80 0e 7c 3f 10 12 c3 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 d5 64 6e 8a ac =
6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
wlan0: Setting authentication timeout: 70 sec 0 usec=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D117=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x8a (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Ack)=0A=
wlan0:   key_length=3D16 key_data_length=3D22=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 06=0A=
  key_nonce - hexdump(len=3D32): b8 36 83 48 f1 8c 35 d0 e0 bd 2f de 97 =
0d 78 56 19 b7 4c fa ca b6 86 9a 61 80 0e 7c 3f 10 12 c3=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
WPA: RX EAPOL-Key - hexdump(len=3D121): 02 03 00 75 02 00 8a 00 10 00 00 =
00 00 00 00 00 06 b8 36 83 48 f1 8c 35 d0 e0 bd 2f de 97 0d 78 56 19 b7 =
4c fa ca b6 86 9a 61 80 0e 7c 3f 10 12 c3 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 d5 64 =
6e 8a ac 6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
wlan0: State: ASSOCIATED -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 1 of 4-Way Handshake from 00:1b:b1:58:f6:dd =
(ver=3D2)=0A=
RSN: msg 1/4 key data - hexdump(len=3D22): dd 14 00 0f ac 04 d5 64 6e 8a =
ac 6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
WPA: PMKID in EAPOL-Key - hexdump(len=3D22): dd 14 00 0f ac 04 d5 64 6e =
8a ac 6c db b7 1d e0 2d e8 0c 36 d4 a5=0A=
RSN: PMKID from Authenticator - hexdump(len=3D16): d5 64 6e 8a ac 6c db =
b7 1d e0 2d e8 0c 36 d4 a5=0A=
RSN: matched PMKID - hexdump(len=3D16): d5 64 6e 8a ac 6c db b7 1d e0 2d =
e8 0c 36 d4 a5=0A=
RSN: PMK from PMKSA cache - hexdump(len=3D32): [REMOVED]=0A=
EAPOL: PMKSA caching was used - skip EAPOL=0A=
EAPOL: Supplicant port status: Authorized=0A=
Get randomness: len=3D32 entropy=3D1=0A=
WPA: Renewed SNonce - hexdump(len=3D32): cb a9 6f a8 11 5e 71 64 a3 de =
1b 5b 20 df 86 a1 90 d4 8c 23 b8 80 ca d8 c7 1f 37 1b 70 0f 96 26=0A=
WPA: PTK derivation - A1=3D90:a4:de:21:4f:53 A2=3D00:1b:b1:58:f6:dd=0A=
WPA: Nonce1 - hexdump(len=3D32): cb a9 6f a8 11 5e 71 64 a3 de 1b 5b 20 =
df 86 a1 90 d4 8c 23 b8 80 ca d8 c7 1f 37 1b 70 0f 96 26=0A=
WPA: Nonce2 - hexdump(len=3D32): b8 36 83 48 f1 8c 35 d0 e0 bd 2f de 97 =
0d 78 56 19 b7 4c fa ca b6 86 9a 61 80 0e 7c 3f 10 12 c3=0A=
WPA: PMK - hexdump(len=3D32): [REMOVED]=0A=
WPA: PTK - hexdump(len=3D48): [REMOVED]=0A=
WPA: WPA IE for msg 2/4 - hexdump(len=3D40): 30 26 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 1d =
e0 2d e8 0c 36 d4 a5=0A=
WPA: Replay Counter - hexdump(len=3D8): 00 00 00 00 00 00 00 06=0A=
wlan0: WPA: Sending EAPOL-Key 2/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): be dd bd 8d e4 59 e4 68 16 c6 =
1a 55 fb d7 82 09=0A=
WPA: TX EAPOL-Key - hexdump(len=3D139): 01 03 00 87 02 01 0a 00 00 00 00 =
00 00 00 00 00 06 cb a9 6f a8 11 5e 71 64 a3 de 1b 5b 20 df 86 a1 90 d4 =
8c 23 b8 80 ca d8 c7 1f 37 1b 70 0f 96 26 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 be dd =
bd 8d e4 59 e4 68 16 c6 1a 55 fb d7 82 09 00 28 30 26 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 01 00 00 01 00 d5 64 6e 8a ac 6c db b7 =
1d e0 2d e8 0c 36 d4 a5=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd to 90:a4:de:21:4f:53 (bridge)=0A=
wlan0: RX EAPOL from 00:1b:b1:58:f6:dd=0A=
RX EAPOL - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 =
00 00 07 b8 36 83 48 f1 8c 35 d0 e0 bd 2f de 97 0d 78 56 19 b7 4c fa ca =
b6 86 9a 61 80 0e 7c 3f 10 12 c3 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff d9 29 b7 1f =
8e f1 79 14 c7 b9 72 49 41 7a 36 00 38 fe 93 44 e4 06 ce fe cf a6 f4 b5 =
a1 cf ec e5 ef 9b 2d 8b 4b dc cc f8 7a 9a 84 53 ab 9b 12 98 7e 85 a9 1c =
55 58 38 25 7f 88 9f 65 ea 69 c8 9f 08 6f 8a 24 e5 48 23 2f 26=0A=
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines=0A=
wlan0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D151=0A=
wlan0:   EAPOL-Key type=3D2=0A=
wlan0:   key_info 0x13ca (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Install =
Ack MIC Secure Encr)=0A=
wlan0:   key_length=3D16 key_data_length=3D56=0A=
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 07=0A=
  key_nonce - hexdump(len=3D32): b8 36 83 48 f1 8c 35 d0 e0 bd 2f de 97 =
0d 78 56 19 b7 4c fa ca b6 86 9a 61 80 0e 7c 3f 10 12 c3=0A=
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00=0A=
  key_rsc - hexdump(len=3D8): 01 00 00 00 00 00 00 00=0A=
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00=0A=
  key_mic - hexdump(len=3D16): ff d9 29 b7 1f 8e f1 79 14 c7 b9 72 49 41 =
7a 36=0A=
WPA: RX EAPOL-Key - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 =
00 00 00 00 00 07 b8 36 83 48 f1 8c 35 d0 e0 bd 2f de 97 0d 78 56 19 b7 =
4c fa ca b6 86 9a 61 80 0e 7c 3f 10 12 c3 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff d9 =
29 b7 1f 8e f1 79 14 c7 b9 72 49 41 7a 36 00 38 fe 93 44 e4 06 ce fe cf =
a6 f4 b5 a1 cf ec e5 ef 9b 2d 8b 4b dc cc f8 7a 9a 84 53 ab 9b 12 98 7e =
85 a9 1c 55 58 38 25 7f 88 9f 65 ea 69 c8 9f 08 6f 8a 24 e5 48 23 2f 26=0A=
RSN: encrypted key data - hexdump(len=3D56): fe 93 44 e4 06 ce fe cf a6 =
f4 b5 a1 cf ec e5 ef 9b 2d 8b 4b dc cc f8 7a 9a 84 53 ab 9b 12 98 7e 85 =
a9 1c 55 58 38 25 7f 88 9f 65 ea 69 c8 9f 08 6f 8a 24 e5 48 23 2f 26=0A=
WPA: decrypted EAPOL-Key key data - hexdump(len=3D48): [REMOVED]=0A=
wlan0: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE=0A=
wlan0: WPA: RX message 3 of 4-Way Handshake from 00:1b:b1:58:f6:dd =
(ver=3D2)=0A=
WPA: IE KeyData - hexdump(len=3D48): 30 14 01 00 00 0f ac 04 01 00 00 0f =
ac 04 01 00 00 0f ac 01 0c 00 dd 16 00 0f ac 01 02 00 3d d9 35 4f 35 e6 =
81 0b 4c 56 d6 1b e3 8c f1 bc dd 00=0A=
WPA: RSN IE in EAPOL-Key - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 01 0c 00=0A=
WPA: GTK in EAPOL-Key - hexdump(len=3D24): [REMOVED]=0A=
wlan0: WPA: Sending EAPOL-Key 4/4=0A=
WPA: KCK - hexdump(len=3D16): [REMOVED]=0A=
WPA: Derived Key MIC - hexdump(len=3D16): a9 fb f9 d2 78 15 45 22 eb 87 =
a3 a9 f1 9e 28 62=0A=
WPA: TX EAPOL-Key - hexdump(len=3D99): 01 03 00 5f 02 03 0a 00 00 00 00 =
00 00 00 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a9 fb =
f9 d2 78 15 45 22 eb 87 a3 a9 f1 9e 28 62 00 00=0A=
wlan0: WPA: Installing PTK to the driver=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10426f28 =
key_idx=3D0 set_tx=3D1 seq_len=3D6 key_len=3D16=0A=
   addr=3D00:1b:b1:58:f6:dd=0A=
EAPOL: External notification - portValid=3D1=0A=
wlan0: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE=0A=
RSN: received GTK in pairwise handshake - hexdump(len=3D18): [REMOVED]=0A=
WPA: Group Key - hexdump(len=3D16): [REMOVED]=0A=
wlan0: WPA: Installing GTK to the driver (keyidx=3D2 tx=3D0 len=3D16)=0A=
WPA: RSC - hexdump(len=3D6): 01 00 00 00 00 00=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D3 addr=3D0x10082f30 =
key_idx=3D2 set_tx=3D0 seq_len=3D6 key_len=3D16=0A=
   broadcast key=0A=
wlan0: WPA: Key negotiation completed with 00:1b:b1:58:f6:dd [PTK=3DCCMP =
GTK=3DCCMP]=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wlan0: Cancelling authentication timeout=0A=
wlan0: State: GROUP_HANDSHAKE -> COMPLETED=0A=
wlan0: CTRL-EVENT-CONNECTED - Connection to 00:1b:b1:58:f6:dd completed =
(reauth) [id=3D0 id_str=3D]=0A=
CTRL_IFACE monitor send - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 5f =
63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D6=0A=
EAPOL: External notification - portValid=3D1=0A=
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])=0A=
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added=0A=
nl80211: if_removed already cleared - ignore event=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
EAPOL: startWhen --> 0=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
CTRL_IFACE monitor detached - hexdump(len=3D21): 2f 74 6d 70 2f 77 70 61 =
5f 63 74 72 6c 5f 31 39 30 39 2d 32 00=0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
RX ctrl_iface - hexdump_ascii(len=3D4):=0A=
     77 6c 61 6e                                       wlan            =0A=
EAPOL: idleWhile --> 0=0A=
EAPOL: disable timer tick=0A=
wlan0: Removing interface wlan0=0A=
wpa_driver_nl80211_deauthenticate(addr=3D00:1b:b1:58:f6:dd =
reason_code=3D3)=0A=
wlan0: Event DEAUTH (12) received=0A=
wlan0: Deauthentication notification=0A=
wlan0:  * reason 3 (locally generated)=0A=
Deauthentication frame IE(s) - hexdump(len=3D0): [NULL]=0A=
wlan0: Auto connect enabled: try to reconnect (wps=3D0 wpa_state=3D9)=0A=
wlan0: Setting scan request: 0 sec 100000 usec=0A=
Added BSSID 00:1b:b1:58:f6:dd into blacklist=0A=
wlan0: Another BSS in this ESS has been seen; try it next=0A=
BSSID 00:1b:b1:58:f6:dd blacklist count incremented to 2=0A=
wlan0: Not rescheduling scan to ensure that specific SSID scans occur=0A=
wlan0: CTRL-EVENT-DISCONNECTED bssid=3D00:1b:b1:58:f6:dd reason=3D3 =
locally_generated=3D1=0A=
wlan0: Disconnect event - remove keys=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D4 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D(nil) key_idx=3D5 =
set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
wpa_driver_nl80211_set_key: ifindex=3D5 alg=3D0 addr=3D0x10426414 =
key_idx=3D0 set_tx=3D0 seq_len=3D0 key_len=3D0=0A=
   addr=3D00:1b:b1:58:f6:dd=0A=
wlan0: State: COMPLETED -> DISCONNECTED=0A=
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
EAPOL: External notification - portEnabled=3D0=0A=
EAPOL: SUPP_PAE entering state DISCONNECTED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: SUPP_BE entering state INITIALIZE=0A=
EAP: EAP entering state DISABLED=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portValid=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
wlan0: No keys have been configured - skip key clearing=0A=
wlan0: State: DISCONNECTED -> DISCONNECTED=0A=
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
EAPOL: External notification - portEnabled=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portValid=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
wlan0: No keys have been configured - skip key clearing=0A=
RSN: Flush PMKSA cache entry for 00:1b:b1:58:f6:dd=0A=
nl80211: Delete PMKID for 00:1b:b1:58:f6:dd=0A=
wlan0: RSN: removed current PMKSA entry=0A=
wlan0: No keys have been configured - skip key clearing=0A=
wlan0: State: DISCONNECTED -> DISCONNECTED=0A=
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)=0A=
netlink: Operstate: linkmode=3D-1, operstate=3D5=0A=
EAPOL: External notification - portEnabled=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
EAPOL: External notification - portValid=3D0=0A=
EAPOL: Supplicant port status: Unauthorized=0A=
wlan0: Not rescheduling scan to ensure that specific SSID scans occur=0A=
RSN: Flush PMKSA cache entry for 90:a4:de:aa:42:94=0A=
nl80211: Delete PMKID for 90:a4:de:aa:42:94=0A=
EAP: deinitialize previously used EAP method (0, TLS) at EAP deinit=0A=
ENGINE: engine deinit=0A=
Removed BSSID 00:1b:b1:58:f6:dd from blacklist (clear)=0A=
wlan0: BSS: Remove id 1 BSSID 90:a4:de:aa:42:94 SSID 'cdtest'=0A=
wlan0: BSS: Remove id 0 BSSID 00:1b:b1:58:f6:dd SSID 'cdtest'=0A=
wlan0: Cancelling scan request=0A=
wlan0: Cancelling authentication timeout=0A=
netlink: Operstate: linkmode=3D0, operstate=3D6=0A=
nl80211: Set mode ifindex 5 iftype 2 (STATION)=0A=
nl80211: Unsubscribe mgmt frames handle 0x10426ca0 (mode change)=0A=
wlan0: CTRL-EVENT-TERMINATING =0A=

------=_NextPart_000_01EA_01CDB2C7.67A86E60--

