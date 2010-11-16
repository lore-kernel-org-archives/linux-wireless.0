Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout028.mac.com ([17.148.16.103]:57388 "EHLO
	asmtpout028.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433Ab0KPHxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 02:53:23 -0500
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from [192.168.1.100] ([87.201.169.183])
 by asmtp028.mac.com (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep
 26 2008; 64bit)) with ESMTPSA id <0LBY001IITRH4P90@asmtp028.mac.com> for
 linux-wireless@vger.kernel.org; Mon, 15 Nov 2010 22:52:49 -0800 (PST)
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: Android 2.2/2.2.1 wifi not working after restart with driver-awext
Date: Tue, 16 Nov 2010 10:52:08 +0400
Message-id: <0604E650-C4CD-40FF-ACC6-262E555C8194@mac.com>
To: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
        I'm currently facing with wifi not working after restarting it from the android 2.2/2.2.1 settings wifi control panel.

I applied the driver-awext.c patch and I'm using wpa_supplicant 0.5.x with a Ralink RT3070USB wifi module. 

When I first connect wifi, it can scan the AP and obtain its SSID. 

My AP is secured so I type the WPA key and it obtains the IP address and works when I try to use the browser. 

If I Turn Off Wifi from the settings control panel and turn it back on, it cannot connect. 

Is it because the SIOCGIWSTATS ioctl is not implemented in the Ralink driver? 

The strange thing is that it obtains the SSID and connects to it in the first place, but doesn't working on restarting wifi.

SCAN done, resume MSDU transmission ...
CNTL - BSSID not found. reply NDIS_STATUS_NOT_ACCEPTED
CNTL - BSSID not found. start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AYNC - InvalidStateWhenScan(state=2). Reset SYNC machine
SCAN done, resume MSDU transmission ...
===> rt28xx_close

V/WifiMonitor(  969): Event [CTRL-EVENT-STATE-CHINFO::Network is down!
ANGE id=0 state=0]
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCSIWSCAN]: Network is down
V/WifiStateTracker(  969): Changing supplicant state: ASSOCIATING ==> DISCONNECTED
V/WifiMonitor(  969): Event [CTRL-EVENT-STATE-CHANGE id=-1 state=2]
V/WifiStateTracker(  969): Changing supplicant state: DISCONNECTED ==> SCANNING
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSTATS]: Operation not supported on transport endpoint
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWRATE]: Network is down
rt28xx_get_wireless_stats --->
INFO::Network is down!
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSTATS]: Operation not supported on transport endpoint
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWRATE]: Network is down
D/dalvikvm( 1198): GC_FOR_MALLOC freed 9817 objects / 545496 bytes in 62ms hsize: 16777216
INFO::Network is down!
INFO::Network is down!
D/WifiStateTracker(  969): Reset connections and stopping DHCP
W/wpa_supplicant( 1397): Failed to initiate AP scan.
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSCAN]: Network is down
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCSIWSCAN]: Network is down
D/WifiStateTracker(  969): Disabling interface
D/NetworkStateTracker(  969): setDetailed state, old =CONNECTING and new state=DISCONNECTED
rt28xx_get_wireless_stats --->
INFO::Network is down!
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSTATS]: Operation not supported on transport endpoint
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWRATE]: Network is down
D/ConnectivityService(  969): ConnectivityChange for WIFI: DISCONNECTED/DISCONNECTED
D/DataConnectionTracker( 1056): enableApnType(default), isApnTypeActive = false and state = IDLE
D/DataConnectionTracker( 1056): type not available
D/ConnectivityService(  969): getMobileDataEnabled returning true
D/Tethering(  969): Tethering got CONNECTIVITY_ACTION
D/Tethering(  969): MasterInitialState.processMessage what=3
E/HierarchicalStateMachine(  969): TetherMaster - unhandledMessage: msg.what=3
INFO::Network is down!
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSCAN]: Network is down
INFO::Network is down!
W/wpa_supplicant( 1397): Failed to initiate AP scan.
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCSIWSCAN]: Network is down
D/dalvikvm( 1152): GC_EXPLICIT freed 1525 objects / 69984 bytes in 45ms hsize: 16777216



The full log from start to finish (start wifi, browse, stop wifi and restart) is given below:


I/WifiHW  (  969): Loading WiFi modules
I/WifiHW  (  969): WIFI DRIVER_MODULE_NAME		:= rt3070sta,
I/WifiHW  (  969): WIFI DRIVER_MODULE_TAG		:= rt3070sta ,
I/WifiHW  (  969): WIFI DRIVER_MODULE_PATH		:= /system/lib/modules/rt3070sta.ko,
E/WifiHW  (  969): driver rt3070sta  has NOT been installed
rtusb init --->
===>rt2870_probe()!
--> RTMPAllocAdapterBlock


=== pAd = d0962000, size = 500648 ===

<-- RTMPAllocAdapterBlock, Status=0
NumEndpoints=7
BULK IN MaxPacketSize = 512
EP address = 0x81
BULK OUT MaxPacketSize = 512
EP address = 0x 1  
BULK OUT MaxPacketSize = 512
EP address = 0x 2  
BULK OUT MaxPacketSize = 512
EP address = 0x 3  
BULK OUT MaxPacketSize = 512
EP address = 0x 4  
BULK OUT MaxPacketSize = 512
EP address = 0x 5  
BULK OUT MaxPacketSize = 512
EP address = 0x 6  
STA Driver version-2.3.0.4
NVM is EEPROM
Allocate a net device with private data size=0!
Allocate net device ops success!
The name of the new wlan interface is wlan0...
RtmpOSNetDevAttach()--->
<---RtmpOSNetDevAttach(), ret=0
<===rt2870_probe()!
D/Tethering(  969): wlan0 is not a tetherable iface, ignoring
usbcore: registered new interface driver rt2870
Allocate 8192 memory for BA reordering
MAC_CSR0  [ Ver:Rev=0x30700201]
<=== RtmpAsicLoadFirmware (status=0)
--> RTMPAllocTxRxRingMemory
--> NICInitTransmit
MGMT Ring: total 32 entry allocated
<-- NICInitTransmit(Status=0)
--> NICInitRecv
<-- NICInitRecv(Status=0)
<-- RTMPAllocTxRxRingMemory, Status=0
--> MLME Initialize
<-- MLME Initialize
--> UserCfgInit
--> UserCfgInit. BACapability = 0x3024040
<-- UserCfgInit
--> NICInitializeAdapter
<== DMA offset 0x208 = 0x0
--> NICInitializeAsic
MAC_CSR0  [ Ver:Rev=0x30700201]
-->RTUSBVenderReset
<--RTUSBVenderReset
BBP version = 60
--->Disable TSF synchronization
<-- NICInitializeAsic
<-- NICInitializeAdapter
1. Phy Mode = 0
2. Phy Mode = 0
--> NICReadEEPROMParameters
--> E2PROM_CSR = 0x20408
--> EEPROMAddressNum = 6
Initialize MAC Address from E2PROM 
E2PROM MAC: =00:08:10:74:b5:da
Use the MAC address what is assigned from EEPROM. 
Current MAC: =00:08:10:74:b5:da
E2PROM: Version = 1, FAE release #1
NICReadEEPROMParameters: RxPath = 1, TxPath = 1
Chip specific bbpRegTbSize=0!
E2PROM: G Tssi[-4 .. +4] = 255 255 255 255 - 255 -255 255 255 255, step=255, tuning=0
E2PROM: A Tssi[-4 .. +4] = 0 0 0 0 - 0 -0 0 0 0, step=0, tuning=0
E2PROM: RF FreqOffset=0x29 
RTMPSetPhyMode : PhyMode=0, channel=0 
country code=128/128, RFIC=5, PHY mode=0, support 11 channels
BuildChannel # 1 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 2 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 3 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 4 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 5 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 6 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 7 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 8 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 9 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 10 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 11 :: Pwr0 = 16, Pwr1 =5, 
 RTMPSetPhyMode: channel is out of range, use first channel=1 
