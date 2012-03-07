Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4413 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964847Ab2CGRpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 12:45:12 -0500
Message-ID: <4F579E90.3020107@broadcom.com> (sfid-20120307_184520_720733_A2151CFC)
Date: Wed, 7 Mar 2012 18:44:48 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jouni Malinen" <j@w1.fi>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: debugging wpa_supplicant
Content-Type: multipart/mixed;
 boundary=------------020500070800050400010105
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------020500070800050400010105
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

Hi Jouni,

I am working on wireless driver brcmfmac (cfg80211-based driver), which 
has an issue with wpa_supplicant that I am debugging. It is difficult to 
reproduce but finally got a good, bad log. The test setup run Ubuntu and 
uses nmcli to setup a connection to the AP:

  nmcli<->NetworkManager<-[dbus]->wpa_supplicant<->brcmfmac.

In the log I noticed a message that reminded me on an old bug I filed a 
while ago (http://hostap.epitest.fi/bugz/show_bug.cgi?id=262).

I want to investigate further, but could use some pointers on tinkering 
wpa_supplicant. Hope you can help me out. Here is the part of the log 
that triggered me:

Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 
98:fc:11:8e:94:57
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 
type=3 length=117
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 
keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]:   key_length=16 
key_data_length=22
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 
4WAY_HANDSHAKE
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 
4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - 
A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering 
state CONNECTING
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in 
non-IEEE 802.1X mode (type=1 len=0)

After this the sequence from "RX EAPOL" until "Sending EAPOL-Key 2/4" 
keeps repeating several times. In the end NetworkManager times out in 
setting up the connection. Full log is attached.

Gr. AvS

--------------020500070800050400010105
Content-Type: text/plain;
 name=iperf-stall-syslog.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=iperf-stall-syslog.txt

