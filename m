Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43243 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab0CICho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 21:37:44 -0500
Received: by bwz1 with SMTP id 1so3468027bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 18:37:42 -0800 (PST)
Subject: RE: Athros wireless stopped working
From: Jim Ham <jimham@dslextreme.com>
Reply-To: Jimham@porcine.com
To: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-OLuUWUfU8LKnCF3QXa8w"
Date: Mon, 08 Mar 2010 18:37:35 -0800
Message-ID: <1268102255.10290.24.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OLuUWUfU8LKnCF3QXa8w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit


> The athros chip in my Fujitsu notebook as stopped working after an 
> update  (Debian squeeze) about a month ago. It uses the ath5k driver.
> uname -a returns Linux WideBook 2.6.32-trunk-amd64 #1 SMP Sun Jan 10
> 22:40:40 UTC 2010 x86_64 GNU/Linux
> 
> It appears that iwconfig can't set the essid and the password reliably.
> When I issue iwconfig ath0 I usually get garbage in the essid and
> password fields. This can be after setting both (with iwconfig)
> apparently successfully.
> 
> This notebook is dual boot so I know that the hardware is working. 
> 
> I have put some debug output in the wireless-tools script in if-pre-up.d
> so that I can see that the essid and password fields seem to 'take' for
> a short time, then revert to garbage.
> 
> Does any of this sound familiar? Is this a known problem?
> 
> Regards,
> 
> Jim Ham
> 
I've attached the modified
script /etc/network/if-pre-up.d/wireless-tools. I added a couple of echo
statements to the script to make sure that the environmental variables
were being passed correctly. Then I added two instances of "iwconfig
ath0" at the bottom of the script. I then created an new
script /etc/network/if-pre-up.d/zz that only contains the command
iwconfig ath0.

Here is the result of an ifdown followed by an ifup:

WideBook:/etc/network# ifdown ath0
There is already a pid file /var/run/dhclient.ath0.pid with pid 7879
killed old client process, removed PID file
Internet Systems Consortium DHCP Client V3.1.3
Copyright 2004-2009 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

Listening on LPF/ath0/00:1b:9e:56:b1:27
Sending on   LPF/ath0/00:1b:9e:56:b1:27
Sending on   Socket/fallback
DHCPRELEASE on ath0 to 192.168.0.1 port 67
Reloading /etc/samba/smb.conf: smbd only.

WideBook:/etc/network# ifup ath0
iface ath0
wireless_key abcd-ef01-2345-6789-abcd-ef01-23
essid PorcineAssociates
eval /sbin/iwconfig ath0 key abcd-ef01-2345-6789-abcd-ef01-23
/sbin/iwconfig ath0 essid PorcineAssociates
ath0      IEEE 802.11abg  ESSID:"PorcineAssociates"  
          Mode:Managed  Frequency:2.417 GHz  Access Point:
Not-Associated   
          Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:ABCD-EF01-2345-6789-ABCD-EF01-23
          Power Management:off
          
ath0      IEEE 802.11abg  ESSID:")\x9E\xDD\xB1\xF2<#\xC6\x05\x988
\x9B;Xbs\xB6=\xE0\x8ARk\xDBb\xFEA\xBE\xDB\xBBO\x8F\xE5"  
          Mode:Managed  Frequency:2.417 GHz  Access Point:
Not-Associated   
          Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:ABCD-EF01-2345-6789-ABCD-EF01-23
          Power Management:off
          
ath0      IEEE 802.11abg  ESSID:")\x9E\xDD\xB1\xF2<#\xC6\x05\x988
\x9B;Xbs\xB6=\xE0\x8ARk\xDBb\xFEA\xBE\xDB\xBBO\x8F\xE5"  
          Mode:Managed  Frequency:2.417 GHz  Access Point:
Not-Associated   
          Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
Internet Systems Consortium DHCP Client V3.1.3
Copyright 2004-2009 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

