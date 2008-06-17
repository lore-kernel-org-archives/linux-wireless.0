Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:53947 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYFQNb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 09:31:26 -0400
Received: from localhost (durandal.nerv-un.net [199.201.145.179])
	by durandal.nerv-un.net (Postfix) with ESMTP id 92790BC022
	for <linux-wireless@vger.kernel.org>; Tue, 17 Jun 2008 05:28:39 -0400 (EDT)
Date: Tue, 17 Jun 2008 09:24:01 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: linux-wireless@vger.kernel.org
Subject: More 4965 woes
Message-ID: <20080617132401.GA8328@drd1813.lan> (sfid-20080617_153143_519126_1E6BB4C8)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Using wireless-testing 10526-ga0d3022 I'm seeing a bunch of
"interesting" behavior...

1 - Inability to associate to a network on 5ghz.  Same AP on 2.4ghz
  works fine, scanning shows the AP fine.  Sniffing with an additional
  card shows no frames at all being sent by the 4965. AP is on a channel
  the 4965 should be able to talk to according to iwlist channel (logs atta=
ched)
2 - *Severe* latency when HT is enabled, even when connected to a 11G
  AP.  Severe defined as "no packets for 30+ seconds at a time" at
  random intervals about a minute apart.  Problem does not manifest
  itself with same kernel and no HT.  Ping shows 33,000ms pings, so the
  packets are sticking around somewhere in the queue.  (logs attached)
3 - Making a monitor mode vap causes a deadlock.  No logs, because the
  system locks hard, no caps lock LED, no sysreq.  Monitoring with
  tcpdump works for about 3 seconds, then boom.

Commented dmesg logs follow,

# Load driver with debug...

iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26kds
iwl4965: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
ieee80211 phy2: U iwl4965_pci_probe pci_resource_len =3D 0x00002000
ieee80211 phy2: U iwl4965_pci_probe pci_resource_base =3D f8b0c000
iwl4965: Detected Intel Wireless WiFi Link 4965AGN REV=3D0x34
ieee80211 phy2: U iwl4965_pci_probe MAC address: 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_set_rxon_chain rx chain 2806
ieee80211 phy2: U iwl_set_rxon_channel Staging channel set to 6 [0]
ieee80211 phy2: U iwl_init_channel_map Initializing regulatory info from EE=
PROM
ieee80211 phy2: U iwl_init_channel_map Parsing data for 56 channels.
ieee80211 phy2: U iwl_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WID=
E (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WID=
E (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WID=
E (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WID=
E (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WID=
E (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WID=
E (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WID=
E (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WID=
E (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WID=
E (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WI=
DE (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WI=
DE (0x2b 14dBm): Ad-Hoc supported
ieee80211 phy2: U iwl_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 36 [5.2GHz] VALID WIDE (0x21 15d=
Bm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 40 [5.2GHz] VALID WIDE (0x21 15d=
Bm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 44 [5.2GHz] VALID WIDE (0x21 15d=
Bm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 48 [5.2GHz] VALID WIDE (0x21 15d=
Bm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE (0x=
31 15dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE (0x=
31 15dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE (0x=
31 15dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE (0x=
31 15dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
ieee80211 phy2: U iwl_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16=
dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16=
dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16=
dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16=
dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16=
dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 1 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 5 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 2 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 6 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 3 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 7 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 4 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 8 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 5 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 9 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 6 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 10 [2.4GHz] (0x00 0dBm): Ad=
-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 7 [2.4GHz] (0x00 0dBm): Ad-=
Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 11 [2.4GHz] (0x00 0dBm): Ad=
-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 36 [5.2GHz] WIDE (0x21 13dB=
m): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 40 [5.2GHz] WIDE (0x21 13dB=
m): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 44 [5.2GHz] WIDE (0x21 15dB=
m): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 48 [5.2GHz] WIDE (0x21 15dB=
m): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 52 [5.2GHz] RADAR WIDE (0x3=
1 15dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 56 [5.2GHz] RADAR WIDE (0x3=
1 15dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 60 [5.2GHz] RADAR WIDE (0x3=
1 14dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 64 [5.2GHz] RADAR WIDE (0x3=
1 14dBm): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 149 [5.2GHz] WIDE (0x21 16d=
Bm): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 153 [5.2GHz] WIDE (0x21 16d=
Bm): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 157 [5.2GHz] WIDE (0x21 16d=
Bm): Ad-Hoc not supported
ieee80211 phy2: U iwl_set_fat_chan_info FAT Ch. 161 [5.2GHz] WIDE (0x21 16d=
Bm): Ad-Hoc not supported
ieee80211 phy2: U iwlcore_init_geos Channel 1 Freq=3D2412[2.4GHz] valid fla=
g=3D0x20
ieee80211 phy2: U iwlcore_init_geos Channel 2 Freq=3D2417[2.4GHz] valid fla=
g=3D0x20
ieee80211 phy2: U iwlcore_init_geos Channel 3 Freq=3D2422[2.4GHz] valid fla=
g=3D0x20
ieee80211 phy2: U iwlcore_init_geos Channel 4 Freq=3D2427[2.4GHz] valid fla=
g=3D0x20
ieee80211 phy2: U iwlcore_init_geos Channel 5 Freq=3D2432[2.4GHz] valid fla=
g=3D0x0
ieee80211 phy2: U iwlcore_init_geos Channel 6 Freq=3D2437[2.4GHz] valid fla=
g=3D0x0
ieee80211 phy2: U iwlcore_init_geos Channel 7 Freq=3D2442[2.4GHz] valid fla=
g=3D0x0
ieee80211 phy2: U iwlcore_init_geos Channel 8 Freq=3D2447[2.4GHz] valid fla=
g=3D0x10
ieee80211 phy2: U iwlcore_init_geos Channel 9 Freq=3D2452[2.4GHz] valid fla=
g=3D0x10
ieee80211 phy2: U iwlcore_init_geos Channel 10 Freq=3D2457[2.4GHz] valid fl=
ag=3D0x10
ieee80211 phy2: U iwlcore_init_geos Channel 11 Freq=3D2462[2.4GHz] valid fl=
ag=3D0x10
ieee80211 phy2: U iwlcore_init_geos Channel 36 Freq=3D5180[5.2GHz] valid fl=
ag=3D0x26
ieee80211 phy2: U iwlcore_init_geos Channel 40 Freq=3D5200[5.2GHz] valid fl=
ag=3D0x16
ieee80211 phy2: U iwlcore_init_geos Channel 44 Freq=3D5220[5.2GHz] valid fl=
ag=3D0x26
ieee80211 phy2: U iwlcore_init_geos Channel 48 Freq=3D5240[5.2GHz] valid fl=
ag=3D0x16
ieee80211 phy2: U iwlcore_init_geos Channel 52 Freq=3D5260[5.2GHz] valid fl=
ag=3D0x2E
ieee80211 phy2: U iwlcore_init_geos Channel 56 Freq=3D5280[5.2GHz] valid fl=
ag=3D0x1E
ieee80211 phy2: U iwlcore_init_geos Channel 60 Freq=3D5300[5.2GHz] valid fl=
ag=3D0x2E
ieee80211 phy2: U iwlcore_init_geos Channel 64 Freq=3D5320[5.2GHz] valid fl=
ag=3D0x1E
ieee80211 phy2: U iwlcore_init_geos Channel 149 Freq=3D5745[5.2GHz] valid f=
lag=3D0x26
ieee80211 phy2: U iwlcore_init_geos Channel 153 Freq=3D5765[5.2GHz] valid f=
lag=3D0x16
ieee80211 phy2: U iwlcore_init_geos Channel 157 Freq=3D5785[5.2GHz] valid f=
lag=3D0x26
ieee80211 phy2: U iwlcore_init_geos Channel 161 Freq=3D5805[5.2GHz] valid f=
lag=3D0x16
ieee80211 phy2: U iwlcore_init_geos Channel 165 Freq=3D5825[5.2GHz] valid f=
lag=3D0x36
iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
phy2: Selected rate control algorithm 'iwl-4965-rs'
input: 4965AGN as /class/input/input12
ieee80211 phy2: U iwl_power_init_handle Initialize power=20
ieee80211 phy2: U iwl_power_init_handle adjust power command flags
ieee80211 phy2: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
firmware: requesting iwlwifi-4965-1.ucode
ieee80211 phy2: U iwl4965_read_ucode Got firmware 'iwlwifi-4965-1.ucode' fi=
le (185764 bytes) from disk
ieee80211 phy2: U iwl4965_read_ucode f/w package hdr ucode version =3D 0x42=
c0114
ieee80211 phy2: U iwl4965_read_ucode f/w package hdr runtime inst size =3D =
92720
ieee80211 phy2: U iwl4965_read_ucode f/w package hdr runtime data size =3D =
40960
ieee80211 phy2: U iwl4965_read_ucode f/w package hdr init inst size =3D 103=
12
ieee80211 phy2: U iwl4965_read_ucode f/w package hdr init data size =3D 409=
60
ieee80211 phy2: U iwl4965_read_ucode f/w package hdr boot inst size =3D 788
ieee80211 phy2: U iwl4965_read_ucode Copying (but not loading) uCode instr =
len 92720
ieee80211 phy2: U iwl4965_read_ucode uCode instr buf vaddr =3D 0xf5c60000, =
paddr =3D 0x35c60000
ieee80211 phy2: U iwl4965_read_ucode Copying (but not loading) uCode data l=
en 40960
ieee80211 phy2: U iwl4965_read_ucode Copying (but not loading) init instr l=
en 10312
ieee80211 phy2: U iwl4965_read_ucode Copying (but not loading) init data le=
n 40960
ieee80211 phy2: U iwl4965_read_ucode Copying (but not loading) boot instr l=
en 788
ieee80211 phy2: U iwl4965_load_bsm Begin load bsm
ieee80211 phy2: U iwl4965_verify_bsm Begin verify bsm
ieee80211 phy2: U iwl4965_verify_bsm BSM bootstrap uCode image OK
ieee80211 phy2: U iwl4965_load_bsm BSM write complete, poll 1 iterations
ieee80211 phy2: U __iwl4965_up iwl4965 is coming up
ieee80211 phy2: U iwl4965_mac_start Start UP work done.
ieee80211 phy2: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision=
 0x1 0x9
ieee80211 phy2: I iwl_rx_reply_alive Initialization Alive received.
ieee80211 phy2: U iwlcore_verify_inst_sparse ucode inst image size is 788
ieee80211 phy2: U iwlcore_verify_inst_sparse ucode inst image size is 10312
ieee80211 phy2: U iwl_verify_ucode Initialize uCode is good in inst SRAM
ieee80211 phy2: U iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: U iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3420
ieee80211 phy2: U iwl4965_hw_get_temperature Calibrated temperature: 322K, =
49C
ieee80211 phy2: U iwl4965_init_alive_start Initialization Alive received.
ieee80211 phy2: U iwl4965_set_ucode_ptrs Runtime uCode pointers are set.
ieee80211 phy2: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision=
 0x1 0x0
ieee80211 phy2: I iwl_rx_reply_alive Runtime Alive received.
ieee80211 phy2: U iwl_alive_start Runtime Alive received.
ieee80211 phy2: U iwlcore_verify_inst_sparse ucode inst image size is 788
ieee80211 phy2: U iwlcore_verify_inst_sparse ucode inst image size is 10312
ieee80211 phy2: U iwlcore_verify_inst_sparse ucode inst image size is 92720
ieee80211 phy2: U iwl_verify_ucode Runtime uCode is good in inst SRAM
ieee80211 phy2: U iwl4965_tx_queue_set_status Activate AC Queue 0 on AC 3
ieee80211 phy2: U iwl4965_tx_queue_set_status Activate AC Queue 1 on AC 2
ieee80211 phy2: U iwl4965_tx_queue_set_status Activate AC Queue 2 on AC 1
ieee80211 phy2: U iwl4965_tx_queue_set_status Activate AC Queue 3 on AC 0
ieee80211 phy2: U iwl4965_tx_queue_set_status Activate AC Queue 4 on AC 4
ieee80211 phy2: U iwl4965_tx_queue_set_status Activate AC Queue 5 on AC 5
ieee80211 phy2: U iwl4965_tx_queue_set_status Activate AC Queue 6 on AC 6
ieee80211 phy2: U iwl_set_rxon_chain rx chain 2806
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), s=
eq: 0x0400, 16 bytes at 0[0]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_STATISTICS_CMD (#9=
c), seq: 0x0401, 8 bytes at 1[1]:4
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0402, 48 bytes at 2[2]:4
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0403, 12 bytes at 3[3]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3420
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 322K, =
49C
ieee80211 phy2: I iwl4965_is_temp_calib_needed Getting warmer, delta 322,=
=20
ieee80211 phy2: I iwl4965_is_temp_calib_needed Thermal txpower calib needed
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_STATISTICS_CMD (=
0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0404, 16 bytes at 4[4]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0405, 28 bytes at 5[5]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0406, 140 bytes at 6[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0407, 72 bytes at 7[7]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0408, 92 bytes at 8[8]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_CT_KILL_CONFIG_CMD=
 (#a4), seq: 0x0409, 16 bytes at 9[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_rf_kill_ct_config REPLY_CT_KILL_CONFIG_CMD succeeded,=
 critical temperature is 383
Registered led device: iwl-phy2:radio
Registered led device: iwl-phy2:assoc
Registered led device: iwl-phy2:RX
Registered led device: iwl-phy2:TX
ieee80211 phy2: U iwl_alive_start ALIVE processing complete.
ieee80211 phy2: U iwl_update_power_command Flags value =3D 0x00000000
ieee80211 phy2: U iwl_update_power_command Tx timeout =3D 0
ieee80211 phy2: U iwl_update_power_command Rx timeout =3D 0
ieee80211 phy2: U iwl_update_power_command Sleep interval vector =3D { 0 , =
0 , 0 , 0 , 0 }
ieee80211 phy2: U iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), s=
eq: 0x040A, 40 bytes at 10[10]:4
ieee80211 phy2: U iwl_set_rxon_chain rx chain 2806
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x040B, 48 bytes at 11[11]:4
ieee80211 phy2: U iwl4965_mac_start leave
ieee80211 phy2: U iwl4965_mac_add_interface enter: type 2
ieee80211 phy2: I iwl_generic_cmd_callback back from POWER_TABLE_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x040C, 16 bytes at 12[12]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x040D, 140 bytes at 13[13]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x040E, 72 bytes at 14[14]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x040F, 92 bytes at 15[15]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0410, 140 bytes at 16[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl4965_mac_add_interface Set 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_set_rxon_channel Staging channel set to 6 [0]
ieee80211 phy2: U iwl_set_rxon_chain rx chain 2806
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0411, 48 bytes at 17[17]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0412, 16 bytes at 18[18]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0413, 140 bytes at 19[19]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0414, 72 bytes at 20[20]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0415, 92 bytes at 21[21]:4
ieee80211 phy2: U iwl4965_mac_add_interface leave
ieee80211 phy2: U iwl4965_mac_config_interface bssid: 00:00:00:00:00:00
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0416, 48 bytes at 22[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0417, 16 bytes at 23[23]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0418, 140 bytes at 24[24]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0419, 72 bytes at 25[25]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x041A, 92 bytes at 26[26]:4
ieee80211 phy2: U iwl4965_mac_config_interface leave
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x6
ieee80211 phy2: U iwl4965_bss_info_changed ERP_PREAMBLE 0
ieee80211 phy2: U iwl4965_bss_info_changed ERP_CTS 0
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl4965_mac_config enter to channel 1
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D16 new=3D14
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x041B, 140 bytes at 27[27]:4
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x041C, 48 bytes at 28[28]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x041D, 16 bytes at 29[29]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x041E, 140 bytes at 30[30]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x041F, 72 bytes at 31[31]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0420, 92 bytes at 32[0]:4
ieee80211 phy2: U iwl4965_mac_config leave
ADDRCONF(NETDEV_UP): wlan0: link is not ready
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl_scan_initiate Starting scan...
ieee80211 phy2: U iwl4965_mac_hw_scan leave
ieee80211 phy2: U iwl_bg_request_scan Start indirect scan.
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 1 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 2 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 3 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 4 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 5 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 6 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 7 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 8 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 9 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 10 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 11 [PASSIVE 120]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 11=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x4421, 382 bytes at 33[32]:4
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0422, 12 bytes at 34[2]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3456
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 323K, =
50C
ieee80211 phy2: I iwl4965_hw_rx_statistics Temperature changed from 49C to =
50C
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x=
00000000:0002BCBE) - 1 (beacon timer 4219714)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:=
 0x00000000:00049CCE) - 7 elapsed=3D122896 usec (513741ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x=
00000000:00049E3A) - 1 (beacon timer 8393158)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:=
 0x00000000:00067E51) - 3 elapsed=3D122903 usec (123ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x=
00000000:00067FBD) - 1 (beacon timer 16863299)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:=
 0x00000000:00085FDA) - 4 elapsed=3D122909 usec (123ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x=
00000000:00086146) - 1 (beacon timer 21036730)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:=
 0x00000000:000A4168) - 7 elapsed=3D122914 usec (124ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x=
00000000:000A42D4) - 1 (beacon timer 25210156)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:=
 0x00000000:000C22EE) - 3 elapsed=3D122906 usec (123ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x=
00000000:000C245A) - 1 (beacon timer 29383590)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:=
 0x00000000:000E0477) - 10 elapsed=3D122909 usec (124ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x=
00000000:000E05E3) - 1 (beacon timer 33557021)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:=
 0x00000000:000FE5FD) - 3 elapsed=3D122906 usec (123ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x=
00000000:000FE769) - 1 (beacon timer 42027159)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:=
 0x00000000:0011C779) - 4 elapsed=3D122896 usec (123ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x=
00000000:0011C8E5) - 1 (beacon timer 46200603)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:=
 0x00000000:0013A8F7) - 7 elapsed=3D122898 usec (124ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0=
x00000000:0013AA63) - 1 (beacon timer 50374045)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF=
: 0x00000000:00158A72) - 5 elapsed=3D122895 usec (123ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0=
x00000000:00158BDE) - 1 (beacon timer 54547490)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF=
: 0x00000000:00176BF4) - 8 elapsed=3D122902 usec (123ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 11 channels (TS=
F 0x00176D6D:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 1357ms
ieee80211 phy2: U iwl_bg_request_scan Start indirect scan.
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 36 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 40 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 44 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 48 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 52 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 56 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 60 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 64 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 149 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 153 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 157 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 161 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 165 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 13=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x4423, 398 bytes at 35[32]:4
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x=
00000000:00177124) - 1 (beacon timer 63016668)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:=
 0x00000000:00192944) - 0 elapsed=3D112672 usec (114ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x=
00000000:00192AAE) - 1 (beacon timer 67200337)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:=
 0x00000000:001AE2D1) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x=
00000000:001AE43C) - 1 (beacon timer 71384004)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:=
 0x00000000:001C9C5E) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x=
00000000:001C9DC9) - 1 (beacon timer 75567671)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:=
 0x00000000:001E55EC) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x=
00000000:001E5757) - 1 (beacon timer 79751337)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:=
 0x00000000:00200F7A) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x=
00000000:002010E5) - 1 (beacon timer 83935003)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:=
 0x00000000:0021C908) - 2 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x=
00000000:0021CA73) - 1 (beacon timer 88118669)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:=
 0x00000000:00238296) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x=
00000000:00238402) - 1 (beacon timer 92302334)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:=
 0x00000000:00253C24) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0=
