Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:59395 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3ABOOU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:14:20 -0500
Date: Wed, 2 Jan 2013 12:00:02 +0100
From: Julian Wollrath <jwollrath@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/wireless/mlme.c:517
Message-ID: <20130102120002.691dbbb4@ilfaris> (sfid-20130102_151427_102591_61221218)
In-Reply-To: <50E36325.3090502@lwfinger.net>
References: <20130101154507.351dfb03@ilfaris>
 <50E325B5.205@lwfinger.net>
 <20130101231544.430cf1fe@ilfaris>
 <50E36325.3090502@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> As you have probably seen, I cannot duplicate the problems that
> Borislav sees, nor do I ever see the ones you state here.
> 
> If this condition is easy to replicate, please unload rtl8192ce, and
> reload with the command 'sudo modprobe -v rtl8192ce debug=4'. That
> will generate a lot of logging, thus you probably do not want to let
> it run too long.
Below is the output of a short time with debug=4 from a period where
the interface did not manage to connect properly to the AP. Since I have
no LED which indicates anything the lines that state
"rtl8192ce:rtl92ce_led_control() [...]" do not seem necessary but I
suspect there is no way to detect if there really is a state LED or is
it?

The other thing, which catched my eye, were the following repeated messages:
rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem


With best regards,
Julian