Txpower per Rate
Gpwrdelta = 0, Apwrdelta = 0 .
20MHz BW, 2.4G band-aaaa6666,  Adata = aaaa6666,  Gdata = aaaa6666 
20MHz BW, 2.4G band-aaaa6688,  Adata = aaaa6688,  Gdata = aaaa6688 
20MHz BW, 2.4G band-aaaa6688,  Adata = aaaa6688,  Gdata = aaaa6688 
20MHz BW, 2.4G band-aaaa6688,  Adata = aaaa6688,  Gdata = aaaa6688 
20MHz BW, 2.4G band-ffff6688,  Adata = ffff6688,  Gdata = ffff6688 
<-- NICReadEEPROMParameters
3. Phy Mode = 0
--> NICInitAsicFromEEPROM
AsicSetRxAnt, switch to main antenna
RTMPFilterCalibration - CaliBW20RfR24=0xa, CaliBW40RfR24=0x28
RTMPSetLED::Mode=1,HighByte=0x20,LowByte=0x01
Use Hw Radio Control Pin=0; if used Pin=0;
TxPath = 1, RxPath = 1, RFIC=5, Polar+LED mode=1
<-- NICInitAsicFromEEPROM
RTMPSetPhyMode : PhyMode=0, channel=1 
country code=128/128, RFIC=5, PHY mode=0, support 11 channels
BuildChannel # 1 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 2 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 3 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 4 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 5 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 6 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 7 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 8 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 9 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 10 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 11 :: Pwr0 = 16, Pwr1 =5, 
 MCS Set = 00 00 00 00 00
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
NDIS_STATUS_MEDIA_DISCONNECT Event B!
RTUSBBulkReceive!
<==== rt28xx_init, Status=0
==> RTMPEnableRxTx
<== WRITE DMA offset 0x208 = 0x45
<== RTMPEnableRxTx
0x1300 = 00073200
STAMlmePeriodicExec():CNTL - ScanTab.BssNr==0, start a new ACTIVE scan SSID[]
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
I/WifiHW  (  969): Wi-Fi is runnAsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
ing
D/WifiService(  969): ACTION_BATTERY_CHANGED pluggedType: 1
I/WifiHW  (  969): Interface directory = /data/system/wpa_supplicant
I/WifiHW  (  969): Interface name = /data/system/wpa_supplicant/wlan0
E/WifiHW  (  969): Unable to open connection to supplicant on "/data/system/wpa_supplicant/wlan0": No such file or directory
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
===> rt_ioctl_siwpmksa
rt_ioctl_siwpmksa - IW_PMKSA_FLUSH
===>Set_NetworkType_Proc::(INFRA)
Set_NetworkType_Proc::(NetworkType=1)
===>rt_ioctl_giwrange
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
rt_ioctl_siwauth::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = 1)
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #0 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8001)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #1 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8002)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #2 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8003)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #3 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8004)
rt_ioctl_siwauth::IW_AUTH_WPA_VERSION - param->value = 1!
rt_ioctl_giwscan:: Still scanning
I/wpa_supplicant( 1292): CTRL-EVENT-STATE-CHANGE id=-1 state=2
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
I/power   (  969): *** set_screert_ioctl_giwscan:: Still scanning
n_state 1
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
rt_ioctl_giwscan:: Still scanning
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
rt_ioctl_giwscan:: Still scanning
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
===>rt_ioctl_giwscan. 1(1) BSS returned, data->length = 200
SCANNING, suspend MSDU transmission ...
I/wpa_supplicant( 1292): CTRL-EVSYNC - BBP R4 to 20MHz.l
ENT-SCAN-RESULTS  Ready
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
I/WifiHW  (  969): Interface directory = /data/system/wpa_supplicant
I/WifiHW  (  969): Interface name = /data/system/wpa_supplrt28xx_get_wireless_stats --->
icant/wlan0
I/WifiHW  (  969): <--- rt28xx_get_wireless_stats
connect to supplicant done
V/WifiStateTracker(  969): Connection to supplicant established, state=SCANNING
D/NetworkStateTracker(  969): setDetailed state, old =IDLE and new state=SCANNING
D/ConnectivityService(  969): ConnectivityChange for WIFI: DISCONNECTED/SCANNING
D/ConnectivityService(  969): getMobileDataEnabled returning true
D/DataConnectionTracker( 1056): enableApnType(default), isApnTypeActive = false and state = IDLE
D/DataConnectionTracker( 1056): type not available
D/Tethering(  969): Tethering got CONNECTIVITY_ACTION
D/Tethering(  969): MasterInitialState.processMessage what=3
E/HierarchicalStateMachine(  969): TetherMaster - unhandledMessage: msg.what=3
===>rt_ioctl_giwscan. 1(1) BSS returned, data->length = 200
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
I/wpa_supplicant( 1292): CTRL-EVENT-STATE-CHANGE id=-1 state=1
V/WifiMonitor(  969): Event [CTRL-EVENT-STATE-CHANGE id=-1 state=1]
V/WifiStateTracker(  969): Changing supplicant state: SCANNING ==> INACTIVE
D/NetworkStateTracker(  969): setDetailed state, old =SCANNING and new state=IDLE
D/ConnectivityService(  969): Dropping ConnectivityChange for WIFI: DISCONNECTED/IDLE
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[02]
SCAN done, resume MSDU transmission ...
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/ActivityManager(  969): Starting activity: Intent { act=android.intent.action.MAIN cmp=com.android.settings/.wifi.WifiSettings }
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 2 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
!!! reset MLME state machine !!!
MlmeRestartStateMachine 
!!! MLME busy, reset MLME state machine !!!
I/wpa_supplicant( 1292): CTRL-EVENT-STATE-CHANGE id=-1 state=2
V/WifiMonitor(  969): Event [CTRAsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
L-EVENT-STATE-CHANGE id=-1 state=2]
V/WifiStateTracker(  969): Changing supplicant state: INACTIVE =SCAN done, resume MSDU transmission ...
=> SCANNING
D/NetworkStateTracker(  969): seSCANNING, suspend MSDU transmission ...
tDetailed state, old =IDLE and new state=SCANNING
SYNC - BBP R4 to 20MHz.l
D/ConnectivityService(  969): Dropping ConnectivityChange for WIFI: DISCONNECTED/SCANNING
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
I/dalvikvm(  969): Jit: resizing JitTable from 4096 to 8192
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
I/ActivityManager(  969): Displayed activity com.android.settings/.wifi.WifiSettings: 539 ms (total 539 ms)
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[02]
SCAN done, resume MSDU transmission ...
===>rt_ioctl_giwscan. 2(2) BSS returned, data->length = 324
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 2 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
!!! MLME busy, reset MLME state machine !!!
!!! reset MLME state machine !!!
MlmeRestartStateMachine 
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SCAN done, resume MSDU transmission ...
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[02]
SCAN done, resume MSDU transmission ...
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/ARMAssembler(  969): generated scanline__00000077:03515104_00000000_00000000 [ 33 ipp] (47 ins) at [0x2bd2e8:0x2bd3a4] in 244141 ns
===>rt_ioctl_giwscan. 2(2) BSS returned, data->length = 324
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
D/dalvikvm( 1198): GC_FOR_MALLOC freed 5597 objects / 289872 bytes in 57ms hsize: 16777216
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 2 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
!!! reset MLME state machine !!!
MlmeRestartStateMachine 
!!! MLME busy, reset MLME state machine !!!
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SCAN done, resume MSDU transmission ...
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
D/dalvikvm( 1048): GC_FOR_MALLOC freed 4230 objects / 265728 bytes in 130ms hsize: 16777216
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
D/dalvikvm( 1048): GC_EXTERNAL_ALLOC freed 886 objects / 39280 bytes in 72ms hsize: 16777216
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[02]
SCAN done, resume MSDU transmission ...
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
===>rt_ioctl_giwscan. 2(2) BSS returned, data->length = 324
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
W/KeyCharacterMap( 1198): No keyboard for id 0
W/KeyCharacterMap( 1198): Using default keymap: /system/usr/keychars/qwerty.kcm.bin
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 2 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
!!! reset MLME state machine !!!
MlmeRestartStateMachine 
!!! MLME busy, reset MLME state machine !!!
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SCAN done, resume MSDU transmission ...
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[02]
SCAN done, resume MSDU transmission ...
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
E/NetworkManagmentService(  969): Unexpected response code 600
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
===>rt_ioctl_giwscan. 2(2) BSS returned, data->length = 324
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 2 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
!!! MLME busy, reset MLME state machine !!!
!!! reset MLME state machine !!!
MlmeRestartStateMachine 
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SCAN done, resume MSDU transmission ...
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[02]
SCAN done, resume MSDU transmission ...
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
===>rt_ioctl_giwscan. 2(2) BSS returned, data->length = 324
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 2 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
!!! reset MLME state machine !!!
!!! MLME busy, reset MLME state machine !!!
MlmeRestartStateMachine 
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SCAN done, resume MSDU transmission ...
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screeAsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
n_state 1
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[02]
SCAN done, resume MSDU transmission ...
I/power   (  969): *** set_screen_state 1
D/dalvikvm(  969): GC_FOR_MALLOC freed 9018 objects / 478800 bytes in 98ms hsize: 16777216
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
===>rt_ioctl_giwscan. 2(2) BSS returned, data->length = 324
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
CntlOidSsidProc():CNTL - 0 BSS of 2 BSS match the desire (0)SSID - 
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
!!! reset MLME state machine !!!
!!! MLME busy, reset MLME state machine !!!
MlmeRestartStateMachine 
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SCAN done, resume MSDU transmission ...
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
!!! reset MLME state machine !!!
MlmeRestartStateMachine 
!!! MLME busy, reset MLME state machine !!!
I/wpa_supplicant( 1292): CTRL-EVENT-STATE-CHANGE id=-1 state=2
V/WifiMonitor(  969): Event [CTRAsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
L-EVENT-STATE-CHANGE id=-1 state=2]
SCAN done, resume MSDU transmission ...
V/WifiStateTracker(  969): ChangSCANNING, suspend MSDU transmission ...
ing supplicant state: SCANNING ==> SCANNING
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
I/dalvikvm( 1198): Jit: resizing JitTable from 4096 to 8192
===>rt_ioctl_giwscan. 1(1) BSS returned, data->length = 200
I/wpa_supplicant( 1292): CTRL-EVrt_ioctl_siwauth::IW_AUTH_80211_AUTH_ALG - param->value = 1!
ENT-SCAN-RESULTS  Ready
rt_ioctl_siwauth::IW_AUTH_WPA_VERSION - param->value = 1!
I/wpa_supplicant( 1292): Trying ===>Set_NetworkType_Proc::(INFRA)
to associate with 68:7f:74:1c:e4Set_NetworkType_Proc::(NetworkType=1)
:7c (SSID='Olympus2' freq=2437 M===> rt_ioctl_siwgenie
Hz)
I/wpa_supplicant( 1292): CTrt_ioctl_siwauth::IW_AUTH_WPA_VERSION - param->value = 4!
RL-EVENT-STATE-CHANGE id=-1 statrt_ioctl_siwauth::IW_AUTH_CIPHER_PAIRWISE - param->value = 8!
e=3
rt_ioctl_siwauth::IW_AUTH_CIPHER_GROUP - param->value = 4!
rt_ioctl_siwauth::IW_AUTH_KEY_MGMT - param->value = 2!
rt_ioctl_siwauth::IW_AUTH_PRIVACY_INVOKED - param->value = 1!
==>rt_ioctl_siwfreq::SIOCSIWFREQ[cmd=0x8b04] (Channel=1)
Set_SSID_Proc::(Len=8,Ssid=Olympus2)
CntlOidSsidProc():CNTL - 1 BSS of 1 BSS match the desire (8)SSID - Olympus2
IOCTL::SIOCSIWAP 68:7f:74:1c:e4:7c
CNTL - iterate BSS 0 of 1
SYNC - MlmeJoinReqAction(BSS #0)
SYNC - BBP R4 to 20MHz.l
V/WifiMonitor(  969): Event [Trying to associate with 68:7f:74:1AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
c:e4:7c (SSID='Olympus2' freq=2437 MHz)]
SYNC - Switch to ch 6, Wait BEACON from 68:7f:74:1c:e4:7c
V/WifiMonitor(  969): Event [CTRL-EVENT-STATE-CHANGE id=-1 state=3]
V/WifiStateTracker(  969): Changing supplicant state: SCANNING ==> ASSOCIATING
SYNC - receive desired BEACON at JoinWaitBeacon... Channel = 6
MlmeAux.ExtCapInfo=0
RTMPUpdateMlmeRate ==>   MlmeTransmit = 0x0  
SYNC - after JOIN, SupRateLen=8, ExtRateLen=4
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
!!! 20MHz !!! 
D/NetworkStateTracker(  969): seAUTH - Send AUTH request seq#1 (Alg=0)...
tDetailed state, old =SCANNING and new state=CONNECTING
AUTH - Receive AUTH_RSP seq#2 to me (Alg=0, Status=0)
D/ConnectivityService(  969): CoCNTL - AUTH OK
nnectivityChange for WIFI: CONNECTING/CONNECTING
ASSOC - Send ASSOC request...
PeerAssocRspAction():ASSOC - receive ASSOC_RSP to me (status=0)
PeerAssocRspAction():MacTable [255].AMsduSize = 0. ClientStatusFlags = 0x0 
AssocPostProc===>  AP.AMsduSize = 0. ClientStatusFlags = 0x0 
AssocPostProc===>    (Mmps=0, AmsduSize=0, )
AssocPostProc===> Store RSN_IE for WPA2 SM negotiation 
RSN_IE: d09c4674, len = 26
0x0000 : 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f 
0x0010 : ac 02 01 00 00 0f ac 02 0c 00 
I/wpa_supplicant( 1292): CTRL-EV!!!Infra LINK UP !!! 
ENT-STATE-CHANGE id=0 state=4
I/wpa_supplicant( 1292): Associa!!! LINK UP !!! (BssType=1, AID=1, ssid=Olympus2, Channel=6, CentralChannel = 6)
ted with 68:7f:74:1c:e4:7c
V/WifiMonitor(  969): Event [CTR!!! LINK UP !!! (Density =0, )
L-EVENT-STATE-CHANGE id=0 state=4]
V/WifiStateTracker(  969): C==============> AsicSetBssid 68:7f:74:1c:e4:7c
hanging supplicant state: ASSOCIAsicSetEdcaParm
ATING ==> ASSOCIATED
D/NetworkStateTracker(  969): setDetailed NDIS_STATUS_MEDIA_DISCONNECT Event AA!
state, old =CONNECTING and new sRTMPWPARemoveAllKeys(AuthMode=7, WepStatus=6)
tate=CONNECTING
V/WifiMonitor(  969): Event [Associated with 68:7f:74:1c:e4:7c]
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
remove none key #0
AsicRemoveSharedKeyEntry: #0 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
remove none key #1
AsicRemoveSharedKeyEntry: #1 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
remove none key #2
AsicRemoveSharedKeyEntry: #2 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
remove none key #3
AsicRemoveSharedKeyEntry: #3 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
ComposePsPoll
--->AsicEnableBssSync(INFRA mode)
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
!!! LINK UP !!!  ClientStatusFlags=0)
MlmeUpdateTxRates[MaxSupport = 54] = MaxDesire 54 Mbps
 MlmeUpdateTxRates (MaxDesire=54, MaxSupport=54, MaxTxRate=54, MinRate=1, Rate Switching =1)
 MlmeUpdateTxRates (TxRate=24, RtsRate=24, BasicRateBitmap=0x015f)