Mar  7 13:30:34 lb-bun-21 kernel: [771204.210867] sdhci: Secure Digital Host Controller Interface driver
Mar  7 13:30:34 lb-bun-21 kernel: [771204.210873] sdhci: Copyright(c) Pierre Ossman
Mar  7 13:30:34 lb-bun-21 kernel: [771204.211387] sdhci-pci 0000:04:00.1: SDHCI controller found [1180:e822] (rev 3)
Mar  7 13:30:34 lb-bun-21 kernel: [771204.211520] mmc0: no vmmc regulator found
Mar  7 13:30:34 lb-bun-21 kernel: [771204.211586] Registered led device: mmc0::
Mar  7 13:30:34 lb-bun-21 kernel: [771204.212692] mmc0: SDHCI controller on PCI [0000:04:00.1] using DMA
Mar  7 13:30:34 lb-bun-21 kernel: [771204.225263] cfg80211: Calling CRDA to update world regulatory domain
Mar  7 13:30:34 lb-bun-21 kernel: [771204.232086] cfg80211: World regulatory domain updated:
Mar  7 13:30:34 lb-bun-21 kernel: [771204.232091] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar  7 13:30:34 lb-bun-21 kernel: [771204.232097] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:34 lb-bun-21 kernel: [771204.232101] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:34 lb-bun-21 kernel: [771204.232106] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:34 lb-bun-21 kernel: [771204.232110] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:34 lb-bun-21 kernel: [771204.232114] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771204.878755] mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
Mar  7 13:30:35 lb-bun-21 kernel: [771204.878813] mmc0: new SDIO card at address 0001
Mar  7 13:30:35 lb-bun-21 kernel: [771205.234217] brcmfmac: F1 signature read @0x18000000=0x9934329
Mar  7 13:30:35 lb-bun-21 kernel: [771205.235023] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength init done for chip 4329 rev 3 pmurev 6
Mar  7 13:30:35 lb-bun-21 kernel: [771205.284551] brcmfmac: brcmf_sdbrcm_write_vars: Download/Upload/Compare of NVRAM ok
Mar  7 13:30:35 lb-bun-21 kernel: [771205.384540] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Sep  2 2011 14:48:19 version 4.220.48
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557742] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557749] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557754] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557759] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557763] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557768] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557772] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557777] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557781] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557786] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557790] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557795] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557799] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557804] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557808] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557813] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557817] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557822] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557826] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557831] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557835] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557840] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557844] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557849] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557853] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557858] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557862] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557866] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557871] cfg80211: Disabling freq 5170 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557874] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557879] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557883] cfg80211: Updating information on frequency 5190 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557888] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557892] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557897] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557901] cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557906] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557910] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557915] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557919] cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557924] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557928] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557933] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557937] cfg80211: Disabling freq 5260 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557939] cfg80211: Disabling freq 5280 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557942] cfg80211: Disabling freq 5300 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557944] cfg80211: Disabling freq 5320 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557947] cfg80211: Disabling freq 5500 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557950] cfg80211: Disabling freq 5520 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557952] cfg80211: Disabling freq 5540 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557955] cfg80211: Disabling freq 5560 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557958] cfg80211: Disabling freq 5580 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557960] cfg80211: Disabling freq 5600 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557963] cfg80211: Disabling freq 5620 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557965] cfg80211: Disabling freq 5640 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557968] cfg80211: Disabling freq 5660 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557971] cfg80211: Disabling freq 5680 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557973] cfg80211: Disabling freq 5700 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557977] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557982] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557986] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557991] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557994] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.557999] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558003] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558008] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558012] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558017] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558021] cfg80211: Disabling freq 5920 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558023] cfg80211: Disabling freq 5940 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558026] cfg80211: Disabling freq 5960 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558029] cfg80211: Disabling freq 5980 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558031] cfg80211: Disabling freq 6000 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558034] cfg80211: Disabling freq 6020 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558037] cfg80211: Disabling freq 6040 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558039] cfg80211: Disabling freq 6060 MHz
Mar  7 13:30:35 lb-bun-21 kernel: [771205.558042] cfg80211: Disabling freq 6080 MHz
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]: <info> found WiFi radio killswitch rfkill40 (at /sys/devices/pci0000:00/0000:00:1c.2/0000:04:00.1/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/ieee80211/phy0/rfkill40) (driver <unknown>)
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]:    SCPlugin-Ifupdown: devices added (path: /sys/devices/pci0000:00/0000:00:1c.2/0000:04:00.1/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/net/wlan1, iface: wlan1)
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]:    SCPlugin-Ifupdown: device added (path: /sys/devices/pci0000:00/0000:00:1c.2/0000:04:00.1/mmc_host/mmc0/mmc0:0001/mmc0:0001:2/net/wlan1, iface: wlan1): no ifupdown configuration found.
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]: <error> [1331123435.995564] [nm-device-wifi.c:3095] real_update_permanent_hw_address(): (wlan1): unable to read permanent MAC address (error 0)
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]: <info> (wlan1): driver supports SSID scans (scan_capa 0x01).
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]: <info> (wlan1): new 802.11 WiFi device (driver: 'brcmfmac' ifindex: 41)
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]: <info> (wlan1): exported as /org/freedesktop/NetworkManager/Devices/39
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]: <info> (wlan1): now managed
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 1 -> 2 (reason 2)
Mar  7 13:30:35 lb-bun-21 NetworkManager[899]: <info> (wlan1): bringing up device.
Mar  7 13:30:35 lb-bun-21 kernel: [771205.590994] udev[11368]: renamed network interface wlan0 to wlan1
Mar  7 13:30:36 lb-bun-21 NetworkManager[899]: <info> (wlan1): preparing device.
Mar  7 13:30:36 lb-bun-21 NetworkManager[899]: <info> (wlan1): deactivating device (reason: 2).
Mar  7 13:30:36 lb-bun-21 kernel: [771205.600543] brcmfmac: _brcmf_set_multicast_list: wlan1: set promisc 0 failed
Mar  7 13:30:36 lb-bun-21 kernel: [771205.601761] brcmfmac: _brcmf_set_multicast_list: wlan1: set promisc 0 failed
Mar  7 13:30:36 lb-bun-21 NetworkManager[899]: <info> (wlan1): reset MAC address to 00:90:4C:11:22:33
Mar  7 13:30:36 lb-bun-21 kernel: [771205.602258] brcmfmac: ERROR @brcmf_run_iscan : error (-3)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Initializing interface 'wlan1' conf 'N/A' driver 'wext' ctrl_interface 'N/A' bridge 'N/A'
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Initializing interface (2) 'wlan1'
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WEXT: cfg80211-based driver detected
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]:   capabilities: key_mgmt 0xf enc 0xf flags 0x0
Mar  7 13:30:36 lb-bun-21 kernel: [771205.606325] brcmfmac: _brcmf_set_multicast_list: wlan1: set promisc 0 failed
Mar  7 13:30:36 lb-bun-21 kernel: [771205.607859] brcmfmac: _brcmf_set_multicast_list: wlan1: set promisc 0 failed
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=1, operstate=5
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Own MAC address: 00:90:4c:c5:34:23
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_wpa
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_countermeasures
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_drop_unencrypted
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: RSN: flushing PMKID list in the driver
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Setting scan request: 38 sec 100000 usec
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: Build Beacon and Probe Response IEs
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Version
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Wi-Fi Protected Setup State (0)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Version
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Wi-Fi Protected Setup State (0)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Response Type (2)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * UUID-E
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Manufacturer
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Model Name
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Model Number
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Serial Number
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Primary Device Type
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Device Name
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * Config Methods (0)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS:  * RF Bands (3)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: EAPOL: KEY_RX entering state NO_KEY_RECEIVE
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: EAP: EAP entering state DISABLED
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Added interface wlan1
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b06 len=12
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:36 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant interface state:  starting -> ready
Mar  7 13:30:36 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 2 -> 3 (reason 42)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Setting scan request: 0 sec 0 usec
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> SCANNING
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Starting AP scan (broadcast SSID)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Trying to get current scan results first without requesting a new scan to speed up initial association
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Received 0 bytes of scan results (0 BSSes)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Cached scan results are empty - not posting
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: No suitable AP found.
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Setting scan request: 0 sec 0 usec
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Setting scan request: 0 sec 0 usec
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Starting AP scan (broadcast SSID)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Scan requested (ret=0) - scan timeout 5 seconds
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b19 len=16
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: Received 4095 bytes of scan results (8 BSSes)
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: New scan results available
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: No suitable AP found.
Mar  7 13:30:36 lb-bun-21 wpa_supplicant[978]: State: SCANNING -> INACTIVE
Mar  7 13:30:37 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:30:37 lb-bun-21 avahi-daemon[903]: Joining mDNS multicast group on interface wlan1.IPv6 with address fe80::290:4cff:fec5:3423.
Mar  7 13:30:37 lb-bun-21 avahi-daemon[903]: New relevant interface wlan1.IPv6 for mDNS.
Mar  7 13:30:37 lb-bun-21 avahi-daemon[903]: Registering new address record for fe80::290:4cff:fec5:3423 on wlan1.*.
Mar  7 13:30:37 lb-bun-21 kernel: [771207.113844] brcmfmac: _brcmf_set_multicast_list: wlan1: set promisc 0 failed
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) starting connection 'smoke-net'
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 3 -> 4 (reason 0)
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) scheduled...
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) started...
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) scheduled...
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) complete.
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) starting...
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 4 -> 5 (reason 0)
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1/wireless): access point 'smoke-net' has security, but secrets are required.
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 5 -> 6 (reason 0)
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) complete.
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) scheduled...
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) started...
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 6 -> 4 (reason 0)
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) scheduled...
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) complete.
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) starting...
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 4 -> 5 (reason 0)
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1/wireless): connection 'smoke-net' has security, and secrets exist.  No new secrets needed.
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Config: added 'ssid' value 'smoke_24'
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Config: added 'scan_ssid' value '1'
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Config: added 'key_mgmt' value 'WPA-PSK'
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Config: added 'psk' value '<omitted>'
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: nm_setting_802_1x_get_pkcs11_engine_path: assertion `NM_IS_SETTING_802_1X (setting)' failed
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: nm_setting_802_1x_get_pkcs11_module_path: assertion `NM_IS_SETTING_802_1X (setting)' failed
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) complete.
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> Config: set interface ap_scan to 1
Mar  7 13:30:37 lb-bun-21 wpa_supplicant[978]: key_mgmt: 0x2
Mar  7 13:30:37 lb-bun-21 wpa_supplicant[978]: scan_ssid=1 (0x1)
Mar  7 13:30:37 lb-bun-21 wpa_supplicant[978]: Setting scan request: 0 sec 0 usec
Mar  7 13:30:37 lb-bun-21 wpa_supplicant[978]: State: INACTIVE -> SCANNING
Mar  7 13:30:37 lb-bun-21 wpa_supplicant[978]: Starting AP scan (specific SSID)
Mar  7 13:30:37 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  inactive -> scanning
Mar  7 13:30:37 lb-bun-21 wpa_supplicant[978]: Scan requested (ret=0) - scan timeout 30 seconds
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b19 len=16
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Received 4093 bytes of scan results (8 BSSes)
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: New scan results available
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Selecting BSS from priority group 0
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Try to find WPA-enabled AP
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: 0: 98:fc:11:8e:94:57 ssid='smoke_24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]:    selected based on RSN IE
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]:    selected WPA AP 98:fc:11:8e:94:57 ssid='smoke_24'
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Trying to associate with 98:fc:11:8e:94:57 (SSID='smoke_24' freq=2462 MHz)
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPA: clearing own WPA/RSN IE
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Automatic auth_alg selection: 0x1
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RSN: using IEEE 802.11i/D9.0
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPA: using GTK TKIP
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPA: using PTK CCMP
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WPA: using KEY_MGMT WPA-PSK
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_drop_unencrypted
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: State: SCANNING -> ASSOCIATING
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_associate
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_psk
Mar  7 13:30:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  scanning -> associating
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Association request to the driver failed
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 5 sec 0 usec
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP fail=0
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portControl=Auto
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RSN: Ignored PMKID candidate without preauth flag
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b06 len=12
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added

