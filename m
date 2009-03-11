Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:37181 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbZCKDlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 23:41:31 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2261474qwi.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 20:41:28 -0700 (PDT)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1236661466.15923.53.camel@rc-desk>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0903011937p6538adbfpc0dab859a6742394@mail.gmail.com>
	 <1236141120.12734.2.camel@rainbow> <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk> <1236312734.19328.37.camel@rainbow>
	 <1236317982.12430.9.camel@rc-desk>  <1236649234.6685.9.camel@rainbow>
	 <1236661466.15923.53.camel@rc-desk>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 23:40:05 -0400
Message-Id: <1236742805.6267.9.camel@rainbow> (sfid-20090311_044152_048315_E24196E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> You log below has a new error (similar to what you note in your next
> email). "Unsupported interface type 515". This is very strange and
> really looks like some corruption as this value is initialized with a
> macro during probe. Could you enable mac and info debugging also (add
> 0x3 to your current debug flags)? This code has also changed a bit since
> commit bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d. 
> 
> You can also put a dump_stack() in iwl3945_connection_init_rx_config to
> see where the call comes from and then trace the value of mode to see
> where it is set to 515 ... it is supposed to be 2
> (NL80211_IFTYPE_STATION).

See logs below.  I ran with debug=0x40003.  This is on commit
"ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f iwl3945: sync tx queue data
structure with iwlagn" with my patches to make it somewhat usable.

> I am finding it hard to keep track of things as what works and what does
> not work appears to shift. I did install a 64bit system in the hopes of
> reproducing your issue but could not with a basic open connect. How do
> you connect to the AP? Please provide details that you think will enable
> me to reproduce.

The problem is that as I try older commits to find which one introduced
the original error, I find other problems that need to be solved.
Hopefully I have finally tracked down the commit,
"ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f iwl3945: sync tx queue data
structure with iwlagn", that introduced the Microcode SW errors.

Does the latest wireless-testing on a x86-64 kernel work with iwl3945
for you?

Thanks,

Jason

Mar 10 23:26:28 rainbow kernel: [  239.558534] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
Mar 10 23:26:28 rainbow kernel: [  239.558541] iwl3945: Copyright(c) 2003-2008 Intel Corporation
Mar 10 23:26:28 rainbow kernel: [  239.558747] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Mar 10 23:26:28 rainbow kernel: [  239.558766] iwl3945 0000:03:00.0: setting latency timer to 64
Mar 10 23:26:28 rainbow kernel: [  239.558920] ieee80211 phy3: U iwl3945_pci_probe pci_resource_len = 0x00001000
Mar 10 23:26:28 rainbow kernel: [  239.558930] ieee80211 phy3: U iwl3945_pci_probe pci_resource_base = ffffc200053a8000
Mar 10 23:26:28 rainbow kernel: [  239.604392] ieee80211 phy3: U iwl3945_pci_probe MAC address: 00:1f:3c:20:a1:6e
Mar 10 23:26:28 rainbow kernel: [  239.604412] ieee80211 phy3: U iwl3945_init_channel_map Initializing regulatory info from EEPROM
Mar 10 23:26:28 rainbow kernel: [  239.604417] ieee80211 phy3: U iwl3945_init_channel_map Parsing data for 56 channels.
Mar 10 23:26:28 rainbow kernel: [  239.604562] ieee80211 phy3: U iwl3945_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604573] ieee80211 phy3: U iwl3945_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604580] ieee80211 phy3: U iwl3945_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604587] ieee80211 phy3: U iwl3945_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604595] ieee80211 phy3: U iwl3945_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604602] ieee80211 phy3: U iwl3945_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604609] ieee80211 phy3: U iwl3945_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604617] ieee80211 phy3: U iwl3945_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604624] ieee80211 phy3: U iwl3945_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604632] ieee80211 phy3: U iwl3945_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604639] ieee80211 phy3: U iwl3945_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar 10 23:26:28 rainbow kernel: [  239.604645] ieee80211 phy3: U iwl3945_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604651] ieee80211 phy3: U iwl3945_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604656] ieee80211 phy3: U iwl3945_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604661] ieee80211 phy3: U iwl3945_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604667] ieee80211 phy3: U iwl3945_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604672] ieee80211 phy3: U iwl3945_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604677] ieee80211 phy3: U iwl3945_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604682] ieee80211 phy3: U iwl3945_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604687] ieee80211 phy3: U iwl3945_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604692] ieee80211 phy3: U iwl3945_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604698] ieee80211 phy3: U iwl3945_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604703] ieee80211 phy3: U iwl3945_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604708] ieee80211 phy3: U iwl3945_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604713] ieee80211 phy3: U iwl3945_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604718] ieee80211 phy3: U iwl3945_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604723] ieee80211 phy3: U iwl3945_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604728] ieee80211 phy3: U iwl3945_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604735] ieee80211 phy3: U iwl3945_init_channel_map Ch. 36 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604741] ieee80211 phy3: U iwl3945_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604748] ieee80211 phy3: U iwl3945_init_channel_map Ch. 40 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604754] ieee80211 phy3: U iwl3945_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604760] ieee80211 phy3: U iwl3945_init_channel_map Ch. 44 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604766] ieee80211 phy3: U iwl3945_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604772] ieee80211 phy3: U iwl3945_init_channel_map Ch. 48 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604779] ieee80211 phy3: U iwl3945_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604787] ieee80211 phy3: U iwl3945_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604794] ieee80211 phy3: U iwl3945_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604801] ieee80211 phy3: U iwl3945_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604807] ieee80211 phy3: U iwl3945_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604813] ieee80211 phy3: U iwl3945_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604818] ieee80211 phy3: U iwl3945_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604823] ieee80211 phy3: U iwl3945_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604828] ieee80211 phy3: U iwl3945_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604833] ieee80211 phy3: U iwl3945_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604838] ieee80211 phy3: U iwl3945_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604844] ieee80211 phy3: U iwl3945_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604849] ieee80211 phy3: U iwl3945_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604854] ieee80211 phy3: U iwl3945_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604859] ieee80211 phy3: U iwl3945_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604864] ieee80211 phy3: U iwl3945_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
Mar 10 23:26:28 rainbow kernel: [  239.604870] ieee80211 phy3: U iwl3945_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604877] ieee80211 phy3: U iwl3945_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604884] ieee80211 phy3: U iwl3945_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604891] ieee80211 phy3: U iwl3945_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604898] ieee80211 phy3: U iwl3945_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 10 23:26:28 rainbow kernel: [  239.604911] ieee80211 phy3: U iwl3945_hw_reg_txpower_get_temperature Temperature: 260
Mar 10 23:26:28 rainbow kernel: [  239.604942] ieee80211 phy3: U iwl3945_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.604948] ieee80211 phy3: U iwl3945_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.604954] ieee80211 phy3: U iwl3945_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.604959] ieee80211 phy3: U iwl3945_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.604965] ieee80211 phy3: U iwl3945_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.604970] ieee80211 phy3: U iwl3945_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.604976] ieee80211 phy3: U iwl3945_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.604982] ieee80211 phy3: U iwl3945_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.604987] ieee80211 phy3: U iwl3945_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.604993] ieee80211 phy3: U iwl3945_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.605024] ieee80211 phy3: U iwl3945_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=00
Mar 10 23:26:28 rainbow kernel: [  239.605030] ieee80211 phy3: U iwl3945_init_geos Channel 36 Freq=5180[5.2GHz] valid flag=06
Mar 10 23:26:28 rainbow kernel: [  239.605036] ieee80211 phy3: U iwl3945_init_geos Channel 40 Freq=5200[5.2GHz] valid flag=06
Mar 10 23:26:28 rainbow kernel: [  239.605042] ieee80211 phy3: U iwl3945_init_geos Channel 44 Freq=5220[5.2GHz] valid flag=06
Mar 10 23:26:28 rainbow kernel: [  239.605048] ieee80211 phy3: U iwl3945_init_geos Channel 48 Freq=5240[5.2GHz] valid flag=06
Mar 10 23:26:28 rainbow kernel: [  239.605054] ieee80211 phy3: U iwl3945_init_geos Channel 52 Freq=5260[5.2GHz] valid flag=0E
Mar 10 23:26:28 rainbow kernel: [  239.605060] ieee80211 phy3: U iwl3945_init_geos Channel 56 Freq=5280[5.2GHz] valid flag=0E
Mar 10 23:26:28 rainbow kernel: [  239.605066] ieee80211 phy3: U iwl3945_init_geos Channel 60 Freq=5300[5.2GHz] valid flag=0E
Mar 10 23:26:28 rainbow kernel: [  239.605072] ieee80211 phy3: U iwl3945_init_geos Channel 64 Freq=5320[5.2GHz] valid flag=0E
Mar 10 23:26:28 rainbow kernel: [  239.605079] ieee80211 phy3: U iwl3945_init_geos Channel 149 Freq=5745[5.2GHz] valid flag=06
Mar 10 23:26:28 rainbow kernel: [  239.605085] ieee80211 phy3: U iwl3945_init_geos Channel 153 Freq=5765[5.2GHz] valid flag=06
Mar 10 23:26:28 rainbow kernel: [  239.605091] ieee80211 phy3: U iwl3945_init_geos Channel 157 Freq=5785[5.2GHz] valid flag=06
Mar 10 23:26:28 rainbow kernel: [  239.605097] ieee80211 phy3: U iwl3945_init_geos Channel 161 Freq=5805[5.2GHz] valid flag=06
Mar 10 23:26:28 rainbow kernel: [  239.605103] ieee80211 phy3: U iwl3945_init_geos Channel 165 Freq=5825[5.2GHz] valid flag=06
Mar 10 23:26:28 rainbow kernel: [  239.605109] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
Mar 10 23:26:28 rainbow kernel: [  239.605115] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
Mar 10 23:26:28 rainbow kernel: [  239.605163] ieee80211 phy3: U iwl3945_set_rxon_channel Staging channel set to 6 [0]
Mar 10 23:26:28 rainbow kernel: [  239.640332] phy3: Selected rate control algorithm 'iwl-3945-rs'
Mar 10 23:26:32 rainbow kernel: [  243.686817] ieee80211 phy3: U iwl3945_mac_start enter
Mar 10 23:26:32 rainbow kernel: [  243.686851] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Mar 10 23:26:32 rainbow kernel: [  243.687228] iwl3945 0000:03:00.0: irq 2295 for MSI/MSI-X
Mar 10 23:26:32 rainbow kernel: [  243.687350] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
Mar 10 23:26:32 rainbow kernel: [  243.693847] ieee80211 phy3: U iwl3945_read_ucode Got firmware 'iwlwifi-3945-2.ucode' file (149816 bytes) from disk
Mar 10 23:26:32 rainbow kernel: [  243.693858] iwl3945 0000:03:00.0: loaded firmware version 15.28.2.8
Mar 10 23:26:32 rainbow kernel: [  243.693864] ieee80211 phy3: U iwl3945_read_ucode f/w package hdr ucode version raw = 0xf1c0208
Mar 10 23:26:32 rainbow kernel: [  243.693869] ieee80211 phy3: U iwl3945_read_ucode f/w package hdr runtime inst size = 80684
Mar 10 23:26:32 rainbow kernel: [  243.693874] ieee80211 phy3: U iwl3945_read_ucode f/w package hdr runtime data size = 32768
Mar 10 23:26:32 rainbow kernel: [  243.693879] ieee80211 phy3: U iwl3945_read_ucode f/w package hdr init inst size = 2672
Mar 10 23:26:32 rainbow kernel: [  243.693883] ieee80211 phy3: U iwl3945_read_ucode f/w package hdr init data size = 32768
Mar 10 23:26:32 rainbow kernel: [  243.693888] ieee80211 phy3: U iwl3945_read_ucode f/w package hdr boot inst size = 900
Mar 10 23:26:32 rainbow kernel: [  243.694026] ieee80211 phy3: U iwl3945_read_ucode Copying (but not loading) uCode instr len 80684
Mar 10 23:26:32 rainbow kernel: [  243.694069] ieee80211 phy3: U iwl3945_read_ucode uCode instr buf vaddr = 0xffff8800bb4a0000, paddr = 0xbb4a0000
Mar 10 23:26:32 rainbow kernel: [  243.694075] ieee80211 phy3: U iwl3945_read_ucode Copying (but not loading) uCode data len 32768
Mar 10 23:26:32 rainbow kernel: [  243.694125] ieee80211 phy3: U iwl3945_read_ucode Copying (but not loading) init instr len 2672
Mar 10 23:26:32 rainbow kernel: [  243.694132] ieee80211 phy3: U iwl3945_read_ucode Copying (but not loading) init data len 32768
Mar 10 23:26:32 rainbow kernel: [  243.694161] ieee80211 phy3: U iwl3945_read_ucode Copying (but not loading) boot instr len 900
Mar 10 23:26:32 rainbow kernel: [  243.694297] ieee80211 phy3: U iwl3945_hw_nic_init HW Revision ID = 0x2
Mar 10 23:26:32 rainbow kernel: [  243.694347] ieee80211 phy3: U iwl3945_nic_config 3945 RADIO-MM type
Mar 10 23:26:32 rainbow kernel: [  243.694358] ieee80211 phy3: U iwl3945_nic_config SKU OP mode is basic
Mar 10 23:26:32 rainbow kernel: [  243.694362] ieee80211 phy3: U iwl3945_nic_config 3945ABG revision is 0xF1
Mar 10 23:26:32 rainbow kernel: [  243.694373] ieee80211 phy3: U iwl3945_nic_config Card M type B version is 0x3
Mar 10 23:26:32 rainbow kernel: [  243.695594] ieee80211 phy3: U iwl3945_load_bsm Begin load bsm
Mar 10 23:26:32 rainbow kernel: [  243.696869] ieee80211 phy3: U iwl3945_verify_bsm Begin verify bsm
Mar 10 23:26:32 rainbow kernel: [  243.699046] ieee80211 phy3: U iwl3945_verify_bsm BSM bootstrap uCode image OK
Mar 10 23:26:32 rainbow kernel: [  243.699103] ieee80211 phy3: U iwl3945_load_bsm BSM write complete, poll 1 iterations
Mar 10 23:26:32 rainbow kernel: [  243.699120] ieee80211 phy3: U __iwl3945_up iwl3945 is coming up
Mar 10 23:26:32 rainbow kernel: [  243.699125] ieee80211 phy3: U iwl3945_mac_start Start UP work.
Mar 10 23:26:32 rainbow kernel: [  243.710600] ieee80211 phy3: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Mar 10 23:26:32 rainbow kernel: [  243.710610] ieee80211 phy3: I iwl3945_rx_reply_alive Initialization Alive received.
Mar 10 23:26:32 rainbow kernel: [  243.717224] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 10 23:26:32 rainbow kernel: [  243.717321] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 10 23:26:32 rainbow kernel: [  243.717604] ieee80211 phy3: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Mar 10 23:26:32 rainbow kernel: [  243.717609] ieee80211 phy3: U iwl3945_init_alive_start Initialization Alive received.
Mar 10 23:26:32 rainbow kernel: [  243.717657] ieee80211 phy3: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Mar 10 23:26:32 rainbow kernel: [  243.722011] ieee80211 phy3: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Mar 10 23:26:32 rainbow kernel: [  243.722020] ieee80211 phy3: I iwl3945_rx_reply_alive Runtime Alive received.
Mar 10 23:26:32 rainbow kernel: [  243.722066] ieee80211 phy3: I iwl3945_disable_events Selected uCode log events may be disabled
Mar 10 23:26:32 rainbow kernel: [  243.722071] ieee80211 phy3: I iwl3945_disable_events   by writing "1"s into disable bitmap
Mar 10 23:26:32 rainbow kernel: [  243.722077] ieee80211 phy3: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Mar 10 23:26:32 rainbow kernel: [  243.728271] ieee80211 phy3: U iwl3945_alive_start Runtime Alive received.
Mar 10 23:26:32 rainbow kernel: [  243.728282] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 10 23:26:32 rainbow kernel: [  243.728367] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 10 23:26:32 rainbow kernel: [  243.728450] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 80684
Mar 10 23:26:32 rainbow kernel: [  243.736252] ieee80211 phy3: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Mar 10 23:26:32 rainbow kernel: [  243.736288] ieee80211 phy3: U iwl3945_alive_start RFKILL status: 0x1
Mar 10 23:26:32 rainbow kernel: [  243.738052] Pid: 5986, comm: iwl3945/1 Not tainted 2.6.28-wl #57
Mar 10 23:26:32 rainbow kernel: [  243.738057] Call Trace:
Mar 10 23:26:32 rainbow kernel: [  243.738080]  [<ffffffffa052104d>] iwl3945_connection_init_rx_config+0x4d/0x1f0 [iwl3945]
Mar 10 23:26:32 rainbow kernel: [  243.738099]  [<ffffffffa052e9e6>] iwl3945_bg_alive_start+0x426/0x6f0 [iwl3945]
Mar 10 23:26:32 rainbow kernel: [  243.738116]  [<ffffffffa052e5c0>] ? iwl3945_bg_alive_start+0x0/0x6f0 [iwl3945]
Mar 10 23:26:32 rainbow kernel: [  243.738127]  [<ffffffff80254d40>] run_workqueue+0x70/0x120
Mar 10 23:26:32 rainbow kernel: [  243.738133]  [<ffffffff80254ff7>] worker_thread+0xa7/0x120
Mar 10 23:26:32 rainbow kernel: [  243.738140]  [<ffffffff80259270>] ? autoremove_wake_function+0x0/0x40
Mar 10 23:26:32 rainbow kernel: [  243.738147]  [<ffffffff80254f50>] ? worker_thread+0x0/0x120
Mar 10 23:26:32 rainbow kernel: [  243.738153]  [<ffffffff80258e39>] kthread+0x49/0x90
Mar 10 23:26:32 rainbow kernel: [  243.738161]  [<ffffffff8020d3f9>] child_rip+0xa/0x11
Mar 10 23:26:32 rainbow kernel: [  243.738167]  [<ffffffff80258df0>] ? kthread+0x0/0x90
Mar 10 23:26:32 rainbow kernel: [  243.738173]  [<ffffffff8020d3ef>] ? child_rip+0x0/0x11
Mar 10 23:26:32 rainbow kernel: [  243.738178] iwl3945 0000:03:00.0: Unsupported interface type 515
Mar 10 23:26:32 rainbow kernel: [  243.738236] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.747862] ieee80211 phy3: U iwl3945_commit_rxon Sending RXON
Mar 10 23:26:32 rainbow kernel: [  243.747865] * without RXON_FILTER_ASSOC_MSK
Mar 10 23:26:32 rainbow kernel: [  243.747867] * channel = 1
Mar 10 23:26:32 rainbow kernel: [  243.747868] * bssid = 00:00:00:00:00:00
Mar 10 23:26:32 rainbow kernel: [  243.747885] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.751048] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.754301] ieee80211 phy3: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 10 23:26:32 rainbow kernel: [  243.754322] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.756804] ieee80211 phy3: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 10 23:26:32 rainbow kernel: [  243.756832] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.761488] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.772099] ieee80211 phy3: U iwl3945_hw_reg_txpower_get_temperature Temperature: 75
Mar 10 23:26:32 rainbow kernel: [  243.772135] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.775434] Registered led device: iwl-phy3:radio
Mar 10 23:26:32 rainbow kernel: [  243.775450] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.775496] Registered led device: iwl-phy3:assoc
Mar 10 23:26:32 rainbow kernel: [  243.775530] Registered led device: iwl-phy3:RX
Mar 10 23:26:32 rainbow kernel: [  243.775562] Registered led device: iwl-phy3:TX
Mar 10 23:26:32 rainbow kernel: [  243.775567] ieee80211 phy3: U iwl3945_alive_start ALIVE processing complete.
Mar 10 23:26:32 rainbow kernel: [  243.775617] ieee80211 phy3: U iwl3945_mac_start leave
Mar 10 23:26:32 rainbow kernel: [  243.775636] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.775650] ieee80211 phy3: U iwl3945_mac_add_interface enter: type 2
Mar 10 23:26:32 rainbow kernel: [  243.775659] ieee80211 phy3: U iwl3945_mac_add_interface Set: 00:1f:3c:20:a1:6e
Mar 10 23:26:32 rainbow kernel: [  243.775673] ieee80211 phy3: U iwl3945_commit_rxon Sending RXON
Mar 10 23:26:32 rainbow kernel: [  243.775675] * without RXON_FILTER_ASSOC_MSK
Mar 10 23:26:32 rainbow kernel: [  243.775676] * channel = 1
Mar 10 23:26:32 rainbow kernel: [  243.775678] * bssid = 00:00:00:00:00:00
Mar 10 23:26:32 rainbow kernel: [  243.775693] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.778224] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.781048] ieee80211 phy3: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 10 23:26:32 rainbow kernel: [  243.784347] ieee80211 phy3: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 10 23:26:32 rainbow kernel: [  243.784370] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.787498] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.790453] ieee80211 phy3: U iwl3945_mac_add_interface leave
Mar 10 23:26:32 rainbow kernel: [  243.790462] ieee80211 phy3: U iwl3945_bss_info_changed changes = 0xE
Mar 10 23:26:32 rainbow kernel: [  243.790467] ieee80211 phy3: U iwl3945_bss_info_changed ERP_PREAMBLE 0
Mar 10 23:26:32 rainbow kernel: [  243.790472] ieee80211 phy3: U iwl3945_bss_info_changed ERP_CTS 0
Mar 10 23:26:32 rainbow kernel: [  243.804323] ieee80211 phy3: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 10 23:26:32 rainbow kernel: [  243.806268] ieee80211 phy3: U iwl3945_mac_config enter to channel 1
Mar 10 23:26:32 rainbow kernel: [  243.806285] ieee80211 phy3: U iwl3945_commit_rxon Sending RXON
Mar 10 23:26:32 rainbow kernel: [  243.806287] * without RXON_FILTER_ASSOC_MSK
Mar 10 23:26:32 rainbow kernel: [  243.806289] * channel = 1
Mar 10 23:26:32 rainbow kernel: [  243.806290] * bssid = 00:00:00:00:00:00
Mar 10 23:26:32 rainbow kernel: [  243.806351] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.817325] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.820121] ieee80211 phy3: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 10 23:26:32 rainbow kernel: [  243.820143] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.822706] ieee80211 phy3: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 10 23:26:32 rainbow kernel: [  243.826225] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  243.828886] ieee80211 phy3: U iwl3945_mac_config leave
Mar 10 23:26:32 rainbow kernel: [  243.828899] ieee80211 phy3: U iwl3945_mac_conf_tx enter
Mar 10 23:26:32 rainbow kernel: [  243.828904] ieee80211 phy3: U iwl3945_mac_conf_tx leave
Mar 10 23:26:32 rainbow kernel: [  243.828908] ieee80211 phy3: U iwl3945_mac_conf_tx enter
Mar 10 23:26:32 rainbow kernel: [  243.828912] ieee80211 phy3: U iwl3945_mac_conf_tx leave
Mar 10 23:26:32 rainbow kernel: [  243.828916] ieee80211 phy3: U iwl3945_mac_conf_tx enter
Mar 10 23:26:32 rainbow kernel: [  243.828920] ieee80211 phy3: U iwl3945_mac_conf_tx leave
Mar 10 23:26:32 rainbow kernel: [  243.828924] ieee80211 phy3: U iwl3945_mac_conf_tx enter
Mar 10 23:26:32 rainbow kernel: [  243.828928] ieee80211 phy3: U iwl3945_mac_conf_tx leave
Mar 10 23:26:32 rainbow kernel: [  243.828947] ieee80211 phy3: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 10 23:26:32 rainbow kernel: [  243.828983] ieee80211 phy3: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 10 23:26:32 rainbow kernel: [  243.830895] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar 10 23:26:32 rainbow kernel: [  243.830902] ieee80211 phy3: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 10 23:26:32 rainbow kernel: [  243.831980] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:26:32 rainbow kernel: [  243.831988] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:26:32 rainbow kernel: [  243.831999] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:26:32 rainbow kernel: [  243.832071] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:32 rainbow kernel: [  244.158535] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 328ms
Mar 10 23:26:34 rainbow kernel: [  245.637430] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1480ms
Mar 10 23:26:34 rainbow kernel: [  245.637441] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Setting scan to off
Mar 10 23:26:34 rainbow kernel: [  245.637446] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Scan took 1808ms
Mar 10 23:26:34 rainbow kernel: [  245.637495] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:26:34 rainbow kernel: [  245.637536] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:26:34 rainbow kernel: [  245.637578] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:27:22 rainbow kernel: [  293.890669] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:27:22 rainbow kernel: [  293.890681] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:27:22 rainbow kernel: [  293.890690] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:27:22 rainbow kernel: [  293.890763] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:22 rainbow kernel: [  294.271919] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 380ms
Mar 10 23:27:24 rainbow kernel: [  295.750114] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1480ms
Mar 10 23:27:24 rainbow kernel: [  295.750124] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Setting scan to off
Mar 10 23:27:24 rainbow kernel: [  295.750129] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Scan took 1860ms
Mar 10 23:27:24 rainbow kernel: [  295.750170] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:27:24 rainbow kernel: [  295.750207] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:29 rainbow kernel: [  300.751944] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:27:29 rainbow kernel: [  300.751957] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:27:29 rainbow kernel: [  300.751966] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:27:29 rainbow kernel: [  300.752041] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:29 rainbow kernel: [  301.131280] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 380ms
Mar 10 23:27:31 rainbow kernel: [  302.609296] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1480ms
Mar 10 23:27:31 rainbow kernel: [  302.609307] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Setting scan to off
Mar 10 23:27:31 rainbow kernel: [  302.609313] ieee80211 phy3: I iwl3945_rx_scan_complete_notif Scan took 1860ms
Mar 10 23:27:31 rainbow kernel: [  302.609340] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:27:31 rainbow kernel: [  302.609378] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.612092] ieee80211 phy3: U iwl3945_mac_config enter to channel 1
Mar 10 23:27:31 rainbow kernel: [  302.612103] ieee80211 phy3: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 10 23:27:31 rainbow kernel: [  302.612108] ieee80211 phy3: U iwl3945_mac_config leave
Mar 10 23:27:31 rainbow kernel: [  302.612134] ieee80211 phy3: U iwl3945_mac_config_interface bssid: 00:13:46:08:8a:6e
Mar 10 23:27:31 rainbow kernel: [  302.612144] ieee80211 phy3: U iwl3945_commit_rxon Sending RXON
Mar 10 23:27:31 rainbow kernel: [  302.612146] * without RXON_FILTER_ASSOC_MSK
Mar 10 23:27:31 rainbow kernel: [  302.612148] * channel = 1
Mar 10 23:27:31 rainbow kernel: [  302.612149] * bssid = 00:13:46:08:8a:6e
Mar 10 23:27:31 rainbow kernel: [  302.612163] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.615556] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.618187] ieee80211 phy3: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 10 23:27:31 rainbow kernel: [  302.618203] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.621061] ieee80211 phy3: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 10 23:27:31 rainbow kernel: [  302.621077] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.622250] ieee80211 phy3: U iwl3945_mac_set_key enter
Mar 10 23:27:31 rainbow kernel: [  302.623850] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.627106] ieee80211 phy3: U iwl3945_mac_config_interface leave
Mar 10 23:27:31 rainbow kernel: [  302.639394] ieee80211 phy3: U iwl3945_mac_config enter to channel 1
Mar 10 23:27:31 rainbow kernel: [  302.639406] ieee80211 phy3: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 10 23:27:31 rainbow kernel: [  302.639411] ieee80211 phy3: U iwl3945_mac_config leave
Mar 10 23:27:31 rainbow kernel: [  302.639416] ieee80211 phy3: U iwl3945_mac_conf_tx enter
Mar 10 23:27:31 rainbow kernel: [  302.639421] ieee80211 phy3: U iwl3945_mac_conf_tx leave
Mar 10 23:27:31 rainbow kernel: [  302.639424] ieee80211 phy3: U iwl3945_mac_conf_tx enter
Mar 10 23:27:31 rainbow kernel: [  302.639428] ieee80211 phy3: U iwl3945_mac_conf_tx leave
Mar 10 23:27:31 rainbow kernel: [  302.639432] ieee80211 phy3: U iwl3945_mac_conf_tx enter
Mar 10 23:27:31 rainbow kernel: [  302.639436] ieee80211 phy3: U iwl3945_mac_conf_tx leave
Mar 10 23:27:31 rainbow kernel: [  302.639439] ieee80211 phy3: U iwl3945_mac_conf_tx enter
Mar 10 23:27:31 rainbow kernel: [  302.639443] ieee80211 phy3: U iwl3945_mac_conf_tx leave
Mar 10 23:27:31 rainbow kernel: [  302.639448] ieee80211 phy3: U iwl3945_mac_reset_tsf enter
Mar 10 23:27:31 rainbow kernel: [  302.639454] ieee80211 phy3: U iwl_reset_qos set QoS to default 
Mar 10 23:27:31 rainbow kernel: [  302.639465] ieee80211 phy3: U iwl3945_commit_rxon Sending RXON
Mar 10 23:27:31 rainbow kernel: [  302.639467] * without RXON_FILTER_ASSOC_MSK
Mar 10 23:27:31 rainbow kernel: [  302.639468] * channel = 1
Mar 10 23:27:31 rainbow kernel: [  302.639469] * bssid = 00:13:46:08:8a:6e
Mar 10 23:27:31 rainbow kernel: [  302.639528] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.650189] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.652899] ieee80211 phy3: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 10 23:27:31 rainbow kernel: [  302.652913] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.656144] ieee80211 phy3: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 10 23:27:31 rainbow kernel: [  302.656162] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.659449] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.662193] ieee80211 phy3: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 10 23:27:31 rainbow kernel: [  302.662207] wlan0: authenticate with AP 00:13:46:08:8a:6e
Mar 10 23:27:31 rainbow kernel: [  302.662232] ieee80211 phy3: I iwl3945_mac_tx enter
Mar 10 23:27:31 rainbow kernel: [  302.662250] ieee80211 phy3: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.662262] ieee80211 phy3: I iwl3945_mac_tx leave
Mar 10 23:27:31 rainbow kernel: [  302.662277] ieee80211 phy3: U iwl3945_mac_set_key leave
Mar 10 23:27:31 rainbow kernel: [  302.662285] mac80211-phy3: failed to set key (0, ff:ff:ff:ff:ff:ff) to hardware (-22)
Mar 10 23:27:31 rainbow kernel: [  302.860284] wlan0: authenticate with AP 00:13:46:08:8a:6e
Mar 10 23:27:31 rainbow kernel: [  302.860316] ieee80211 phy3: I iwl3945_mac_tx enter
Mar 10 23:27:31 rainbow kernel: [  302.860363] ieee80211 phy3: I iwl3945_mac_tx leave
Mar 10 23:27:31 rainbow kernel: [  302.865213] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
Mar 10 23:27:31 rainbow kernel: [  302.865248] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
Mar 10 23:27:31 rainbow kernel: [  302.865254] iwl3945 0000:03:00.0: Status: 0x000302E4, count: 1
Mar 10 23:27:31 rainbow kernel: [  302.865258] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Mar 10 23:27:31 rainbow kernel: [  302.865332] iwl3945 0000:03:00.0: SYSASSERT     (#5) 0000207471 0x0089A 0x0025E 0x00304 0x04BC2 78
Mar 10 23:27:31 rainbow kernel: [  302.865335] 
Mar 10 23:27:31 rainbow kernel: [  302.865401] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display count 512, wraps 29
Mar 10 23:27:31 rainbow kernel: [  302.865436] iwl3945 0000:03:00.0: 0000001913^I0x00840052^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865469] iwl3945 0000:03:00.0: 0000001914^I0x00840053^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865503] iwl3945 0000:03:00.0: 0000001916^I0x007e0054^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865536] iwl3945 0000:03:00.0: 0000001917^I0x007d0055^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865568] iwl3945 0000:03:00.0: 0000001919^I0x00000056^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865602] iwl3945 0000:03:00.0: 0000001920^I0x00007050^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865635] iwl3945 0000:03:00.0: 0000001922^I0x00017051^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865667] iwl3945 0000:03:00.0: 0000001924^I0x00008204^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865700] iwl3945 0000:03:00.0: 0000001926^I0x00018205^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865733] iwl3945 0000:03:00.0: 0000001929^I0x00000001^I1101
Mar 10 23:27:31 rainbow kernel: [  302.865766] iwl3945 0000:03:00.0: 0000001930^I0x008b0063^I1102
Mar 10 23:27:31 rainbow kernel: [  302.865800] iwl3945 0000:03:00.0: 0000001932^I0x0000001d^I1104
Mar 10 23:27:31 rainbow kernel: [  302.865833] iwl3945 0000:03:00.0: 0000001934^I0x00000069^I1114
Mar 10 23:27:31 rainbow kernel: [  302.865866] iwl3945 0000:03:00.0: 0000001955^I0x0000020f^I0605
Mar 10 23:27:31 rainbow kernel: [  302.865898] iwl3945 0000:03:00.0: 0000001956^I0x0000026b^I0621
Mar 10 23:27:31 rainbow kernel: [  302.865931] iwl3945 0000:03:00.0: 0000001960^I0x00000101^I1108
Mar 10 23:27:31 rainbow kernel: [  302.865964] iwl3945 0000:03:00.0: 0000001962^I0x0000000e^I1101
Mar 10 23:27:31 rainbow kernel: [  302.865997] iwl3945 0000:03:00.0: 0000001963^I0x00680034^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866030] iwl3945 0000:03:00.0: 0000001964^I0x00670035^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866063] iwl3945 0000:03:00.0: 0000001966^I0x007e0036^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866096] iwl3945 0000:03:00.0: 0000001967^I0x007c0037^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866129] iwl3945 0000:03:00.0: 0000001969^I0x00000038^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866162] iwl3945 0000:03:00.0: 0000001970^I0x00840052^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866195] iwl3945 0000:03:00.0: 0000001972^I0x00840053^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866228] iwl3945 0000:03:00.0: 0000001973^I0x007e0054^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866262] iwl3945 0000:03:00.0: 0000001975^I0x007d0055^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866295] iwl3945 0000:03:00.0: 0000001976^I0x00000056^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866328] iwl3945 0000:03:00.0: 0000001978^I0x00007050^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866361] iwl3945 0000:03:00.0: 0000001980^I0x00017051^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866394] iwl3945 0000:03:00.0: 0000001982^I0x00008204^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866427] iwl3945 0000:03:00.0: 0000001984^I0x00018205^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866459] iwl3945 0000:03:00.0: 0000001987^I0x00000001^I1101
Mar 10 23:27:31 rainbow kernel: [  302.866493] iwl3945 0000:03:00.0: 0000001988^I0x008b0063^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866526] iwl3945 0000:03:00.0: 0000001990^I0x0000001c^I1104
Mar 10 23:27:31 rainbow kernel: [  302.866559] iwl3945 0000:03:00.0: 0000001991^I0x00000002^I1101
Mar 10 23:27:31 rainbow kernel: [  302.866592] iwl3945 0000:03:00.0: 0000001992^I0x0083903f^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866624] iwl3945 0000:03:00.0: 0000001994^I0x0001d213^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866657] iwl3945 0000:03:00.0: 0000001997^I0x00000002^I1101
Mar 10 23:27:31 rainbow kernel: [  302.866690] iwl3945 0000:03:00.0: 0000001998^I0x0003d206^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866723] iwl3945 0000:03:00.0: 0000002000^I0x0083903e^I1102
Mar 10 23:27:31 rainbow kernel: [  302.866756] iwl3945 0000:03:00.0: 0000002004^I0x00000059^I1101
Mar 10 23:27:31 rainbow kernel: [  302.866789] iwl3945 0000:03:00.0: 0000002104^I0x00000013^I1101
Mar 10 23:27:31 rainbow kernel: [  302.866822] iwl3945 0000:03:00.0: 0000002122^I0x00000004^I1107
Mar 10 23:27:31 rainbow kernel: [  302.866856] iwl3945 0000:03:00.0: 0000002690^I0x0001857f^I1110
Mar 10 23:27:31 rainbow kernel: [  302.866888] iwl3945 0000:03:00.0: 0000002701^I0xffffff51^I0454
Mar 10 23:27:31 rainbow kernel: [  302.866921] iwl3945 0000:03:00.0: 0000002702^I0x00000000^I0472
Mar 10 23:27:31 rainbow kernel: [  302.866954] iwl3945 0000:03:00.0: 0000002712^I0x00000001^I0463
Mar 10 23:27:31 rainbow kernel: [  302.866987] iwl3945 0000:03:00.0: 0000002715^I0xffffff51^I1111
Mar 10 23:27:31 rainbow kernel: [  302.867020] iwl3945 0000:03:00.0: 0000002720^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867053] iwl3945 0000:03:00.0: 0000002720^I0x0000000e^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867086] iwl3945 0000:03:00.0: 0000002725^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867119] iwl3945 0000:03:00.0: 0000002729^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867152] iwl3945 0000:03:00.0: 0000002733^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867184] iwl3945 0000:03:00.0: 0000002737^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867217] iwl3945 0000:03:00.0: 0000002742^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867251] iwl3945 0000:03:00.0: 0000002746^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867283] iwl3945 0000:03:00.0: 0000002750^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867316] iwl3945 0000:03:00.0: 0000002755^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867349] iwl3945 0000:03:00.0: 0000002759^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867382] iwl3945 0000:03:00.0: 0000002763^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867415] iwl3945 0000:03:00.0: 0000002767^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867448] iwl3945 0000:03:00.0: 0000002772^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867482] iwl3945 0000:03:00.0: 0000002776^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867515] iwl3945 0000:03:00.0: 0000002780^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867548] iwl3945 0000:03:00.0: 0000002784^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867581] iwl3945 0000:03:00.0: 0000002789^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867615] iwl3945 0000:03:00.0: 0000002793^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867648] iwl3945 0000:03:00.0: 0000002797^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867681] iwl3945 0000:03:00.0: 0000002802^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867714] iwl3945 0000:03:00.0: 0000002806^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867747] iwl3945 0000:03:00.0: 0000002810^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867780] iwl3945 0000:03:00.0: 0000002814^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867813] iwl3945 0000:03:00.0: 0000002819^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867846] iwl3945 0000:03:00.0: 0000002823^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867879] iwl3945 0000:03:00.0: 0000002827^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867912] iwl3945 0000:03:00.0: 0000002831^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867945] iwl3945 0000:03:00.0: 0000002836^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.867978] iwl3945 0000:03:00.0: 0000002840^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868011] iwl3945 0000:03:00.0: 0000002844^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868044] iwl3945 0000:03:00.0: 0000002849^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868077] iwl3945 0000:03:00.0: 0000002853^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868110] iwl3945 0000:03:00.0: 0000002857^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868143] iwl3945 0000:03:00.0: 0000002861^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868176] iwl3945 0000:03:00.0: 0000002866^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868209] iwl3945 0000:03:00.0: 0000002870^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868242] iwl3945 0000:03:00.0: 0000002874^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868274] iwl3945 0000:03:00.0: 0000002878^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868308] iwl3945 0000:03:00.0: 0000002883^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868341] iwl3945 0000:03:00.0: 0000002887^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868374] iwl3945 0000:03:00.0: 0000002891^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868406] iwl3945 0000:03:00.0: 0000002896^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868439] iwl3945 0000:03:00.0: 0000002900^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868472] iwl3945 0000:03:00.0: 0000002904^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868505] iwl3945 0000:03:00.0: 0000002908^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868538] iwl3945 0000:03:00.0: 0000002913^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868571] iwl3945 0000:03:00.0: 0000002917^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868604] iwl3945 0000:03:00.0: 0000002921^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868637] iwl3945 0000:03:00.0: 0000002926^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868670] iwl3945 0000:03:00.0: 0000002930^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868703] iwl3945 0000:03:00.0: 0000002934^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868736] iwl3945 0000:03:00.0: 0000002938^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868769] iwl3945 0000:03:00.0: 0000002943^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868802] iwl3945 0000:03:00.0: 0000002947^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868835] iwl3945 0000:03:00.0: 0000002951^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868868] iwl3945 0000:03:00.0: 0000002955^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868901] iwl3945 0000:03:00.0: 0000002960^I0x00000001^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868934] iwl3945 0000:03:00.0: 0000002961^I0x0000000f^I1106
Mar 10 23:27:31 rainbow kernel: [  302.868967] iwl3945 0000:03:00.0: 0000002962^I0x000003ec^I1105
Mar 10 23:27:31 rainbow kernel: [  302.869000] iwl3945 0000:03:00.0: 0000002966^I0x000004e8^I1115
Mar 10 23:27:31 rainbow kernel: [  302.869033] iwl3945 0000:03:00.0: 0000002970^I0x00000001^I0463
Mar 10 23:27:31 rainbow kernel: [  302.869066] iwl3945 0000:03:00.0: 0000002971^I0x00000001^I0462
Mar 10 23:27:31 rainbow kernel: [  302.869099] iwl3945 0000:03:00.0: 0000002982^I0x0000010c^I0601
Mar 10 23:27:31 rainbow kernel: [  302.869132] iwl3945 0000:03:00.0: 0000002992^I0x04250018^I0401
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003005^I0x0000010f^I0603
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003074^I0x00000180^I0604
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003076^I0x0000019c^I0610
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003077^I0x000183fc^I0610
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003078^I0x00000000^I0610
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003126^I0x00000500^I0600
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004628^I0x000001ed^I0616
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003120^I0x000183d0^I0638
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003543^I0x0000001c^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003576^I0x0000001a^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003603^I0x000000ff^I1103
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003604^I0xffff9111^I1103
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003606^I0x00000010^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003624^I0x00000011^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003637^I0x00000000^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003638^I0x00000000^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003640^I0x000001d8^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003642^I0x00000065^I1104
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003644^I0x0000000e^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003645^I0x00680034^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003646^I0x00670035^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003648^I0x007e0036^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003650^I0x007c0037^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003651^I0x00000038^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003653^I0x00840052^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003654^I0x00840053^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003656^I0x007e0054^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003657^I0x007d0055^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003659^I0x00000056^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003660^I0x00007050^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003662^I0x00017051^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003664^I0x00008204^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003666^I0x00018205^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003669^I0x00000001^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003670^I0x008b0063^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003672^I0x0000001d^I1104
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003674^I0x00000069^I1114
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003695^I0x0000020f^I0605
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003696^I0x0000026b^I0621
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003700^I0x00000101^I1108
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003702^I0x0000000e^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003703^I0x00680034^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003704^I0x00670035^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003706^I0x007e0036^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003707^I0x007c0037^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003709^I0x00000038^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003710^I0x00840052^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003712^I0x00840053^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003713^I0x007e0054^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003715^I0x007d0055^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003716^I0x00000056^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003718^I0x00007050^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003720^I0x00017051^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003722^I0x00008204^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003724^I0x00018205^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003727^I0x00000001^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003728^I0x008b0063^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003730^I0x0000001c^I1104
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003731^I0x00000002^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003732^I0x0083903f^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003734^I0x0001d213^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003737^I0x00000002^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003738^I0x0003d206^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003740^I0x0083903e^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003744^I0x00000059^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003844^I0x00000013^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000003862^I0x00000004^I1107
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004430^I0x00017eb3^I1110
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004441^I0xffffff50^I0454
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004442^I0x00000000^I0472
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004452^I0x00000001^I0463
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004455^I0xffffff50^I1111
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004460^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004460^I0x0000000e^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004465^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004469^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004473^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004477^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004482^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004486^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004490^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004495^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004499^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004503^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004507^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004512^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004516^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004520^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004524^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004529^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004533^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004537^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004542^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004546^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004550^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004554^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004559^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004563^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004567^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004571^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004576^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004580^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004584^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004589^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004593^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004597^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004601^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004606^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004610^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004614^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004618^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004623^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004627^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004631^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004636^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004640^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004644^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004648^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004653^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004657^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004661^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004666^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004670^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004674^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004678^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004683^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004687^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004691^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004695^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004700^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004704^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004708^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004713^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004717^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004721^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004725^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004730^I0x00000001^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004730^I0x0000000f^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004732^I0x0000040a^I1105
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004735^I0x000004e8^I1115
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004739^I0x00000001^I0463
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004740^I0x00000001^I0462
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004752^I0x0000010c^I0601
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004762^I0x04260047^I0401
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004772^I0x0000010f^I0603
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004844^I0x00000180^I0604
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004846^I0x0000019c^I0610
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004847^I0x00017d12^I0610
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004848^I0x02000000^I0610
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004896^I0x00000500^I0600
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006397^I0x000001ed^I0616
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004890^I0x00017ce6^I0638
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004913^I0x0000001c^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004946^I0x0000001a^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004973^I0x000000ff^I1103
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004974^I0xffff9111^I1103
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004976^I0x00000010^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000004994^I0x00000011^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005007^I0x00000000^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005008^I0x00000000^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005010^I0x000001d8^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005012^I0x00000065^I1104
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005014^I0x0000000e^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005015^I0x00680034^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005016^I0x00670035^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005018^I0x007e0036^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005020^I0x007c0037^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005021^I0x00000038^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005023^I0x00840052^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005024^I0x00840053^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005026^I0x007e0054^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005027^I0x007d0055^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005029^I0x00000056^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005030^I0x00007050^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005032^I0x00017051^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005034^I0x00008204^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005036^I0x00018205^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005039^I0x00000001^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005040^I0x008b0063^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005042^I0x0000001d^I1104
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005044^I0x00000069^I1114
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005065^I0x0000020f^I0605
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005066^I0x0000026b^I0621
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005070^I0x00000101^I1108
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005072^I0x0000000e^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005073^I0x00680034^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005074^I0x00670035^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005076^I0x007e0036^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005077^I0x007c0037^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005079^I0x00000038^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005080^I0x00840052^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005082^I0x00840053^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005083^I0x007e0054^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005085^I0x007d0055^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005086^I0x00000056^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005088^I0x00007050^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005090^I0x00017051^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005092^I0x00008204^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005094^I0x00018205^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005097^I0x00000001^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005098^I0x008b0063^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005100^I0x0000001c^I1104
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005101^I0x00000002^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005102^I0x0083903f^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005104^I0x0001d213^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005107^I0x00000002^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005108^I0x0003d206^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005110^I0x0083903e^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005114^I0x00000059^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005214^I0x00000013^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005232^I0x00000004^I1107
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005800^I0x00017959^I1110
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005811^I0xffffff51^I0454
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005812^I0x00000000^I0472
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005822^I0x00000001^I0463
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005825^I0xffffff51^I1111
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005830^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005830^I0x0000000e^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005835^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005839^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005843^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005847^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005852^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005856^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005860^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005865^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005869^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005873^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005877^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005882^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005886^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005890^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005894^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005899^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005903^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005907^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005912^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005916^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005920^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005924^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005929^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005933^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005937^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005941^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005946^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005950^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005954^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005959^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005963^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005967^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005971^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005976^I0x00000001^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005976^I0x0000000f^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005978^I0x0000038e^I1105
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005981^I0x000004e8^I1115
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005985^I0x00000001^I0463
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005986^I0x00000001^I0462
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000005998^I0x0000010c^I0601
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006008^I0x04270047^I0401
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006018^I0x0000010f^I0603
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006090^I0x00000180^I0604
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006092^I0x0000019c^I0610
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006093^I0x00017834^I0610
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006094^I0x00000000^I0610
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006142^I0x00000500^I0600
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007643^I0x000001ed^I0616
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006136^I0x00017808^I0638
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006159^I0x0000001c^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006192^I0x0000001a^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006219^I0x000000ff^I1103
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006220^I0xffff9111^I1103
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006222^I0x00000010^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006240^I0x00000011^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006253^I0x00000000^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006254^I0x00000000^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006256^I0x000001d8^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006258^I0x00000065^I1104
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006260^I0x0000000e^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006261^I0x00680034^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006262^I0x00670035^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006264^I0x007e0036^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006266^I0x007c0037^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006267^I0x00000038^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006269^I0x00840052^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006270^I0x00840053^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006272^I0x007e0054^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006273^I0x007d0055^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006275^I0x00000056^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006276^I0x00007050^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006278^I0x00017051^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006280^I0x00008204^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006282^I0x00018205^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006285^I0x00000001^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006286^I0x008b0063^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006288^I0x0000001d^I1104
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006290^I0x00000069^I1114
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006311^I0x0000020f^I0605
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006312^I0x0000026b^I0621
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006316^I0x00000101^I1108
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006318^I0x0000000e^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006319^I0x00680034^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006320^I0x00670035^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006322^I0x007e0036^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006323^I0x007c0037^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006325^I0x00000038^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006326^I0x00840052^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006328^I0x00840053^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006329^I0x007e0054^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006331^I0x007d0055^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006332^I0x00000056^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006334^I0x00007050^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006336^I0x00017051^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006338^I0x00008204^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006340^I0x00018205^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006343^I0x00000001^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006344^I0x008b0063^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006346^I0x0000001c^I1104
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006347^I0x00000002^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006348^I0x0083903f^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006350^I0x0001d213^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006353^I0x00000002^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006354^I0x0003d206^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006356^I0x0083903e^I1102
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006360^I0x00000059^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006460^I0x00000013^I1101
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000006478^I0x00000004^I1107
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007046^I0x0001747b^I1110
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007057^I0xffffff51^I0454
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007058^I0x00000000^I0472
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007068^I0x00000001^I0463
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007071^I0xffffff51^I1111
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007076^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007076^I0x0000000e^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007081^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007085^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007089^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007093^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007098^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007102^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007106^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007111^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007115^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007119^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007123^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007128^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007132^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007136^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007140^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007145^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007149^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007153^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007158^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007162^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007166^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007170^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007175^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007179^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007183^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007187^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007192^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007196^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007200^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007205^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007209^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007213^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007217^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007222^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007226^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007230^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007234^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007239^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007243^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007247^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007252^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007256^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007260^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007264^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007269^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007273^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007277^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007282^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007286^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007290^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007294^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007299^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007303^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007307^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007311^I0x00000000^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007316^I0x00000001^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007317^I0x0000000f^I1106
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007318^I0x000003ec^I1105
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007322^I0x000004e8^I1115
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007326^I0x00000001^I0463
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007327^I0x00000001^I0462
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007338^I0x0000010c^I0601
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007499^I0x00010087^I0250
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000007505^I0x0000001c^I0218
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000207469^I0x00000002^I0123
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: 0000207472^I0x00000100^I0125
Mar 10 23:27:31 rainbow kernel: [  302.869158] ieee80211 phy3: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq 0x013A ser 0x004E0000
Mar 10 23:27:31 rainbow kernel: [  302.869158] ieee80211 phy3: U __iwl3945_down iwl3945 is going down
Mar 10 23:27:31 rainbow kernel: [  302.869158] iwl3945 0000:03:00.0: Can't stop Rx DMA.
Mar 10 23:27:31 rainbow kernel: [  302.884993] ieee80211 phy3: U iwl3945_apm_stop_master stop master
Mar 10 23:27:31 rainbow kernel: [  302.885216] ieee80211 phy3: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Mar 10 23:27:31 rainbow kernel: [  302.888201] ieee80211 phy3: U iwl3945_hw_nic_init HW Revision ID = 0x2
Mar 10 23:27:31 rainbow kernel: [  302.888255] ieee80211 phy3: U iwl3945_nic_config 3945 RADIO-MM type
Mar 10 23:27:31 rainbow kernel: [  302.888266] ieee80211 phy3: U iwl3945_nic_config SKU OP mode is basic
Mar 10 23:27:31 rainbow kernel: [  302.888272] ieee80211 phy3: U iwl3945_nic_config 3945ABG revision is 0xF1
Mar 10 23:27:31 rainbow kernel: [  302.888283] ieee80211 phy3: U iwl3945_nic_config Card M type B version is 0x3
Mar 10 23:27:31 rainbow kernel: [  302.890984] ieee80211 phy3: U iwl3945_load_bsm Begin load bsm
Mar 10 23:27:31 rainbow kernel: [  302.892252] ieee80211 phy3: U iwl3945_verify_bsm Begin verify bsm
Mar 10 23:27:31 rainbow kernel: [  302.894457] ieee80211 phy3: U iwl3945_verify_bsm BSM bootstrap uCode image OK
Mar 10 23:27:31 rainbow kernel: [  302.894514] ieee80211 phy3: U iwl3945_load_bsm BSM write complete, poll 1 iterations
Mar 10 23:27:31 rainbow kernel: [  302.894531] ieee80211 phy3: U __iwl3945_up iwl3945 is coming up
Mar 10 23:27:31 rainbow kernel: [  302.905997] ieee80211 phy3: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Mar 10 23:27:31 rainbow kernel: [  302.906007] ieee80211 phy3: I iwl3945_rx_reply_alive Initialization Alive received.
Mar 10 23:27:31 rainbow kernel: [  302.912067] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 10 23:27:31 rainbow kernel: [  302.912162] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 10 23:27:31 rainbow kernel: [  302.912443] ieee80211 phy3: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Mar 10 23:27:31 rainbow kernel: [  302.912449] ieee80211 phy3: U iwl3945_init_alive_start Initialization Alive received.
Mar 10 23:27:31 rainbow kernel: [  302.912498] ieee80211 phy3: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Mar 10 23:27:31 rainbow kernel: [  302.916881] ieee80211 phy3: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Mar 10 23:27:31 rainbow kernel: [  302.916888] ieee80211 phy3: I iwl3945_rx_reply_alive Runtime Alive received.
Mar 10 23:27:31 rainbow kernel: [  302.916935] ieee80211 phy3: I iwl3945_disable_events Selected uCode log events may be disabled
Mar 10 23:27:31 rainbow kernel: [  302.916940] ieee80211 phy3: I iwl3945_disable_events   by writing "1"s into disable bitmap
Mar 10 23:27:31 rainbow kernel: [  302.916946] ieee80211 phy3: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Mar 10 23:27:31 rainbow kernel: [  302.925117] ieee80211 phy3: U iwl3945_alive_start Runtime Alive received.
Mar 10 23:27:31 rainbow kernel: [  302.925123] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 10 23:27:31 rainbow kernel: [  302.925207] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 10 23:27:31 rainbow kernel: [  302.925290] ieee80211 phy3: U iwl3945_verify_inst_sparse ucode inst image size is 80684
Mar 10 23:27:31 rainbow kernel: [  302.932944] ieee80211 phy3: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Mar 10 23:27:31 rainbow kernel: [  302.932976] ieee80211 phy3: U iwl3945_alive_start RFKILL status: 0x1
Mar 10 23:27:31 rainbow kernel: [  302.933645] Pid: 5986, comm: iwl3945/1 Not tainted 2.6.28-wl #57
Mar 10 23:27:31 rainbow kernel: [  302.933650] Call Trace:
Mar 10 23:27:31 rainbow kernel: [  302.933674]  [<ffffffffa052104d>] iwl3945_connection_init_rx_config+0x4d/0x1f0 [iwl3945]
Mar 10 23:27:31 rainbow kernel: [  302.933693]  [<ffffffffa052e9e6>] iwl3945_bg_alive_start+0x426/0x6f0 [iwl3945]
Mar 10 23:27:31 rainbow kernel: [  302.933705]  [<ffffffff804f46ce>] ? mutex_unlock+0xe/0x10
Mar 10 23:27:31 rainbow kernel: [  302.933722]  [<ffffffffa052e5c0>] ? iwl3945_bg_alive_start+0x0/0x6f0 [iwl3945]
Mar 10 23:27:31 rainbow kernel: [  302.933731]  [<ffffffff80254d40>] run_workqueue+0x70/0x120
Mar 10 23:27:31 rainbow kernel: [  302.933738]  [<ffffffff80254ff7>] worker_thread+0xa7/0x120
Mar 10 23:27:31 rainbow kernel: [  302.933746]  [<ffffffff80259270>] ? autoremove_wake_function+0x0/0x40
Mar 10 23:27:31 rainbow kernel: [  302.933753]  [<ffffffff80254f50>] ? worker_thread+0x0/0x120
Mar 10 23:27:31 rainbow kernel: [  302.933760]  [<ffffffff80258e39>] kthread+0x49/0x90
Mar 10 23:27:31 rainbow kernel: [  302.933767]  [<ffffffff8020d3f9>] child_rip+0xa/0x11
Mar 10 23:27:31 rainbow kernel: [  302.933774]  [<ffffffff80258df0>] ? kthread+0x0/0x90
Mar 10 23:27:31 rainbow kernel: [  302.933779]  [<ffffffff8020d3ef>] ? child_rip+0x0/0x11
Mar 10 23:27:31 rainbow kernel: [  302.933785] iwl3945 0000:03:00.0: Unsupported interface type 515
Mar 10 23:27:31 rainbow kernel: [  302.933801] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.934983] ieee80211 phy3: U iwl3945_commit_rxon Sending RXON
Mar 10 23:27:31 rainbow kernel: [  302.934986] * without RXON_FILTER_ASSOC_MSK
Mar 10 23:27:31 rainbow kernel: [  302.934987] * channel = 1
Mar 10 23:27:31 rainbow kernel: [  302.934989] * bssid = 00:00:00:00:00:00
Mar 10 23:27:31 rainbow kernel: [  302.935003] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.937965] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.940690] ieee80211 phy3: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 10 23:27:31 rainbow kernel: [  302.940705] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.943485] ieee80211 phy3: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 10 23:27:31 rainbow kernel: [  302.943501] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.946308] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.948930] ieee80211 phy3: U iwl3945_hw_reg_txpower_get_temperature Temperature: 85
Mar 10 23:27:31 rainbow kernel: [  302.948957] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.951787] Registered led device: iwl-phy3:radio
Mar 10 23:27:31 rainbow kernel: [  302.951803] ieee80211 phy3: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  302.951849] Registered led device: iwl-phy3:assoc
Mar 10 23:27:31 rainbow kernel: [  302.951884] Registered led device: iwl-phy3:RX
Mar 10 23:27:31 rainbow kernel: [  302.951917] Registered led device: iwl-phy3:TX
Mar 10 23:27:31 rainbow kernel: [  302.951921] ieee80211 phy3: U iwl3945_alive_start ALIVE processing complete.
Mar 10 23:27:31 rainbow kernel: [  303.061042] wlan0: authenticate with AP 00:13:46:08:8a:6e
Mar 10 23:27:31 rainbow kernel: [  303.061067] ieee80211 phy3: I iwl3945_mac_tx enter
Mar 10 23:27:31 rainbow kernel: [  303.061130] ieee80211 phy3: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 10 23:27:31 rainbow kernel: [  303.061142] ieee80211 phy3: I iwl3945_mac_tx leave
Mar 10 23:27:31 rainbow kernel: [  303.261076] wlan0: authentication with AP 00:13:46:08:8a:6e timed out
Mar 10 23:27:41 rainbow kernel: [  312.634320] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:27:41 rainbow kernel: [  312.634333] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:27:41 rainbow kernel: [  312.634343] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:27:41 rainbow kernel: [  313.132774] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:27:41 rainbow kernel: [  313.132791] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:27:42 rainbow kernel: [  313.632144] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:27:46 rainbow kernel: [  318.134367] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:27:46 rainbow kernel: [  318.134380] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:27:46 rainbow kernel: [  318.134389] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:27:47 rainbow kernel: [  318.632190] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:27:47 rainbow kernel: [  318.632205] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:27:47 rainbow kernel: [  319.132146] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:27:52 rainbow kernel: [  323.633725] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:27:52 rainbow kernel: [  323.633737] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:27:52 rainbow kernel: [  323.633745] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:27:52 rainbow kernel: [  324.132196] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:27:52 rainbow kernel: [  324.132212] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:27:53 rainbow kernel: [  324.633142] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:27:57 rainbow kernel: [  329.133776] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:27:57 rainbow kernel: [  329.133788] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:27:57 rainbow kernel: [  329.133798] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:27:58 rainbow kernel: [  329.632148] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:27:58 rainbow kernel: [  329.632164] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:27:58 rainbow kernel: [  330.132276] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:28:03 rainbow kernel: [  334.633087] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:28:03 rainbow kernel: [  334.633098] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:28:03 rainbow kernel: [  334.633107] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:28:03 rainbow kernel: [  335.132147] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:28:03 rainbow kernel: [  335.132162] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:28:04 rainbow kernel: [  335.633066] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:28:08 rainbow kernel: [  340.133694] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:28:08 rainbow kernel: [  340.133705] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:28:08 rainbow kernel: [  340.133714] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:28:09 rainbow kernel: [  340.632148] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:28:09 rainbow kernel: [  340.632163] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:28:09 rainbow kernel: [  341.132153] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:28:14 rainbow kernel: [  345.633712] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:28:14 rainbow kernel: [  345.633724] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:28:14 rainbow kernel: [  345.633732] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:28:14 rainbow kernel: [  346.133045] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:28:14 rainbow kernel: [  346.133062] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:28:15 rainbow kernel: [  346.633140] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:28:19 rainbow kernel: [  351.134525] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:28:19 rainbow kernel: [  351.134537] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:28:19 rainbow kernel: [  351.134546] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:28:20 rainbow kernel: [  351.632147] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:28:20 rainbow kernel: [  351.632163] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:28:20 rainbow kernel: [  352.132154] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:28:25 rainbow kernel: [  356.633864] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:28:25 rainbow kernel: [  356.633876] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:28:25 rainbow kernel: [  356.633887] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:28:25 rainbow kernel: [  357.132314] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:28:25 rainbow kernel: [  357.132332] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:28:26 rainbow kernel: [  357.632065] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:28:31 rainbow kernel: [  362.949278] ieee80211 phy3: U iwl3945_hw_reg_txpower_get_temperature Temperature: 84
Mar 10 23:28:34 rainbow kernel: [  365.348079] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:28:34 rainbow kernel: [  365.348091] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:28:34 rainbow kernel: [  365.348101] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:28:34 rainbow kernel: [  365.848149] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:28:34 rainbow kernel: [  365.848165] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:28:35 rainbow kernel: [  366.348175] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 10 23:28:39 rainbow kernel: [  370.850028] ieee80211 phy3: U iwl3945_mac_hw_scan enter
Mar 10 23:28:39 rainbow kernel: [  370.850040] ieee80211 phy3: U iwl3945_scan_initiate Starting scan...
Mar 10 23:28:39 rainbow kernel: [  370.850049] ieee80211 phy3: U iwl3945_mac_hw_scan leave
Mar 10 23:28:40 rainbow kernel: [  371.348149] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 10 23:28:40 rainbow kernel: [  371.348164] ieee80211 phy3: U iwl3945_bg_scan_completed SCAN complete scan
Mar 10 23:28:40 rainbow kernel: [  371.848269] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms

