Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zbasel.fortytwo.ch ([193.138.215.60]:44273 "EHLO
	zbasel.fortytwo.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZG1Gtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 02:49:52 -0400
Received: from laeggerli.fortytwo.ch (mail.stiftung-buehl.ch [84.253.12.26])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by zbasel.fortytwo.ch (Postfix) with ESMTP id 6AE493037E
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 08:38:54 +0200 (CEST)
From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: ath5k connection loss (failed to wakeup the MAC Chip)
Date: Tue, 28 Jul 2009 08:38:34 +0200
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed;
  boundary="nextPart2648695.XYUnbmi3CQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200907280838.42541@fortytwo.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2648695.XYUnbmi3CQ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Heyho!

(This is using kernel 2.6.31-rc3 as packaged by Debian)

While taking a full backup of my laptop, I noticed that after a few 100M th=
e=20
ath5k can't connect to WLAN anymore.

syslog shows:
+++
Jul 28 00:12:59 laeggerli kernel: [187967.601820] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:13:04 laeggerli wpa_supplicant[2574]: CTRL-EVENT-DISCONNECTED - D=
isconnect event - remove keys
Jul 28 00:13:04 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  completed -> disconnected
Jul 28 00:13:04 laeggerli kernel: [187973.344128] wlan0: no probe response =
from AP 00:21:29:7c:d6:7e - disassociating
Jul 28 00:13:05 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  disconnected -> scanning
Jul 28 00:13:06 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:13:06 laeggerli wpa_supplicant[2574]: Trying to associate with 00=
:21:29:7c:d6:7e (SSID=3D'JUNGBORN' freq=3D2437 MHz)
Jul 28 00:13:06 laeggerli wpa_supplicant[2574]: Association request to the =
driver failed
Jul 28 00:13:06 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  scanning -> associating
Jul 28 00:13:06 laeggerli kernel: [187974.834410] wlan0: authenticate with =
AP 00:21:29:7c:d6:7e
Jul 28 00:13:06 laeggerli kernel: [187974.835893] wlan0: authenticated
Jul 28 00:13:06 laeggerli kernel: [187974.835902] wlan0: associate with AP =
00:21:29:7c:d6:7e
Jul 28 00:13:06 laeggerli kernel: [187974.838825] wlan0: RX ReassocResp fro=
m 00:21:29:7c:d6:7e (capab=3D0x411 status=3D13 aid=3D0)
Jul 28 00:13:06 laeggerli kernel: [187974.838839] wlan0: AP denied associat=
ion (code=3D13)
Jul 28 00:13:06 laeggerli kernel: [187975.032147] wlan0: associate with AP =
00:21:29:7c:d6:7e
Jul 28 00:13:06 laeggerli kernel: [187975.232140] wlan0: associate with AP =
00:21:29:7c:d6:7e
Jul 28 00:13:06 laeggerli kernel: [187975.234415] wlan0: RX AssocResp from =
00:21:29:7c:d6:7e (capab=3D0x411 status=3D0 aid=3D2)
Jul 28 00:13:06 laeggerli kernel: [187975.234427] wlan0: associated
Jul 28 00:13:06 laeggerli wpa_supplicant[2574]: Associated with 00:21:29:7c=
:d6:7e
Jul 28 00:13:06 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  associating -> associated
Jul 28 00:13:06 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  associated -> 4-way handshake
Jul 28 00:13:06 laeggerli wpa_supplicant[2574]: WPA: Key negotiation comple=
ted with 00:21:29:7c:d6:7e [PTK=3DCCMP GTK=3DCCMP]
Jul 28 00:13:06 laeggerli wpa_supplicant[2574]: CTRL-EVENT-CONNECTED - Conn=
ection to 00:21:29:7c:d6:7e completed (reauth) [id=3D0 id_str=3D]
Jul 28 00:13:06 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  4-way handshake -> group handshake
Jul 28 00:13:06 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  group handshake -> completed
Jul 28 00:13:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:15:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:16:57 laeggerli kernel: [188206.300081] CE: hpet increasing min_d=
elta_ns to 22500 nsec
Jul 28 00:17:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:19:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:21:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:23:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:25:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:27:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:29:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:31:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:33:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:35:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:36:33 laeggerli wpa_supplicant[2574]: WPA: Group rekeying complet=
ed with 00:21:29:7c:d6:7e [GTK=3DCCMP]
Jul 28 00:36:33 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  completed -> group handshake
Jul 28 00:36:33 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  group handshake -> completed
Jul 28 00:37:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:39:50 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:40:39 laeggerli wpa_supplicant[2574]: CTRL-EVENT-DISCONNECTED - D=
isconnect event - remove keys
Jul 28 00:40:39 laeggerli kernel: [189628.185908] wlan0: no probe response =
from AP 00:21:29:7c:d6:7e - disassociating
Jul 28 00:40:39 laeggerli kernel: [189628.312377] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:40:39 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  completed -> disconnected
Jul 28 00:40:39 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  disconnected -> scanning
Jul 28 00:40:40 laeggerli kernel: [189628.381965] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:40 laeggerli kernel: [189628.381984] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:40 laeggerli kernel: [189628.419755] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:40 laeggerli kernel: [189628.419771] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:40 laeggerli kernel: [189628.457511] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:40 laeggerli kernel: [189628.457526] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:40 laeggerli kernel: [189628.495260] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:40 laeggerli kernel: [189628.495276] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:40 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:40:45 laeggerli kernel: [189633.901859] __ratelimit: 20 callbacks=
 suppressed
Jul 28 00:40:45 laeggerli kernel: [189633.901872] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:45 laeggerli kernel: [189633.901886] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:45 laeggerli kernel: [189633.939635] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:45 laeggerli kernel: [189633.939651] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:45 laeggerli kernel: [189633.977350] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:45 laeggerli kernel: [189633.977365] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:45 laeggerli kernel: [189634.015105] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:45 laeggerli kernel: [189634.015120] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:45 laeggerli kernel: [189634.052883] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:45 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:40:50 laeggerli kernel: [189639.310908] __ratelimit: 18 callbacks=
 suppressed
Jul 28 00:40:50 laeggerli kernel: [189639.310923] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:40:51 laeggerli kernel: [189639.423590] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:51 laeggerli kernel: [189639.423608] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:51 laeggerli kernel: [189639.461345] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:51 laeggerli kernel: [189639.461361] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:51 laeggerli kernel: [189639.499131] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:51 laeggerli kernel: [189639.499147] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:51 laeggerli kernel: [189639.536910] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:51 laeggerli kernel: [189639.536926] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:51 laeggerli kernel: [189639.574650] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:51 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:40:55 laeggerli NetworkManager: <info>  (wlan0): device state cha=
nge: 8 -> 3
Jul 28 00:40:55 laeggerli NetworkManager: <info>  (wlan0): deactivating dev=
ice (reason: 11).
Jul 28 00:40:55 laeggerli NetworkManager: <info>  wlan0: canceled DHCP tran=
saction, dhcp client pid 22348
Jul 28 00:40:55 laeggerli NetworkManager: <info>  (wlan0): removing resolv.=
conf from /sbin/resolvconf
Jul 28 00:40:55 laeggerli NetworkManager: <WARN>  check_one_route(): (wlan0=
) error -34 returned from rtnl_route_del(): Sucess#012
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Activation (wlan0) starti=
ng connection 'JUNGBORN'
Jul 28 00:40:55 laeggerli NetworkManager: <info>  (wlan0): device state cha=
nge: 3 -> 4
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Activation (wlan0) Stage =
1 of 5 (Device Prepare) scheduled...
Jul 28 00:40:55 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  scanning -> disconnected
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Activation (wlan0) Stage =
1 of 5 (Device Prepare) started...
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Activation (wlan0) Stage =
2 of 5 (Device Configure) scheduled...
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Activation (wlan0) Stage =
1 of 5 (Device Prepare) complete.
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Activation (wlan0) Stage =
2 of 5 (Device Configure) starting...
Jul 28 00:40:55 laeggerli NetworkManager: <info>  (wlan0): device state cha=
nge: 4 -> 5
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Activation (wlan0/wireles=
s): connection 'JUNGBORN' has security, and secrets exist.  No=20
new
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Config: added 'ssid' valu=
e 'JUNGBORN'
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Config: added 'scan_ssid'=
 value '1'
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Config: added 'key_mgmt' =
value 'WPA-PSK'
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Config: added 'auth_alg' =
value 'OPEN'
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Config: added 'psk' value=
 '<omitted>'
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Activation (wlan0) Stage =
2 of 5 (Device Configure) complete.
Jul 28 00:40:55 laeggerli NetworkManager: <info>  Config: set interface ap_=
scan to 1
Jul 28 00:40:56 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  disconnected -> scanning
Jul 28 00:40:56 laeggerli kernel: [189644.942989] __ratelimit: 19 callbacks=
 suppressed
Jul 28 00:40:56 laeggerli kernel: [189644.943006] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:56 laeggerli kernel: [189644.943025] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:56 laeggerli kernel: [189644.980644] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:56 laeggerli kernel: [189644.980657] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:56 laeggerli kernel: [189645.018382] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:56 laeggerli kernel: [189645.018400] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:56 laeggerli kernel: [189645.056153] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:56 laeggerli kernel: [189645.056169] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:56 laeggerli kernel: [189645.093905] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:40:56 laeggerli kernel: [189645.093920] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:40:57 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:41:01 laeggerli kernel: [189650.312282] __ratelimit: 18 callbacks=
 suppressed
Jul 28 00:41:01 laeggerli kernel: [189650.312297] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:41:02 laeggerli kernel: [189650.465854] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:41:02 laeggerli kernel: [189650.465873] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:41:02 laeggerli kernel: [189650.503638] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:41:02 laeggerli kernel: [189650.503654] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:41:02 laeggerli kernel: [189650.541381] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:41:02 laeggerli kernel: [189650.541397] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:41:02 laeggerli kernel: [189650.579152] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:41:02 laeggerli kernel: [189650.579168] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:41:02 laeggerli kernel: [189650.616908] ath5k phy0: failed to wak=
eup the MAC Chip
=2E..
Jul 28 00:41:19 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:41:21 laeggerli NetworkManager: <info>  Activation (wlan0/wireles=
s): association took too long.
Jul 28 00:41:21 laeggerli NetworkManager: <info>  (wlan0): device state cha=
nge: 5 -> 6
Jul 28 00:41:21 laeggerli NetworkManager: <info>  Activation (wlan0/wireles=
s): asking for new secrets
Jul 28 00:41:21 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  scanning -> disconnected
Jul 28 00:41:23 laeggerli kernel: [189672.311165] __ratelimit: 18 callbacks=
 suppressed
Jul 28 00:41:23 laeggerli kernel: [189672.311180] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:41:34 laeggerli kernel: [189683.312283] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:41:36 laeggerli NetworkManager: <info>  wlan0: link timed out.
Jul 28 00:41:45 laeggerli kernel: [189694.310974] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:41:49 laeggerli NetworkManager: <info>  (wlan0): supplicant conne=
ction state:  disconnected -> scanning
Jul 28 00:41:49 laeggerli kernel: [189697.437887] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:41:49 laeggerli kernel: [189697.437906] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:41:49 laeggerli kernel: [189697.475626] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:41:49 laeggerli kernel: [189697.475640] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:41:49 laeggerli kernel: [189697.513393] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:41:49 laeggerli kernel: [189697.513410] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:41:49 laeggerli kernel: [189697.551173] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:41:49 laeggerli kernel: [189697.551190] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:41:49 laeggerli kernel: [189697.588922] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:41:49 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:41:56 laeggerli kernel: [189705.310991] __ratelimit: 19 callbacks=
 suppressed
Jul 28 00:41:56 laeggerli kernel: [189705.311005] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:42:07 laeggerli kernel: [189716.310940] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:42:18 laeggerli kernel: [189727.311011] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:42:29 laeggerli kernel: [189738.312159] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:42:40 laeggerli kernel: [189749.310972] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:42:51 laeggerli kernel: [189760.310827] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:43:02 laeggerli kernel: [189771.310876] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:43:13 laeggerli kernel: [189782.310957] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:43:24 laeggerli kernel: [189793.310941] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:43:49 laeggerli kernel: [189817.437845] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:43:49 laeggerli kernel: [189817.437864] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:43:49 laeggerli kernel: [189817.475614] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:43:49 laeggerli kernel: [189817.475627] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:43:49 laeggerli kernel: [189817.513366] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:43:49 laeggerli kernel: [189817.513383] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:43:49 laeggerli kernel: [189817.551138] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:43:49 laeggerli kernel: [189817.551153] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:43:49 laeggerli kernel: [189817.588901] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:43:49 laeggerli wpa_supplicant[2574]: CTRL-EVENT-SCAN-RESULTS
Jul 28 00:43:57 laeggerli kernel: [189826.310939] __ratelimit: 19 callbacks=
 suppressed
Jul 28 00:43:57 laeggerli kernel: [189826.310954] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:44:08 laeggerli kernel: [189837.310993] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:44:19 laeggerli kernel: [189848.310941] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:44:30 laeggerli kernel: [189859.312331] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:44:41 laeggerli kernel: [189870.310908] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:44:52 laeggerli kernel: [189881.310876] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:45:03 laeggerli kernel: [189892.310988] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:45:14 laeggerli kernel: [189903.311005] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:45:25 laeggerli kernel: [189914.310988] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:45:36 laeggerli kernel: [189925.312394] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:45:47 laeggerli kernel: [189936.310909] ath5k phy0: noise floor c=
alibration timeout (2437MHz)
Jul 28 00:45:49 laeggerli kernel: [189937.437866] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:45:49 laeggerli kernel: [189937.437885] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:45:49 laeggerli kernel: [189937.475614] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:45:49 laeggerli kernel: [189937.475628] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:45:49 laeggerli kernel: [189937.513360] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:45:49 laeggerli kernel: [189937.513377] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:45:49 laeggerli kernel: [189937.551138] ath5k phy0: failed to wak=
eup the MAC Chip
Jul 28 00:45:49 laeggerli kernel: [189937.551154] ath5k phy0: can't reset h=
ardware (-5)
Jul 28 00:45:49 laeggerli kernel: [189937.588900] ath5k phy0: failed to wak=
eup the MAC Chip
etc. etc.
+++

This only happens with bulk data transfers, and probably only when sending.=
 =20
Downloading large dataset over WLAN is fine (I haven't tested it as much as=
=20
sending, though: downloads are mostly small, while the bulk sending happens=
=20
regularly during backup.)

It is not related to how long the WLAN is up: I can work for days or weeks=
=20
(happened with earlier kernels as well) with this laptop, over=20
suspend/resume, and WLAN works fine.  It's only when I run backup that it=20
happens (always - but I since backups usually are incremental, they're ofte=
n=20
small enough.  But once I do a full backup WLAN goes down.  So use cable fo=
r=20
those...)

Is this known?  Can I get you more information?

Hardware is Acer AOA 150.

thanks
=2D- vbi

=2D-=20
featured link: Debian Bookmark Collection - http://bookmarks.debian.net/



--nextPart2648695.XYUnbmi3CQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAkpunOtgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6zJoAnjtqX+Q+uChPqOKUekvh0VUU
GY4jAJ4wGy+vsBZ+bdZeEE4eTPyCsg09oA==
=fzS8
-----END PGP SIGNATURE-----

--nextPart2648695.XYUnbmi3CQ--