>>>> 1 <<< EVENT: AUTH TIMEOUT >>>
Mar  7 13:30:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=24
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: Authentication with 98:fc:11:8e:94:57 timed out.
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: Added BSSID 98:fc:11:8e:94:57 into blacklist
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATING -> DISCONNECTED
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: Setting scan request: 0 sec 0 usec
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> SCANNING
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: Starting AP scan (broadcast SSID)
Mar  7 13:30:43 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associating -> disconnected
Mar  7 13:30:43 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  disconnected -> scanning
Mar  7 13:30:43 lb-bun-21 wpa_supplicant[978]: Scan requested (ret=0) - scan timeout 30 seconds
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b19 len=16
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Scan results did not fit - trying larger buffer (8192 bytes)
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Received 5247 bytes of scan results (9 BSSes)
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: New scan results available
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Selecting BSS from priority group 0
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Try to find WPA-enabled AP
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: 0: 98:fc:11:8e:94:57 ssid='smoke_24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]:    selected based on RSN IE
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]:    selected WPA AP 98:fc:11:8e:94:57 ssid='smoke_24'
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Trying to associate with 98:fc:11:8e:94:57 (SSID='smoke_24' freq=2462 MHz)
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: clearing own WPA/RSN IE
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Automatic auth_alg selection: 0x1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RSN: using IEEE 802.11i/D9.0
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: using GTK TKIP
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: using PTK CCMP
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: using KEY_MGMT WPA-PSK
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_drop_unencrypted
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: State: SCANNING -> ASSOCIATING
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_associate
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_psk
Mar  7 13:30:44 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  scanning -> associating
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Association request to the driver failed
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 5 sec 0 usec
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP fail=0
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portControl=Auto
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RSN: Ignored PMKID candidate without preauth flag
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b06 len=12
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=24
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Not associated - Delay processing of received EAPOL frame
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=148
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATING -> ASSOCIATED
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Associated to a new BSS: BSSID=98:fc:11:8e:94:57
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:30:44 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associating -> associated
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Process pending EAPOL frame that was received just before association notification
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:44 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:44 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4