x00000000:00253D91) - 1 (beacon timer 96485999)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF=
: 0x00000000:0026F5B4) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0=
x00000000:0026F722) - 1 (beacon timer 100669662)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF=
: 0x00000000:0028AF3E) - 1 elapsed=3D112668 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0=
x00000000:0028B0AC) - 1 (beacon timer 109150036)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF=
: 0x00000000:002A68CE) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0=
x00000000:002A6A3C) - 1 (beacon timer 113333700)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF=
: 0x00000000:002C225E) - 0 elapsed=3D112674 usec (114ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0=
x00000000:002C23CC) - 1 (beacon timer 117517364)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF=
: 0x00000000:002DDBEF) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 13 channels (TS=
F 0x002DDD68:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 5.2GHz took 1471ms
ieee80211 phy2: I iwl_rx_scan_complete_notif Setting scan to off
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan took 2828ms
ieee80211 phy2: U iwl_bg_scan_completed SCAN complete scan
ieee80211 phy2: U iwl4965_mac_config enter to channel 1
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 6
ieee80211 phy2: U iwl_set_rxon_channel Staging channel set to 6 [0]
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:00:00:00:00:00
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0424, 48 bytes at 36[4]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0425, 16 bytes at 37[5]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0426, 140 bytes at 38[6]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0427, 72 bytes at 39[7]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0428, 92 bytes at 40[8]:4
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_config_interface bssid: 00:1d:7e:32:78:c3
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 6
* bssid =3D 00:1d:7e:32:78:c3
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0429, 48 bytes at 41[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x042A, 16 bytes at 42[10]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x042B, 140 bytes at 43[11]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x042C, 72 bytes at 44[12]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x042D, 92 bytes at 45[13]:4
ieee80211 phy2: U iwl4965_mac_config_interface leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK

# Unrequested startup connection to some open network in the area

* channel =3D 6
* bssid =3D 00:1d:7e:32:78:c3
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x042E, 48 bytes at 46[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x042F, 16 bytes at 47[15]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0430, 140 bytes at 48[16]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0431, 72 bytes at 49[17]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0432, 92 bytes at 50[18]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1d:7e:32:78:c3
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 11
ieee80211 phy2: U iwl_set_rxon_channel Staging channel set to 11 [0]
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:1d:7e:32:78:c3
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0433, 48 bytes at 51[19]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0434, 16 bytes at 52[20]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0435, 140 bytes at 53[21]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0436, 72 bytes at 54[22]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0437, 92 bytes at 55[23]:4
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_config_interface bssid: 00:16:b6:cf:57:17
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK

# Initial connection to my default network by wpa_supplicant

* channel =3D 11
* bssid =3D 00:16:b6:cf:57:17
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0438, 48 bytes at 56[24]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0439, 16 bytes at 57[25]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x043A, 140 bytes at 58[26]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x043B, 72 bytes at 59[27]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x043C, 92 bytes at 60[28]:4
ieee80211 phy2: U iwl4965_mac_config_interface leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x043D, 140 bytes at 61[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl4965_mac_config enter to channel 11
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:16:b6:cf:57:17
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x043E, 48 bytes at 62[30]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x043F, 16 bytes at 63[31]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0440, 140 bytes at 64[0]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0441, 72 bytes at 65[1]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0442, 92 bytes at 66[2]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:16:b6:cf:57:17
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 11
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:16:b6:cf:57:17
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0443, 48 bytes at 67[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0444, 16 bytes at 68[4]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0445, 140 bytes at 69[5]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0446, 72 bytes at 70[6]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0447, 92 bytes at 71[7]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:16:b6:cf:57:17
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: RX authentication from 00:16:b6:cf:57:17 (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:16:b6:cf:57:17
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
wlan0: authentication frame received from 00:16:b6:cf:57:17, but not in aut=
henticate state - ignored
wlan0: RX AssocResp from 00:16:b6:cf:57:17 (capab=3D0x411 status=3D0 aid=3D=
2)
wlan0: associated
wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D3 cWmin=3D15 cWmax=3D1023 txop=
=3D0
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 txop=
=3D0
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 txop=3D94
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 txop=3D47
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x1
ieee80211 phy2: U iwl4965_bss_info_changed ASSOC 1
ieee80211 phy2: U iwl4965_post_associate Associated as 2 to: 00:16:b6:cf:57=
:17
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:16:b6:cf:57:17
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0448, 48 bytes at 72[8]:4
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0449, 16 bytes at 73[9]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x044A, 140 bytes at 74[10]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x044B, 72 bytes at 75[11]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x044C, 92 bytes at 76[12]:4
ieee80211 phy2: U iwl4965_setup_rxon_timing beacon interval 100 beacon time=
r 102013 beacon tim 0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON_TIMING (#14),=
 seq: 0x044D, 24 bytes at 77[13]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_set_rxon_chain rx chain 2806
ieee80211 phy2: U iwl4965_post_associate assoc id 2 beacon interval 100
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:16:b6:cf:57:17
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x044E, 48 bytes at 78[14]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x044F, 16 bytes at 79[15]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0450, 140 bytes at 80[16]:4
ieee80211 phy2: I iwl_sta_ucode_deactivate Removed STA from Ucode: ff:ff:ff=
:ff:ff:ff
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0451, 72 bytes at 81[17]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0452, 92 bytes at 82[18]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 0: 00:16:b6:cf:57:17
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0453, 72 bytes at 83[19]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl_tx_skb Dropping - !iwl_is_associated
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (dup): 00:13:e8:92:3f:cb, 00=
:16:b6:cf:57:17, 00:16:b6:cf:57:17
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0454, 92 bytes at 84[20]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CM=
D (#b0), seq: 0x0455, 12 bytes at 85[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), s=
eq: 0x0456, 40 bytes at 86[22]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3668
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 327K, =
54C
ieee80211 phy2: I iwl4965_hw_rx_statistics Temperature changed from 50C to =
54C
ieee80211 phy2: I iwl4965_is_temp_calib_needed Getting warmer, delta 5,=20
ieee80211 phy2: I iwl4965_is_temp_calib_needed Thermal txpower calib needed
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0457, 140 bytes at 87[23]:4
wlan0: RX protected frame, but have no key
wlan0: RX protected frame, but have no key
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0458, 28 bytes at 88[24]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0459, 28 bytes at 89[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045A, 28 bytes at 90[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045B, 28 bytes at 91[27]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045C, 28 bytes at 92[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045D, 28 bytes at 93[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045E, 28 bytes at 94[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl_set_ccmp_dynamic_key_info hwcrypto: modify ucode stat=
ion key info
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x045F, 72 bytes at 95[31]:4
ieee80211 phy2: U iwl4965_mac_set_key enable hwcrypto key
ieee80211 phy2: U iwl4965_mac_set_key leave
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl4965_mac_set_key enable hwcrypto key
ieee80211 phy2: U iwl4965_mac_set_key leave
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0460, 12 bytes at 96[0]:4
ieee80211 phy2: I iwl4965_mac_update_tkip_key enter
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0461, 72 bytes at 97[1]:4
ieee80211 phy2: I iwl4965_mac_update_tkip_key leave
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0462, 28 bytes at 98[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0463, 28 bytes at 99[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): 33:33:00:00:0=
0:02, 00:16:b6:cf:57:17, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CM=
D (#b0), seq: 0x0464, 12 bytes at 100[4]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): 33:33:00:00:0=
0:16, 00:16:b6:cf:57:17, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:16:b6:cf:57:17, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:16:b6:cf:57:17, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:16:b6:cf:57:17, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:16:b6:cf:57:17, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0465, 28 bytes at 101[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0466, 92 bytes at 102[6]:4
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:16:b6:cf:57:17, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:16:b6:cf:57:17, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:16:b6:cf:57:17, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0467, 28 bytes at 103[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0468, 28 bytes at 104[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0469, 12 bytes at 105[9]:4
wlan0: disassociate(reason=3D3)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x6
ieee80211 phy2: U iwl4965_bss_info_changed ERP_PREAMBLE 0
ieee80211 phy2: U iwl4965_bss_info_changed ERP_CTS 0
ieee80211 phy2: U iwl4965_bss_info_changed Associated Changes 6
ieee80211 phy2: U iwl4965_send_rxon_assoc Using current RXON_ASSOC.  Not re=
sending.
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x1
ieee80211 phy2: U iwl4965_bss_info_changed ASSOC 0
ieee80211 phy2: U iwl4965_bss_info_changed DISASSOC 0
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl_scan_initiate Starting scan...
ieee80211 phy2: U iwl4965_mac_hw_scan leave
ieee80211 phy2: U iwl_bg_request_scan Scanning while associated...
ieee80211 phy2: U iwl_bg_request_scan suspend_time 0x400000 beacon interval=
 100
ieee80211 phy2: U iwl_bg_request_scan Start indirect scan.
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 1 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 2 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 3 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 4 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 5 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 6 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 7 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 8 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 9 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 10 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 11 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 11=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x446A, 382 bytes at 106[32]:4
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl_scan_cancel Queuing scan abort.
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_ABORT_CMD (#8=
1), seq: 0x046B, 4 bytes at 107[11]:4
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 0 channels (TSF=
 0xF613D1BF:00000183) - 2
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 11ms
ieee80211 phy2: I iwl_rx_scan_complete_notif Aborted scan completed.
ieee80211 phy2: I iwl_rx_scan_complete_notif Setting scan to off
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan took 11ms
ieee80211 phy2: U iwl_bg_scan_completed SCAN complete scan
ieee80211 phy2: U iwl4965_mac_config enter to channel 11
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x046C, 140 bytes at 108[12]:4
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl_set_rxon_channel Staging channel set to 56 [1]
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_commit_rxon Toggling associated bit on current RX=
ON
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x046D, 48 bytes at 109[13]:4
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:16:b6:cf:57:17
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x046E, 48 bytes at 110[14]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x046F, 16 bytes at 111[15]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0470, 28 bytes at 112[16]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0471, 140 bytes at 113[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0472, 72 bytes at 114[18]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0473, 92 bytes at 115[19]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 0: 00:16:b6:cf:57:17
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0474, 72 bytes at 116[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0475, 92 bytes at 117[21]:4
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_config_interface bssid: 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl4965_commit_rxon Toggling associated bit on current RX=
ON
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0476, 48 bytes at 118[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0477, 48 bytes at 119[23]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0478, 16 bytes at 120[24]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0479, 140 bytes at 121[25]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x047A, 72 bytes at 122[26]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x047B, 92 bytes at 123[27]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 0: 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x047C, 72 bytes at 124[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x047D, 92 bytes at 125[29]:4
ieee80211 phy2: U iwl4965_mac_config_interface leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x047E, 48 bytes at 126[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x047F, 16 bytes at 127[31]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0480, 140 bytes at 128[0]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0481, 72 bytes at 129[1]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0482, 92 bytes at 130[2]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl4965_mac_set_key disable hwcrypto key
ieee80211 phy2: U iwl4965_mac_set_key leave
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl_find_station can not find STA 00:16:b6:cf:57:17 total=
 1
ieee80211 phy2: U iwl4965_mac_set_key leave - 00:16:b6:cf:57:17 not in stat=
ion map.
mac80211-phy2: failed to remove key (0, 00:16:b6:cf:57:17) from hardware (-=
22)
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authentication with AP 00:1a:1e:80:02:b0 timed out
wlan0: no IPv6 routers present
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl_scan_initiate Starting scan...
ieee80211 phy2: U iwl4965_mac_hw_scan leave
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 1 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 2 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 3 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 4 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 5 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 6 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 7 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 8 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 9 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 10 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 11 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 11=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x4483, 382 bytes at 131[32]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3690
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 327K, =
54C
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x=
00000000:00989805) - 1 (beacon timer 406882299)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:=
 0x00000000:0098F4CB) - 7 elapsed=3D23750 usec (10034ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x=
00000000:0098F636) - 1 (beacon timer 406858186)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:=
 0x00000000:00994D54) - 2 elapsed=3D22302 usec (23ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x=
00000000:00994EBF) - 1 (beacon timer 411132225)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:=
 0x00000000:00996ADA) - 0 elapsed=3D7195 usec (7ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x=
00000000:00996C46) - 1 (beacon timer 411124666)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:=
 0x00000000:009987B2) - 1 elapsed=3D7020 usec (8ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x=
00000000:0099891E) - 1 (beacon timer 411117282)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:=
 0x00000000:0099ED19) - 3 elapsed=3D25595 usec (26ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x=
00000000:0099EE85) - 1 (beacon timer 411091323)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:=
 0x00000000:009A564E) - 5 elapsed=3D26569 usec (27ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x=
00000000:009A57BA) - 1 (beacon timer 411064390)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:=
 0x00000000:009AB420) - 6 elapsed=3D23654 usec (24ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x=
00000000:009AB58C) - 1 (beacon timer 415337076)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:=
 0x00000000:009AD795) - 1 elapsed=3D8713 usec (9ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x=
00000000:009AD901) - 1 (beacon timer 415327999)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:=
 0x00000000:009AF5CC) - 1 elapsed=3D7371 usec (7ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0=
x00000000:009AF738) - 1 (beacon timer 415320264)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF=
: 0x00000000:009B1F62) - 1 elapsed=3D10282 usec (11ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0=
x00000000:009B20CE) - 1 (beacon timer 415309618)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF=
: 0x00000000:009B84B6) - 7 elapsed=3D25576 usec (26ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 11 channels (TS=
F 0x009B862E:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 193ms
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 36 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 40 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 44 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 48 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 52 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 56 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 60 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 64 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 149 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 153 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 157 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 161 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 165 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 13=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x4484, 398 bytes at 132[32]:4
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x=
00000000:009B8C07) - 1 (beacon timer 415282169)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:=
 0x00000000:009D4427) - 0 elapsed=3D112672 usec (115ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x=
00000000:009D4591) - 1 (beacon timer 419465838)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:=
 0x00000000:009EFDB4) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x=
00000000:009EFF1F) - 1 (beacon timer 423649505)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:=
 0x00000000:00A0B741) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x=
00000000:00A0B8AC) - 1 (beacon timer 427833172)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:=
 0x00000000:00A270CF) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x=
00000000:00A2723A) - 1 (beacon timer 432016838)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:=
 0x00000000:00A42A5D) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x=
00000000:00A42BC9) - 1 (beacon timer 440497207)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:=
 0x00000000:00A5E3DF) - 1 elapsed=3D112662 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x=
00000000:00A5E54B) - 1 (beacon timer 444680885)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:=
 0x00000000:00A79D6D) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x=