MlmeUpdateTxRates (MlmeTransmit=0x0, MinHTPhyMode=0, MaxHTPhyMode=0x4004, HTPhyMode=0x4004)
MlmeUpdateHtTxRates===> 
!!! LINK UP !! (StaActive.bHtEnable =0, )
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
NDIS_STATUS_MEDIA_CONNECT Event B!.BACapability = 3024040. ClientStatusFlags = 0
RTMPSetLED::Mode=1,HighByte=0x60,LowByte=0x01
Txburst 2
!!!pAd->bNextDisableRxBA= 0 
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
not supports 20/40 BSS COEX !!! 
pAd->CommonCfg.bBssCoexEnable 1 !!! 
pAd->CommonCfg.Channel 6 !!! 
pAd->StaActive.SupportedHtPhy.bHtEnable 0 !!! 
pAd->MlmeAux.ExtCapInfo.BssCoexstSup 0 !!! 
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
pAd->CommonCfg.CentralChannel 6 !!! 
pAd->CommonCfg.PhyMode 0 !!! 
CNTL - Association successful on BSS #0
SYNC - AP changed N OperaionMode to 3
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
I/power   (  969): *** set_screen_state 1
Receive EAPOL-Key frame, TYPE = 3, Length = 117
MediaState is connected
I/wpa_supplicant( 1292): CTRL-EVENT-STATE-CHANGE id=0 state=5
V/WifiMonitor(  969): Event [CTRL-EVENT-STATE-CHANGE id=0 state=5]
V/WifiStateTracker(  969): Changing supplicant state: ASSOCIATED ==> FOUR_WAY_HANDSHAKE
D/NetworkStateTracker(  969): setDetailed state, old =CONNECTING anReceive EAPOL-Key frame, TYPE = 3, Length = 175
d new state=AUTHENTICATING
D/Cort_ioctl_siwencodeext::DefaultKeyId = 0
nnectivityService(  969): Dropping ConnectivityChange for WIFI: AsicAddSharedKeyEntry BssIndex=0, KeyIdx=0
CONNECTING/AUTHENTICATING
I/wpaAsicAddSharedKeyEntry: AES key #0
_supplicant( 1292): CTRL-EVENT-S 	Key = 68:d6:0e:2e:83:68:6f:06:4f:85:5d:9c:4c:4f:23:6b
TATE-CHANGE id=0 state=5
V/Wifi 	Rx MIC Key = 00:00:00:00:00:00:00:00
Monitor(  969): Event [CTRL-EVEN 	Tx MIC Key = 00:00:00:00:00:00:00:00
T-STATE-CHANGE id=0 state=5]
V/Read: SHARED_KEY_MODE_BASE at this Bss[0] KeyIdx[0]= 0x0 
WifiStateTracker(  969): ChanginWrite: SHARED_KEY_MODE_BASE at this Bss[0] = 0x4 
g supplicant state: FOUR_WAY_HANAsicUpdateWCIDIVEIV: wcid(1) 0x20000001, 0x00000000 
DSHAKE ==> FOUR_WAY_HANDSHAKE
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=AES
		WCIDAttri = 0x8 