>>>> 1 <<< RX: receiving same EAPOL as line 426 (retry) >>>
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:30:45 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:46 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:47 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:48 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:49 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:50 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:51 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:30:53 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:30:53 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:54 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:54 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:55 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:56 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:57 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:58 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:30:59 lb-bun-21 NetworkManager[899]: <warn> (wlan1): link timed out.
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:30:59 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:00 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:02 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:02 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:03 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:03 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:04 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:05 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:06 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:07 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:08 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:09 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:11 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:31:11 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:12 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:12 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:13 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:14 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:15 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:16 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:17 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:18 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:20 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:20 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:21 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:22 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:22 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:22 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:22 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:22 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:22 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:23 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:24 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:25 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:26 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:26 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:27 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:28 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:29 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:30 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:31 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:32 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:33 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:35 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:35 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:36 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:37 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:37 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:37 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:37 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:37 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:37 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <warn> Activation (wlan1/wireless): association took too long.
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 5 -> 6 (reason 0)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_disassociate
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <warn> Activation (wlan1/wireless): asking for new secrets
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) scheduled...
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) started...
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 6 -> 4 (reason 0)
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) scheduled...
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) complete.
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) starting...
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 4 -> 5 (reason 0)
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1/wireless): connection 'smoke-net' has security, and secrets exist.  No new secrets needed.
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> DISCONNECTED
Mar  7 13:31:38 lb-bun-21 kernel: [771267.501878] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.502347] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.502367] cfg80211: All devices are disconnected, going to restore regulatory settings
Mar  7 13:31:38 lb-bun-21 kernel: [771267.502372] cfg80211: Restoring regulatory settings
Mar  7 13:31:38 lb-bun-21 kernel: [771267.502389] cfg80211: Calling CRDA to update world regulatory domain
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Config: added 'ssid' value 'smoke_24'
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Config: added 'scan_ssid' value '1'
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Config: added 'key_mgmt' value 'WPA-PSK'
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Config: added 'psk' value '<omitted>'
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: nm_setting_802_1x_get_pkcs11_engine_path: assertion `NM_IS_SETTING_802_1X (setting)' failed
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: nm_setting_802_1x_get_pkcs11_module_path: assertion `NM_IS_SETTING_802_1X (setting)' failed
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) complete.
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> disconnected
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> DISCONNECTED
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> DISCONNECTED
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> Config: set interface ap_scan to 1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 00:00:00:00:00:00
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Added BSSID 00:00:00:00:00:00 into blacklist
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> DISCONNECTED
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: key_mgmt: 0x2
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: scan_ssid=1 (0x1)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508116] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508123] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508128] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508133] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508137] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508142] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508146] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508151] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508155] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508160] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508164] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508169] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508173] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508178] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508182] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508187] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508191] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508196] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508199] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508204] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508208] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508213] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508217] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508222] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508226] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508231] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508235] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508240] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508244] cfg80211: Disabling freq 5170 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508248] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508253] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508257] cfg80211: Updating information on frequency 5190 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508262] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508266] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508271] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508274] cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508279] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508283] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508288] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508292] cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508297] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508301] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508306] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508310] cfg80211: Disabling freq 5260 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508312] cfg80211: Disabling freq 5280 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508315] cfg80211: Disabling freq 5300 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508318] cfg80211: Disabling freq 5320 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508320] cfg80211: Disabling freq 5500 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508323] cfg80211: Disabling freq 5520 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508326] cfg80211: Disabling freq 5540 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508328] cfg80211: Disabling freq 5560 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508331] cfg80211: Disabling freq 5580 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508334] cfg80211: Disabling freq 5600 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508336] cfg80211: Disabling freq 5620 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508339] cfg80211: Disabling freq 5640 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508342] cfg80211: Disabling freq 5660 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508344] cfg80211: Disabling freq 5680 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508347] cfg80211: Disabling freq 5700 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508350] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508356] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508359] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508364] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508368] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508373] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508377] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508382] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508386] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508391] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508395] cfg80211: Disabling freq 5920 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508397] cfg80211: Disabling freq 5940 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508400] cfg80211: Disabling freq 5960 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508403] cfg80211: Disabling freq 5980 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508405] cfg80211: Disabling freq 6000 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508408] cfg80211: Disabling freq 6020 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508411] cfg80211: Disabling freq 6040 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508413] cfg80211: Disabling freq 6060 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508416] cfg80211: Disabling freq 6080 MHz
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508423] cfg80211: World regulatory domain updated:
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508425] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508430] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508434] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508438] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508443] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 kernel: [771267.508447] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Setting scan request: 0 sec 0 usec
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> SCANNING
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Starting AP scan (specific SSID)
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  disconnected -> scanning
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Scan requested (ret=0) - scan timeout 30 seconds
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b19 len=16
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Received 704 bytes of scan results (1 BSSes)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: New scan results available
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Selecting BSS from priority group 0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Try to find WPA-enabled AP
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: 0: 98:fc:11:8e:94:57 ssid='smoke_24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]:    selected based on RSN IE
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]:    selected WPA AP 98:fc:11:8e:94:57 ssid='smoke_24'
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Trying to associate with 98:fc:11:8e:94:57 (SSID='smoke_24' freq=2462 MHz)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPA: clearing own WPA/RSN IE
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Automatic auth_alg selection: 0x1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RSN: using IEEE 802.11i/D9.0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPA: using GTK TKIP
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPA: using PTK CCMP
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPA: using KEY_MGMT WPA-PSK
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_drop_unencrypted
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: State: SCANNING -> ASSOCIATING
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_associate
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_psk
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  scanning -> associating
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Association request to the driver failed
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 5 sec 0 usec
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP fail=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portControl=Auto
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b06 len=12
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=24
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=148
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATING -> ASSOCIATED
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Associated to a new BSS: BSSID=98:fc:11:8e:94:57
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associating -> associated
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:38 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:39 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:39 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:39 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:39 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:39 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:39 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:40 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:41 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:42 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:42 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:43 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:44 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:45 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:46 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:47 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:48 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:49 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:51 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:51 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:52 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:53 lb-bun-21 NetworkManager[899]: <warn> (wlan1): link timed out.
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:53 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:54 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:54 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:54 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:54 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:54 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:54 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:55 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:56 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:56 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=175
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=80
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: WPA: Invalid EAPOL-Key MIC when using TPTK - ignoring TPTK
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: WPA: Could not verify EAPOL-Key MIC - dropping packet
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:31:57 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: Authentication with 98:fc:11:8e:94:57 timed out.
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: BSSID 98:fc:11:8e:94:57 blacklist count incremented to 2
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_disassociate
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> DISCONNECTED
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: Setting scan request: 0 sec 0 usec
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> SCANNING
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: Starting AP scan (broadcast SSID)
Mar  7 13:32:06 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> disconnected
Mar  7 13:32:06 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  disconnected -> scanning
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: Scan requested (ret=0) - scan timeout 30 seconds
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 00:00:00:00:00:00
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: BSSID 00:00:00:00:00:00 blacklist count incremented to 2
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: State: SCANNING -> DISCONNECTED
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:06 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:32:06 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  scanning -> disconnected
Mar  7 13:32:06 lb-bun-21 kernel: [771296.237265] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.237709] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.239860] cfg80211: All devices are disconnected, going to restore regulatory settings
Mar  7 13:32:06 lb-bun-21 kernel: [771296.239868] cfg80211: Restoring regulatory settings
Mar  7 13:32:06 lb-bun-21 kernel: [771296.240015] cfg80211: Calling CRDA to update world regulatory domain
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244634] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244641] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244646] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244651] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244655] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244660] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244664] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244669] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244673] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244678] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244682] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244687] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244690] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244695] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244699] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244704] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244708] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244713] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244717] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244722] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244726] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244731] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244735] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244740] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244743] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244748] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244752] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244757] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244761] cfg80211: Disabling freq 5170 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244765] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244770] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244774] cfg80211: Updating information on frequency 5190 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244779] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244783] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244787] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244791] cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244796] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244800] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244805] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244809] cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244814] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244818] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244823] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244826] cfg80211: Disabling freq 5260 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244829] cfg80211: Disabling freq 5280 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244832] cfg80211: Disabling freq 5300 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244834] cfg80211: Disabling freq 5320 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244837] cfg80211: Disabling freq 5500 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244840] cfg80211: Disabling freq 5520 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244842] cfg80211: Disabling freq 5540 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244845] cfg80211: Disabling freq 5560 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244848] cfg80211: Disabling freq 5580 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244850] cfg80211: Disabling freq 5600 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244853] cfg80211: Disabling freq 5620 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244856] cfg80211: Disabling freq 5640 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244858] cfg80211: Disabling freq 5660 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244861] cfg80211: Disabling freq 5680 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244864] cfg80211: Disabling freq 5700 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244867] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244872] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244876] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244881] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244885] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244890] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244894] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244899] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244903] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244908] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244911] cfg80211: Disabling freq 5920 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244914] cfg80211: Disabling freq 5940 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244917] cfg80211: Disabling freq 5960 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244919] cfg80211: Disabling freq 5980 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244922] cfg80211: Disabling freq 6000 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244925] cfg80211: Disabling freq 6020 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244927] cfg80211: Disabling freq 6040 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244930] cfg80211: Disabling freq 6060 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244933] cfg80211: Disabling freq 6080 MHz
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244939] cfg80211: World regulatory domain updated:
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244942] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244946] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244951] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244955] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244960] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:06 lb-bun-21 kernel: [771296.244964] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b19 len=16
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Received 3842 bytes of scan results (7 BSSes)
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: New scan results available
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Selecting BSS from priority group 0
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Try to find WPA-enabled AP
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 0: 98:fc:11:8e:94:57 ssid='smoke_24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - blacklisted
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 1: 68:7f:74:0c:32:fa ssid='bun01_2_ap' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 2: c0:c1:c0:04:b8:2c ssid='NSN' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 3: 00:24:d2:d7:ca:39 ssid='ThomsonD7CA39' wpa_ie_len=22 rsn_ie_len=20 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 4: 20:4e:7f:7a:32:85 ssid='AP' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 5: 00:25:9c:42:9f:3f ssid='DD-WLAN2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - no WPA/RSN IE
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 6: 00:90:4c:07:00:2a ssid='bun01_1_ap' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - no WPA/RSN IE
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Try to find non-WPA AP
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 0: 98:fc:11:8e:94:57 ssid='smoke_24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - blacklisted
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 1: 68:7f:74:0c:32:fa ssid='bun01_2_ap' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 2: c0:c1:c0:04:b8:2c ssid='NSN' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 3: 00:24:d2:d7:ca:39 ssid='ThomsonD7CA39' wpa_ie_len=22 rsn_ie_len=20 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 4: 20:4e:7f:7a:32:85 ssid='AP' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 5: 00:25:9c:42:9f:3f ssid='DD-WLAN2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 6: 00:90:4c:07:00:2a ssid='bun01_1_ap' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    skip - SSID mismatch
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: No APs found - clear blacklist and try again
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Removed BSSID 98:fc:11:8e:94:57 from blacklist (clear)
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Selecting BSS from priority group 0
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Try to find WPA-enabled AP
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: 0: 98:fc:11:8e:94:57 ssid='smoke_24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    selected based on RSN IE
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:    selected WPA AP 98:fc:11:8e:94:57 ssid='smoke_24'
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Trying to associate with 98:fc:11:8e:94:57 (SSID='smoke_24' freq=2462 MHz)
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: clearing own WPA/RSN IE
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Automatic auth_alg selection: 0x1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RSN: using IEEE 802.11i/D9.0
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: using GTK TKIP
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: using PTK CCMP
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: using KEY_MGMT WPA-PSK
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_drop_unencrypted
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> ASSOCIATING
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_associate
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_psk
Mar  7 13:32:07 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  disconnected -> associating
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Association request to the driver failed
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 5 sec 0 usec
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP fail=0
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portControl=Auto
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b06 len=12
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=24
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Not associated - Delay processing of received EAPOL frame
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=148
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATING -> ASSOCIATED
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Associated to a new BSS: BSSID=98:fc:11:8e:94:57
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:32:07 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associating -> associated
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Process pending EAPOL frame that was received just before association notification
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:07 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:07 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:08 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:09 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:10 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:11 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:12 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:13 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:14 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:16 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:16 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:32:17 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:32:17 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:32:17 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:17 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:32:17 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:32:17 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> ASSOCIATED
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:32:18 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:19 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:19 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:32:19 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:21 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:21 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:32:21 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:22 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=175
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=80
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: WPA: Invalid EAPOL-Key MIC when using TPTK - ignoring TPTK
Mar  7 13:32:22 lb-bun-21 wpa_supplicant[978]: WPA: Could not verify EAPOL-Key MIC - dropping packet
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Authentication with 98:fc:11:8e:94:57 timed out.
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Added BSSID 98:fc:11:8e:94:57 into blacklist
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_disassociate
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> DISCONNECTED
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Setting scan request: 0 sec 0 usec
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> SCANNING
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Starting AP scan (specific SSID)
Mar  7 13:32:32 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> disconnected
Mar  7 13:32:32 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  disconnected -> scanning
Mar  7 13:32:32 lb-bun-21 kernel: [771321.512002] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.512499] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Scan requested (ret=0) - scan timeout 30 seconds
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 00:00:00:00:00:00
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Added BSSID 00:00:00:00:00:00 into blacklist
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: State: SCANNING -> DISCONNECTED
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:32:32 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  scanning -> disconnected
Mar  7 13:32:32 lb-bun-21 kernel: [771321.514027] cfg80211: All devices are disconnected, going to restore regulatory settings
Mar  7 13:32:32 lb-bun-21 kernel: [771321.514035] cfg80211: Restoring regulatory settings
Mar  7 13:32:32 lb-bun-21 kernel: [771321.514268] cfg80211: Calling CRDA to update world regulatory domain
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518578] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518586] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518590] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518595] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518599] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518605] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518608] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518613] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518617] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518622] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518626] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518631] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518635] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518640] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518644] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518649] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518653] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518658] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518662] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518667] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518671] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518676] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518680] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518685] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518689] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518694] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518698] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518703] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518707] cfg80211: Disabling freq 5170 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518710] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518715] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518719] cfg80211: Updating information on frequency 5190 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518724] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518728] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518733] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518737] cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518742] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518746] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518751] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518755] cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518760] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518763] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518768] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518772] cfg80211: Disabling freq 5260 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518775] cfg80211: Disabling freq 5280 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518777] cfg80211: Disabling freq 5300 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518780] cfg80211: Disabling freq 5320 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518783] cfg80211: Disabling freq 5500 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518785] cfg80211: Disabling freq 5520 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518788] cfg80211: Disabling freq 5540 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518791] cfg80211: Disabling freq 5560 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518793] cfg80211: Disabling freq 5580 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518796] cfg80211: Disabling freq 5600 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518799] cfg80211: Disabling freq 5620 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518801] cfg80211: Disabling freq 5640 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518804] cfg80211: Disabling freq 5660 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518807] cfg80211: Disabling freq 5680 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518809] cfg80211: Disabling freq 5700 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518813] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518818] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518822] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518827] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518831] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518836] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518840] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518845] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518849] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518854] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518857] cfg80211: Disabling freq 5920 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518860] cfg80211: Disabling freq 5940 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518863] cfg80211: Disabling freq 5960 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518865] cfg80211: Disabling freq 5980 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518868] cfg80211: Disabling freq 6000 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518871] cfg80211: Disabling freq 6020 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518873] cfg80211: Disabling freq 6040 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518876] cfg80211: Disabling freq 6060 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518879] cfg80211: Disabling freq 6080 MHz
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518885] cfg80211: World regulatory domain updated:
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518888] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518892] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518897] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518901] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518906] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 kernel: [771321.518910] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b19 len=16
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Received 704 bytes of scan results (1 BSSes)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: New scan results available
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Selecting BSS from priority group 0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Try to find WPA-enabled AP
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: 0: 98:fc:11:8e:94:57 ssid='smoke_24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]:    selected based on RSN IE
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]:    selected WPA AP 98:fc:11:8e:94:57 ssid='smoke_24'
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Trying to associate with 98:fc:11:8e:94:57 (SSID='smoke_24' freq=2462 MHz)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: clearing own WPA/RSN IE
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Automatic auth_alg selection: 0x1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RSN: using IEEE 802.11i/D9.0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: using GTK TKIP
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: using PTK CCMP
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: using KEY_MGMT WPA-PSK
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_drop_unencrypted
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> ASSOCIATING
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_associate
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_psk
Mar  7 13:32:32 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  disconnected -> associating
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Association request to the driver failed
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 5 sec 0 usec
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP fail=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portControl=Auto
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b06 len=12
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=24
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Not associated - Delay processing of received EAPOL frame
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=148
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATING -> ASSOCIATED
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Associated to a new BSS: BSSID=98:fc:11:8e:94:57
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:32 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associating -> associated
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Process pending EAPOL frame that was received just before association notification
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:32 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:32 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:33 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:34 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:35 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:36 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:37 lb-bun-21 NetworkManager[899]: <warn> (wlan1): link timed out.
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:37 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <warn> Activation (wlan1/wireless): association took too long.
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 5 -> 6 (reason 0)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_disassociate
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <warn> Activation (wlan1/wireless): asking for new secrets
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) scheduled...
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) started...
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 6 -> 4 (reason 0)
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) scheduled...
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 1 of 5 (Device Prepare) complete.
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) starting...
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 4 -> 5 (reason 0)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> DISCONNECTED
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1/wireless): connection 'smoke-net' has security, and secrets exist.  No new secrets needed.
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Config: added 'ssid' value 'smoke_24'
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Config: added 'scan_ssid' value '1'
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Config: added 'key_mgmt' value 'WPA-PSK'
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Config: added 'psk' value '<omitted>'
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: nm_setting_802_1x_get_pkcs11_engine_path: assertion `NM_IS_SETTING_802_1X (setting)' failed
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: nm_setting_802_1x_get_pkcs11_module_path: assertion `NM_IS_SETTING_802_1X (setting)' failed
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Activation (wlan1) Stage 2 of 5 (Device Configure) complete.
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> disconnected
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> DISCONNECTED
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> DISCONNECTED
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> Config: set interface ap_scan to 1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 00:00:00:00:00:00
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: BSSID 00:00:00:00:00:00 blacklist count incremented to 2
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> DISCONNECTED
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.396393] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:38 lb-bun-21 kernel: [771327.396897] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:38 lb-bun-21 kernel: [771327.396930] cfg80211: All devices are disconnected, going to restore regulatory settings
Mar  7 13:32:38 lb-bun-21 kernel: [771327.396935] cfg80211: Restoring regulatory settings
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:38 lb-bun-21 kernel: [771327.396940] cfg80211: Calling CRDA to update world regulatory domain
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: key_mgmt: 0x2
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: scan_ssid=1 (0x1)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402515] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402522] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402527] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402532] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402536] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402541] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402545] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402550] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402554] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402559] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402562] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402567] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402571] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402576] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402580] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402585] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402589] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402594] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402598] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402603] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402607] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402612] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402616] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402621] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402625] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402630] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402634] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402638] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402643] cfg80211: Disabling freq 5170 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402646] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402651] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402655] cfg80211: Updating information on frequency 5190 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402660] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402664] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402669] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402673] cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402678] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402682] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402687] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402690] cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402695] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402699] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402704] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402708] cfg80211: Disabling freq 5260 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402711] cfg80211: Disabling freq 5280 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402713] cfg80211: Disabling freq 5300 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402716] cfg80211: Disabling freq 5320 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402718] cfg80211: Disabling freq 5500 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402721] cfg80211: Disabling freq 5520 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402724] cfg80211: Disabling freq 5540 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402726] cfg80211: Disabling freq 5560 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402729] cfg80211: Disabling freq 5580 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402732] cfg80211: Disabling freq 5600 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402734] cfg80211: Disabling freq 5620 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402737] cfg80211: Disabling freq 5640 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402740] cfg80211: Disabling freq 5660 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402742] cfg80211: Disabling freq 5680 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402745] cfg80211: Disabling freq 5700 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402748] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402753] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402757] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402762] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402766] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402771] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402775] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402780] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402784] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402789] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402793] cfg80211: Disabling freq 5920 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402795] cfg80211: Disabling freq 5940 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402798] cfg80211: Disabling freq 5960 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402801] cfg80211: Disabling freq 5980 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402803] cfg80211: Disabling freq 6000 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402806] cfg80211: Disabling freq 6020 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402809] cfg80211: Disabling freq 6040 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402811] cfg80211: Disabling freq 6060 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402814] cfg80211: Disabling freq 6080 MHz
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402820] cfg80211: World regulatory domain updated:
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402823] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402828] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402832] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402836] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402841] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 kernel: [771327.402845] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Setting scan request: 0 sec 0 usec
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> SCANNING
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Starting AP scan (broadcast SSID)
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  disconnected -> scanning
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Scan requested (ret=0) - scan timeout 30 seconds
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b19 len=16
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Received 3842 bytes of scan results (7 BSSes)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: New scan results available
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x104a len=1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1044 len=1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1041 len=1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x103b len=1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1047 len=16
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1021 len=5
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1023 len=13
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1024 len=7
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1042 len=2
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1054 len=8
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1011 len=13
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPS: attr type=0x1008 len=2
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Selecting BSS from priority group 0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Try to find WPA-enabled AP
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: 0: 98:fc:11:8e:94:57 ssid='smoke_24' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]:    selected based on RSN IE
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]:    selected WPA AP 98:fc:11:8e:94:57 ssid='smoke_24'
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Trying to associate with 98:fc:11:8e:94:57 (SSID='smoke_24' freq=2462 MHz)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: clearing own WPA/RSN IE
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Automatic auth_alg selection: 0x1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RSN: using IEEE 802.11i/D9.0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: using GTK TKIP
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: using PTK CCMP
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: using KEY_MGMT WPA-PSK
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_drop_unencrypted
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: State: SCANNING -> ASSOCIATING
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_associate
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  scanning -> associating
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_psk
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Association request to the driver failed
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 5 sec 0 usec
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP fail=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portControl=Auto
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b06 len=12
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=24
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Not associated - Delay processing of received EAPOL frame
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=148
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATING -> ASSOCIATED
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Associated to a new BSS: BSSID=98:fc:11:8e:94:57
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associating -> associated
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Process pending EAPOL frame that was received just before association notification
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:38 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:38 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:39 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:40 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:41 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:42 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:43 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:44 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:45 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c07 len=154
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8c08 len=206
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 98:fc:11:8e:94:57
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: Association info event
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> ASSOCIATED
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: Associated with 98:fc:11:8e:94:57
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: WPA: Association event - clear replay counter
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: WPA: Clear old PTK
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:32:47 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  4-way handshake -> associated
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=1
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state IDLE
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:47 lb-bun-21 wpa_supplicant[978]: Cancelling scan request
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: EAPOL: startWhen --> 0
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: EAPOL: disable timer tick
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state CONNECTING
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: EAPOL: enable timer tick
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: EAPOL: txStart
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: RX EAPOL from 98:fc:11:8e:94:57
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: Setting authentication timeout: 10 sec 0 usec
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: IEEE 802.1X RX: version=2 type=3 length=117
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]:   EAPOL-Key type=2
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]:   key_length=16 key_data_length=22
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: State: ASSOCIATED -> 4WAY_HANDSHAKE
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: WPA: RX message 1 of 4-Way Handshake from 98:fc:11:8e:94:57 (ver=2)
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: RSN: no matching PMKID found
Mar  7 13:32:48 lb-bun-21 NetworkManager[899]: <info> (wlan1): supplicant connection state:  associated -> 4-way handshake
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: WPA: PTK derivation - A1=00:90:4c:c5:34:23 A2=98:fc:11:8e:94:57
Mar  7 13:32:48 lb-bun-21 wpa_supplicant[978]: WPA: Sending EAPOL-Key 2/4
Mar  7 13:32:49 lb-bun-21 NetworkManager[899]: <info> (wlan1): device state change: 5 -> 3 (reason 39)
Mar  7 13:32:49 lb-bun-21 NetworkManager[899]: <info> (wlan1): deactivating device (reason: 39).
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_disassociate
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: State: 4WAY_HANDSHAKE -> DISCONNECTED
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:49 lb-bun-21 avahi-daemon[903]: Interface wlan1.IPv6 no longer relevant for mDNS.
Mar  7 13:32:49 lb-bun-21 kernel: [771338.569271] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:32:49 lb-bun-21 avahi-daemon[903]: Leaving mDNS multicast group on interface wlan1.IPv6 with address fe80::290:4cff:fec5:3423.
Mar  7 13:32:49 lb-bun-21 kernel: [771338.569717] brcmfmac: ERROR @send_key_to_dongle : WLC_SET_KEY error (-8)
Mar  7 13:32:49 lb-bun-21 avahi-daemon[903]: Withdrawing address record for fe80::290:4cff:fec5:3423 on wlan1.
Mar  7 13:32:49 lb-bun-21 kernel: [771338.569743] cfg80211: All devices are disconnected, going to restore regulatory settings
Mar  7 13:32:49 lb-bun-21 kernel: [771338.569749] cfg80211: Restoring regulatory settings
Mar  7 13:32:49 lb-bun-21 kernel: [771338.569770] cfg80211: Calling CRDA to update world regulatory domain
Mar  7 13:32:49 lb-bun-21 kernel: [771338.571343] brcmfmac: _brcmf_set_multicast_list: wlan1: set promisc 0 failed
Mar  7 13:32:49 lb-bun-21 kernel: [771338.571827] brcmfmac: ERROR @brcmf_run_iscan : error (-3)
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_PAE entering state DISCONNECTED
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: SUPP_BE entering state INITIALIZE
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: No keys have been configured - skip key clearing
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> DISCONNECTED
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b15 len=24
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: Wireless event: new AP: 00:00:00:00:00:00
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: BSSID 00:00:00:00:00:00 blacklist count incremented to 3
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: State: DISCONNECTED -> DISCONNECTED
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: WEXT: Operstate: linkmode=-1, operstate=5
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portEnabled=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - portValid=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: EAPOL: External notification - EAP success=0
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: Wireless event: cmd=0x8b1a len=16
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575128] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575135] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575140] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575145] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575149] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575154] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575158] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575163] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575167] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575172] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575176] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575181] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575185] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575190] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575193] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575198] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575202] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575207] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575211] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575216] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575220] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575225] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575229] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575234] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575238] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575243] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575247] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575252] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575256] cfg80211: Disabling freq 5170 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575259] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575264] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575268] cfg80211: Updating information on frequency 5190 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575273] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575277] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575282] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575286] cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575291] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575295] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575300] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575304] cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575309] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575313] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575318] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575321] cfg80211: Disabling freq 5260 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575324] cfg80211: Disabling freq 5280 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575327] cfg80211: Disabling freq 5300 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575329] cfg80211: Disabling freq 5320 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575332] cfg80211: Disabling freq 5500 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575335] cfg80211: Disabling freq 5520 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575337] cfg80211: Disabling freq 5540 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575340] cfg80211: Disabling freq 5560 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575343] cfg80211: Disabling freq 5580 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575345] cfg80211: Disabling freq 5600 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575348] cfg80211: Disabling freq 5620 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575351] cfg80211: Disabling freq 5640 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575353] cfg80211: Disabling freq 5660 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575356] cfg80211: Disabling freq 5680 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575359] cfg80211: Disabling freq 5700 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575362] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575367] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575371] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575376] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575380] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575385] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575389] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575394] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575398] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575403] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575406] cfg80211: Disabling freq 5920 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575409] cfg80211: Disabling freq 5940 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575412] cfg80211: Disabling freq 5960 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575414] cfg80211: Disabling freq 5980 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575417] cfg80211: Disabling freq 6000 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575420] cfg80211: Disabling freq 6020 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575422] cfg80211: Disabling freq 6040 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575425] cfg80211: Disabling freq 6060 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575428] cfg80211: Disabling freq 6080 MHz
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575434] cfg80211: World regulatory domain updated:
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575437] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575441] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575446] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575450] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575454] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 kernel: [771338.575459] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar  7 13:32:49 lb-bun-21 NetworkManager[899]: <info> (wlan1): reset MAC address to 00:90:4C:11:22:33
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Mar  7 13:32:49 lb-bun-21 wpa_supplicant[978]: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Mar  7 13:32:49 lb-bun-21 kernel: [771338.579328] brcmfmac: _brcmf_set_multicast_list: wlan1: set promisc 0 failed
Mar  7 13:32:49 lb-bun-21 NetworkManager[899]: <info> Policy set 'Auto eth0' (eth0) as default for IPv4 routing and DNS.
Mar  7 13:32:49 lb-bun-21 NetworkManager[899]: <info> Policy set 'Auto eth0' (eth0) as default for IPv4 routing and DNS.
Mar  7 13:32:49 lb-bun-21 kernel: [771338.581048] brcmfmac: _brcmf_set_multicast_list: wlan1: set promisc 0 failed
Mar  7 13:32:50 lb-bun-21 avahi-daemon[903]: Joining mDNS multicast group on interface wlan1.IPv6 with address fe80::290:4cff:fec5:3423.
Mar  7 13:32:50 lb-bun-21 avahi-daemon[903]: New relevant interface wlan1.IPv6 for mDNS.
Mar  7 13:32:50 lb-bun-21 avahi-daemon[903]: Registering new address record for fe80::290:4cff:fec5:3423 on wlan1.*.
Mar  7 13:32:50 lb-bun-21 kernel: [771340.217005] brcmfmac: _brcmf_set_multicast_list: wlan1: set promisc 0 failed

--------------020500070800050400010105--