00000000:00A79ED9) - 1 (beacon timer 448864551)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:=
 0x00000000:00A956FB) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0=
x00000000:00A95868) - 1 (beacon timer 453048216)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF=
: 0x00000000:00AB108B) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0=
x00000000:00AB11F8) - 1 (beacon timer 457231879)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF=
: 0x00000000:00ACCA12) - 1 elapsed=3D112666 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0=
x00000000:00ACCB80) - 1 (beacon timer 461415552)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF=
: 0x00000000:00AE83A2) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0=
x00000000:00AE8510) - 1 (beacon timer 465599216)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF=
: 0x00000000:00B03D32) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0=
x00000000:00B03EA0) - 1 (beacon timer 469782880)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF=
: 0x00000000:00B1F6C3) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 13 channels (TS=
F 0x00B1F83A:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 5.2GHz took 1471ms
ieee80211 phy2: I iwl_rx_scan_complete_notif Setting scan to off
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan took 1664ms
ieee80211 phy2: U iwl_bg_scan_completed SCAN complete scan
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0485, 140 bytes at 133[5]:4
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl4965_mac_config enter to channel 1
ieee80211 phy2: U iwl_set_rxon_channel Staging channel set to 1 [0]
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK

# Request to connect to the 5ghz radio on my test AP

* channel =3D 1
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0486, 48 bytes at 134[6]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0487, 16 bytes at 135[7]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0488, 140 bytes at 136[8]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0489, 72 bytes at 137[9]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x048A, 92 bytes at 138[10]:4
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_config_interface bssid: 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK

# It fell down to 2.4ghz

* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x048B, 48 bytes at 139[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x048C, 16 bytes at 140[12]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x048D, 140 bytes at 141[13]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x048E, 72 bytes at 142[14]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x048F, 92 bytes at 143[15]:4
ieee80211 phy2: U iwl4965_mac_config_interface leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 1
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0490, 48 bytes at 144[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0491, 16 bytes at 145[17]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0492, 140 bytes at 146[18]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0493, 72 bytes at 147[19]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0494, 92 bytes at 148[20]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:a0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
wlan0: RX authentication from 00:1a:1e:80:02:a0 (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:1a:1e:80:02:a0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: RX AssocResp from 00:1a:1e:80:02:a0 (capab=3D0x431 status=3D0 aid=3D=
1)
wlan0: associated
wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D3 cWmin=3D15 cWmax=3D1023 txop=
=3D0
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 txop=
=3D0
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 txop=3D94
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 txop=3D47
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: switched to short barker preamble (BSSID=3D00:1a:1e:80:02:a0)
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x15
ieee80211 phy2: U iwl4965_bss_info_changed ERP_PREAMBLE 1
ieee80211 phy2: U iwl4965_bss_info_changed HT 1
ieee80211 phy2: U iwl4965_ht_conf enter:=20
ieee80211 phy2: U iwl4965_ht_conf control channel 1
ieee80211 phy2: U iwl4965_ht_conf leave
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl4965_bss_info_changed ASSOC 1
ieee80211 phy2: U iwl4965_post_associate Associated as 1 to: 00:1a:1e:80:02=
:a0
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0495, 48 bytes at 149[21]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0496, 16 bytes at 150[22]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0497, 140 bytes at 151[23]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0498, 72 bytes at 152[24]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0499, 92 bytes at 153[25]:4
ieee80211 phy2: U iwl4965_setup_rxon_timing beacon interval 100 beacon time=
r 76806 beacon tim 0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON_TIMING (#14),=
 seq: 0x049A, 24 bytes at 154[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl_set_rxon_ht supported HT rate 0xFF 0xFF 0x0 rxon flag=
s 0x8025 operation mode :0x0 extension channel offset 0x0 control chan 1
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl4965_post_associate assoc id 1 beacon interval 100
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x049B, 48 bytes at 155[27]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x049C, 16 bytes at 156[28]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x049D, 140 bytes at 157[29]:4
ieee80211 phy2: I iwl_sta_ucode_deactivate Removed STA from Ucode: ff:ff:ff=
:ff:ff:ff
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x049E, 72 bytes at 158[30]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x049F, 92 bytes at 159[31]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 0: 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x04A0, 72 bytes at 160[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x04A1, 92 bytes at 161[1]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), s=
eq: 0x04A2, 40 bytes at 162[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x04A3, 72 bytes at 163[3]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3784
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 329K, =
56C
ieee80211 phy2: I iwl4965_hw_rx_statistics Temperature changed from 54C to =
56C
ieee80211 phy2: I iwl4965_is_temp_calib_needed Getting warmer, delta 2,=20
ieee80211 phy2: I iwl4965_is_temp_calib_needed Thermal txpower calib not ne=
eded
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A4, 28 bytes at 164[4]:4
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x10
ieee80211 phy2: U iwl4965_bss_info_changed HT 1
ieee80211 phy2: U iwl4965_ht_conf enter:=20
ieee80211 phy2: U iwl4965_ht_conf control channel 1
ieee80211 phy2: U iwl4965_ht_conf leave
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl4965_bss_info_changed Associated Changes 16
ieee80211 phy2: U iwl4965_send_rxon_assoc Using current RXON_ASSOC.  Not re=
sending.
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A5, 28 bytes at 165[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A6, 28 bytes at 166[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A7, 28 bytes at 167[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A8, 28 bytes at 168[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A9, 28 bytes at 169[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04AA, 28 bytes at 170[10]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04AB, 28 bytes at 171[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04AC, 28 bytes at 172[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl_set_ccmp_dynamic_key_info hwcrypto: modify ucode stat=
ion key info
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x04AD, 72 bytes at 173[13]:4
ieee80211 phy2: U iwl4965_mac_set_key enable hwcrypto key
ieee80211 phy2: U iwl4965_mac_set_key leave
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl_set_ccmp_dynamic_key_info hwcrypto: modify ucode stat=
ion key info
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x04AE, 72 bytes at 174[14]:4
ieee80211 phy2: U iwl4965_mac_set_key enable hwcrypto key
ieee80211 phy2: U iwl4965_mac_set_key leave
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04AF, 12 bytes at 175[15]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B0, 28 bytes at 176[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B1, 28 bytes at 177[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B2, 28 bytes at 178[18]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B3, 28 bytes at 179[19]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B4, 28 bytes at 180[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B5, 28 bytes at 181[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B6, 28 bytes at 182[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B7, 28 bytes at 183[23]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B8, 28 bytes at 184[24]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B9, 28 bytes at 185[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BA, 28 bytes at 186[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BB, 28 bytes at 187[27]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BC, 28 bytes at 188[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BD, 28 bytes at 189[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BE, 28 bytes at 190[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BF, 28 bytes at 191[31]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C0, 28 bytes at 192[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C1, 28 bytes at 193[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C2, 28 bytes at 194[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C3, 28 bytes at 195[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04C4, 12 bytes at 196[4]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C5, 28 bytes at 197[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C6, 28 bytes at 198[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C7, 28 bytes at 199[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C8, 28 bytes at 200[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C9, 28 bytes at 201[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CA, 28 bytes at 202[10]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CB, 28 bytes at 203[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CC, 28 bytes at 204[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CD, 28 bytes at 205[13]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CE, 28 bytes at 206[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CF, 28 bytes at 207[15]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D0, 28 bytes at 208[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D1, 28 bytes at 209[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D2, 28 bytes at 210[18]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D3, 28 bytes at 211[19]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D4, 28 bytes at 212[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D5, 28 bytes at 213[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D6, 28 bytes at 214[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D7, 28 bytes at 215[23]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D8, 28 bytes at 216[24]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D9, 28 bytes at 217[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x04DA, 92 bytes at 218[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DB, 28 bytes at 219[27]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DC, 28 bytes at 220[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DD, 28 bytes at 221[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DE, 28 bytes at 222[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DF, 28 bytes at 223[31]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04E0, 12 bytes at 224[0]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E1, 28 bytes at 225[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E2, 28 bytes at 226[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E3, 28 bytes at 227[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E4, 28 bytes at 228[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E5, 28 bytes at 229[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E6, 28 bytes at 230[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E7, 28 bytes at 231[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E8, 28 bytes at 232[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E9, 28 bytes at 233[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04EA, 28 bytes at 234[10]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04EB, 28 bytes at 235[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04EC, 28 bytes at 236[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04ED, 28 bytes at 237[13]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04EE, 28 bytes at 238[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04EF, 12 bytes at 239[15]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04F0, 28 bytes at 240[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04F1, 28 bytes at 241[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl_scan_initiate Starting scan...
ieee80211 phy2: U iwl4965_mac_hw_scan leave
ieee80211 phy2: U iwl_bg_request_scan Scanning while associated...
ieee80211 phy2: U iwl_bg_request_scan suspend_time 0x400000 beacon interval=
 100
ieee80211 phy2: U iwl_bg_request_scan Start indirect scan.
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 1 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 2 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 3 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 4 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 5 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 6 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 7 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 8 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 9 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 10 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 11 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 11=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x44F2, 382 bytes at 242[32]:4
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x=
00000005:F9812DB0) - 1 (beacon timer 419529296)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:=
 0x00000005:F9828E04) - 1 elapsed=3D90196 usec (10313ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x=
00000005:F9844AE1) - 1 (beacon timer 427918623)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:=
 0x00000005:F985AB33) - 1 elapsed=3D90194 usec (204ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x=
00000005:F9876AE1) - 1 (beacon timer 436307231)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:=
 0x00000005:F988CB2B) - 1 elapsed=3D90186 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x=
00000005:F98A8AE1) - 1 (beacon timer 444695839)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:=
 0x00000005:F98BEB35) - 2 elapsed=3D90196 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x=
00000005:F98DAAE1) - 1 (beacon timer 453084447)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:=
 0x00000005:F98F0B39) - 3 elapsed=3D90200 usec (204ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x=
00000005:F990CAE1) - 1 (beacon timer 461473055)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:=
 0x00000005:F9922B39) - 5 elapsed=3D90200 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x=
00000005:F993EAE1) - 1 (beacon timer 469861663)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:=
 0x00000005:F9954B2F) - 2 elapsed=3D90190 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x=
00000005:F9970AE4) - 1 (beacon timer 478250268)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:=
 0x00000005:F9986B3D) - 2 elapsed=3D90201 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x=
00000005:F99A2AE4) - 1 (beacon timer 486638876)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:=
 0x00000005:F99B8B3E) - 4 elapsed=3D90202 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0=
x00000005:F99D4AE1) - 1 (beacon timer 495027487)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF=
: 0x00000005:F99EAB2E) - 4 elapsed=3D90189 usec (204ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0=
x00000005:F9A06AE4) - 1 (beacon timer 503416091)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF=
: 0x00000005:F9A1CB39) - 5 elapsed=3D90197 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 11 channels (TS=
F 0xF9A1CD6D:00000005) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 2204ms
ieee80211 phy2: U iwl_bg_request_scan Scanning while associated...
ieee80211 phy2: U iwl_bg_request_scan suspend_time 0x400000 beacon interval=
 100
ieee80211 phy2: U iwl_bg_request_scan Start indirect scan.
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 36 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 40 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 44 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 48 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 52 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 56 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 60 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 64 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 149 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 153 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 157 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 161 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 165 [PASSIVE 88]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 13=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x44F3, 398 bytes at 243[32]:4
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x=
00000005:F9A1FAE0) - 1 (beacon timer 507610400)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:=
 0x00000005:F9A35B33) - 0 elapsed=3D90195 usec (103ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x=
00000005:F9A51ADF) - 1 (beacon timer 515999008)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:=
 0x00000005:F9A67B32) - 0 elapsed=3D90195 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x=
00000005:F9A83AE1) - 1 (beacon timer 524387615)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:=
 0x00000005:F9A99B33) - 0 elapsed=3D90194 usec (204ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x=
00000005:F9AB5AE0) - 1 (beacon timer 532776224)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:=
 0x00000005:F9ACBB32) - 0 elapsed=3D90194 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x=
00000005:F9AE7AE1) - 1 (beacon timer 541164831)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:=
 0x00000005:F9AFDB33) - 0 elapsed=3D90194 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x=
00000005:F9B19AE0) - 1 (beacon timer 549553440)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:=
 0x00000005:F9B2FB34) - 1 elapsed=3D90196 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x=
00000005:F9B4BAE0) - 1 (beacon timer 557942047)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:=
 0x00000005:F9B61B33) - 0 elapsed=3D90195 usec (204ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x=
00000005:F9B7DAE1) - 1 (beacon timer 566330655)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:=
 0x00000005:F9B93B33) - 0 elapsed=3D90194 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0=
x00000005:F9BAFAE3) - 1 (beacon timer 574719261)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF=
: 0x00000005:F9BC5B36) - 0 elapsed=3D90195 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0=
x00000005:F9BE1AF4) - 1 (beacon timer 583107851)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF=
: 0x00000005:F9BF7B47) - 0 elapsed=3D90195 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0=
x00000005:F9C13AE4) - 1 (beacon timer 591496476)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF=
: 0x00000005:F9C29B36) - 0 elapsed=3D90194 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0=
x00000005:F9C45AE3) - 1 (beacon timer 599885085)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF=
: 0x00000005:F9C5BB35) - 0 elapsed=3D90194 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0=
x00000005:F9C77AE4) - 1 (beacon timer 608273692)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF=
: 0x00000005:F9C8DB36) - 0 elapsed=3D90194 usec (205ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 13 channels (TS=
F 0xF9C8DD69:00000005) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 5.2GHz took 2561ms
ieee80211 phy2: I iwl_rx_scan_complete_notif Setting scan to off
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan took 4765ms
ieee80211 phy2: U iwl_bg_scan_completed SCAN complete scan
ieee80211 phy2: U iwl4965_mac_config enter to channel 1
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x04F4, 140 bytes at 244[20]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl_set_rxon_channel Staging channel set to 56 [1]
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_commit_rxon Toggling associated bit on current RX=
ON
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x04F5, 48 bytes at 245[21]:4
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x04F6, 48 bytes at 246[22]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x04F7, 16 bytes at 247[23]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04F8, 28 bytes at 248[24]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x04F9, 140 bytes at 249[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x04FA, 72 bytes at 250[26]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x04FB, 92 bytes at 251[27]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 0: 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x04FC, 72 bytes at 252[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x04FD, 92 bytes at 253[29]:4
ieee80211 phy2: U iwl4965_mac_config leave

# Request locking to the 5ghz bssid

ieee80211 phy2: U iwl4965_mac_config_interface bssid: 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl4965_commit_rxon Toggling associated bit on current RX=
ON
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x04FE, 48 bytes at 254[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK

# We locked on and got the right channel...

* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x04FF, 48 bytes at 255[31]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0400, 16 bytes at 0[0]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0401, 140 bytes at 1[1]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0402, 72 bytes at 2[2]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0403, 92 bytes at 3[3]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 0: 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0404, 72 bytes at 4[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0405, 92 bytes at 5[5]:4
ieee80211 phy2: U iwl4965_mac_config_interface leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_set_key disable hwcrypto key
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), s=
eq: 0x0406, 40 bytes at 6[6]:4
ieee80211 phy2: U iwl4965_mac_set_key leave
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), s=
eq: 0x0407, 40 bytes at 7[7]:4
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), s=
eq: 0x0408, 40 bytes at 8[8]:4
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), s=
eq: 0x0409, 40 bytes at 9[9]:4
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x040A, 48 bytes at 10[10]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x040B, 16 bytes at 11[11]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x040C, 140 bytes at 12[12]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x040D, 72 bytes at 13[13]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x040E, 92 bytes at 14[14]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS

# Fail, fail, fail

wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authentication with AP 00:1a:1e:80:02:b0 timed out
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl_scan_initiate Starting scan...
ieee80211 phy2: U iwl4965_mac_hw_scan leave
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 1 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 2 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 3 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 4 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 5 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 6 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 7 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 8 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 9 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 10 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 11 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 11=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x440F, 382 bytes at 15[32]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3800
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 329K, =
56C
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x=
00000000:00988B61) - 1 (beacon timer 406885535)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:=
 0x00000000:0098ED9F) - 6 elapsed=3D25150 usec (10038ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x=
00000000:0098EF0A) - 1 (beacon timer 406860022)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:=
 0x00000000:009964FA) - 7 elapsed=3D30192 usec (31ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x=
00000000:00996665) - 1 (beacon timer 411126171)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:=
 0x00000000:0099E0B1) - 5 elapsed=3D31308 usec (31ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x=
00000000:0099E21D) - 1 (beacon timer 411094499)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:=
 0x00000000:009A084F) - 1 elapsed=3D9778 usec (11ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x=
00000000:009A09BB) - 1 (beacon timer 411084357)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:=
 0x00000000:009A24D9) - 0 elapsed=3D6942 usec (7ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x=
00000000:009A2645) - 1 (beacon timer 411077051)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:=
 0x00000000:009A8B8D) - 4 elapsed=3D25928 usec (26ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x=
00000000:009A8CF9) - 1 (beacon timer 411050759)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:=
 0x00000000:009AF9CD) - 5 elapsed=3D27860 usec (28ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x=
00000000:009AFB39) - 1 (beacon timer 415319239)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:=
 0x00000000:009B1BB5) - 1 elapsed=3D8316 usec (9ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x=
00000000:009B1D21) - 1 (beacon timer 415310559)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:=
 0x00000000:009B39B0) - 1 elapsed=3D7311 usec (8ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0=
x00000000:009B3B1C) - 1 (beacon timer 415302884)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF=
: 0x00000000:009B5D5F) - 1 elapsed=3D8771 usec (9ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0=
x00000000:009B5ECB) - 1 (beacon timer 415293749)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF=
: 0x00000000:009BD2BD) - 10 elapsed=3D29682 usec (30ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 11 channels (TS=
F 0x009BD434:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 216ms
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 36 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 40 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 44 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 48 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 52 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 56 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 60 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 64 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 149 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 153 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 157 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 161 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 165 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 13=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x4410, 398 bytes at 16[32]:4
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x=
00000000:009BD8AE) - 1 (beacon timer 415262546)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:=
 0x00000000:009D90CE) - 0 elapsed=3D112672 usec (114ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x=
00000000:009D9239) - 1 (beacon timer 419446215)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:=
 0x00000000:009F4A5B) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x=
00000000:009F4BC6) - 1 (beacon timer 423629882)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:=
 0x00000000:00A103E8) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x=
00000000:00A10553) - 1 (beacon timer 432110253)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:=
 0x00000000:00A2BD76) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x=
00000000:00A2BEE1) - 1 (beacon timer 436293919)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:=
 0x00000000:00A47704) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x=
00000000:00A47870) - 1 (beacon timer 440477584)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:=
 0x00000000:00A63090) - 1 elapsed=3D112672 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x=