I/wpa_supplicant( 1292): CTRL-EVENT-STATE-CHANGE id=0 state=6
rt_ioctl_siwencodeext::IW_ENCODE_ALG_TKIP - keyIdx = 2, ext->key_len = 32
V/WifiMonitor(  969): Event [CTRAsicAddSharedKeyEntry BssIndex=0, KeyIdx=2
L-EVENT-STATE-CHANGE id=0 state=AsicAddSharedKeyEntry: TKIP key #2
6]
V/WifiStateTracker(  969): C 	Key = a6:07:f3:8b:11:37:bf:1e:bb:10:f8:be:03:a1:82:b1
hanging supplicant state: FOUR_W 	Rx MIC Key = da:42:4b:7d:6a:82:cb:86
AY_HANDSHAKE ==> GROUP_HANDSHAKE 	Tx MIC Key = 6d:8f:18:80:a1:0b:4a:1b

Read: SHARED_KEY_MODE_BASE at this Bss[0] KeyIdx[2]= 0x4 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x304 
I/wpa_supplicant( 1292): WPA: Key negotiation completed with 68:rt28xx_get_wireless_stats --->
7f:74:1c:e4:7c [PTK=CCMP GTK=TKIP]
V/WifiMonitor(  969): Event [WPA: Key negotiation completed <--- rt28xx_get_wireless_stats
with 68:7f:74:1c:e4:7c [PTK=CCMP GTK=TKIP]]
I/wpa_supplicant( 1292): CTRL-EVENT-STATE-CHANGE id=0 state=7
V/WifiMonitor(  969): Event [CTRL-EVENT-STATE-CHANGE id=0 state=7]
I/wpa_supplicant( 1292): CTRL-EVENT-CONNECTED - Connection to 68:7f:74:1c:e4:7c completed (auth) [id=0 id_str=]
V/WifiMonitor(  969): Event [CTRL-EVENT-CONNECTED - Connection to 68:7f:74:1c:e4:7c completed (auth) [id=0 id_str=]]
D/NetworkStateTracker(  969): setDetailed state, old =AUTHENTICATING and new state=AUTHENTICATING
V/WifiStateTracker(  969): Changing supplicant state: GROUP_HANDSHAKE ==> COMPLETED
V/WifiStateTracker(  969): New network state is CONNECTED
D/WifiStateTracker(  969): DhcpHandler: DHCP request started
D/dhcp_utils(  969): dhcp_do_request
D/NetworkStateTracker(  969): setDetailed state, old =AUTHENTICATING and new state=OBTAINING_IPADDR
D/ConnectivityService(  969): Dropping ConnectivityChange for WIFI: CONNECTING/OBTAINING_IPADDR
D/dalvikvm( 1198): GC_FOR_MALLOC freed 9867 objects / 523176 bytes in 111ms hsize: 16777216
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
D/dhcpcd  ( 1301): dhcpcd 4.0.15 starting
D/dhcpcd  ( 1301): hardware address = 00:08:10:74:b5:da
D/dhcpcd  ( 1301): executing `/system/etc/dhcpcd/dhcpcd-run-hooks', reason PREINIT
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
SCANNING, suspend MSDU transmission ...
MlmeScanReqAction -- Send PSM Data frame for off channel RM, SCAN_IN_PROGRESS=1!
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
I//system/bin/dhcpcd( 1300): [: not found
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
D/dhcpcd  ( 1301): host does not support a monotonic clock - timing can skew
D/dhcpcd  ( 1301): broadcasting for a lease
D/dhcpcd  ( 1301): sending DHCP_DISCOVER with xid 0x92e3848e, next in 4.04 seconds
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
ScanNextChannel():Send PWA NullData frame to notify the associated AP!
ScanTimeoutAction():Send PWS NullData frame to notify the associated AP!
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
SYNC - End of SCAN, restore to channel 6, Total BSS[01]
ScanNextChannel -- Send PSM Data frame
bFastRoamingScan ~~~~~~~~~~~~~ Get back to send data ~~~~~~~~~~~~~
SCAN done, resume MSDU transmission ...
bImprovedScan ............. Resume for bImprovedScan, SCAN_PENDING .............. 
SCANNING, suspend MSDU transmission ...
MlmeScanReqAction -- Send PSM Data frame for off channel RM, SCAN_IN_PROGRESS=1!
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
SYNC - End of SCAN, restore to channel 6, Total BSS[02]
ScanNextChannel -- Send PSM Data frame
D/dhcpcd  ( 1301): offered 192.1SCAN done, resume MSDU transmission ...
68.1.102 from 192.168.1.1
D/dhcpcd  ( 1301): sending DHCP_REQUEST with xid 0x92e3848e, next in 3.17 seconds
D/dhcpcd  ( 1301): acknowledged 192.168.1.102 from 192.168.1.1
D/dhcpcd  ( 1301): checking 192.168.1.102 is available on attached networks
D/dhcpcd  ( 1301): sending ARP probe (1 of 3), next in 1.22 seconds
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
D/dhcpcd  ( 1301): sending ARP probe (2 of 3), next in 1.25 seconds
D/dhcpcd  ( 1301): sending ARP probe (3 of 3), next in 2.00 seconds
===>rt_ioctl_giwscan. 2(2) BSS returned, data->length = 324
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
SCANNING, suspend MSDU transmission ...
MlmeScanReqAction -- Send PSM Data frame for off channel RM, SCAN_IN_PROGRESS=1!
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
D/dhcpcd  ( 1301): leased 192.168.1.102 for 86400 seconds
D/dhcpcd  ( 1301): adding IP address 192.168.1.102/24
D/dhcpcd  ( 1301): adding route to 0.0.0.0/0 via 192.168.1.1
D/dhcpcd  ( 1301): executing `/system/etc/dhcpcd/dhcpcd-run-hooks', reason BOUND
I//system/bin/dhcpcd( 1300): [: not found
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
ScanNextChannel():Send PWA NullData frame to notify the associated AP!
ScanTimeoutAction():Send PWS NullData frame to notify the associated AP!
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
SYNC - End of SCAN, restore to channel 6, Total BSS[01]
ScanNextChannel -- Send PSM Data frame
bFastRoamingScan ~~~~~~~~~~~~~ Get back to send data ~~~~~~~~~~~~~
SCAN done, resume MSDU transmission ...
bImprovedScan ............. Resume for bImprovedScan, SCAN_PENDING .............. 
SCANNING, suspend MSDU transmission ...
MlmeScanReqAction -- Send PSM Data frame for off channel RM, SCAN_IN_PROGRESS=1!
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
D/dhcp_utils(  969): dhcp ok1: wlan0 169.110.52.173 169.110.52.173
D/dhcp_utils(  969): dhcp ok2: wlan0 213.132.63.25 213.132.63.25
V/WifiStateTracker(  969): DhcpHandler: DHCP request succeeded
D/NetworkStateTracker(  969): setDetailed state, old =OBTAINING_IPADDR and new state=CONNECTED
V/WifiStateTracker(  969): IP configuration: ipaddr 192.168.1.102 gateway 192.168.1.1 netmask 255.255.255.0 dns1 192.168.1.1 dns2 213.132.63.25 DHCP server 192.168.1.1 lease 86400 seconds
V/NetworkStateTracker(  969): Setting TCP values: [4095,87380,110208,4096,16384,110208] which comes from [net.tcp.buffersize.wifi]
D/ConnectivityService(  969): ConnectivityChange for WIFI: CONNECTED/CONNECTED
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
SYNC - End of SCAN, restore to channel 6, Total BSS[02]
ScanNextChannel -- Send PSM Data frame
SCAN done, resume MSDU transmission ...
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
E/NetworkStateTracker(  969): Can't set tcp buffer sizes:java.iort28xx_get_wireless_stats --->
.FileNotFoundException: /sys/ker<--- rt28xx_get_wireless_stats
nel/ipv4/tcp_rmem_min (Permission denied)
D/ConnectivityService(  969): adding dns 192.168.1.1 for WIFI
D/ConnectivityService(  969): adding dns 213.132.63.25 for WIFI
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
D/WifiWatchdogService(  969): (android.server.ServerThread) Olympus2 (68:7f:74:1c:e4:7c) does not require the watchdog
D/Tethering(  969): Tethering got CONNECTIVITY_ACTION
D/Tethering(  969): MasterInitialState.processMessage what=3
E/HierarchicalStateMachine(  969): TetherMaster - unhandledMessage: msg.what=3
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
D/dhcpcd  ( 1301): sending ARP announce (1 of 2), next in 2.00 seconds
===>rt_ioctl_giwscan. 2(2) BSS returned, data->length = 324
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
SCANNING, suspend MSDU transmission ...
MlmeScanReqAction -- Send PSM Data frame for off channel RM, SCAN_IN_PROGRESS=1!
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
D/dhcpcd  ( 1301): sending ARP announce (2 of 2)
D/dhcpcd  ( 1301): renew in 43196 seconds
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
ScanNextChannel():Send PWA NullData frame to notify the associated AP!
ScanTimeoutAction():Send PWS NullData frame to notify the associated AP!
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
SYNC - End of SCAN, restore to channel 6, Total BSS[01]
ScanNextChannel -- Send PSM Data frame
bFastRoamingScan ~~~~~~~~~~~~~ Get back to send data ~~~~~~~~~~~~~
SCAN done, resume MSDU transmission ...
bImprovedScan ............. Resume for bImprovedScan, SCAN_PENDING .............. 
SCANNING, suspend MSDU transmission ...
MlmeScanReqAction -- Send PSM Data frame for off channel RM, SCAN_IN_PROGRESS=1!
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
SYNC - End of SCAN, restore to channel 6, Total BSS[02]
ScanNextChannel -- Send PSM Data frame
SCAN done, resume MSDU transmission ...
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
W/KeyCharacterMap( 1198): No keyboard for id 0
W/KeyCharacterMap( 1198): Using default keymap: /system/usr/keychars/qwerty.kcm.bin
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
SYNC - send NULL Frame @24 Mbps...
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
===>rt_ioctl_giwscan. 2(2) BSS returned, data->length = 324
I/wpa_supplicant( 1292): CTRL-EVENT-SCAN-RESULTS  Ready
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
D/dalvikvm( 1110): GC_EXTERNAL_ALLOC freed 2535 objects / 118424 bytes in 64ms hsize: 16777216
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
D/dalvikvm( 1152): GC_EXPLICIT freed 2931 objects / 187072 bytes in 109ms hsize: 16777216
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/ActivityManager(  969): Starting activity: Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x10200000 cmp=com.android.browser/.BrowserActivity }
I/ActivityManager(  969): Start proc com.android.browser for activity com.android.browser/.BrowserActivity: pid=1331 uid=10012 gids={3003, 1015}
D/installd(  914): DexInv: --- BEGIN '/system/app/Browser.apk' ---
D/dalvikvm( 1339): creating instr width table
D/dalvikvm( 1339): DexOpt: load 74ms, verify 318ms, opt 12ms
D/installd(  914): DexInv: --- END '/system/app/Browser.apk' (success) ---
I/ActivityThread( 1331): Publishing provider browser: com.android.browser.BrowserProvider
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
I/BrowserSettings( 1331): Selected search engine: ActivitySearchEngine{android.app.SearchableInfo@43e55990}
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331)SYNC - send NULL Frame @24 Mbps...
: Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
E/ActivityThread( 1331): Failed to find provider info for com.google.settings
I/Database( 1331): sqlite returned: error code = 1, msg = no such table: IconDatabaseInfo
I/ActivityManager(  969): Displayed activity com.android.browser/.BrowserActivity: 3094 ms (total 3094 ms)
D/dalvikvm( 1331): GC_FOR_MALLOC freed 4087 objects / 274744 bytes in 69ms hsize: 16777216
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
I/power   (  969): *** set_screen_state 1
D/dalvikvm( 1331): GC_EXTERNAL_ALLOC freed 2457 objects / 267168 bytes in 61ms hsize: 16777216
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
D/dalvikvm( 1110): GC_EXPLICIT freed 987 objects / 49208 bytes in 55ms hsize: 16777216
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
SYNC - send NULL Frame @24 Mbps...
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
W/KeyCharacterMap( 1331): No keyboard for id 0
W/KeyCharacterMap( 1331): Using default keymap: /system/usr/keychars/qwerty.kcm.bin
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/ActivityManager(  969): moveTaskToBack: 5
W/InputManagerService(  969): Starting input on non-focused client com.android.internal.view.IInputMethodClient$Stub$Proxy@43ecb9b0 (uid=10012 pid=1331)
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/ActivityManager(  969): Starting activity: Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x10200000 cmp=com.android.settings/.Settings }
I/ActivityManager(  969): Displayed activity com.android.settings/.Settings: 312 ms (total 312 ms)
I/power   (  969): *** set_screen_state 1
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/ActivityManager(  969): Starting activity: Intent { act=android.intent.action.MAIN cmp=com.android.settings/.WirelessSettings }
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
rt28xx_get_wireless_stats --->
<--- rt28xx_get_wireless_stats
I/ActivityManager(  969): Displayed activity com.android.settings/.WirelessSettings: 247 ms (total 247 ms)
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
====> rt_ioctl_siwmlme
====> rt_ioctl_siwmlme - IW_MLME_DEAUTH
I/wpa_supplicant( 1292): CTRL-EVENT-TERMINATING - signal 15 received
I/wpa_supplicant( 1292): CAUTH - Send DE-AUTH request (Reason=3)...
TRL-EVENT-TERMINATING - signal 0 received
I/wpa_supplicant( 1292): CTRL-EVENT-STATE-CHANGE id=0!!! LINK DOWN !!!
 state=0
