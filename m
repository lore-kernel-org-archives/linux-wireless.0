Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:42026 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab3DZSRL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 14:17:11 -0400
Date: Fri, 26 Apr 2013 11:17:06 -0700
From: Jonathan McDowell <noodles@earth.li>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: [Ilw] Firmware problems with Intel 2230 and AP mode
Message-ID: <20130426181706.GY31591@earth.li> (sfid-20130426_201717_861202_46E9FEAC)
References: <20130402190831.GQ31591@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB301965EC0@HASMSX103.ger.corp.intel.com>
 <20130403182153.GT31591@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130403182153.GT31591@earth.li>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 03, 2013 at 11:21:53AM -0700, Jonathan McDowell wrote:
> On Tue, Apr 02, 2013 at 07:11:12PM +0000, Grumbach, Emmanuel wrote:
> > > 
> > > I'm trying to build my own wifi router, cobbling together a Debian
> > > (wheezy) box, hostapd (1.0) and an Intel 2230. I'm seeing various
> > > problems with the 2230 and I'm wondering if I'm mad for trying to use
> > > this card in AP mode (in which case is there an alternative Intel card I
> > > should use, or is an ath9k my best bet), or if it's worthwhile reporting
> > > the issues and trying fixes.

> Then overnight it completely died (should have been very little traffic
> going on). Required an iwldwm module unload and reload to recover:

Running with 3.9.0-rc8 + the patch that fixes the tx_queue mismatch
error I'm still seeing firmware errors every few days that require a
module unload + reload to recover from. They all seem to be
ADVANCED_SYSASSERT 0x00001057 followed by a number of ADVANCED_SYSASSERT
0x000014E1 when the driver attempts to reload the firmware:

Mar 24 11:53:29 ramen kernel: [71318.392715] iwlwifi 0000:04:00.0: 0x00001057 | ADVANCED_SYSASSERT
Apr  3 00:08:39 ramen kernel: [36492.159448] iwlwifi 0000:04:00.0: 0x00001057 | ADVANCED_SYSASSERT
Apr  6 20:04:09 ramen kernel: [170492.160556] iwlwifi 0000:04:00.0: 0x00001057 | ADVANCED_SYSASSERT
Apr 19 17:30:28 ramen kernel: [101024.330427] iwlwifi 0000:04:00.0: 0x00001057 | ADVANCED_SYSASSERT
Apr 26 00:29:08 ramen kernel: [309090.750943] iwlwifi 0000:04:00.0: 0x00001057 | ADVANCED_SYSASSERT

(I can provide full logs if that helps but they all seem to be of the
same format as below. The March 24th instance is with 3.8.4 but the
others are during the 3.9.0-rc testing I did for the tx_mismatch issue.)