00000000:00A631FC) - 1 (beacon timer 444661252)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:=
 0x00000000:00A7EA1E) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x=
00000000:00A7EB8A) - 1 (beacon timer 448844918)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:=
 0x00000000:00A9A3AC) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0=
x00000000:00A9A519) - 1 (beacon timer 453028583)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF=
: 0x00000000:00AB5D3C) - 0 elapsed=3D112675 usec (114ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0=
x00000000:00AB5EAA) - 1 (beacon timer 457212246)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF=
: 0x00000000:00AD16BE) - 1 elapsed=3D112660 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0=
x00000000:00AD182C) - 1 (beacon timer 461395924)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF=
: 0x00000000:00AED04E) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0=
x00000000:00AED1BC) - 1 (beacon timer 465579588)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF=
: 0x00000000:00B089DF) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0=
x00000000:00B08B4D) - 1 (beacon timer 469763251)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF=
: 0x00000000:00B24370) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 13 channels (TS=
F 0x00B244E7:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 5.2GHz took 1471ms
ieee80211 phy2: I iwl_rx_scan_complete_notif Setting scan to off
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan took 1687ms
ieee80211 phy2: U iwl_bg_scan_completed SCAN complete scan
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0411, 140 bytes at 17[17]:4
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0412, 48 bytes at 18[18]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0413, 16 bytes at 19[19]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0414, 140 bytes at 20[20]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0415, 72 bytes at 21[21]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0416, 92 bytes at 22[22]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0417, 48 bytes at 23[23]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0418, 16 bytes at 24[24]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0419, 140 bytes at 25[25]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x041A, 72 bytes at 26[26]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x041B, 92 bytes at 27[27]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authentication with AP 00:1a:1e:80:02:b0 timed out
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl_scan_initiate Starting scan...
ieee80211 phy2: U iwl4965_mac_hw_scan leave
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 1 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 2 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 3 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 4 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 5 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 6 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 7 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 8 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 9 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 10 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 11 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 11=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x441C, 382 bytes at 28[32]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3842
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 330K, =
57C
ieee80211 phy2: I iwl4965_hw_rx_statistics Temperature changed from 56C to =
57C
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x=
00000000:00988E0A) - 1 (beacon timer 406884854)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:=
 0x00000000:00990A2C) - 9 elapsed=3D31778 usec (10034ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x=
00000000:00990B97) - 1 (beacon timer 406852713)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:=
 0x00000000:00998853) - 5 elapsed=3D31932 usec (33ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x=
00000000:009989BE) - 1 (beacon timer 411117122)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:=
 0x00000000:0099F54C) - 3 elapsed=3D27534 usec (27ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x=
00000000:0099F6B8) - 1 (beacon timer 411089224)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:=
 0x00000000:009A5717) - 3 elapsed=3D24671 usec (26ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x=
00000000:009A5883) - 1 (beacon timer 411064189)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:=
 0x00000000:009AB557) - 2 elapsed=3D23764 usec (24ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x=
00000000:009AB6C3) - 1 (beacon timer 415336765)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:=
 0x00000000:009B1F5C) - 6 elapsed=3D26777 usec (27ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x=
00000000:009B20C8) - 1 (beacon timer 415309624)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:=
 0x00000000:009B874D) - 5 elapsed=3D26245 usec (26ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x=
00000000:009B88B9) - 1 (beacon timer 415283015)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:=
 0x00000000:009BED18) - 3 elapsed=3D25695 usec (27ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x=
00000000:009BEE84) - 1 (beacon timer 415256956)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:=
 0x00000000:009C57E2) - 2 elapsed=3D26974 usec (27ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0=
x00000000:009C594E) - 1 (beacon timer 419526322)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF=
: 0x00000000:009C762F) - 1 elapsed=3D7393 usec (7ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0=
x00000000:009C779B) - 1 (beacon timer 419518565)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF=
: 0x00000000:009CD798) - 4 elapsed=3D24573 usec (25ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 11 channels (TS=
F 0x009CD90F:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 283ms
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 36 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 40 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 44 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 48 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 52 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 56 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 60 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 64 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 149 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 153 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 157 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 161 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 165 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 13=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x441D, 398 bytes at 29[32]:4
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x=
00000000:009CDE3D) - 1 (beacon timer 419492291)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:=
 0x00000000:009E965D) - 0 elapsed=3D112672 usec (115ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x=
00000000:009E97C7) - 1 (beacon timer 423675960)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:=
 0x00000000:00A04FEA) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x=
