Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42691 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3FKE2K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 00:28:10 -0400
Received: by mail-oa0-f46.google.com with SMTP id h2so7067638oag.33
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jun 2013 21:28:09 -0700 (PDT)
Received: from FermiDesk (ip72-207-233-133.br.br.cox.net. [72.207.233.133])
        by mx.google.com with ESMTPSA id l4sm26500360obh.7.2013.06.10.21.28.08
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 10 Jun 2013 21:28:08 -0700 (PDT)
Date: Mon, 10 Jun 2013 23:28:01 -0500
From: Edward Seyler <epseyler@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Intel Centrino Wireless-N 2200 Tech Support
Message-ID: <20130611042801.GA217@FermiDesk> (sfid-20130611_062814_506831_D606E2F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am having difficulty using my Intel Centrino Wireless-N 2200 PCI-E wireless card.  The card is visible but cannot be set "up," either from "ip link" or wpa_supplicant.  I am using Arch Linux but have also observed this problem in Ubuntu 12.04 LTS.  I have downloaded the firmware from http://wireless.kernel.org/en/users/Drivers/iwlwifi and followed the instructions there on how to copy it into /lib/firmware.  Installing Arch Linux's "compat-drivers-patched" package had no effect.  Removing all other PCI/PCI-E devices had no effect.  My wired ethernet connection is fully functional.  Below is the output of several commands that may be relevant, all run as root.  Any assistance would be greatly appreciated.  Please let me know if I can provide any additional information.

Thank you,

Edward Seyler


# wpa_supplicant -i wlp3s0 -c /etc/wpa_supplicant/my_wpa.conf -D nl80211 -dd


wpa_supplicant v2.0
Successfully initialized wpa_supplicant
Initializing interface 'wlp3s0' conf '/etc/wpa_supplicant/my_wpa.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant/my_wpa.conf' -> '/etc/wpa_supplicant/my_wpa.conf'
Reading configuration file '/etc/wpa_supplicant/my_wpa.conf'
Line: 1 - start of a new network block
BSSID - hexdump(len=6): e0 46 9a 79 75 46
PSK - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid=''
nl80211: interface wlp3s0 in phy phy0
rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Subscribe to mgmt frames with non-AP handle 0x1b26740
nl80211: Register frame type=0xd0 nl_handle=0x1b26740
nl80211: Register frame match - hexdump(len=2): 04 0a
nl80211: Register frame type=0xd0 nl_handle=0x1b26740
nl80211: Register frame match - hexdump(len=2): 04 0b
nl80211: Register frame type=0xd0 nl_handle=0x1b26740
nl80211: Register frame match - hexdump(len=2): 04 0c
nl80211: Register frame type=0xd0 nl_handle=0x1b26740
nl80211: Register frame match - hexdump(len=2): 04 0d
nl80211: Register frame type=0xd0 nl_handle=0x1b26740
nl80211: Register frame match - hexdump(len=6): 04 09 50 6f 9a 09
nl80211: Register frame type=0xd0 nl_handle=0x1b26740
nl80211: Register frame match - hexdump(len=5): 7f 50 6f 9a 09
nl80211: Register frame type=0xd0 nl_handle=0x1b26740
nl80211: Register frame match - hexdump(len=1): 06
nl80211: Register frame type=0xd0 nl_handle=0x1b26740
nl80211: Register frame match - hexdump(len=2): 0a 07
nl80211: Register frame type=0xd0 nl_handle=0x1b26740
nl80211: Register frame match - hexdump(len=2): 0a 11
Could not set interface wlp3s0 flags (UP): Connection timed out
nl80211: Could not set interface 'wlp3s0' UP
netlink: Operstate: linkmode=0, operstate=6
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Unsubscribe mgmt frames handle 0x1b26740 (mode change)
wlp3s0: Failed to initialize driver interface
Failed to add interface wlp3s0
wlp3s0: Cancelling scan request
wlp3s0: Cancelling authentication timeout

(running this command, or ip link set wlp3s0 up, a second time causes the system to lock up)



# dmesg | grep iwl

[    9.868028] iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
[    9.942668] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
[   10.015848] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   10.015861] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   10.015866] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   10.015872] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   10.015877] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
[   10.015884] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Wireless-N 2200 BGN, REV=0x104
[   10.015912] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   10.056013] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[  280.878663] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[  280.886234] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0
[  285.886692] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[  285.886888] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[  285.887299] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
[  285.887516] iwlwifi 0000:03:00.0: Unable to initialize device.




# uname -a

Linux FermiDesk 3.9.5-1-ARCH #1 SMP PREEMPT Sat Jun 8 09:22:45 CEST 2013 x86_64 GNU/Linux



# lspci -vvv | tail -n 35

03:00.0 Network controller: Intel Corporation Centrino Wireless-N 2200 (rev c4)
	Subsystem: Intel Corporation Centrino Wireless-N 2200 BGN
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at efffe000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41d1
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 9c-4e-36-ff-ff-19-1a-8c
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi




# ip link

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
    link/ether bc:5f:f4:82:28:91 brd ff:ff:ff:ff:ff:ff
3: wlp3s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000
    link/ether 9c:4e:36:19:1a:8c brd ff:ff:ff:ff:ff:ff
4: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN mode DEFAULT qlen 100
    link/none 




# iwconfig


tun0      no wireless extensions.

enp0s7    no wireless extensions.

lo        no wireless extensions.

wlp3s0    IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          



# rfkill list all

0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no




# lsmod | grep iw

iwldvm                173046  0 
mac80211              495646  1 iwldvm
iwlwifi               143110  1 iwldvm
cfg80211              454778  3 iwlwifi,mac80211,iwldvm
compat                  1357  4 cfg80211,iwlwifi,mac80211,iwldvm
