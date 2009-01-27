Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:44823 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbZA0Xbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 18:31:41 -0500
Received: by gxk14 with SMTP id 14so5851201gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 15:31:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090127162437.GA3596@sortiz.org>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <20090126114453.GB3197@sortiz.org>
	 <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com>
	 <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
	 <20090127162437.GA3596@sortiz.org>
Date: Tue, 27 Jan 2009 18:31:38 -0500
Message-ID: <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com> (sfid-20090128_003201_614757_1603EA62)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> No, that's just a consequence of the bug, not the bug itself.
> Would you mind applying this patch on top of your latest wireless-testing tree
> and testing 3945 with it ? Thanks for your patience.

The patch did not cleanly apply, but I just removed the lines
indicated in the patch.  It crashed with a NULL pointer dereference.

Jason

[   15.110619] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network
Connection driver for Linux, 1.2.26kds
[   15.110707] iwl3945: Copyright(c) 2003-2009 Intel Corporation
[   15.110933] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   15.111003] iwl3945 0000:03:00.0: setting latency timer to 64
[   15.111284] ieee80211 phy0: U iwl3945_pci_probe pci_resource_len = 0x00001000
[   15.111369] ieee80211 phy0: U iwl3945_pci_probe pci_resource_base =
ffffc200050b4000
[   15.111506] ieee80211 phy0: U iwl3945_power_init_handle Initialize power
[   15.111571] ieee80211 phy0: U iwl3945_power_init_handle adjust
power command flags
[   15.166727] ieee80211 phy0: U iwl3945_pci_probe MAC address:
00:1f:3c:20:a1:6e
[   15.166803] ieee80211 phy0: U iwl_init_channel_map Initializing
regulatory info from EEPROM
[   15.166868] ieee80211 phy0: U iwl_init_channel_map Parsing data for
56 channels.
[   15.166939] ieee80211 phy0: U iwl_init_channel_map Ch. 1 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167020] ieee80211 phy0: U iwl_init_channel_map Ch. 2 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167094] ieee80211 phy0: U iwl_init_channel_map Ch. 3 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167162] ieee80211 phy0: U iwl_init_channel_map Ch. 4 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167241] ieee80211 phy0: U iwl_init_channel_map Ch. 5 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167309] ieee80211 phy0: U iwl_init_channel_map Ch. 6 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167383] ieee80211 phy0: U iwl_init_channel_map Ch. 7 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167466] ieee80211 phy0: U iwl_init_channel_map Ch. 8 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167544] ieee80211 phy0: U iwl_init_channel_map Ch. 9 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167613] ieee80211 phy0: U iwl_init_channel_map Ch. 10 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[   15.167686] ieee80211 phy0: U iwl_init_channel_map Ch. 11 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[   15.167771] ieee80211 phy0: U iwl_init_channel_map Ch. 12 Flags 0
[2.4GHz] - No traffic
[   15.167843] ieee80211 phy0: U iwl_init_channel_map Ch. 13 Flags 0
[2.4GHz] - No traffic
[   15.167910] ieee80211 phy0: U iwl_init_channel_map Ch. 14 Flags 0
[2.4GHz] - No traffic
[   15.167981] ieee80211 phy0: U iwl_init_channel_map Ch. 183 Flags 0
[5.2GHz] - No traffic
[   15.168078] ieee80211 phy0: U iwl_init_channel_map Ch. 184 Flags 0
[5.2GHz] - No traffic
[   15.168142] ieee80211 phy0: U iwl_init_channel_map Ch. 185 Flags 0
[5.2GHz] - No traffic
[   15.168206] ieee80211 phy0: U iwl_init_channel_map Ch. 187 Flags 0
[5.2GHz] - No traffic
[   15.168270] ieee80211 phy0: U iwl_init_channel_map Ch. 188 Flags 0
[5.2GHz] - No traffic
[   15.168339] ieee80211 phy0: U iwl_init_channel_map Ch. 189 Flags 0
[5.2GHz] - No traffic
[   15.168404] ieee80211 phy0: U iwl_init_channel_map Ch. 192 Flags 0
[5.2GHz] - No traffic
[   15.168468] ieee80211 phy0: U iwl_init_channel_map Ch. 196 Flags 0
[5.2GHz] - No traffic
[   15.168538] ieee80211 phy0: U iwl_init_channel_map Ch. 7 Flags 0
[5.2GHz] - No traffic
[   15.168615] ieee80211 phy0: U iwl_init_channel_map Ch. 8 Flags 0
[5.2GHz] - No traffic
[   15.168680] ieee80211 phy0: U iwl_init_channel_map Ch. 11 Flags 0
[5.2GHz] - No traffic
[   15.169403] ieee80211 phy0: U iwl_init_channel_map Ch. 12 Flags 0
[5.2GHz] - No traffic
[   15.169483] ieee80211 phy0: U iwl_init_channel_map Ch. 16 Flags 0
[5.2GHz] - No traffic
[   15.169551] ieee80211 phy0: U iwl_init_channel_map Ch. 34 Flags 0
[5.2GHz] - No traffic
[   15.169637] ieee80211 phy0: U iwl_init_channel_map Ch. 36 [5.2GHz]
VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
[   15.169705] ieee80211 phy0: U iwl_init_channel_map Ch. 38 Flags 0
[5.2GHz] - No traffic
[   15.169768] ieee80211 phy0: U iwl_init_channel_map Ch. 40 [5.2GHz]
VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
[   15.169834] ieee80211 phy0: U iwl_init_channel_map Ch. 42 Flags 0
[5.2GHz] - No traffic
[   15.169903] ieee80211 phy0: U iwl_init_channel_map Ch. 44 [5.2GHz]
VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
[   15.169970] ieee80211 phy0: U iwl_init_channel_map Ch. 46 Flags 0
[5.2GHz] - No traffic
[   15.170035] ieee80211 phy0: U iwl_init_channel_map Ch. 48 [5.2GHz]
VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
[   15.170102] ieee80211 phy0: U iwl_init_channel_map Ch. 52 [5.2GHz]
VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
[   15.170189] ieee80211 phy0: U iwl_init_channel_map Ch. 56 [5.2GHz]
VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
[   15.170257] ieee80211 phy0: U iwl_init_channel_map Ch. 60 [5.2GHz]
VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
[   15.170325] ieee80211 phy0: U iwl_init_channel_map Ch. 64 [5.2GHz]
VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
[   15.170399] ieee80211 phy0: U iwl_init_channel_map Ch. 100 Flags 0
[5.2GHz] - No traffic
[   15.170467] ieee80211 phy0: U iwl_init_channel_map Ch. 104 Flags 0
[5.2GHz] - No traffic
[   15.170541] ieee80211 phy0: U iwl_init_channel_map Ch. 108 Flags 0
[5.2GHz] - No traffic
[   15.170616] ieee80211 phy0: U iwl_init_channel_map Ch. 112 Flags 0
[5.2GHz] - No traffic
[   15.170686] ieee80211 phy0: U iwl_init_channel_map Ch. 116 Flags 0
[5.2GHz] - No traffic
[   15.170758] ieee80211 phy0: U iwl_init_channel_map Ch. 120 Flags 0
[5.2GHz] - No traffic
[   15.170822] ieee80211 phy0: U iwl_init_channel_map Ch. 124 Flags 0
[5.2GHz] - No traffic
[   15.170892] ieee80211 phy0: U iwl_init_channel_map Ch. 128 Flags 0
[5.2GHz] - No traffic
[   15.170976] ieee80211 phy0: U iwl_init_channel_map Ch. 132 Flags 0
[5.2GHz] - No traffic
[   15.171041] ieee80211 phy0: U iwl_init_channel_map Ch. 136 Flags 0
[5.2GHz] - No traffic
[   15.171105] ieee80211 phy0: U iwl_init_channel_map Ch. 140 Flags 0
[5.2GHz] - No traffic
[   15.171175] ieee80211 phy0: U iwl_init_channel_map Ch. 145 Flags 0
[5.2GHz] - No traffic
[   15.171243] ieee80211 phy0: U iwl_init_channel_map Ch. 149 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[   15.171311] ieee80211 phy0: U iwl_init_channel_map Ch. 153 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[   15.171378] ieee80211 phy0: U iwl_init_channel_map Ch. 157 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[   15.171451] ieee80211 phy0: U iwl_init_channel_map Ch. 161 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[   15.171531] ieee80211 phy0: U iwl_init_channel_map Ch. 165 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[   15.171605] ieee80211 phy0: U
iwl3945_hw_reg_txpower_get_temperature Temperature: 260
[   15.171674] ieee80211 phy0: U iwl3945_hw_reg_init_channel_groups
Initializing factory calib info from EEPROM
[   15.171745] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
1 mapped to grp 0
[   15.171809] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 1: -21 [260]
[   15.171874] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
2 mapped to grp 0
[   15.171937] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 2: -21 [260]
[   15.172008] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
3 mapped to grp 0
[   15.172095] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 3: -21 [260]
[   15.172162] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
4 mapped to grp 0
[   15.172230] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 4: -21 [260]
[   15.172296] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
5 mapped to grp 0
[   15.172386] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 5: -21 [260]
[   15.172457] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
6 mapped to grp 0
[   15.172520] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 6: -21 [260]
[   15.172596] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
7 mapped to grp 0
[   15.172659] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 7: -21 [260]
[   15.172725] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
8 mapped to grp 0
[   15.172789] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 8: -21 [260]
[   15.172873] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
9 mapped to grp 0
[   15.172937] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 9: -21 [260]
[   15.173004] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
10 mapped to grp 0
[   15.173097] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 10: -21 [260]
[   15.173175] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
11 mapped to grp 0
[   15.173240] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 11: -21 [260]
[   15.173311] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
36 mapped to grp 1
[   15.173374] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 36: -21 [260]
[   15.173467] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
40 mapped to grp 1
[   15.173544] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 40: -21 [260]
[   15.173617] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
44 mapped to grp 1
[   15.173686] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 44: -21 [260]
[   15.173758] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
48 mapped to grp 2
[   15.173821] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 48: -21 [260]
[   15.173887] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
52 mapped to grp 2
[   15.173968] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 52: -21 [260]
[   15.174046] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
56 mapped to grp 2
[   15.174122] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 56: -21 [260]
[   15.174211] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
60 mapped to grp 2
[   15.174277] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 60: -21 [260]
[   15.174344] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
64 mapped to grp 2
[   15.174412] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 64: -21 [260]
[   15.174482] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
149 mapped to grp 4
[   15.174546] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 149: -21 [260]
[   15.174612] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
153 mapped to grp 4
[   15.174681] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 153: -21 [260]
[   15.174760] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
157 mapped to grp 4
[   15.174823] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 157: -21 [260]
[   15.174890] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
161 mapped to grp 4
[   15.174960] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 161: -21 [260]
[   15.175029] ieee80211 phy0: U iwl3945_hw_reg_get_ch_grp_index Chnl
165 mapped to grp 4
[   15.175093] ieee80211 phy0: U iwl3945_txpower_set_from_eeprom Delta
index for channel 165: -21 [260]
[   15.175162] ieee80211 phy0: U iwlcore_init_geos Channel 1
Freq=2412[2.4GHz] valid flag=0x30
[   15.175231] ieee80211 phy0: U iwlcore_init_geos Channel 2
Freq=2417[2.4GHz] valid flag=0x30
[   15.175307] ieee80211 phy0: U iwlcore_init_geos Channel 3
Freq=2422[2.4GHz] valid flag=0x30
[   15.175371] ieee80211 phy0: U iwlcore_init_geos Channel 4
Freq=2427[2.4GHz] valid flag=0x30
[   15.175435] ieee80211 phy0: U iwlcore_init_geos Channel 5
Freq=2432[2.4GHz] valid flag=0x30
[   15.175505] ieee80211 phy0: U iwlcore_init_geos Channel 6
Freq=2437[2.4GHz] valid flag=0x30
[   15.175575] ieee80211 phy0: U iwlcore_init_geos Channel 7
Freq=2442[2.4GHz] valid flag=0x30
[   15.175640] ieee80211 phy0: U iwlcore_init_geos Channel 8
Freq=2447[2.4GHz] valid flag=0x30
[   15.175704] ieee80211 phy0: U iwlcore_init_geos Channel 9
Freq=2452[2.4GHz] valid flag=0x30
[   15.176448] ieee80211 phy0: U iwlcore_init_geos Channel 10
Freq=2457[2.4GHz] valid flag=0x30
[   15.176515] ieee80211 phy0: U iwlcore_init_geos Channel 11
Freq=2462[2.4GHz] valid flag=0x30
[   15.176587] ieee80211 phy0: U iwlcore_init_geos Channel 36
Freq=5180[5.2GHz] valid flag=0x36
[   15.176659] ieee80211 phy0: U iwlcore_init_geos Channel 40
Freq=5200[5.2GHz] valid flag=0x36
[   15.176723] ieee80211 phy0: U iwlcore_init_geos Channel 44
Freq=5220[5.2GHz] valid flag=0x36
[   15.176807] ieee80211 phy0: U iwlcore_init_geos Channel 48
Freq=5240[5.2GHz] valid flag=0x36
[   15.176875] ieee80211 phy0: U iwlcore_init_geos Channel 52
Freq=5260[5.2GHz] valid flag=0x3E
[   15.176941] ieee80211 phy0: U iwlcore_init_geos Channel 56
Freq=5280[5.2GHz] valid flag=0x3E
[   15.177019] ieee80211 phy0: U iwlcore_init_geos Channel 60
Freq=5300[5.2GHz] valid flag=0x3E
[   15.177104] ieee80211 phy0: U iwlcore_init_geos Channel 64
Freq=5320[5.2GHz] valid flag=0x3E
[   15.177169] ieee80211 phy0: U iwlcore_init_geos Channel 149
Freq=5745[5.2GHz] valid flag=0x36
[   15.177234] ieee80211 phy0: U iwlcore_init_geos Channel 153
Freq=5765[5.2GHz] valid flag=0x36
[   15.177305] ieee80211 phy0: U iwlcore_init_geos Channel 157
Freq=5785[5.2GHz] valid flag=0x36
[   15.177374] ieee80211 phy0: U iwlcore_init_geos Channel 161
Freq=5805[5.2GHz] valid flag=0x36
[   15.177444] ieee80211 phy0: U iwlcore_init_geos Channel 165
Freq=5825[5.2GHz] valid flag=0x36
[   15.177525] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13
802.11a channels
[   15.177597] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   15.177781] iwl3945 0000:03:00.0: irq 31 for MSI/MSI-X
[   15.177960] ieee80211 phy0: U iwl3945_set_rxon_channel Staging
channel set to 6 [0]
[   15.178799] wmaster0 (iwl3945): not using net_device_ops yet
[   15.179090] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   15.445074] wlan0 (iwl3945): not using net_device_ops yet
[   15.592361] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[   15.592434] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
[   15.592594] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   26.684365] ieee80211 phy0: U iwl3945_mac_start enter
[   26.755340] ieee80211 phy0: U iwl3945_read_ucode Got firmware
'iwlwifi-3945-2.ucode' file (149816 bytes) from disk
[   26.755352] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr
ucode version raw = 0xf1c0208
[   26.755356] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr
runtime inst size = 80684
[   26.755359] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr
runtime data size = 32768
[   26.755362] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr
init inst size = 2672
[   26.755365] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr
init data size = 32768
[   26.755367] ieee80211 phy0: U iwl3945_read_ucode f/w package hdr
boot inst size = 900
[   26.755441] ieee80211 phy0: U iwl3945_read_ucode Copying (but not
loading) uCode instr len 80684
[   26.755459] ieee80211 phy0: U iwl3945_read_ucode uCode instr buf
vaddr = 0xffff8800bb880000, paddr = 0xbb880000
[   26.755464] ieee80211 phy0: U iwl3945_read_ucode Copying (but not
loading) uCode data len 32768
[   26.755482] ieee80211 phy0: U iwl3945_read_ucode Copying (but not
loading) init instr len 2672
[   26.755486] ieee80211 phy0: U iwl3945_read_ucode Copying (but not
loading) init data len 32768
[   26.755498] ieee80211 phy0: U iwl3945_read_ucode Copying (but not
loading) boot instr len 900
[   26.755526] ieee80211 phy0: U iwl3945_power_init_handle Initialize power
[   26.755534] ieee80211 phy0: U iwl3945_power_init_handle adjust
power command flags
[   26.755628] ieee80211 phy0: U iwl3945_hw_nic_init HW Revision ID = 0x2
[   26.755675] ieee80211 phy0: U iwl3945_nic_config 3945 RADIO-MM type
[   26.755683] ieee80211 phy0: U iwl3945_nic_config SKU OP mode is basic
[   26.755686] ieee80211 phy0: U iwl3945_nic_config 3945ABG revision is 0xF1
[   26.755694] ieee80211 phy0: U iwl3945_nic_config Card M type B version is 0x3
[   26.756399] ieee80211 phy0: U iwl3945_load_bsm Begin load bsm
[   26.757665] ieee80211 phy0: U iwl3945_verify_bsm Begin verify bsm
[   26.759801] ieee80211 phy0: U iwl3945_verify_bsm BSM bootstrap uCode image OK
[   26.759855] ieee80211 phy0: U iwl3945_load_bsm BSM write complete,
poll 1 iterations
[   26.759870] ieee80211 phy0: U __iwl3945_up iwl3945 is coming up
[   26.759873] ieee80211 phy0: U iwl3945_mac_start Start UP work.
[   26.771305] BUG: unable to handle kernel NULL pointer dereference at (null)
[   26.771318] IP: [<ffffffffa038966e>]
iwl3945_irq_tasklet+0x4ee/0x1500 [iwl3945]
[   26.771334] PGD 139191067 PUD 138870067 PMD 0
[   26.771342] Oops: 0000 [#1] SMP
[   26.771347] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/firmware/0000:03:00.0/loading
[   26.771350] CPU 1
[   26.771354] Modules linked in: i915 drm i2c_algo_bit i2c_core
binfmt_misc ipv6 acpi_cpufreq cpufreq_ondemand cpufreq_stats
cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table
pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss
snd_mixer_oss arc4 ecb snd_pcm snd_seq_dummy snd_seq_oss iwl3945
iwlcore snd_seq_midi snd_rawmidi joydev mac80211 snd_seq_midi_event
thinkpad_acpi rfkill snd_seq lib80211 snd_timer cfg80211 pcmcia
led_class snd_seq_device evdev nvram psmouse snd soundcore serio_raw
pcspkr intel_agp iTCO_wdt iTCO_vendor_support video output battery ac
wmi shpchp pci_hotplug yenta_socket rsrc_nonstatic pcmcia_core
snd_page_alloc button ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif
sg ata_piix ata_generic ahci pata_acpi libata ohci1394 scsi_mod
ieee1394 ehci_hcd uhci_hcd usbcore thermal processor fan fuse
[   26.771494] Pid: 5156, comm: Xorg Not tainted 2.6.29-rc2-wl #27
[   26.771496] RIP: 0010:[<ffffffffa038966e>]  [<ffffffffa038966e>]
iwl3945_irq_tasklet+0x4ee/0x1500 [iwl3945]
[   26.771507] RSP: 0018:ffff88013b193df8  EFLAGS: 00010082
[   26.771509] RAX: 0000000000000000 RBX: ffff8801371d4c28 RCX: 0000000000000000
[   26.771512] RDX: 0000000080000008 RSI: ffffc200050b4010 RDI: 0000000000010000
[   26.771515] RBP: ffff88013b193ec8 R08: 0000000000001000 R09: 0000000000000000
[   26.771518] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801371d4c20
[   26.771520] R13: 0000000000000000 R14: ffff8801371c1a80 R15: ffffffff807e5600
[   26.771523] FS:  00007f4ee0d046e0(0000) GS:ffff88013bc03e00(0000)
knlGS:0000000000000000
[   26.771526] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.771530] CR2: 0000000000000000 CR3: 000000013887e000 CR4: 00000000000006e0
[   26.771533] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   26.771536] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   26.771539] Process Xorg (pid: 5156, threadinfo ffff880138846000,
task ffff880139010000)
[   26.771542] Stack:
[   26.771544]  ffff88013b193e08 ffffffff802b84cb ffff88013b193e18
ffffffff802b8505
[   26.771550]  ffff88013b193e58 ffff8801371c24a4 0001000000000000
0000000000000286
[   26.771558]  ffff88013b193e68 ffffffff802e5521 ffffffff8072cc20
ffffe200044464a0
[   26.771570] Call Trace:
[   26.771572]  <IRQ> <0> [<ffffffff802b84cb>] ? free_hot_page+0xb/0x10
[   26.771581]  [<ffffffff802b8505>] ? __free_pages+0x35/0x40
[   26.771585]  [<ffffffff802e5521>] ? add_partial+0x51/0x80
[   26.771590]  [<ffffffff802e85cf>] ? __slab_free+0x17f/0x340
[   26.771596]  [<ffffffff802f2544>] ? file_free_rcu+0x34/0x50
[   26.771603]  [<ffffffff80255e36>] tasklet_action+0x86/0x110
[   26.771608]  [<ffffffff802567ac>] __do_softirq+0x9c/0x170
[   26.771612]  [<ffffffff80214a5c>] call_softirq+0x1c/0x30
[   26.771617]  [<ffffffff80215f4d>] do_softirq+0x5d/0xa0
[   26.771621]  [<ffffffff80256505>] irq_exit+0x75/0xa0
[   26.771625]  [<ffffffff802161d6>] do_IRQ+0x86/0x110
[   26.771630]  [<ffffffff802141d3>] ret_from_intr+0x0/0x29
[   26.771635]  <EOI> <0>Code: c7 c0 f0 6b 39 a0 89 d9 48 c7 c7 10 b3
39 a0 31 c0 e8 e0 42 19 e0 e9 f2 fb ff ff 66 90 49 8b 86 60 4e 00 00
41 8b 8e 28 4e 00 00 <0f> b7 00 49 8d be 18 14 00 00 25 ff 0f 00 00 89
8d 7c ff ff ff
[   26.771723] RIP  [<ffffffffa038966e>]
iwl3945_irq_tasklet+0x4ee/0x1500 [iwl3945]
[   26.771810]  RSP <ffff88013b193df8>
[   26.771813] CR2: 0000000000000000
[   26.771817] ---[ end trace a87b87b3f9a3172a ]---
[   26.771819] Kernel panic - not syncing: Fatal exception in interrupt
[   26.771824] ------------[ cut here ]------------
[   26.771827] WARNING: at kernel/smp.c:299 smp_call_function_many+0x1f9/0x260()
[   26.771829] Hardware name: 7658CTO
[   26.771831] Modules linked in: i915 drm i2c_algo_bit i2c_core
binfmt_misc ipv6 acpi_cpufreq cpufreq_ondemand cpufreq_stats
cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table
pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss
snd_mixer_oss arc4 ecb snd_pcm snd_seq_dummy snd_seq_oss iwl3945
iwlcore snd_seq_midi snd_rawmidi joydev mac80211 snd_seq_midi_event
thinkpad_acpi rfkill snd_seq lib80211 snd_timer cfg80211 pcmcia
led_class snd_seq_device evdev nvram psmouse snd soundcore serio_raw
pcspkr intel_agp iTCO_wdt iTCO_vendor_support video output battery ac
wmi shpchp pci_hotplug yenta_socket rsrc_nonstatic pcmcia_core
snd_page_alloc button ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif
sg ata_piix ata_generic ahci pata_acpi libata ohci1394 scsi_mod
ieee1394 ehci_hcd uhci_hcd usbcore thermal processor fan fuse
[   26.772023] Pid: 5156, comm: Xorg Tainted: G      D    2.6.29-rc2-wl #27
[   26.772025] Call Trace:
[   26.772027]  <IRQ>  [<ffffffff80250440>] warn_slowpath+0xd0/0x130
[   26.772036]  [<ffffffff80230659>] ? default_spin_lock_flags+0x9/0x10
[   26.772040]  [<ffffffff80250d0d>] ? release_console_sem+0x1cd/0x220
[   26.772044]  [<ffffffff8051d9a0>] ? printk+0x67/0x6f
[   26.772048]  [<ffffffff80285e34>] ? crash_kexec+0x74/0x100
[   26.772052]  [<ffffffff80230659>] ? default_spin_lock_flags+0x9/0x10
[   26.772055]  [<ffffffff80279c29>] smp_call_function_many+0x1f9/0x260
[   26.772061]  [<ffffffff8021aeb0>] ? stop_this_cpu+0x0/0x30
[   26.772064]  [<ffffffff80250d0d>] ? release_console_sem+0x1cd/0x220
[   26.772068]  [<ffffffff80279cb0>] smp_call_function+0x20/0x30
[   26.772072]  [<ffffffff80226c03>] native_smp_send_stop+0x23/0x50
[   26.772075]  [<ffffffff8051d87e>] panic+0xaf/0x16a
[   26.772078]  [<ffffffff80285e34>] ? crash_kexec+0x74/0x100
[   26.772082]  [<ffffffff80250d0d>] ? release_console_sem+0x1cd/0x220
[   26.772085]  [<ffffffff80251035>] ? console_unblank+0x75/0x90
[   26.772089]  [<ffffffff805219fc>] oops_end+0xec/0x100
[   26.772093]  [<ffffffff805232ca>] do_page_fault+0x25a/0xbe0
[   26.772096]  [<ffffffff8023d828>] ? check_preempt_wakeup+0xf8/0x230
[   26.772100]  [<ffffffff80246c3f>] ? try_to_wake_up+0x13f/0x2e0
[   26.772103]  [<ffffffff805208d9>] ? _spin_lock+0x9/0x10
[   26.772107]  [<ffffffff802e5521>] ? add_partial+0x51/0x80
[   26.772111]  [<ffffffff802e85cf>] ? __slab_free+0x17f/0x340
[   26.772115]  [<ffffffff802b3422>] ? mempool_free_slab+0x12/0x20
[   26.772119]  [<ffffffff802b3422>] ? mempool_free_slab+0x12/0x20
[   26.772124]  [<ffffffff8031b301>] ? bvec_free_bs+0x21/0x40
[   26.772127]  [<ffffffff802b3422>] ? mempool_free_slab+0x12/0x20
[   26.772203]  [<ffffffff802b34ba>] ? mempool_free+0x8a/0xa0
[   26.772206]  [<ffffffff805208d9>] ? _spin_lock+0x9/0x10
[   26.772209]  [<ffffffff802e5521>] ? add_partial+0x51/0x80
[   26.772213]  [<ffffffff805208d9>] ? _spin_lock+0x9/0x10
[   26.772216]  [<ffffffff802e5521>] ? add_partial+0x51/0x80
[   26.772220]  [<ffffffff80242eda>] ? enqueue_entity+0x11a/0x2a0
[   26.772223]  [<ffffffff80520d45>] page_fault+0x25/0x30
[   26.772231]  [<ffffffffa038966e>] ?
iwl3945_irq_tasklet+0x4ee/0x1500 [iwl3945]
[   26.772239]  [<ffffffffa038923e>] ? iwl3945_irq_tasklet+0xbe/0x1500 [iwl3945]
[   26.772242]  [<ffffffff802b84cb>] ? free_hot_page+0xb/0x10
[   26.772245]  [<ffffffff802b8505>] ? __free_pages+0x35/0x40
[   26.772249]  [<ffffffff802e5521>] ? add_partial+0x51/0x80
[   26.772252]  [<ffffffff802e85cf>] ? __slab_free+0x17f/0x340
[   26.772256]  [<ffffffff802f2544>] ? file_free_rcu+0x34/0x50
[   26.772259]  [<ffffffff80255e36>] tasklet_action+0x86/0x110
[   26.772262]  [<ffffffff802567ac>] __do_softirq+0x9c/0x170
[   26.772265]  [<ffffffff80214a5c>] call_softirq+0x1c/0x30
[   26.772268]  [<ffffffff80215f4d>] do_softirq+0x5d/0xa0
[   26.772271]  [<ffffffff80256505>] irq_exit+0x75/0xa0
[   26.772274]  [<ffffffff802161d6>] do_IRQ+0x86/0x110
[   26.772277]  [<ffffffff802141d3>] ret_from_intr+0x0/0x29
[   26.772279]  <EOI> <4>---[ end trace a87b87b3f9a3172b ]---
[   26.772284] ------------[ cut here ]------------
[   26.772287] WARNING: at kernel/smp.c:220
smp_call_function_single+0xa5/0x100()
[   26.772289] Hardware name: 7658CTO
[   26.772291] Modules linked in: i915 drm i2c_algo_bit i2c_core
binfmt_misc ipv6 acpi_cpufreq cpufreq_ondemand cpufreq_stats
cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table
pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss
snd_mixer_oss arc4 ecb snd_pcm snd_seq_dummy snd_seq_oss iwl3945
iwlcore snd_seq_midi snd_rawmidi joydev mac80211 snd_seq_midi_event
thinkpad_acpi rfkill snd_seq lib80211 snd_timer cfg80211 pcmcia
led_class snd_seq_device evdev nvram psmouse snd soundcore serio_raw
pcspkr intel_agp iTCO_wdt iTCO_vendor_support video output battery ac
wmi shpchp pci_hotplug yenta_socket rsrc_nonstatic pcmcia_core
snd_page_alloc button ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif
sg ata_piix ata_generic ahci pata_acpi libata ohci1394 scsi_mod
ieee1394 ehci_hcd uhci_hcd usbcore thermal processor fan fuse
[   26.772533] Pid: 5156, comm: Xorg Tainted: G      D W  2.6.29-rc2-wl #27
[   26.772535] Call Trace:
[   26.772537]  <IRQ>  [<ffffffff80250440>] warn_slowpath+0xd0/0x130
[   26.772543]  [<ffffffff8051d7c6>] ? dump_stack+0x72/0x7b
[   26.772546]  [<ffffffff8027aa97>] ? print_modules+0x57/0xb0
[   26.772550]  [<ffffffff8025045a>] ? warn_slowpath+0xea/0x130
[   26.772553]  [<ffffffff80230659>] ? default_spin_lock_flags+0x9/0x10
[   26.772557]  [<ffffffff80250d0d>] ? release_console_sem+0x1cd/0x220
[   26.772561]  [<ffffffff802799d5>] smp_call_function_single+0xa5/0x100
[   26.772564]  [<ffffffff8051d9a0>] ? printk+0x67/0x6f
[   26.772567]  [<ffffffff80285e34>] ? crash_kexec+0x74/0x100
[   26.772570]  [<ffffffff80279bf2>] smp_call_function_many+0x1c2/0x260
[   26.772574]  [<ffffffff8021aeb0>] ? stop_this_cpu+0x0/0x30
[   26.772577]  [<ffffffff80250d0d>] ? release_console_sem+0x1cd/0x220
[   26.772580]  [<ffffffff80279cb0>] smp_call_function+0x20/0x30
[   26.772642]  [<ffffffff80226c03>] native_smp_send_stop+0x23/0x50
[   26.772645]  [<ffffffff8051d87e>] panic+0xaf/0x16a
[   26.772648]  [<ffffffff80285e34>] ? crash_kexec+0x74/0x100
[   26.772652]  [<ffffffff80250d0d>] ? release_console_sem+0x1cd/0x220
[   26.772655]  [<ffffffff80251035>] ? console_unblank+0x75/0x90
[   26.772659]  [<ffffffff805219fc>] oops_end+0xec/0x100
[   26.772662]  [<ffffffff805232ca>] do_page_fault+0x25a/0xbe0
[   26.772665]  [<ffffffff8023d828>] ? check_preempt_wakeup+0xf8/0x230
[   26.772669]  [<ffffffff80246c3f>] ? try_to_wake_up+0x13f/0x2e0
[   26.772672]  [<ffffffff805208d9>] ? _spin_lock+0x9/0x10
