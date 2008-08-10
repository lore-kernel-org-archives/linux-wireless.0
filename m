Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:32705 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYHJIm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 04:42:56 -0400
Received: from agathe (dslb-084-057-007-136.pools.arcor-ip.net [84.57.7.136])
	by post.webmailer.de (fruni mo23) (RZmta 16.47)
	with ESMTP id I02112k7A8b2zz for <linux-wireless@vger.kernel.org>;
	Sun, 10 Aug 2008 10:42:54 +0200 (MEST)
	(envelope-from: <postfix@au-79.de>)
Received: from localhost (agathe [127.0.0.1])
	by agathe (Postfix) with ESMTP id 49C301BFE2
	for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2008 10:42:53 +0200 (CEST)
Received: from agathe ([127.0.0.1])
	by localhost (agathe.au-79.intra [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3nRgf7bJOmlG for <linux-wireless@vger.kernel.org>;
	Sun, 10 Aug 2008 10:42:47 +0200 (CEST)
Received: from [192.168.23.124] (sixtus.au-79.intra [192.168.23.124])
	by agathe (Postfix) with ESMTP id 9AC5E1BFC3
	for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2008 10:42:47 +0200 (CEST)
Message-ID: <489EAA04.8070203@au-79.de> (sfid-20080810_104317_369182_9B80DF20)
Date: Sun, 10 Aug 2008 10:42:44 +0200
From: Robert Goldner <postfix@au-79.de>
Reply-To: postfix@au-79.de
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems with Belkin F5D7010 PCMCIA 1799:701f while trying WPA connection
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I want to get a wpa-connection running with a belkin F5D7010 PCMCIA card 
(pci-id: 1799:701f).
I tryed every kernel from 2.6.22 (self compiled, but wlan and WPA 
running well with other cards). Now I use 2.6.27-rc2


lspci -vvvv
06:00.0 Ethernet controller: Belkin Unknown device 701f (rev 20)
         Subsystem: Belkin Unknown device 701f
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR+
         Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 9
         Region 0: I/O ports at 1800 [size=256]
         Region 1: Memory at 2c000000 (32-bit, non-prefetchable)
[size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [60] Vital Product Data


dmesg while plug-in of the card:
pccard: CardBus card inserted into slot 1
pci 0000:06:00.0: supports D1
pci 0000:06:00.0: supports D2
pci 0000:06:00.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:06:00.0: PME# disabled
rtl8180 0000:06:00.0: enabling device (0000 -> 0003)
rtl8180 0000:06:00.0: PCI INT A -> Link[LNKB] -> GSI 9 (level, low) -> IRQ 9
rtl8180 0000:06:00.0: setting latency timer to 64
phy2: Selected rate control algorithm 'pid'
phy2: hwaddr 00:17:3f:30:49:d4, RTL8185vD + rtl8225z2

iwconfig:
wlan0     IEEE 802.11bg  ESSID:""
           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
           Tx-Power=27 dBm
           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
           Encryption key:off
           Power Management:off
           Link Quality:0  Signal level:0  Noise level:0
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0


everything seems to be ok.

But starting wpa-supplicant with

wpa_supplicant -i wlan0 -d -c /etc/wpa_supplicant/test.conf

I get the following output:
Initializing interface 'wlan0' conf '/etc/wpa_supplicant/test.conf' 
driver 'default' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant/test.conf' -> 
'/etc/wpa_supplicant/test.conf'
Reading configuration file '/etc/wpa_supplicant/test.conf'
Priority group 0
    id=0 ssid='my_secrect_ssid'
Initializing interface (2) 'wlan0'
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
   capabilities: key_mgmt 0xf enc 0xf flags 0x0
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:17:3f:30:49:d4
wpa_driver_wext_set_wpa
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
wpa_driver_wext_set_drop_unencrypted
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
State: DISCONNECTED -> SCANNING
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=8):
      64 69 64 65 6c 64 75 6d                           dideldum
Trying to get current scan results first without requesting a new scan 
to speed up initial association
Received 0 bytes of scan results (0 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 5 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b19 len=8
Received 0 bytes of scan results (0 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
EAPOL: disable timer tick
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=8):
      64 69 64 65 6c 64 75 6d                           dideldum
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b19 len=8
Received 0 bytes of scan results (0 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b19 len=8
Received 0 bytes of scan results (0 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=8):
      64 69 64 65 6c 64 75 6d                           dideldum
Scan requested (ret=0) - scan timeout 30 seconds
...
...
...

The config-file is running well with a rt73, rtl8187 and a b43 card. So 
it seems, that the pcmcia-card itself is the problem.



Any hints?

Best regards

Robert

P.S. wpa-supplicant is 0.6.4, wireless-tools are 29-1 from debian lenny.
