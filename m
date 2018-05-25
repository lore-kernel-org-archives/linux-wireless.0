Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.230]:62374 "EHLO
        dnvrco-cmomta02.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S968269AbeEYUjX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 16:39:23 -0400
Message-ID: <20180525203922.QZ7AP.56018.root@dnvrco-web26> (sfid-20180525_223929_946588_38568F06)
Date: Fri, 25 May 2018 20:39:22 +0000
From: <mgreger@cinci.rr.com>
To: sedat.dilek@gmail.com
Subject: Re: Atheros AR9462 - 5Ghz not working
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CA+icZUX+p2feWOnXSA=m3i+r560Mo2kHsadT4qFhx8VvUv_k8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---- Sedat Dilek <sedat.dilek@gmail.com> wrote: 
> On Tue, May 22, 2018 at 7:21 PM,  <mgreger@cinci.rr.com> wrote:
> > I've run out of ideas and am hoping someone here can help.
> >
> > All I want to do is connect a client to my 5Ghz network.
> >
> > My client:
> >   OS is Debian stable "Stretch" with sysvinit instead of systemd
> >   Atheros AR9462 (World roaming 0x64 regdomain in EEPROM)
> >   "iw reg set US"
> >   "iw list" shows both 2.4Ghz and 5Ghz bands available.
> >   "iw wlp3s0 survey dump" shows received traffic on 5Ghz bands.
> >
> > There are oodles of 5Ghz AP's within range, but scans (including passive scans) reveal only 2.4Ghz networks. My only guess was that it won't transmit due to regulatory requirements, but I cannot make it work.
> >
> > What I've tried:
> >   Running with and without CRDA
> >   Running latest mainline kernel
> >   Hacking around on the ath9k driver and nl80211 to remove all regulatory enforcement.
> >
> > Nothing works and I'm pulling my hair out. Any help would be greatly appreciated.
> 
> Hi,
> 
> I try to give some initial help.
> 
> The linux-wireless driver is supported by ath9k driver see [1] and [2].
> 
> Unfortunately, you have not sent any log-files at least your dmesg-log.
> No output of the above userspace commands or userspace-tools versions.
> No information to VendorID/ProductID (PCI, USB, whatever).
> It's not clear to me if this is a kernelspace (ath9k-driver) or
> userspace (CRDA/regulatory) problem.
> How should someone help you effectively?
> 
> The linux-wireless wiki has somne informations on how to debug
> Atheros/Qualcomm ath9k-driver, see [3].
> 
> As a debianist I say try Linux v4.16 Debian packages from
> stretch-backports (and maybe a higher version of wireless-regdb).
> 
> Try to ask questions the smart way [4] :-).
> 
> Hope this helps.
> 
> Regards,
> - Sedat -
> 
> [1] https://wireless.wiki.kernel.org/en/users/drivers/ath9k
> [2] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/devices
> [3] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/debug
> [4] http://www.catb.org/esr/faqs/smart-questions.html



Here's everything you asked for (How could I know what to send until someone told me?):

kernel 4.9.88
iw version 4.9
crda 3.18
wireless-regdb 2016-6-10

Everything is stock debian stable except the kernel, but like I said before: completely different operating systems have the same problem.


/sys/kernel/debug/ieee80211/phy0/ath9k/base_eeprom

      EEPROM Version :          2
          RegDomain1 :        106
          RegDomain2 :         31
             TX Mask :          3
             RX Mask :          3
          Allow 5GHz :          1
          Allow 2GHz :          1
   Disable 2GHz HT20 :          0
   Disable 2GHz HT40 :          0
   Disable 5Ghz HT20 :          0
   Disable 5Ghz HT40 :          0
          Big Endian :          0
           RF Silent :         45
           BT option :          0
          Device Cap :          0
         Device Type :          5
  Power Table Offset :          0
        Tuning Caps1 :         72
        Tuning Caps2 :          0
 Enable Tx Temp Comp :          1
 Enable Tx Volt Comp :          0
   Enable fast clock :          1
     Enable doubling :          1
  Internal regulator :          1
        Enable Paprd :          1
     Driver Strength :          0
          Quick Drop :          1
   Chain mask Reduce :          0
   Write enable Gpio :          6
   WLAN Disable Gpio :          0
       WLAN LED Gpio :          8
 Rx Band Select Gpio :        255
             Tx Gain :          1
             Rx Gain :          1
              SW Reg :  303972982
          MacAddress : 74:c6:3b:bf:90:a3



/sys/kernel/debug/ieee80211/phy0/ath9k/base_eeprom

   2GHz modal Header :
 Chain0 Ant. Control :        336
 Chain1 Ant. Control :        336
 Chain2 Ant. Control :         16
 Ant. Common Control :    4195664
Ant. Common Control2 :     139810
           Ant. Gain :          0
       Switch Settle :         44
    Chain0 xatten1DB :          0
    Chain1 xatten1DB :          0
    Chain2 xatten1DB :          0
Chain0 xatten1Margin :          0
Chain1 xatten1Margin :          0
Chain2 xatten1Margin :          0
          Temp Slope :         25
          Volt Slope :          0
      spur Channels0 :        164
      spur Channels1 :          0
      spur Channels2 :          0
      spur Channels3 :          0
      spur Channels4 :          0
 Chain0 NF Threshold :         -1
 Chain1 NF Threshold :          0
 Chain2 NF Threshold :          0
          Quick Drop :          0
       txEndToXpaOff :          0
      xPA Bias Level :          0
  txFrameToDataStart :         14
       txFrameToPaOn :         14
      txFrameToXpaOn :         14
              txClip :          3
    ADC Desired size :        -30
   5GHz modal Header :
 Chain0 Ant. Control :        336
 Chain1 Ant. Control :        336
 Chain2 Ant. Control :         80
 Ant. Common Control :    8390784
