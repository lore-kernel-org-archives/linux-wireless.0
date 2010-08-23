Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab0HWQdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 12:33:00 -0400
Date: Mon, 23 Aug 2010 12:32:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn fails to associate on 2.6.36-rc2
Message-ID: <20100823163259.GA15511@infradead.org>
References: <20100823110247.GA3198@infradead.org>
 <1282572681.20674.3.camel@wwguy-ubuntu>
 <20100823141432.GA29902@infradead.org>
 <1282574533.12500.1.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
In-Reply-To: <1282574533.12500.1.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 23, 2010 at 07:42:13AM -0700, Guy, Wey-Yi wrote:
> Turn both iwlagn anf mac80211 debugging on when you compile kernel and
> use debug=0x43fff when you load the iwlagn module

Here's a log for the sequence of:

	modprobe iwlagn debug=0x43fff
	ifup wlan0

until dhclient times out.

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=iwlagn-dmesg

[  112.069209] iwlagn 0000:03:00.0: PCI INT A disabled
[  116.890742] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[  116.890745] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[  116.890799] ieee80211 phy1: U iwl_pci_probe *** LOAD DRIVER ***
[  116.890840] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  116.890872] iwlagn 0000:03:00.0: setting latency timer to 64
[  116.891609] ieee80211 phy1: U iwl_pci_probe pci_resource_len = 0x00002000
[  116.891611] ieee80211 phy1: U iwl_pci_probe pci_resource_base = ffffc90018874000
[  116.891644] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[  116.891652] ieee80211 phy1: U iwl_prepare_card_hw iwl_prepare_card_hw enter
[  116.891664] ieee80211 phy1: U iwl_set_hw_ready hardware ready
[  116.891673] ieee80211 phy1: U iwl_eeprom_init NVM size = 2048
[  116.891788] ieee80211 phy1: U iwl_apm_init Init card's basic functions
[  116.891848] ieee80211 phy1: U iwl_apm_init L1 Enabled; Disabling L0S
[  116.892250] ieee80211 phy1: U iwlcore_eeprom_verify_signature EEPROM signature=0x00000004
[  116.911173] ieee80211 phy1: U iwl_eeprom_init NVM Type: EEPROM, version: 0x11e
[  116.911178] ieee80211 phy1: U iwl_apm_stop Stop card, put in low power state
[  116.911185] ieee80211 phy1: U iwl_apm_stop_master stop master
[  116.911223] iwlagn 0000:03:00.0: device EEPROM VER=0x11e, CALIB=0x4
[  116.911225] ieee80211 phy1: U iwl_pci_probe MAC address: 00:21:5d:b3:d0:88
[  116.911228] ieee80211 phy1: U iwl_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[  116.911230] ieee80211 phy1: U iwl_init_channel_map Initializing regulatory info from EEPROM
[  116.911232] ieee80211 phy1: U iwl_init_channel_map Parsing data for 56 channels.
[  116.911576] ieee80211 phy1: U iwl_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911580] ieee80211 phy1: U iwl_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911583] ieee80211 phy1: U iwl_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911586] ieee80211 phy1: U iwl_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911589] ieee80211 phy1: U iwl_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911592] ieee80211 phy1: U iwl_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911594] ieee80211 phy1: U iwl_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911597] ieee80211 phy1: U iwl_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911600] ieee80211 phy1: U iwl_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911603] ieee80211 phy1: U iwl_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911606] ieee80211 phy1: U iwl_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911609] ieee80211 phy1: U iwl_init_channel_map Ch. 12 [2.4GHz] VALID WIDE (0x61 15dBm): Ad-Hoc not supported
[  116.911612] ieee80211 phy1: U iwl_init_channel_map Ch. 13 [2.4GHz] VALID WIDE (0x61 15dBm): Ad-Hoc not supported
[  116.911614] ieee80211 phy1: U iwl_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
[  116.911616] ieee80211 phy1: U iwl_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
[  116.911619] ieee80211 phy1: U iwl_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
[  116.911621] ieee80211 phy1: U iwl_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
[  116.911623] ieee80211 phy1: U iwl_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
[  116.911624] ieee80211 phy1: U iwl_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
[  116.911626] ieee80211 phy1: U iwl_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
[  116.911628] ieee80211 phy1: U iwl_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
[  116.911630] ieee80211 phy1: U iwl_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
[  116.911632] ieee80211 phy1: U iwl_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
[  116.911634] ieee80211 phy1: U iwl_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
[  116.911636] ieee80211 phy1: U iwl_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
[  116.911638] ieee80211 phy1: U iwl_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
[  116.911640] ieee80211 phy1: U iwl_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
[  116.911642] ieee80211 phy1: U iwl_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
[  116.911645] ieee80211 phy1: U iwl_init_channel_map Ch. 36 [5.2GHz] VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[  116.911647] ieee80211 phy1: U iwl_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
[  116.911650] ieee80211 phy1: U iwl_init_channel_map Ch. 40 [5.2GHz] VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[  116.911652] ieee80211 phy1: U iwl_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
[  116.911655] ieee80211 phy1: U iwl_init_channel_map Ch. 44 [5.2GHz] VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[  116.911657] ieee80211 phy1: U iwl_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
[  116.911659] ieee80211 phy1: U iwl_init_channel_map Ch. 48 [5.2GHz] VALID WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[  116.911662] ieee80211 phy1: U iwl_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911665] ieee80211 phy1: U iwl_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911668] ieee80211 phy1: U iwl_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911671] ieee80211 phy1: U iwl_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911674] ieee80211 phy1: U iwl_init_channel_map Ch. 100 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911676] ieee80211 phy1: U iwl_init_channel_map Ch. 104 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911679] ieee80211 phy1: U iwl_init_channel_map Ch. 108 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911682] ieee80211 phy1: U iwl_init_channel_map Ch. 112 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911685] ieee80211 phy1: U iwl_init_channel_map Ch. 116 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911688] ieee80211 phy1: U iwl_init_channel_map Ch. 120 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911691] ieee80211 phy1: U iwl_init_channel_map Ch. 124 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911693] ieee80211 phy1: U iwl_init_channel_map Ch. 128 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911696] ieee80211 phy1: U iwl_init_channel_map Ch. 132 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911699] ieee80211 phy1: U iwl_init_channel_map Ch. 136 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911702] ieee80211 phy1: U iwl_init_channel_map Ch. 140 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911704] ieee80211 phy1: U iwl_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
[  116.911707] ieee80211 phy1: U iwl_init_channel_map Ch. 149 [5.2GHz] VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[  116.911710] ieee80211 phy1: U iwl_init_channel_map Ch. 153 [5.2GHz] VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[  116.911712] ieee80211 phy1: U iwl_init_channel_map Ch. 157 [5.2GHz] VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[  116.911715] ieee80211 phy1: U iwl_init_channel_map Ch. 161 [5.2GHz] VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[  116.911718] ieee80211 phy1: U iwl_init_channel_map Ch. 165 [5.2GHz] VALID WIDE DFS (0xa1 15dBm): Ad-Hoc not supported
[  116.911721] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 1 [2.4GHz] IBSS ACTIVE WIDE (0x6f 10dBm): Ad-Hoc supported
[  116.911724] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 5 [2.4GHz] IBSS ACTIVE WIDE (0x6f 10dBm): Ad-Hoc supported
[  116.911727] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 2 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911729] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 6 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911732] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 3 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911735] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 7 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911738] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 4 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911740] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 8 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911743] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 5 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911746] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 9 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911749] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 6 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911751] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 10 [2.4GHz] IBSS ACTIVE WIDE (0x6f 15dBm): Ad-Hoc supported
[  116.911754] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 7 [2.4GHz] IBSS ACTIVE WIDE (0x6f 13dBm): Ad-Hoc supported
[  116.911757] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 11 [2.4GHz] IBSS ACTIVE WIDE (0x6f 13dBm): Ad-Hoc supported
[  116.911760] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 36 [5.2GHz] WIDE DFS (0xe1 14dBm): Ad-Hoc not supported
[  116.911762] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 40 [5.2GHz] WIDE DFS (0xe1 14dBm): Ad-Hoc not supported
[  116.911765] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 44 [5.2GHz] WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[  116.911768] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 48 [5.2GHz] WIDE DFS (0xe1 15dBm): Ad-Hoc not supported
[  116.911771] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 52 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911773] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 56 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911776] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 60 [5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[  116.911779] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 64 [5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[  116.911782] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 100 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911785] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 104 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911787] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 108 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911790] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 112 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911793] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 116 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911796] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 120 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911799] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 124 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911802] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 128 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911804] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 132 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911807] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 136 [5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[  116.911810] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 149 [5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[  116.911813] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 153 [5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[  116.911816] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 157 [5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[  116.911818] ieee80211 phy1: U iwl_mod_ht40_chan_info HT40 Ch. 161 [5.2GHz] WIDE (0x61 15dBm): Ad-Hoc not supported
[  116.911826] ieee80211 phy1: U iwlcore_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=0x20
[  116.911829] ieee80211 phy1: U iwlcore_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=0x20
[  116.911831] ieee80211 phy1: U iwlcore_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=0x20
[  116.911833] ieee80211 phy1: U iwlcore_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=0x20
[  116.911835] ieee80211 phy1: U iwlcore_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=0x0
[  116.911838] ieee80211 phy1: U iwlcore_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=0x0
[  116.911840] ieee80211 phy1: U iwlcore_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=0x0
[  116.911842] ieee80211 phy1: U iwlcore_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=0x10
[  116.911844] ieee80211 phy1: U iwlcore_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=0x10
[  116.911847] ieee80211 phy1: U iwlcore_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=0x10
[  116.911849] ieee80211 phy1: U iwlcore_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=0x10
[  116.911851] ieee80211 phy1: U iwlcore_init_geos Channel 12 Freq=2467[2.4GHz] valid flag=0x36
[  116.911854] ieee80211 phy1: U iwlcore_init_geos Channel 13 Freq=2472[2.4GHz] valid flag=0x36
[  116.911856] ieee80211 phy1: U iwlcore_init_geos Channel 36 Freq=5180[5.2GHz] valid flag=0x26
[  116.911858] ieee80211 phy1: U iwlcore_init_geos Channel 40 Freq=5200[5.2GHz] valid flag=0x16
[  116.911860] ieee80211 phy1: U iwlcore_init_geos Channel 44 Freq=5220[5.2GHz] valid flag=0x26
[  116.911863] ieee80211 phy1: U iwlcore_init_geos Channel 48 Freq=5240[5.2GHz] valid flag=0x16
[  116.911865] ieee80211 phy1: U iwlcore_init_geos Channel 52 Freq=5260[5.2GHz] valid flag=0x2E
[  116.911867] ieee80211 phy1: U iwlcore_init_geos Channel 56 Freq=5280[5.2GHz] valid flag=0x1E
[  116.911869] ieee80211 phy1: U iwlcore_init_geos Channel 60 Freq=5300[5.2GHz] valid flag=0x2E
[  116.911871] ieee80211 phy1: U iwlcore_init_geos Channel 64 Freq=5320[5.2GHz] valid flag=0x1E
[  116.911874] ieee80211 phy1: U iwlcore_init_geos Channel 100 Freq=5500[5.2GHz] valid flag=0x2E
[  116.911876] ieee80211 phy1: U iwlcore_init_geos Channel 104 Freq=5520[5.2GHz] valid flag=0x1E
[  116.911878] ieee80211 phy1: U iwlcore_init_geos Channel 108 Freq=5540[5.2GHz] valid flag=0x2E
[  116.911881] ieee80211 phy1: U iwlcore_init_geos Channel 112 Freq=5560[5.2GHz] valid flag=0x1E
[  116.911883] ieee80211 phy1: U iwlcore_init_geos Channel 116 Freq=5580[5.2GHz] valid flag=0x2E
[  116.911885] ieee80211 phy1: U iwlcore_init_geos Channel 120 Freq=5600[5.2GHz] valid flag=0x1E
[  116.911887] ieee80211 phy1: U iwlcore_init_geos Channel 124 Freq=5620[5.2GHz] valid flag=0x2E
[  116.911890] ieee80211 phy1: U iwlcore_init_geos Channel 128 Freq=5640[5.2GHz] valid flag=0x1E
[  116.911892] ieee80211 phy1: U iwlcore_init_geos Channel 132 Freq=5660[5.2GHz] valid flag=0x2E
[  116.911894] ieee80211 phy1: U iwlcore_init_geos Channel 136 Freq=5680[5.2GHz] valid flag=0x1E
[  116.911896] ieee80211 phy1: U iwlcore_init_geos Channel 140 Freq=5700[5.2GHz] valid flag=0x3E
[  116.911899] ieee80211 phy1: U iwlcore_init_geos Channel 149 Freq=5745[5.2GHz] valid flag=0x26
[  116.911901] ieee80211 phy1: U iwlcore_init_geos Channel 153 Freq=5765[5.2GHz] valid flag=0x16
[  116.911903] ieee80211 phy1: U iwlcore_init_geos Channel 157 Freq=5785[5.2GHz] valid flag=0x26
[  116.911906] ieee80211 phy1: U iwlcore_init_geos Channel 161 Freq=5805[5.2GHz] valid flag=0x16
[  116.911908] ieee80211 phy1: U iwlcore_init_geos Channel 165 Freq=5825[5.2GHz] valid flag=0x36
[  116.911910] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[  116.912066] iwlagn 0000:03:00.0: irq 49 for MSI/MSI-X
[  116.913655] ieee80211 phy1: U iwl_tt_initialize Initialize Thermal Throttling
[  116.913657] ieee80211 phy1: U iwl_tt_initialize Legacy Thermal Throttling
[  116.913659] ieee80211 phy1: U iwl_request_firmware attempting to load firmware 'iwlwifi-5000-2.ucode'
[  116.921518] ieee80211 phy1: U iwl_ucode_callback Loaded firmware file 'iwlwifi-5000-2.ucode' (353240 bytes).
[  116.921522] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[  116.921524] ieee80211 phy1: U iwl_ucode_callback f/w package hdr ucode version raw = 0x818020c
[  116.921526] ieee80211 phy1: U iwl_ucode_callback f/w package hdr runtime inst size = 130700
[  116.921528] ieee80211 phy1: U iwl_ucode_callback f/w package hdr runtime data size = 49152
[  116.921530] ieee80211 phy1: U iwl_ucode_callback f/w package hdr init inst size = 124212
[  116.921532] ieee80211 phy1: U iwl_ucode_callback f/w package hdr init data size = 49152
[  116.921534] ieee80211 phy1: U iwl_ucode_callback f/w package hdr boot inst size = 0
[  116.921673] ieee80211 phy1: U iwl_ucode_callback Copying (but not loading) uCode instr len 130700
[  116.921692] ieee80211 phy1: U iwl_ucode_callback uCode instr buf vaddr = 0xffff880125700000, paddr = 0x25700000
[  116.921694] ieee80211 phy1: U iwl_ucode_callback Copying (but not loading) uCode data len 49152
[  116.921715] ieee80211 phy1: U iwl_ucode_callback Copying (but not loading) init instr len 124212
[  116.921742] ieee80211 phy1: U iwl_ucode_callback Copying (but not loading) init data len 49152
[  116.921750] ieee80211 phy1: U iwl_ucode_callback Copying (but not loading) boot instr len 0
[  116.922401] phy1: Selected rate control algorithm 'iwl-agn-rs'
[  130.686519] ieee80211 phy1: U iwl_mac_start enter
[  130.686524] ieee80211 phy1: U iwl_prep_station Add STA to driver ID 15: ff:ff:ff:ff:ff:ff
[  130.686527] ieee80211 phy1: U iwl_prepare_card_hw iwl_prepare_card_hw enter
[  130.686556] ieee80211 phy1: U iwl_set_hw_ready hardware ready
[  130.686566] ieee80211 phy1: U iwl_apm_init Init card's basic functions
[  130.686605] ieee80211 phy1: U iwl_apm_init L1 Enabled; Disabling L0S
[  130.688323] ieee80211 phy1: U iwlagn_load_ucode Init ucode found. Loading init ucode...
[  130.688385] ieee80211 phy1: U iwlagn_load_section INST uCode section being loaded...
[  130.691993] ieee80211 phy1: U iwlagn_load_section DATA uCode section being loaded...
[  130.694679] ieee80211 phy1: U iwlagn_load_ucode Init ucode load complete.
[  130.694682] ieee80211 phy1: U __iwl_up iwlagn is coming up
[  130.694684] ieee80211 phy1: U iwl_mac_start Start UP work done.
[  130.702936] ieee80211 phy1: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
[  130.702940] ieee80211 phy1: I iwl_rx_reply_alive Initialization Alive received.
[  130.707026] ieee80211 phy1: U iwlcore_verify_inst_sparse ucode inst image size is 0
[  130.707029] ieee80211 phy1: U iwl_verify_ucode Bootstrap uCode is good in inst SRAM
[  130.708016] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
[  130.708016] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
[  130.708016] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
[  130.708016] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
[  130.708016] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
[  130.709519] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command COEX_PRIORITY_TABLE_CMD
[  130.709522] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[  130.709527] ieee80211 phy1: U iwl_enqueue_hcmd Sending command COEX_PRIORITY_TABLE_CMD (#5a), seq: 0x0400, 72 bytes at 0[0]:4
[  130.709562] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[  130.709712] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[  130.709714] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.709717] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CMD (#b0), seq: 0x4401, 12 bytes at 1[32]:4
[  130.709774] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.709783] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command CALIBRATION_CFG_CMD
[  130.709785] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command CALIBRATION_CFG_CMD
[  130.709788] ieee80211 phy1: U iwl_enqueue_hcmd Sending command CALIBRATION_CFG_CMD (#65), seq: 0x0402, 96 bytes at 2[2]:4
[  130.709827] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command CALIBRATION_CFG_CMD
[  130.785241] ieee80211 phy1: I iwlagn_rx_calib_complete Init. calibration is completed, restarting fw.
[  130.785252] ieee80211 phy1: U __iwl_down iwlagn is going down
[  130.785254] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode stations in driver
[  130.785256] ieee80211 phy1: U iwl_clear_ucode_stations No active stations found to be cleared
[  130.785493] ieee80211 phy1: U iwl_apm_stop Stop card, put in low power state
[  130.785501] ieee80211 phy1: U iwl_apm_stop_master stop master
[  130.785539] ieee80211 phy1: U iwl_clear_free_frames 0 frames on pre-allocated heap on clear.
[  130.785544] ieee80211 phy1: U iwl_prep_station Add STA to driver ID 15: ff:ff:ff:ff:ff:ff
[  130.785547] ieee80211 phy1: U iwl_prepare_card_hw iwl_prepare_card_hw enter
[  130.785575] ieee80211 phy1: U iwl_set_hw_ready hardware ready
[  130.785584] ieee80211 phy1: U iwl_apm_init Init card's basic functions
[  130.785623] ieee80211 phy1: U iwl_apm_init L1 Enabled; Disabling L0S
[  130.786515] ieee80211 phy1: U iwlagn_load_ucode Init ucode not found, or already loaded. Loading runtime ucode...
[  130.786584] ieee80211 phy1: U iwlagn_load_section INST uCode section being loaded...
[  130.790257] ieee80211 phy1: U iwlagn_load_section DATA uCode section being loaded...
[  130.792944] ieee80211 phy1: U iwlagn_load_ucode Runtime ucode load complete.
[  130.792947] ieee80211 phy1: U __iwl_up iwlagn is coming up
[  130.801201] ieee80211 phy1: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
[  130.801203] ieee80211 phy1: I iwl_rx_reply_alive Runtime Alive received.
[  130.806026] ieee80211 phy1: U iwl_alive_start Runtime Alive received.
[  130.806032] ieee80211 phy1: U iwlcore_verify_inst_sparse ucode inst image size is 0
[  130.806035] ieee80211 phy1: U iwl_verify_ucode Bootstrap uCode is good in inst SRAM
[  130.807009] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
[  130.807009] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
[  130.807009] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
[  130.807009] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
[  130.807009] ieee80211 phy1: U iwlagn_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
[  130.808537] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command COEX_PRIORITY_TABLE_CMD
[  130.808542] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[  130.808549] ieee80211 phy1: U iwl_enqueue_hcmd Sending command COEX_PRIORITY_TABLE_CMD (#5a), seq: 0x0400, 72 bytes at 0[0]:4
[  130.808583] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command COEX_PRIORITY_TABLE_CMD
[  130.808610] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[  130.808616] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.808622] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CMD (#b0), seq: 0x4401, 12 bytes at 1[32]:4
[  130.808675] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.808920] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[  130.808924] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.808929] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CMD (#b0), seq: 0x4402, 512 bytes at 2[32]:4
[  130.808967] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.808977] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[  130.808981] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.808985] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CMD (#b0), seq: 0x4403, 92 bytes at 3[32]:4
[  130.809020] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.809246] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[  130.809250] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.809255] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CMD (#b0), seq: 0x4404, 52 bytes at 4[32]:4
[  130.809286] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.809297] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_PHY_CALIBRATION_CMD
[  130.809300] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.809305] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_PHY_CALIBRATION_CMD (#b0), seq: 0x4405, 12 bytes at 5[32]:4
[  130.809334] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_PHY_CALIBRATION_CMD
[  130.809352] ieee80211 phy1: U iwlagn_send_tx_ant_config select valid tx ant: 2
[  130.809356] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command TX_ANT_CONFIGURATION_CMD
[  130.809363] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command TX_ANT_CONFIGURATION_CMD
[  130.809368] ieee80211 phy1: U iwl_enqueue_hcmd Sending command TX_ANT_CONFIGURATION_CMD (#98), seq: 0x0406, 8 bytes at 6[6]:4
[  130.809392] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command TX_ANT_CONFIGURATION_CMD
[  130.809408] ieee80211 phy1: U iwl_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[  130.809412] ieee80211 phy1: U iwl_send_bt_config BT coex active
[  130.809415] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_BT_CONFIG
[  130.809418] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_BT_CONFIG
[  130.809422] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0407, 16 bytes at 7[7]:4
[  130.809450] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_BT_CONFIG
[  130.809462] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_STATISTICS_CMD (#9c), seq: 0x0408, 8 bytes at 8[8]:4
[  130.809468] ieee80211 phy1: U iwl_commit_rxon Sending RXON
[  130.809469] * without RXON_FILTER_ASSOC_MSK
[  130.809470] * channel = 1
[  130.809471] * bssid = 00:00:00:00:00:00
[  130.809474] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_RXON
[  130.809478] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[  130.809482] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0409, 54 bytes at 9[9]:4
[  130.809500] ieee80211 phy1: I iwl_tt_handler Queueing thermal throttling work.
[  130.809506] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_STATISTICS_CMD (0x00000000)
[  130.810765] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[  130.810786] ieee80211 phy1: I iwl_tt_handler Queueing thermal throttling work.
[  130.810795] ieee80211 phy1: U iwl_commit_rxon Return from !new_assoc RXON.
[  130.810799] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode stations in driver
[  130.810802] ieee80211 phy1: U iwl_clear_ucode_stations No active stations found to be cleared
[  130.810805] ieee80211 phy1: U iwl_restore_stations Not ready yet, not restoring any stations.
[  130.810809] ieee80211 phy1: U iwl_print_rx_config_cmd RX CONFIG:
[  130.810813] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  130.810816] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 06 24 ff 0f 00 00  ...........$....
[  130.810819] iwl data: 00000020: 05 80 00 00 04 00 00 00 01 00 ff ff ff 00 00 00  ................
[  130.810822] iwl data: 00000030: 00 00                                            ..
[  130.810825] ieee80211 phy1: U iwl_print_rx_config_cmd u16 channel: 0x1
[  130.810828] ieee80211 phy1: U iwl_print_rx_config_cmd u32 flags: 0x00008005
[  130.810831] ieee80211 phy1: U iwl_print_rx_config_cmd u32 filter_flags: 0x00000004
[  130.810834] ieee80211 phy1: U iwl_print_rx_config_cmd u8 dev_type: 0x3
[  130.810837] ieee80211 phy1: U iwl_print_rx_config_cmd u8 ofdm_basic_rates: 0xff
[  130.810840] ieee80211 phy1: U iwl_print_rx_config_cmd u8 cck_basic_rates: 0x0f
[  130.810843] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] node_addr: 00:00:00:00:00:00
[  130.810847] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
[  130.810850] ieee80211 phy1: U iwl_print_rx_config_cmd u16 assoc_id: 0x0
[  130.810855] ieee80211 phy1: U iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x040A, 28 bytes at 10[10]:4
[  130.810860] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_CT_KILL_CONFIG_CMD
[  130.810863] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_CT_KILL_CONFIG_CMD
[  130.810867] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_CT_KILL_CONFIG_CMD (#a4), seq: 0x040B, 16 bytes at 11[11]:4
[  130.812193] ieee80211 phy1: I iwlagn_pass_packet_to_mac80211 Dropping packet while interface is not open.
[  130.812208] ieee80211 phy1: I iwl_generic_cmd_callback back from SENSITIVITY_CMD (0x00000000)
[  130.812213] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_CT_KILL_CONFIG_CMD
[  130.812230] ieee80211 phy1: U iwl_rf_kill_ct_config REPLY_CT_KILL_CONFIG_CMD succeeded, critical temperature is 110
[  130.812234] ieee80211 phy1: U iwl_alive_start ALIVE processing complete.
[  130.812239] ieee80211 phy1: U iwl_power_sleep_cam_cmd Sleep command for CAM
[  130.812242] ieee80211 phy1: U iwl_set_power Sending power/sleep command
[  130.812245] ieee80211 phy1: U iwl_set_power Flags value = 0x00000000
[  130.812248] ieee80211 phy1: U iwl_set_power Tx timeout = 0
[  130.812250] ieee80211 phy1: U iwl_set_power Rx timeout = 0
[  130.812254] ieee80211 phy1: U iwl_set_power Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
[  130.812257] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command POWER_TABLE_CMD
[  130.812262] ieee80211 phy1: U iwl_mac_start leave
[  130.812267] ieee80211 phy1: U iwl_mac_add_interface enter: type 2, addr 00:21:5d:b3:d0:88
[  130.812271] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command POWER_TABLE_CMD
[  130.812276] ieee80211 phy1: U iwl_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x040C, 40 bytes at 12[12]:4
[  130.812334] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
[  130.812343] ieee80211 phy1: U iwl_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[  130.812347] ieee80211 phy1: U iwl_commit_rxon Sending RXON
[  130.812348] * without RXON_FILTER_ASSOC_MSK
[  130.812349] * channel = 1
[  130.812350] * bssid = 00:00:00:00:00:00
[  130.812354] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_RXON
[  130.812357] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[  130.812361] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040D, 54 bytes at 13[13]:4
[  130.812570] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[  130.812591] ieee80211 phy1: U iwl_commit_rxon Return from !new_assoc RXON.
[  130.812600] ieee80211 phy1: I iwl_tt_handler Queueing thermal throttling work.
[  130.812604] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode stations in driver
[  130.812607] ieee80211 phy1: U iwl_clear_ucode_stations No active stations found to be cleared
[  130.812610] ieee80211 phy1: U iwl_restore_stations Restoring all known stations ... start.
[  130.812613] ieee80211 phy1: U iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[  130.812617] ieee80211 phy1: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[  130.812621] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  130.812624] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  130.812628] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040E, 96 bytes at 14[14]:4
[  130.812711] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  130.812723] ieee80211 phy1: U iwl_process_add_sta_resp Processing response for adding station 15
[  130.812727] ieee80211 phy1: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  130.812731] ieee80211 phy1: U iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[  130.812734] ieee80211 phy1: U iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[  130.812738] ieee80211 phy1: U iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[  130.812742] ieee80211 phy1: U is_lq_table_valid Channel 1 is not an HT channel
[  130.812746] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[  130.812749] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.812754] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x040F, 92 bytes at 15[15]:4
[  130.812795] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.812803] ieee80211 phy1: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[  130.812806] ieee80211 phy1: U iwl_restore_stations Restoring all known stations .... complete.
[  130.812810] ieee80211 phy1: U iwl_print_rx_config_cmd RX CONFIG:
[  130.812813] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  130.812816] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 06 24 ff 0f 00 00  ...........$....
[  130.812819] iwl data: 00000020: 05 80 00 00 04 00 00 00 01 00 ff ff ff 00 00 00  ................
[  130.812822] iwl data: 00000030: 00 00                                            ..
[  130.812825] ieee80211 phy1: U iwl_print_rx_config_cmd u16 channel: 0x1
[  130.812828] ieee80211 phy1: U iwl_print_rx_config_cmd u32 flags: 0x00008005
[  130.812831] ieee80211 phy1: U iwl_print_rx_config_cmd u32 filter_flags: 0x00000004
[  130.812834] ieee80211 phy1: U iwl_print_rx_config_cmd u8 dev_type: 0x3
[  130.812837] ieee80211 phy1: U iwl_print_rx_config_cmd u8 ofdm_basic_rates: 0xff
[  130.812840] ieee80211 phy1: U iwl_print_rx_config_cmd u8 cck_basic_rates: 0x0f
[  130.812843] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] node_addr: 00:00:00:00:00:00
[  130.812846] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
[  130.812849] ieee80211 phy1: U iwl_print_rx_config_cmd u16 assoc_id: 0x0
[  130.812854] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x0410, 8 bytes at 16[16]:4
[  130.812857] ieee80211 phy1: U iwl_alive_start Updated power mode
[  130.812865] ieee80211 phy1: U iwl_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[  130.812870] ieee80211 phy1: U iwl_commit_rxon Sending RXON
[  130.812871] * without RXON_FILTER_ASSOC_MSK
[  130.812872] * channel = 1
[  130.812873] * bssid = 00:00:00:00:00:00
[  130.812876] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_RXON
[  130.812879] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[  130.812883] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0411, 54 bytes at 17[17]:4
[  130.812952] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)
[  130.813109] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[  130.813434] ieee80211 phy1: U iwl_commit_rxon Return from !new_assoc RXON.
[  130.813437] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode stations in driver
[  130.813441] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode active for station 15
[  130.813444] ieee80211 phy1: U iwl_restore_stations Restoring all known stations ... start.
[  130.813447] ieee80211 phy1: U iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[  130.813451] ieee80211 phy1: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[  130.813454] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  130.813458] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  130.813462] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0412, 96 bytes at 18[18]:4
[  130.813521] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  130.813838] ieee80211 phy1: U iwl_process_add_sta_resp Processing response for adding station 15
[  130.813842] ieee80211 phy1: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  130.813845] ieee80211 phy1: U iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[  130.813849] ieee80211 phy1: U iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[  130.813853] ieee80211 phy1: U iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[  130.813857] ieee80211 phy1: U is_lq_table_valid Channel 1 is not an HT channel
[  130.813860] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[  130.813863] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.813868] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0413, 92 bytes at 19[19]:4
[  130.813912] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.813931] ieee80211 phy1: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[  130.813935] ieee80211 phy1: U iwl_restore_stations Restoring all known stations .... complete.
[  130.813938] ieee80211 phy1: U iwl_print_rx_config_cmd RX CONFIG:
[  130.813942] iwl data: 00000000: 00 21 5d b3 d0 88 00 00 00 00 00 00 00 00 00 00  .!].............
[  130.813945] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 06 24 ff 0f 00 00  ...........$....
[  130.813948] iwl data: 00000020: 05 80 00 00 04 00 00 00 01 00 ff ff ff 00 00 00  ................
[  130.813951] iwl data: 00000030: 00 00                                            ..
[  130.813953] ieee80211 phy1: U iwl_print_rx_config_cmd u16 channel: 0x1
[  130.813957] ieee80211 phy1: U iwl_print_rx_config_cmd u32 flags: 0x00008005
[  130.813960] ieee80211 phy1: U iwl_print_rx_config_cmd u32 filter_flags: 0x00000004
[  130.813963] ieee80211 phy1: U iwl_print_rx_config_cmd u8 dev_type: 0x3
[  130.813966] ieee80211 phy1: U iwl_print_rx_config_cmd u8 ofdm_basic_rates: 0xff
[  130.813969] ieee80211 phy1: U iwl_print_rx_config_cmd u8 cck_basic_rates: 0x0f
[  130.813972] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] node_addr: 00:21:5d:b3:d0:88
[  130.813975] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
[  130.813978] ieee80211 phy1: U iwl_print_rx_config_cmd u16 assoc_id: 0x0
[  130.813983] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x0414, 8 bytes at 20[20]:4
[  130.813988] ieee80211 phy1: U iwl_mac_add_interface leave
[  130.813991] ieee80211 phy1: U iwl_bss_info_changed changes = 0xE
[  130.813994] ieee80211 phy1: U iwl_bss_info_changed ERP_PREAMBLE 0
[  130.813997] ieee80211 phy1: U iwl_bss_info_changed ERP_CTS 0
[  130.814000] ieee80211 phy1: U iwl_bss_info_changed leave
[  130.814016] phy1: device now idle
[  130.814019] ieee80211 phy1: U iwl_mac_flush enter
[  130.814022] ieee80211 phy1: U iwl_mac_flush wait transmit/flush all frames
[  130.814025] ieee80211 phy1: U iwl_mac_flush leave
[  130.814029] ieee80211 phy1: U iwl_mac_config enter to channel 1 changed 0xFFFFFFFF
[  130.814033] ieee80211 phy1: U iwl_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[  130.814038] ieee80211 phy1: U iwl_power_sleep_cam_cmd Sleep command for CAM
[  130.814041] ieee80211 phy1: U iwl_mac_config TX Power old=15 new=15
[  130.814045] ieee80211 phy1: U iwl_commit_rxon Sending RXON
[  130.814047] * without RXON_FILTER_ASSOC_MSK
[  130.814048] * channel = 1
[  130.814048] * bssid = 00:00:00:00:00:00
[  130.814052] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_RXON
[  130.814055] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[  130.814059] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0415, 54 bytes at 21[21]:4
[  130.814097] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)
[  130.814256] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[  130.814523] ieee80211 phy1: U iwl_commit_rxon Return from !new_assoc RXON.
[  130.814525] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode stations in driver
[  130.814527] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode active for station 15
[  130.814529] ieee80211 phy1: U iwl_restore_stations Restoring all known stations ... start.
[  130.814531] ieee80211 phy1: U iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[  130.814533] ieee80211 phy1: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[  130.814535] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  130.814537] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  130.814539] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0416, 96 bytes at 22[22]:4
[  130.814571] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  130.814581] ieee80211 phy1: U iwl_process_add_sta_resp Processing response for adding station 15
[  130.814583] ieee80211 phy1: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  130.814585] ieee80211 phy1: U iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[  130.814587] ieee80211 phy1: U iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[  130.814589] ieee80211 phy1: U iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[  130.814591] ieee80211 phy1: U is_lq_table_valid Channel 1 is not an HT channel
[  130.814593] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[  130.814595] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.814598] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0417, 92 bytes at 23[23]:4
[  130.814637] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.814641] ieee80211 phy1: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[  130.814643] ieee80211 phy1: U iwl_restore_stations Restoring all known stations .... complete.
[  130.814645] ieee80211 phy1: U iwl_print_rx_config_cmd RX CONFIG:
[  130.814647] iwl data: 00000000: 00 21 5d b3 d0 88 00 00 00 00 00 00 00 00 00 00  .!].............
[  130.814649] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 06 24 15 03 00 00  ...........$....
[  130.814651] iwl data: 00000020: 05 80 00 00 04 00 00 00 01 00 ff ff ff 00 00 00  ................
[  130.814652] iwl data: 00000030: 00 00                                            ..
[  130.814654] ieee80211 phy1: U iwl_print_rx_config_cmd u16 channel: 0x1
[  130.814656] ieee80211 phy1: U iwl_print_rx_config_cmd u32 flags: 0x00008005
[  130.814657] ieee80211 phy1: U iwl_print_rx_config_cmd u32 filter_flags: 0x00000004
[  130.814659] ieee80211 phy1: U iwl_print_rx_config_cmd u8 dev_type: 0x3
[  130.814661] ieee80211 phy1: U iwl_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
[  130.814663] ieee80211 phy1: U iwl_print_rx_config_cmd u8 cck_basic_rates: 0x03
[  130.814664] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] node_addr: 00:21:5d:b3:d0:88
[  130.814666] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
[  130.814668] ieee80211 phy1: U iwl_print_rx_config_cmd u16 assoc_id: 0x0
[  130.814671] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x0418, 8 bytes at 24[24]:4
[  130.814673] ieee80211 phy1: U iwl_mac_config leave
[  130.814676] ieee80211 phy1: U iwl_mac_conf_tx enter
[  130.814677] ieee80211 phy1: U iwl_mac_conf_tx leave
[  130.814679] ieee80211 phy1: U iwl_mac_conf_tx enter
[  130.814680] ieee80211 phy1: U iwl_mac_conf_tx leave
[  130.814682] ieee80211 phy1: U iwl_mac_conf_tx enter
[  130.814683] ieee80211 phy1: U iwl_mac_conf_tx leave
[  130.814685] ieee80211 phy1: U iwl_mac_conf_tx enter
[  130.814686] ieee80211 phy1: U iwl_mac_conf_tx leave
[  130.814688] ieee80211 phy1: U iwl_bss_info_changed changes = 0x2000
[  130.814690] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), seq: 0x0419, 40 bytes at 25[25]:4
[  130.814693] ieee80211 phy1: U iwl_bss_info_changed leave
[  130.814713] phy1: device no longer idle - scanning
[  130.814715] ieee80211 phy1: U iwl_mac_config enter to channel 1 changed 0x100
[  130.814717] ieee80211 phy1: U iwl_power_sleep_cam_cmd Sleep command for CAM
[  130.814719] ieee80211 phy1: U iwl_mac_config Not re-sending same RXON configuration.
[  130.814721] ieee80211 phy1: U iwl_mac_config leave
[  130.814723] ieee80211 phy1: U iwl_mac_hw_scan enter
[  130.814725] ieee80211 phy1: U iwl_scan_initiate Starting scan...
[  130.814730] ieee80211 phy1: U iwlagn_request_scan Kicking off active scan
[  130.814733] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=1 prob=0x3 [ACTIVE 36]
[  130.814735] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=2 prob=0x3 [ACTIVE 36]
[  130.814737] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=3 prob=0x3 [ACTIVE 36]
[  130.814740] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=4 prob=0x3 [ACTIVE 36]
[  130.814742] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=5 prob=0x3 [ACTIVE 36]
[  130.814744] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=6 prob=0x3 [ACTIVE 36]
[  130.814747] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=7 prob=0x3 [ACTIVE 36]
[  130.814749] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=8 prob=0x3 [ACTIVE 36]
[  130.814751] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=9 prob=0x3 [ACTIVE 36]
[  130.814753] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=10 prob=0x3 [ACTIVE 36]
[  130.814755] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=11 prob=0x3 [ACTIVE 36]
[  130.814758] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=12 prob=0x2 [PASSIVE 120]
[  130.814760] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=13 prob=0x2 [PASSIVE 120]
[  130.814762] ieee80211 phy1: U iwl_get_channels_for_scan total channels to scan 13
[  130.814764] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_SCAN_CMD
[  130.814765] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
[  130.814766] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)
[  130.814771] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x441A, 994 bytes at 26[32]:4
[  130.814776] ieee80211 phy1: U iwl_configure_filter Enter: changed: 0x10, total: 0x80000010
[  130.814936] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_QOS_PARAM (0x00000000)
[  130.814938] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
[  130.814943] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x00000000:000002F2) - 1 (beacon timer 101646)
[  130.814959] ieee80211 phy1: U iwl_mac_hw_scan leave
[  130.815857] ieee80211 phy1: U iwl_commit_rxon Sending RXON
[  130.815858] * without RXON_FILTER_ASSOC_MSK
[  130.815858] * channel = 1
[  130.815859] * bssid = 00:00:00:00:00:00
[  130.815861] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_RXON
[  130.815863] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[  130.815866] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x041B, 54 bytes at 27[27]:4
[  130.816300] ieee80211 phy1: I iwl_rx_scan_complete_notif Scan complete: 0 channels (TSF 0x00000848:00000000) - 8
[  130.816304] ieee80211 phy1: I iwl_rx_scan_complete_notif Scan on 2.4GHz took 2ms
[  130.816305] ieee80211 phy1: I iwl_rx_scan_complete_notif Setting scan to off
[  130.816422] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[  130.816428] ieee80211 phy1: U iwl_commit_rxon Return from !new_assoc RXON.
[  130.816431] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode stations in driver
[  130.816440] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode active for station 15
[  130.816442] ieee80211 phy1: U iwl_restore_stations Restoring all known stations ... start.
[  130.816444] ieee80211 phy1: U iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[  130.816446] ieee80211 phy1: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[  130.816448] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  130.816450] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  130.816453] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041C, 96 bytes at 28[28]:4
[  130.816509] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  130.816514] ieee80211 phy1: U iwl_process_add_sta_resp Processing response for adding station 15
[  130.816516] ieee80211 phy1: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  130.816518] ieee80211 phy1: U iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[  130.816520] ieee80211 phy1: U iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[  130.816522] ieee80211 phy1: U iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[  130.816525] ieee80211 phy1: U is_lq_table_valid Channel 1 is not an HT channel
[  130.816527] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[  130.816529] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.816531] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041D, 92 bytes at 29[29]:4
[  130.816581] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.816597] ieee80211 phy1: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[  130.816599] ieee80211 phy1: U iwl_restore_stations Restoring all known stations .... complete.
[  130.816601] ieee80211 phy1: U iwl_print_rx_config_cmd RX CONFIG:
[  130.816604] iwl data: 00000000: 00 21 5d b3 d0 88 00 00 00 00 00 00 00 00 00 00  .!].............
[  130.816605] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 06 24 15 03 00 00  ...........$....
[  130.816607] iwl data: 00000020: 05 80 00 00 44 00 00 00 01 00 ff ff ff 00 00 00  ....D...........
[  130.816609] iwl data: 00000030: 00 00                                            ..
[  130.816610] ieee80211 phy1: U iwl_print_rx_config_cmd u16 channel: 0x1
[  130.816612] ieee80211 phy1: U iwl_print_rx_config_cmd u32 flags: 0x00008005
[  130.816614] ieee80211 phy1: U iwl_print_rx_config_cmd u32 filter_flags: 0x00000044
[  130.816616] ieee80211 phy1: U iwl_print_rx_config_cmd u8 dev_type: 0x3
[  130.816617] ieee80211 phy1: U iwl_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
[  130.816619] ieee80211 phy1: U iwl_print_rx_config_cmd u8 cck_basic_rates: 0x03
[  130.816621] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] node_addr: 00:21:5d:b3:d0:88
[  130.816623] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
[  130.816625] ieee80211 phy1: U iwl_print_rx_config_cmd u16 assoc_id: 0x0
[  130.816627] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x041E, 8 bytes at 30[30]:4
[  130.816632] ieee80211 phy1: U iwl_configure_filter Enter: changed: 0x0, total: 0x80000010
[  130.816634] ieee80211 phy1: U iwl_commit_rxon Sending RXON
[  130.816635] * without RXON_FILTER_ASSOC_MSK
[  130.816635] * channel = 1
[  130.816636] * bssid = 00:00:00:00:00:00
[  130.816638] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_RXON
[  130.816640] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[  130.816642] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x041F, 54 bytes at 31[31]:4
[  130.816751] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)
[  130.816914] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[  130.816918] ieee80211 phy1: U iwl_commit_rxon Return from !new_assoc RXON.
[  130.816920] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode stations in driver
[  130.816922] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode active for station 15
[  130.816924] ieee80211 phy1: U iwl_restore_stations Restoring all known stations ... start.
[  130.816926] ieee80211 phy1: U iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[  130.816928] ieee80211 phy1: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[  130.816930] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  130.816932] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  130.816935] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0420, 96 bytes at 32[0]:4
[  130.817009] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  130.817681] ieee80211 phy1: U iwl_process_add_sta_resp Processing response for adding station 15
[  130.817683] ieee80211 phy1: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  130.817685] ieee80211 phy1: U iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[  130.817687] ieee80211 phy1: U iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[  130.817689] ieee80211 phy1: U iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[  130.817692] ieee80211 phy1: U is_lq_table_valid Channel 1 is not an HT channel
[  130.817694] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[  130.817696] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.817698] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0421, 92 bytes at 33[1]:4
[  130.817761] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  130.817985] ieee80211 phy1: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[  130.817987] ieee80211 phy1: U iwl_restore_stations Restoring all known stations .... complete.
[  130.817989] ieee80211 phy1: U iwl_print_rx_config_cmd RX CONFIG:
[  130.817991] iwl data: 00000000: 00 21 5d b3 d0 88 00 00 00 00 00 00 00 00 00 00  .!].............
[  130.817993] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 06 24 15 03 00 00  ...........$....
[  130.817995] iwl data: 00000020: 05 80 00 00 44 00 00 00 01 00 ff ff ff 00 00 00  ....D...........
[  130.817996] iwl data: 00000030: 00 00                                            ..
[  130.817998] ieee80211 phy1: U iwl_print_rx_config_cmd u16 channel: 0x1
[  130.818011] ieee80211 phy1: U iwl_print_rx_config_cmd u32 flags: 0x00008005
[  130.818013] ieee80211 phy1: U iwl_print_rx_config_cmd u32 filter_flags: 0x00000044
[  130.818015] ieee80211 phy1: U iwl_print_rx_config_cmd u8 dev_type: 0x3
[  130.818017] ieee80211 phy1: U iwl_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
[  130.818019] ieee80211 phy1: U iwl_print_rx_config_cmd u8 cck_basic_rates: 0x03
[  130.818020] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] node_addr: 00:21:5d:b3:d0:88
[  130.818022] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
[  130.818024] ieee80211 phy1: U iwl_print_rx_config_cmd u16 assoc_id: 0x0
[  130.818027] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x0422, 8 bytes at 34[2]:4
[  130.818032] ieee80211 phy1: U iwl_bg_scan_completed SCAN complete scan
[  130.818034] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x0423, 8 bytes at 35[3]:4
[  130.818039] ieee80211 phy1: U iwl_mac_hw_scan enter
[  130.818040] ieee80211 phy1: U iwl_scan_initiate Starting scan...
[  130.818043] ieee80211 phy1: U iwlagn_request_scan Kicking off active scan
[  130.818046] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=36 prob=0x2 [PASSIVE 110]
[  130.818048] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=40 prob=0x2 [PASSIVE 110]
[  130.818050] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=44 prob=0x2 [PASSIVE 110]
[  130.818053] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=48 prob=0x2 [PASSIVE 110]
[  130.818055] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=52 prob=0x2 [PASSIVE 110]
[  130.818057] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=56 prob=0x2 [PASSIVE 110]
[  130.818059] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=60 prob=0x2 [PASSIVE 110]
[  130.818061] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=64 prob=0x2 [PASSIVE 110]
[  130.818063] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=100 prob=0x2 [PASSIVE 110]
[  130.818066] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=104 prob=0x2 [PASSIVE 110]
[  130.818068] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=108 prob=0x2 [PASSIVE 110]
[  130.818070] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=112 prob=0x2 [PASSIVE 110]
[  130.818072] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=116 prob=0x2 [PASSIVE 110]
[  130.818074] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=120 prob=0x2 [PASSIVE 110]
[  130.818076] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=124 prob=0x2 [PASSIVE 110]
[  130.818079] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=128 prob=0x2 [PASSIVE 110]
[  130.818081] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=132 prob=0x2 [PASSIVE 110]
[  130.818083] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=136 prob=0x2 [PASSIVE 110]
[  130.818085] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=140 prob=0x2 [PASSIVE 110]
[  130.818088] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=149 prob=0x2 [PASSIVE 110]
[  130.818090] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=153 prob=0x2 [PASSIVE 110]
[  130.818092] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=157 prob=0x2 [PASSIVE 110]
[  130.818094] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=161 prob=0x2 [PASSIVE 110]
[  130.818096] ieee80211 phy1: U iwl_get_channels_for_scan Scanning ch=165 prob=0x2 [PASSIVE 110]
[  130.818098] ieee80211 phy1: U iwl_get_channels_for_scan total channels to scan 24
[  130.818100] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_SCAN_CMD
[  130.818101] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
[  130.818105] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4424, 1120 bytes at 36[32]:4
[  130.818124] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)
[  130.818202] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)
[  130.819503] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
[  130.819509] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 36 [802.11a] (TSF: 0x00000000:00000A6F) - 1 (beacon timer 99729)
[  130.819525] ieee80211 phy1: U iwl_mac_hw_scan leave
[  130.932199] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 36 [802.11a] (TSF: 0x00000000:0001C29B) - 0 elapsed=112684 usec
[  130.933397] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 40 [802.11a] (TSF: 0x00000000:0001C74A) - 1 (beacon timer 4282550)
[  131.046083] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 40 [802.11a] (TSF: 0x00000000:00037F79) - 0 elapsed=112687 usec
[  131.047281] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 44 [802.11a] (TSF: 0x00000000:00038428) - 1 (beacon timer 8465368)
[  131.159998] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 44 [802.11a] (TSF: 0x00000000:00053C6C) - 0 elapsed=112708 usec
[  131.161201] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 48 [802.11a] (TSF: 0x00000000:0005411C) - 1 (beacon timer 12648164)
[  131.273899] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 48 [802.11a] (TSF: 0x00000000:0006F95F) - 0 elapsed=112707 usec
[  131.275107] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 52 [802.11a] (TSF: 0x00000000:0006FE12) - 1 (beacon timer 16830958)
[  131.387811] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 52 [802.11a] (TSF: 0x00000000:0008B656) - 0 elapsed=112708 usec
[  131.389024] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 56 [802.11a] (TSF: 0x00000000:0008BB0A) - 1 (beacon timer 21013750)
[  131.501732] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 56 [802.11a] (TSF: 0x00000000:000A734D) - 0 elapsed=112707 usec
[  131.502936] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 60 [802.11a] (TSF: 0x00000000:000A7802) - 1 (beacon timer 25196542)
[  131.615649] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 60 [802.11a] (TSF: 0x00000000:000C3040) - 0 elapsed=112702 usec
[  131.616847] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 64 [802.11a] (TSF: 0x00000000:000C34F4) - 1 (beacon timer 29379340)
[  131.729550] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 64 [802.11a] (TSF: 0x00000000:000DED34) - 0 elapsed=112704 usec
[  131.730751] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 100 [802.11a] (TSF: 0x00000000:000DF1E6) - 1 (beacon timer 33562138)
[  131.843454] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 100 [802.11a] (TSF: 0x00000000:000FAA2D) - 0 elapsed=112711 usec
[  131.844657] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 104 [802.11a] (TSF: 0x00000000:000FAED9) - 1 (beacon timer 42041639)
[  131.957366] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 104 [802.11a] (TSF: 0x00000000:00116722) - 0 elapsed=112713 usec
[  131.958566] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 108 [802.11a] (TSF: 0x00000000:00116BD2) - 1 (beacon timer 46224430)
[  132.071268] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 108 [802.11a] (TSF: 0x00000000:00132407) - 0 elapsed=112693 usec
[  132.072465] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 112 [802.11a] (TSF: 0x00000000:001328B7) - 1 (beacon timer 50407241)
[  132.185157] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 112 [802.11a] (TSF: 0x00000000:0014E0EC) - 0 elapsed=112693 usec
[  132.186357] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 116 [802.11a] (TSF: 0x00000000:0014E59E) - 1 (beacon timer 54590050)
[  132.299071] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 116 [802.11a] (TSF: 0x00000000:00169DE5) - 0 elapsed=112711 usec
[  132.300276] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 120 [802.11a] (TSF: 0x00000000:0016A296) - 1 (beacon timer 58772842)
[  132.412967] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 120 [802.11a] (TSF: 0x00000000:00185ACB) - 0 elapsed=112693 usec
[  132.414171] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 124 [802.11a] (TSF: 0x00000000:00185F7B) - 1 (beacon timer 62955653)
[  132.526866] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 124 [802.11a] (TSF: 0x00000000:001A17B1) - 0 elapsed=112694 usec
[  132.528063] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 128 [802.11a] (TSF: 0x00000000:001A1C62) - 1 (beacon timer 67138462)
[  132.640758] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 128 [802.11a] (TSF: 0x00000000:001BD498) - 0 elapsed=112694 usec
[  132.641967] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 132 [802.11a] (TSF: 0x00000000:001BD94D) - 1 (beacon timer 71321267)
[  132.754681] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 132 [802.11a] (TSF: 0x00000000:001D9193) - 0 elapsed=112710 usec
[  132.755887] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 136 [802.11a] (TSF: 0x00000000:001D9648) - 1 (beacon timer 75504056)
[  132.868588] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 136 [802.11a] (TSF: 0x00000000:001F4E8E) - 0 elapsed=112710 usec
[  132.869789] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 140 [802.11a] (TSF: 0x00000000:001F5340) - 1 (beacon timer 83983552)
[  132.982494] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 140 [802.11a] (TSF: 0x00000000:00210B75) - 0 elapsed=112693 usec
[  132.983701] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 149 [802.11a] (TSF: 0x00000000:00211027) - 1 (beacon timer 88166361)
[  133.096383] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 149 [802.11a] (TSF: 0x00000000:0022C85C) - 0 elapsed=112693 usec
[  133.097585] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 153 [802.11a] (TSF: 0x00000000:0022CD0E) - 1 (beacon timer 92349170)
[  133.210277] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 153 [802.11a] (TSF: 0x00000000:00248543) - 0 elapsed=112693 usec
[  133.211488] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 157 [802.11a] (TSF: 0x00000000:002489F8) - 1 (beacon timer 96531976)
[  133.324202] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 157 [802.11a] (TSF: 0x00000000:0026423F) - 0 elapsed=112711 usec
[  133.325400] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 161 [802.11a] (TSF: 0x00000000:002646F5) - 1 (beacon timer 100714763)
[  133.438119] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 161 [802.11a] (TSF: 0x00000000:0027FF3B) - 0 elapsed=112710 usec
[  133.439322] ieee80211 phy1: I iwl_rx_scan_start_notif Scan start: 165 [802.11a] (TSF: 0x00000000:002803F1) - 1 (beacon timer 104897551)
[  133.552039] ieee80211 phy1: I iwl_rx_scan_results_notif Scan ch.res: 165 [802.11a] (TSF: 0x00000000:0029BC37) - 0 elapsed=112710 usec
[  133.553247] ieee80211 phy1: I iwl_rx_scan_complete_notif Scan complete: 24 channels (TSF 0x0029C0F2:00000000) - 1
[  133.553253] ieee80211 phy1: I iwl_rx_scan_complete_notif Scan on 5.2GHz took 2735ms
[  133.553256] ieee80211 phy1: I iwl_rx_scan_complete_notif Setting scan to off
[  133.553272] ieee80211 phy1: U iwl_bg_scan_completed SCAN complete scan
[  133.553280] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x0425, 8 bytes at 37[5]:4
[  133.553292] ieee80211 phy1: U iwl_mac_config enter to channel 1 changed 0x40
[  133.553296] ieee80211 phy1: U iwl_set_rxon_chain rx_chain=0x2406 active=2 idle=1
[  133.553302] ieee80211 phy1: U iwl_mac_config Not re-sending same RXON configuration.
[  133.553305] ieee80211 phy1: U iwl_mac_config leave
[  133.553308] phy1: device now idle
[  133.553311] ieee80211 phy1: U iwl_mac_flush enter
[  133.553314] ieee80211 phy1: U iwl_mac_flush wait transmit/flush all frames
[  133.553318] ieee80211 phy1: U iwl_mac_flush leave
[  133.553321] ieee80211 phy1: U iwl_mac_config enter to channel 1 changed 0x100
[  133.553325] ieee80211 phy1: U iwl_power_sleep_cam_cmd Sleep command for CAM
[  133.553328] ieee80211 phy1: U iwl_mac_config Not re-sending same RXON configuration.
[  133.553331] ieee80211 phy1: U iwl_mac_config leave
[  133.553390] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)
[  133.577022] ieee80211 phy1: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0426, 12 bytes at 38[6]:4
[  133.577045] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  193.039097] ieee80211 phy1: U iwl_configure_filter Enter: changed: 0x10, total: 0x80000000
[  193.039104] ieee80211 phy1: U iwl_commit_rxon Sending RXON
[  193.039104] * without RXON_FILTER_ASSOC_MSK
[  193.039105] * channel = 1
[  193.039105] * bssid = 00:00:00:00:00:00
[  193.039108] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_RXON
[  193.039110] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[  193.039114] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0427, 54 bytes at 39[7]:4
[  193.039277] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[  193.039286] ieee80211 phy1: U iwl_commit_rxon Return from !new_assoc RXON.
[  193.039289] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode stations in driver
[  193.039291] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode active for station 15
[  193.039294] ieee80211 phy1: I iwl_tt_handler Queueing thermal throttling work.
[  193.039303] ieee80211 phy1: U iwl_restore_stations Restoring all known stations ... start.
[  193.039305] ieee80211 phy1: U iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[  193.039308] ieee80211 phy1: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[  193.039310] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  193.039312] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  193.039315] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0428, 96 bytes at 40[8]:4
[  193.039371] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  193.039377] ieee80211 phy1: U iwl_process_add_sta_resp Processing response for adding station 15
[  193.039380] ieee80211 phy1: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  193.039382] ieee80211 phy1: U iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[  193.039384] ieee80211 phy1: U iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[  193.039386] ieee80211 phy1: U iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[  193.039389] ieee80211 phy1: U is_lq_table_valid Channel 1 is not an HT channel
[  193.039391] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[  193.039393] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  193.039396] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0429, 92 bytes at 41[9]:4
[  193.039432] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  193.039448] ieee80211 phy1: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[  193.039450] ieee80211 phy1: U iwl_restore_stations Restoring all known stations .... complete.
[  193.039453] ieee80211 phy1: U iwl_print_rx_config_cmd RX CONFIG:
[  193.039455] iwl data: 00000000: 00 21 5d b3 d0 88 00 00 00 00 00 00 00 00 00 00  .!].............
[  193.039457] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 06 24 15 03 00 00  ...........$....
[  193.039459] iwl data: 00000020: 05 80 00 00 04 00 00 00 01 00 ff ff ff 00 00 00  ................
[  193.039460] iwl data: 00000030: 00 00                                            ..
[  193.039462] ieee80211 phy1: U iwl_print_rx_config_cmd u16 channel: 0x1
[  193.039464] ieee80211 phy1: U iwl_print_rx_config_cmd u32 flags: 0x00008005
[  193.039466] ieee80211 phy1: U iwl_print_rx_config_cmd u32 filter_flags: 0x00000004
[  193.039468] ieee80211 phy1: U iwl_print_rx_config_cmd u8 dev_type: 0x3
[  193.039469] ieee80211 phy1: U iwl_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
[  193.039471] ieee80211 phy1: U iwl_print_rx_config_cmd u8 cck_basic_rates: 0x03
[  193.039473] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] node_addr: 00:21:5d:b3:d0:88
[  193.039475] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
[  193.039476] ieee80211 phy1: U iwl_print_rx_config_cmd u16 assoc_id: 0x0
[  193.039481] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x042A, 8 bytes at 42[10]:4
[  193.039486] ieee80211 phy1: U iwl_legacy_tt_handler Temperature increase 14 degree Celsius
[  193.039581] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)
[  198.923638] ieee80211 phy1: U iwl_configure_filter Enter: changed: 0x0, total: 0x80000000
[  198.923646] ieee80211 phy1: U iwl_commit_rxon Sending RXON
[  198.923646] * without RXON_FILTER_ASSOC_MSK
[  198.923647] * channel = 1
[  198.923648] * bssid = 00:00:00:00:00:00
[  198.923651] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_RXON
[  198.923652] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_RXON
[  198.923656] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x042B, 54 bytes at 43[11]:4
[  198.923819] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_RXON
[  198.923825] ieee80211 phy1: U iwl_commit_rxon Return from !new_assoc RXON.
[  198.923827] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode stations in driver
[  198.923829] ieee80211 phy1: U iwl_clear_ucode_stations Clearing ucode active for station 15
[  198.923831] ieee80211 phy1: U iwl_restore_stations Restoring all known stations ... start.
[  198.923834] ieee80211 phy1: U iwl_restore_stations Restoring sta ff:ff:ff:ff:ff:ff
[  198.923836] ieee80211 phy1: U iwl_send_add_sta Adding sta 15 (ff:ff:ff:ff:ff:ff) synchronously
[  198.923839] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  198.923840] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  198.923843] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x042C, 96 bytes at 44[12]:4
[  198.923914] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  198.923919] ieee80211 phy1: U iwl_process_add_sta_resp Processing response for adding station 15
[  198.923921] ieee80211 phy1: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  198.923923] ieee80211 phy1: U iwl_sta_ucode_activate Added STA id 15 addr ff:ff:ff:ff:ff:ff to uCode
[  198.923925] ieee80211 phy1: U iwl_process_add_sta_resp Added station id 15 addr ff:ff:ff:ff:ff:ff
[  198.923928] ieee80211 phy1: U iwl_process_add_sta_resp Added station according to cmd buffer ff:ff:ff:ff:ff:ff
[  198.923931] ieee80211 phy1: U is_lq_table_valid Channel 1 is not an HT channel
[  198.923933] ieee80211 phy1: U iwl_send_cmd_sync Attempting to send sync command REPLY_TX_LINK_QUALITY_CMD
[  198.923935] ieee80211 phy1: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  198.923938] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x042D, 92 bytes at 45[13]:4
[  198.923974] ieee80211 phy1: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_TX_LINK_QUALITY_CMD
[  198.923978] ieee80211 phy1: U iwl_send_lq_cmd init LQ command complete, clearing sta addition status for sta 15
[  198.923980] ieee80211 phy1: U iwl_restore_stations Restoring all known stations .... complete.
[  198.923983] ieee80211 phy1: U iwl_print_rx_config_cmd RX CONFIG:
[  198.923985] iwl data: 00000000: 00 21 5d b3 d0 88 00 00 00 00 00 00 00 00 00 00  .!].............
[  198.923987] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 06 24 15 03 00 00  ...........$....
[  198.923989] iwl data: 00000020: 05 80 00 00 04 00 00 00 01 00 ff ff ff 00 00 00  ................
[  198.923991] iwl data: 00000030: 00 00                                            ..
[  198.923993] ieee80211 phy1: U iwl_print_rx_config_cmd u16 channel: 0x1
[  198.923995] ieee80211 phy1: U iwl_print_rx_config_cmd u32 flags: 0x00008005
[  198.923997] ieee80211 phy1: U iwl_print_rx_config_cmd u32 filter_flags: 0x00000004
[  198.923998] ieee80211 phy1: U iwl_print_rx_config_cmd u8 dev_type: 0x3
[  198.924011] ieee80211 phy1: U iwl_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
[  198.924013] ieee80211 phy1: U iwl_print_rx_config_cmd u8 cck_basic_rates: 0x03
[  198.924015] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] node_addr: 00:21:5d:b3:d0:88
[  198.924017] ieee80211 phy1: U iwl_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
[  198.924018] ieee80211 phy1: U iwl_print_rx_config_cmd u16 assoc_id: 0x0
[  198.924023] ieee80211 phy1: U iwl_enqueue_hcmd Sending command REPLY_TX_POWER_DBM_CMD (#95), seq: 0x042E, 8 bytes at 46[14]:4
[  198.924122] ieee80211 phy1: I iwl_generic_cmd_callback back from REPLY_TX_POWER_DBM_CMD (0x00000000)

--EeQfGwPcQSOJBaQU--