[23128.250785] cfg80211: World regulatory domain updated:
[23128.250793] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23128.250797] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23128.250801] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23128.250804] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23128.250807] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23128.250810] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23128.251520] cfg80211: Calling CRDA for country: AT
[23128.270288] cfg80211: Regulatory domain changed to country: AT
[23128.270299] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23128.270303] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23128.270306] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23128.270309] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23128.270312] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[23145.894382] cfg80211: Calling CRDA to update world regulatory domain
[23145.918221] cfg80211: World regulatory domain updated:
[23145.918231] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23145.918234] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23145.918238] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23145.918241] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23145.918244] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23145.918246] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23145.921313] rtl8192ce:_rtl92ce_read_chip_version():<0-0> Chip Version ID: B_CHIP_88C
[23145.931275] rtl8192ce: rtl8192ce: Power Save off (module option)
[23145.931341] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
[23145.931421] rtlwifi:rtl_fw_cb():<0-0> Firmware callback routine entered!
[23145.931625] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[23145.931956] rtlwifi: wireless switch is on
[23145.932198] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.932254] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.932360] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.932465] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.932570] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.932676] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.932781] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.932886] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.932991] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.933096] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.933202] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.933307] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23145.933412] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:98053f15:10
[23145.934293] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
[23145.971355] cfg80211: Calling CRDA for country: AT
[23145.999669] rtlwifi:rtl_reg_notifier():<0-0> 
[23145.999678] cfg80211: Regulatory domain changed to country: AT
[23145.999680] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23145.999684] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23145.999687] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23145.999690] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23145.999692] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[23146.152443] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 0 GroupEncAlgorithm = 0
[23146.152449] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[23146.260698] rtl8192c_common:rtl92c_dm_initialize_txpower_tracking_thermalmeter():<0-0> pMgntInfo->txpower_tracking = 1
[23146.260706] rtlwifi:rtl_pci_start():<0-0> enable_interrupt OK
[23146.260709] rtlwifi:rtl_pci_start():<0-0> OK
[23146.260757] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23146.260761] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23146.260773] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23146.260792] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23146.260796] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23146.260821] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[23146.260826] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23146.260845] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_LISTEN_INTERVAL
[23146.260850] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_RETRY_LIMITS 4
[23146.270899] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23146.270903] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23146.270977] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23148.261833] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23148.261846] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23148.261854] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23148.261861] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23148.264881] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0x0 eeprom_thermalmeter 0xe
[23148.264891] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23148.264902] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23148.264911] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23148.264916] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23148.374103] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23148.374118] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23148.374129] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x20, pre_igvalue = 0x0, back_val = 10
[23148.384309] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23148.384325] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23148.454432] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23148.454448] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23148.524390] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23148.524405] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23148.594173] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23148.594189] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23148.664068] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23148.664084] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23148.733969] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23148.733984] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23148.803846] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23148.803895] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23148.873742] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23148.873758] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23148.943758] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23148.943774] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23149.013640] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23149.013656] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23149.083722] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23149.083738] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23149.153641] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23149.153656] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23149.223405] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23149.223420] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23149.293474] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23149.293490] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23149.293607] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23149.293627] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x22, pre_igvalue = 0x22, back_val = 10
[23150.262847] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23150.262860] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23150.262872] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23152.263835] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23152.263848] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23152.263856] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23152.263863] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23152.266882] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23152.266893] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23152.266904] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23152.266912] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23152.266918] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23154.264862] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23154.264875] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23154.264886] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23156.265881] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23156.265894] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23156.265902] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23156.265909] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23156.268928] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23156.268939] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23156.268951] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23156.268959] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23156.268965] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23158.266884] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23158.266897] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23158.266909] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23160.267892] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23160.267905] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23160.267914] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23160.267920] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23160.270940] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23160.270950] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23160.270961] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23160.270969] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23160.270975] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23162.268868] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23162.268881] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23162.268893] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23164.269979] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23164.269992] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23164.270000] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23164.270007] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23164.273026] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23164.273037] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23164.273047] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23164.273056] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23164.273062] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23166.270807] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23166.270821] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23166.270832] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23168.271923] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23168.271937] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23168.271945] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23168.271951] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23168.274971] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23168.274982] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23168.274993] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23168.275001] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23168.275007] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23170.272931] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23170.272944] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23170.272956] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23172.273945] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23172.273958] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23172.273966] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23172.273973] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23172.276993] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23172.277003] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23172.277015] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23172.277023] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23172.277029] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23174.274952] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23174.274965] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23174.274976] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23176.275955] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23176.275969] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23176.275976] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23176.275983] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23176.279002] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23176.279013] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23176.279024] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23176.279032] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23176.279038] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23178.276786] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23178.276800] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23178.276812] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23178.331591] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23178.341715] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23178.341724] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23178.341800] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23178.341821] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23178.341828] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23178.341856] wlan0: direct probe to xx:xx:xx:xx:xx:xx (try 1/3)
[23178.542340] wlan0: direct probe to xx:xx:xx:xx:xx:xx (try 2/3)
[23178.743135] wlan0: direct probe to xx:xx:xx:xx:xx:xx (try 3/3)
[23178.943852] wlan0: authentication with xx:xx:xx:xx:xx:xx timed out
[23178.943919] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23178.943941] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23178.943948] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23179.420683] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23180.279901] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23180.279915] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23180.279924] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23180.279930] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23180.282950] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23180.282961] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23180.282971] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23180.282980] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23180.282986] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23180.443178] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23182.278989] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23182.279002] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23182.279014] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23182.488108] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23182.492689] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23183.335721] wlan0: deauthenticating from xx:xx:xx:xx:xx:xx by local choice (reason=3)
[23183.436162] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23183.436177] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23183.436188] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x24, pre_igvalue = 0x24, back_val = 10
[23183.446398] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23183.446413] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23183.516024] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23183.516039] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23183.585869] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23183.585886] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23183.655769] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23183.655785] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23183.725653] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23183.725668] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23183.795542] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23183.795559] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23183.865481] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23183.865497] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23183.935513] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23183.935529] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23184.005234] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23184.005249] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23184.075126] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23184.075141] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23184.145159] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23184.145174] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23184.215233] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23184.215249] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23184.279925] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23184.279938] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23184.279946] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23184.279952] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23184.282972] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23184.282982] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23184.282993] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23184.283001] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23184.283007] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23184.285132] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23184.285147] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23184.354737] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23184.354752] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23184.354978] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23184.354990] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x26, pre_igvalue = 0x26, back_val = 10
[23186.281028] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23186.281042] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23186.281054] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23188.282015] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23188.282028] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23188.282036] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23188.282043] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23188.285062] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23188.285072] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23188.285083] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23188.285091] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23188.285097] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23190.282894] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23190.282907] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23190.282919] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23192.284044] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23192.284058] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23192.284066] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23192.284072] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23192.287092] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23192.287102] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23192.287113] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23192.287121] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23192.287127] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23194.285077] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23194.285091] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23194.285102] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23196.286054] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23196.286068] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23196.286075] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23196.286082] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23196.289101] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23196.289112] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23196.289123] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23196.289131] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23196.289137] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23196.700861] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23196.702242] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23198.287077] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23198.287090] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23198.287102] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23200.288100] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23200.288113] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23200.288121] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23200.288128] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23200.291147] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23200.291158] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23200.291169] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23200.291177] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23200.291183] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23200.688573] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23200.699188] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23202.289107] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23202.289120] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23202.289132] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23204.290127] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23204.290141] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23204.290149] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23204.290155] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23204.293174] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23204.293185] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23204.293196] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23204.293204] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23204.293210] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23206.291134] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23206.291147] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23206.291159] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23208.292121] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23208.292133] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23208.292141] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23208.292148] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23208.295167] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23208.295178] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23208.295189] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23208.295197] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23208.295203] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23210.293154] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23210.293167] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23210.293179] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23211.526684] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23212.294164] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23212.294177] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23212.294185] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23212.294192] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23212.297211] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23212.297222] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23212.297234] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23212.297242] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23212.297248] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23213.393662] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23213.393718] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23213.393740] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23213.393747] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23213.393776] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[23213.393802] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23213.400247] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23213.483140] wlan0: authenticated
[23213.500002] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23213.704235] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23213.806478] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23213.908681] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23214.010991] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23214.215684] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23214.294935] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23214.294955] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23214.317674] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23214.522410] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23214.624612] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23214.931339] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23215.135841] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23215.238157] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23215.340365] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23215.442678] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23215.544885] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23215.749410] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23215.851597] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23216.260645] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23216.295990] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23216.296006] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23216.296013] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23216.299033] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23216.299044] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23216.299055] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23216.299063] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23216.299069] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23216.465160] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23216.567356] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23216.669529] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23216.771666] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23216.976357] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23217.078663] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23217.283119] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23217.385312] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23217.487621] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23217.589828] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23217.692021] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23217.896543] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23218.173128] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.173909] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.175250] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.176564] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.177602] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.178910] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.179931] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.181232] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.183239] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.184329] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.188587] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.189546] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.190631] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.191654] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.192901] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.193849] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.194859] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.196262] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.197654] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.207221] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.208544] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.209737] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23218.296964] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23218.296983] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23218.387983] wlan0: deauthenticating from xx:xx:xx:xx:xx:xx by local choice (reason=3)
[23218.388103] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23218.388124] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23218.388132] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23218.888386] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23218.888401] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23218.888412] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x28, pre_igvalue = 0x28, back_val = 10
[23218.898613] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23218.898628] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23218.968077] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23218.968092] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.037887] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.037903] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.107850] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.107865] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.177766] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.177782] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.247574] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.247590] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.317580] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.317597] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.387375] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.387390] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.457342] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.457357] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.527185] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.527201] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.597133] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.597148] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.667176] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.667192] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.737164] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.737179] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.806941] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23219.806956] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23219.807075] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23219.807095] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x2a, pre_igvalue = 0x2a, back_val = 10
[23220.298171] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23220.298186] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23220.298193] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23220.301213] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23220.301223] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23220.301233] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23220.301242] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23220.301248] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23222.299206] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23222.299225] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23224.300225] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23224.300240] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23224.300246] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23224.303266] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23224.303276] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23224.303287] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23224.303296] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23224.303302] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23226.301233] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23226.301251] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23226.761798] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23226.765444] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23228.302261] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23228.302275] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23228.302282] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23228.305302] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23228.305312] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23228.305323] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23228.305332] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23228.305338] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23230.303251] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23230.303270] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23232.183028] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23232.190189] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23232.304260] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23232.304276] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23232.304282] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23232.307310] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23232.307321] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23232.307332] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23232.307341] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23232.307347] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23234.305280] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23234.305299] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23234.941713] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23234.944359] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23236.306296] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23236.306312] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23236.306318] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23236.309338] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23236.309348] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23236.309359] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23236.309367] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23236.309373] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23238.307296] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23238.307316] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23238.315533] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23238.320056] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23238.929443] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23238.939195] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23239.338009] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23239.348452] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23240.308313] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23240.308328] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23240.308335] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23240.311354] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23240.311365] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23240.311376] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23240.311384] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23240.311390] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23240.360438] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23240.367250] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23241.382939] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23241.385769] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23242.309324] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23242.309343] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23244.310319] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23244.310334] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23244.310340] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23244.313361] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe
[23244.313371] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23244.313383] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23244.313391] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xf pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x1 delta_lck 0x1 delta_iqk 0x1
[23244.313397] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23245.848313] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23245.848328] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23245.848375] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23245.848381] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23245.848391] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[23245.848397] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
[23245.848497] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[23245.848502] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
[23262.605727] cfg80211: Calling CRDA to update world regulatory domain
[23262.629287] cfg80211: World regulatory domain updated:
[23262.629297] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23262.629301] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23262.629304] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23262.629307] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23262.629310] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23262.629313] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23262.632900] rtl8192ce:_rtl92ce_read_chip_version():<0-0> Chip Version ID: B_CHIP_88C
[23262.642454] rtl8192ce: rtl8192ce: Power Save off (module option)
[23262.642490] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
[23262.642585] rtlwifi:rtl_fw_cb():<0-0> Firmware callback routine entered!
[23262.642806] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[23262.643129] rtlwifi: wireless switch is on
[23262.662861] cfg80211: Calling CRDA for country: AT
[23262.688510] rtlwifi:rtl_reg_notifier():<0-0> 
[23262.688518] cfg80211: Regulatory domain changed to country: AT
[23262.688521] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23262.688524] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23262.688527] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23262.688530] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23262.688533] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[23263.038909] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.038970] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.039076] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.039182] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.039287] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.039393] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.039498] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.039603] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.039708] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.039813] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.039919] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.040024] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23263.040139] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:98053f15:10
[23263.040993] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
[23263.259318] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 0 GroupEncAlgorithm = 0
[23263.259324] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[23263.367570] rtl8192c_common:rtl92c_dm_initialize_txpower_tracking_thermalmeter():<0-0> pMgntInfo->txpower_tracking = 1
[23263.367577] rtlwifi:rtl_pci_start():<0-0> enable_interrupt OK
[23263.367580] rtlwifi:rtl_pci_start():<0-0> OK
[23263.367646] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23263.367651] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23263.367653] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23263.367667] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23263.367676] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23263.367708] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[23263.367717] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23263.367754] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_LISTEN_INTERVAL
[23263.367765] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_RETRY_LIMITS 4
[23263.377827] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23263.377834] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23263.377964] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23263.944098] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23263.944113] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23263.944124] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x20, pre_igvalue = 0x0, back_val = 10
[23263.954246] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23263.954261] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.023668] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.023683] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.093566] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.093581] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.163517] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.163533] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.233385] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.233401] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.303250] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.303266] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.373164] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.373180] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.443098] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.443113] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.513940] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.513951] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.583852] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.583867] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.653724] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.653740] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.723661] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.723676] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.793536] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.793552] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.854937] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23264.863540] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.863555] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.863626] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23264.863646] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x22, pre_igvalue = 0x22, back_val = 10
[23264.873827] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23264.873835] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23264.873931] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23264.873952] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23264.873958] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23264.874000] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[23264.874025] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23264.879203] wlan0: authenticated
[23264.879623] rtl8192ce 0000:01:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
[23264.880316] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[23264.930404] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23265.081007] wlan0: associate with xx:xx:xx:xx:xx:xx (try 2/3)
[23265.100400] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
[23265.100425] rtlwifi:rtl_op_sta_add():<0-0> Add sta addr is xx:xx:xx:xx:xx:xx
[23265.100434] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> ratr_bitmap :ff5
[23265.100442] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> Rate_index:4, ratr_val:ff5, f5:0f:00:40:80
[23265.100448] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23265.100460] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d0) =  6
[23265.100476] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 1
[23265.100482] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23265.100505] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ASSOC
[23265.100512] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23265.100535] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23265.100543] 80 00 00 00 ff ff ff ff ff ff 60 d8 19 c8 fd 43  ..........`....C
[23265.100548] 20 4e 7f ab c8 ba 50 08 00 00 00 00 00 00 00 00   N....P.........
[23265.100553] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23265.100558] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23265.100563] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23265.100568] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100572] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23265.100577] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23265.100582] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100586] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100591] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100595] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100600] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100605] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100609] 10 00 20 8c 00 12 10 00 00 00 00 00 00 00 00 00  .. .............
[23265.100614] 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100619] a4 10 01 c0 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  .... N....`....C
[23265.100623] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100628] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100632] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100637] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100641] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100646] 18 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  .. .............
[23265.100651] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100656] 48 01 00 00 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  H... N....`....C
[23265.100661] 20 4e 7f ab c8 ba 00 00 00 00 00 00 00 00 00 00   N..............
[23265.100688] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100693] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100698] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100702] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100707] 72 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  r. .............
[23265.100712] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100716] 50 00 00 00 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  P... N....`....C
[23265.100721] 20 4e 7f ab c8 ba 00 00 9e 46 15 32 27 f2 2d 00   N.......F.2'.-.
[23265.100726] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23265.100731] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23265.100736] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23265.100740] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100745] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23265.100749] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23265.100754] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100759] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100763] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100768] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100772] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100777] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100781] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100786] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100792] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23265.100796] 04 02 03                                         ...
[23265.100808] rtl8192ce: In process "kworker/u:1" (pid 27666): H2C Tx Cmd Content
[23265.100813] 00 03 20 8c 00 10 07 00 00 00 00 00 00 00 00 80  .. .............
[23265.100818] 80 01 00 00 00 00 00 00 00 00 00 00 00 03 00 00  ................
[23265.100823] 80 b3 eb 33 00 00 00 00 40 c0 66 b9 00 00 00 00  ...3....@.f.....
[23265.100828] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23265.100835] rtl8192c_common:rtl92c_set_fw_rsvdpagepkt():<0-0> Set RSVD page location to Fw
[23265.100840] rtl8192c_common: In process "kworker/u:1" (pid 27666): H2C_RSVDPAGE
[23265.100845] 04 02 03                                         ...
[23265.100849] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23265.100858] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d4) =  3
[23265.100870] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 2
[23265.100875] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23265.100885] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23265.100893] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d8) =  2
[23265.100905] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 3
[23265.100909] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23265.100929] wlan0: associated
[23265.101023] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23265.339322] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23265.339446] wlan0: AP xx:xx:xx:xx:xx:xx switches to unsupported channel (0 MHz), disconnecting
[23265.359624] rtlwifi:rtl_op_sta_remove():<0-0> Remove sta addr is xx:xx:xx:xx:xx:xx
[23265.359678] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_UN_ASSOC
[23265.359685] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[23265.359695] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23265.359705] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_SHORTGI_DENSITY: 0x0
[23265.359720] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_FACTOR: 0xf
[23265.359726] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_MIN_SPACE: 0x7
[23265.359745] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23265.359764] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23265.359770] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23265.360800] cfg80211: Calling CRDA to update world regulatory domain
[23265.367145] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23265.367159] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23265.367167] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23265.367174] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23265.370193] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0x0 eeprom_thermalmeter 0xe
[23265.370204] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23265.370214] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23265.370223] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23265.370229] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23265.376199] rtlwifi:rtl_reg_notifier():<0-0> 
[23265.376211] cfg80211: World regulatory domain updated:
[23265.376215] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23265.376222] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23265.376228] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23265.376235] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23265.376241] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23265.376246] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23265.376291] cfg80211: Calling CRDA for country: AT
[23265.392084] rtlwifi:rtl_reg_notifier():<0-0> 
[23265.392098] cfg80211: Regulatory domain changed to country: AT
[23265.392102] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23265.392109] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23265.392115] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23265.392121] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23265.392126] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[23265.460125] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23265.460141] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23265.460153] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x24, pre_igvalue = 0x24, back_val = 10
[23265.470265] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23265.470281] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23265.539412] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23265.539429] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23265.609323] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23265.609338] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23265.679201] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23265.679217] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23265.749106] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23265.749122] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23265.818980] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23265.818996] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23265.888898] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23265.888914] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23265.958785] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23265.958801] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.028669] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.028685] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.098568] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.098584] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.168460] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.168475] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.238369] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.238385] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.308296] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.308313] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.372422] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23266.378207] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.378222] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.378413] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23266.378425] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x26, pre_igvalue = 0x26, back_val = 10
[23266.378558] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23266.378578] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23266.378585] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23266.378634] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[23266.378661] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23266.380777] wlan0: authenticated
[23266.381141] rtl8192ce 0000:01:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
[23266.382065] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[23266.384600] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
[23266.384620] rtlwifi:rtl_op_sta_add():<0-0> Add sta addr is xx:xx:xx:xx:xx:xx
[23266.384628] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> ratr_bitmap :ff5
[23266.384635] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> Rate_index:4, ratr_val:ff5, f5:0f:00:40:80
[23266.384642] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23266.384653] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1dc) =  6
[23266.384669] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 0
[23266.384674] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23266.384696] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ASSOC
[23266.384703] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23266.384727] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23266.384734] 80 00 00 00 ff ff ff ff ff ff 60 d8 19 c8 fd 43  ..........`....C
[23266.384740] 20 4e 7f ab c8 ba 50 08 00 00 00 00 00 00 00 00   N....P.........
[23266.384744] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23266.384749] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23266.384754] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23266.384759] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384764] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23266.384768] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23266.384773] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384778] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384782] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384787] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384791] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384796] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384801] 10 00 20 8c 00 12 10 00 00 00 00 00 00 00 00 00  .. .............
[23266.384805] 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384810] a4 10 01 c0 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  .... N....`....C
[23266.384815] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384819] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384824] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384828] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384833] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384838] 18 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  .. .............
[23266.384842] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384847] 48 01 00 00 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  H... N....`....C
[23266.384852] 20 4e 7f ab c8 ba 00 00 00 00 00 00 00 00 00 00   N..............
[23266.384856] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384861] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384865] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384870] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384875] 72 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  r. .............
[23266.384879] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384884] 50 00 00 00 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  P... N....`....C
[23266.384889] 20 4e 7f ab c8 ba 00 00 9e 46 15 32 27 f2 2d 00   N.......F.2'.-.
[23266.384894] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23266.384898] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23266.384903] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23266.384908] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384912] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23266.384917] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23266.384922] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384926] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384931] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384935] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384940] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384944] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384949] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384954] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.384959] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23266.384964] 04 02 03                                         ...
[23266.384975] rtl8192ce: In process "kworker/u:1" (pid 27666): H2C Tx Cmd Content
[23266.384979] 00 03 20 8c 00 10 07 00 00 00 00 00 00 00 00 80  .. .............
[23266.384984] 80 01 00 00 00 00 00 00 00 00 00 00 00 03 00 00  ................
[23266.384989] c0 41 39 0c 00 00 00 00 40 c0 66 b9 00 00 00 00  .A9.....@.f.....
[23266.384994] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23266.385001] rtl8192c_common:rtl92c_set_fw_rsvdpagepkt():<0-0> Set RSVD page location to Fw
[23266.385006] rtl8192c_common: In process "kworker/u:1" (pid 27666): H2C_RSVDPAGE
[23266.385011] 04 02 03                                         ...
[23266.385016] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23266.385025] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d0) =  3
[23266.385077] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 1
[23266.385082] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23266.385092] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23266.385101] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d4) =  2
[23266.385113] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 2
[23266.385118] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23266.385508] wlan0: associated
[23266.464125] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23266.464216] wlan0: AP xx:xx:xx:xx:xx:xx switches to unsupported channel (0 MHz), disconnecting
[23266.484965] rtlwifi:rtl_op_sta_remove():<0-0> Remove sta addr is xx:xx:xx:xx:xx:xx
[23266.485017] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_UN_ASSOC
[23266.485024] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[23266.485034] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.485044] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_SHORTGI_DENSITY: 0x7
[23266.485059] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_FACTOR: 0xf
[23266.485065] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_MIN_SPACE: 0x7
[23266.485084] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23266.485103] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23266.485109] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23266.485211] cfg80211: Calling CRDA to update world regulatory domain
[23266.500017] rtlwifi:rtl_reg_notifier():<0-0> 
[23266.500029] cfg80211: World regulatory domain updated:
[23266.500034] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23266.500041] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23266.500047] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23266.500053] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23266.500059] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23266.500065] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23266.500211] cfg80211: Calling CRDA for country: AT
[23266.510593] rtlwifi:rtl_reg_notifier():<0-0> 
[23266.510602] cfg80211: Regulatory domain changed to country: AT
[23266.510604] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23266.510608] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23266.510611] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23266.510614] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23266.510617] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[23266.585631] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23266.585647] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23266.585658] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x28, pre_igvalue = 0x28, back_val = 10
[23266.595870] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.595879] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.665728] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.665744] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.735625] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.735641] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.805529] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.805546] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.875444] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.875460] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23266.945310] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23266.945326] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23267.015230] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23267.015246] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23267.085128] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23267.085144] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23267.155022] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23267.155038] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23267.224963] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23267.224978] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23267.294919] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23267.294935] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23267.364665] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23267.364683] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23267.367639] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23267.367652] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23267.367664] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23267.434582] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23267.434597] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23267.504469] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23267.504485] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23267.504614] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23267.504625] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x2a, pre_igvalue = 0x2a, back_val = 10
[23267.505508] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23267.505575] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23267.505596] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23267.505604] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23267.505633] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[23267.505659] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23267.507667] wlan0: authenticated
[23267.508048] rtl8192ce 0000:01:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
[23267.508058] rtl8192ce 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[23267.508065] rtl8192ce 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[23267.508609] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[23267.510895] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=5)
[23267.510920] rtlwifi:rtl_op_sta_add():<0-0> Add sta addr is xx:xx:xx:xx:xx:xx
[23267.510929] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> ratr_bitmap :ff5
[23267.510937] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> Rate_index:4, ratr_val:ff5, f5:0f:00:40:80
[23267.510943] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23267.510955] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d8) =  6
[23267.510972] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 3
[23267.510977] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23267.510999] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ASSOC
[23267.511006] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23267.511030] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23267.511038] 80 00 00 00 ff ff ff ff ff ff 60 d8 19 c8 fd 43  ..........`....C
[23267.511044] 58 6d 8f da 92 a7 50 08 00 00 00 00 00 00 00 00  Xm....P.........
[23267.511049] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23267.511054] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23267.511059] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23267.511063] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511068] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23267.511073] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23267.511077] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511082] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511086] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511091] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511096] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511100] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511105] 10 00 20 8c 00 12 10 00 00 00 00 00 00 00 00 00  .. .............
[23267.511109] 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511114] a4 10 05 c0 58 6d 8f da 92 a7 60 d8 19 c8 fd 43  ....Xm....`....C
[23267.511119] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511124] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511128] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511133] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511137] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511142] 18 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  .. .............
[23267.511147] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511152] 48 01 00 00 58 6d 8f da 92 a7 60 d8 19 c8 fd 43  H...Xm....`....C
[23267.511156] 58 6d 8f da 92 a7 00 00 00 00 00 00 00 00 00 00  Xm..............
[23267.511161] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511166] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511170] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511175] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511179] 72 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  r. .............
[23267.511184] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511189] 50 00 00 00 58 6d 8f da 92 a7 60 d8 19 c8 fd 43  P...Xm....`....C
[23267.511194] 58 6d 8f da 92 a7 00 00 9e 46 15 32 27 f2 2d 00  Xm.......F.2'.-.
[23267.511199] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23267.511203] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23267.511208] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23267.511213] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511218] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23267.511222] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23267.511227] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511231] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511236] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511240] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511245] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511250] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511254] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511259] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511265] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23267.511269] 04 02 03                                         ...
[23267.511290] rtl8192ce: In process "kworker/u:1" (pid 27666): H2C Tx Cmd Content
[23267.511295] 00 03 20 8c 00 10 07 00 00 00 00 00 00 00 00 80  .. .............
[23267.511300] 80 01 00 00 00 00 00 00 00 00 00 00 00 03 00 00  ................
[23267.511305] 40 f2 eb 33 00 00 00 00 40 c0 66 b9 00 00 00 00  @..3....@.f.....
[23267.511309] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23267.511317] rtl8192c_common:rtl92c_set_fw_rsvdpagepkt():<0-0> Set RSVD page location to Fw
[23267.511323] rtl8192c_common: In process "kworker/u:1" (pid 27666): H2C_RSVDPAGE
[23267.511327] 04 02 03                                         ...
[23267.511332] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23267.511341] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1dc) =  3
[23267.511389] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 0
[23267.511394] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23267.511411] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23267.511431] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d0) =  2
[23267.511454] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 1
[23267.511473] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23267.511507] wlan0: associated
[23267.516704] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23267.518824] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23267.527320] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23267.527646] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23267.528203] rtlwifi:rtl_op_set_key():<0-0> Using hardware based encryption for keyidx: 0, mac: xx:xx:xx:xx:xx:xx
[23267.528212] rtlwifi:rtl_op_set_key():<0-0> alg:TKIP
[23267.528219] rtlwifi:rtl_op_set_key():<0-0> set enable_hw_sec, key_type:2(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
[23267.528226] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 2 GroupEncAlgorithm = 0
[23267.528234] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[23267.528242] rtlwifi:rtl_op_set_key():<0-0> set pairwise key
[23267.528250] rtl8192ce:rtl92ce_set_key():<0-0> The insert KEY length is 32
[23267.528256] rtl8192ce:rtl92ce_set_key():<0-0> The insert KEY is 15 4b
[23267.528261] rtl8192ce:rtl92ce_set_key():<0-0> add one entry
[23267.528266] rtl8192ce: In process "wpa_supplicant" (pid 27788): Pairwise Key content
[23267.528274] 15 4b 2e 8a 94 aa 5a dc 0d 5b 67 26 c2 6d 53 6a  .K....Z..[g&.mSj
[23267.528279] 2d c5 ed 6f 06 82 2a 04 86 e1 c4 17 b2 11 03 63  -..o..*........c
[23267.528284] rtl8192ce:rtl92ce_set_key():<0-0> set Pairwise key
[23267.528292] rtlwifi:rtl_cam_add_one_entry():<0-0> EntryNo:4, ulKeyId=0, ulEncAlg=2, ulUseDK=0 MacAddr xx:xx:xx:xx:xx:xx
[23267.528298] rtlwifi:rtl_cam_program_entry():<0-0> key_cont_128: 15:4b:2e:8a:94:aa
[23267.528308] rtlwifi:rtl_cam_program_entry():<0-0> WRITE 674: 6d588008
[23267.528313] rtlwifi:rtl_cam_program_entry():<0-0> The Key ID is 4
[23267.528318] rtlwifi:rtl_cam_program_entry():<0-0> WRITE 670: 80010020
[23267.528360] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: a792da8f
[23267.528378] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010021
[23267.528497] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 8a2e4b15
[23267.528502] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010022
[23267.528610] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: dc5aaa94
[23267.528615] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010023
[23267.528724] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 26675b0d
[23267.528729] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010024
[23267.528837] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 6a536dc2
[23267.528842] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010025
[23267.528951] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 6fedc52d
[23267.528955] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010026
[23267.529064] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 42a8206
[23267.529068] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010027
[23267.529074] rtlwifi:rtl_cam_program_entry():<0-0> after set key, usconfig:8008
[23267.529078] rtlwifi:rtl_cam_add_one_entry():<0-0> <===
[23267.537707] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23267.538220] rtlwifi:rtl_op_set_key():<0-0> Using hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[23267.538235] rtlwifi:rtl_op_set_key():<0-0> alg:TKIP
[23267.538241] rtlwifi:rtl_op_set_key():<0-0> set group key
[23267.538250] rtl8192ce:rtl92ce_set_key():<0-0> The insert KEY length is 32
[23267.538256] rtl8192ce:rtl92ce_set_key():<0-0> The insert KEY is 15 4b
[23267.538261] rtl8192ce:rtl92ce_set_key():<0-0> add one entry
[23267.538266] rtl8192ce:rtl92ce_set_key():<0-0> set group key
[23267.538275] rtlwifi:rtl_cam_add_one_entry():<0-0> EntryNo:2, ulKeyId=2, ulEncAlg=2, ulUseDK=0 MacAddr ff:ff:ff:ff:ff:ff
[23267.538282] rtlwifi:rtl_cam_program_entry():<0-0> key_cont_128: c1:a4:7e:90:5e:fd
[23267.538293] rtlwifi:rtl_cam_program_entry():<0-0> WRITE 674: ffff800a
[23267.538298] rtlwifi:rtl_cam_program_entry():<0-0> The Key ID is 2
[23267.538303] rtlwifi:rtl_cam_program_entry():<0-0> WRITE 670: 80010010
[23267.538337] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: ffffffff
[23267.538342] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010011
[23267.538465] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 907ea4c1
[23267.538470] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010012
[23267.538578] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 4a12fd5e
[23267.538583] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010013
[23267.538692] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: ce29578c
[23267.538697] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010014
[23267.538805] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: cb437e22
[23267.538810] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010015
[23267.538919] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 67c8c318
[23267.538923] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010016
[23267.539032] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 851d1b2f
[23267.539037] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010017
[23267.539042] rtlwifi:rtl_cam_program_entry():<0-0> after set key, usconfig:800a
[23267.539047] rtlwifi:rtl_cam_add_one_entry():<0-0> <===
[23267.539151] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23267.557389] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23267.632686] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23267.659678] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23267.761886] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23267.864179] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23267.938809] rtl8192ce:rtl92ce_led_control():<300-1> ledaction 4
[23267.966396] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.068673] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.170924] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.273122] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.375419] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.477641] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.579915] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.682156] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.784373] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.886660] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23268.988996] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23269.091368] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23269.193576] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23269.295774] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23269.368865] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x1e, pre_igvalue = 0x2c, back_val = 8
[23269.368922] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> STA Default Port PWDB = 0x15
[23269.368949] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23269.368955] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23269.371975] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23269.371986] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23269.371996] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23269.372005] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23269.372011] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23269.372017] rtl8192c_common:rtl92c_dm_refresh_rate_adaptive_mask():<0-0> RSSI = 21
[23269.372023] rtl8192c_common:rtl92c_dm_refresh_rate_adaptive_mask():<0-0> RSSI_LEVEL = 2
[23269.372029] rtl8192c_common:rtl92c_dm_refresh_rate_adaptive_mask():<0-0> PreState = 0, CurState = 2
[23269.372039] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> ratr_bitmap :ff0
[23269.372047] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> Rate_index:4, ratr_val:ff0, f0:0f:00:40:80
[23269.372052] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23269.372063] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d4) =  6
[23269.372079] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 2
[23269.372084] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23269.602610] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23269.704813] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23269.709636] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23270.113850] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23270.431302] rtl8192ce:rtl92ce_led_control():<300-1> ledaction 4
[23270.625091] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23270.727148] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23271.057455] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23271.137260] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23271.340739] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23271.369629] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x1e, pre_igvalue = 0x20, back_val = 10
[23271.369679] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> STA Default Port PWDB = 0x14
[23271.369691] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23271.369699] rtl8192c_common:rtl92c_dm_refresh_rate_adaptive_mask():<0-0> RSSI = 20
[23271.369704] rtl8192c_common:rtl92c_dm_refresh_rate_adaptive_mask():<0-0> RSSI_LEVEL = 3
[23271.369710] rtl8192c_common:rtl92c_dm_refresh_rate_adaptive_mask():<0-0> PreState = 2, CurState = 3
[23271.369720] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> ratr_bitmap :ff5
[23271.369728] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> Rate_index:4, ratr_val:ff5, f5:0f:00:40:80
[23271.369733] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23271.369744] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d8) =  6
[23271.369760] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 3
[23271.369765] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23271.647415] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23272.056480] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23272.058784] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.059607] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.060915] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.062017] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.063402] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.069051] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.070134] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.071400] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.082074] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.083444] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.087211] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.159908] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23272.670049] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23272.976758] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23273.181338] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23273.283476] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23273.284593] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23273.370868] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x1e, pre_igvalue = 0x20, back_val = 8
[23273.370910] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> STA Default Port PWDB = 0x15
[23273.370918] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23273.370925] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23273.373944] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23273.373955] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23273.373965] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23273.373974] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23273.373980] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23274.433343] rtl8192ce:rtl92ce_led_control():<300-1> ledaction 4
[23275.371304] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23275.371715] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x1e, pre_igvalue = 0x20, back_val = 6
[23275.371752] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> STA Default Port PWDB = 0x13
[23275.371764] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23275.641276] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23276.658725] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23276.669755] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23277.372907] rtlwifi:rtl_lps_enter():<0-0> Enter 802.11 power save mode...
[23277.372921] rtlwifi:rtl_lps_set_psmode():<0-0> FW LPS enter ps_mode:3
[23277.372931] rtl8192c_common:rtl92c_set_fw_pwrmode_cmd():<0-0> FW LPS mode = 3
[23277.372938] rtl8192c_common: In process "kworker/1:0" (pid 23592): rtl92c_set_fw_rsvdpagepkt(): u1_h2c_set_pwrmode
[23277.372945] 03 01 05                                         ...
[23277.372951] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23277.372962] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1dc) =  1
[23277.372975] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 0
[23277.372980] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23277.681057] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23277.688512] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23287.326999] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23296.674045] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23300.278139] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23302.662439] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23308.804117] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23325.683018] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23326.045982] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.047171] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.050485] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.055443] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.056446] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.057963] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.058786] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.059863] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.061152] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.062367] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.147033] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.351692] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.353840] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.355132] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.358643] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.364821] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.453872] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.454889] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.456194] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.464998] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.557232] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23326.565893] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23331.770598] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23351.145274] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23351.145293] rtlwifi:rtl_lps_leave():<0-0> Busy Traffic,Leave 802.11 power save..
[23351.145300] rtlwifi:rtl_lps_set_psmode():<0-0> FW LPS leave ps_mode:0
[23351.145313] rtl8192c_common:rtl92c_set_fw_pwrmode_cmd():<0-0> FW LPS mode = 0
[23351.145320] rtl8192c_common: In process "wpa_supplicant" (pid 27788): rtl92c_set_fw_rsvdpagepkt(): u1_h2c_set_pwrmode
[23351.145327] 00 01 05                                         ...
[23351.145334] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23351.145344] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d0) =  1
[23351.145357] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 1
[23351.145362] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23351.145368] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23351.145413] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x20, pre_igvalue = 0x20, back_val = 6
[23351.145458] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23351.205744] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.205756] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.275317] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.275333] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.345195] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.345211] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.415129] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.415144] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.415237] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23351.415263] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23351.415269] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23351.418288] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23351.418299] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23351.418311] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23351.418319] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23351.418325] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23351.485010] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.485025] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.554894] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.554909] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.624787] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.624803] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.694707] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.694722] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.764627] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.764642] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.834820] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.834834] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.904719] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.904734] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23351.974270] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23351.974285] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23352.044387] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.044402] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23352.114342] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.114356] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23352.114462] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23352.114484] rtlwifi:rtl_op_set_key():<0-0> Disabling hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[23352.114489] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23352.114501] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23352.114511] rtlwifi:rtl_op_set_key():<0-0> alg:TKIP
[23352.114520] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x22, pre_igvalue = 0x22, back_val = 6
[23352.114523] rtlwifi:rtl_op_set_key():<0-0> disable key delete one entry
[23352.114530] rtlwifi:rtl_cam_delete_one_entry():<0-0> key_idx:2
[23352.114539] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A4: 0
[23352.114546] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A0: 80010010
[23352.114630] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23352.115042] wlan0: deauthenticating from xx:xx:xx:xx:xx:xx by local choice (reason=2)
[23352.136101] rtlwifi:rtl_op_set_key():<0-0> Disabling hardware based encryption for keyidx: 0, mac: xx:xx:xx:xx:xx:xx
[23352.136115] rtlwifi:rtl_op_set_key():<0-0> alg:TKIP
[23352.136122] rtlwifi:rtl_op_set_key():<0-0> set enable_hw_sec, key_type:2(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
[23352.136132] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 2 GroupEncAlgorithm = 0
[23352.136141] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[23352.136149] rtlwifi:rtl_op_set_key():<0-0> disable key delete one entry
[23352.136156] rtlwifi:rtl_cam_delete_one_entry():<0-0> key_idx:0
[23352.136164] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A4: 0
[23352.136170] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A0: 80010000
[23352.136180] rtlwifi:rtl_op_sta_remove():<0-0> Remove sta addr is xx:xx:xx:xx:xx:xx
[23352.136234] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_UN_ASSOC
[23352.136240] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[23352.136249] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23352.136258] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_SHORTGI_DENSITY: 0x7
[23352.136274] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_FACTOR: 0xf
[23352.136279] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_MIN_SPACE: 0x7
[23352.136298] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23352.136318] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23352.136324] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23352.136510] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23352.136546] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23352.136564] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23352.136569] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23352.136594] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[23352.136618] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23352.138358] cfg80211: Calling CRDA to update world regulatory domain
[23352.156979] rtlwifi:rtl_reg_notifier():<0-0> 
[23352.156986] cfg80211: World regulatory domain updated:
[23352.156988] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23352.156992] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23352.156995] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23352.156998] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23352.157001] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23352.157004] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23352.157118] cfg80211: Calling CRDA for country: AT
[23352.175483] rtlwifi:rtl_reg_notifier():<0-0> 
[23352.175492] cfg80211: Regulatory domain changed to country: AT
[23352.175495] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23352.175498] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23352.175501] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23352.175504] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23352.175507] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[23352.236927] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23352.236943] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23352.236954] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x24, pre_igvalue = 0x24, back_val = 6
[23352.247079] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.247095] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23352.309172] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.309183] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23352.309340] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23352.309347] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x26, pre_igvalue = 0x26, back_val = 6
[23352.309462] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23352.309479] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23352.309482] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23352.311686] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23352.311696] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23352.311735] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23352.311739] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23352.311746] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[23352.311749] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
[23352.311844] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[23352.311846] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
[23352.336034] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.336096] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.336203] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.336309] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.336415] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.336520] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.336627] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.336733] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.336839] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.336945] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.337050] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.337156] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
[23352.337262] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:98053f15:10
[23352.338151] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23352.338161] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
[23352.556753] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 0 GroupEncAlgorithm = 0
[23352.556759] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[23352.559101] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23352.665030] rtl8192c_common:rtl92c_dm_initialize_txpower_tracking_thermalmeter():<0-0> pMgntInfo->txpower_tracking = 1
[23352.665037] rtlwifi:rtl_pci_start():<0-0> enable_interrupt OK
[23352.665040] rtlwifi:rtl_pci_start():<0-0> OK
[23352.665176] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23352.665180] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23352.665182] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23352.665190] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23352.665194] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23352.665203] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23352.665229] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[23352.665235] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23352.665252] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_LISTEN_INTERVAL
[23352.665259] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_RETRY_LIMITS 4
[23352.668205] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23352.668212] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23352.668218] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23352.668223] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23352.668226] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23352.678196] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.678201] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23352.678604] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[23352.681346] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23352.681356] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23352.681362] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x20, pre_igvalue = 0x0, back_val = 10
[23352.691502] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.691507] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23352.761107] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.761122] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23352.831024] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.831039] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23352.900970] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.900986] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23352.970803] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23352.970820] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.040655] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23353.040671] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.110550] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23353.110566] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.180481] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23353.180497] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.250386] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23353.250401] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.320247] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23353.320263] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.390133] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23353.390149] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.460028] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23353.460044] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.529954] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23353.529970] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.590725] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23353.599857] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23353.599872] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23353.600270] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23353.600282] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x22, pre_igvalue = 0x22, back_val = 10
[23353.600420] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23353.600440] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23353.600447] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23353.600488] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[23353.600514] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23353.650415] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23353.752703] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23353.800455] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
[23353.800491] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23354.001164] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
[23354.001203] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23354.059448] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23354.060430] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23354.162801] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23354.168686] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23354.201845] wlan0: authentication with xx:xx:xx:xx:xx:xx timed out
[23354.201920] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23354.201941] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23354.201948] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23354.265144] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23354.665466] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23354.665485] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23354.701977] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23354.701993] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23354.702004] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x24, pre_igvalue = 0x24, back_val = 10
[23354.712143] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23354.712159] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23354.782101] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23354.782116] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23354.851968] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23354.851984] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23354.921879] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23354.921895] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23354.991784] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23354.991800] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.061687] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.061703] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.131574] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.131590] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.201470] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.201485] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.271412] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.271427] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.341381] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.341396] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.411279] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.411295] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.481296] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.481311] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.551261] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.551276] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.612044] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23355.621001] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.621016] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.621151] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23355.621171] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x26, pre_igvalue = 0x26, back_val = 10
[23355.621392] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23355.621421] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23355.621429] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23355.621472] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[23355.621498] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23355.624584] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23355.635792] wlan0: authenticated
[23355.636573] rtl8192ce 0000:01:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
[23355.636838] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[23355.639421] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
[23355.639446] rtlwifi:rtl_op_sta_add():<0-0> Add sta addr is xx:xx:xx:xx:xx:xx
[23355.639455] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> ratr_bitmap :ff5
[23355.639462] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> Rate_index:4, ratr_val:ff5, f5:0f:00:40:80
[23355.639468] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23355.639479] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d0) =  6
[23355.639496] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 1
[23355.639502] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23355.639524] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ASSOC
[23355.639532] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23355.639556] rtl8192c_common: In process "kworker/u:7" (pid 22704): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23355.639565] 80 00 00 00 ff ff ff ff ff ff 60 d8 19 c8 fd 43  ..........`....C
[23355.639570] 20 4e 7f ab c8 ba 50 08 00 00 00 00 00 00 00 00   N....P.........
[23355.639575] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23355.639580] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23355.639585] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23355.639589] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639594] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23355.639598] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23355.639603] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639608] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639612] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639617] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639621] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639626] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639630] 10 00 20 8c 00 12 10 00 00 00 00 00 00 00 00 00  .. .............
[23355.639635] 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639640] a4 10 01 c0 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  .... N....`....C
[23355.639644] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639649] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639654] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639658] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639706] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639723] 18 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  .. .............
[23355.639738] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639754] 48 01 00 00 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  H... N....`....C
[23355.639769] 20 4e 7f ab c8 ba 00 00 00 00 00 00 00 00 00 00   N..............
[23355.639784] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639802] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639820] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639838] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639856] 72 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  r. .............
[23355.639864] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639869] 50 00 00 00 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  P... N....`....C
[23355.639874] 20 4e 7f ab c8 ba 00 00 9e 46 15 32 27 f2 2d 00   N.......F.2'.-.
[23355.639879] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23355.639884] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23355.639889] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23355.639893] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639898] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23355.639902] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23355.639907] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639912] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639918] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639923] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639927] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639932] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639937] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639941] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639947] rtl8192c_common: In process "kworker/u:7" (pid 22704): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23355.639952] 04 02 03                                         ...
[23355.639961] rtl8192ce: In process "kworker/u:7" (pid 22704): H2C Tx Cmd Content
[23355.639966] 00 03 20 8c 00 10 07 00 00 00 00 00 00 00 00 80  .. .............
[23355.639971] 80 01 00 00 00 00 00 00 00 00 00 00 00 03 00 00  ................
[23355.639975] 00 7a 39 0c 00 00 00 00 40 c0 66 b9 00 00 00 00  .z9.....@.f.....
[23355.639980] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23355.639988] rtl8192c_common:rtl92c_set_fw_rsvdpagepkt():<0-0> Set RSVD page location to Fw
[23355.639993] rtl8192c_common: In process "kworker/u:7" (pid 22704): H2C_RSVDPAGE
[23355.639997] 04 02 03                                         ...
[23355.640002] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23355.640011] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d4) =  3
[23355.640023] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 2
[23355.640028] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23355.640038] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23355.640054] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d8) =  2
[23355.640067] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 3
[23355.640071] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23355.641437] wlan0: associated
[23355.641462] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[23355.726347] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23355.726469] wlan0: AP xx:xx:xx:xx:xx:xx switches to unsupported channel (0 MHz), disconnecting
[23355.747655] rtlwifi:rtl_op_sta_remove():<0-0> Remove sta addr is xx:xx:xx:xx:xx:xx
[23355.747707] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_UN_ASSOC
[23355.747714] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[23355.747724] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.747734] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_SHORTGI_DENSITY: 0x7
[23355.747749] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_FACTOR: 0xf
[23355.747755] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_MIN_SPACE: 0x7
[23355.747773] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23355.747792] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23355.747798] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23355.748857] cfg80211: Calling CRDA to update world regulatory domain
[23355.762184] rtlwifi:rtl_reg_notifier():<0-0> 
[23355.762192] cfg80211: World regulatory domain updated:
[23355.762195] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23355.762199] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23355.762202] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23355.762205] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23355.762208] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23355.762211] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23355.762305] cfg80211: Calling CRDA for country: AT
[23355.774622] rtlwifi:rtl_reg_notifier():<0-0> 
[23355.774630] cfg80211: Regulatory domain changed to country: AT
[23355.774632] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23355.774636] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23355.774639] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23355.774642] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23355.774645] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[23355.848204] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23355.848220] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23355.848231] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x28, pre_igvalue = 0x28, back_val = 10
[23355.858463] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.858472] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.928341] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.928357] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23355.998254] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23355.998269] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.068181] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.068196] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.138025] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.138040] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.207984] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.208005] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.277881] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.277898] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.347725] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.347740] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.417633] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.417650] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.487554] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.487570] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.557441] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.557456] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.627352] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.627367] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.666198] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
[23356.666212] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
[23356.666221] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23356.666227] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23356.669247] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23356.669258] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23356.669268] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23356.669277] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23356.669283] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23356.697199] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.697215] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.757918] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23356.767133] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.767149] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.767410] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23356.767422] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x2a, pre_igvalue = 0x2a, back_val = 10
[23356.767555] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23356.767576] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23356.767582] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23356.767622] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[23356.767648] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23356.769741] wlan0: authenticated
[23356.770085] rtl8192ce 0000:01:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
[23356.770995] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[23356.773617] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
[23356.773637] rtlwifi:rtl_op_sta_add():<0-0> Add sta addr is xx:xx:xx:xx:xx:xx
[23356.773645] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> ratr_bitmap :ff5
[23356.773652] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> Rate_index:4, ratr_val:ff5, f5:0f:00:40:80
[23356.773658] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23356.773669] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1dc) =  6
[23356.773686] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 0
[23356.773691] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23356.773713] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ASSOC
[23356.773720] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23356.773745] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23356.773753] 80 00 00 00 ff ff ff ff ff ff 60 d8 19 c8 fd 43  ..........`....C
[23356.773758] 20 4e 7f ab c8 ba 50 08 00 00 00 00 00 00 00 00   N....P.........
[23356.773763] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23356.773768] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23356.773773] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23356.773778] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773782] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23356.773787] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23356.773792] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773796] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773801] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773805] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773810] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773815] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773819] 10 00 20 8c 00 12 10 00 00 00 00 00 00 00 00 00  .. .............
[23356.773824] 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773829] a4 10 01 c0 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  .... N....`....C
[23356.773833] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773838] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773842] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773847] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773852] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773856] 18 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  .. .............
[23356.773861] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773866] 48 01 00 00 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  H... N....`....C
[23356.773870] 20 4e 7f ab c8 ba 00 00 00 00 00 00 00 00 00 00   N..............
[23356.773875] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773879] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773884] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773889] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773893] 72 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  r. .............
[23356.773898] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773903] 50 00 00 00 20 4e 7f ab c8 ba 60 d8 19 c8 fd 43  P... N....`....C
[23356.773908] 20 4e 7f ab c8 ba 00 00 9e 46 15 32 27 f2 2d 00   N.......F.2'.-.
[23356.773913] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23356.773917] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23356.773922] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23356.773927] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773931] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23356.773936] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23356.773940] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773945] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773950] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773954] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773959] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773963] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773990] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.773996] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.774001] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23356.774006] 04 02 03                                         ...
[23356.774021] rtl8192ce: In process "kworker/u:1" (pid 27666): H2C Tx Cmd Content
[23356.774026] 00 03 20 8c 00 10 07 00 00 00 00 00 00 00 00 80  .. .............
[23356.774031] 80 01 00 00 00 00 00 00 00 00 00 00 00 03 00 00  ................
[23356.774035] 40 07 7c 84 00 00 00 00 40 c0 66 b9 00 00 00 00  @.|.....@.f.....
[23356.774040] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23356.774048] rtl8192c_common:rtl92c_set_fw_rsvdpagepkt():<0-0> Set RSVD page location to Fw
[23356.774053] rtl8192c_common: In process "kworker/u:1" (pid 27666): H2C_RSVDPAGE
[23356.774057] 04 02 03                                         ...
[23356.774062] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23356.774071] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d0) =  3
[23356.774083] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 1
[23356.774088] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23356.774098] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23356.774107] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d4) =  2
[23356.774128] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 2
[23356.774132] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23356.774151] wlan0: associated
[23356.851121] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23356.851231] wlan0: AP xx:xx:xx:xx:xx:xx switches to unsupported channel (0 MHz), disconnecting
[23356.871915] rtlwifi:rtl_op_sta_remove():<0-0> Remove sta addr is xx:xx:xx:xx:xx:xx
[23356.871962] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_UN_ASSOC
[23356.871969] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[23356.871979] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23356.871989] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_SHORTGI_DENSITY: 0x7
[23356.872004] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_FACTOR: 0xf
[23356.872010] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_MIN_SPACE: 0x7
[23356.872028] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23356.872047] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23356.872054] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23356.873052] cfg80211: Calling CRDA to update world regulatory domain
[23356.886829] rtlwifi:rtl_reg_notifier():<0-0> 
[23356.886841] cfg80211: World regulatory domain updated:
[23356.886845] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23356.886852] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23356.886858] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23356.886864] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23356.886870] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23356.886876] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23356.887024] cfg80211: Calling CRDA for country: AT
[23356.902915] rtlwifi:rtl_reg_notifier():<0-0> 
[23356.902929] cfg80211: Regulatory domain changed to country: AT
[23356.902934] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23356.902941] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23356.902947] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23356.902952] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23356.902957] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[23356.972413] rtlwifi:rtl_op_sw_scan_start():<0-0> 
[23356.972428] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 6
[23356.972439] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x2c, pre_igvalue = 0x2c, back_val = 10
[23356.982549] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23356.982564] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.051720] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.051736] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.121558] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.121574] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.191508] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.191524] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.261386] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.261402] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.331253] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.331269] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.401176] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.401193] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.471077] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.471093] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.540946] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.540961] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.610861] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.610877] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.680719] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.680735] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.750729] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.750745] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.820550] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.820566] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.881295] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[23357.890421] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
[23357.890437] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23357.890660] rtlwifi:rtl_op_sw_scan_complete():<0-0> 
[23357.890673] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x2e, pre_igvalue = 0x2e, back_val = 10
[23357.890805] rtlwifi:rtl_op_bss_info_changed():<0-0> xx:xx:xx:xx:xx:xx
[23357.890826] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23357.890833] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23357.890871] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[23357.890896] rtlwifi:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[23357.892827] wlan0: authenticated
[23357.893205] rtl8192ce 0000:01:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
[23357.893214] rtl8192ce 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[23357.893221] rtl8192ce 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[23357.893663] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[23357.895917] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=5)
[23357.895937] rtlwifi:rtl_op_sta_add():<0-0> Add sta addr is xx:xx:xx:xx:xx:xx
[23357.895945] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> ratr_bitmap :ff5
[23357.895953] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> Rate_index:4, ratr_val:ff5, f5:0f:00:40:80
[23357.895959] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23357.895970] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d8) =  6
[23357.895986] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 3
[23357.895991] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23357.896012] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ASSOC
[23357.896019] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 9
[23357.896048] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23357.896056] 80 00 00 00 ff ff ff ff ff ff 60 d8 19 c8 fd 43  ..........`....C
[23357.896062] 58 6d 8f da 92 a7 50 08 00 00 00 00 00 00 00 00  Xm....P.........
[23357.896067] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23357.896072] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23357.896077] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23357.896081] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896086] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23357.896091] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23357.896095] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896100] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896104] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896109] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896114] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896118] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896123] 10 00 20 8c 00 12 10 00 00 00 00 00 00 00 00 00  .. .............
[23357.896127] 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896132] a4 10 05 c0 58 6d 8f da 92 a7 60 d8 19 c8 fd 43  ....Xm....`....C
[23357.896137] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896142] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896146] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896151] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896155] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896160] 18 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  .. .............
[23357.896165] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896169] 48 01 00 00 58 6d 8f da 92 a7 60 d8 19 c8 fd 43  H...Xm....`....C
[23357.896174] 58 6d 8f da 92 a7 00 00 00 00 00 00 00 00 00 00  Xm..............
[23357.896179] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896184] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896188] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896193] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896197] 72 00 20 8c 00 12 00 00 00 00 00 00 00 00 00 80  r. .............
[23357.896202] 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896207] 50 00 00 00 58 6d 8f da 92 a7 60 d8 19 c8 fd 43  P...Xm....`....C
[23357.896212] 58 6d 8f da 92 a7 00 00 9e 46 15 32 27 f2 2d 00  Xm.......F.2'.-.
[23357.896217] 64 00 00 04 00 0c 6c 69 6e 6b 73 79 73 5f 77 6c  d.....linksys_wl
[23357.896221] 61 6e 01 04 82 84 8b 96 03 01 01 06 02 00 00 2a  an.............*
[23357.896226] 01 00 32 08 24 30 48 6c 0c 12 18 60 2d 1a 6c 18  ..2.$0Hl...`-.l.
[23357.896231] 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896236] 00 00 00 00 00 00 00 00 3d 00 dd 06 00 e0 4c 02  ........=.....L.
[23357.896240] 01 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .p..............
[23357.896245] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896249] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896254] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896259] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896263] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896268] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896272] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896277] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896283] rtl8192c_common: In process "kworker/u:1" (pid 27666): rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL
[23357.896306] 04 02 03                                         ...
[23357.896318] rtl8192ce: In process "kworker/u:1" (pid 27666): H2C Tx Cmd Content
[23357.896323] 00 03 20 8c 00 10 07 00 00 00 00 00 00 00 00 80  .. .............
[23357.896328] 80 01 00 00 00 00 00 00 00 00 00 00 00 03 00 00  ................
[23357.896332] 40 64 7c 84 00 00 00 00 40 c0 66 b9 00 00 00 00  @d|.....@.f.....
[23357.896337] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[23357.896344] rtl8192c_common:rtl92c_set_fw_rsvdpagepkt():<0-0> Set RSVD page location to Fw
[23357.896349] rtl8192c_common: In process "kworker/u:1" (pid 27666): H2C_RSVDPAGE
[23357.896354] 04 02 03                                         ...
[23357.896358] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23357.896377] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1dc) =  3
[23357.896389] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 0
[23357.896394] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23357.896405] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23357.896414] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d0) =  2
[23357.896426] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 1
[23357.896430] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23357.898517] wlan0: associated
[23357.900037] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23357.901901] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23357.910552] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23357.910833] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23357.911014] rtlwifi:rtl_op_set_key():<0-0> Using hardware based encryption for keyidx: 0, mac: xx:xx:xx:xx:xx:xx
[23357.911022] rtlwifi:rtl_op_set_key():<0-0> alg:TKIP
[23357.911028] rtlwifi:rtl_op_set_key():<0-0> set enable_hw_sec, key_type:2(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
[23357.911035] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 2 GroupEncAlgorithm = 0
[23357.911043] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[23357.911051] rtlwifi:rtl_op_set_key():<0-0> set pairwise key
[23357.911059] rtl8192ce:rtl92ce_set_key():<0-0> The insert KEY length is 32
[23357.911064] rtl8192ce:rtl92ce_set_key():<0-0> The insert KEY is 60 51
[23357.911069] rtl8192ce:rtl92ce_set_key():<0-0> add one entry
[23357.911075] rtl8192ce: In process "wpa_supplicant" (pid 27788): Pairwise Key content
[23357.911082] 60 51 ca 9e 86 08 7a 64 65 92 3b 56 af cf bc e6  `Q....zde.;V....
[23357.911088] dd 61 bb 4b 44 6b 5e ca 5f f3 ef ca 0e 0b 86 cb  .a.KDk^._.......
[23357.911092] rtl8192ce:rtl92ce_set_key():<0-0> set Pairwise key
[23357.911101] rtlwifi:rtl_cam_add_one_entry():<0-0> EntryNo:4, ulKeyId=0, ulEncAlg=2, ulUseDK=0 MacAddr xx:xx:xx:xx:xx:xx
[23357.911107] rtlwifi:rtl_cam_program_entry():<0-0> key_cont_128: 60:51:ca:9e:86:08
[23357.911117] rtlwifi:rtl_cam_program_entry():<0-0> WRITE 674: 6d588008
[23357.911121] rtlwifi:rtl_cam_program_entry():<0-0> The Key ID is 4
[23357.911127] rtlwifi:rtl_cam_program_entry():<0-0> WRITE 670: 80010020
[23357.911135] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: a792da8f
[23357.911140] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010021
[23357.911249] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 9eca5160
[23357.911254] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010022
[23357.911364] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 647a0886
[23357.911369] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010023
[23357.911477] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 563b9265
[23357.911482] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010024
[23357.911590] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: e6bccfaf
[23357.911595] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010025
[23357.911704] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 4bbb61dd
[23357.911708] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010026
[23357.911817] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: ca5e6b44
[23357.911821] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010027
[23357.911826] rtlwifi:rtl_cam_program_entry():<0-0> after set key, usconfig:8008
[23357.911831] rtlwifi:rtl_cam_add_one_entry():<0-0> <===
[23357.920999] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23357.921452] rtlwifi:rtl_op_set_key():<0-0> Using hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[23357.921460] rtlwifi:rtl_op_set_key():<0-0> alg:TKIP
[23357.921466] rtlwifi:rtl_op_set_key():<0-0> set group key
[23357.921474] rtl8192ce:rtl92ce_set_key():<0-0> The insert KEY length is 32
[23357.921480] rtl8192ce:rtl92ce_set_key():<0-0> The insert KEY is 60 51
[23357.921485] rtl8192ce:rtl92ce_set_key():<0-0> add one entry
[23357.921490] rtl8192ce:rtl92ce_set_key():<0-0> set group key
[23357.921498] rtlwifi:rtl_cam_add_one_entry():<0-0> EntryNo:2, ulKeyId=2, ulEncAlg=2, ulUseDK=0 MacAddr ff:ff:ff:ff:ff:ff
[23357.921505] rtlwifi:rtl_cam_program_entry():<0-0> key_cont_128: c1:a4:7e:90:5e:fd
[23357.921515] rtlwifi:rtl_cam_program_entry():<0-0> WRITE 674: ffff800a
[23357.921520] rtlwifi:rtl_cam_program_entry():<0-0> The Key ID is 2
[23357.921525] rtlwifi:rtl_cam_program_entry():<0-0> WRITE 670: 80010010
[23357.921534] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: ffffffff
[23357.921539] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010011
[23357.921648] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 907ea4c1
[23357.921653] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010012
[23357.921762] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 4a12fd5e
[23357.921766] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010013
[23357.921875] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: ce29578c
[23357.921879] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010014
[23357.921988] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: cb437e22
[23357.921992] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010015
[23357.922101] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 67c8c318
[23357.922106] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010016
[23357.922214] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A4: 851d1b2f
[23357.922219] rtlwifi:rtl_cam_program_entry():<0-0> WRITE A0: 80010017
[23357.922224] rtlwifi:rtl_cam_program_entry():<0-0> after set key, usconfig:800a
[23357.922229] rtlwifi:rtl_cam_add_one_entry():<0-0> <===
[23357.922348] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23357.944837] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23358.005879] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23358.047133] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23358.149349] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23358.251627] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23358.353876] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23358.456172] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23358.558371] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23358.660591] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23358.667251] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x1e, pre_igvalue = 0x30, back_val = 8
[23358.667334] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> STA Default Port PWDB = 0x16
[23358.667364] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23358.667371] rtl8192c_common:rtl92c_dm_refresh_rate_adaptive_mask():<0-0> RSSI = 22
[23358.667377] rtl8192c_common:rtl92c_dm_refresh_rate_adaptive_mask():<0-0> RSSI_LEVEL = 2
[23358.667383] rtl8192c_common:rtl92c_dm_refresh_rate_adaptive_mask():<0-0> PreState = 0, CurState = 2
[23358.667393] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> ratr_bitmap :ff0
[23358.667400] rtl8192ce:rtl92ce_update_hal_rate_mask():<0-0> Rate_index:4, ratr_val:ff0, f0:0f:00:40:80
[23358.667406] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23358.667416] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d4) =  6
[23358.667433] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 2
[23358.667438] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23358.865112] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23359.376503] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23359.580904] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23359.683079] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23359.785563] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23359.887765] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23360.501208] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23360.603529] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23360.668196] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x1e, pre_igvalue = 0x20, back_val = 10
[23360.668242] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> STA Default Port PWDB = 0x18
[23360.668249] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23360.668256] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23360.671276] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23360.671287] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23360.671297] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23360.671306] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23360.671312] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23360.705536] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23361.012450] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23361.114766] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23361.216826] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23361.319286] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23361.421475] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23361.495017] rtl8192ce:rtl92ce_led_control():<300-1> ledaction 4
[23361.728194] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23362.137245] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23362.239428] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23362.341766] rtlwifi:rtl_recognize_peer():<10000-1> =>broad find
[23362.553293] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23362.669466] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x1e, pre_igvalue = 0x20, back_val = 8
[23362.669509] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> STA Default Port PWDB = 0x18
[23362.669520] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
[23364.670494] rtl8192c_common:rtl92c_dm_write_dig():<0-0> cur_igvalue = 0x20, pre_igvalue = 0x20, back_val = 6
[23364.670544] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> STA Default Port PWDB = 0x1c
[23364.670553] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Schedule TxPowerTracking direct call!!
[23364.670559] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> rtl92c_dm_txpower_tracking_callback_thermalmeter
[23364.673578] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe
[23364.673589] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial pathA ele_d reg0xc80 = 0x40000000, ofdm_index=0xc
[23364.673599] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Initial reg0xa24 = 0x90e1317, cck_index=0xc, ch14 0
[23364.673608] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> Readback Thermal Meter = 0xe pre thermal meter 0xe eeprom_thermalmeter 0xe delta 0x0 delta_lck 0x0 delta_iqk 0x0
[23364.673614] rtl8192c_common:rtl92c_dm_txpower_tracking_callback_thermalmeter():<0-0> <===
[23365.497275] rtl8192ce:rtl92ce_led_control():<300-1> ledaction 4
[23365.703170] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23366.023596] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23366.671496] rtlwifi:rtl_lps_enter():<0-0> Enter 802.11 power save mode...
[23366.671510] rtlwifi:rtl_lps_set_psmode():<0-0> FW LPS enter ps_mode:3
[23366.671520] rtl8192c_common:rtl92c_set_fw_pwrmode_cmd():<0-0> FW LPS mode = 3
[23366.671527] rtl8192c_common: In process "kworker/0:0" (pid 27876): rtl92c_set_fw_rsvdpagepkt(): u1_h2c_set_pwrmode
[23366.671534] 03 01 05                                         ...
[23366.671540] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23366.671551] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1d8) =  1
[23366.671564] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 3
[23366.671570] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23367.046069] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23368.068563] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23381.054146] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23382.078081] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23382.078941] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23382.079929] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23382.082241] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23382.083527] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23384.380889] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23386.064178] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23387.086800] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23388.007091] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23388.014268] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23391.184340] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23391.310478] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23391.381076] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23392.506216] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23393.127969] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23394.039436] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23394.040717] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23396.084556] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23396.094177] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23397.106843] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23397.112614] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23399.049580] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23399.356936] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23399.357871] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23399.361088] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23399.458983] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23399.460086] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23399.461272] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23399.469935] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23399.669847] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23400.379411] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23400.388927] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23401.094714] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23401.097411] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23401.197384] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23401.772998] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23401.812990] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23401.819433] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23401.823115] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23402.117339] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23402.126160] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23403.139664] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23404.059948] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23405.092402] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23406.104891] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23406.784199] rtl8192ce:rtl92ce_led_control():<200-1> ledaction 4
[23407.127378] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23408.149853] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23409.070128] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23410.092430] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23411.125718] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23412.137713] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23412.143154] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23412.144160] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23413.058004] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23413.160018] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23414.090628] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23414.182361] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23415.102778] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23417.147729] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23417.148989] rtl8192ce:rtl92ce_led_control():<10100-1> ledaction 5
[23418.170201] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23423.488922] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23423.490061] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23423.491318] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23423.494071] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23423.495370] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23423.499806] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23423.503824] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23424.204188] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23424.208630] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23425.662165] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23425.663344] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23427.782342] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23428.190513] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23428.191689] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23428.192603] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23428.194562] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23428.293031] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23429.213047] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23429.214344] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23429.222007] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23430.951785] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23431.770711] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23431.773216] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23431.778663] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23431.781326] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23431.782967] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23431.784519] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23431.872968] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23432.587664] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23435.859443] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23435.862281] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23436.065811] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23436.066991] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23436.166319] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23436.168541] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23436.171500] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23437.188303] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23438.210797] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23438.722511] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23439.438272] rtl8192ce:rtl92ce_led_control():<10000-1> ledaction 5
[23444.760262] wlan0: deauthenticating from xx:xx:xx:xx:xx:xx by local choice (reason=3)
[23444.760366] rtlwifi:rtl_op_set_key():<0-0> Disabling hardware based encryption for keyidx: 0, mac: xx:xx:xx:xx:xx:xx
[23444.760374] rtlwifi:rtl_op_set_key():<0-0> alg:TKIP
[23444.760381] rtlwifi:rtl_op_set_key():<0-0> set enable_hw_sec, key_type:2(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
[23444.760388] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 2 GroupEncAlgorithm = 2
[23444.760397] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[23444.760405] rtlwifi:rtl_op_set_key():<0-0> disable key delete one entry
[23444.760412] rtlwifi:rtl_cam_delete_one_entry():<0-0> key_idx:0
[23444.760421] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A4: 0
[23444.760426] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A0: 80010000
[23444.760436] rtlwifi:rtl_op_sta_remove():<0-0> Remove sta addr is xx:xx:xx:xx:xx:xx
[23444.760792] rtlwifi:rtl_lps_leave():<0-0> Busy Traffic,Leave 802.11 power save..
[23444.760798] rtlwifi:rtl_lps_set_psmode():<0-0> FW LPS leave ps_mode:0
[23444.760811] rtl8192c_common:rtl92c_set_fw_pwrmode_cmd():<0-0> FW LPS mode = 0
[23444.760819] rtl8192c_common: In process "modprobe" (pid 27992): rtl92c_set_fw_rsvdpagepkt(): u1_h2c_set_pwrmode
[23444.760826] 00 01 05                                         ...
[23444.760832] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> come in
[23444.760842] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> Write element_id box_reg( 1dc) =  1
[23444.760855] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> pHalData->last_hmeboxnum  = 0
[23444.760860] rtl8192c_common:_rtl92c_fill_h2c_command():<0-0> go out
[23444.760868] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_UN_ASSOC
[23444.760874] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
[23444.760883] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
[23444.760892] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_SHORTGI_DENSITY: 0x7
[23444.760907] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_FACTOR: 0xf
[23444.760913] rtl8192ce:rtl92ce_set_hw_reg():<0-0> Set HW_VAR_AMPDU_MIN_SPACE: 0x7
[23444.760932] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[23444.760951] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23444.760958] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23444.762097] rtlwifi:rtl_op_set_key():<0-0> Disabling hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[23444.762107] rtlwifi:rtl_op_set_key():<0-0> alg:TKIP
[23444.762113] rtlwifi:rtl_op_set_key():<0-0> set enable_hw_sec, key_type:2(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
[23444.762120] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 2 GroupEncAlgorithm = 0
[23444.762128] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
[23444.762136] rtlwifi:rtl_op_set_key():<0-0> disable key delete one entry
[23444.762141] rtlwifi:rtl_cam_delete_one_entry():<0-0> key_idx:2
[23444.762150] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A4: 0
[23444.762155] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A0: 80010010
[23444.767549] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23444.767563] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23444.767613] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
[23444.767619] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
[23444.767630] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[23444.767635] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
[23444.767737] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
[23444.767742] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
[23444.769676] cfg80211: Calling CRDA to update world regulatory domain
[23444.792603] cfg80211: World regulatory domain updated:
[23444.792613] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23444.792617] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23444.792620] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23444.792623] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[23444.792626] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23444.792629] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[23444.792655] cfg80211: Calling CRDA for country: AT
[23444.827263] cfg80211: Regulatory domain changed to country: AT
[23444.827274] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[23444.827278] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23444.827281] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23444.827284] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[23444.827287] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