Listening on LPF/ath0/00:1b:9e:56:b1:27
Sending on   LPF/ath0/00:1b:9e:56:b1:27
Sending on   Socket/fallback
DHCPDISCOVER on ath0 to 255.255.255.255 port 67 interval 5
DHCPDISCOVER on ath0 to 255.255.255.255 port 67 interval 6
DHCPDISCOVER on ath0 to 255.255.255.255 port 67 interval 7
DHCPDISCOVER on ath0 to 255.255.255.255 port 67 interval 8
DHCPDISCOVER on ath0 to 255.255.255.255 port 67 interval 11
DHCPDISCOVER on ath0 to 255.255.255.255 port 67 interval 12
DHCPDISCOVER on ath0 to 255.255.255.255 port 67 interval 12
No DHCPOFFERS received.
No working leases in persistent database - sleeping.
Starting portmap daemon...Already running..
Starting NFS common utilities: statd.
WideBook:/etc/network# 

What I have discovered is that if the ESSID is not active, iwconfig sets
it correctly and it sticks. If the ESSID is one that is locally present,
iwconfig seems to set it, but it almost immediately reverts to garbage.
For instance if I issue the command:
iwconfig ath0 essid PorcineAssociate
All works. Here is an example:

WideBook:/etc/network# iwconfig  ath0  essid PorcineAssociate
WideBook:/etc/network# iwconfig ath0
ath0      IEEE 802.11abg  ESSID:"PorcineAssociate"  
          Mode:Managed  Frequency:2.417 GHz  Access Point:
Not-Associated   
          Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