00000000:00A05155) - 1 (beacon timer 427859627)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:=
 0x00000000:00A20977) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x=
00000000:00A20AE2) - 1 (beacon timer 432043294)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:=
 0x00000000:00A3C305) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x=
00000000:00A3C470) - 1 (beacon timer 436226960)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:=
 0x00000000:00A57C93) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x=
00000000:00A57DFF) - 1 (beacon timer 440410625)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:=
 0x00000000:00A7360E) - 1 elapsed=3D112655 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x=
00000000:00A7377A) - 1 (beacon timer 448891014)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:=
 0x00000000:00A8EF9C) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x=
00000000:00A8F108) - 1 (beacon timer 453074680)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:=
 0x00000000:00AAA92A) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0=
x00000000:00AAAA97) - 1 (beacon timer 457258345)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF=
: 0x00000000:00AC62BA) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0=
x00000000:00AC6428) - 1 (beacon timer 461442008)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF=
: 0x00000000:00AE1C3B) - 1 elapsed=3D112659 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0=
x00000000:00AE1DA9) - 1 (beacon timer 465625687)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF=
: 0x00000000:00AFD5CB) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0=
x00000000:00AFD739) - 1 (beacon timer 469809351)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF=
: 0x00000000:00B18F4C) - 0 elapsed=3D112659 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0=
x00000000:00B190BA) - 1 (beacon timer 473993030)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF=
: 0x00000000:00B348DD) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 13 channels (TS=
F 0x00B34A54:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 5.2GHz took 1470ms
ieee80211 phy2: I iwl_rx_scan_complete_notif Setting scan to off
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan took 1753ms
ieee80211 phy2: U iwl_bg_scan_completed SCAN complete scan
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x041E, 140 bytes at 30[30]:4
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x041F, 48 bytes at 31[31]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0420, 16 bytes at 32[0]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0421, 140 bytes at 33[1]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0422, 72 bytes at 34[2]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0423, 92 bytes at 35[3]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0424, 48 bytes at 36[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0425, 16 bytes at 37[5]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0426, 140 bytes at 38[6]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0427, 72 bytes at 39[7]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0428, 92 bytes at 40[8]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authentication with AP 00:1a:1e:80:02:b0 timed out
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl_scan_initiate Starting scan...
ieee80211 phy2: U iwl4965_mac_hw_scan leave
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 1 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 2 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 3 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 4 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 5 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 6 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 7 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 8 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 9 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 10 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 11 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 11=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x4429, 382 bytes at 41[32]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3850
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 330K, =
57C
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x=
00000000:00988EDA) - 1 (beacon timer 406884646)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:=
 0x00000000:0098EBA1) - 4 elapsed=3D23751 usec (10027ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x=
00000000:0098ED0C) - 1 (beacon timer 406860532)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:=
 0x00000000:00995453) - 6 elapsed=3D26439 usec (27ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x=
00000000:009955BE) - 1 (beacon timer 411130434)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:=
 0x00000000:0099B439) - 3 elapsed=3D24187 usec (25ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x=
00000000:0099B5A5) - 1 (beacon timer 411105883)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:=
 0x00000000:009A0DB1) - 2 elapsed=3D22540 usec (22ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x=
00000000:009A0F1D) - 1 (beacon timer 411082979)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:=
 0x00000000:009A2FE3) - 0 elapsed=3D8390 usec (9ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x=
00000000:009A314F) - 1 (beacon timer 411074225)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:=
 0x00000000:009A88BC) - 7 elapsed=3D22381 usec (23ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x=
00000000:009A8A28) - 1 (beacon timer 411051480)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:=
 0x00000000:009AED48) - 3 elapsed=3D25376 usec (26ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x=
00000000:009AEEB4) - 1 (beacon timer 415322444)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:=
 0x00000000:009B5735) - 3 elapsed=3D26753 usec (27ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x=
00000000:009B58A1) - 1 (beacon timer 415295327)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:=
 0x00000000:009B7AC0) - 1 elapsed=3D8735 usec (9ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0=
x00000000:009B7C2C) - 1 (beacon timer 415286228)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF=
: 0x00000000:009BDB0C) - 3 elapsed=3D24288 usec (25ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0=
x00000000:009BDC78) - 1 (beacon timer 415261576)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF=
: 0x00000000:009C0034) - 1 elapsed=3D9148 usec (9ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 11 channels (TS=
F 0x009C01AB:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 227ms
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 36 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 40 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 44 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 48 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 52 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 56 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 60 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 64 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 149 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 153 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 157 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 161 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 165 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 13=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x442A, 398 bytes at 42[32]:4
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x=
00000000:009C063A) - 1 (beacon timer 415250886)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:=
 0x00000000:009DBE5A) - 0 elapsed=3D112672 usec (114ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x=
00000000:009DBFC5) - 1 (beacon timer 419434555)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:=
 0x00000000:009F77E7) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x=
