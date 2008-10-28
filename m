Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbYJ1UXf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 16:23:35 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: reinette chatre <reinette.chatre@intel.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081028194323.GA14303@isilmar.linta.de>
References: <20081018231046.GA10977@isilmar.linta.de>
	 <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
	 <20081019075916.GA12904@isilmar.linta.de>
	 <1225145468.1115.139.camel@rc-desk>
	 <20081027230326.GA23250@isilmar.linta.de>
	 <1225154823.1115.149.camel@rc-desk>
	 <20081028194323.GA14303@isilmar.linta.de>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 13:23:54 -0700
Message-Id: <1225225434.1115.217.camel@rc-desk> (sfid-20081028_212343_098446_12401F4B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-28 at 12:43 -0700, Dominik Brodowski wrote:
> Hi,
> 
> On Mon, Oct 27, 2008 at 05:47:03PM -0700, reinette chatre wrote:
> > On Mon, 2008-10-27 at 16:03 -0700, Dominik Brodowski wrote:
> > > Hi,
> > >
> > > On Mon, Oct 27, 2008 at 03:11:08PM -0700, reinette chatre wrote:
> > > > Could you please try the following patch instead of updating your ucode?
> > >
> > > Thanks for the patch -- it doesn't work with the old uCode, unfortunately;
> > > while the new uCode works with or without this patch.
> > >
> >
> > We would like to trace what is causing that microcode error - could you
> > please reproduce the problem while debugging is enabled in the driver?
> > That will give us a full log of the microcode error. Please compile your
> > driver with debugging (CONFIG_IWL3945_DEBUG) and load the module with
> > option "debug=0x43fff". Please run the test without the patch I just
> > sent.
> 
> here it is. If you need further information, please let me know.

(adding linux-wireless so I am keeping the log below)

This helps a lot - thanks!

Could you please recompile wireless with CONFIG_WIRELESS_OLD_REGULATORY?
(-> Networking support -> Wireless -> Old wireless static regulatory
definitions) Alternatively, please use iw
(http://wireless.kernel.org/en/users/Documentation/iw) to set your
regulatory domain correctly          

Reinette

> 
> Thanks,
>         Dominik
> 
> [ 1092.432615] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
> [ 1092.432626] iwl3945: Copyright(c) 2003-2008 Intel Corporation
> [ 1092.432840] iwl3945 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 1092.432873] iwl3945 0000:02:00.0: setting latency timer to 64
> [ 1092.433378] iwl3945: U iwl3945_pci_probe pci_resource_len = 0x00001000
> [ 1092.433388] iwl3945: U iwl3945_pci_probe pci_resource_base = ffffc200104f0000
> [ 1092.433396] iwl3945: Detected Intel Wireless WiFi Link 3945ABG
> [ 1092.433473] iwl3945: U iwl3945_set_rxon_channel Staging channel set to 6 [0]
> [ 1092.476012] iwl3945: U iwl3945_pci_probe MAC address: 00:1b:77:dd:0c:a7
> [ 1092.476022] iwl3945: U iwl3945_init_channel_map Initializing regulatory info from EEPROM
> [ 1092.476030] iwl3945: U iwl3945_init_channel_map Parsing data for 56 channels.
> [ 1092.476106] iwl3945: U iwl3945_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476119] iwl3945: U iwl3945_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476129] iwl3945: U iwl3945_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476139] iwl3945: U iwl3945_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476149] iwl3945: U iwl3945_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476159] iwl3945: U iwl3945_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476168] iwl3945: U iwl3945_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476178] iwl3945: U iwl3945_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476188] iwl3945: U iwl3945_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476198] iwl3945: U iwl3945_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476208] iwl3945: U iwl3945_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
> [ 1092.476218] iwl3945: U iwl3945_init_channel_map Ch. 12 [2.4GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
> [ 1092.476228] iwl3945: U iwl3945_init_channel_map Ch. 13 [2.4GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
> [ 1092.476236] iwl3945: U iwl3945_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
> [ 1092.476244] iwl3945: U iwl3945_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
> [ 1092.476285] iwl3945: U iwl3945_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
> [ 1092.476293] iwl3945: U iwl3945_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
> [ 1092.476300] iwl3945: U iwl3945_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
> [ 1092.476308] iwl3945: U iwl3945_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
> [ 1092.476316] iwl3945: U iwl3945_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
> [ 1092.476324] iwl3945: U iwl3945_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
> [ 1092.476331] iwl3945: U iwl3945_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
> [ 1092.476338] iwl3945: U iwl3945_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
> [ 1092.476347] iwl3945: U iwl3945_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
> [ 1092.476354] iwl3945: U iwl3945_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
> [ 1092.476362] iwl3945: U iwl3945_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
> [ 1092.476370] iwl3945: U iwl3945_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
> [ 1092.476382] iwl3945: U iwl3945_init_channel_map Ch. 34 [5.2GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
> [ 1092.476386] iwl3945: U iwl3945_init_channel_map Ch. 36 [5.2GHz] VALID IBSS ACTIVE WIDE DFS (0xab 15dBm): Ad-Hoc supported
> [ 1092.476390] iwl3945: U iwl3945_init_channel_map Ch. 38 [5.2GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
> [ 1092.476394] iwl3945: U iwl3945_init_channel_map Ch. 40 [5.2GHz] VALID IBSS ACTIVE WIDE DFS (0xab 15dBm): Ad-Hoc supported
> [ 1092.476399] iwl3945: U iwl3945_init_channel_map Ch. 42 [5.2GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
> [ 1092.476403] iwl3945: U iwl3945_init_channel_map Ch. 44 [5.2GHz] VALID IBSS ACTIVE WIDE DFS (0xab 15dBm): Ad-Hoc supported
> [ 1092.476407] iwl3945: U iwl3945_init_channel_map Ch. 46 [5.2GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
> [ 1092.476411] iwl3945: U iwl3945_init_channel_map Ch. 48 [5.2GHz] VALID IBSS ACTIVE WIDE DFS (0xab 15dBm): Ad-Hoc supported
> [ 1092.476415] iwl3945: U iwl3945_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE DFS (0xb1 15dBm): Ad-Hoc not supported
> [ 1092.476419] iwl3945: U iwl3945_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE DFS (0xb1 15dBm): Ad-Hoc not supported
> [ 1092.476424] iwl3945: U iwl3945_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE DFS (0xb1 15dBm): Ad-Hoc not supported
> [ 1092.476428] iwl3945: U iwl3945_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE DFS (0xb1 15dBm): Ad-Hoc not supported
> [ 1092.476432] iwl3945: U iwl3945_init_channel_map Ch. 100 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476436] iwl3945: U iwl3945_init_channel_map Ch. 104 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476440] iwl3945: U iwl3945_init_channel_map Ch. 108 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476444] iwl3945: U iwl3945_init_channel_map Ch. 112 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476449] iwl3945: U iwl3945_init_channel_map Ch. 116 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476453] iwl3945: U iwl3945_init_channel_map Ch. 120 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476457] iwl3945: U iwl3945_init_channel_map Ch. 124 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476461] iwl3945: U iwl3945_init_channel_map Ch. 128 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476465] iwl3945: U iwl3945_init_channel_map Ch. 132 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476470] iwl3945: U iwl3945_init_channel_map Ch. 136 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476474] iwl3945: U iwl3945_init_channel_map Ch. 140 [5.2GHz] VALID RADAR WIDE DFS (0xb1 16dBm): Ad-Hoc not supported
> [ 1092.476478] iwl3945: U iwl3945_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
> [ 1092.476481] iwl3945: U iwl3945_init_channel_map Ch. 149 Flags 0 [5.2GHz] - No traffic
> [ 1092.476484] iwl3945: U iwl3945_init_channel_map Ch. 153 Flags 0 [5.2GHz] - No traffic
> [ 1092.476487] iwl3945: U iwl3945_init_channel_map Ch. 157 Flags 0 [5.2GHz] - No traffic
> [ 1092.476490] iwl3945: U iwl3945_init_channel_map Ch. 161 Flags 0 [5.2GHz] - No traffic
> [ 1092.476493] iwl3945: U iwl3945_init_channel_map Ch. 165 Flags 0 [5.2GHz] - No traffic
> [ 1092.476503] iwl3945: U iwl3945_hw_reg_txpower_get_temperature Temperature: 260
> [ 1092.476506] iwl3945: U iwl3945_hw_reg_init_channel_groups Initializing factory calib info from EEPROM
> [ 1092.476509] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 1 mapped to grp 0
> [ 1092.476513] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 1: -20 [260]
> [ 1092.476517] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 2 mapped to grp 0
> [ 1092.476519] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 2: -20 [260]
> [ 1092.476523] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 3 mapped to grp 0
> [ 1092.476526] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 3: -20 [260]
> [ 1092.476529] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 4 mapped to grp 0
> [ 1092.476532] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 4: -20 [260]
> [ 1092.476535] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 5 mapped to grp 0
> [ 1092.476538] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 5: -20 [260]
> [ 1092.476541] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 6 mapped to grp 0
> [ 1092.476544] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 6: -20 [260]
> [ 1092.476548] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 7 mapped to grp 0
> [ 1092.476550] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 7: -20 [260]
> [ 1092.476554] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 8 mapped to grp 0
> [ 1092.476557] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 8: -20 [260]
> [ 1092.476560] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 9 mapped to grp 0
> [ 1092.476563] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 9: -20 [260]
> [ 1092.476566] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 10 mapped to grp 0
> [ 1092.476569] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 10: -20 [260]
> [ 1092.476572] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 11 mapped to grp 0
> [ 1092.476575] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 11: -20 [260]
> [ 1092.476578] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 12 mapped to grp 0
> [ 1092.476581] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 12: -20 [260]
> [ 1092.476585] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 13 mapped to grp 0
> [ 1092.476587] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 13: -20 [260]
> [ 1092.476591] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 34 mapped to grp 1
> [ 1092.476594] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 34: -20 [260]
> [ 1092.476597] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 36 mapped to grp 1
> [ 1092.476600] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 36: -20 [260]
> [ 1092.476604] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 38 mapped to grp 1
> [ 1092.476607] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 38: -20 [260]
> [ 1092.476610] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 40 mapped to grp 1
> [ 1092.476613] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 40: -20 [260]
> [ 1092.476616] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 42 mapped to grp 1
> [ 1092.476619] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 42: -20 [260]
> [ 1092.476623] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 44 mapped to grp 1
> [ 1092.476626] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 44: -20 [260]
> [ 1092.476629] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 46 mapped to grp 2
> [ 1092.476632] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 46: -20 [260]
> [ 1092.476635] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 48 mapped to grp 2
> [ 1092.476638] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 48: -20 [260]
> [ 1092.476642] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 52 mapped to grp 2
> [ 1092.476644] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 52: -20 [260]
> [ 1092.476648] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 56 mapped to grp 2
> [ 1092.476651] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 56: -20 [260]
> [ 1092.476654] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 60 mapped to grp 2
> [ 1092.476657] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 60: -20 [260]
> [ 1092.476660] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 64 mapped to grp 2
> [ 1092.476663] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 64: -20 [260]
> [ 1092.476667] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 100 mapped to grp 3
> [ 1092.476670] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 100: -20 [260]
> [ 1092.476673] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 104 mapped to grp 3
> [ 1092.476676] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 104: -20 [260]
> [ 1092.476679] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 108 mapped to grp 3
> [ 1092.476682] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 108: -20 [260]
> [ 1092.476686] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 112 mapped to grp 3
> [ 1092.476688] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 112: -20 [260]
> [ 1092.476692] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 116 mapped to grp 3
> [ 1092.476695] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 116: -20 [260]
> [ 1092.476698] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 120 mapped to grp 4
> [ 1092.476701] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 120: -20 [260]
> [ 1092.476705] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 124 mapped to grp 4
> [ 1092.476708] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 124: -20 [260]
> [ 1092.476711] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 128 mapped to grp 4
> [ 1092.476714] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 128: -20 [260]
> [ 1092.476717] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 132 mapped to grp 4
> [ 1092.476720] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 132: -20 [260]
> [ 1092.476724] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 136 mapped to grp 4
> [ 1092.476727] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 136: -20 [260]
> [ 1092.476730] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 140 mapped to grp 4
> [ 1092.476733] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 140: -20 [260]
> [ 1092.476739] iwl3945: U iwl3945_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=00
> [ 1092.476743] iwl3945: U iwl3945_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=00
> [ 1092.476746] iwl3945: U iwl3945_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=00
> [ 1092.476749] iwl3945: U iwl3945_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=00
> [ 1092.476752] iwl3945: U iwl3945_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=00
> [ 1092.476756] iwl3945: U iwl3945_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=00
> [ 1092.476759] iwl3945: U iwl3945_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=00
> [ 1092.476762] iwl3945: U iwl3945_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=00
> [ 1092.476765] iwl3945: U iwl3945_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=00
> [ 1092.476769] iwl3945: U iwl3945_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=00
> [ 1092.476772] iwl3945: U iwl3945_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=00
> [ 1092.476775] iwl3945: U iwl3945_init_geos Channel 12 Freq=2467[2.4GHz] valid flag=06
> [ 1092.476779] iwl3945: U iwl3945_init_geos Channel 13 Freq=2472[2.4GHz] valid flag=06
> [ 1092.476782] iwl3945: U iwl3945_init_geos Channel 34 Freq=5170[5.2GHz] valid flag=06
> [ 1092.476785] iwl3945: U iwl3945_init_geos Channel 36 Freq=5180[5.2GHz] valid flag=00
> [ 1092.476788] iwl3945: U iwl3945_init_geos Channel 38 Freq=5190[5.2GHz] valid flag=06
> [ 1092.476791] iwl3945: U iwl3945_init_geos Channel 40 Freq=5200[5.2GHz] valid flag=00
> [ 1092.476795] iwl3945: U iwl3945_init_geos Channel 42 Freq=5210[5.2GHz] valid flag=06
> [ 1092.476798] iwl3945: U iwl3945_init_geos Channel 44 Freq=5220[5.2GHz] valid flag=00
> [ 1092.476801] iwl3945: U iwl3945_init_geos Channel 46 Freq=5230[5.2GHz] valid flag=06
> [ 1092.476804] iwl3945: U iwl3945_init_geos Channel 48 Freq=5240[5.2GHz] valid flag=00
> [ 1092.476808] iwl3945: U iwl3945_init_geos Channel 52 Freq=5260[5.2GHz] valid flag=0E
> [ 1092.476811] iwl3945: U iwl3945_init_geos Channel 56 Freq=5280[5.2GHz] valid flag=0E
> [ 1092.476814] iwl3945: U iwl3945_init_geos Channel 60 Freq=5300[5.2GHz] valid flag=0E
> [ 1092.476817] iwl3945: U iwl3945_init_geos Channel 64 Freq=5320[5.2GHz] valid flag=0E
> [ 1092.476821] iwl3945: U iwl3945_init_geos Channel 100 Freq=5500[5.2GHz] valid flag=0E
> [ 1092.476824] iwl3945: U iwl3945_init_geos Channel 104 Freq=5520[5.2GHz] valid flag=0E
> [ 1092.476827] iwl3945: U iwl3945_init_geos Channel 108 Freq=5540[5.2GHz] valid flag=0E
> [ 1092.476830] iwl3945: U iwl3945_init_geos Channel 112 Freq=5560[5.2GHz] valid flag=0E
> [ 1092.476834] iwl3945: U iwl3945_init_geos Channel 116 Freq=5580[5.2GHz] valid flag=0E
> [ 1092.476837] iwl3945: U iwl3945_init_geos Channel 120 Freq=5600[5.2GHz] valid flag=0E
> [ 1092.476840] iwl3945: U iwl3945_init_geos Channel 124 Freq=5620[5.2GHz] valid flag=0E
> [ 1092.476844] iwl3945: U iwl3945_init_geos Channel 128 Freq=5640[5.2GHz] valid flag=0E
> [ 1092.476847] iwl3945: U iwl3945_init_geos Channel 132 Freq=5660[5.2GHz] valid flag=0E
> [ 1092.476850] iwl3945: U iwl3945_init_geos Channel 136 Freq=5680[5.2GHz] valid flag=0E
> [ 1092.476854] iwl3945: U iwl3945_init_geos Channel 140 Freq=5700[5.2GHz] valid flag=0E
> [ 1092.476857] iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> [ 1092.478238] phy1: Selected rate control algorithm 'iwl-3945-rs'
> [ 1092.517745] iwl3945: U iwl3945_mac_start enter
> [ 1092.517768] iwl3945 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 1092.518128] iwl3945 0000:02:00.0: irq 44 for MSI/MSI-X
> [ 1092.518387] iwl3945 0000:02:00.0: firmware: requesting iwlwifi-3945-1.ucode
> [ 1092.552827] iwl3945: U iwl3945_read_ucode Got firmware 'iwlwifi-3945-1.ucode' file (149652 bytes) from disk
> [ 1092.552833] iwl3945: U iwl3945_read_ucode f/w package hdr ucode version = 0x20e0105
> [ 1092.552836] iwl3945: U iwl3945_read_ucode f/w package hdr runtime inst size = 80524
> [ 1092.552839] iwl3945: U iwl3945_read_ucode f/w package hdr runtime data size = 32768
> [ 1092.552842] iwl3945: U iwl3945_read_ucode f/w package hdr init inst size = 2668
> [ 1092.552845] iwl3945: U iwl3945_read_ucode f/w package hdr init data size = 32768
> [ 1092.552848] iwl3945: U iwl3945_read_ucode f/w package hdr boot inst size = 900
> [ 1092.552940] iwl3945: U iwl3945_read_ucode Copying (but not loading) uCode instr len 80524
> [ 1092.552994] iwl3945: U iwl3945_read_ucode uCode instr buf vaddr = 0xffff88001b2c0000, paddr = 0x1b2c0000
> [ 1092.552998] iwl3945: U iwl3945_read_ucode Copying (but not loading) uCode data len 32768
> [ 1092.553061] iwl3945: U iwl3945_read_ucode Copying (but not loading) init instr len 2668
> [ 1092.553065] iwl3945: U iwl3945_read_ucode Copying (but not loading) init data len 32768
> [ 1092.553074] iwl3945: U iwl3945_read_ucode Copying (but not loading) boot instr len 900
> [ 1092.553145] iwl3945: U iwl3945_power_init_handle Initialize power
> [ 1092.553178] iwl3945: U iwl3945_power_init_handle adjust power command flags
> [ 1092.553293] iwl3945: U iwl3945_hw_nic_init HW Revision ID = 0x2
> [ 1092.553340] iwl3945: U iwl3945_hw_nic_init 3945 RADIO-MM type
> [ 1092.553348] iwl3945: U iwl3945_hw_nic_init SKU OP mode is basic
> [ 1092.553351] iwl3945: U iwl3945_hw_nic_init 3945ABG revision is 0xF1
> [ 1092.553360] iwl3945: U iwl3945_hw_nic_init Card M type B version is 0x2
> [ 1092.554370] iwl3945: U iwl3945_load_bsm Begin load bsm
> [ 1092.555630] iwl3945: U iwl3945_verify_bsm Begin verify bsm
> [ 1092.557783] iwl3945: U iwl3945_verify_bsm BSM bootstrap uCode image OK
> [ 1092.557837] iwl3945: U iwl3945_load_bsm BSM write complete, poll 1 iterations
> [ 1092.557852] iwl3945: U __iwl3945_up iwl3945 is coming up
> [ 1092.557857] iwl3945: U iwl3945_mac_start Start UP work.
> [ 1092.569478] iwl3945: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
> [ 1092.569483] iwl3945: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
> [ 1092.569486] iwl3945: I iwl3945_rx_reply_alive Initialization Alive received.
> [ 1092.574395] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [ 1092.574483] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 2668
> [ 1092.574759] iwl3945: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
> [ 1092.574762] iwl3945: U iwl3945_init_alive_start Initialization Alive received.
> [ 1092.574809] iwl3945: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
> [ 1092.579140] iwl3945: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
> [ 1092.579143] iwl3945: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
> [ 1092.579146] iwl3945: I iwl3945_rx_reply_alive Runtime Alive received.
> [ 1092.579188] iwl3945: I iwl3945_disable_events Selected uCode log events may be disabled
> [ 1092.579190] iwl3945: I iwl3945_disable_events   by writing "1"s into disable bitmap
> [ 1092.579193] iwl3945: I iwl3945_disable_events   in SRAM at 0x8015f4, size 47 u32s
> [ 1092.584327] iwl3945: U iwl3945_alive_start Runtime Alive received.
> [ 1092.584330] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [ 1092.584407] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 2668
> [ 1092.584484] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 80524
> [ 1092.592065] iwl3945: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
> [ 1092.592096] iwl3945: U iwl3945_alive_start RFKILL status: 0x1
> [ 1092.592115] iwl3945: U iwl3945_update_power_cmd Flags value = 0x00000008
> [ 1092.592118] iwl3945: U iwl3945_update_power_cmd Tx timeout = 0
> [ 1092.592121] iwl3945: U iwl3945_update_power_cmd Rx timeout = 0
> [ 1092.592124] iwl3945: U iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
> [ 1092.592162] iwl3945: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
> [ 1092.592237] iwl3945: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
> [ 1092.592307] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
> [ 1092.592384] iwl3945: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
> [ 1092.592404] iwl3945: U iwl3945_commit_rxon Sending RXON
> [ 1092.592405] * without RXON_FILTER_ASSOC_MSK
> [ 1092.592406] * channel = 1
> [ 1092.592407] * bssid = 00:00:00:00:00:00
> [ 1092.592412] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
> [ 1092.593637] iwl3945: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
> [ 1092.593662] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp 108 rate code 0x0d
> [ 1092.593665] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp 108 rate code 0x0f
> [ 1092.593669] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp 108 rate code 0x05
> [ 1092.593672] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp 108 rate code 0x07
> [ 1092.593675] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp 108 rate code 0x09
> [ 1092.593678] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp 108 rate code 0x0b
> [ 1092.593681] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp 108 rate code 0x01
> [ 1092.593685] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 187 dsp 108 rate code 0x03
> [ 1092.593688] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 113 rate code 0x0a
> [ 1092.593691] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 113 rate code 0x14
> [ 1092.593694] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 113 rate code 0x37
> [ 1092.593697] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 179 dsp 113 rate code 0x6e
> [ 1092.593702] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
> [ 1092.593819] iwl3945: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [ 1092.593838] iwl3945: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [ 1092.593843] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
> [ 1092.593912] iwl3945: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
> [ 1092.593932] iwl3945: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [ 1092.593938] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
> [ 1092.594007] iwl3945: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
> [ 1092.594019] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
> [ 1092.594095] iwl3945: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
> [ 1092.594135] iwl3945: U iwl3945_hw_reg_txpower_get_temperature Temperature: 101
> [ 1092.594138] iwl3945: U is_temp_calib_needed Getting cooler, delta -159,
> [ 1092.594141] iwl3945: U is_temp_calib_needed Timed thermal calib needed
> [ 1092.594152] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0d
> [ 1092.594155] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0f
> [ 1092.594158] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x05
> [ 1092.594161] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x07
> [ 1092.594164] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x09
> [ 1092.594168] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0b
> [ 1092.594171] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x01
> [ 1092.594174] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x03
> [ 1092.594177] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x0a
> [ 1092.594180] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x14
> [ 1092.594183] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x37
> [ 1092.594186] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x6e
> [ 1092.594190] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
> [ 1092.594280] iwl3945: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [ 1092.594530] Registered led device: iwl-phy1:radio
> [ 1092.594535] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
> [ 1092.594599] iwl3945: I iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
> [ 1092.594633] Registered led device: iwl-phy1:assoc
> [ 1092.594682] Registered led device: iwl-phy1:RX
> [ 1092.594730] Registered led device: iwl-phy1:TX
> [ 1092.594733] iwl3945: U iwl3945_alive_start ALIVE processing complete.
> [ 1092.594763] iwl3945: U iwl3945_mac_start leave
> [ 1092.594795] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12 bytes at 9[9]:4
> [ 1092.594800] iwl3945: U iwl3945_mac_add_interface enter: type 2
> [ 1092.594805] iwl3945: U iwl3945_mac_add_interface Set: 00:1b:77:dd:0c:a7
> [ 1092.594814] iwl3945: U iwl3945_commit_rxon Sending RXON
> [ 1092.594815] * without RXON_FILTER_ASSOC_MSK
> [ 1092.594816] * channel = 1
> [ 1092.594817] * bssid = 00:00:00:00:00:00
> [ 1092.594824] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040A, 48 bytes at 10[10]:4
> [ 1092.594866] iwl3945: I iwl3945_rx_handle r 12 i 11 No handler needed for REPLY_LEDS_CMD, 0x48
> [ 1092.595052] iwl3945: I iwl3945_rx_handle r 13 i 12 No handler needed for REPLY_RXON, 0x10
> [ 1092.595072] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0d
> [ 1092.595075] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0f
> [ 1092.595078] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x05
> [ 1092.595081] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x07
> [ 1092.595085] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x09
> [ 1092.595088] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0b
> [ 1092.595091] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x01
> [ 1092.595094] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x03
> [ 1092.595097] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x0a
> [ 1092.595101] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x14
> [ 1092.595104] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x37
> [ 1092.595107] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x6e
> [ 1092.595111] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040B, 56 bytes at 11[11]:4
> [ 1092.595197] iwl3945: I iwl3945_rx_handle r 14 i 13 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [ 1092.595289] iwl3945: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [ 1092.595294] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040C, 68 bytes at 12[12]:4
> [ 1092.595361] iwl3945: I iwl3945_rx_handle r = 15, i = 14, REPLY_ADD_STA, 0x18
> [ 1092.595373] iwl3945: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [ 1092.595410] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040D, 56 bytes at 13[13]:4
> [ 1092.595476] iwl3945: I iwl3945_rx_handle r 16 i 15 No handler needed for REPLY_RATE_SCALE, 0x47
> [ 1092.595490] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040E, 56 bytes at 14[14]:4
> [ 1092.595555] iwl3945: I iwl3945_rx_handle r 17 i 16 No handler needed for REPLY_RATE_SCALE, 0x47
> [ 1092.595568] iwl3945: U iwl3945_mac_add_interface leave
> [ 1092.595572] iwl3945: U iwl3945_bss_info_changed changes = 0x6
> [ 1092.595574] iwl3945: U iwl3945_bss_info_changed ERP_PREAMBLE 0
> [ 1092.595577] iwl3945: U iwl3945_bss_info_changed ERP_CTS 0
> [ 1092.599465] iwl3945: U iwl3945_mac_config enter to channel 1
> [ 1092.599475] iwl3945: U iwl3945_commit_rxon Sending RXON
> [ 1092.599477] * without RXON_FILTER_ASSOC_MSK
> [ 1092.599478] * channel = 1
> [ 1092.599478] * bssid = 00:00:00:00:00:00
> [ 1092.599484] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040F, 48 bytes at 15[15]:4
> [ 1092.599659] iwl3945: I iwl3945_rx_handle r 18 i 17 No handler needed for REPLY_RXON, 0x10
> [ 1092.599681] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0d
> [ 1092.599684] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0f
> [ 1092.599687] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x05
> [ 1092.599690] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x07
> [ 1092.599693] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x09
> [ 1092.599697] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0b
> [ 1092.599700] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x01
> [ 1092.599703] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x03
> [ 1092.599706] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x0a
> [ 1092.599709] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x14
> [ 1092.599713] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x37
> [ 1092.599716] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x6e
> [ 1092.599720] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0410, 56 bytes at 16[16]:4
> [ 1092.599840] iwl3945: I iwl3945_rx_handle r 19 i 18 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [ 1092.599855] iwl3945: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [ 1092.599860] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0411, 68 bytes at 17[17]:4
> [ 1092.599926] iwl3945: I iwl3945_rx_handle r = 20, i = 19, REPLY_ADD_STA, 0x18
> [ 1092.599939] iwl3945: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [ 1092.599945] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0412, 56 bytes at 18[18]:4
> [ 1092.600053] iwl3945: I iwl3945_rx_handle r 21 i 20 No handler needed for REPLY_RATE_SCALE, 0x47
> [ 1092.600073] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0413, 56 bytes at 19[19]:4
> [ 1092.600152] iwl3945: I iwl3945_rx_handle r 22 i 21 No handler needed for REPLY_RATE_SCALE, 0x47
> [ 1092.600168] iwl3945: U iwl3945_mac_config leave
> [ 1092.600172] iwl3945: U iwl3945_mac_conf_tx enter
> [ 1092.600176] iwl3945: U iwl3945_mac_conf_tx leave
> [ 1092.600178] iwl3945: U iwl3945_mac_conf_tx enter
> [ 1092.600181] iwl3945: U iwl3945_mac_conf_tx leave
> [ 1092.600183] iwl3945: U iwl3945_mac_conf_tx enter
> [ 1092.600186] iwl3945: U iwl3945_mac_conf_tx leave
> [ 1092.600188] iwl3945: U iwl3945_mac_conf_tx enter
> [ 1092.600192] iwl3945: U iwl3945_mac_conf_tx leave
> [ 1092.880189] iwl3945: I iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
> [ 1092.982804] iwl3945: I iwl3945_rx_handle r = 24, i = 23, REPLY_3945_RX, 0x1b
> [ 1093.213682] iwl3945: U iwl3945_mac_hw_scan enter
> [ 1093.213780] iwl3945: U iwl3945_scan_initiate Starting scan...
> [ 1093.213944] iwl3945: U iwl3945_mac_hw_scan leave
> [ 1093.214158] iwl3945: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [ 1093.214171] iwl3945: U iwl3945_get_channels_for_scan Scanning 1 [PASSIVE 120]
> [ 1093.214179] iwl3945: U iwl3945_get_channels_for_scan Scanning 2 [PASSIVE 120]
> [ 1093.214187] iwl3945: U iwl3945_get_channels_for_scan Scanning 3 [PASSIVE 120]
> [ 1093.214194] iwl3945: U iwl3945_get_channels_for_scan Scanning 4 [PASSIVE 120]
> [ 1093.214201] iwl3945: U iwl3945_get_channels_for_scan Scanning 5 [PASSIVE 120]
> [ 1093.214209] iwl3945: U iwl3945_get_channels_for_scan Scanning 6 [PASSIVE 120]
> [ 1093.214216] iwl3945: U iwl3945_get_channels_for_scan Scanning 7 [PASSIVE 120]
> [ 1093.214223] iwl3945: U iwl3945_get_channels_for_scan Scanning 8 [PASSIVE 120]
> [ 1093.214231] iwl3945: U iwl3945_get_channels_for_scan Scanning 9 [PASSIVE 120]
> [ 1093.214238] iwl3945: U iwl3945_get_channels_for_scan Scanning 10 [PASSIVE 120]
> [ 1093.214246] iwl3945: U iwl3945_get_channels_for_scan Scanning 11 [PASSIVE 120]
> [ 1093.214290] iwl3945: U iwl3945_get_channels_for_scan total channels to scan 11
> [ 1093.214314] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4414, 350 bytes at 20[32]:4
> [ 1093.214460] iwl3945: I iwl3945_rx_handle r = 25, i = 24, REPLY_SCAN_CMD, 0x80
> [ 1093.215519] iwl3945: I iwl3945_rx_handle r = 27, i = 25, STATISTICS_NOTIFICATION, 0x9d
> [ 1093.215542] iwl3945: I iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0415, 12 bytes at 21[21]:4
> [ 1093.215555] iwl3945: I iwl3945_rx_handle r = 27, i = 26, SCAN_START_NOTIFICATION, 0x82
> [ 1093.215565] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x00000000:000965CA) - 1 (beacon timer 100764214)
> [ 1093.215635] iwl3945: I iwl3945_rx_handle r 28 i 27 No handler needed for REPLY_LEDS_CMD, 0x48
> [ 1093.289780] iwl3945: I iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
> [ 1093.338636] iwl3945: I iwl3945_rx_handle r = 30, i = 29, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1093.338651] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF: 0x00000000:000B45DC) - 1 elapsed=122898 usec (793338ms since last)
> [ 1093.339419] iwl3945: I iwl3945_rx_handle r = 32, i = 30, STATISTICS_NOTIFICATION, 0x9d
> [ 1093.339439] iwl3945: I iwl3945_rx_handle r = 32, i = 31, SCAN_START_NOTIFICATION, 0x82
> [ 1093.339449] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x00000000:000B49B8) - 1 (beacon timer 117519944)
> [ 1093.392169] iwl3945: I iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
> [ 1093.462525] iwl3945: I iwl3945_rx_handle r = 34, i = 33, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1093.462539] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF: 0x00000000:000D29C9) - 1 elapsed=122897 usec (124ms since last)
> [ 1093.463338] iwl3945: I iwl3945_rx_handle r = 36, i = 34, STATISTICS_NOTIFICATION, 0x9d
> [ 1093.463354] iwl3945: I iwl3945_rx_handle r = 36, i = 35, SCAN_START_NOTIFICATION, 0x82
> [ 1093.463365] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x00000000:000D2DB6) - 1 (beacon timer 134275658)
> [ 1093.494792] iwl3945: I iwl3945_rx_handle r = 37, i = 36, REPLY_3945_RX, 0x1b
> [ 1093.586424] iwl3945: I iwl3945_rx_handle r = 38, i = 37, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1093.586440] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF: 0x00000000:000F0DC2) - 1 elapsed=122892 usec (124ms since last)
> [ 1093.587321] iwl3945: I iwl3945_rx_handle r = 40, i = 38, STATISTICS_NOTIFICATION, 0x9d
> [ 1093.587339] iwl3945: I iwl3945_rx_handle r = 40, i = 39, SCAN_START_NOTIFICATION, 0x82
> [ 1093.587350] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x00000000:000F11BA) - 1 (beacon timer 151031366)
> [ 1093.596942] iwl3945: I iwl3945_rx_handle r = 41, i = 40, REPLY_3945_RX, 0x1b
> [ 1093.699399] iwl3945: I iwl3945_rx_handle r = 42, i = 41, REPLY_3945_RX, 0x1b
> [ 1093.710124] iwl3945: I iwl3945_rx_handle r = 43, i = 42, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1093.710139] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF: 0x00000000:0010F1C8) - 2 elapsed=122894 usec (124ms since last)
> [ 1093.711367] iwl3945: I iwl3945_rx_handle r = 45, i = 43, STATISTICS_NOTIFICATION, 0x9d
> [ 1093.711383] iwl3945: I iwl3945_rx_handle r = 45, i = 44, SCAN_START_NOTIFICATION, 0x82
> [ 1093.711393] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x00000000:0010F6D2) - 1 (beacon timer 167786798)
> [ 1093.834345] iwl3945: I iwl3945_rx_handle r = 46, i = 45, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1093.834361] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF: 0x00000000:0012D6ED) - 0 elapsed=122907 usec (124ms since last)
> [ 1093.835587] iwl3945: I iwl3945_rx_handle r = 48, i = 46, STATISTICS_NOTIFICATION, 0x9d
> [ 1093.835602] iwl3945: I iwl3945_rx_handle r = 48, i = 47, SCAN_START_NOTIFICATION, 0x82
> [ 1093.835612] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x00000000:0012DC0F) - 1 (beacon timer 201421809)
> [ 1093.958742] iwl3945: I iwl3945_rx_handle r = 49, i = 48, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1093.958758] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF: 0x00000000:0014BC2C) - 0 elapsed=122909 usec (124ms since last)
> [ 1093.959598] iwl3945: I iwl3945_rx_handle r = 51, i = 49, STATISTICS_NOTIFICATION, 0x9d
> [ 1093.959617] iwl3945: I iwl3945_rx_handle r = 51, i = 50, SCAN_START_NOTIFICATION, 0x82
> [ 1093.959627] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x00000000:0014C054) - 1 (beacon timer 218177452)
> [ 1094.082715] iwl3945: I iwl3945_rx_handle r = 52, i = 51, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1094.082730] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF: 0x00000000:0016A071) - 0 elapsed=122909 usec (124ms since last)
> [ 1094.083602] iwl3945: I iwl3945_rx_handle r = 54, i = 52, STATISTICS_NOTIFICATION, 0x9d
> [ 1094.083620] iwl3945: I iwl3945_rx_handle r = 54, i = 53, SCAN_START_NOTIFICATION, 0x82
> [ 1094.083630] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x00000000:0016A4BC) - 1 (beacon timer 234933060)
> [ 1094.206507] iwl3945: I iwl3945_rx_handle r = 55, i = 54, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1094.206522] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF: 0x00000000:001884D0) - 0 elapsed=122900 usec (124ms since last)
> [ 1094.207564] iwl3945: I iwl3945_rx_handle r = 57, i = 55, STATISTICS_NOTIFICATION, 0x9d
> [ 1094.207581] iwl3945: I iwl3945_rx_handle r = 57, i = 56, SCAN_START_NOTIFICATION, 0x82
> [ 1094.207590] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x00000000:00188921) - 1 (beacon timer 251688671)
> [ 1094.330718] iwl3945: I iwl3945_rx_handle r = 58, i = 57, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1094.330734] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF: 0x00000000:001A693F) - 0 elapsed=122910 usec (124ms since last)
> [ 1094.331595] iwl3945: I iwl3945_rx_handle r = 60, i = 58, STATISTICS_NOTIFICATION, 0x9d
> [ 1094.331609] iwl3945: I iwl3945_rx_handle r = 60, i = 59, SCAN_START_NOTIFICATION, 0x82
> [ 1094.331619] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0x00000000:001A6D8B) - 1 (beacon timer 268444277)
> [ 1094.454512] iwl3945: I iwl3945_rx_handle r = 61, i = 60, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1094.454528] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF: 0x00000000:001C4DA6) - 0 elapsed=122907 usec (124ms since last)
> [ 1094.455440] iwl3945: I iwl3945_rx_handle r = 63, i = 61, STATISTICS_NOTIFICATION, 0x9d
> [ 1094.455454] iwl3945: I iwl3945_rx_handle r = 63, i = 62, SCAN_START_NOTIFICATION, 0x82
> [ 1094.455463] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0x00000000:001C5174) - 1 (beacon timer 302079628)
> [ 1094.578359] iwl3945: I iwl3945_rx_handle r = 64, i = 63, SCAN_RESULTS_NOTIFICATION, 0x83
> [ 1094.578375] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF: 0x00000000:001E318F) - 0 elapsed=122907 usec (124ms since last)
> [ 1094.579376] iwl3945: I iwl3945_rx_handle r = 65, i = 64, SCAN_COMPLETE_NOTIFICATION, 0x84
> [ 1094.579386] iwl3945: I iwl3945_rx_scan_complete_notif Scan complete: 11 channels (TSF 0x001E3594:00000000) - 1
> [ 1094.579402] iwl3945: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 1366ms
> [ 1094.582562] iwl3945: U iwl3945_bg_request_scan Kicking off one indirect scan.
> [ 1094.582574] iwl3945: U iwl3945_get_channels_for_scan total channels to scan 0
> [ 1094.582588] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4416, 262 bytes at 22[32]:4
> [ 1094.582723] iwl3945: I iwl3945_rx_handle r = 66, i = 65, REPLY_SCAN_CMD, 0x80
> [ 1094.782750] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> [ 1094.782782] iwl3945: Start IWL Error Log Dump:
> [ 1094.782786] iwl3945: Status: 0x0002A2E4, count: 1
> [ 1094.782790] iwl3945: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
> [ 1094.782861] iwl3945: SYSASSERT     (#5) 0002183136 0x0089A 0x0025E 0x00304 0x0F0C6 75
> [ 1094.782864]
> [ 1094.782926] iwl3945: Start IWL Event Log Dump: display count 256, wraps 3
> [ 1094.782965] iwl3945: 0001201830      0x00008000      0350
> [ 1094.782995] iwl3945: 0001201843      0x000000d9      0106
> [ 1094.783031] iwl3945: 0001201844      0x00000000      0301
> [ 1094.783061] iwl3945: 0001201854      0x00008000      0350
> [ 1094.783091] iwl3945: 0001201871      0x000000d9      0106
> [ 1094.783121] iwl3945: 0001201873      0x00000000      0301
> [ 1094.783151] iwl3945: 0001201883      0x00008000      0350
> [ 1094.783181] iwl3945: 0001201909      0x000000d9      0106
> [ 1094.783211] iwl3945: 0001201911      0x00000000      0301
> [ 1094.783241] iwl3945: 0001201920      0x00008000      0350
> [ 1094.783271] iwl3945: 0001201930      0x000000d9      0106
> [ 1094.783307] iwl3945: 0001201931      0x00000000      0301
> [ 1094.783337] iwl3945: 0001201941      0x00008000      0350
> [ 1094.783367] iwl3945: 0001201950      0x000000d9      0106
> [ 1094.783397] iwl3945: 0001201952      0x00000000      0301
> [ 1094.783426] iwl3945: 0001202040      0x00000003      0353
> [ 1094.783456] iwl3945: 0001202049      0x00000000      0352
> [ 1094.783486] iwl3945: 0001202071      0x000000d9      0106
> [ 1094.783516] iwl3945: 0001202072      0x00000000      0301
> [ 1094.783546] iwl3945: 0001202082      0x00008000      0350
> [ 1094.783576] iwl3945: 0001202093      0x000000d9      0106
> [ 1094.783605] iwl3945: 0001202094      0x00000000      0301
> [ 1094.783635] iwl3945: 0001202104      0x00008000      0350
> [ 1094.783665] iwl3945: 0001202115      0x000000d9      0106
> [ 1094.783695] iwl3945: 0001202117      0x00000000      0301
> [ 1094.783700] iwl3945: 0001202126      0x00008000      0350
> [ 1094.783700] iwl3945: 0001202137      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001202138      0x00000000      0301
> [ 1094.783700] iwl3945: 0001202148      0x00008000      0350
> [ 1094.783700] iwl3945: 0001234668      0x0001e000      0723
> [ 1094.783700] iwl3945: 0001234669      0x00000005      0717
> [ 1094.783700] iwl3945: 0001234671      0x05050500      0706
> [ 1094.783700] iwl3945: 0001234675      0x05000300      0706
> [ 1094.783700] iwl3945: 0001234676      0x05050300      0725
> [ 1094.783700] iwl3945: 0001234677      0x00000000      0710
> [ 1094.783700] iwl3945: 0001234681      0x00000003      0732
> [ 1094.783700] iwl3945: 0001235369      0xffffff6d      0454
> [ 1094.783700] iwl3945: 0001235370      0x00000000      0472
> [ 1094.783700] iwl3945: 0001235378      0x00000005      0463
> [ 1094.783700] iwl3945: 0001235382      0x00000006      0719
> [ 1094.783700] iwl3945: 0001235383      0x03000304      0706
> [ 1094.783700] iwl3945: 0001235404      0x03000304      0725
> [ 1094.783700] iwl3945: 0001235405      0x00000004      0710
> [ 1094.783700] iwl3945: 0001235956      0x00000006      0463
> [ 1094.783700] iwl3945: 0001235957      0x00000006      0462
> [ 1094.783700] iwl3945: 0001235973      0x00000003      0733
> [ 1094.783700] iwl3945: 0001235983      0x00000006      0716
> [ 1094.783700] iwl3945: 0001235985      0x03040400      0706
> [ 1094.783700] iwl3945: 0001235986      0x00000006      0720
> [ 1094.783700] iwl3945: 0001235987      0x03040400      0725
> [ 1094.783700] iwl3945: 0001235988      0x00000000      0711
> [ 1094.783700] iwl3945: 0001235992      0x04000500      0706
> [ 1094.783700] iwl3945: 0001236006      0x04000500      0725
> [ 1094.783700] iwl3945: 0001236010      0x05000505      0706
> [ 1094.783700] iwl3945: 0001236026      0x05000505      0725
> [ 1094.783700] iwl3945: 0001242718      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001242720      0x00000000      0302
> [ 1094.783700] iwl3945: 0001242729      0x00008000      0350
> [ 1094.783700] iwl3945: 0001358891      0x0001e000      0723
> [ 1094.783700] iwl3945: 0001358892      0x00000006      0717
> [ 1094.783700] iwl3945: 0001358894      0x05050500      0706
> [ 1094.783700] iwl3945: 0001358898      0x05000300      0706
> [ 1094.783700] iwl3945: 0001358899      0x05050300      0725
> [ 1094.783700] iwl3945: 0001358900      0x00000000      0710
> [ 1094.783700] iwl3945: 0001358904      0x00000003      0732
> [ 1094.783700] iwl3945: 0001359592      0xffffff6e      0454
> [ 1094.783700] iwl3945: 0001359593      0x00000000      0472
> [ 1094.783700] iwl3945: 0001359601      0x00000006      0463
> [ 1094.783700] iwl3945: 0001359605      0x00000007      0719
> [ 1094.783700] iwl3945: 0001359606      0x03000304      0706
> [ 1094.783700] iwl3945: 0001359627      0x03000304      0725
> [ 1094.783700] iwl3945: 0001359628      0x00000004      0710
> [ 1094.783700] iwl3945: 0001359928      0x00000007      0463
> [ 1094.783700] iwl3945: 0001359930      0x00000007      0462
> [ 1094.783700] iwl3945: 0001359946      0x00000003      0733
> [ 1094.783700] iwl3945: 0001359955      0x00000007      0716
> [ 1094.783700] iwl3945: 0001359958      0x03040400      0706
> [ 1094.783700] iwl3945: 0001359959      0x00000007      0720
> [ 1094.783700] iwl3945: 0001359960      0x03040400      0725
> [ 1094.783700] iwl3945: 0001359961      0x00000000      0711
> [ 1094.783700] iwl3945: 0001359965      0x04000500      0706
> [ 1094.783700] iwl3945: 0001359979      0x04000500      0725
> [ 1094.783700] iwl3945: 0001359983      0x05000505      0706
> [ 1094.783700] iwl3945: 0001359999      0x05000505      0725
> [ 1094.783700] iwl3945: 0001437557      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001437559      0x00000000      0302
> [ 1094.783700] iwl3945: 0001437568      0x00008000      0350
> [ 1094.783700] iwl3945: 0001482864      0x0001e000      0723
> [ 1094.783700] iwl3945: 0001482865      0x00000007      0717
> [ 1094.783700] iwl3945: 0001482867      0x05050500      0706
> [ 1094.783700] iwl3945: 0001482871      0x05000300      0706
> [ 1094.783700] iwl3945: 0001482872      0x05050300      0725
> [ 1094.783700] iwl3945: 0001482873      0x00000000      0710
> [ 1094.783700] iwl3945: 0001482877      0x00000003      0732
> [ 1094.783700] iwl3945: 0001483565      0xffffff6e      0454
> [ 1094.783700] iwl3945: 0001483566      0x00000000      0472
> [ 1094.783700] iwl3945: 0001483574      0x00000007      0463
> [ 1094.783700] iwl3945: 0001483578      0x00000008      0719
> [ 1094.783700] iwl3945: 0001483579      0x03000304      0706
> [ 1094.783700] iwl3945: 0001483600      0x03000304      0725
> [ 1094.783700] iwl3945: 0001483601      0x00000004      0710
> [ 1094.783700] iwl3945: 0001483936      0x00000008      0463
> [ 1094.783700] iwl3945: 0001483937      0x00000008      0462
> [ 1094.783700] iwl3945: 0001483954      0x00000003      0733
> [ 1094.783700] iwl3945: 0001483963      0x00000008      0716
> [ 1094.783700] iwl3945: 0001483965      0x03040400      0706
> [ 1094.783700] iwl3945: 0001483966      0x00000008      0720
> [ 1094.783700] iwl3945: 0001483968      0x03040400      0725
> [ 1094.783700] iwl3945: 0001483968      0x00000000      0711
> [ 1094.783700] iwl3945: 0001483973      0x04000500      0706
> [ 1094.783700] iwl3945: 0001483986      0x04000500      0725
> [ 1094.783700] iwl3945: 0001483990      0x05000505      0706
> [ 1094.783700] iwl3945: 0001484006      0x05000505      0725
> [ 1094.783700] iwl3945: 0001538752      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001538753      0x00000000      0302
> [ 1094.783700] iwl3945: 0001538793      0x00000001      0353
> [ 1094.783700] iwl3945: 0001539873      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001539875      0x00000000      0302
> [ 1094.783700] iwl3945: 0001539883      0x00008000      0350
> [ 1094.783700] iwl3945: 0001543631      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001543633      0x00000000      0302
> [ 1094.783700] iwl3945: 0001543674      0x00000002      0353
> [ 1094.783700] iwl3945: 0001550844      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001550845      0x00000000      0302
> [ 1094.783700] iwl3945: 0001550852      0x00008000      0350
> [ 1094.783700] iwl3945: 0001606863      0x0001e000      0723
> [ 1094.783700] iwl3945: 0001606864      0x00000008      0717
> [ 1094.783700] iwl3945: 0001606866      0x05050500      0706
> [ 1094.783700] iwl3945: 0001606870      0x05000300      0706
> [ 1094.783700] iwl3945: 0001606871      0x05050300      0725
> [ 1094.783700] iwl3945: 0001606872      0x00000000      0710
> [ 1094.783700] iwl3945: 0001606876      0x00000003      0732
> [ 1094.783700] iwl3945: 0001607564      0xffffff6e      0454
> [ 1094.783700] iwl3945: 0001607565      0x00000000      0472
> [ 1094.783700] iwl3945: 0001607573      0x00000008      0463
> [ 1094.783700] iwl3945: 0001607577      0x00000009      0719
> [ 1094.783700] iwl3945: 0001607578      0x03000304      0706
> [ 1094.783700] iwl3945: 0001607599      0x03000304      0725
> [ 1094.783700] iwl3945: 0001607600      0x00000004      0710
> [ 1094.783700] iwl3945: 0001607942      0x00000009      0463
> [ 1094.783700] iwl3945: 0001607943      0x00000009      0462
> [ 1094.783700] iwl3945: 0001607959      0x00000003      0733
> [ 1094.783700] iwl3945: 0001607969      0x00000009      0716
> [ 1094.783700] iwl3945: 0001607971      0x03040400      0706
> [ 1094.783700] iwl3945: 0001607972      0x00000009      0720
> [ 1094.783700] iwl3945: 0001607973      0x03040400      0725
> [ 1094.783700] iwl3945: 0001607974      0x00000000      0711
> [ 1094.783700] iwl3945: 0001607978      0x04000500      0706
> [ 1094.783700] iwl3945: 0001607992      0x04000500      0725
> [ 1094.783700] iwl3945: 0001607996      0x05000505      0706
> [ 1094.783700] iwl3945: 0001608012      0x05000505      0725
> [ 1094.783700] iwl3945: 0001631842      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001631844      0x00000000      0302
> [ 1094.783700] iwl3945: 0001631852      0x00008000      0350
> [ 1094.783700] iwl3945: 0001637239      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001637240      0x00000000      0302
> [ 1094.783700] iwl3945: 0001637248      0x00008000      0350
> [ 1094.783700] iwl3945: 0001730878      0x0001e000      0723
> [ 1094.783700] iwl3945: 0001730879      0x00000009      0717
> [ 1094.783700] iwl3945: 0001730881      0x05050500      0706
> [ 1094.783700] iwl3945: 0001730885      0x05000300      0706
> [ 1094.783700] iwl3945: 0001730886      0x05050300      0725
> [ 1094.783700] iwl3945: 0001730887      0x00000000      0710
> [ 1094.783700] iwl3945: 0001730891      0x00000003      0732
> [ 1094.783700] iwl3945: 0001731579      0xffffff6e      0454
> [ 1094.783700] iwl3945: 0001731580      0x00000000      0472
> [ 1094.783700] iwl3945: 0001731588      0x00000009      0463
> [ 1094.783700] iwl3945: 0001731592      0x0000000a      0719
> [ 1094.783700] iwl3945: 0001731593      0x03000304      0706
> [ 1094.783700] iwl3945: 0001731614      0x03000304      0725
> [ 1094.783700] iwl3945: 0001731615      0x00000004      0710
> [ 1094.783700] iwl3945: 0001731951      0x0000000a      0463
> [ 1094.783700] iwl3945: 0001731952      0x0000000a      0462
> [ 1094.783700] iwl3945: 0001731969      0x00000003      0733
> [ 1094.783700] iwl3945: 0001731978      0x0000000a      0716
> [ 1094.783700] iwl3945: 0001731980      0x03040400      0706
> [ 1094.783700] iwl3945: 0001731981      0x0000000a      0720
> [ 1094.783700] iwl3945: 0001731983      0x03040400      0725
> [ 1094.783700] iwl3945: 0001731983      0x00000000      0711
> [ 1094.783700] iwl3945: 0001731988      0x04000500      0706
> [ 1094.783700] iwl3945: 0001732001      0x04000500      0725
> [ 1094.783700] iwl3945: 0001732005      0x05000505      0706
> [ 1094.783700] iwl3945: 0001732021      0x05000505      0725
> [ 1094.783700] iwl3945: 0001854885      0x0001e000      0723
> [ 1094.783700] iwl3945: 0001854886      0x0000000a      0717
> [ 1094.783700] iwl3945: 0001854888      0x05050500      0706
> [ 1094.783700] iwl3945: 0001854892      0x05000300      0706
> [ 1094.783700] iwl3945: 0001854893      0x05050300      0725
> [ 1094.783700] iwl3945: 0001854894      0x00000000      0710
> [ 1094.783700] iwl3945: 0001854898      0x00000003      0732
> [ 1094.783700] iwl3945: 0001855586      0xffffff6f      0454
> [ 1094.783700] iwl3945: 0001855587      0x00000000      0472
> [ 1094.783700] iwl3945: 0001855595      0x0000000a      0463
> [ 1094.783700] iwl3945: 0001855599      0x0000000b      0719
> [ 1094.783700] iwl3945: 0001855600      0x03000304      0706
> [ 1094.783700] iwl3945: 0001855621      0x03000304      0725
> [ 1094.783700] iwl3945: 0001855622      0x00000004      0710
> [ 1094.783700] iwl3945: 0001855833      0x0000000b      0463
> [ 1094.783700] iwl3945: 0001855834      0x0000000b      0462
> [ 1094.783700] iwl3945: 0001855850      0x00000003      0733
> [ 1094.783700] iwl3945: 0001855860      0x0000000b      0716
> [ 1094.783700] iwl3945: 0001855862      0x03040400      0706
> [ 1094.783700] iwl3945: 0001855863      0x0000000b      0720
> [ 1094.783700] iwl3945: 0001855864      0x03040400      0725
> [ 1094.783700] iwl3945: 0001855865      0x00000000      0711
> [ 1094.783700] iwl3945: 0001855869      0x04000500      0706
> [ 1094.783700] iwl3945: 0001855883      0x04000500      0725
> [ 1094.783700] iwl3945: 0001855887      0x05000505      0706
> [ 1094.783700] iwl3945: 0001855903      0x05000505      0725
> [ 1094.783700] iwl3945: 0001902749      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001902751      0x00000000      0302
> [ 1094.783700] iwl3945: 0001902791      0x00000001      0353
> [ 1094.783700] iwl3945: 0001918487      0x000000d9      0106
> [ 1094.783700] iwl3945: 0001918489      0x00000000      0302
> [ 1094.783700] iwl3945: 0001918518      0x00000002      0353
> [ 1094.783700] iwl3945: 0001978766      0x0001e000      0723
> [ 1094.783700] iwl3945: 0001978767      0x0000000b      0717
> [ 1094.783700] iwl3945: 0001978769      0x05050500      0706
> [ 1094.783700] iwl3945: 0001978770      0x05000600      0706
> [ 1094.783700] iwl3945: 0001978771      0x05050600      0725
> [ 1094.783700] iwl3945: 0001978772      0x00000000      0713
> [ 1094.783700] iwl3945: 0001978773      0x00000006      0732
> [ 1094.783700] iwl3945: 0001979410      0xffffff6f      0454
> [ 1094.783700] iwl3945: 0001979411      0x00000000      0472
> [ 1094.783700] iwl3945: 0001979419      0x0000000b      0463
> [ 1094.783700] iwl3945: 0001979424      0x00000001      0719
> [ 1094.783700] iwl3945: 0001979477      0x06000604      0706
> [ 1094.783700] iwl3945: 0001979482      0x06000604      0725
> [ 1094.783700] iwl3945: 0001979483      0x00000004      0713
> [ 1094.783700] iwl3945: 0001979760      0x00000001      0463
> [ 1094.783700] iwl3945: 0001979762      0x00000001      0462
> [ 1094.783700] iwl3945: 0001979785      0x00000006      0733
> [ 1094.783700] iwl3945: 0001979786      0x00000001      0720
> [ 1094.783700] iwl3945: 0001979787      0x06040600      0706
> [ 1094.783700] iwl3945: 0001979792      0x06000100      0706
> [ 1094.783700] iwl3945: 0001979794      0x06040100      0725
> [ 1094.783700] iwl3945: 0001979795      0x00000000      0708
> [ 1094.783700] iwl3945: 0001979796      0x00000001      0718
> [ 1094.783700] iwl3945: 0001979801      0x01000000      0706
> [ 1094.783700] iwl3945: 0001979802      0x00000000      0706
> [ 1094.783700] iwl3945: 0001979803      0x44140080      0703
> [ 1094.783700] iwl3945: 0001983086      0x44160080      0401
> [ 1094.783700] iwl3945: 0001983088      0x44160080      0700
> [ 1094.783700] iwl3945: 0001983091      0x00000000      0706
> [ 1094.783700] iwl3945: 0001983100      0x00000000      0452
> [ 1094.783700] iwl3945: 0001983101      0x00000000      0452
> [ 1094.783700] iwl3945: 0001983103      0x00000072      0601
> [ 1094.783700] iwl3945: 0001983111      0x00000100      0706
> [ 1094.783700] iwl3945: 0001983115      0x00000000      0708
> [ 1094.783700] iwl3945: 0001983120      0x01000300      0706
> [ 1094.783700] iwl3945: 0001983135      0x01000300      0725
> [ 1094.783700] iwl3945: 0001983136      0x00000000      0710
> [ 1094.783700] iwl3945: 0001983140      0x00000001      0729
> [ 1094.783700] iwl3945: 0001983141      0x00000003      0732
> [ 1094.783700] iwl3945: 0002183134      0x00000002      0123
> [ 1094.783700] iwl3945: 0002183137      0x00000100      0125
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd RX CONFIG:
> [ 1094.783700] iwl data: 00000000: 00 1b 77 dd 0c a7 00 00 00 00 00 00 00 00 00 00  ..w.............
> [ 1094.783700] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 00 00 15 03 00 00  ................
> [ 1094.783700] iwl data: 00000020: 05 80 00 00 04 00 00 00 01 00 00 00              ............
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd u16 channel: 0x1
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd u32 flags: 0x00008005
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd u8 dev_type: 0x3
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1b:77:dd:0c:a7
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
> [ 1094.783700] iwl3945: I iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
> [ 1094.783700] iwl3945: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
> [ 1094.783700] iwl3945: I iwl3945_rx_handle r = 67, i = 66, REPLY_ERROR, 0x02
> [ 1094.783700] iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq 0x4416 ser 0x0000004B
> [ 1094.792338] iwl3945: U __iwl3945_down iwl3945 is going down
> [ 1094.976813] iwl3945: Can't stop Rx DMA.
> [ 1095.793368] iwl3945: U iwl3945_hw_nic_stop_master stop master
> [ 1095.904061] iwl3945: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
> [ 1095.905139] iwl3945: U iwl3945_power_init_handle Initialize power
> [ 1095.905178] iwl3945: U iwl3945_power_init_handle adjust power command flags
> [ 1095.905389] iwl3945: U iwl3945_hw_nic_init HW Revision ID = 0x2
> [ 1095.905443] iwl3945: U iwl3945_hw_nic_init 3945 RADIO-MM type
> [ 1095.905456] iwl3945: U iwl3945_hw_nic_init SKU OP mode is basic
> [ 1095.905462] iwl3945: U iwl3945_hw_nic_init 3945ABG revision is 0xF1
> [ 1095.905475] iwl3945: U iwl3945_hw_nic_init Card M type B version is 0x2
> [ 1095.907666] iwl3945: U iwl3945_load_bsm Begin load bsm
> [ 1095.908933] iwl3945: U iwl3945_verify_bsm Begin verify bsm
> [ 1095.911178] iwl3945: U iwl3945_verify_bsm BSM bootstrap uCode image OK
> [ 1095.911238] iwl3945: U iwl3945_load_bsm BSM write complete, poll 1 iterations
> [ 1095.911276] iwl3945: U __iwl3945_up iwl3945 is coming up
> [ 1095.922896] iwl3945: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
> [ 1095.922900] iwl3945: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
> [ 1095.922903] iwl3945: I iwl3945_rx_reply_alive Initialization Alive received.
> [ 1095.928033] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [ 1095.928121] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 2668
> [ 1095.928400] iwl3945: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
> [ 1095.928403] iwl3945: U iwl3945_init_alive_start Initialization Alive received.
> [ 1095.928448] iwl3945: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
> [ 1095.932784] iwl3945: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
> [ 1095.932789] iwl3945: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
> [ 1095.932792] iwl3945: I iwl3945_rx_reply_alive Runtime Alive received.
> [ 1095.932833] iwl3945: I iwl3945_disable_events Selected uCode log events may be disabled
> [ 1095.932836] iwl3945: I iwl3945_disable_events   by writing "1"s into disable bitmap
> [ 1095.932839] iwl3945: I iwl3945_disable_events   in SRAM at 0x8015f4, size 47 u32s
> [ 1095.938030] iwl3945: U iwl3945_alive_start Runtime Alive received.
> [ 1095.938034] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 900
> [ 1095.938112] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 2668
> [ 1095.938189] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 80524
> [ 1095.945749] iwl3945: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
> [ 1095.945777] iwl3945: U iwl3945_alive_start RFKILL status: 0x1
> [ 1095.945799] iwl3945: U iwl3945_update_power_cmd Flags value = 0x00000008
> [ 1095.945802] iwl3945: U iwl3945_update_power_cmd Tx timeout = 0
> [ 1095.945804] iwl3945: U iwl3945_update_power_cmd Rx timeout = 0
> [ 1095.945807] iwl3945: U iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
> [ 1095.945813] iwl3945: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
> [ 1095.945910] iwl3945: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
> [ 1095.945927] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
> [ 1095.945990] iwl3945: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
> [ 1095.946005] iwl3945: U iwl3945_commit_rxon Sending RXON
> [ 1095.946007] * without RXON_FILTER_ASSOC_MSK
> [ 1095.946008] * channel = 1
> [ 1095.946008] * bssid = 00:00:00:00:00:00
> [ 1095.946013] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
> [ 1095.947404] iwl3945: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
> [ 1095.947461] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0d
> [ 1095.947465] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0f
> [ 1095.947468] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x05
> [ 1095.947471] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x07
> [ 1095.947474] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x09
> [ 1095.947477] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x0b
> [ 1095.947480] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x01
> [ 1095.947483] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  91 rate code 0x03
> [ 1095.947487] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x0a
> [ 1095.947490] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x14
> [ 1095.947493] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x37
> [ 1095.947496] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  96 rate code 0x6e
> [ 1095.947501] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
> [ 1095.947586] iwl3945: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [ 1095.947598] iwl3945: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
> [ 1095.947602] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
> [ 1095.947693] iwl3945: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
> [ 1095.947711] iwl3945: U iwl3945_send_add_station REPLY_ADD_STA PASSED
> [ 1095.947729] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
> [ 1095.947792] iwl3945: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
> [ 1095.947810] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
> [ 1095.947904] iwl3945: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
> [ 1095.947920] iwl3945: U iwl3945_hw_reg_txpower_get_temperature Temperature: 110
> [ 1095.947923] iwl3945: U is_temp_calib_needed Getting warmer, delta 9,
> [ 1095.947926] iwl3945: U is_temp_calib_needed Timed thermal calib needed
> [ 1095.947936] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  97 rate code 0x0d
> [ 1095.947940] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  97 rate code 0x0f
> [ 1095.947943] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  97 rate code 0x05
> [ 1095.947946] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  97 rate code 0x07
> [ 1095.947949] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  97 rate code 0x09
> [ 1095.947952] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  97 rate code 0x0b
> [ 1095.947955] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  97 rate code 0x01
> [ 1095.947958] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp  97 rate code 0x03
> [ 1095.947961] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 102 rate code 0x0a
> [ 1095.947965] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 102 rate code 0x14
> [ 1095.947968] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 102 rate code 0x37
> [ 1095.947971] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp 102 rate code 0x6e
> [ 1095.947975] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
> [ 1095.948074] iwl3945: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
> [ 1095.948627] Registered led device: iwl-phy1:radio
> [ 1095.948633] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
> [ 1095.948698] iwl3945: I iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
> [ 1095.949067] Registered led device: iwl-phy1:assoc
> [ 1095.949549] Registered led device: iwl-phy1:RX
> [ 1095.950262] Registered led device: iwl-phy1:TX
> [ 1095.950266] iwl3945: U iwl3945_alive_start ALIVE processing complete.
> [ 1096.566769] iwl3945: I iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
> [ 1096.669170] iwl3945: I iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
> [ 1096.771571] iwl3945: I iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
> [ 1096.873971] iwl3945: I iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
> [ 1096.976141] iwl3945: I iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
> [ 1097.078577] iwl3945: I iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
> [ 1097.181138] iwl3945: I iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
> [ 1097.385741] iwl3945: I iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
> [ 1097.590754] iwl3945: I iwl3945_rx_handle r = 20, i = 19, REPLY_3945_RX, 0x1b
> [ 1097.693162] iwl3945: I iwl3945_rx_handle r = 21, i = 20, REPLY_3945_RX, 0x1b
> [ 1098.000321] iwl3945: I iwl3945_rx_handle r = 22, i = 21, REPLY_3945_RX, 0x1b
> [ 1098.512347] iwl3945: I iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
> [ 1098.619023] iwl3945: I iwl3945_rx_handle r = 24, i = 23, REPLY_3945_RX, 0x1b
> [ 1098.716947] iwl3945: I iwl3945_rx_handle r = 25, i = 24, REPLY_3945_RX, 0x1b
> [ 1098.921744] iwl3945: I iwl3945_rx_handle r = 26, i = 25, REPLY_3945_RX, 0x1b
> [ 1099.024336] iwl3945: I iwl3945_rx_handle r = 27, i = 26, REPLY_3945_RX, 0x1b
> [ 1099.126665] iwl3945: I iwl3945_rx_handle r = 28, i = 27, REPLY_3945_RX, 0x1b
> [ 1099.229141] iwl3945: I iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
> [ 1099.331303] iwl3945: I iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
> [ 1099.433683] iwl3945: I iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
> [ 1099.575555] iwl3945: I iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
> [ 1099.638524] iwl3945: I iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
> [ 1099.740916] iwl3945: I iwl3945_rx_handle r = 34, i = 33, REPLY_3945_RX, 0x1b
> [ 1099.843534] iwl3945: I iwl3945_rx_handle r = 35, i = 34, REPLY_3945_RX, 0x1b
> [ 1099.945931] iwl3945: I iwl3945_rx_handle r = 36, i = 35, REPLY_3945_RX, 0x1b
> [ 1100.150727] iwl3945: I iwl3945_rx_handle r = 37, i = 36, REPLY_3945_RX, 0x1b
> [ 1100.253126] iwl3945: I iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
> [ 1100.355529] iwl3945: I iwl3945_rx_handle r = 39, i = 38, REPLY_3945_RX, 0x1b
> [ 1100.662723] iwl3945: I iwl3945_rx_handle r = 40, i = 39, REPLY_3945_RX, 0x1b
> [ 1100.969921] iwl3945: I iwl3945_rx_handle r = 41, i = 40, REPLY_3945_RX, 0x1b
> [ 1101.072081] iwl3945: I iwl3945_rx_handle r = 42, i = 41, REPLY_3945_RX, 0x1b
> [ 1101.174504] iwl3945: I iwl3945_rx_handle r = 43, i = 42, REPLY_3945_RX, 0x1b
> [ 1101.276859] iwl3945: I iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
> [ 1101.379259] iwl3945: I iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
> [ 1101.481682] iwl3945: I iwl3945_rx_handle r = 46, i = 45, REPLY_3945_RX, 0x1b
> [ 1101.584288] iwl3945: I iwl3945_rx_handle r = 47, i = 46, REPLY_3945_RX, 0x1b
> [ 1101.686715] iwl3945: I iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
> [ 1101.891502] iwl3945: I iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
> [ 1102.301106] iwl3945: I iwl3945_rx_handle r = 50, i = 49, REPLY_3945_RX, 0x1b
> [ 1102.403504] iwl3945: I iwl3945_rx_handle r = 51, i = 50, REPLY_3945_RX, 0x1b
> [ 1102.505904] iwl3945: I iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
> [ 1102.608295] iwl3945: I iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
> [ 1102.710500] iwl3945: I iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
> [ 1102.813104] iwl3945: I iwl3945_rx_handle r = 55, i = 54, REPLY_3945_RX, 0x1b
> [ 1103.837091] iwl3945: I iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
> [ 1103.939492] iwl3945: I iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
> [ 1104.553682] iwl3945: I iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
> [ 1104.656295] iwl3945: I iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
> [ 1104.758674] iwl3945: I iwl3945_rx_handle r = 60, i = 59, REPLY_3945_RX, 0x1b
> [ 1104.860884] iwl3945: I iwl3945_rx_handle r = 61, i = 60, REPLY_3945_RX, 0x1b
> [ 1104.963479] iwl3945: I iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
> [ 1105.065873] iwl3945: I iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
> [ 1105.168078] iwl3945: I iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
> [ 1105.270677] iwl3945: I iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
> [ 1105.372871] iwl3945: I iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
> [ 1105.782467] iwl3945: I iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
> [ 1106.192069] iwl3945: I iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
> [ 1106.294655] iwl3945: I iwl3945_rx_handle r = 69, i = 68, REPLY_3945_RX, 0x1b
> [ 1106.806656] iwl3945: I iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
> [ 1106.908824] iwl3945: I iwl3945_rx_handle r = 71, i = 70, REPLY_3945_RX, 0x1b
> [ 1107.011448] iwl3945: I iwl3945_rx_handle r = 72, i = 71, REPLY_3945_RX, 0x1b
> [ 1107.113846] iwl3945: I iwl3945_rx_handle r = 73, i = 72, REPLY_3945_RX, 0x1b
> [ 1107.216240] iwl3945: I iwl3945_rx_handle r = 74, i = 73, REPLY_3945_RX, 0x1b
> [ 1107.318647] iwl3945: I iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
> [ 1107.523440] iwl3945: I iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
> [ 1108.240230] iwl3945: I iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
> [ 1108.342632] iwl3945: I iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
> [ 1108.444825] iwl3945: I iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b
> [ 1108.547431] iwl3945: I iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
> [ 1108.649625] iwl3945: I iwl3945_rx_handle r = 81, i = 80, REPLY_3945_RX, 0x1b
> [ 1108.752220] iwl3945: I iwl3945_rx_handle r = 82, i = 81, REPLY_3945_RX, 0x1b
> [ 1108.854630] iwl3945: I iwl3945_rx_handle r = 83, i = 82, REPLY_3945_RX, 0x1b
> [ 1109.059430] iwl3945: I iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
> [ 1109.264015] iwl3945: I iwl3945_rx_handle r = 85, i = 84, REPLY_3945_RX, 0x1b
> [ 1109.366624] iwl3945: I iwl3945_rx_handle r = 86, i = 85, REPLY_3945_RX, 0x1b
> [ 1109.469011] iwl3945: I iwl3945_rx_handle r = 87, i = 86, REPLY_3945_RX, 0x1b
> [ 1109.571423] iwl3945: I iwl3945_rx_handle r = 88, i = 87, REPLY_3945_RX, 0x1b
> [ 1109.673817] iwl3945: I iwl3945_rx_handle r = 89, i = 88, REPLY_3945_RX, 0x1b
> [ 1109.776018] iwl3945: I iwl3945_rx_handle r = 90, i = 89, REPLY_3945_RX, 0x1b
> [ 1109.981022] iwl3945: I iwl3945_rx_handle r = 91, i = 90, REPLY_3945_RX, 0x1b
> [ 1110.083198] iwl3945: I iwl3945_rx_handle r = 92, i = 91, REPLY_3945_RX, 0x1b
> [ 1110.493012] iwl3945: I iwl3945_rx_handle r = 93, i = 92, REPLY_3945_RX, 0x1b
> [ 1110.595410] iwl3945: I iwl3945_rx_handle r = 94, i = 93, REPLY_3945_RX, 0x1b
> [ 1110.697804] iwl3945: I iwl3945_rx_handle r = 95, i = 94, REPLY_3945_RX, 0x1b
> [ 1110.800208] iwl3945: I iwl3945_rx_handle r = 96, i = 95, REPLY_3945_RX, 0x1b
> [ 1110.902412] iwl3945: I iwl3945_rx_handle r = 97, i = 96, REPLY_3945_RX, 0x1b
> [ 1110.968686] iwl3945: I iwl3945_rx_handle r = 98, i = 97, REPLY_3945_RX, 0x1b
> [ 1111.004997] iwl3945: I iwl3945_rx_handle r = 99, i = 98, REPLY_3945_RX, 0x1b
> [ 1111.107394] iwl3945: I iwl3945_rx_handle r = 100, i = 99, REPLY_3945_RX, 0x1b
> [ 1111.209809] iwl3945: I iwl3945_rx_handle r = 101, i = 100, REPLY_3945_RX, 0x1b
> [ 1112.028990] iwl3945: I iwl3945_rx_handle r = 102, i = 101, REPLY_3945_RX, 0x1b
> [ 1112.131389] iwl3945: I iwl3945_rx_handle r = 103, i = 102, REPLY_3945_RX, 0x1b
> [ 1112.233789] iwl3945: I iwl3945_rx_handle r = 104, i = 103, REPLY_3945_RX, 0x1b
> [ 1112.336191] iwl3945: I iwl3945_rx_handle r = 105, i = 104, REPLY_3945_RX, 0x1b
> [ 1112.438582] iwl3945: I iwl3945_rx_handle r = 106, i = 105, REPLY_3945_RX, 0x1b
> [ 1112.540984] iwl3945: I iwl3945_rx_handle r = 107, i = 106, REPLY_3945_RX, 0x1b
> [ 1112.643394] iwl3945: I iwl3945_rx_handle r = 108, i = 107, REPLY_3945_RX, 0x1b
> [ 1112.745597] iwl3945: I iwl3945_rx_handle r = 109, i = 108, REPLY_3945_RX, 0x1b
> [ 1112.848189] iwl3945: I iwl3945_rx_handle r = 110, i = 109, REPLY_3945_RX, 0x1b
> [ 1113.667181] iwl3945: I iwl3945_rx_handle r = 111, i = 110, REPLY_3945_RX, 0x1b
> [ 1113.769770] iwl3945: I iwl3945_rx_handle r = 112, i = 111, REPLY_3945_RX, 0x1b
> [ 1113.974379] iwl3945: I iwl3945_rx_handle r = 113, i = 112, REPLY_3945_RX, 0x1b
> [ 1114.076759] iwl3945: I iwl3945_rx_handle r = 114, i = 113, REPLY_3945_RX, 0x1b
> [ 1114.179365] iwl3945: I iwl3945_rx_handle r = 115, i = 114, REPLY_3945_RX, 0x1b
> [ 1114.191468] iwl3945: U iwl3945_pci_remove *** UNLOAD DRIVER ***
> [ 1114.191482] iwl3945: U __iwl3945_down iwl3945 is going down
> [ 1114.193251] iwl3945: U iwl3945_hw_nic_stop_master stop master
> [ 1114.303935] iwl3945: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
> [ 1114.333093] iwl3945: U iwl3945_mac_remove_interface enter
> [ 1114.333106] iwl3945: U iwl3945_mac_remove_interface leave
> [ 1114.336945] iwl3945: U iwl3945_mac_stop enter
> [ 1114.336957] iwl3945: U __iwl3945_down iwl3945 is going down
> [ 1114.337037] iwl3945: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
> [ 1114.337603] iwl3945: U iwl3945_mac_stop leave