V/WifiMonitor(  969): !!! LINK DOWN 2!!!
Event [CTRL-EVENT-TERMINATING - signal 15 received]
V/WifiStateTracker(  969): Connection to suMacTableDeleteEntry1 - Total= 0
pplicant lost
CmdThread : CMDTHREAD_SET_ASIC_WCID : WCID = 1, SetTid  = ffffffff, DeleteTid = ffffffff.
1-MACValue= 0,
2-MACValue= 0,
AsicSetEdcaParm
CNTL - Illegal message in CntlIdleProc(MsgType=36)
RTMPSetLED::Mode=1,HighByte=0x20,LowByte=0x01
D/NetworkStateTracker(  969): setDetailed state, old =CONNECTED --->Disable TSF synchronization
and new state=DISCONNECTED
D/ConnectivityService(  969): ConnectivityChange for WIFI: DISCONNECLinkDownCleanMlmeAux.ExtCapInfo!
TED/DISCONNECTED
D/ConnectivityService(  969): getMobileDataEnabled returning true
D/WifiStateTracker(  969): Reset connections and stopping DHCP
D/DataConneAsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
ctionTracker( 1056): enableApnType(default), isApnTypeActive = false and state = IDLE
D/DataCon		WCIDAttri = 0x1 
nectionTracker( 1056): type not available
D/Tethering(  969): TAsicRemovePairwiseKeyEntry : Wcid #1 
ethering got CONNECTIVITY_ACTIONAsicRemoveSharedKeyEntry: #0 

