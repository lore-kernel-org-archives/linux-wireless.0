Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:50329 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab0LCAKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 19:10:55 -0500
Date: Thu, 2 Dec 2010 20:10:52 -0400
From: Giacomo Comes <comes@naic.edu>
To: Dave Kilroy <kilroyd@gmail.com>
Cc: Giacomo Comes <comes@naic.edu>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs module and WPA not working
Message-ID: <20101203001052.GA16808@monopoli.naic.edu>
References: <20101122024208.GA13377@monopoli.naic.edu> <AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com> <20101125014511.GA1683@monopoli.naic.edu> <AANLkTi=nkayyyzECi6MO87ZO-CUpZeNP007_hMp8LiPV@mail.gmail.com> <20101126040742.GA5238@monopoli.naic.edu> <AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com> <20101130021911.GA18971@monopoli.naic.edu> <AANLkTi=1PXk4u37mPd6=F6mjYWLqo=wg7trVmmpfV_WV@mail.gmail.com> <20101202002234.GA30670@monopoli.naic.edu> <AANLkTi=YT1V-kr-tAmNfSBPPEGk39H37RoNkx5txhnD7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
In-Reply-To: <AANLkTi=YT1V-kr-tAmNfSBPPEGk39H37RoNkx5txhnD7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Dec 02, 2010 at 05:46:54PM +0000, Dave Kilroy wrote:
> On Thu, Dec 2, 2010 at 12:22 AM, Giacomo Comes <comes@naic.edu> wrote:
> > On Wed, Dec 01, 2010 at 09:52:15PM +0000, Dave Kilroy wrote:
> >> On Tue, Nov 30, 2010 at 2:19 AM, Giacomo Comes <comes@naic.edu> wrote:
> >> wpa_supplicant log indicates it is continuously timing out the scans.
> >> I don't know what is going on there.
> >>
> >> What you can try is to turn off wpa_supplicant roaming, and force
> >> wpa_supplicant to connect to the AP with highest priority in your
> >> config. Set ap_scan=2 in wpa_supplicant.conf, and set
> >>
> >> group=TKIP
> >> pairwise=TKIP
> >>
> >> in the network block.
> >>
> >> This also prevents wpa_supplicant trying to connect to an AP using
> >> BSSID, which the agere cards don't support.
> >
> > Running:
> > wpa_supplicant -ieth1 -c wpa_supplicant.conf -f wpa_supplicant.log -dd
> >
> > wpa_supplicant.conf content:
> > ctrl_interface=/var/run/wpa_supplicant
> > ctrl_interface_group=0
> > ap_scan=2
> >
> > network={
> >        ssid="Comes"
> >        psk="<password>"
> >        key_mgmt=WPA-PSK
> >        priority=5
> >        proto=WPA
> >
> >        group=TKIP
> >        pairwise=TKIP
> > }
> 
> OK, looks like you're using a newer wpa_supplicant that tries to use
> IW_AUTH_MFP which orinoco doesn't know about. I can modify the driver
> to silently pass these calls through, but it would be nice if
> wpa_supplicant didn't fail because a driver didn't support a
> particular option.
> 
> I'll put together a patch to accept an IW_AUTH_MFP call set to NONE or
> DISABLED, and fail on REQUIRED. In the meantime you could try use an
> older wpa_supplicant. I think I was using 0.7.2 before, but I can't be
> sure.

wpa_supplicant version is 0.7.3. It's the one included in suse 11.3.

About your patch, things are getting better.

I have applied the patch and run wpa_supplicant with the configuration
showed above. It works, the card associates with the AP.
The succesful log is attached.
After I removed from wpa_supplicant.conf the two lines:
group=TKIP
pairwise=TKIP
the association still works.

But after removing the line: ap_scan=2
the association fails.
The log is in the second attachment.

Also I have included in the 3rd attachement wpa_supplicant.log when 
NetworkManager is used.

Giacomo

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wpa_supplicant_ok.log"

