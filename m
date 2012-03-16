Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60218 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031199Ab2CPUXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 16:23:21 -0400
Message-ID: <4F63A135.1060909@canonical.com> (sfid-20120316_212325_995320_06E3B575)
Date: Fri, 16 Mar 2012 16:23:17 -0400
From: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: mathieu-tl@ubuntu.com
Subject: Issues with IBSS/WPA being created unsecured IBSS
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB2F284866F26C35FA4328520"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB2F284866F26C35FA4328520
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Hi,

I'm trying to figure out how to fix WPA-secured IBSS; which appears to
be silently falling back to creating unsecured IBSS networks at the
kernel level (or IBSS/RSN really, if need be, as it seems to react
pretty much just the same, although I understand it's not supported by
all devices).

That bug has been initially reported at
https://bugs.launchpad.net/ubuntu/+source/network-manager/+bug/905748.

This has been tested on around version 3.2.11 (Ubuntu
3.2.0-18.29-generic 3.2.9); and observed on iwlwifi, iwl496, ath9k and
rt2800pci.

Wpasupplicant 0.7.3-6 appears to be creating the IBSS network just fine,
but running into an issue with the nl80211 layer:

mtrudel@gaea ~/Documents % sudo wpa_supplicant -dd -cwpa-adhoc.conf
-iwlan0 -Dnl80211
Initializing interface 'wlan0' conf 'wpa-adhoc.conf' driver 'nl80211'
ctrl_interface 'N/A' bridge 'N/A'
Configuration file 'wpa-adhoc.conf' ->
'/home/mtrudel/Documents/wpa-adhoc.conf'
Reading configuration file '/home/mtrudel/Documents/wpa-adhoc.conf'
ap_scan=3D2
Line: 2 - start of a new network block
ssid - hexdump_ascii(len=3D10):
     74 65 73 74 20 61 64 68 6f 63                     test adhoc
mode=3D1 (0x1)
frequency=3D2412 (0x96c)
proto: 0x1
key_mgmt: 0x10
pairwise: 0x1
group: 0x8
PSK (ASCII passphrase) - hexdump_ascii(len=3D10): [REMOVED]
PSK (from passphrase) - hexdump(len=3D32): [REMOVED]
Priority group 0
   id=3D0 ssid=3D'test adhoc'
netlink: Operstate: linkmode=3D1, operstate=3D5
Own MAC address: ac:72:89:85:33:38
wpa_driver_nl80211_set_key: ifindex=3D3 alg=3D0 addr=3D0x495e2c key_idx=3D=
0
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D3 alg=3D0 addr=3D0x495e2c key_idx=3D=
1
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D3 alg=3D0 addr=3D0x495e2c key_idx=3D=
2
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D3 alg=3D0 addr=3D0x495e2c key_idx=3D=
3
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D3 alg=3D0 addr=3D0x495e2c key_idx=3D=
4
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D3 alg=3D0 addr=3D0x495e2c key_idx=3D=
5
set_tx=3D0 seq_len=3D0 key_len=3D0
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=3D16): 16 9c 02 d6 0f ea 57
44 bc 3b 45 1a 38 3d b8 9d
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Added interface wlan0
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
State: DISCONNECTED -> SCANNING
Trying to associate with SSID 'test adhoc'
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: No WPA/RSN IE available from association info
WPA: Set cipher suites based on configuration
WPA: Selected cipher suites: group 8 pairwise 1 key_mgmt 16 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK NONE
WPA: using KEY_MGMT WPA-NONE
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=3D24): dd 16 00 50 f2 01 01 00
00 50 f2 02 01 00 00 50 f2 00 01 00 00 50 f2 00
No keys have been configured - skip key clearing
wpa_driver_nl80211_set_key: ifindex=3D3 alg=3D2 addr=3D0x495e2c key_idx=3D=
0
set_tx=3D1 seq_len=3D6 key_len=3D32
nl80211: set_key failed; err=3D-67 Link has been severed)
State: SCANNING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
nl80211: Join IBSS (ifindex=3D3)
  * SSID - hexdump_ascii(len=3D10):
     74 65 73 74 20 61 64 68 6f 63                     test adhoc
  * freq=3D2412
  * Extra IEs for Beacon/Probe Response frames - hexdump(len=3D24): dd 16=