Ant. Common Control2 :     139810
           Ant. Gain :          0
       Switch Settle :         45
    Chain0 xatten1DB :          0
    Chain1 xatten1DB :          0
    Chain2 xatten1DB :          0
Chain0 xatten1Margin :          0
Chain1 xatten1Margin :          0
Chain2 xatten1Margin :          0
          Temp Slope :         55
          Volt Slope :          0
      spur Channels0 :         80
      spur Channels1 :        144
      spur Channels2 :        176
      spur Channels3 :        192
      spur Channels4 :        200
 Chain0 NF Threshold :         -1
 Chain1 NF Threshold :          0
 Chain2 NF Threshold :          0
          Quick Drop :          0
       txEndToXpaOff :          0
      xPA Bias Level :          0
  txFrameToDataStart :         14
       txFrameToPaOn :         14
      txFrameToXpaOn :         14
              txClip :          3
    ADC Desired size :        -30



/sys/kernel/debug/ieee80211/phy0/ath9k/recv

          PKTS-ALL :       9721
         BYTES-ALL :    2900995
           BEACONS :       8220
             FRAGS :          0
          SPECTRAL :          0
           CRC ERR :        137
   DECRYPT CRC ERR :          4
           PHY ERR :          4
           MIC ERR :          0
 PRE-DELIM CRC ERR :          0
POST-DELIM CRC ERR :        639
  DECRYPT BUSY ERR :          0
        LENGTH-ERR :          0
           OOM-ERR :          0
          RATE-ERR :          0
    TOO-MANY-FRAGS :          0



lspci -vs 03:00

03:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network Adapter (rev 01)
	Subsystem: AzureWave AR9462 Wireless Network Adapter
	Flags: bus master, fast devsel, latency 0, IRQ 18
	Memory at df000000 (64-bit, non-prefetchable) [size=512K]
	Expansion ROM at df080000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 2
	Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
	Capabilities: [70] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: ath9k
	Kernel modules: ath9k



iw reg get