WideBook:/etc/network# iwconfig  ath0  essid PorcineAssociates
WideBook:/etc/network# iwconfig ath0
ath0      IEEE 802.11abg  ESSID:"\xEDl\x96\xDF\xA9\xB9\xA5\xAER\xDEI
\x8D6\xAB\x00\xEC\xE9\xE1w;LR\x9DJ\x93[%N\xAA\xB43\x97"  
          Mode:Managed  Frequency:2.417 GHz  Access Point:
Not-Associated   
          Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
WideBook:/etc/network# 

PorcineAssociates exists and is my local network ID. PorcineAssociate
does not exist. I have repeated this experiment with my neighbors
network names and I observe the same thing: if the network exists, the
name changes to garbage after a short time.

Here's the Athros entry from lspic -vv:

07:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless
Network Adapter (rev 01)
	Subsystem: Fujitsu Limited. Device 139c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fe2f0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [90] MSI-X: Enable- Count=1 Masked-
		Vector table: BAR=0 offset=00000000
		PBA: BAR=0 offset=00000000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntrySize=0
		Arb:	Fixed- WRR32- WRR64- WRR128- 100ns- - - onfig- TableOffset=0
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256- Fixed- RR32-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: ath5k

It's all very confusing to me!

Regards,

Jim Ham


 
> 
> 

--=-OLuUWUfU8LKnCF3QXa8w
Content-Type: application/x-shellscript; name="wireless-tools"
Content-Disposition: attachment; filename="wireless-tools"
Content-Transfer-Encoding: 7bit

#!/bin/sh

IWCONFIG=/sbin/iwconfig

if [ ! -x $IWCONFIG ]; then
  exit 0
fi

if [ -n "$IF_WIRELESS_SENS" ]; then
  $IWCONFIG "$IFACE" sens $IF_WIRELESS_SENS
fi

if [ -n "$IF_WIRELESS_MODE" ]; then
  $IWCONFIG "$IFACE" mode $IF_WIRELESS_MODE
fi

if [ -n "$IF_WIRELESS_AP" ]; then
  $IWCONFIG "$IFACE" ap $IF_WIRELESS_AP
fi

if [ -n "$IF_WIRELESS_RATE" ]; then
  $IWCONFIG "$IFACE" rate $IF_WIRELESS_RATE
fi

if [ -n "$IF_WIRELESS_RTS" ]; then
  $IWCONFIG "$IFACE" rts $IF_WIRELESS_RTS
fi

if [ -n "$IF_WIRELESS_FRAG" ]; then
  $IWCONFIG "$IFACE" frag $IF_WIRELESS_FRAG
fi

if [ -n "$IF_WIRELESS_POWER" ]; then
  $IWCONFIG "$IFACE" power $IF_WIRELESS_POWER
fi

if [ -n "$IF_WIRELESS_POWERPERIOD" ]; then
  $IWCONFIG "$IFACE" power period $IF_WIRELESS_POWERPERIOD
fi

if [ -n "$IF_WIRELESS_POWERTIMEOUT" ]; then
  $IWCONFIG "$IFACE" power timeout $IF_WIRELESS_POWERTIMEOUT
fi

if [ -n "$IF_WIRELESS_TXPOWER" ]; then
  $IWCONFIG "$IFACE" txpower $IF_WIRELESS_TXPOWER
fi

if [ -n "$IF_WIRELESS_RETRY" ]; then
  $IWCONFIG "$IFACE" retry $IF_WIRELESS_RETRY
fi

if [ -n "$IF_WIRELESS_ENC" ]; then
  eval $IWCONFIG "$IFACE" enc $IF_WIRELESS_ENC
fi
echo iface $IFACE
echo wireless_key $IF_WIRELESS_KEY
echo essid $IF_WIRELESS_ESSID
if [ -n "$IF_WIRELESS_KEY" ]; then
  eval $IWCONFIG "$IFACE" key $IF_WIRELESS_KEY
  echo eval $IWCONFIG "$IFACE" key $IF_WIRELESS_KEY
fi

if [ -n "$IF_WIRELESS_KEY1" ]; then
  $IWCONFIG "$IFACE" key [1] "$IF_WIRELESS_KEY1"
fi

if [ -n "$IF_WIRELESS_KEY2" ]; then
  $IWCONFIG "$IFACE" key [2] "$IF_WIRELESS_KEY2"
fi

if [ -n "$IF_WIRELESS_KEY3" ]; then
  $IWCONFIG "$IFACE" key [3] "$IF_WIRELESS_KEY3"
fi

if [ -n "$IF_WIRELESS_KEY4" ]; then
  $IWCONFIG "$IFACE" key [4] "$IF_WIRELESS_KEY4"
fi

if [ -n "$IF_WIRELESS_DEFAULTKEY" ]; then
  $IWCONFIG "$IFACE" key ["$IF_WIRELESS_DEFAULTKEY"]
fi

if [ -n "$IF_WIRELESS_KEYMODE" ]; then
  $IWCONFIG "$IFACE" key "$IF_WIRELESS_KEYMODE"
fi

if [ -n "$IF_WIRELESS_FREQ" ]; then
  $IWCONFIG "$IFACE" freq $IF_WIRELESS_FREQ
fi

if [ -n "$IF_WIRELESS_CHANNEL" ]; then
  $IWCONFIG "$IFACE" channel $IF_WIRELESS_CHANNEL
fi

if [ -n "$IF_WIRELESS_NICK" ]; then
  $IWCONFIG "$IFACE" nick "$IF_WIRELESS_NICK"
fi

if [ -n "$IF_WIRELESS_NWID" ]; then
  $IWCONFIG "$IFACE" nwid "$IF_WIRELESS_NWID"
fi

if [ -n "$IF_WIRELESS_ESSID" ]; then
  $IWCONFIG "$IFACE" essid "$IF_WIRELESS_ESSID"
  echo $IWCONFIG "$IFACE" essid "$IF_WIRELESS_ESSID"
fi

if [ -n "$IF_WIRELESS_COMMIT" ]; then
  $IWCONFIG "$IFACE" commit
fi

iwconfig ath0
iwconfig ath0
--=-OLuUWUfU8LKnCF3QXa8w
Content-Type: application/x-shellscript; name="zz"
Content-Disposition: attachment; filename="zz"
Content-Transfer-Encoding: 7bit

#!/bin/sh

iwconfig ath0
--=-OLuUWUfU8LKnCF3QXa8w--