00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 00 01 00 00 50 f2 00
nl80211: Join IBSS request sent successfully
wpa_driver_nl80211_set_key: ifindex=3D3 alg=3D2 addr=3D0x495e2c key_idx=3D=
0
set_tx=3D1 seq_len=3D6 key_len=3D32
nl80211: set_key failed; err=3D-67 Link has been severed)
Cancelling authentication timeout
State: ASSOCIATING -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:00:00:00:00:00 completed (auth)
[id=3D-1 id_str=3D]
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
netlink: Operstate: linkmode=3D-1, operstate=3D6
EAPOL: External notification - EAP success=3D0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=3D0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=3DForceAuthorized
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11003 ([UP][LOWER_UP])
netlink: Operstate: linkmode=3D-1, operstate=3D6
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
nl80211: Event message available
nl80211: IBSS 52:c8:0d:3f:f1:0f joined
State: COMPLETED -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
Associated to a new BSS: BSSID=3D52:c8:0d:3f:f1:0f
Select network based on association information
Network configuration found for the current AP
WPA: Using WPA IE from AssocReq to set cipher suites
WPA: Selected cipher suites: group 8 pairwise 1 key_mgmt 16 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK NONE
WPA: using KEY_MGMT WPA-NONE
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=3D24): dd 16 00 50 f2 01 01 00
00 50 f2 02 01 00 00 50 f2 00 01 00 00 50 f2 00
EAPOL: External notification - EAP success=3D0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=3D0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=3DForceAuthorized
EAPOL: Supplicant port status: Unauthorized
Associated with 52:c8:0d:3f:f1:0f
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=3D0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=3D1
EAPOL: SUPP_PAE entering state S_FORCE_AUTH
EAPOL: Supplicant port status: Authorized
EAPOL: SUPP_BE entering state IDLE
Cancelling authentication timeout
State: ASSOCIATED -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 52:c8:0d:3f:f1:0f completed
(reauth) [id=3D0 id_str=3D]
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
netlink: Operstate: linkmode=3D-1, operstate=3D6
Cancelling scan request
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11003 ([UP][LOWER_UP])
netlink: Operstate: linkmode=3D-1, operstate=3D6
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (12 BSSes)
BSS: Start scan result update 1
BSS: Add new id 0 BSSID 00:22:90:50:1a:50 SSID 'Ubuntu'
BSS: Add new id 1 BSSID c0:c1:c0:87:9e:cd SSID 'ubuntu-cert-n-wpa'
BSS: Add new id 2 BSSID 00:26:0b:70:57:d0 SSID 'UbuntuConf'
BSS: Add new id 3 BSSID 00:1d:7e:5a:54:b2 SSID 'GVM'
BSS: Add new id 4 BSSID e0:cb:4e:ad:ef:97 SSID 'ubity'
BSS: Add new id 5 BSSID 4e:75:8f:95:91:12 SSID 'adhoc'
BSS: Add new id 6 BSSID 68:7f:74:01:51:52 SSID 'ubity_visiteur'
BSS: Add new id 7 BSSID 00:1e:e5:05:94:96 SSID 'TechWIRE'
BSS: Add new id 8 BSSID 00:14:bf:21:73:35 SSID ''
BSS: Add new id 9 BSSID e0:46:9a:69:b1:34 SSID 'LVLAPP03'
BSS: Add new id 10 BSSID 52:c8:0d:3f:f1:0f SSID 'test adhoc'
BSS: Add new id 11 BSSID c0:c1:c0:7a:97:f3 SSID 'ubuntu-cert-n-open'
New scan results available
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
nl80211: Ignored unknown event (cmd=3D19)

As a side note, I've tried the same bit in wext after noticing the
nl80211 error, but I'm getting a similar error:

wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
ioctl[SIOCSIWGENIE]: Operation not supported
wpa_driver_wext_set_psk
Association request to the driver failed
wpa_driver_wext_set_key: alg=3D2 key_idx=3D0 set_tx=3D1 seq_len=3D6 key_l=
en=3D32
Cancelling authentication timeout
State: ASSOCIATING -> COMPLETED


At this point, 'iw dev wlan0 scan' lists the network as created, IBSS,
and using WPA version 1:

mtrudel@gaea ~/Documents % sudo iw dev wlan0 scan
[...]
BSS 52:c8:0d:3f:f1:0f (on wlan0) -- joined
	freq: 2412
	beacon interval: 100
	capability: IBSS (0x0002)
	signal: 0.00 dBm
	last seen: 24888 ms ago
	SSID: test adhoc
	Supported rates: 1.0* 2.0 5.5 11.0 6.0 9.0 12.0 18.0
	DS Parameter set: channel 1
	Extended supported rates: 24.0 36.0 48.0 54.0
	WPA:	 * Version: 1
		 * Group cipher: TKIP
		 * Pairwise ciphers: Use group cipher suite
		 * Authentication suites: 00-50-f2:0
	WMM: information: 01 00

Other systems see that network the same way in iw; but succeed it
connecting with an invalid key. On Android; that IBSS network is seen as
Open.

Anyone has clues on how to further debug this?

Thanks.

--=20
Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
Freenode: cyphermox, Jabber: mathieu.tl@gmail.com
4096R/EE018C93 1967 8F7D 03A1 8F38 732E  FF82 C126 33E1 EE01 8C93


--------------enigB2F284866F26C35FA4328520
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPY6E2AAoJEMEmM+HuAYyTIaQP/A4Jk6n22e2sRMDgcE1nm9hG
CNjhLO9wf6XiPuSgjIo1zfeTJAk9tZKlkPHN0BcWIlABpZx+bRgdoPuzM51CT2o9
SVIzpsSZcgOGyFRJUNonno39bhwkTSuvIyz0C1r8J1UI7il3xNuCXGBoIh38pupm
kQH5T4DJCDOBC6W/IieAYBAao/g3aHzmvsQTETu0Zord4PNXIRC/8RjaoQUzHAFP
AQkxBQ2ISU268iiU4v8M+wIdpEyiz+y3rS4ClF3G/speqX2i9mPwTUGUCN66vvOl
mXsjHjtd6ltgjxEJihKMcHQYxY10NxfmkypbQTRZs4e+/Crl1xxO0Koduk0z2cuU
BSt6hs7z4bVOEc2cubFNZwq80elN/8RcU9TyYOBOCRPbiPucHnWdxM6UM1SzbZuN
9rzZ38O4qDgp+UMxh82KesAt7HMxaTGajie7ccEj9KwZFsEnmCYi2BnRG7Qj6G/K
E19geaSCHhVlD1vyu2K9qjgN9j8bcqVif8uDcUut5ZZaIBteu/ZIX55NrYTwxjyw
tOOte3qDeTT03cbEi21UjwBaADtV3CVVA09dK7llVRF0KqBLG9EgRwbxuhuSiFrU
QG4J8kaQz5+er8We/HrhWkbI0RbhAYbUKc9eN+LX36Sg4Yg3f6opzHUa81OnqTMN
c5R6AOxnu6Bwlooq6AZe
=mMhC
-----END PGP SIGNATURE-----

--------------enigB2F284866F26C35FA4328520--