00000000:009F7952) - 1 (beacon timer 427914926)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:=
 0x00000000:00A13174) - 0 elapsed=3D112674 usec (114ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x=
00000000:00A132DF) - 1 (beacon timer 432098593)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:=
 0x00000000:00A2EB02) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x=
00000000:00A2EC6D) - 1 (beacon timer 436282259)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:=
 0x00000000:00A4A490) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x=
00000000:00A4A5FC) - 1 (beacon timer 440465924)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:=
 0x00000000:00A65E13) - 1 elapsed=3D112663 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x=
00000000:00A65F7F) - 1 (beacon timer 444649601)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:=
 0x00000000:00A817A1) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x=
00000000:00A8190D) - 1 (beacon timer 448833267)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:=
 0x00000000:00A9D12F) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0=
x00000000:00A9D29C) - 1 (beacon timer 453016932)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF=
: 0x00000000:00AB8ABF) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0=
x00000000:00AB8C2C) - 1 (beacon timer 457200595)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF=
: 0x00000000:00AD443F) - 1 elapsed=3D112659 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0=
x00000000:00AD45AD) - 1 (beacon timer 461384275)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF=
: 0x00000000:00AEFDBC) - 0 elapsed=3D112655 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0=
x00000000:00AEFF2A) - 1 (beacon timer 465567958)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF=
: 0x00000000:00B0B74D) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0=
x00000000:00B0B8BB) - 1 (beacon timer 474048325)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF=
: 0x00000000:00B270DE) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 13 channels (TS=
F 0x00B27255:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 5.2GHz took 1471ms
ieee80211 phy2: I iwl_rx_scan_complete_notif Setting scan to off
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan took 1698ms
ieee80211 phy2: U iwl_bg_scan_completed SCAN complete scan
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x042B, 140 bytes at 43[11]:4
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x042C, 48 bytes at 44[12]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x042D, 16 bytes at 45[13]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x042E, 140 bytes at 46[14]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x042F, 72 bytes at 47[15]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0430, 92 bytes at 48[16]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 56
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0431, 48 bytes at 49[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0432, 16 bytes at 50[18]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0433, 140 bytes at 51[19]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0434, 72 bytes at 52[20]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0435, 92 bytes at 53[21]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authenticate with AP 00:1a:1e:80:02:b0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: authentication with AP 00:1a:1e:80:02:b0 timed out
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl_scan_initiate Starting scan...
ieee80211 phy2: U iwl4965_mac_hw_scan leave
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 1 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 2 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 3 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 4 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 5 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 6 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 7 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 8 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 9 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 10 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 11 [ACTIVE 20]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 11=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x4436, 382 bytes at 54[32]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3862
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 330K, =
57C
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x=
00000000:00988EE5) - 1 (beacon timer 406884635)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF:=
 0x00000000:00990B42) - 9 elapsed=3D31837 usec (10035ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x=
00000000:00990CAD) - 1 (beacon timer 406852435)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF:=
 0x00000000:00998609) - 3 elapsed=3D31068 usec (32ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x=
00000000:00998774) - 1 (beacon timer 411117708)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF:=
 0x00000000:0099A385) - 0 elapsed=3D7185 usec (7ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x=
00000000:0099A4F1) - 1 (beacon timer 411110159)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF:=
 0x00000000:009A0435) - 3 elapsed=3D24388 usec (25ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x=
00000000:009A05A1) - 1 (beacon timer 411085407)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF:=
 0x00000000:009A6D6F) - 5 elapsed=3D26574 usec (27ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x=
00000000:009A6EDB) - 1 (beacon timer 411058469)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF:=
 0x00000000:009AE16B) - 10 elapsed=3D29328 usec (30ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x=
00000000:009AE2D7) - 1 (beacon timer 415325481)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF:=
 0x00000000:009B4693) - 5 elapsed=3D25532 usec (26ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x=
00000000:009B47FF) - 1 (beacon timer 415299585)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF:=
 0x00000000:009B69CA) - 1 elapsed=3D8651 usec (9ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x=
00000000:009B6B36) - 1 (beacon timer 415290570)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF:=
 0x00000000:009BE7AA) - 5 elapsed=3D31860 usec (31ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0=
x00000000:009BE916) - 1 (beacon timer 415258346)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF=
: 0x00000000:009C0664) - 1 elapsed=3D7502 usec (8ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0=
x00000000:009C07D0) - 1 (beacon timer 415250480)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF=
: 0x00000000:009C2AC4) - 1 elapsed=3D8948 usec (10ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 11 channels (TS=
F 0x009C2C3C:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 238ms
ieee80211 phy2: U iwl_bg_request_scan Start direct scan for 'UESC-N' (not a=
ssociated)
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 36 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 40 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 44 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 48 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 52 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 56 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 60 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 64 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 149 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 153 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 157 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 161 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan Scanning 165 [PASSIVE 110]
ieee80211 phy2: U iwl_get_channels_for_scan total channels to scan 13=20
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), se=
q: 0x4437, 398 bytes at 55[32]:4
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x=
00000000:009C30BE) - 1 (beacon timer 415240002)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF:=
 0x00000000:009DE8DE) - 0 elapsed=3D112672 usec (114ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x=
00000000:009DEA48) - 1 (beacon timer 423720375)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF:=
 0x00000000:009FA26B) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x=
00000000:009FA3D6) - 1 (beacon timer 427904042)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF:=
 0x00000000:00A15BF8) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x=
00000000:00A15D63) - 1 (beacon timer 432087709)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF:=
 0x00000000:00A31586) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x=
00000000:00A316F1) - 1 (beacon timer 436271375)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF:=
 0x00000000:00A4CF14) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x=
00000000:00A4D080) - 1 (beacon timer 440455040)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF:=
 0x00000000:00A68898) - 1 elapsed=3D112664 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x=
00000000:00A68A04) - 1 (beacon timer 444638716)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF:=
 0x00000000:00A84226) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x=
00000000:00A84392) - 1 (beacon timer 448822382)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF:=
 0x00000000:00A9FBB4) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0=
x00000000:00A9FD21) - 1 (beacon timer 453006047)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF=
: 0x00000000:00ABB544) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0=
x00000000:00ABB6B2) - 1 (beacon timer 457189710)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF=
: 0x00000000:00AD6EC2) - 1 elapsed=3D112656 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0=
x00000000:00AD7030) - 1 (beacon timer 465670096)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF=
: 0x00000000:00AF2852) - 0 elapsed=3D112674 usec (114ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0=
x00000000:00AF29C0) - 1 (beacon timer 469853760)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF=
: 0x00000000:00B0E1E2) - 0 elapsed=3D112674 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0=
x00000000:00B0E350) - 1 (beacon timer 474037424)
ieee80211 phy2: I iwl_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF=
: 0x00000000:00B29B73) - 0 elapsed=3D112675 usec (113ms since last)
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan complete: 13 channels (TS=
F 0x00B29CEA:00000000) - 1
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan pass on 5.2GHz took 1471ms
ieee80211 phy2: I iwl_rx_scan_complete_notif Setting scan to off
ieee80211 phy2: I iwl_rx_scan_complete_notif Scan took 1709ms
ieee80211 phy2: U iwl_bg_scan_completed SCAN complete scan
ieee80211 phy2: U iwl4965_mac_config enter to channel 56
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0438, 140 bytes at 56[24]:4
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: U iwl4965_mac_config enter to channel 1
ieee80211 phy2: U iwl_set_rxon_channel Staging channel set to 1 [0]
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:b0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0439, 48 bytes at 57[25]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x043A, 16 bytes at 58[26]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x043B, 140 bytes at 59[27]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x043C, 72 bytes at 60[28]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x043D, 92 bytes at 61[29]:4
ieee80211 phy2: U iwl4965_mac_config leave

# OK, give up and go to :a0, the 2.4ghz bssid

