Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48035 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab2IESBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 14:01:45 -0400
Received: by eekc1 with SMTP id c1so352365eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 11:01:44 -0700 (PDT)
Date: Wed, 5 Sep 2012 20:01:33 +0200
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce: activation problem with rtl8188ce pci card
Message-ID: <20120905200133.0333ca7f@destiny.ordissimo> (sfid-20120905_200150_041566_3915E49D)
In-Reply-To: <50478E10.6030808@lwfinger.net>
References: <20120905185510.2ab501cd@destiny.ordissimo>
	<50478E10.6030808@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/OVTihMSMQkjGQzZKiouoN3C"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--MP_/OVTihMSMQkjGQzZKiouoN3C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 05 Sep 2012 12:38:24 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :

> On 09/05/2012 11:55 AM, Anisse Astier wrote:
> > Hi,
> >
> > On a toshiba laptop (see dmesg attached), with a wireless-next kernel,
> > this card doesn't seem to turn on:
> > 01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller [10ec:8136] (rev 02)
> >
> 
> Unfortunately, the above is not a wireless device. It is your wired device.
Indeed. This is embarassing. The mail had a full lspci attachement
planned which was forgotten. See attached file.


> 
> > # modprobe rtl8192ce debug=4
> > [ 6184.995319] cfg80211: Calling CRDA to update world regulatory domain
> > [ 6185.103824] rtl8192ce: rtl8192ce: FW Power Save off (module option)
> 
> The above line is unexpected. Do you have a module option set in /etc/module.d/?
Yes. This is related to another problem, see:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/90954


New log with fwlps=1:

[   84.532629] cfg80211: Calling CRDA to update world regulatory domain
[   84.794759] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
[   85.038881] rtlwifi:rtl_fw_cb():<0-0> Firmware callback routine entered!
[   85.188013] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   85.195046] rtlwifi: wireless switch is on
[   85.346058] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
[   85.346677] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
[   85.346799] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
[   85.348064] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
[   85.348885] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
[   85.360848] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
[   85.738594] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:1
[   85.738699] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:1
[   85.738847] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:1
[   85.739089] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:1
[   85.739238] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:1
[   85.739385] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:1
[   85.739533] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:1
[   85.739680] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051e1b:1
[   85.739827] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:98053f15:0
[   85.740967] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
[   85.962468] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 0 GroupEncAlgorithm = 0
[   85.962483] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[   86.071504] rtl8192c_common:rtl92c_dm_initialize_txpower_tracking_thermalmeter():<0-0> pMgntInfo->txpower_tracking = 1
[   86.071520] rtlwifi:rtl_pci_start():<0-0> enable_interrupt OK
[   86.071528] rtlwifi:rtl_pci_start():<0-0> OK
[   86.072201] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[   86.072212] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[   86.072257] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[   86.091672] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[   86.091689] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[   86.091730] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[   86.091742] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[   86.092343] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_LISTEN_INTERVAL
[   86.092674] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_RETRY_LIMITS 4
[   86.102832] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[   86.102842] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[   86.114505] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   86.136118] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   86.170054] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   86.171709] rtl8192ce:rtl92ce_led_control():<10100-1> ledaction 5
[   86.451724] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   86.452711] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   86.540275] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   86.541418] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   86.594256] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   86.642615] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5

After modprobe -r:
[   86.913272] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   86.967129] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   86.968381] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[   87.025606] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[   87.025624] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[   87.044826] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[   87.044844] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[   87.044858] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[   87.044868] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
[   87.045020] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[   87.045029] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
[   88.970535] rtlwifi:rtl_ips_nic_off_wq_callback():<0-0> not station return



This one was harder to get because of the freeze when fwlps=1.


Anisse
--MP_/OVTihMSMQkjGQzZKiouoN3C
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=lspci-rtl8192ce-no-up.txt

06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8176] (rev 01)
	Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8212]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 3
	Region 0: I/O ports at 3000 [size=256]
	Region 2: Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 01-91-81-fe-ff-4c-e0-00
00: ec 10 76 81 07 00 10 00 01 00 80 02 10 00 00 00
10: 01 30 00 00 00 00 00 00 04 00 20 f0 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 ec 10 12 82
30: 00 00 00 00 40 00 00 00 00 00 00 00 03 01 00 00
40: 01 50 c3 ff 08 00 00 00 00 00 00 00 00 00 00 00
50: 05 70 80 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 00 02 00 c0 8c 00 10 10 20 10 00 11 3c 07 00
80: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--MP_/OVTihMSMQkjGQzZKiouoN3C--
