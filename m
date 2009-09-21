Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:60818 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZIULAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 07:00:36 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: hostap@lists.shmoo.com
Subject: BUG: can bring wpa_supplicant/mac80211 into a stuck state at will
Date: Mon, 21 Sep 2009 12:59:45 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909211259.45431.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steps to reproduce:

network={
        ssid="MNHS"
        key_mgmt=NONE
        proto=RSN
        key_mgmt=WPA-PSK
        pairwise=CCMP
        group=CCMP
        psk="99999999"
        scan_freq=2412
}

network={
        ssid="MNFUNK"
        key_mgmt=NONE
        wep_key0="99999"
        scan_freq=2412
}

Also two APs, MNHS/WPA2 and MNFUNK/WEP.

Current wireless-testing from GIT + patch "cfg80211: don't
overwrite privacy setting"

Current wpa_supplicant from GIT.

Command: ./wpa_supplicant -i eth1 -D nl80211 -t -c mnhs.conf -d


First, it associates to the MNHS-AP:

...
1253526128.147011:    selected based on RSN IE
1253526128.147024:    selected WPA AP 00:13:19:80:da:30 ssid='MNHS'
...
1253526128.436265: Associated to a new BSS: BSSID=00:13:19:80:da:30
1253526128.436280: No keys have been configured - skip key clearing
1253526128.436297: Associated with 00:13:19:80:da:30
...
1253526128.470149: CTRL-EVENT-CONNECTED - Connection to 00:13:19:80:da:30 completed (auth) [id=0 id_str=]
...

Fine so far.



Next I turn of the AP where I'm associated to. wpa_supplicant
successfully associates to the WEP-based AP:

...
1253526139.247356: Setting scan request: 0 sec 100000 usec
1253526139.247373: Added BSSID 00:13:19:80:da:30 into blacklist
...
1253526139.727196:    selected non-WPA AP 00:1b:53:11:dc:40 ssid='MNFUNK'
...
1253526140.025300: Associated to a new BSS: BSSID=00:1b:53:11:dc:40
1253526140.025320: Associated with 00:1b:53:11:dc:40
...
1253526140.025654: CTRL-EVENT-CONNECTED - Connection to 00:1b:53:11:dc:40 completed (reauth) [id=1 id_str=]
...



Now I turn on again the MNHS AP. And then I issue a scan
from the cmdline: "iw eth1 scan trigger freq 2412"

And now it's getting interesting:

...
1253526175.739000: Received scan results (3 BSSes)
...

1253526175.739064: 0: 00:13:19:80:da:30 ssid='MNHS' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
1253526175.739087:    selected based on RSN IE
1253526175.739098:    selected WPA AP 00:13:19:80:da:30 ssid='MNHS'
1253526175.739115: Automatic auth_alg selection: 0x1
1253526175.739133: RSN: using IEEE 802.11i/D9.0
1253526175.739144: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
1253526175.739160: WPA: clearing AP WPA IE
1253526175.739171: WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 28 00
1253526175.739206: WPA: using GTK CCMP
1253526175.739219: WPA: using PTK CCMP
1253526175.739231: WPA: using KEY_MGMT WPA-PSK
1253526175.739243: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1253526175.739280: Cancelling scan request
1253526175.739298: Trying to authenticate with 00:13:19:80:da:30 (SSID='MNHS' freq=2412 MHz)
1253526175.739312: nl_set_encr: ifindex=34 alg=0 addr=0x8092a8e key_idx=0 set_tx=0 seq_len=0 key_len=0
1253526175.739370: nl_set_encr: ifindex=34 alg=0 addr=0x8092a8e key_idx=1 set_tx=0 seq_len=0 key_len=0
1253526175.739420: nl_set_encr: ifindex=34 alg=0 addr=0x8092a8e key_idx=2 set_tx=0 seq_len=0 key_len=0
1253526175.739466: nl_set_encr: ifindex=34 alg=0 addr=0x8092a8e key_idx=3 set_tx=0 seq_len=0 key_len=0
1253526175.739512: nl_set_encr: ifindex=34 alg=0 addr=0x84e1b34 key_idx=0 set_tx=0 seq_len=0 key_len=0
1253526175.739537:    addr=00:13:19:80:da:30
1253526175.739575: State: COMPLETED -> AUTHENTICATING
1253526175.739593: EAPOL: External notification - EAP success=0
1253526175.739609: EAPOL: External notification - EAP fail=0
1253526175.739622: EAPOL: External notification - portControl=Auto
1253526175.739634: EAPOL: SUPP_PAE entering state DISCONNECTED
1253526175.739646: EAPOL: Supplicant port status: Unauthorized
1253526175.739713: EAPOL: SUPP_BE entering state INITIALIZE
1253526175.739732: EAPOL: SUPP_PAE entering state CONNECTING
1253526175.739744: EAPOL: enable timer tick
1253526175.739757: EAPOL: SUPP_BE entering state IDLE
1253526175.739773: nl80211: Authenticate (ifindex=34)
1253526175.739787:   * bssid=00:13:19:80:da:30
1253526175.739802:   * freq=2412
1253526175.739813:   * SSID - hexdump_ascii(len=4):
     4d 4e 48 53                                       MNHS