ieee80211 phy2: U iwl4965_mac_config_interface bssid: 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x043E, 48 bytes at 62[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x043F, 16 bytes at 63[31]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0440, 140 bytes at 64[0]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0441, 72 bytes at 65[1]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0442, 92 bytes at 66[2]:4
ieee80211 phy2: U iwl4965_mac_config_interface leave
ieee80211 phy2: U iwl4965_mac_config enter to channel 1
ieee80211 phy2: U iwl4965_mac_config TX Power old=3D14 new=3D14
ieee80211 phy2: U iwl4965_mac_config No re-sending same RXON configuration.
ieee80211 phy2: U iwl4965_mac_config leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_mac_reset_tsf enter
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0443, 48 bytes at 67[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0444, 16 bytes at 68[4]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0445, 140 bytes at 69[5]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0446, 72 bytes at 70[6]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0447, 92 bytes at 71[7]:4
ieee80211 phy2: U iwl4965_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:1a:1e:80:02:a0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
wlan0: RX authentication from 00:1a:1e:80:02:a0 (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:1a:1e:80:02:a0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: RX ReassocResp from 00:1a:1e:80:02:a0 (capab=3D0x431 status=3D0 aid=
=3D1)
wlan0: associated

# OK, we're on the 2.4ghz BSSID fine...

wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D3 cWmin=3D15 cWmax=3D1023 txop=
=3D0
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 txop=
=3D0
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 txop=3D94
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 txop=3D47
ieee80211 phy2: U iwl4965_mac_conf_tx enter
ieee80211 phy2: U iwl4965_mac_conf_tx leave
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x11
ieee80211 phy2: U iwl4965_bss_info_changed HT 1
ieee80211 phy2: U iwl4965_ht_conf enter:=20
ieee80211 phy2: U iwl4965_ht_conf control channel 1
ieee80211 phy2: U iwl4965_ht_conf leave
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl4965_bss_info_changed ASSOC 1
ieee80211 phy2: U iwl4965_post_associate Associated as 1 to: 00:1a:1e:80:02=
:a0
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0448, 48 bytes at 72[8]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0449, 16 bytes at 73[9]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x044A, 140 bytes at 74[10]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x044B, 72 bytes at 75[11]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x044C, 92 bytes at 76[12]:4
ieee80211 phy2: U iwl4965_setup_rxon_timing beacon interval 100 beacon time=
r 102016 beacon tim 0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON_TIMING (#14),=
 seq: 0x044D, 24 bytes at 77[13]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl_set_rxon_ht supported HT rate 0xFF 0xFF 0x0 rxon flag=
s 0x8005 operation mode :0x0 extension channel offset 0x0 control chan 1
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl4965_post_associate assoc id 1 beacon interval 100
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x044E, 48 bytes at 78[14]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x044F, 16 bytes at 79[15]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0450, 140 bytes at 80[16]:4
ieee80211 phy2: I iwl_sta_ucode_deactivate Removed STA from Ucode: ff:ff:ff=
:ff:ff:ff
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0451, 72 bytes at 81[17]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0452, 92 bytes at 82[18]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 0: 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0453, 72 bytes at 83[19]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0454, 92 bytes at 84[20]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), s=
eq: 0x0455, 40 bytes at 85[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0456, 12 bytes at 86[22]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3864
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 330K, =
57C
ieee80211 phy2: I iwl4965_is_temp_calib_needed Getting warmer, delta 3,=20
ieee80211 phy2: I iwl4965_is_temp_calib_needed Thermal txpower calib needed
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0457, 28 bytes at 87[23]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0458, 140 bytes at 88[24]:4
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x10
ieee80211 phy2: U iwl4965_bss_info_changed HT 1
ieee80211 phy2: U iwl4965_ht_conf enter:=20
ieee80211 phy2: U iwl4965_ht_conf control channel 1
ieee80211 phy2: U iwl4965_ht_conf leave
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl4965_bss_info_changed Associated Changes 16
ieee80211 phy2: U iwl4965_send_rxon_assoc Using current RXON_ASSOC.  Not re=
sending.
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0459, 28 bytes at 89[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045A, 28 bytes at 90[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045B, 28 bytes at 91[27]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045C, 28 bytes at 92[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045D, 28 bytes at 93[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045E, 28 bytes at 94[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045F, 28 bytes at 95[31]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0460, 28 bytes at 96[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0461, 28 bytes at 97[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0462, 28 bytes at 98[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0463, 28 bytes at 99[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0464, 28 bytes at 100[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0465, 28 bytes at 101[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0466, 12 bytes at 102[6]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0467, 28 bytes at 103[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
wlan0: RX deauthentication from 00:1a:1e:80:02:a0 (reason=3D3)
wlan0: deauthenticated
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0468, 72 bytes at 104[8]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x6
ieee80211 phy2: U iwl4965_bss_info_changed ERP_PREAMBLE 0
ieee80211 phy2: U iwl4965_bss_info_changed ERP_CTS 0
ieee80211 phy2: U iwl4965_bss_info_changed Associated Changes 6
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON_ASSOC (#11), =
seq: 0x0469, 20 bytes at 105[9]:4
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x1
ieee80211 phy2: U iwl4965_bss_info_changed ASSOC 0
ieee80211 phy2: U iwl4965_bss_info_changed DISASSOC 0
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_RXON_ASSOC (0x00=
000000)
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x046A, 72 bytes at 106[10]:4
ieee80211 phy2: U iwl4965_mac_set_key disable hwcrypto key
ieee80211 phy2: U iwl4965_mac_set_key leave
wlan0: RX deauthentication from 00:1a:1e:80:02:a0 (reason=3D7)
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x6
ieee80211 phy2: U iwl4965_bss_info_changed ERP_PREAMBLE 0
ieee80211 phy2: U iwl4965_bss_info_changed ERP_CTS 0
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x1
ieee80211 phy2: U iwl4965_bss_info_changed ASSOC 0
ieee80211 phy2: U iwl4965_bss_info_changed DISASSOC 0
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x046B, 28 bytes at 107[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x046C, 28 bytes at 108[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
wlan0: authenticate with AP 00:1a:1e:80:02:a0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: RX authentication from 00:1a:1e:80:02:a0 (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:1a:1e:80:02:a0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
wlan0: RX ReassocResp from 00:1a:1e:80:02:a0 (capab=3D0x431 status=3D0 aid=
=3D1)
wlan0: associated
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x046D, 92 bytes at 109[13]:4
wlan0: switched to short barker preamble (BSSID=3D00:1a:1e:80:02:a0)
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x15
ieee80211 phy2: U iwl4965_bss_info_changed ERP_PREAMBLE 1
ieee80211 phy2: U iwl4965_bss_info_changed HT 1
ieee80211 phy2: U iwl4965_ht_conf enter:=20
ieee80211 phy2: U iwl4965_ht_conf control channel 1
ieee80211 phy2: U iwl4965_ht_conf leave
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl4965_bss_info_changed ASSOC 1
ieee80211 phy2: U iwl4965_post_associate Associated as 1 to: 00:1a:1e:80:02=
:a0
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x046E, 48 bytes at 110[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x046F, 16 bytes at 111[15]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0470, 28 bytes at 112[16]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0471, 140 bytes at 113[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0472, 72 bytes at 114[18]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0473, 92 bytes at 115[19]:4
ieee80211 phy2: U iwl4965_setup_rxon_timing beacon interval 100 beacon time=
r 102016 beacon tim 0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON_TIMING (#14),=
 seq: 0x0474, 24 bytes at 116[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl_set_rxon_ht supported HT rate 0xFF 0xFF 0x0 rxon flag=
s 0x8035 operation mode :0x0 extension channel offset 0x0 control chan 1
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl4965_post_associate assoc id 1 beacon interval 100
ieee80211 phy2: U iwl4965_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0=
x0475, 48 bytes at 117[21]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_REMOVE_STA (#19), =
seq: 0x0476, 16 bytes at 118[22]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (=
#97), seq: 0x0477, 140 bytes at 119[23]:4
ieee80211 phy2: I iwl_sta_ucode_deactivate Removed STA from Ucode: ff:ff:ff=
:ff:ff:ff
ieee80211 phy2: U iwl_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x0478, 72 bytes at 120[24]:4
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0479, 92 bytes at 121[25]:4
ieee80211 phy2: U iwl_add_station_flags Add STA ID 0: 00:1a:1e:80:02:a0
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x047A, 72 bytes at 122[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_send_add_sta REPLY_ADD_STA PASSED
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x047B, 92 bytes at 123[27]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), s=
eq: 0x047C, 40 bytes at 124[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x047D, 72 bytes at 125[29]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_hw_scan enter
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl_set_ccmp_dynamic_key_info hwcrypto: modify ucode stat=
ion key info
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x047E, 72 bytes at 126[30]:4
ieee80211 phy2: U iwl4965_mac_set_key enable hwcrypto key
ieee80211 phy2: U iwl4965_mac_set_key leave
ieee80211 phy2: U iwl4965_mac_set_key enter
ieee80211 phy2: U iwl_set_ccmp_dynamic_key_info hwcrypto: modify ucode stat=
ion key info
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x047F, 72 bytes at 127[31]:4
ieee80211 phy2: U iwl4965_mac_set_key enable hwcrypto key
ieee80211 phy2: U iwl4965_mac_set_key leave
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x10
ieee80211 phy2: U iwl4965_bss_info_changed HT 1
ieee80211 phy2: U iwl4965_ht_conf enter:=20
ieee80211 phy2: U iwl4965_ht_conf control channel 1
ieee80211 phy2: U iwl4965_ht_conf leave
ieee80211 phy2: U iwl_set_rxon_chain rx chain 7C06
ieee80211 phy2: U iwl4965_bss_info_changed Associated Changes 16
ieee80211 phy2: U iwl4965_send_rxon_assoc Using current RXON_ASSOC.  Not re=
sending.
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3838
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 330K, =
57C
ieee80211 phy2: I iwl4965_is_temp_calib_needed Same temp,=20
ieee80211 phy2: I iwl4965_is_temp_calib_needed Thermal txpower calib not ne=
eded
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0480, 28 bytes at 128[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0481, 28 bytes at 129[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0482, 28 bytes at 130[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0483, 28 bytes at 131[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0484, 28 bytes at 132[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0485, 12 bytes at 133[5]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x0486, 92 bytes at 134[6]:4
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0487, 28 bytes at 135[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0488, 28 bytes at 136[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0489, 28 bytes at 137[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x048A, 28 bytes at 138[10]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x048B, 28 bytes at 139[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x048C, 28 bytes at 140[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x048D, 12 bytes at 141[13]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x048E, 28 bytes at 142[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x048F, 28 bytes at 143[15]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0490, 28 bytes at 144[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0491, 28 bytes at 145[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0492, 28 bytes at 146[18]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0493, 28 bytes at 147[19]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0494, 28 bytes at 148[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0495, 28 bytes at 149[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0496, 28 bytes at 150[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0497, 28 bytes at 151[23]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0498, 28 bytes at 152[24]:4
wlan0: CTS protection enabled (BSSID=3D00:1a:1e:80:02:a0)

# We're on and trying to ping now.  Some stuff works (ssh started, but
# then hung, etc)

ieee80211 phy2: U iwl4965_bss_info_changed changes =3D 0x2
ieee80211 phy2: U iwl4965_bss_info_changed ERP_CTS 1
ieee80211 phy2: U iwl4965_bss_info_changed Associated Changes 2
ieee80211 phy2: U iwl_enqueue_hcmd Sending command REPLY_RXON_ASSOC (#11), =
seq: 0x0499, 20 bytes at 153[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_RXON_ASSOC (0x00=
000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x049A, 28 bytes at 154[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x049B, 28 bytes at 155[27]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x049C, 28 bytes at 156[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x049D, 28 bytes at 157[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x049E, 28 bytes at 158[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x049F, 28 bytes at 159[31]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A0, 28 bytes at 160[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A1, 28 bytes at 161[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A2, 28 bytes at 162[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A3, 28 bytes at 163[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A4, 28 bytes at 164[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A5, 28 bytes at 165[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A6, 28 bytes at 166[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A7, 28 bytes at 167[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A8, 28 bytes at 168[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04A9, 28 bytes at 169[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04AA, 28 bytes at 170[10]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04AB, 28 bytes at 171[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04AC, 28 bytes at 172[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04AD, 28 bytes at 173[13]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04AE, 28 bytes at 174[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04AF, 28 bytes at 175[15]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B0, 28 bytes at 176[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B1, 28 bytes at 177[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B2, 28 bytes at 178[18]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B3, 28 bytes at 179[19]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B4, 28 bytes at 180[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B5, 28 bytes at 181[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B6, 28 bytes at 182[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B7, 28 bytes at 183[23]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B8, 28 bytes at 184[24]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04B9, 28 bytes at 185[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BA, 28 bytes at 186[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BB, 28 bytes at 187[27]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BC, 28 bytes at 188[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BD, 28 bytes at 189[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04BE, 28 bytes at 190[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x04BF, 92 bytes at 191[31]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C0, 28 bytes at 192[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C1, 28 bytes at 193[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x04C2, 92 bytes at 194[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C3, 28 bytes at 195[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C4, 28 bytes at 196[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C5, 28 bytes at 197[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C6, 28 bytes at 198[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C7, 28 bytes at 199[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04C8, 28 bytes at 200[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04C9, 12 bytes at 201[9]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CA, 28 bytes at 202[10]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CB, 28 bytes at 203[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CC, 28 bytes at 204[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CD, 28 bytes at 205[13]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CE, 28 bytes at 206[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04CF, 28 bytes at 207[15]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D0, 28 bytes at 208[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D1, 28 bytes at 209[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D2, 28 bytes at 210[18]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D3, 28 bytes at 211[19]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D4, 28 bytes at 212[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D5, 28 bytes at 213[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D6, 28 bytes at 214[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D7, 28 bytes at 215[23]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D8, 28 bytes at 216[24]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04D9, 28 bytes at 217[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DA, 28 bytes at 218[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DB, 28 bytes at 219[27]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DC, 28 bytes at 220[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04DD, 12 bytes at 221[29]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DE, 28 bytes at 222[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04DF, 28 bytes at 223[31]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E0, 28 bytes at 224[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E1, 28 bytes at 225[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E2, 28 bytes at 226[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E3, 28 bytes at 227[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E4, 28 bytes at 228[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E5, 28 bytes at 229[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E6, 28 bytes at 230[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E7, 28 bytes at 231[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3808
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 329K, =
56C
ieee80211 phy2: I iwl4965_hw_rx_statistics Temperature changed from 57C to =
56C
ieee80211 phy2: I iwl4965_is_temp_calib_needed Getting cooler, delta -1,=20
ieee80211 phy2: I iwl4965_is_temp_calib_needed Thermal txpower calib not ne=
eded
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E8, 28 bytes at 232[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04E9, 28 bytes at 233[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04EA, 12 bytes at 234[10]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x04EB, 92 bytes at 235[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04EC, 28 bytes at 236[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04ED, 28 bytes at 237[13]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04EE, 28 bytes at 238[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04EF, 12 bytes at 239[15]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04F0, 28 bytes at 240[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04F1, 12 bytes at 241[17]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04F2, 28 bytes at 242[18]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04F3, 12 bytes at 243[19]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04F4, 28 bytes at 244[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04F5, 28 bytes at 245[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04F6, 28 bytes at 246[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CM=
D (#4e), seq: 0x04F7, 92 bytes at 247[23]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_=
CMD (0x00000000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04F8, 12 bytes at 248[24]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04F9, 28 bytes at 249[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04FA, 12 bytes at 250[26]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x04FB, 12 bytes at 251[27]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04FC, 28 bytes at 252[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04FD, 28 bytes at 253[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04FE, 28 bytes at 254[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x04FF, 28 bytes at 255[31]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0400, 12 bytes at 0[0]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0401, 28 bytes at 1[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0402, 28 bytes at 2[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0403, 12 bytes at 3[3]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0404, 28 bytes at 4[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0405, 12 bytes at 5[5]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3822
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 330K, =
57C
ieee80211 phy2: I iwl4965_hw_rx_statistics Temperature changed from 56C to =
57C
ieee80211 phy2: I iwl4965_is_temp_calib_needed Same temp,=20
ieee80211 phy2: I iwl4965_is_temp_calib_needed Thermal txpower calib not ne=
eded
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0406, 28 bytes at 6[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0407, 28 bytes at 7[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0408, 28 bytes at 8[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0409, 12 bytes at 9[9]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x040A, 28 bytes at 10[10]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x040B, 12 bytes at 11[11]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x040C, 28 bytes at 12[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x040D, 28 bytes at 13[13]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x040E, 12 bytes at 14[14]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x040F, 28 bytes at 15[15]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0410, 28 bytes at 16[16]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0411, 12 bytes at 17[17]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0412, 28 bytes at 18[18]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0413, 28 bytes at 19[19]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0414, 28 bytes at 20[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0415, 28 bytes at 21[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0416, 12 bytes at 22[22]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0417, 28 bytes at 23[23]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0418, 28 bytes at 24[24]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0419, 12 bytes at 25[25]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x041A, 28 bytes at 26[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x041B, 28 bytes at 27[27]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x041C, 28 bytes at 28[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x041D, 28 bytes at 29[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x041E, 12 bytes at 30[30]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x041F, 28 bytes at 31[31]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0420, 28 bytes at 32[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0421, 28 bytes at 33[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0422, 28 bytes at 34[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0423, 12 bytes at 35[3]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0424, 28 bytes at 36[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0425, 28 bytes at 37[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0426, 28 bytes at 38[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0427, 12 bytes at 39[7]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0428, 28 bytes at 40[8]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0429, 28 bytes at 41[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x042A, 12 bytes at 42[10]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x042B, 12 bytes at 43[11]:4
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3832
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 330K, =
57C
ieee80211 phy2: I iwl4965_is_temp_calib_needed Same temp,=20
ieee80211 phy2: I iwl4965_is_temp_calib_needed Thermal txpower calib not ne=
eded
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x042C, 12 bytes at 44[12]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x042D, 28 bytes at 45[13]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x042E, 28 bytes at 46[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
iwl4965: iwl_tx_agg_start on ra =3D 00:1a:1e:80:02:a0 tid =3D 0
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq=
: 0x042F, 72 bytes at 47[15]:4
ieee80211 phy2: I iwl4965_tx_queue_set_status Activate BA Queue 7 on AC 1
HW queue is empty
requeue: qlen =3D 0
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
activated addBA response timer on tid 0
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_add_sta_callback Received REPLY_ADD_STA:(0x00000001)
Aggregation on for tid 0=20
recipient accepted agg: tid 0=20
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0430, 12 bytes at 48[16]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0431, 28 bytes at 49[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0432, 28 bytes at 50[18]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0433, 28 bytes at 51[19]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0434, 28 bytes at 52[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0435, 28 bytes at 53[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0436, 28 bytes at 54[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0437, 28 bytes at 55[23]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0438, 12 bytes at 56[24]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0439, 28 bytes at 57[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x043A, 28 bytes at 58[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x043B, 28 bytes at 59[27]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x043C, 28 bytes at 60[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x043D, 12 bytes at 61[29]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x043E, 28 bytes at 62[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x043F, 12 bytes at 63[31]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0440, 28 bytes at 64[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0441, 28 bytes at 65[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_rx_reply_rx Dropping (non network): ff:ff:ff:ff:f=
f:ff, 00:1a:1e:80:02:a0, 00:13:e8:92:3f:cb
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0442, 12 bytes at 66[2]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0443, 28 bytes at 67[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0444, 28 bytes at 68[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0445, 12 bytes at 69[5]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0446, 28 bytes at 70[6]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0447, 28 bytes at 71[7]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0448, 12 bytes at 72[8]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0449, 28 bytes at 73[9]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x044A, 28 bytes at 74[10]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x044B, 28 bytes at 75[11]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x044C, 28 bytes at 76[12]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x044D, 12 bytes at 77[13]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x044E, 28 bytes at 78[14]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x044F, 28 bytes at 79[15]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0450, 12 bytes at 80[16]:4
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl4965_hw_get_temperature Running temperature calibration
ieee80211 phy2: I iwl4965_hw_get_temperature Calib values R[1-3]: -130 1343=
4 -13586 R4: -3824
ieee80211 phy2: I iwl4965_hw_get_temperature Calibrated temperature: 330K, =
57C
ieee80211 phy2: I iwl4965_is_temp_calib_needed Same temp,=20
ieee80211 phy2: I iwl4965_is_temp_calib_needed Thermal txpower calib not ne=
eded
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0451, 28 bytes at 81[17]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0452, 28 bytes at 82[18]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0453, 12 bytes at 83[19]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0454, 28 bytes at 84[20]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0455, 28 bytes at 85[21]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0456, 28 bytes at 86[22]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl4965_mac_tx enter
ieee80211 phy2: I iwl4965_mac_tx leave
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x0457, 12 bytes at 87[23]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0458, 28 bytes at 88[24]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0459, 28 bytes at 89[25]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045A, 28 bytes at 90[26]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), se=
q: 0x045B, 12 bytes at 91[27]:4
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045C, 28 bytes at 92[28]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045D, 28 bytes at 93[29]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045E, 28 bytes at 94[30]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x045F, 28 bytes at 95[31]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0460, 28 bytes at 96[0]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0461, 28 bytes at 97[1]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0462, 28 bytes at 98[2]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0463, 28 bytes at 99[3]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0464, 28 bytes at 100[4]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)
ieee80211 phy2: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), s=
eq: 0x0465, 28 bytes at 101[5]:4
ieee80211 phy2: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x000=
00000)

# During the thrash, ping looks like:

=46rom 10.10.100.109 icmp_seq=3D45 Destination Host Unreachable
=46rom 10.10.100.109 icmp_seq=3D46 Destination Host Unreachable
64 bytes from 10.10.100.1: icmp_seq=3D1 ttl=3D64 time=3D47980 ms
64 bytes from 10.10.100.1: icmp_seq=3D2 ttl=3D64 time=3D46980 ms
64 bytes from 10.10.100.1: icmp_seq=3D3 ttl=3D64 time=3D45980 ms
64 bytes from 10.10.100.1: icmp_seq=3D4 ttl=3D64 time=3D44980 ms
64 bytes from 10.10.100.1: icmp_seq=3D5 ttl=3D64 time=3D43980 ms
64 bytes from 10.10.100.1: icmp_seq=3D6 ttl=3D64 time=3D42980 ms
64 bytes from 10.10.100.1: icmp_seq=3D7 ttl=3D64 time=3D41980 ms
64 bytes from 10.10.100.1: icmp_seq=3D8 ttl=3D64 time=3D40980 ms
64 bytes from 10.10.100.1: icmp_seq=3D9 ttl=3D64 time=3D39980 ms
64 bytes from 10.10.100.1: icmp_seq=3D10 ttl=3D64 time=3D38980 ms
64 bytes from 10.10.100.1: icmp_seq=3D11 ttl=3D64 time=3D37980 ms
64 bytes from 10.10.100.1: icmp_seq=3D12 ttl=3D64 time=3D36980 ms
64 bytes from 10.10.100.1: icmp_seq=3D13 ttl=3D64 time=3D35980 ms
64 bytes from 10.10.100.1: icmp_seq=3D14 ttl=3D64 time=3D34980 ms
64 bytes from 10.10.100.1: icmp_seq=3D15 ttl=3D64 time=3D33980 ms
64 bytes from 10.10.100.1: icmp_seq=3D47 ttl=3D64 time=3D1978 ms
64 bytes from 10.10.100.1: icmp_seq=3D48 ttl=3D64 time=3D978 ms
64 bytes from 10.10.100.1: icmp_seq=3D49 ttl=3D64 time=3D2.69 ms
64 bytes from 10.10.100.1: icmp_seq=3D50 ttl=3D64 time=3D5.06 ms
64 bytes from 10.10.100.1: icmp_seq=3D51 ttl=3D64 time=3D3.02 ms
64 bytes from 10.10.100.1: icmp_seq=3D52 ttl=3D64 time=3D2.57 ms
64 bytes from 10.10.100.1: icmp_seq=3D53 ttl=3D64 time=3D2.73 ms

Note that it got to the point that ping 45 failed and dropped, and then
ping 1 released and came back.

It runs along normally for a while then does this all again.

It's not wireless interference, I fired up a spec-an while testing, and
have seen this in other locations (just not when I could get logging).

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

"Alright, Sesame Street should not be using the 'F' word."

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhXuvEACgkQ17KIInOLvbEFlACfTHt0pNGOWZ1LZ5XmSuvgSNyS
6JoAoLTPjKp7u12WPktfancy6HGZMTUt
=0VQA
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