> [35462.193200] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_disable Deactivate queue 14
> [36401.249027] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can proceed: ssn = next_recl = 146
> [36401.251395] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 14 on FIFO 4 WrPtr: 146
> [36406.863887] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 146
> [36406.863921] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_disable Deactivate queue 14
> [36492.120485] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
> [36492.121142] iwlwifi 0000:04:00.0: CSR values:
> [36492.121820] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [36492.122558] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c80b08
> [36492.123327] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [36492.124107] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
> [36492.124880] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [36492.125679] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
> [36492.126485] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
> [36492.127314] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [36492.128129] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [36492.128972] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X000000c8
> [36492.129856] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X8ff30ffd
> [36492.130749] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000801
> [36492.131647] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00030001
> [36492.132555] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080044
> [36492.133465] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X0000d197
> [36492.134391] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000080
> [36492.135317] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [36492.136255] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [36492.137195] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000040
> [36492.138158] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88409dc6
> [36492.139128] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X29800200
> [36492.140114] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [36492.141120] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [36492.142172] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [36492.143217] iwlwifi 0000:04:00.0: FH register values:
> [36492.144282] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X408a7b00
> [36492.145405] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X04088d70
> [36492.146559] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000010
> [36492.147728] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [36492.148926] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [36492.150153] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [36492.151401] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [36492.152681] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [36492.153984] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [36492.155285] iwlwifi 0000:04:00.0: Loaded firmware version: 18.168.6.1
> [36492.156729] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
> [36492.158080] iwlwifi 0000:04:00.0: Status: 0x0000004C, count: 6
> [36492.159448] iwlwifi 0000:04:00.0: 0x00001057 | ADVANCED_SYSASSERT          
> [36492.160842] iwlwifi 0000:04:00.0: 0x0000D104 | uPc
> [36492.162248] iwlwifi 0000:04:00.0: 0x0000D102 | branchlink1
> [36492.163662] iwlwifi 0000:04:00.0: 0x0000D102 | branchlink2
> [36492.165077] iwlwifi 0000:04:00.0: 0x0000EC7A | interruptlink1
> [36492.166539] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
> [36492.168013] iwlwifi 0000:04:00.0: 0x00000000 | data1
> [36492.169486] iwlwifi 0000:04:00.0: 0x00000000 | data2
> [36492.170967] iwlwifi 0000:04:00.0: 0x000007C6 | line
> [36492.172447] iwlwifi 0000:04:00.0: 0x7EC0DF0B | beacon time
> [36492.173952] iwlwifi 0000:04:00.0: 0x7BD8E0F5 | tsf low
> [36492.175459] iwlwifi 0000:04:00.0: 0x00000008 | tsf hi
> [36492.176980] iwlwifi 0000:04:00.0: 0x0000DF15 | time gp1
> [36492.178513] iwlwifi 0000:04:00.0: 0x7BF31FD1 | time gp2
> [36492.179958] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
> [36492.181421] iwlwifi 0000:04:00.0: 0x754312A8 | uCode version
> [36492.182899] iwlwifi 0000:04:00.0: 0x000000C8 | hw version
> [36492.184385] iwlwifi 0000:04:00.0: 0x00C80B08 | board version
> [36492.185894] iwlwifi 0000:04:00.0: 0x0508001C | hcmd
> [36492.187409] iwlwifi 0000:04:00.0: 0x2FF63010 | isr0
> [36492.188927] iwlwifi 0000:04:00.0: 0x01C1E000 | isr1
> [36492.190455] iwlwifi 0000:04:00.0: 0x00000F1E | isr2
> [36492.191989] iwlwifi 0000:04:00.0: 0x8147F8C3 | isr3
> [36492.193529] iwlwifi 0000:04:00.0: 0x00000000 | isr4
> [36492.195087] iwlwifi 0000:04:00.0: 0x10800112 | isr_pref
> [36492.196647] iwlwifi 0000:04:00.0: 0x0000FD98 | wait_event
> [36492.198178] iwlwifi 0000:04:00.0: 0x00001148 | l2p_control
> [36492.199661] iwlwifi 0000:04:00.0: 0x0000003C | l2p_duration
> [36492.201116] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
> [36492.202590] iwlwifi 0000:04:00.0: 0x00022D76 | l2p_addr_match
> [36492.204011] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
> [36492.205392] iwlwifi 0000:04:00.0: 0x13011054 | timestamp
> [36492.206780] iwlwifi 0000:04:00.0: 0x00001020 | flow_handler
> [36492.208219] iwlwifi 0000:04:00.0: Start IWL Event Log Dump: display last 20 entries
> [36492.209675] iwlwifi 0000:04:00.0: EVT_LOGT:2079520373:0x00000008:0220
> [36492.211127] iwlwifi 0000:04:00.0: EVT_LOGT:2079520413:0x00040000:1243
> [36492.212573] iwlwifi 0000:04:00.0: EVT_LOGT:2079520509:0x00000040:1243
> [36492.214016] iwlwifi 0000:04:00.0: EVT_LOGT:2079520526:0x0508001c:0206
> [36492.215455] iwlwifi 0000:04:00.0: EVT_LOGT:2079520527:0x00000001:0204
> [36492.216901] iwlwifi 0000:04:00.0: EVT_LOGT:2079520531:0x01000101:0211
> [36492.218337] iwlwifi 0000:04:00.0: EVT_LOGT:2079520532:0x00000001:0219
> [36492.219760] iwlwifi 0000:04:00.0: EVT_LOGT:2079520535:0x00000100:1243
> [36492.221176] iwlwifi 0000:04:00.0: EVT_LOGT:2079520537:0x00000000:0212
> [36492.222588] iwlwifi 0000:04:00.0: EVT_LOGT:2079520780:0x00000000:0215
> [36492.223995] iwlwifi 0000:04:00.0: EVT_LOGT:2079520782:0x000000ad:1600
> [36492.225398] iwlwifi 0000:04:00.0: EVT_LOGT:2079520783:0x00000000:1629
> [36492.226801] iwlwifi 0000:04:00.0: EVT_LOGT:2079520784:0x00000008:0220
> [36492.228203] iwlwifi 0000:04:00.0: EVT_LOGT:2079520823:0x00000000:0302
> [36492.229602] iwlwifi 0000:04:00.0: EVT_LOGT:2079520862:0x00002000:1243
> [36492.230992] iwlwifi 0000:04:00.0: EVT_LOGT:2079520903:0x05801007:0310
> [36492.232376] iwlwifi 0000:04:00.0: EVT_LOGT:2079520903:0x0000028b:1623
> [36492.233770] iwlwifi 0000:04:00.0: EVT_LOGT:2079520904:0x03482100:0590
> [36492.235142] iwlwifi 0000:04:00.0: EVT_LOGT:2079520906:0x00000010:1392
> [36492.236504] iwlwifi 0000:04:00.0: EVT_LOGT:2079530967:0x00000000:0125
> [36492.238126] ieee80211 phy0: Hardware restart was requested
> [36492.239493] iwlwifi 0000:04:00.0: L1 Disabled; Enabling L0S
> [36492.248340] iwlwifi 0000:04:00.0: Radio type=0x2-0x0-0x0
> [36492.418121] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 9 on FIFO 7 WrPtr: 0
> [36492.418359] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 0 on FIFO 3 WrPtr: 0
> [36492.418461] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 1 on FIFO 2 WrPtr: 0
> [36492.418562] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 2 on FIFO 1 WrPtr: 0
> [36492.418664] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 3 on FIFO 0 WrPtr: 0
> [36492.418765] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 4 on FIFO 0 WrPtr: 0
> [36492.418866] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 5 on FIFO 4 WrPtr: 0
> [36492.418968] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 6 on FIFO 2 WrPtr: 0
> [36492.419069] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 7 on FIFO 5 WrPtr: 0
> [36492.419170] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 8 on FIFO 4 WrPtr: 0
> [36492.419271] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 10 on FIFO 5 WrPtr: 0
> [36492.428962] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
> [36492.430346] iwlwifi 0000:04:00.0: CSR values:
> [36492.431692] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [36492.433079] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c80b08
> [36492.434475] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X0000ff40
> [36492.435863] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
> [36492.437231] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [36492.438609] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
> [36492.439955] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
> [36492.441287] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [36492.442613] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [36492.443937] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X000000c8
> [36492.445253] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X8ff30ffd
> [36492.446590] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000801
> [36492.447928] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00030001
> [36492.449263] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080044
> [36492.450613] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X0000000a
> [36492.451973] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000080
> [36492.453325] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [36492.454681] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [36492.456029] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
> [36492.457367] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88409dc6
> [36492.458728] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X29800200
> [36492.460107] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [36492.461473] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [36492.462848] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [36492.464222] iwlwifi 0000:04:00.0: FH register values:
> [36492.465596] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X408a7b00
> [36492.467024] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X04088d70
> [36492.468461] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000030
> [36492.469922] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [36492.471394] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [36492.472876] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [36492.474383] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [36492.475906] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [36492.477430] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [36492.478957] iwlwifi 0000:04:00.0: Loaded firmware version: 18.168.6.1
> [36492.480618] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
> [36492.482169] iwlwifi 0000:04:00.0: Status: 0x0000004C, count: 6
> [36492.483747] iwlwifi 0000:04:00.0: 0x000014E1 | ADVANCED_SYSASSERT          
> [36492.485313] iwlwifi 0000:04:00.0: 0x0001A564 | uPc
> [36492.486869] iwlwifi 0000:04:00.0: 0x0001A5CA | branchlink1
> [36492.488430] iwlwifi 0000:04:00.0: 0x0001A5CA | branchlink2
> [36492.489957] iwlwifi 0000:04:00.0: 0x0000EC7A | interruptlink1
> [36492.491473] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
> [36492.492969] iwlwifi 0000:04:00.0: 0x00000000 | data1
> [36492.494473] iwlwifi 0000:04:00.0: 0x00000000 | data2
> [36492.495975] iwlwifi 0000:04:00.0: 0x000000A2 | line
> [36492.497460] iwlwifi 0000:04:00.0: 0x000185E1 | beacon time
> [36492.498969] iwlwifi 0000:04:00.0: 0x00000A1F | tsf low
> [36492.500482] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
> [36492.501986] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
> [36492.503494] iwlwifi 0000:04:00.0: 0x0000BB5F | time gp2
> [36492.504987] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
> [36492.506492] iwlwifi 0000:04:00.0: 0x754312A8 | uCode version
> [36492.508009] iwlwifi 0000:04:00.0: 0x000000C8 | hw version
> [36492.509516] iwlwifi 0000:04:00.0: 0x00C80B08 | board version
> [36492.511037] iwlwifi 0000:04:00.0: 0x0500001C | hcmd
> [36492.512563] iwlwifi 0000:04:00.0: 0x02023010 | isr0
> [36492.514083] iwlwifi 0000:04:00.0: 0x0081E000 | isr1
> [36492.515607] iwlwifi 0000:04:00.0: 0x00000602 | isr2
> [36492.517115] iwlwifi 0000:04:00.0: 0x0145FCC1 | isr3
> [36492.518624] iwlwifi 0000:04:00.0: 0x00000000 | isr4
> [36492.520139] iwlwifi 0000:04:00.0: 0x00020110 | isr_pref
> [36492.521614] iwlwifi 0000:04:00.0: 0x000000F1 | wait_event
> [36492.523082] iwlwifi 0000:04:00.0: 0x00000000 | l2p_control
> [36492.524549] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
> [36492.525980] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
> [36492.527390] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
> [36492.528759] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
> [36492.530103] iwlwifi 0000:04:00.0: 0x13011054 | timestamp
> [36492.531455] iwlwifi 0000:04:00.0: 0x00003038 | flow_handler
> [36492.532850] iwlwifi 0000:04:00.0: Start IWL Event Log Dump: display last 20 entries
> [36492.534258] iwlwifi 0000:04:00.0: EVT_LOGT:0000047618:0x00000118:0106
> [36492.535673] iwlwifi 0000:04:00.0: EVT_LOGT:0000047618:0x00000018:0107
> [36492.537068] iwlwifi 0000:04:00.0: EVT_LOGT:0000047621:0x0000ba05:1110
> [36492.538469] iwlwifi 0000:04:00.0: EVT_LOGT:0000047685:0x00000032:1111
> [36492.539863] iwlwifi 0000:04:00.0: EVT_LOGT:0000047686:0x00000032:0454
> [36492.541267] iwlwifi 0000:04:00.0: EVT_LOGT:0000047687:0x00000000:0472
> [36492.542644] iwlwifi 0000:04:00.0: EVT_LOGT:0000047692:0x00000032:0487
> [36492.544014] iwlwifi 0000:04:00.0: EVT_LOGT:0000047695:0x00000000:0663
> [36492.545371] iwlwifi 0000:04:00.0: EVT_LOGT:0000047696:0x00000032:1592
> [36492.546736] iwlwifi 0000:04:00.0: EVT_LOGT:0000047697:0x00000013:1551
> [36492.548092] iwlwifi 0000:04:00.0: EVT_LOGT:0000047700:0x09250091:0401
> [36492.549449] iwlwifi 0000:04:00.0: EVT_LOGT:0000047701:0x00000007:0456
> [36492.550805] iwlwifi 0000:04:00.0: EVT_LOGT:0000047737:0x09260018:0401
> [36492.552167] iwlwifi 0000:04:00.0: EVT_LOGT:0000047782:0x0927004e:0401
> [36492.553519] iwlwifi 0000:04:00.0: EVT_LOGT:0000047836:0x09280018:0401
> [36492.554868] iwlwifi 0000:04:00.0: EVT_LOGT:0000047853:0x00000000:0302
> [36492.556207] iwlwifi 0000:04:00.0: EVT_LOGT:0000047865:0x00002000:0350
> [36492.557539] iwlwifi 0000:04:00.0: EVT_LOGT:0000047881:0x09290018:0401
> [36492.558866] iwlwifi 0000:04:00.0: EVT_LOGT:0000047958:0x00000040:1243
> [36492.560184] iwlwifi 0000:04:00.0: EVT_LOGT:0000047973:0x00000000:0125
> [36492.561798] ieee80211 phy0: Hardware restart was requested
> [36492.563164] iwlwifi 0000:04:00.0: L1 Disabled; Enabling L0S
> [36492.571997] iwlwifi 0000:04:00.0: Radio type=0x2-0x0-0x0
> [36492.746535] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 9 on FIFO 7 WrPtr: 0
> [36492.746769] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 0 on FIFO 3 WrPtr: 0
> [36492.746869] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 1 on FIFO 2 WrPtr: 0
> [36492.746969] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 2 on FIFO 1 WrPtr: 0
> [36492.747068] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 3 on FIFO 0 WrPtr: 0
> [36492.747167] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 4 on FIFO 0 WrPtr: 0
> [36492.747266] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 5 on FIFO 4 WrPtr: 0
> [36492.747365] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 6 on FIFO 2 WrPtr: 0
> [36492.747465] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 7 on FIFO 5 WrPtr: 0
> [36492.747565] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 8 on FIFO 4 WrPtr: 0
> [36492.747664] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 10 on FIFO 5 WrPtr: 0
> [36492.859059] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
> [36492.860382] iwlwifi 0000:04:00.0: CSR values:
> [36492.861674] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [36492.863033] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c80b08
> [36492.864374] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [36492.865704] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
> [36492.867042] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [36492.868346] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
> [36492.869652] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
> [36492.870946] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [36492.872221] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [36492.873493] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X000000c8
> [36492.874780] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X8ff30ffd
> [36492.876067] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000801
> [36492.877359] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00030001
> [36492.878662] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080044
> [36492.879962] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000086
> [36492.881272] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000080
> [36492.882587] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [36492.883897] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [36492.885192] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
> [36492.886498] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88409dc6
> [36492.887815] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X29800200
> [36492.889140] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [36492.890483] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [36492.891827] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [36492.893168] iwlwifi 0000:04:00.0: FH register values:
> [36492.894521] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X408a7b00
> [36492.895911] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X04088d70
> [36492.897313] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000030
> [36492.898745] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [36492.900187] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [36492.901648] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [36492.903125] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [36492.904618] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [36492.906128] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [36492.907637] iwlwifi 0000:04:00.0: Loaded firmware version: 18.168.6.1
> [36492.909270] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
> [36492.910800] iwlwifi 0000:04:00.0: Status: 0x0000004C, count: 6
> [36492.912342] iwlwifi 0000:04:00.0: 0x000014E1 | ADVANCED_SYSASSERT          
> [36492.913900] iwlwifi 0000:04:00.0: 0x0001A564 | uPc
> [36492.915454] iwlwifi 0000:04:00.0: 0x0001A5CA | branchlink1
> [36492.916996] iwlwifi 0000:04:00.0: 0x0001A5CA | branchlink2
> [36492.918511] iwlwifi 0000:04:00.0: 0x0000EC7A | interruptlink1
> [36492.920001] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
> [36492.921492] iwlwifi 0000:04:00.0: 0x00000000 | data1
> [36492.922989] iwlwifi 0000:04:00.0: 0x00000000 | data2
> [36492.924472] iwlwifi 0000:04:00.0: 0x000000A2 | line
> [36492.925952] iwlwifi 0000:04:00.0: 0x00418978 | beacon time
> [36492.927447] iwlwifi 0000:04:00.0: 0x00019688 | tsf low
> [36492.928938] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
> [36492.930426] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
> [36492.931924] iwlwifi 0000:04:00.0: 0x00024F2F | time gp2
> [36492.933412] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
> [36492.934902] iwlwifi 0000:04:00.0: 0x754312A8 | uCode version
> [36492.936392] iwlwifi 0000:04:00.0: 0x000000C8 | hw version
> [36492.937885] iwlwifi 0000:04:00.0: 0x00C80B08 | board version
> [36492.939399] iwlwifi 0000:04:00.0: 0x0925001C | hcmd
> [36492.940903] iwlwifi 0000:04:00.0: 0x27C63040 | isr0
> [36492.942405] iwlwifi 0000:04:00.0: 0x0181E000 | isr1
> [36492.943917] iwlwifi 0000:04:00.0: 0x00000E02 | isr2
> [36492.945421] iwlwifi 0000:04:00.0: 0x0141FCC3 | isr3
> [36492.946928] iwlwifi 0000:04:00.0: 0x00000000 | isr4
> [36492.948431] iwlwifi 0000:04:00.0: 0x00080110 | isr_pref
> [36492.949906] iwlwifi 0000:04:00.0: 0x00029B36 | wait_event
> [36492.951388] iwlwifi 0000:04:00.0: 0x0000470B | l2p_control
> [36492.952844] iwlwifi 0000:04:00.0: 0x00004418 | l2p_duration
> [36492.954275] iwlwifi 0000:04:00.0: 0x00000003 | l2p_mhvalid
> [36492.955690] iwlwifi 0000:04:00.0: 0x00200A30 | l2p_addr_match
> [36492.957072] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
> [36492.958426] iwlwifi 0000:04:00.0: 0x13011054 | timestamp
> [36492.959786] iwlwifi 0000:04:00.0: 0x00003040 | flow_handler
> [36492.961197] iwlwifi 0000:04:00.0: Start IWL Event Log Dump: display last 20 entries
> [36492.962615] iwlwifi 0000:04:00.0: EVT_LOGT:0000148218:0x00000000:0301
> [36492.964035] iwlwifi 0000:04:00.0: EVT_LOGT:0000148320:0x00002000:1243
> [36492.965443] iwlwifi 0000:04:00.0: EVT_LOGT:0000148348:0x00040000:1243
> [36492.966846] iwlwifi 0000:04:00.0: EVT_LOGT:0000148853:0x00000000:0301
> [36492.968245] iwlwifi 0000:04:00.0: EVT_LOGT:0000148953:0x00040000:1243
> [36492.969637] iwlwifi 0000:04:00.0: EVT_LOGT:0000148961:0x00000000:0301
> [36492.971023] iwlwifi 0000:04:00.0: EVT_LOGT:0000149059:0x00040000:1243
> [36492.972410] iwlwifi 0000:04:00.0: EVT_LOGT:0000149327:0x00000000:0301
> [36492.973783] iwlwifi 0000:04:00.0: EVT_LOGT:0000149428:0x00040000:1243
> [36492.975151] iwlwifi 0000:04:00.0: EVT_LOGT:0000149443:0x00000000:0302
> [36492.976513] iwlwifi 0000:04:00.0: EVT_LOGT:0000149485:0x00040000:1243
> [36492.977875] iwlwifi 0000:04:00.0: EVT_LOGT:0000150167:0x00000000:0302
> [36492.979231] iwlwifi 0000:04:00.0: EVT_LOGT:0000150208:0x00040000:1243
> [36492.980596] iwlwifi 0000:04:00.0: EVT_LOGT:0000151071:0x00000000:0302
> [36492.981953] iwlwifi 0000:04:00.0: EVT_LOGT:0000151112:0x00040000:1243
> [36492.983297] iwlwifi 0000:04:00.0: EVT_LOGT:0000151291:0x00019002:1388
> [36492.984630] iwlwifi 0000:04:00.0: EVT_LOGT:0000151298:0x00049c00:1386
> [36492.985957] iwlwifi 0000:04:00.0: EVT_LOGT:0000151299:0x00049c00:1386
> [36492.987274] iwlwifi 0000:04:00.0: EVT_LOGT:0000151335:0x00000040:1243
> [36492.988583] iwlwifi 0000:04:00.0: EVT_LOGT:0000151350:0x00000000:0125
> [36492.990142] ieee80211 phy0: Hardware restart was requested
> [36492.991470] iwlwifi 0000:04:00.0: L1 Disabled; Enabling L0S
> [36493.000263] iwlwifi 0000:04:00.0: Radio type=0x2-0x0-0x0
> [36493.171052] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 9 on FIFO 7 WrPtr: 0
> [36493.171291] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 0 on FIFO 3 WrPtr: 0
> [36493.171393] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 1 on FIFO 2 WrPtr: 0
> [36493.171494] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 2 on FIFO 1 WrPtr: 0
> [36493.171595] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 3 on FIFO 0 WrPtr: 0
> [36493.171696] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 4 on FIFO 0 WrPtr: 0
> [36493.171798] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 5 on FIFO 4 WrPtr: 0
> [36493.171899] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 6 on FIFO 2 WrPtr: 0
> [36493.172000] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 7 on FIFO 5 WrPtr: 0
> [36493.172101] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 8 on FIFO 4 WrPtr: 0
> [36493.172202] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 10 on FIFO 5 WrPtr: 0
> [36493.283645] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
> [36493.285003] iwlwifi 0000:04:00.0: CSR values:
> [36493.286306] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [36493.287671] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c80b08
> [36493.289038] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [36493.290376] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
> [36493.291745] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [36493.293072] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
> [36493.294374] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
> [36493.295681] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [36493.296960] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [36493.298232] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X000000c8
> [36493.299519] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X8ff30ffd
> [36493.300814] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000801
> [36493.302104] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00030001
> [36493.303417] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080044
> [36493.304746] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000086
> [36493.306051] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000080
> [36493.307373] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [36493.308695] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [36493.309994] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
> [36493.311310] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88409dc6
> [36493.312649] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X29800200
> [36493.313973] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [36493.315330] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [36493.316681] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [36493.318022] iwlwifi 0000:04:00.0: FH register values:
> [36493.319379] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X408a7b00
> [36493.320779] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X04088d70
> [36493.322184] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000038
> [36493.323616] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [36493.325063] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [36493.326517] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [36493.328025] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [36493.329547] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [36493.331086] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [36493.332612] iwlwifi 0000:04:00.0: Loaded firmware version: 18.168.6.1
> [36493.334272] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
> [36493.335824] iwlwifi 0000:04:00.0: Status: 0x0000004C, count: 6
> [36493.337377] iwlwifi 0000:04:00.0: 0x000014E1 | ADVANCED_SYSASSERT          
> [36493.338950] iwlwifi 0000:04:00.0: 0x0001A564 | uPc
> [36493.340509] iwlwifi 0000:04:00.0: 0x0001A5CA | branchlink1
> [36493.342037] iwlwifi 0000:04:00.0: 0x0001A5CA | branchlink2
> [36493.343537] iwlwifi 0000:04:00.0: 0x0000EC7A | interruptlink1
> [36493.345015] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
> [36493.346494] iwlwifi 0000:04:00.0: 0x00000000 | data1
> [36493.347984] iwlwifi 0000:04:00.0: 0x00000000 | data2
> [36493.349462] iwlwifi 0000:04:00.0: 0x000000A2 | line
> [36493.350930] iwlwifi 0000:04:00.0: 0x004188E1 | beacon time
> [36493.352416] iwlwifi 0000:04:00.0: 0x0001971F | tsf low
> [36493.353897] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
> [36493.355383] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
> [36493.356861] iwlwifi 0000:04:00.0: 0x00024B6D | time gp2
> [36493.358340] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
> [36493.359823] iwlwifi 0000:04:00.0: 0x754312A8 | uCode version
> [36493.361335] iwlwifi 0000:04:00.0: 0x000000C8 | hw version
> [36493.362828] iwlwifi 0000:04:00.0: 0x00C80B08 | board version
> [36493.364350] iwlwifi 0000:04:00.0: 0x0925001C | hcmd
> [36493.365854] iwlwifi 0000:04:00.0: 0x27C63040 | isr0
> [36493.367382] iwlwifi 0000:04:00.0: 0x0181E000 | isr1
> [36493.368912] iwlwifi 0000:04:00.0: 0x00000E02 | isr2
> [36493.370421] iwlwifi 0000:04:00.0: 0x0141FCC3 | isr3
> [36493.371938] iwlwifi 0000:04:00.0: 0x00000000 | isr4
> [36493.373446] iwlwifi 0000:04:00.0: 0x00080110 | isr_pref
> [36493.374930] iwlwifi 0000:04:00.0: 0x00029B36 | wait_event
> [36493.376398] iwlwifi 0000:04:00.0: 0x0000B6D5 | l2p_control
> [36493.377856] iwlwifi 0000:04:00.0: 0x00004735 | l2p_duration
> [36493.379290] iwlwifi 0000:04:00.0: 0x00000003 | l2p_mhvalid
> [36493.380699] iwlwifi 0000:04:00.0: 0x00200200 | l2p_addr_match
> [36493.382091] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
> [36493.383467] iwlwifi 0000:04:00.0: 0x13011054 | timestamp
> [36493.384825] iwlwifi 0000:04:00.0: 0x00003848 | flow_handler
> [36493.386244] iwlwifi 0000:04:00.0: Start IWL Event Log Dump: display last 20 entries
> [36493.387671] iwlwifi 0000:04:00.0: EVT_LOGT:0000146662:0x00040000:1243
> [36493.389089] iwlwifi 0000:04:00.0: EVT_LOGT:0000146834:0x00000000:0301
> [36493.390503] iwlwifi 0000:04:00.0: EVT_LOGT:0000146939:0x00040000:1243
> [36493.391919] iwlwifi 0000:04:00.0: EVT_LOGT:0000146961:0x00000000:0301
> [36493.393326] iwlwifi 0000:04:00.0: EVT_LOGT:0000147063:0x00040000:1243
> [36493.394728] iwlwifi 0000:04:00.0: EVT_LOGT:0000147223:0x00000000:0301
> [36493.396128] iwlwifi 0000:04:00.0: EVT_LOGT:0000147323:0x00040000:1243
> [36493.397517] iwlwifi 0000:04:00.0: EVT_LOGT:0000147379:0x00000000:0301
> [36493.398896] iwlwifi 0000:04:00.0: EVT_LOGT:0000147479:0x00040000:1243
> [36493.400270] iwlwifi 0000:04:00.0: EVT_LOGT:0000147500:0x00000000:0301
> [36493.401643] iwlwifi 0000:04:00.0: EVT_LOGT:0000147598:0x00040000:1243
> [36493.403011] iwlwifi 0000:04:00.0: EVT_LOGT:0000148548:0x00000000:0302
> [36493.404386] iwlwifi 0000:04:00.0: EVT_LOGT:0000148591:0x00040000:1243
> [36493.405754] iwlwifi 0000:04:00.0: EVT_LOGT:0000149633:0x00000000:0302
> [36493.407118] iwlwifi 0000:04:00.0: EVT_LOGT:0000149674:0x00040000:1243
> [36493.408470] iwlwifi 0000:04:00.0: EVT_LOGT:0000150330:0x00019002:1388
> [36493.409813] iwlwifi 0000:04:00.0: EVT_LOGT:0000150337:0x00049c00:1386
> [36493.411149] iwlwifi 0000:04:00.0: EVT_LOGT:0000150338:0x00049c00:1386
> [36493.412477] iwlwifi 0000:04:00.0: EVT_LOGT:0000150373:0x00000040:1243
> [36493.413794] iwlwifi 0000:04:00.0: EVT_LOGT:0000150388:0x00000000:0125
> [36493.415366] ieee80211 phy0: Hardware restart was requested
> [36493.416687] iwlwifi 0000:04:00.0: L1 Disabled; Enabling L0S
> [36493.425493] iwlwifi 0000:04:00.0: Radio type=0x2-0x0-0x0
> [36493.595578] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 9 on FIFO 7 WrPtr: 0
> [36493.595818] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 0 on FIFO 3 WrPtr: 0
> [36493.595920] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 1 on FIFO 2 WrPtr: 0
> [36493.596021] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 2 on FIFO 1 WrPtr: 0
> [36493.596122] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 3 on FIFO 0 WrPtr: 0
> [36493.596223] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 4 on FIFO 0 WrPtr: 0
> [36493.596324] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 5 on FIFO 4 WrPtr: 0
> [36493.596425] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 6 on FIFO 2 WrPtr: 0
> [36493.596526] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 7 on FIFO 5 WrPtr: 0
> [36493.596628] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 8 on FIFO 4 WrPtr: 0
> [36493.596729] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 10 on FIFO 5 WrPtr: 0
> [36493.708319] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
> [36493.709636] iwlwifi 0000:04:00.0: CSR values:
> [36493.710928] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [36493.712283] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c80b08
> [36493.713639] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X0000ff40
> [36493.714966] iwlwifi 0000:04:00.0:                     CSR_INT: 0X10000000
> [36493.716313] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [36493.717632] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
> [36493.718927] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
> [36493.720229] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [36493.721518] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [36493.722790] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X000000c8
> [36493.724086] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X8ff30ffd
> [36493.725390] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000801
> [36493.726683] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00030001
> [36493.727994] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080044
> [36493.729310] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X000000a5
> [36493.730622] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000080
> [36493.731955] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [36493.733279] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [36493.734581] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
> [36493.735898] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88409dc6
> [36493.737229] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X29800200
> [36493.738560] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [36493.739918] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [36493.741274] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [36493.742617] iwlwifi 0000:04:00.0: FH register values:
> [36493.743977] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X408a7b00
> [36493.745378] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X04088d70
> [36493.746783] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000030
> [36493.748218] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [36493.749666] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [36493.751126] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [36493.752609] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [36493.754112] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [36493.755624] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [36493.757131] iwlwifi 0000:04:00.0: Loaded firmware version: 18.168.6.1
> [36493.758761] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
> [36493.760289] iwlwifi 0000:04:00.0: Status: 0x0000004C, count: 6
> [36493.761831] iwlwifi 0000:04:00.0: 0x000014E1 | ADVANCED_SYSASSERT          
> [36493.763372] iwlwifi 0000:04:00.0: 0x0001A564 | uPc
> [36493.764910] iwlwifi 0000:04:00.0: 0x0001A5CA | branchlink1
> [36493.766445] iwlwifi 0000:04:00.0: 0x0001A5CA | branchlink2
> [36493.767949] iwlwifi 0000:04:00.0: 0x0000EC7A | interruptlink1
> [36493.769439] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
> [36493.770941] iwlwifi 0000:04:00.0: 0x00000000 | data1
> [36493.772430] iwlwifi 0000:04:00.0: 0x00000000 | data2
> [36493.773913] iwlwifi 0000:04:00.0: 0x000000A2 | line
> [36493.775379] iwlwifi 0000:04:00.0: 0x0041886A | beacon time
> [36493.776861] iwlwifi 0000:04:00.0: 0x00019795 | tsf low
> [36493.778353] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
> [36493.779840] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
> [36493.781331] iwlwifi 0000:04:00.0: 0x000249F9 | time gp2
> [36493.782806] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
> [36493.784290] iwlwifi 0000:04:00.0: 0x754312A8 | uCode version
> [36493.785786] iwlwifi 0000:04:00.0: 0x000000C8 | hw version
> [36493.787277] iwlwifi 0000:04:00.0: 0x00C80B08 | board version
> [36493.788791] iwlwifi 0000:04:00.0: 0x0925001C | hcmd
> [36493.790303] iwlwifi 0000:04:00.0: 0x27C63040 | isr0
> [36493.791810] iwlwifi 0000:04:00.0: 0x0181E000 | isr1
> [36493.793329] iwlwifi 0000:04:00.0: 0x00000E02 | isr2
> [36493.794837] iwlwifi 0000:04:00.0: 0x0141FCC3 | isr3
> [36493.796354] iwlwifi 0000:04:00.0: 0x00000000 | isr4
> [36493.797870] iwlwifi 0000:04:00.0: 0x00080110 | isr_pref
> [36493.799349] iwlwifi 0000:04:00.0: 0x00029B36 | wait_event
> [36493.800812] iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
> [36493.802281] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
> [36493.803721] iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
> [36493.805143] iwlwifi 0000:04:00.0: 0x00200200 | l2p_addr_match
> [36493.806522] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
> [36493.807884] iwlwifi 0000:04:00.0: 0x13011054 | timestamp
> [36493.809253] iwlwifi 0000:04:00.0: 0x00003040 | flow_handler
> [36493.810666] iwlwifi 0000:04:00.0: Start IWL Event Log Dump: display last 20 entries
> [36493.812090] iwlwifi 0000:04:00.0: EVT_LOGT:0000143268:0x00000000:0301
> [36493.813515] iwlwifi 0000:04:00.0: EVT_LOGT:0000143383:0x00000000:0302
> [36493.814924] iwlwifi 0000:04:00.0: EVT_LOGT:0000143424:0x00040000:1243
> [36493.816327] iwlwifi 0000:04:00.0: EVT_LOGT:0000144139:0x00000000:0302
> [36493.817728] iwlwifi 0000:04:00.0: EVT_LOGT:0000144182:0x00040000:1243
> [36493.819124] iwlwifi 0000:04:00.0: EVT_LOGT:0000145846:0x00000000:0301
> [36493.820519] iwlwifi 0000:04:00.0: EVT_LOGT:0000146045:0x00002000:1243
> [36493.821901] iwlwifi 0000:04:00.0: EVT_LOGT:0000146229:0x00001000:1243
> [36493.823274] iwlwifi 0000:04:00.0: EVT_LOGT:0000148140:0x00c01003:0310
> [36493.824644] iwlwifi 0000:04:00.0: EVT_LOGT:0000148141:0x0000028b:1623
> [36493.826013] iwlwifi 0000:04:00.0: EVT_LOGT:0000148144:0x00040000:1243
> [36493.827381] iwlwifi 0000:04:00.0: EVT_LOGT:0000148240:0x00000000:0301
> [36493.828750] iwlwifi 0000:04:00.0: EVT_LOGT:0000148340:0x00040000:1243
> [36493.830124] iwlwifi 0000:04:00.0: EVT_LOGT:0000148354:0x00000000:0302
> [36493.831485] iwlwifi 0000:04:00.0: EVT_LOGT:0000148397:0x00040000:1243
> [36493.832840] iwlwifi 0000:04:00.0: EVT_LOGT:0000149957:0x00019002:1388
> [36493.834183] iwlwifi 0000:04:00.0: EVT_LOGT:0000149964:0x00049c00:1386
> [36493.835520] iwlwifi 0000:04:00.0: EVT_LOGT:0000149965:0x00049c00:1386
> [36493.836847] iwlwifi 0000:04:00.0: EVT_LOGT:0000150000:0x00000040:1243
> [36493.838163] iwlwifi 0000:04:00.0: EVT_LOGT:0000150016:0x00000000:0125
> [36493.839458] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [36502.069842] iwlwifi 0000:04:00.0: Command REPLY_TX_BEACON failed: FW Error
> [36654.398383] iwlwifi 0000:04:00.0: Command REPLY_TX_BEACON failed: FW Error
> [36654.498682] iwlwifi 0000:04:00.0: Command REPLY_TX_BEACON failed: FW Error
> [36655.500726] iwlwifi 0000:04:00.0: Command REPLY_TX_BEACON failed: FW Error
> [36656.503064] iwlwifi 0000:04:00.0: Command REPLY_TX_BEACON failed: FW Error
> [36657.505484] iwlwifi 0000:04:00.0: Command REPLY_TX_BEACON failed: FW Error
> [36657.506728] iwlwifi 0000:04:00.0: Command REPLY_ADD_STA failed: FW Error
> [36657.507903] wlan0: failed to remove key (0, e4:25:e7:03:36:0a) from hardware (-5)
> [36659.517000] iwlwifi 0000:04:00.0: Command REPLY_TX_BEACON failed: FW Error
> 
> Then nothing until the unload / reload.

J.

-- 
] http://www.earth.li/~noodles/ []  If I, um, err. Yeah, it probably   [
]  PGP/GPG Key @ the.earth.li   []    rounds down. -- Simon Huggins    [
] via keyserver, web or email.  []                                     [
] RSA: 4096/2DA8B985            []                                     [