D/Tethering(  969): MasterInitialState.processMessage what=3
E/HierarchicalStateMachine(  969): TetherMaster - unhandledMessaWrite: SHARED_KEY_MODE_BASE at this Bss[0] = 0x300 
ge: msg.what=3
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8001)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #1 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x300 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8002)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #2 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8003)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #3 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8004)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #0 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8001)
D/dhcpcd  ( 1301): received SIGTERM, stopping
D/dhcpcd  ( 1301): deleting route 0.0.0.0/0 via 1rt_ioctl_siwauth::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = 0)
92.168.1.1
D/dhcpcd  ( 1301): deleting IP address 192.168.1.102/24
D/dhcpcd  ( 1301): executinrt_ioctl_siwauth::IW_AUTH_WPA_VERSION - param->value = 0!
g `/system/etc/dhcpcd/dhcpcd-run-hooks', reason STOP
init: untracked pid 1301 exited
===> rt28xx_close
RT28xxUsbMlmeRadioOFF()
D/WifiStateTracker(  969): Disabling interface
RTMPSetLED::Mode=1,HighByte=0x00,LowByte=0x01
==> MlmeHalt
--->Disable TSF synchronization
RTMPSetLED::Mode=1,HighByte=0x00,LowByte=0x00
<== MlmeHalt
MacTableReset
--->RTUSBCancelPendingBulkInIRP
<---RTUSBCancelPendingBulkInIRP
<---MlmeThread
<---RTUSBCmdThread
<---RtmpTimerQThread
---> RTMPFreeTxRxRingMemory
<--- RTMPFreeTxRxRingMemory
<=== rt28xx_close
INFO::Network is down!
init: untracked pid 1292 exited
usbcore: deregistering interface driver rt2870
rtusb_disconnect: unregister usbnet usb-musb_hdrc-1
RtmpOSNetDevDetach(): RtmpOSNetDeviceDetach(), dev->name=wlan0!
E/Tethering(  969): attempting to remove unknown iface (wlan0), ignoring
 RTUSB disconnect successfully
<--- rtusb exit
E/WifiHW  (  969): cannot find driver rt3070sta  in proc
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1
D/dalvikvm(  969): GC_FOR_MALLOC freed 9782 objects / 476104 bytes in 92ms hsize: 16777216
I/power   (  969): *** set_screen_state 1
I/power   (  969): *** set_screen_state 1


==> Restarting wifi (turn off and turn back on from wifi settings control panel)


I/WifiHW  (  969): Loading WiFi modules
I/WifiHW  (  969): WIFI DRIVER_MODULE_NAME		:= rt3070sta,
I/WifiHW  (  969): WIFI DRIVER_MODULE_TAG		:= rt3070sta ,
I/WifiHW  (  969): WIFI DRIVER_MODULE_PATH		:= /system/lib/modules/rt3070sta.ko,
E/WifiHW  (  969): driver rt3070sta  has NOT been installed
rtusb init --->
===>rt2870_probe()!
--> RTMPAllocAdapterBlock


=== pAd = d1402000, size = 500648 ===

<-- RTMPAllocAdapterBlock, Status=0
NumEndpoints=7
BULK IN MaxPacketSize = 512
EP address = 0x81
BULK OUT MaxPacketSize = 512
EP address = 0x 1  
BULK OUT MaxPacketSize = 512
EP address = 0x 2  
BULK OUT MaxPacketSize = 512
EP address = 0x 3  
BULK OUT MaxPacketSize = 512
EP address = 0x 4  
BULK OUT MaxPacketSize = 512
EP address = 0x 5  
BULK OUT MaxPacketSize = 512
EP address = 0x 6  
STA Driver version-2.3.0.4
NVM is EEPROM
Allocate a net device with private data size=0!
Allocate net device ops success!
The name of the new wlan interface is wlan0...
RtmpOSNetDevAttach()--->
<---RtmpOSNetDevAttach(), ret=0
<===rt2870_probe()!
D/Tethering(  969): wlan0 is notusbcore: registered new interface driver rt2870
 a tetherable iface, ignoring
Allocate 8192 memory for BA reordering
MAC_CSR0  [ Ver:Rev=0x30700201]
<=== RtmpAsicLoadFirmware (status=0)
--> RTMPAllocTxRxRingMemory
--> NICInitTransmit
MGMT Ring: total 32 entry allocated
<-- NICInitTransmit(Status=0)
--> NICInitRecv
<-- NICInitRecv(Status=0)
<-- RTMPAllocTxRxRingMemory, Status=0
--> MLME Initialize
<-- MLME Initialize
--> UserCfgInit
--> UserCfgInit. BACapability = 0x3024040
<-- UserCfgInit
--> NICInitializeAdapter
<== DMA offset 0x208 = 0x0
--> NICInitializeAsic
MAC_CSR0  [ Ver:Rev=0x30700201]
-->RTUSBVenderReset
<--RTUSBVenderReset
BBP version = 60
--->Disable TSF synchronization
<-- NICInitializeAsic
<-- NICInitializeAdapter
1. Phy Mode = 0
2. Phy Mode = 0
--> NICReadEEPROMParameters
--> E2PROM_CSR = 0x20408
--> EEPROMAddressNum = 6
Initialize MAC Address from E2PROM 
E2PROM MAC: =00:08:10:74:b5:da
Use the MAC address what is assigned from EEPROM. 
Current MAC: =00:08:10:74:b5:da
E2PROM: Version = 1, FAE release #1
NICReadEEPROMParameters: RxPath = 1, TxPath = 1
Chip specific bbpRegTbSize=0!
E2PROM: G Tssi[-4 .. +4] = 255 255 255 255 - 255 -255 255 255 255, step=255, tuning=0
E2PROM: A Tssi[-4 .. +4] = 0 0 0 0 - 0 -0 0 0 0, step=0, tuning=0
E2PROM: RF FreqOffset=0x29 
RTMPSetPhyMode : PhyMode=0, channel=0 
country code=128/128, RFIC=5, PHY mode=0, support 11 channels
BuildChannel # 1 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 2 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 3 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 4 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 5 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 6 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 7 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 8 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 9 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 10 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 11 :: Pwr0 = 16, Pwr1 =5, 
 RTMPSetPhyMode: channel is out of range, use first channel=1 
Txpower per Rate
Gpwrdelta = 0, Apwrdelta = 0 .
20MHz BW, 2.4G band-aaaa6666,  Adata = aaaa6666,  Gdata = aaaa6666 
20MHz BW, 2.4G band-aaaa6688,  Adata = aaaa6688,  Gdata = aaaa6688 
20MHz BW, 2.4G band-aaaa6688,  Adata = aaaa6688,  Gdata = aaaa6688 
20MHz BW, 2.4G band-aaaa6688,  Adata = aaaa6688,  Gdata = aaaa6688 
20MHz BW, 2.4G band-ffff6688,  Adata = ffff6688,  Gdata = ffff6688 
<-- NICReadEEPROMParameters
3. Phy Mode = 0
--> NICInitAsicFromEEPROM
AsicSetRxAnt, switch to main antenna
RTMPFilterCalibration - CaliBW20RfR24=0x9, CaliBW40RfR24=0x27
RTMPSetLED::Mode=1,HighByte=0x20,LowByte=0x01
Use Hw Radio Control Pin=0; if used Pin=0;
TxPath = 1, RxPath = 1, RFIC=5, Polar+LED mode=1
<-- NICInitAsicFromEEPROM
RTMPSetPhyMode : PhyMode=0, channel=1 
country code=128/128, RFIC=5, PHY mode=0, support 11 channels
BuildChannel # 1 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 2 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 3 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 4 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 5 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 6 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 7 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 8 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 9 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 10 :: Pwr0 = 17, Pwr1 =5, 
 BuildChannel # 11 :: Pwr0 = 16, Pwr1 =5, 
 MCS Set = 00 00 00 00 00
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
NDIS_STATUS_MEDIA_DISCONNECT Event B!
RTUSBBulkReceive!
<==== rt28xx_init, Status=0
==> RTMPEnableRxTx
<== WRITE DMA offset 0x208 = 0x45
<== RTMPEnableRxTx
0x1300 = 000a4200
STAMlmePeriodicExec():CNTL - ScanTab.BssNr==0, start a new ACTIVE scan SSID[]
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AsicSwitchChannel#2(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x07, R=0x02
AsicSwitchChannel#3(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x02, R=0x02
AsicSwitchChannel#4(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF2, K=0x07, R=0x02
AsicSwitchChannel#5(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x02, R=0x02
AsicSwitchChannel#6(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF3, K=0x07, R=0x02
AsicSwitchChannel#7(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x02, R=0x02
I/WifiHW  (  969): Wi-Fi is running
D/WifiService(  969): ACTION_BATTERY_CHANGED pluggedType: 1
I/WifiHW  (  969): Interface directory = /data/system/wpa_supplicant
I/WifiHW  (  969): Interface name = /data/system/wpa_supplicant/wlan0
E/WifiHW  (  969): Unable to open connection to supplicant on "/data/system/wpa_supplicant/wlan0": No such file or directory
AsicSwitchChannel#8(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF4, K=0x07, R=0x02
AsicSwitchChannel#9(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x02, R=0x02
AsicSwitchChannel#10(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF5, K=0x07, R=0x02
AsicSwitchChannel#11(RF=5, Pwr0=16, Pwr1=5, 1T), N=0xF6, K=0x02, R=0x02
D/WifiStateTracker(  969): Reset connections and stopping DHCP
===> rt_ioctl_siwpmksa
rt_ioctl_siwpmksa - IW_PMKSA_FLUSH
===>Set_NetworkType_Proc::(INFRA)
Set_NetworkType_Proc::(NetworkType=1)
===>rt_ioctl_giwrange
rt_ioctl_siwauth::IW_AUTH_WPA_ENABLED - Driver supports WPA!(param->value = 1)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SYNC - End of SCAN, restore to channel 1, Total BSS[01]
SCAN done, resume MSDU transmission ...
AsicRemoveSharedKeyEntry: #0 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8001)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #1 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8002)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #2 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8003)
AsicUpdateWcidAttributeEntry : WCID #1, KeyIndex #0, Alg=none
		WCIDAttri = 0x1 
AsicRemovePairwiseKeyEntry : Wcid #1 
AsicRemoveSharedKeyEntry: #3 
Write: SHARED_KEY_MODE_BASE at this Bss[0] = 0x0 
rt_ioctl_siwencodeext::Remove all keys!(encoding->flags = 8004)
rt_ioctl_siwauth::IW_AUTH_WPA_VERSION - param->value = 1!
Driver auto reconnect to last OID_802_11_SSID setting - , len - 0
===>rt_ioctl_giwscan. 1(1) BSS returned, data->length = 200
rt_ioctl_siwauth::IW_AUTH_80211_AUTH_ALG - param->value = 1!
I/wpa_supplicant( 1397): CTRL-EVCntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire ENT-STATE-CHANGE id=-1 state=2
(0)SSID - 
I/wpa_supplicant( 1397): CTRL-EVCntlOidSsidProc():CNTL - No matching BSS, start a new scan
ENT-SCAN-RESULTS  Ready
I/wpa_sSCANNING, suspend MSDU transmission ...
upplicant( 1397): Trying to assort_ioctl_siwauth::IW_AUTH_WPA_VERSION - param->value = 1!
ciate with 68:7f:74:1c:e4:7c (SSSYNC - BBP R4 to 20MHz.l
ID='Olympus2' freq=2437 MHz)
===>Set_NetworkType_Proc::(INFRA)
I/wpa_supplicant( 1397): CTRL-EVSet_NetworkType_Proc::(NetworkType=1)
ENT-STATE-CHANGE id=-1 state=3
===> rt_ioctl_siwgenie
rt_ioctl_siwauth::IW_AUTH_WPA_VERSION - param->value = 4!
rt_ioctl_siwauth::IW_AUTH_CIPHER_PAIRWISE - param->value = 8!
rt_ioctl_siwauth::IW_AUTH_CIPHER_GROUP - param->value = 4!
rt_ioctl_siwauth::IW_AUTH_KEY_MGMT - param->value = 2!
rt_ioctl_siwauth::IW_AUTH_PRIVACY_INVOKED - param->value = 1!
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
==>rt_ioctl_siwfreq::SIOCSIWFREQ[cmd=0x8b04] (Channel=1)
!!! MLME busy, reset MLME state machine !!!
Set_SSID_Proc::(Len=8,Ssid=Olympus2)
!!! MLME busy, reset MLME state machine !!!
!!! reset MLME state machine !!!
MlmeRestartStateMachine 
IOCTL::SIOCSIWAP 68:7f:74:1c:e4:7c
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SCAN done, resume MSDU transmission ...
CntlOidSsidProc():CNTL - 0 BSS of 0 BSS match the desire (8)SSID - Olympus2
CntlOidSsidProc():CNTL - No matching BSS, start a new scan
!!! reset MLME state machine !!!
MlmeRestartStateMachine 
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
SCAN done, resume MSDU transmission ...
CNTL - BSSID not found. reply NDIS_STATUS_NOT_ACCEPTED
CNTL - BSSID not found. start a new scan
SCANNING, suspend MSDU transmission ...
SYNC - BBP R4 to 20MHz.l
AsicSwitchChannel#1(RF=5, Pwr0=17, Pwr1=5, 1T), N=0xF1, K=0x02, R=0x02
AYNC - InvalidStateWhenScan(state=2). Reset SYNC machine
SCAN done, resume MSDU transmission ...
===> rt28xx_close
RT28xxUsbMlmeRadioOFF()
D/WifiStateTracker(  969): Disabling interface
RTMPSetLED::Mode=1,HighByte=0x00,LowByte=0x01
==> MlmeHalt
--->Disable TSF synchronization
RTMPSetLED::Mode=1,HighByte=0x00,LowByte=0x00
<== MlmeHalt
MacTableReset
--->RTUSBCancelPendingBulkInIRP
<---RTUSBCancelPendingBulkInIRP
<---MlmeThread
<---RTUSBCmdThread
<---RtmpTimerQThread
---> RTMPFreeTxRxRingMemory
<--- RTMPFreeTxRxRingMemory
<=== rt28xx_close
I//system/bin/wpa_supplicant( 1396): l2_packet_receive - recvfrom: Network is down
I/power   (  969): *** set_screen_state 1
I/WifiHW  (  969): Interface directory = /data/system/wpa_supplicant
I/WifiHW  (  969): Interface name = /data/system/wpa_supplrt28xx_get_wireless_stats --->
icant/wlan0
I/WifiHW  (  969): INFO::Network is down!
connect to supplicant done
V/WifiStateTracker(  969): Connection to supplicant established, state=ASSOCIATING
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSTATS]: Operation not supported on transport endpoint
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWRATE]: Network is down
D/NetworkStateTracker(  969): setDetailed state, old =DISCONNECTED and new state=CONNECTING
D/ConnectivityService(  969): ConnectivityChange for WIFI: CONNECTING/CONNECTING
I/wpa_supplicant( 1397): AuthentINFO::Network is down!
ication with 68:7f:74:1c:e4:7c timed out.
I/wpa_supplicant( 1397): CTRL-EVENT-STATE-CHANGE id=0 state=0
I/wpa_supplicant( 1397): CTRL-EVENT-STATE-CHANGE id=-1 state=2
W/wpa_supplicant( 1397): Failed to initiate AP scan.
V/WifiMonitor(  969): Event [Authentication with 68:7f:74:1c:e4:rt28xx_get_wireless_stats --->
7c timed out.]
V/WifiMonitor(  969): Event [CTRL-EVENT-STATE-CHINFO::Network is down!
ANGE id=0 state=0]
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCSIWSCAN]: Network is down
V/WifiStateTracker(  969): Changing supplicant state: ASSOCIATING ==> DISCONNECTED
V/WifiMonitor(  969): Event [CTRL-EVENT-STATE-CHANGE id=-1 state=2]
V/WifiStateTracker(  969): Changing supplicant state: DISCONNECTED ==> SCANNING
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSTATS]: Operation not supported on transport endpoint
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWRATE]: Network is down
rt28xx_get_wireless_stats --->
INFO::Network is down!
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSTATS]: Operation not supported on transport endpoint
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWRATE]: Network is down
D/dalvikvm( 1198): GC_FOR_MALLOC freed 9817 objects / 545496 bytes in 62ms hsize: 16777216
INFO::Network is down!
INFO::Network is down!
D/WifiStateTracker(  969): Reset connections and stopping DHCP
W/wpa_supplicant( 1397): Failed to initiate AP scan.
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSCAN]: Network is down
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCSIWSCAN]: Network is down
D/WifiStateTracker(  969): Disabling interface
D/NetworkStateTracker(  969): setDetailed state, old =CONNECTING and new state=DISCONNECTED
rt28xx_get_wireless_stats --->
INFO::Network is down!
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSTATS]: Operation not supported on transport endpoint
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWRATE]: Network is down
D/ConnectivityService(  969): ConnectivityChange for WIFI: DISCONNECTED/DISCONNECTED
D/DataConnectionTracker( 1056): enableApnType(default), isApnTypeActive = false and state = IDLE
D/DataConnectionTracker( 1056): type not available
D/ConnectivityService(  969): getMobileDataEnabled returning true
D/Tethering(  969): Tethering got CONNECTIVITY_ACTION
D/Tethering(  969): MasterInitialState.processMessage what=3
E/HierarchicalStateMachine(  969): TetherMaster - unhandledMessage: msg.what=3
INFO::Network is down!
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSCAN]: Network is down
INFO::Network is down!
W/wpa_supplicant( 1397): Failed to initiate AP scan.
I//system/bin/wpa_supplicant( 1396): ioctl[SIOCSIWSCAN]: Network is down
D/dalvikvm( 1152): GC_EXPLICIT freed 1525 objects / 69984 bytes in 45ms hsize: 16777216


Best regards,

Elvis Dowson