Initializing interface 'eth1' conf 'wpa_supplicant1.conf' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
Configuration file 'wpa_supplicant1.conf' -> '/root/wpa_supplicant1.conf'
Reading configuration file '/root/wpa_supplicant1.conf'
ctrl_interface='/var/run/wpa_supplicant'
ctrl_interface_group='wheel'
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
Own MAC address: 00:02:2d:70:31:3b
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
WPS: UUID based on MAC address - hexdump(len=16): 65 86 3e 36 18 13 57 3a b2 46 2f 88 c6 00 3e 7d
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
ctrl_interface_group=10 (from group name 'wheel')
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
Setting authentication timeout: 60 sec 0 usec
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
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8c07 len=32
AssocReq IE wireless event - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b15 len=20
Wireless event: new AP: 00:13:10:aa:89:4b
Association info event
req_ies - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
WPA: set own WPA/RSN IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:13:10:aa:89:4b
No keys have been configured - skip key clearing
Select network based on association information
Network configuration found for the current AP
WPA: Using WPA IE from AssocReq to set cipher suites
WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK TKIP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
Associated with 00:13:10:aa:89:4b
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RX EAPOL from 00:13:10:aa:89:4b
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 89 00 20 00 00 00 00 00 00 00 01 94 f9 ea a6 d3 de d8 23 88 f1 a0 64 8f 67 9a 08 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c6 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x89 (ver=1 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=32 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): 94 f9 ea a6 d3 de d8 23 88 f1 a0 64 8f 67 9a 08 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c6
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 89 00 20 00 00 00 00 00 00 00 01 94 f9 ea a6 d3 de d8 23 88 f1 a0 64 8f 67 9a 08 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c6 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:13:10:aa:89:4b (ver=1)
WPA: Renewed SNonce - hexdump(len=32): 0b 6f 62 ce db 30 8a 3b 14 f0 eb 3d bb af e9 b7 bb 87 f0 a1 57 c3 d6 04 82 46 fe 13 14 c4 cf 2e
WPA: PTK derivation - A1=00:02:2d:70:31:3b A2=00:13:10:aa:89:4b
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 09 00 20 00 00 00 00 00 00 00 01 0b 6f 62 ce db 30 8a 3b 14 f0 eb 3d bb af e9 b7 bb 87 f0 a1 57 c3 d6 04 82 46 fe 13 14 c4 cf 2e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e2 e0 e8 f0 e9 2e 89 d9 75 d2 2a 01 ea 21 33 ec 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
RX EAPOL from 00:13:10:aa:89:4b
RX EAPOL - hexdump(len=123): 01 03 00 77 fe 01 c9 00 20 00 00 00 00 00 00 00 02 94 f9 ea a6 d3 de d8 23 88 f1 a0 64 8f 67 9a 08 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c6 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e9 b8 84 f7 58 12 13 3c 61 ae c3 e1 6a 7b 79 f2 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
IEEE 802.1X RX: version=1 type=3 length=119
  EAPOL-Key type=254
  key_info 0x1c9 (ver=1 keyidx=0 rsvd=0 Pairwise Install Ack MIC)
  key_length=32 key_data_length=24
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): 94 f9 ea a6 d3 de d8 23 88 f1 a0 64 8f 67 9a 08 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c6
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): e9 b8 84 f7 58 12 13 3c 61 ae c3 e1 6a 7b 79 f2
WPA: RX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 c9 00 20 00 00 00 00 00 00 00 02 94 f9 ea a6 d3 de d8 23 88 f1 a0 64 8f 67 9a 08 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c6 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e9 b8 84 f7 58 12 13 3c 61 ae c3 e1 6a 7b 79 f2 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:13:10:aa:89:4b (ver=1)
WPA: IE KeyData - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
WPA: WPA IE in EAPOL-Key - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
WPA: No WPA/RSN IE for this AP known. Trying to get from scan results
Received 0 bytes of scan results (0 BSSes)
BSS: Start scan result update 1
WPA: Could not find AP from the scan results
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 01 09 00 20 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 85 78 6b 70 16 73 d0 71 8b ad 7c f0 97 64 64 5e 00 00
WPA: Installing PTK to the driver.
WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
wpa_driver_wext_set_key: alg=2 key_idx=0 set_tx=1 seq_len=6 key_len=32
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RX EAPOL from 00:13:10:aa:89:4b
RX EAPOL - hexdump(len=131): 01 03 00 7f fe 03 a1 00 20 00 00 00 00 00 00 00 03 94 f9 ea a6 d3 de d8 23 88 f1 a0 64 8f 67 9a 08 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c5 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c7 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9a 58 3b 6c a8 47 27 18 ce 97 1e e2 fc 03 5b bb 00 20 e6 09 a7 99 a1 83 0b 6f ea 9b fa 08 2d 74 cb 99 94 e3 31 81 6e 18 44 65 0e b5 1d 4d 6e 08 65 7e
IEEE 802.1X RX: version=1 type=3 length=127
  EAPOL-Key type=254
  key_info 0x3a1 (ver=1 keyidx=2 rsvd=0 Group Ack MIC Secure)
  key_length=32 key_data_length=32
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): 94 f9 ea a6 d3 de d8 23 88 f1 a0 64 8f 67 9a 08 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c5
  key_iv - hexdump(len=16): c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c7
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 9a 58 3b 6c a8 47 27 18 ce 97 1e e2 fc 03 5b bb
WPA: RX EAPOL-Key - hexdump(len=131): 01 03 00 7f fe 03 a1 00 20 00 00 00 00 00 00 00 03 94 f9 ea a6 d3 de d8 23 88 f1 a0 64 8f 67 9a 08 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c5 c7 a4 68 35 94 8b 92 4f 6c aa 60 db a2 29 53 c7 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9a 58 3b 6c a8 47 27 18 ce 97 1e e2 fc 03 5b bb 00 20 e6 09 a7 99 a1 83 0b 6f ea 9b fa 08 2d 74 cb 99 94 e3 31 81 6e 18 44 65 0e b5 1d 4d 6e 08 65 7e
WPA: RX message 1 of Group Key Handshake from 00:13:10:aa:89:4b (ver=1)
State: GROUP_HANDSHAKE -> GROUP_HANDSHAKE
WPA: Group Key - hexdump(len=32): [REMOVED]
WPA: Installing GTK to the driver (keyidx=2 tx=0 len=32).
WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
wpa_driver_wext_set_key: alg=2 key_idx=2 set_tx=0 seq_len=6 key_len=32
WPA: Sending EAPOL-Key 2/2
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 03 21 00 20 00 00 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4b 78 b2 29 17 f0 e4 48 ef b1 e2 90 9b 62 0a 83 00 00
WPA: Key negotiation completed with 00:13:10:aa:89:4b [PTK=TKIP GTK=TKIP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:13:10:aa:89:4b completed (auth) [id=0 id_str=]
wpa_driver_wext_set_operstate: operstate 0->1 (UP)
netlink: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: Supplicant port status: Authorized
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
EAPOL: startWhen --> 0
EAPOL: disable timer tick
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface eth1
wpa_driver_wext_deauthenticate
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=4 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=5 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
State: COMPLETED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Cancelling scan request
Cancelling authentication timeout
netlink: Operstate: linkmode=0, operstate=6

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wpa_supplicant_fail.log"

Initializing interface 'eth1' conf 'wpa_supplicant.conf' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
Configuration file 'wpa_supplicant.conf' -> '/root/wpa_supplicant.conf'
Reading configuration file '/root/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
ctrl_interface_group='wheel'
Line: 3 - start of a new network block
ssid - hexdump_ascii(len=5):
     43 6f 6d 65 73                                    Comes           
PSK (ASCII passphrase) - hexdump_ascii(len=18): [REMOVED]
key_mgmt: 0x2
priority=5 (0x5)
proto: 0x1
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Priority group 5
   id=0 ssid='Comes'
WEXT: cfg80211-based driver detected
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0x5
  capabilities: key_mgmt 0x5 enc 0x7 flags 0x0
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 00:02:2d:70:31:3b
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
WPS: UUID based on MAC address - hexdump(len=16): 65 86 3e 36 18 13 57 3a b2 46 2f 88 c6 00 3e 7d
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
ctrl_interface_group=10 (from group name 'wheel')
Added interface eth1
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 5 seconds
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
Scan timeout - try to get results
Failed to get scan results
Failed to get scan results - try scanning again
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface eth1
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Cancelling scan request
Cancelling authentication timeout
netlink: Operstate: linkmode=0, operstate=6

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wpa_supplicant_nm_fail.log"

1291334455.185942: dbus: Register D-Bus object '/fi/w1/wpa_supplicant1'
1291334455.204160: Providing DBus service 'fi.w1.wpa_supplicant1'.
1291334455.209388: Providing DBus service 'fi.epitest.hostap.WPASupplicant'.
1291334455.211357: Initializing interface 'eth1' conf 'N/A' driver 'wext' ctrl_interface 'N/A' bridge 'N/A'
1291334455.211612: WEXT: cfg80211-based driver detected
1291334455.211825: SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0x5
1291334455.211849:   capabilities: key_mgmt 0x5 enc 0x7 flags 0x0
1291334455.242013: netlink: Operstate: linkmode=1, operstate=5
1291334455.395240: Own MAC address: 00:02:2d:70:31:3b
1291334455.395325: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
1291334455.418714: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
1291334455.455154: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
1291334455.499613: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
1291334455.536584: wpa_driver_wext_set_key: alg=0 key_idx=4 set_tx=0 seq_len=0 key_len=0
1291334455.536826: Driver did not support SIOCSIWENCODEEXT
1291334455.536847: wpa_driver_wext_set_key: alg=0 key_idx=5 set_tx=0 seq_len=0 key_len=0
1291334455.536911: Driver did not support SIOCSIWENCODEEXT
1291334455.536929: wpa_driver_wext_set_countermeasures
1291334455.544624: RSN: flushing PMKID list in the driver
1291334455.544712: State: DISCONNECTED -> INACTIVE
1291334455.544829: WPS: UUID based on MAC address - hexdump(len=16): 65 86 3e 36 18 13 57 3a b2 46 2f 88 c6 00 3e 7d
1291334455.578382: EAPOL: SUPP_PAE entering state DISCONNECTED
1291334455.578453: EAPOL: Supplicant port status: Unauthorized
1291334455.578472: EAPOL: KEY_RX entering state NO_KEY_RECEIVE
1291334455.578489: EAPOL: SUPP_BE entering state INITIALIZE
1291334455.578506: EAP: EAP entering state DISABLED
1291334455.578520: EAPOL: Supplicant port status: Unauthorized
1291334455.578593: EAPOL: Supplicant port status: Unauthorized
1291334455.578651: dbus: Register interface object '/fi/w1/wpa_supplicant1/Interfaces/1'
1291334455.581620: Added interface eth1
1291334455.593117: RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
1291334455.593209: RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
1291334455.593232: Wireless event: cmd=0x8b06 len=8
1291334455.593266: RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
1291334455.593281: RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
1291334455.593293: Wireless event: cmd=0x8b1a len=8
1291334455.593308: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1291334455.593322: RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
1291334455.593520: Setting scan request: 0 sec 0 usec
1291334455.594140: Setting scan request: 0 sec 0 usec
1291334455.606652: State: INACTIVE -> SCANNING
1291334455.607495: Starting AP scan for wildcard SSID
1291334455.608412: Scan requested (ret=0) - scan timeout 5 seconds
1291334455.613314: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1291334456.579602: EAPOL: disable timer tick
1291334456.579683: EAPOL: Supplicant port status: Unauthorized
1291334460.611650: Scan timeout - try to get results
1291334460.612052: Failed to get scan results
1291334460.612094: Failed to get scan results - try scanning again
1291334460.612116: State: SCANNING -> INACTIVE
1291334460.617024: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1291334476.003602: Setting scan request: 0 sec 0 usec
1291334476.003785: State: INACTIVE -> SCANNING
1291334476.003932: Starting AP scan for wildcard SSID
1291334476.004185: Scan requested (ret=-1) - scan timeout 5 seconds
1291334476.004357: Failed to initiate AP scan.
1291334476.004382: State: SCANNING -> INACTIVE
1291334476.004521: Setting scan request: 1 sec 0 usec
1291334476.009841: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1291334477.005651: No enabled networks - do not scan
1291334477.005733: State: INACTIVE -> INACTIVE
1291334481.007606: Scan timeout - try to get results
1291334481.007847: Failed to get scan results
1291334481.007875: Failed to get scan results - try scanning again
1291334481.007898: State: INACTIVE -> INACTIVE
1291334506.004852: Setting scan request: 0 sec 0 usec
1291334506.005044: State: INACTIVE -> SCANNING
1291334506.005195: Starting AP scan for wildcard SSID
1291334506.005410: Scan requested (ret=-1) - scan timeout 5 seconds
1291334506.005625: Failed to initiate AP scan.
1291334506.005658: State: SCANNING -> INACTIVE
1291334506.005802: Setting scan request: 1 sec 0 usec
1291334506.010377: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1291334507.006958: No enabled networks - do not scan
1291334507.007044: State: INACTIVE -> INACTIVE
1291334511.009583: Scan timeout - try to get results
1291334511.009804: Failed to get scan results
1291334511.009833: Failed to get scan results - try scanning again
1291334511.009855: State: INACTIVE -> INACTIVE
1291334546.002272: Setting scan request: 0 sec 0 usec
1291334546.002470: State: INACTIVE -> SCANNING
1291334546.002670: Starting AP scan for wildcard SSID
1291334546.002881: Scan requested (ret=-1) - scan timeout 5 seconds
1291334546.003050: Failed to initiate AP scan.
1291334546.003078: State: SCANNING -> INACTIVE
1291334546.003219: Setting scan request: 1 sec 0 usec
1291334546.007851: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1291334547.004375: No enabled networks - do not scan
1291334547.004460: State: INACTIVE -> INACTIVE
1291334551.005668: Scan timeout - try to get results
1291334551.005889: Failed to get scan results
1291334551.005919: Failed to get scan results - try scanning again
1291334551.005945: State: INACTIVE -> INACTIVE
1291334596.005083: Setting scan request: 0 sec 0 usec
1291334596.005289: State: INACTIVE -> SCANNING
1291334596.005440: Starting AP scan for wildcard SSID
1291334596.005688: Scan requested (ret=-1) - scan timeout 5 seconds
1291334596.005866: Failed to initiate AP scan.
1291334596.005929: State: SCANNING -> INACTIVE
1291334596.006074: Setting scan request: 1 sec 0 usec
1291334596.010628: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1291334597.007229: No enabled networks - do not scan
1291334597.007312: State: INACTIVE -> INACTIVE

--HcAYCG3uE/tztfnV--