global
country US: DFS-FCC
	(2402 - 2472 @ 40), (N/A, 30), (N/A)
	(5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
	(5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
	(5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
	(5735 - 5835 @ 80), (N/A, 30), (N/A)
	(57240 - 63720 @ 2160), (N/A, 40), (N/A)



iw wlp3s0 info

Interface wlp3s0
	ifindex 3
	wdev 0x1
	addr 74:c6:3b:bf:90:a3
	type managed
	wiphy 0
	channel 8 (2447 MHz), width: 20 MHz, center1: 2447 MHz
	txpower 19.00 dBm



iw list

Wiphy phy0
	max # scan SSIDs: 4
	max scan IEs length: 2257 bytes
	max # sched scan SSIDs: 0
	max # match sets: 0
	max # scan plans: 1
	max scan plan interval: -1
	max scan plan iterations: 0
	Retry short limit: 7
	Retry long limit: 4
	Coverage class: 0 (up to 0m)
	Device supports RSN-IBSS.
	Device supports AP-side u-APSD.
	Device supports T-DLS.
	Supported Ciphers:
		* WEP40 (00-0f-ac:1)
		* WEP104 (00-0f-ac:5)
		* TKIP (00-0f-ac:2)
		* CCMP-128 (00-0f-ac:4)
		* CCMP-256 (00-0f-ac:10)
		* GCMP-128 (00-0f-ac:8)
		* GCMP-256 (00-0f-ac:9)
		* CMAC (00-0f-ac:6)
		* CMAC-256 (00-0f-ac:13)
		* GMAC-128 (00-0f-ac:11)
		* GMAC-256 (00-0f-ac:12)
	Available Antennas: TX 0x3 RX 0x3
	Configured Antennas: TX 0x3 RX 0x3
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * WDS
		 * monitor
		 * mesh point
		 * P2P-client
		 * P2P-GO
		 * outside context of a BSS
	Band 1:
		Capabilities: 0x11ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-15
		Bitrates (non-HT):
			* 1.0 Mbps
			* 2.0 Mbps (short preamble supported)
			* 5.5 Mbps (short preamble supported)
			* 11.0 Mbps (short preamble supported)
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
		Frequencies:
			* 2412 MHz [1] (30.0 dBm)
			* 2417 MHz [2] (30.0 dBm)
			* 2422 MHz [3] (30.0 dBm)
			* 2427 MHz [4] (30.0 dBm)
			* 2432 MHz [5] (30.0 dBm)
			* 2437 MHz [6] (30.0 dBm)
			* 2442 MHz [7] (30.0 dBm)
			* 2447 MHz [8] (30.0 dBm)
			* 2452 MHz [9] (30.0 dBm)
			* 2457 MHz [10] (30.0 dBm)
			* 2462 MHz [11] (30.0 dBm)
			* 2467 MHz [12] (disabled)
			* 2472 MHz [13] (disabled)
			* 2484 MHz [14] (disabled)
	Band 2:
		Capabilities: 0x11ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-15
		Bitrates (non-HT):
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
		Frequencies:
			* 5180 MHz [36] (23.0 dBm)
			* 5200 MHz [40] (23.0 dBm)
			* 5220 MHz [44] (23.0 dBm)
			* 5240 MHz [48] (23.0 dBm)
			* 5260 MHz [52] (23.0 dBm) (radar detection)
			* 5280 MHz [56] (23.0 dBm) (radar detection)
			* 5300 MHz [60] (23.0 dBm) (radar detection)
			* 5320 MHz [64] (23.0 dBm) (radar detection)
			* 5500 MHz [100] (23.0 dBm) (radar detection)
			* 5520 MHz [104] (23.0 dBm) (radar detection)
			* 5540 MHz [108] (23.0 dBm) (radar detection)
			* 5560 MHz [112] (23.0 dBm) (radar detection)
			* 5580 MHz [116] (23.0 dBm) (radar detection)
			* 5600 MHz [120] (23.0 dBm) (radar detection)
			* 5620 MHz [124] (23.0 dBm) (radar detection)
			* 5640 MHz [128] (23.0 dBm) (radar detection)
			* 5660 MHz [132] (23.0 dBm) (radar detection)
			* 5680 MHz [136] (23.0 dBm) (radar detection)
			* 5700 MHz [140] (23.0 dBm) (radar detection)
			* 5745 MHz [149] (30.0 dBm)
			* 5765 MHz [153] (30.0 dBm)
			* 5785 MHz [157] (30.0 dBm)
			* 5805 MHz [161] (30.0 dBm)
			* 5825 MHz [165] (30.0 dBm)
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * start_ap
		 * new_station
		 * new_mpath
		 * set_mesh_config
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * join_mesh
		 * remain_on_channel
		 * set_tx_bitrate_mask
		 * frame
		 * frame_wait_cancel
		 * set_wiphy_netns
		 * set_channel
		 * set_wds_peer
		 * tdls_mgmt
		 * tdls_oper
		 * probe_client
		 * set_noack_map
		 * register_beacons
		 * start_p2p_device
		 * set_mcast_rate
		 * channel_switch
		 * set_qos_map
		 * connect
		 * disconnect
	Supported TX frame types:
		 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
	Supported RX frame types:
		 * IBSS: 0x40 0xb0 0xc0 0xd0
		 * managed: 0x40 0xd0
		 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * mesh point: 0xb0 0xc0 0xd0
		 * P2P-client: 0x40 0xd0
		 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * P2P-device: 0x40 0xd0
	software interface modes (can always be added):
		 * AP/VLAN
		 * monitor
	valid interface combinations:
		 * #{ managed } <= 2048, #{ AP, mesh point } <= 8, #{ P2P-client, P2P-GO } <= 1,
		   total <= 2048, #channels <= 1, STA/AP BI must match
		 * #{ WDS } <= 2048,
		   total <= 2048, #channels <= 1, STA/AP BI must match
	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
	Device supports TX status socket option.
	Device supports HT-IBSS.
	Device supports SAE with AUTHENTICATE command
	Device supports low priority scan.
	Device supports scan flush.
	Device supports AP scan.
	Device supports per-vif TX power setting
	P2P GO supports CT window setting
	Driver supports full state transitions for AP/GO clients
	Driver supports a userspace MPM
	Device supports active monitor (which will ACK incoming frames)
	Driver/device bandwidth changes during BSS lifetime (AP/GO mode)
	Device supports configuring vdev MAC-addr on create.



iw phy0 channels

Band 1:
	* 2412 MHz [1] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40+
	* 2417 MHz [2] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40+
	* 2422 MHz [3] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40+
	* 2427 MHz [4] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40+
	* 2432 MHz [5] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40- HT40+
	* 2437 MHz [6] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40- HT40+
	* 2442 MHz [7] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40- HT40+
	* 2447 MHz [8] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40-
	* 2452 MHz [9] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40-
	* 2457 MHz [10] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40-
	* 2462 MHz [11] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40-
	* 2467 MHz [12] (disabled)
	* 2472 MHz [13] (disabled)
	* 2484 MHz [14] (disabled)
Band 2:
	* 5180 MHz [36] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40+
	* 5200 MHz [40] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40- HT40+
	* 5220 MHz [44] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40- HT40+
	* 5240 MHz [48] 
	  Maximum TX power: 16.0 dBm
	  Channel widths: 20MHz HT40- HT40+
	* 5260 MHz [52] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5280 MHz [56] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5300 MHz [60] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5320 MHz [64] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40-
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5500 MHz [100] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5520 MHz [104] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5540 MHz [108] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5560 MHz [112] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5580 MHz [116] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5600 MHz [120] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5620 MHz [124] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5640 MHz [128] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5660 MHz [132] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5680 MHz [136] 
	  Maximum TX power: 17.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40- HT40+
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5700 MHz [140] 
	  Maximum TX power: 16.0 dBm
	  Radar detection
	  Channel widths: 20MHz HT40-
	  DFS state: usable (for 82 sec)
	  DFS CAC time: 60000 ms
	* 5745 MHz [149] 
	  Maximum TX power: 17.0 dBm
	  Channel widths: 20MHz HT40+
	* 5765 MHz [153] 
	  Maximum TX power: 17.0 dBm
	  Channel widths: 20MHz HT40- HT40+
	* 5785 MHz [157] 
	  Maximum TX power: 17.0 dBm
	  Channel widths: 20MHz HT40- HT40+
	* 5805 MHz [161] 
	  Maximum TX power: 17.0 dBm
	  Channel widths: 20MHz HT40- HT40+
	* 5825 MHz [165] 
	  Maximum TX power: 17.0 dBm
	  Channel widths: 20MHz HT40-



iw wlp3s0 survey dump

Survey data from wlp3s0
	frequency:			2412 MHz
	noise:				-86 dBm
	channel active time:		216 ms
	channel busy time:		70 ms
	channel receive time:		44 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			2417 MHz
	noise:				-86 dBm
	channel active time:		63 ms
	channel busy time:		15 ms
	channel receive time:		8 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			2422 MHz
	noise:				-86 dBm
	channel active time:		63 ms
	channel busy time:		12 ms
	channel receive time:		10 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			2427 MHz
	noise:				-87 dBm
	channel active time:		63 ms
	channel busy time:		10 ms
	channel receive time:		4 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			2432 MHz
	noise:				-87 dBm
	channel active time:		62 ms
	channel busy time:		13 ms
	channel receive time:		8 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			2437 MHz
	noise:				-87 dBm
	channel active time:		62 ms
	channel busy time:		18 ms
	channel receive time:		16 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			2442 MHz
	noise:				-87 dBm
	channel active time:		62 ms
	channel busy time:		8 ms
	channel receive time:		4 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			2447 MHz [in use]
	noise:				-89 dBm
	channel active time:		615524 ms
	channel busy time:		76644 ms
	channel receive time:		72453 ms
	channel transmit time:		120 ms
Survey data from wlp3s0
	frequency:			2452 MHz
	noise:				-88 dBm
	channel active time:		63 ms
	channel busy time:		4 ms
	channel receive time:		1 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			2457 MHz
	noise:				-88 dBm
	channel active time:		62 ms
	channel busy time:		8 ms
	channel receive time:		5 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			2462 MHz
	noise:				-89 dBm
	channel active time:		62 ms
	channel busy time:		12 ms
	channel receive time:		9 ms
	channel transmit time:		1 ms
Survey data from wlp3s0
	frequency:			5180 MHz
	noise:				-78 dBm
	channel active time:		67 ms
	channel busy time:		21 ms
	channel receive time:		15 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5200 MHz
	noise:				-95 dBm
	channel active time:		63 ms
	channel busy time:		0 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5220 MHz
	noise:				-78 dBm
	channel active time:		62 ms
	channel busy time:		19 ms
	channel receive time:		17 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5240 MHz
	noise:				-78 dBm
	channel active time:		63 ms
	channel busy time:		15 ms
	channel receive time:		13 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5260 MHz
	noise:				-78 dBm
	channel active time:		111 ms
	channel busy time:		42 ms
	channel receive time:		41 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5280 MHz
	noise:				-78 dBm
	channel active time:		110 ms
	channel busy time:		42 ms
	channel receive time:		41 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5300 MHz
	noise:				-78 dBm
	channel active time:		110 ms
	channel busy time:		29 ms
	channel receive time:		28 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5320 MHz
	noise:				-78 dBm
	channel active time:		110 ms
	channel busy time:		41 ms
	channel receive time:		40 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5500 MHz
	noise:				-77 dBm
	channel active time:		111 ms
	channel busy time:		45 ms
	channel receive time:		44 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5520 MHz
	noise:				-95 dBm
	channel active time:		110 ms
	channel busy time:		0 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5540 MHz
	noise:				-78 dBm
	channel active time:		111 ms
	channel busy time:		44 ms
	channel receive time:		43 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5560 MHz
	noise:				-77 dBm
	channel active time:		111 ms
	channel busy time:		40 ms
	channel receive time:		39 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5580 MHz
	noise:				-78 dBm
	channel active time:		110 ms
	channel busy time:		39 ms
	channel receive time:		38 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5600 MHz
	noise:				-78 dBm
	channel active time:		110 ms
	channel busy time:		27 ms
	channel receive time:		26 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5620 MHz
	noise:				-78 dBm
	channel active time:		111 ms
	channel busy time:		27 ms
	channel receive time:		27 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5640 MHz
	noise:				-78 dBm
	channel active time:		110 ms
	channel busy time:		30 ms
	channel receive time:		29 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5660 MHz
	noise:				-79 dBm
	channel active time:		110 ms
	channel busy time:		44 ms
	channel receive time:		43 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5680 MHz
	noise:				-95 dBm
	channel active time:		110 ms
	channel busy time:		0 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5700 MHz
	noise:				-78 dBm
	channel active time:		110 ms
	channel busy time:		32 ms
	channel receive time:		31 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5745 MHz
	noise:				-78 dBm
	channel active time:		63 ms
	channel busy time:		14 ms
	channel receive time:		13 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5765 MHz
	noise:				-79 dBm
	channel active time:		62 ms
	channel busy time:		14 ms
	channel receive time:		12 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5785 MHz
	noise:				-78 dBm
	channel active time:		63 ms
	channel busy time:		20 ms
	channel receive time:		18 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5805 MHz
	noise:				-78 dBm
	channel active time:		62 ms
	channel busy time:		10 ms
	channel receive time:		9 ms
	channel transmit time:		0 ms
Survey data from wlp3s0
	frequency:			5825 MHz
	noise:				-79 dBm
	channel active time:		63 ms
	channel busy time:		24 ms
	channel receive time:		22 ms
	channel transmit time:		0 ms



iw dev wlp3s0 scan

BSS 60:31:97:0f:d0:41(on wlp3s0)
	TSF: 4540802549928 usec (52d, 13:20:02)
	freq: 2412
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -76.00 dBm
	last seen: 8200 ms ago
	Information elements from Probe Response frame:
	SSID: Home
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0 
	DS Parameter set: channel 1
	ERP: Barker_Preamble_Mode
	Extended supported rates: 6.0* 9.0 12.0* 48.0 
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	BSS Load:
		 * station count: 2
		 * channel utilisation: 53/255
		 * available admission capacity: 0 [*32us]
	HT capabilities:
		Capabilities: 0x8bc
			HT20
			SM Power Save disabled
			RX Greenfield
			RX HT20 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 1
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 1
		 * HT protection: nonmember
		 * non-GF present: 1
		 * OBSS non-GF present: 1
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: Extended Channel Switching, BSS Transition, 6
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * Response Type: 3 (AP)
		 * UUID: 677b63dd-ca69-3baf-6473-e9e8105d1d6a
		 * Manufacturer: ZyXEL
		 * Model: EMG3415-B10A
		 * Model Number: EMG3415-B10A
		 * Serial Number: S172V19000107
		 * Primary Device Type: 6-0050f204-1
		 * Device name: EMG3415-B10A ZyXELAP 2.4G
		 * Config methods: Label, Display
		 * RF Bands: 0x1
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS aa:40:a0:56:93:af(on wlp3s0)
	TSF: 1849339597187 usec (21d, 09:42:19)
	freq: 2412
	beacon interval: 100 TUs
	capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
	signal: -60.00 dBm
	last seen: 8176 ms ago
	Information elements from Probe Response frame:
	SSID: 
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
	DS Parameter set: channel 1
	TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
	Country: US	Environment: Indoor/Outdoor
		Channels [1 - 11] @ 127 dBm
	ERP: <no flags>
	Extended supported rates: 24.0 36.0 48.0 54.0 
	HT capabilities:
		Capabilities: 0x19ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: No restriction (0x00)
		HT TX/RX MCS rate indexes supported: 0-15
	HT operation:
		 * primary channel: 1
		 * secondary channel offset: above
		 * STA channel width: any
		 * RIFS: 0
		 * HT protection: no
		 * non-GF present: 1
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Overlapping BSS scan params:
		 * passive dwell: 20 TUs
		 * active dwell: 10 TUs
		 * channel width trigger scan interval: 300 s
		 * scan passive total per channel: 200 TUs
		 * scan active total per channel: 20 TUs
		 * BSS width channel transition delay factor: 5
		 * OBSS Scan Activity Threshold: 0.25 %
	Extended capabilities: HT Information Exchange Supported, Extended Channel Switching, TFS, WNM-Sleep Mode, TIM Broadcast, BSS Transition, SSID List, 6
	VHT capabilities:
		VHT Capabilities (0x338959b2):
			Max MPDU length: 11454
			Supported Channel Width: neither 160 nor 80+80
			RX LDPC
			short GI (80 MHz)
			TX STBC
			SU Beamformer
			SU Beamformee
			MU Beamformer
			RX antenna pattern consistency
			TX antenna pattern consistency
		VHT RX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: not supported
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT RX highest supported: 0 Mbps
		VHT TX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: not supported
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT TX highest supported: 0 Mbps
	VHT operation:
		 * channel width: 0 (20 or 40 MHz)
		 * center freq segment 1: 0
		 * center freq segment 2: 0
		 * VHT basic MCS set: 0xfffc
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
BSS a6:40:a0:56:93:af(on wlp3s0)
	TSF: 1849339615943 usec (21d, 09:42:19)
	freq: 2412
	beacon interval: 100 TUs
	capability: ESS Privacy ShortPreamble ShortSlotTime RadioMeasure (0x1431)
	signal: -63.00 dBm
	last seen: 7920 ms ago
	Information elements from Probe Response frame:
	SSID: ORBI84
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
	DS Parameter set: channel 1
	Country: US	Environment: Indoor/Outdoor
		Channels [1 - 11] @ 127 dBm
	ERP: <no flags>
	Extended supported rates: 24.0 36.0 48.0 54.0 
	HT capabilities:
		Capabilities: 0x19ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: No restriction (0x00)
		HT TX/RX MCS rate indexes supported: 0-15
	HT operation:
		 * primary channel: 1
		 * secondary channel offset: above
		 * STA channel width: any
		 * RIFS: 0
		 * HT protection: no
		 * non-GF present: 1
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Overlapping BSS scan params:
		 * passive dwell: 20 TUs
		 * active dwell: 10 TUs
		 * channel width trigger scan interval: 300 s
		 * scan passive total per channel: 200 TUs
		 * scan active total per channel: 20 TUs
		 * BSS width channel transition delay factor: 5
		 * OBSS Scan Activity Threshold: 0.25 %
	Extended capabilities: HT Information Exchange Supported, Extended Channel Switching, TFS, WNM-Sleep Mode, TIM Broadcast, BSS Transition, SSID List, 6
	VHT capabilities:
		VHT Capabilities (0x338041b2):
			Max MPDU length: 11454
			Supported Channel Width: neither 160 nor 80+80
			RX LDPC
			short GI (80 MHz)
			TX STBC
			RX antenna pattern consistency
			TX antenna pattern consistency
		VHT RX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: not supported
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT RX highest supported: 0 Mbps
		VHT TX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: not supported
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT TX highest supported: 0 Mbps
	VHT operation:
		 * channel width: 0 (20 or 40 MHz)
		 * center freq segment 1: 0
		 * center freq segment 2: 0
		 * VHT basic MCS set: 0xfffc
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * Response Type: 3 (AP)
		 * UUID: 87654321-9abc-def0-1234-a040a05693af
		 * Manufacturer: openwrt.org
		 * Model: WAP
		 * Model Number: 123
		 * Serial Number: 12345
		 * Primary Device Type: 6-0050f204-1
		 * Device name: RBR40(Wireless AP)
		 * Config methods:
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
BSS 58:90:43:47:5d:7c(on wlp3s0)
	TSF: 671994675584 usec (7d, 18:39:54)
	freq: 2437
	beacon interval: 100 TUs
	capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
	signal: -75.00 dBm
	last seen: 132 ms ago
	Information elements from Probe Response frame:
	SSID: ListWifi
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0* 9.0 12.0* 18.0 
	DS Parameter set: channel 6
	TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
	Country: US	Environment: Indoor/Outdoor
		Channels [1 - 11] @ 30 dBm
	ERP: <no flags>
	Extended supported rates: 24.0* 36.0 48.0 54.0 
	HT capabilities:
		Capabilities: 0x1ad
			RX LDPC
			HT20
			SM Power Save disabled
			RX HT20 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-23
	HT operation:
		 * primary channel: 6
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: nonmember
		 * non-GF present: 0
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: TFS, WNM-Sleep Mode, TIM Broadcast, BSS Transition, 6
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
BSS a0:e4:cb:92:d6:3b(on wlp3s0)
	TSF: 170084643804 usec (1d, 23:14:44)
	freq: 2442
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -72.00 dBm
	last seen: 240 ms ago
	Information elements from Probe Response frame:
	SSID: ZyXEL39005
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 7
	ERP: Barker_Preamble_Mode
	ERP D4.0: Barker_Preamble_Mode
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	Extended supported rates: 6.0 9.0 12.0 48.0 
	BSS Load:
		 * station count: 4
		 * channel utilisation: 59/255
		 * available admission capacity: 0 [*32us]
	HT capabilities:
		Capabilities: 0x18ac
			HT20
			SM Power Save disabled
			RX HT20 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 7
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: no
		 * non-GF present: 1
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: BSS Transition
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 1 (Unconfigured)
		 * Response Type: 3 (AP)
		 * UUID: 6964dff7-f9ec-882d-bbf8-b4251d765cbb
		 * Manufacturer: ZyXEL
		 * Model: VMG4381-B10A
		 * Model Number: VMG4381-B10A
		 * Serial Number: 96368GW
		 * Primary Device Type: 6-0050f204-1
		 * Device name: VMG4381-B10A
		 * Config methods: Label, Display
		 * RF Bands: 0x1
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 58:8b:f3:a2:04:01(on wlp3s0)
	TSF: 1026097385439 usec (11d, 21:01:37)
	freq: 2442
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -78.00 dBm
	last seen: 104 ms ago
	Information elements from Probe Response frame:
	SSID: ZyXEL28348
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 7
	ERP: <no flags>
	ERP D4.0: <no flags>
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	Extended supported rates: 6.0 9.0 12.0 48.0 
	BSS Load:
		 * station count: 1
		 * channel utilisation: 93/255
		 * available admission capacity: 0 [*32us]
	HT capabilities:
		Capabilities: 0x18ac
			HT20
			SM Power Save disabled
			RX HT20 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 7
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: no
		 * non-GF present: 1
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: BSS Transition
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 1 (Unconfigured)
		 * Response Type: 3 (AP)
		 * UUID: 9267b03e-2d9f-963b-e8c9-705fbbbed7d5
		 * Manufacturer: ZyXEL
		 * Model: VMG4381-B10A
		 * Model Number: VMG4381-B10A
		 * Serial Number: 96368GW
		 * Primary Device Type: 6-0050f204-1
		 * Device name: VMG4381-B10A
		 * Config methods: Label, Display
		 * RF Bands: 0x1
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS c0:56:27:62:ac:49(on wlp3s0) -- associated
	TSF: 522053362683 usec (6d, 01:00:53)
	freq: 2447
	beacon interval: 100 TUs
	capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
	signal: -19.00 dBm
	last seen: 124 ms ago
	Information elements from Probe Response frame:
	SSID: ?
	Supported rates: 1.0* 2.0* 5.5* 11.0* 22.0 6.0 9.0 12.0 
	DS Parameter set: channel 8
	Country: US	Environment: Indoor/Outdoor
		Channels [1 - 11] @ 30 dBm
	ERP: <no flags>
	Extended supported rates: 18.0 24.0 36.0 48.0 54.0 
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	HT capabilities:
		Capabilities: 0x106f
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-23, 32
	HT operation:
		 * primary channel: 8
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: no
		 * non-GF present: 1
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: Extended Channel Switching, 6
	WMM:	 * Parameter version 1
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 00:ac:e0:7e:26:30(on wlp3s0)
	TSF: 515368038772 usec (5d, 23:09:28)
	freq: 2462
	beacon interval: 100 TUs
	capability: ESS Privacy ShortPreamble ShortSlotTime APSD (0x0c31)
	signal: -70.00 dBm
	last seen: 6520 ms ago
	Information elements from Probe Response frame:
	SSID: Wagoner1
	Supported rates: 1.0* 2.0* 5.5* 11.0* 9.0 18.0 36.0 54.0 
	DS Parameter set: channel 11
	Extended supported rates: 6.0 12.0 24.0 48.0 
	Country: US	Environment: Indoor/Outdoor
		Channels [1 - 11] @ 36 dBm
	TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * UUID: 36135900-1dd2-11b2-8601-5753435f5555
		 * RF Bands: 0x1
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	ERP: <no flags>
	HT capabilities:
		Capabilities: 0x1ec
			HT20
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT RX MCS rate indexes supported: 0-23
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 11
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: no
		 * non-GF present: 0
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: HT Information Exchange Supported
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
	BSS Load:
		 * station count: 0
		 * channel utilisation: 21/255
		 * available admission capacity: 31250 [*32us]
BSS e8:37:7a:d2:a5:93(on wlp3s0)
	TSF: 7212237926787 usec (83d, 11:23:57)
	freq: 2462
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -63.00 dBm
	last seen: 96 ms ago
	Information elements from Probe Response frame:
	SSID: ZyXEL80126
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 11
	TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x2
	ERP: Use_Protection Barker_Preamble_Mode
	ERP D4.0: Use_Protection Barker_Preamble_Mode
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	Extended supported rates: 6.0 9.0 12.0 48.0 
	BSS Load:
		 * station count: 2
		 * channel utilisation: 75/255
		 * available admission capacity: 0 [*32us]
	HT capabilities:
		Capabilities: 0x18ac
			HT20
			SM Power Save disabled
			RX HT20 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 11
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: non-HT mixed
		 * non-GF present: 1
		 * OBSS non-GF present: 1
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: BSS Transition
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * UUID: d2e04b00-bcc6-3c0c-3ede-560199179809
		 * RF Bands: 0x1
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS b8:ec:a3:50:1a:94(on wlp3s0)
	TSF: 4156384459795 usec (48d, 02:33:04)
	freq: 2432
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -81.00 dBm
	last seen: 7552 ms ago
	Information elements from Probe Response frame:
	SSID: ZyXEL03149
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 5
	ERP: Barker_Preamble_Mode
	ERP D4.0: Barker_Preamble_Mode
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	Extended supported rates: 6.0 9.0 12.0 48.0 
	BSS Load:
		 * station count: 7
		 * channel utilisation: 80/255
		 * available admission capacity: 0 [*32us]
	HT capabilities:
		Capabilities: 0x18ac
			HT20
			SM Power Save disabled
			RX HT20 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 5
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: nonmember
		 * non-GF present: 1
		 * OBSS non-GF present: 1
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: BSS Transition
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 1 (Unconfigured)
		 * Response Type: 3 (AP)
		 * UUID: 8edb1b1f-8868-d690-039e-ea062272c6d7
		 * Manufacturer: ZyXEL
		 * Model: VMG4381-B10A
		 * Model Number: VMG4381-B10A
		 * Serial Number: 96368GW
		 * Primary Device Type: 6-0050f204-1
		 * Device name: VMG4381-B10A
		 * Config methods: Label, Display
		 * RF Bands: 0x1
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 9c:3d:cf:09:92:60(on wlp3s0)
	TSF: 1849362077524 usec (21d, 09:42:42)
	freq: 2412
	beacon interval: 300 TUs
	capability: ESS Privacy ShortPreamble ShortSlotTime RadioMeasure (0x1431)
	signal: -67.00 dBm
	last seen: 7864 ms ago
	Information elements from Probe Response frame:
	SSID: ORBI84
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
	DS Parameter set: channel 1
	ERP: <no flags>
	Extended supported rates: 24.0 36.0 48.0 54.0 
	HT capabilities:
		Capabilities: 0x19ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: No restriction (0x00)
		HT TX/RX MCS rate indexes supported: 0-15
	HT operation:
		 * primary channel: 1
		 * secondary channel offset: above
		 * STA channel width: any
		 * RIFS: 0
		 * HT protection: nonmember
		 * non-GF present: 1
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Overlapping BSS scan params:
		 * passive dwell: 20 TUs
		 * active dwell: 10 TUs
		 * channel width trigger scan interval: 300 s
		 * scan passive total per channel: 200 TUs
		 * scan active total per channel: 20 TUs
		 * BSS width channel transition delay factor: 5
		 * OBSS Scan Activity Threshold: 0.25 %
	Extended capabilities: HT Information Exchange Supported, Extended Channel Switching, TFS, WNM-Sleep Mode, TIM Broadcast, BSS Transition, SSID List, 6
	VHT capabilities:
		VHT Capabilities (0x338041b2):
			Max MPDU length: 11454
			Supported Channel Width: neither 160 nor 80+80
			RX LDPC
			short GI (80 MHz)
			TX STBC
			RX antenna pattern consistency
			TX antenna pattern consistency
		VHT RX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: not supported
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT RX highest supported: 0 Mbps
		VHT TX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: not supported
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT TX highest supported: 0 Mbps
	VHT operation:
		 * channel width: 0 (20 or 40 MHz)
		 * center freq segment 1: 0
		 * center freq segment 2: 0
		 * VHT basic MCS set: 0xfffc
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * Response Type: 3 (AP)
		 * UUID: 87654321-9abc-def0-1234-9c3dcf099260
		 * Manufacturer: openwrt.org
		 * Model: WAP
		 * Model Number: 123
		 * Serial Number: 12345
		 * Primary Device Type: 6-0050f204-1
		 * Device name: RBW30(Wireless AP)
		 * Config methods:
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
BSS 74:44:01:3d:9c:03(on wlp3s0)
	TSF: 6897418342787 usec (79d, 19:56:58)
	freq: 2412
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -71.00 dBm
	last seen: 8248 ms ago
	Information elements from Probe Response frame:
	SSID: 1087
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 1
	TIM: DTIM Count 1 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x0
	ERP: Barker_Preamble_Mode
	ERP D4.0: Barker_Preamble_Mode
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	Extended supported rates: 6.0 9.0 12.0 48.0 
	HT capabilities:
		Capabilities: 0x18fc
			HT20
			SM Power Save disabled
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 1
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: non-HT mixed
		 * non-GF present: 1
		 * OBSS non-GF present: 1
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Overlapping BSS scan params:
		 * passive dwell: 20 TUs
		 * active dwell: 10 TUs
		 * channel width trigger scan interval: 300 s
		 * scan passive total per channel: 200 TUs
		 * scan active total per channel: 20 TUs
		 * BSS width channel transition delay factor: 5
		 * OBSS Scan Activity Threshold: 0.25 %
	Extended capabilities: HT Information Exchange Supported
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * UUID: 72e9a727-0304-3186-62c4-927362e67f0a
		 * RF Bands: 0x3
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 1c:74:0d:58:4d:68(on wlp3s0)
	TSF: 10984278181146 usec (127d, 03:11:18)
	freq: 2412
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -78.00 dBm
	last seen: 8164 ms ago
	Information elements from Probe Response frame:
	SSID: Sophie
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 1
	ERP: <no flags>
	ERP D4.0: <no flags>
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	Extended supported rates: 6.0 9.0 12.0 48.0 
	BSS Load:
		 * station count: 2
		 * channel utilisation: 100/255
		 * available admission capacity: 0 [*32us]
	HT capabilities:
		Capabilities: 0x18ac
			HT20
			SM Power Save disabled
			RX HT20 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 1
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: nonmember
		 * non-GF present: 1
		 * OBSS non-GF present: 1
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: BSS Transition
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * Response Type: 3 (AP)
		 * UUID: cf44a35e-5217-ac12-139c-99aaf31998d2
		 * Manufacturer: ZyXEL
		 * Model: VMG4381-B10A
		 * Model Number: VMG4381-B10A
		 * Serial Number: 96368GW
		 * Primary Device Type: 6-0050f204-1
		 * Device name: VMG4381-B10A
		 * Config methods: Label, Display
		 * RF Bands: 0x1
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 60:31:97:24:bb:0c(on wlp3s0)
	TSF: 3879963961644 usec (44d, 21:46:03)
	freq: 2452
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -78.00 dBm
	last seen: 120 ms ago
	Information elements from Probe Response frame:
	SSID: ZyXEL47078
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 9
	ERP: Barker_Preamble_Mode
	ERP D4.0: Barker_Preamble_Mode
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	Extended supported rates: 6.0 9.0 12.0 48.0 
	BSS Load:
		 * station count: 5
		 * channel utilisation: 39/255
		 * available admission capacity: 0 [*32us]
	HT capabilities:
		Capabilities: 0x18ac
			HT20
			SM Power Save disabled
			RX HT20 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 9
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: no
		 * non-GF present: 1
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: BSS Transition
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 1 (Unconfigured)
		 * Response Type: 3 (AP)
		 * UUID: cf05e0b4-24ab-9316-9113-1700541dfd46
		 * Manufacturer: ZyXEL
		 * Model: VMG4381-B10A
		 * Model Number: VMG4381-B10A
		 * Serial Number: 96368GW
		 * Primary Device Type: 6-0050f204-1
		 * Device name: VMG4381-B10A
		 * Config methods: Label, Display
		 * RF Bands: 0x1
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 1c:74:0d:63:ea:5a(on wlp3s0)
	TSF: 5779329748295 usec (66d, 21:22:09)
	freq: 2462
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -68.00 dBm
	last seen: 6552 ms ago
	Information elements from Probe Response frame:
	SSID: ZyXEL92807
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 11
	TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
	ERP: Barker_Preamble_Mode
	ERP D4.0: Barker_Preamble_Mode
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)
	Extended supported rates: 6.0 9.0 12.0 48.0 
	BSS Load:
		 * station count: 3
		 * channel utilisation: 67/255
		 * available admission capacity: 0 [*32us]
	HT capabilities:
		Capabilities: 0x18ac
			HT20
			SM Power Save disabled
			RX HT20 SGI
			TX STBC
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 11
		 * secondary channel offset: no secondary
		 * STA channel width: 20 MHz
		 * RIFS: 0
		 * HT protection: nonmember
		 * non-GF present: 1
		 * OBSS non-GF present: 1
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Extended capabilities: BSS Transition
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * UUID: b719957c-dc0a-b468-b77f-91ebb907d44e
		 * RF Bands: 0x1
		 * Unknown TLV (0x1049, 6 bytes): 00 37 2a 00 01 20
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
BSS 34:64:a9:86:23:33(on wlp3s0)
	TSF: 2589478707522 usec (29d, 23:17:58)
	freq: 2462
	beacon interval: 100 TUs
	capability: ESS ShortPreamble ShortSlotTime (0x0421)
	signal: -63.00 dBm
	last seen: 6548 ms ago
	Information elements from Probe Response frame:
	SSID: HP-Print-33-ENVY 4500 series
	Supported rates: 1.0 2.0 5.5 6.0 9.0 11.0 12.0 18.0 
	DS Parameter set: channel 11
	TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
	ERP: <no flags>
	Extended supported rates: 24.0 36.0 48.0 54.0 
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