1253526175.739845:   * IEs - hexdump(len=0): [NULL]
1253526175.739858:   * Auth Type 0
1253526175.739899: nl80211: Authentication request send successfully
1253526175.739918: RSN: Ignored PMKID candidate without preauth flag
1253526175.739936: RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
1253526175.739954: RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
1253526175.954553: nl80211: Event message available
1253526175.954592: nl80211: MLME event 37
1253526175.954608: SME: Authentication response: peer=00:13:19:80:da:30 auth_type=0 status_code=0
1253526175.954635: Trying to associate with 00:13:19:80:da:30 (SSID='MNHS' freq=2412 MHz)
1253526175.954649: State: AUTHENTICATING -> ASSOCIATING
1253526175.954662: wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
1253526175.954677: nl80211: Operstate: linkmode=-1, operstate=5
1253526175.955294: nl80211: Associate (ifindex=34)
1253526175.955312:   * bssid=00:13:19:80:da:30
1253526175.955327:   * freq=2412
1253526175.955338:   * SSID - hexdump_ascii(len=4):
     4d 4e 48 53                                       MNHS
1253526175.955370:   * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1253526175.955456: nl80211: MLME command failed: ret=-114 (Operation already in progress)
1253526175.955479: Association request to the driver failed
1253526175.955512: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1253526175.955530: RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
1253526178.742658: EAPOL: startWhen --> 0
1253526178.742678: EAPOL: disable timer tick
1253526178.742690: EAPOL: SUPP_PAE entering state CONNECTING
1253526178.742701: EAPOL: enable timer tick
1253526178.742714: EAPOL: txStart
1253526178.742725: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
1253526208.774009: EAPOL: startWhen --> 0
1253526208.774043: EAPOL: disable timer tick
1253526208.774055: EAPOL: SUPP_PAE entering state CONNECTING
1253526208.774066: EAPOL: enable timer tick
1253526208.774079: EAPOL: txStart
1253526208.774090: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
1253526238.805764: EAPOL: startWhen --> 0
1253526238.805790: EAPOL: disable timer tick
1253526238.805802: EAPOL: SUPP_PAE entering state CONNECTING
1253526238.805814: EAPOL: enable timer tick
1253526238.805827: EAPOL: txStart
1253526238.805838: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
1253526268.837109: EAPOL: startWhen --> 0
1253526268.837130: EAPOL: disable timer tick
1253526268.837143: EAPOL: SUPP_PAE entering state HELD
1253526268.837154: EAPOL: enable timer tick
1253526268.837166: EAPOL: Supplicant port status: Unauthorized
1253526268.837296: EAPOL authentication completed unsuccessfully
1253526268.837322: Setting authentication timeout: 2 sec 0 usec
1253526270.838400: Authentication with 00:13:19:80:da:30 timed out.
1253526270.838421: BSSID 00:13:19:80:da:30 blacklist count incremented to 2
1253526270.838440: No keys have been configured - skip key clearing
1253526270.838453: State: ASSOCIATING -> DISCONNECTED
1253526270.838466: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1253526270.838481: nl80211: Operstate: linkmode=-1, operstate=5
1253526270.838506: EAPOL: External notification - portEnabled=0
1253526270.838520: EAPOL: SUPP_PAE entering state DISCONNECTED
1253526270.838532: EAPOL: Supplicant port status: Unauthorized
1253526270.838600: EAPOL: SUPP_BE entering state INITIALIZE
1253526270.838619: EAPOL: Supplicant port status: Unauthorized
1253526270.838679: EAPOL: External notification - portValid=0
1253526270.838697: EAPOL: Supplicant port status: Unauthorized
1253526270.838755: EAPOL: External notification - EAP success=0
1253526270.838772: EAPOL: Supplicant port status: Unauthorized
1253526270.838837: Setting scan request: 0 sec 0 usec
1253526270.838867: EAPOL: Supplicant port status: Unauthorized
1253526270.838936: State: DISCONNECTED -> SCANNING
1253526270.838959: Starting AP scan for wildcard SSID
1253526270.839130: Scan requested (ret=0) - scan timeout 30 seconds
1253526270.839165: nl80211: Event message available
1253526270.839193: nl80211: Ignored unknown event (cmd=33)
1253526271.839909: EAPOL: Supplicant port status: Unauthorized
1253526272.840948: EAPOL: Supplicant port status: Unauthorized
1253526273.841988: EAPOL: Supplicant port status: Unauthorized
1253526274.843028: EAPOL: Supplicant port status: Unauthorized
1253526275.844068: EAPOL: Supplicant port status: Unauthorized
1253526276.845110: EAPOL: Supplicant port status: Unauthorized
1253526277.846150: EAPOL: Supplicant port status: Unauthorized
1253526278.847174: EAPOL: Supplicant port status: Unauthorized
1253526279.848214: EAPOL: Supplicant port status: Unauthorized
1253526280.849255: EAPOL: Supplicant port status: Unauthorized
1253526281.850294: EAPOL: Supplicant port status: Unauthorized
1253526282.851334: EAPOL: Supplicant port status: Unauthorized
1253526283.852374: EAPOL: Supplicant port status: Unauthorized
1253526284.853414: EAPOL: Supplicant port status: Unauthorized
1253526285.854454: EAPOL: Supplicant port status: Unauthorized
1253526286.855495: EAPOL: Supplicant port status: Unauthorized
1253526287.856534: EAPOL: Supplicant port status: Unauthorized
1253526288.857574: EAPOL: Supplicant port status: Unauthorized
1253526289.858613: EAPOL: Supplicant port status: Unauthorized
1253526290.859653: EAPOL: Supplicant port status: Unauthorized
1253526291.860693: EAPOL: Supplicant port status: Unauthorized
1253526292.861733: EAPOL: Supplicant port status: Unauthorized
1253526293.862773: EAPOL: Supplicant port status: Unauthorized
1253526294.863813: EAPOL: Supplicant port status: Unauthorized
1253526295.864853: EAPOL: Supplicant port status: Unauthorized

... AD INIFINITUM ...

-- 
http://www.holgerschurig.de
