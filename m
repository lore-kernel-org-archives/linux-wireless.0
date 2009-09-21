Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:3745 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbZIULKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 07:10:31 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: BUG?  I can reproduce "Association request to the driver failed" at will
Date: Mon, 21 Sep 2009 13:09:40 +0200
Cc: hostap@lists.shmoo.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909211309.40476.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following is an indication about yet another MLME problem:

Two APs, both set to the MNHS/WPA.

Let wpa_supplicant associate. Turn one AP off. wpa_supplicant
automatically associates to the second.

Now turn the first AP on again. Issue a manual scan command:

1253527140.577702: nl80211: Event message available
1253527140.577751: nl80211: Ignored unknown event (cmd=33)
1253527140.794448: nl80211: Event message available
1253527140.794490: nl80211: New scan results available
1253527140.794921: Received scan results (3 BSSes)
1253527140.794947: CTRL-EVENT-SCAN-RESULTS
1253527140.794960: Selecting BSS from priority group 0
1253527140.794972: Try to find WPA-enabled AP
1253527140.794984: 0: 00:13:19:80:da:30 ssid='MNWPA' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
1253527140.795007:    selected based on WPA IE
1253527140.795018:    selected WPA AP 00:13:19:80:da:30 ssid='MNWPA'
1253527140.795035: Automatic auth_alg selection: 0x1
1253527140.795052: WPA: using IEEE 802.11i/D3.0
1253527140.795063: WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
1253527140.795079: WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 28 00
1253527140.795117: WPA: clearing AP RSN IE
1253527140.795129: WPA: using GTK TKIP
1253527140.795141: WPA: using PTK TKIP
1253527140.795154: WPA: using KEY_MGMT WPA-PSK
1253527140.795165: WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
1253527140.795203: Cancelling scan request
1253527140.795221: Trying to authenticate with 00:13:19:80:da:30 (SSID='MNWPA' freq=2412 MHz)
1253527140.795234: nl_set_encr: ifindex=34 alg=0 addr=0x8092a8e key_idx=0 set_tx=0 seq_len=0 key_len=0
1253527140.795286: nl_set_encr: ifindex=34 alg=0 addr=0x8092a8e key_idx=1 set_tx=0 seq_len=0 key_len=0
1253527140.795341: nl_set_encr: ifindex=34 alg=0 addr=0x8092a8e key_idx=2 set_tx=0 seq_len=0 key_len=0
1253527140.795389: nl_set_encr: ifindex=34 alg=0 addr=0x8092a8e key_idx=3 set_tx=0 seq_len=0 key_len=0
1253527140.795435: nl_set_encr: ifindex=34 alg=0 addr=0x91ce96c key_idx=0 set_tx=0 seq_len=0 key_len=0
1253527140.795460:    addr=00:13:19:80:da:30
1253527140.795498: State: COMPLETED -> AUTHENTICATING
1253527140.795515: EAPOL: External notification - EAP success=0
1253527140.795530: EAPOL: External notification - EAP fail=0
1253527140.795542: EAPOL: External notification - portControl=Auto
1253527140.795559: nl80211: Authenticate (ifindex=34)
1253527140.795572:   * bssid=00:13:19:80:da:30
1253527140.795587:   * freq=2412
1253527140.795598:   * SSID - hexdump_ascii(len=5):
     4d 4e 57 50 41                                    MNWPA
1253527140.795630:   * IEs - hexdump(len=0): [NULL]
1253527140.795643:   * Auth Type 0
1253527140.795683: nl80211: Authentication request send successfully
1253527140.795707: RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
1253527140.795725: RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
1253527140.953161: nl80211: Event message available
1253527140.953200: nl80211: MLME event 37
1253527140.953216: SME: Authentication response: peer=00:13:19:80:da:30 auth_type=0 status_code=0
1253527140.953243: Trying to associate with 00:13:19:80:da:30 (SSID='MNWPA' freq=2412 MHz)
1253527140.953257: State: AUTHENTICATING -> ASSOCIATING
1253527140.953270: wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
1253527140.953284: nl80211: Operstate: linkmode=-1, operstate=5
1253527140.953901: nl80211: Associate (ifindex=34)
1253527140.953919:   * bssid=00:13:19:80:da:30
1253527140.953934:   * freq=2412
1253527140.953945:   * SSID - hexdump_ascii(len=5):
     4d 4e 57 50 41                                    MNWPA
1253527140.953977:   * IEs - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
1253527140.954064: nl80211: MLME command failed: ret=-114 (Operation already in progress)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1253527140.954086: Association request to the driver failed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1253527140.954113: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1253527140.954131: RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added


The "Association request to the driver failed" will
be shown even without "-d". Also note that the association
seems to actually work, e.g. I can ping throught the
connection.

-- 
http://www.holgerschurig.de
