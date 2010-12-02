Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:48646 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0LBAWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 19:22:37 -0500
Date: Wed, 1 Dec 2010 20:22:34 -0400
From: Giacomo Comes <comes@naic.edu>
To: Dave Kilroy <kilroyd@gmail.com>
Cc: Giacomo Comes <comes@naic.edu>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs module and WPA not working
Message-ID: <20101202002234.GA30670@monopoli.naic.edu>
References: <20101122024208.GA13377@monopoli.naic.edu> <AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com> <20101125014511.GA1683@monopoli.naic.edu> <AANLkTi=nkayyyzECi6MO87ZO-CUpZeNP007_hMp8LiPV@mail.gmail.com> <20101126040742.GA5238@monopoli.naic.edu> <AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com> <20101130021911.GA18971@monopoli.naic.edu> <AANLkTi=1PXk4u37mPd6=F6mjYWLqo=wg7trVmmpfV_WV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
In-Reply-To: <AANLkTi=1PXk4u37mPd6=F6mjYWLqo=wg7trVmmpfV_WV@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Dec 01, 2010 at 09:52:15PM +0000, Dave Kilroy wrote:
> On Tue, Nov 30, 2010 at 2:19 AM, Giacomo Comes <comes@naic.edu> wrote:
> > On Sun, Nov 28, 2010 at 04:10:30PM +0000, Dave Kilroy wrote:
> >>
> >> Just had a closer look at your log. wpa_supplicant is clearing keys 4
> >> and 5, which is why you're getting invalid arguments reported. This
> >> shouldn't affect driver behaviour.
> >>
> >> After that, something seems to go wrong with scanning. Try a plain
> >> scan with wpa_supplicant turned off. Do you get any results?
> >
> > After a reboot and without configuring the wireless interface,
> > iw dev eth1 scan
> > gives:
> > command failed: Network is down (-100)
> 
> The interface need to be up to scan:
> 
> ifconfig eth1 up

Ok, my bad. After I put the interface up the scan works.

> 
> > I was trying to associate the wireless card using iwconfig:
> >    iwconfig eth1 mode managed key <key>
> >    iwconfig eth1 essid <essid>
> > but the card does not associate with the AP.
> > Isn't that supposed to work or am I missing something?
> 
> Was that AP using WEP or WPA? The former should work (with the
> interface up, and all the parameters being set correctly). The latter
> won't.

The AP was using WEP, but it didn't associate because I didn't put up 
the interface. After doing it, it works.

> 
> > Buy the way, if I configure the wireless interface with yast
> > using WEP (the only way I can make the truemobile
> > card work) then iw dev eth1 scan gives:
> > BSS 00:13:10:aa:89:4b (on eth1)
> >        TSF: 12179691 usec (0d, 00:00:12)
> >        freq: 2437
> >        beacon interval: 100
> >        capability: ESS Privacy PBCC ShortSlotTime (0x0451)
> >        signal: -27.00 dBm
> >        last seen: 48 ms ago
> >        SSID: ssid2
> >        Supported rates: 1.0* 2.0* 5.5* 11.0* 22.0
> >        DS Parameter set: channel 6
> >        ERP: Barker_Preamble_Mode
> >        Extended supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0
> >        WPA:     * Version: 1
> >                 * Group cipher: TKIP
> >                 * Pairwise ciphers: TKIP
> >                 * Authentication suites: PSK
> 
> That's what I wanted to see. So the card is able to scan, but your
> wpa_supplicant log indicates it is continuously timing out the scans.
> I don't know what is going on there.
> 
> What you can try is to turn off wpa_supplicant roaming, and force
> wpa_supplicant to connect to the AP with highest priority in your
> config. Set ap_scan=2 in wpa_supplicant.conf, and set
> 
> group=TKIP
> pairwise=TKIP
> 
> in the network block.
> 
> This also prevents wpa_supplicant trying to connect to an AP using
> BSSID, which the agere cards don't support.
> 

Running:
wpa_supplicant -ieth1 -c wpa_supplicant.conf -f wpa_supplicant.log -dd

wpa_supplicant.conf content:
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
ap_scan=2

network={
        ssid="Comes"
        psk="<password>"
        key_mgmt=WPA-PSK
        priority=5
        proto=WPA

        group=TKIP
        pairwise=TKIP
}

wpa_supplicant.log attached.

Giacomo

--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wpa_supplicant.log"

Initializing interface 'eth1' conf 'wpa_supplicant.conf' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
Configuration file 'wpa_supplicant.conf' -> '/root/wpa_supplicant.conf'
Reading configuration file '/root/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
ctrl_interface_group='0'
ap_scan=2
Line: 5 - start of a new network block
ssid - hexdump_ascii(len=5):
     43 6f 6d 65 73                                    Comes           
PSK (ASCII passphrase) - hexdump_ascii(len=18): [REMOVED]
key_mgmt: 0x2
priority=5 (0x5)
proto: 0x1
group: 0x8
pairwise: 0x8
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Priority group 5
   id=0 ssid='Comes'
WEXT: cfg80211-based driver detected
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0x5
  capabilities: key_mgmt 0x5 enc 0x7 flags 0x0
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 00:02:2d:7e:fc:cb
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=4 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=5 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_countermeasures
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): 85 92 32 af f8 e1 55 09 8a 9c 35 74 b7 fa 7e 0b
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
ctrl_interface_group=0
Added interface eth1
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
State: DISCONNECTED -> SCANNING
Trying to associate with SSID 'Comes'
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: No WPA/RSN IE available from association info
WPA: Set cipher suites based on configuration
WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK TKIP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wpa_driver_wext_associate: assoc failed because set_auth_param(IW_AUTH_MFP) failed
Association request to the driver failed
Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=13
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
Authentication with 00:00:00:00:00:00 timed out.
Added BSSID 00:00:00:00:00:00 into blacklist
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Trying to associate with SSID 'Comes'
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: No WPA/RSN IE available from association info
WPA: Set cipher suites based on configuration
WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK TKIP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wpa_driver_wext_associate: assoc failed because set_auth_param(IW_AUTH_MFP) failed
Association request to the driver failed
Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=13
Authentication with 00:00:00:00:00:00 timed out.
BSSID 00:00:00:00:00:00 blacklist count incremented to 2
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Trying to associate with SSID 'Comes'
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: No WPA/RSN IE available from association info
WPA: Set cipher suites based on configuration
WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK TKIP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wpa_driver_wext_associate: assoc failed because set_auth_param(IW_AUTH_MFP) failed
Association request to the driver failed
Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=13
Authentication with 00:00:00:00:00:00 timed out.
BSSID 00:00:00:00:00:00 blacklist count incremented to 3
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Trying to associate with SSID 'Comes'
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: No WPA/RSN IE available from association info
WPA: Set cipher suites based on configuration
WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK TKIP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wpa_driver_wext_associate: assoc failed because set_auth_param(IW_AUTH_MFP) failed
Association request to the driver failed
Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=13
Authentication with 00:00:00:00:00:00 timed out.
BSSID 00:00:00:00:00:00 blacklist count incremented to 4
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Trying to associate with SSID 'Comes'
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: No WPA/RSN IE available from association info
WPA: Set cipher suites based on configuration
WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK TKIP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wpa_driver_wext_associate: assoc failed because set_auth_param(IW_AUTH_MFP) failed
Association request to the driver failed
Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=13
Authentication with 00:00:00:00:00:00 timed out.
BSSID 00:00:00:00:00:00 blacklist count incremented to 5
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Trying to associate with SSID 'Comes'
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: No WPA/RSN IE available from association info
WPA: Set cipher suites based on configuration
WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK TKIP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wpa_driver_wext_associate: assoc failed because set_auth_param(IW_AUTH_MFP) failed
Association request to the driver failed
Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=13
Authentication with 00:00:00:00:00:00 timed out.
BSSID 00:00:00:00:00:00 blacklist count incremented to 6
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Trying to associate with SSID 'Comes'
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: No WPA/RSN IE available from association info
WPA: Set cipher suites based on configuration
WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK TKIP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wpa_driver_wext_associate: assoc failed because set_auth_param(IW_AUTH_MFP) failed
Association request to the driver failed
Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=13
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface eth1
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Cancelling scan request
Cancelling authentication timeout
netlink: Operstate: linkmode=0, operstate=6

--Qxx1br4bt0+wmkIi--
