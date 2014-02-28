Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43491 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbaB1VaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 16:30:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1WJV0M-00053y-Gb
	for linux-wireless@vger.kernel.org; Fri, 28 Feb 2014 22:30:02 +0100
Received: from c-98-234-235-84.hsd1.ca.comcast.net ([98.234.235.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 22:30:02 +0100
Received: from ceasere by c-98-234-235-84.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 22:30:02 +0100
To: linux-wireless@vger.kernel.org
From: Ed Ceaser <ceasere@gmail.com>
Subject: rtl8821ae constantly dropping signal
Date: Fri, 28 Feb 2014 21:23:49 +0000 (UTC)
Message-ID: <lequp5$cub$1@ger.gmane.org> (sfid-20140228_223010_474081_A0468EFA)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

I'm trying to get a Realtek 8821ae chip working, using the staged drivers 
in the kernel's Git repo.

Everything works fine up until the point where I actually connect to a 
secured 802.11n wireless network. At this point, I connect to the access 
point, but it repeatedly drops and reassociates every few seconds.

My access point's logs don't really say anything useful, but I pasted the 
driver's logs from one "cycle" at the end of this post.

I'd love to help out with debugging this, but I'm not really sure here 
where the actual drop out of the signal is occurring, so I don't really 
know where to start looking in the driver for issues. Any guidance would 
be appreciated.

[ 4263.189320] wlan0: associated
[ 4263.189354] cfg80211: Calling CRDA for country: US
[ 4263.190508] rtl8821ae-0:rtl_is_special_data():<10000-1> 802.1X Rx EAPOL 
pkt!!
[ 4263.190926] rtl8821ae-0:rtl_is_special_data():<200-1> 802.1X Tx EAPOL 
pkt!!
[ 4263.190962] rtl8821ae-0:rtl_is_special_data():<100-1> 802.1X Tx EAPOL 
pkt!!
[ 4263.191637] cfg80211: Regulatory domain changed to country: US
[ 4263.191639] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[ 4263.191640] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2700 mBm)
[ 4263.191640] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 1700 mBm)
[ 4263.191641] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[ 4263.191642] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[ 4263.191643] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[ 4263.191643] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 3000 mBm)
[ 4263.191644] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), 
(N/A, 4000 mBm)
[ 4263.192549] rtl8821ae-0:rtl_is_special_data():<10000-1> 802.1X Rx EAPOL 
pkt!!
[ 4263.192618] rtl8821ae-0:rtl_is_special_data():<200-1> 802.1X Tx EAPOL 
pkt!!
[ 4263.192655] rtl8821ae-0:rtl_is_special_data():<100-1> 802.1X Tx EAPOL 
pkt!!
[ 4263.192677] rtl8821ae-0:rtl_op_set_key():<0-0> Using hardware based 
encryption for keyidx: 0, mac: c2:9f:db:1b:70:00
[ 4263.192680] rtl8821ae-0:rtl_op_set_key():<0-0> alg:CCMP
[ 4263.192682] rtl8821ae-0:rtl_op_set_key():<0-0> set enable_hw_sec, 
key_type:4(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
[ 4263.192683] rtl8821ae-0:rtl8821ae_enable_hw_security_config():<0-0> 
PairwiseEncAlgorithm = 4 GroupEncAlgorithm = 0
[ 4263.192688] rtl8821ae-0:rtl8821ae_enable_hw_security_config():<0-0> 
The SECR-value cc 
[ 4263.192692] rtl8821ae-0:rtl_op_set_key():<0-0> set pairwise key
[ 4263.192693] rtl8821ae-0:rtl8821ae_set_key():<0-0> add one entry
[ 4263.192694] rtl8821ae-0:rtl8821ae_set_key():<0-0> set Pairwiase key
[ 4263.192695] rtl8821ae-0:rtl_cam_add_one_entry():<0-0> EntryNo:4, 
ulKeyId=0, ulEncAlg=4, ulUseDK=0 MacAddr c2:9f:db:1b:70:00
[ 4263.192696] rtl8821ae: 
[ 4263.192697] In process "wpa_supplicant" (pid 2682):Key content :C0 E1 
9E 1C  CD 2A 0D 95  91 B5 9C 79  64 DB 8F 10  
[ 4263.192702] 
[ 4263.193338] rtl8821ae-0:rtl_cam_add_one_entry():<0-0> end 
[ 4263.193387] rtl8821ae-0:rtl_op_set_key():<0-0> Using hardware based 
encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
[ 4263.193389] rtl8821ae-0:rtl_op_set_key():<0-0> alg:CCMP
[ 4263.193390] rtl8821ae-0:rtl_op_set_key():<0-0> set group key
[ 4263.193391] rtl8821ae-0:rtl8821ae_set_key():<0-0> add one entry
[ 4263.193392] rtl8821ae-0:rtl8821ae_set_key():<0-0> set group key
[ 4263.193393] rtl8821ae-0:rtl_cam_add_one_entry():<0-0> EntryNo:1, 
ulKeyId=1, ulEncAlg=4, ulUseDK=0 MacAddr ff:ff:ff:ff:ff:ff
[ 4263.193394] rtl8821ae: 
[ 4263.193394] In process "wpa_supplicant" (pid 2682):Key content :80 13 
83 F8  70 13 94 DC  0B FE 58 60  58 24 3A 3F  
[ 4263.193399] 
[ 4263.194035] rtl8821ae-0:rtl_cam_add_one_entry():<0-0> end 
[ 4263.231685] wlan0: Limiting TX power to 17 (17 - 0) dBm as advertised 
by c2:9f:db:1b:70:00
[ 4263.394466] userif-3: sent link down event.
[ 4263.394468] userif-3: sent link up event.
[ 4265.066164] rtl8821ae-0:rtl_watchdog_wq_callback():<0-0> AP off for 2 s
[ 4267.474444] rtl8821ae-0:rtl_watchdog_wq_callback():<0-0> AP off for 4 s
[ 4269.077219] rtl8821ae-0:rtl_watchdog_wq_callback():<0-0> AP off for 6 s
[ 4271.082791] rtl8821ae-0:rtl_watchdog_wq_callback():<0-0> AP off for 8 s
[ 4273.088445] rtl8821ae-0:rtl_watchdog_wq_callback():<0-0> AP off for 10 
s
[ 4273.088448] rtl8821ae-0:rtl_watchdog_wq_callback():<0-0> AP off, try 
to reconnect now
[ 4273.088476] wlan0: Connection to AP c2:9f:db:1b:70:00 lost
[ 4273.100349] rtl8821ae-0:rtl_op_set_key():<0-0> Disabling hardware 
based encryption for keyidx: 0, mac: c2:9f:db:1b:70:00
[ 4273.100352] rtl8821ae-0:rtl_op_set_key():<0-0> alg:CCMP
[ 4273.100353] rtl8821ae-0:rtl_op_set_key():<0-0> set enable_hw_sec, 
key_type:4(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
[ 4273.100354] rtl8821ae-0:rtl8821ae_enable_hw_security_config():<0-0> 
PairwiseEncAlgorithm = 4 GroupEncAlgorithm = 4
[ 4273.100361] rtl8821ae-0:rtl8821ae_enable_hw_security_config():<0-0> 
The SECR-value cc 
[ 4273.100364] rtl8821ae-0:rtl_op_set_key():<0-0> disable key delete one 
entry
[ 4273.100366] rtl8821ae-0:rtl_cam_delete_one_entry():<0-0> key_idx:0
[ 4273.100371] rtl8821ae-0:rtl_cam_delete_one_entry():<0-0> 
rtl_cam_delete_one_entry(): WRITE A4: 0 
[ 4273.100372] rtl8821ae-0:rtl_cam_delete_one_entry():<0-0> 
rtl_cam_delete_one_entry(): WRITE A0: 80010000 
[ 4273.100375] rtl8821ae-0:rtl_op_sta_remove():<0-0> Remove sta addr is 
c2:9f:db:1b:70:00
[ 4273.100382] rtl8821ae-0:rtl_op_bss_info_changed():<0-0> 
BSS_CHANGED_UN_ASSOC
[ 4273.100411] rtl8821ae-0:rtl_op_bss_info_changed():<0-0> bssid: 
00:00:00:00:00:00
[ 4273.112365] rtl8821ae-0:rtl_op_set_key():<0-0> Disabling hardware 
based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
[ 4273.112367] rtl8821ae-0:rtl_op_set_key():<0-0> alg:CCMP
[ 4273.112369] rtl8821ae-0:rtl_op_set_key():<0-0> disable key delete one 
entry
[ 4273.112370] rtl8821ae-0:rtl_cam_delete_one_entry():<0-0> key_idx:1
[ 4273.112376] rtl8821ae-0:rtl_cam_delete_one_entry():<0-0> 
rtl_cam_delete_one_entry(): WRITE A4: 0 
[ 4273.112377] rtl8821ae-0:rtl_cam_delete_one_entry():<0-0> 
rtl_cam_delete_one_entry(): WRITE A0: 80010008 
[ 4273.112401] cfg80211: Calling CRDA to update world regulatory domain
[ 4273.114892] cfg80211: World regulatory domain updated:
[ 4273.114895] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[ 4273.114896] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[ 4273.114897] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[ 4273.114898] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[ 4273.114898] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[ 4273.114899] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[ 4273.201076] rtl8821ae-0:rtl8821ae_phy_switch_wirelessband():<0-0> 2.4G
[ 4273.288789] userif-3: sent link down event.
[ 4273.288791] userif-3: sent link up event.
[ 4273.816895] rtl8821ae-0:rtl8821ae_phy_switch_wirelessband():<0-0> 5G
[ 4275.222343] wlan0: authenticate with c2:9f:db:1b:70:00
[ 4275.222679] rtl8821ae-0:rtl_op_bss_info_changed():<0-0> bssid: 
c2:9f:db:1b:70:00
[ 4275.222713] wlan0: send auth to c2:9f:db:1b:70:00 (try 1/3)
[ 4275.222718] rtl8821ae-0:rtl_tx_mgmt_proc():<200-1> MAC80211_LINKING
[ 4275.223815] wlan0: authenticated
[ 4275.226048] wlan0: associate with c2:9f:db:1b:70:00 (try 1/3)
[ 4275.226820] wlan0: RX AssocResp from c2:9f:db:1b:70:00 (capab=0x411 
status=0 aid=1)
[ 4275.226824] rtl8821ae-0:rtl_op_sta_add():<0-0> Add sta addr is 
c2:9f:db:1b:70:00
[ 4275.226826] rtl8821ae-0:rtl8821ae_update_hal_rate_mask():<0-0> 
ratr_bitmap :ff000
[ 4275.226827] rtl8821ae-0:rtl8821ae_update_hal_rate_mask():<0-0> 
Rate_index:0, ratr_val:ff000, 0:81:1:0:f0:f:0
[ 4275.226864] rtl8821ae-0:rtl8821ae_update_hal_rate_mask():<0-0> 
ratr_bitmap :ff000
[ 4275.226865] rtl8821ae-0:rtl8821ae_update_hal_rate_mask():<0-0> 
Rate_index:0, ratr_val:ff000, 0:81:1:0:f0:f:0
[ 4275.226890] rtl8821ae-0:rtl_op_bss_info_changed():<0-0> 
BSS_CHANGED_ASSOC
[ 4275.226908] rtl8821ae-0:rtl8821ae_set_hw_reg():<0-0> switch case not 
process 5c
[ 4275.226932] rtl8821ae: 
[ 4275.226932] In process "kworker/u16:4" (pid 
199):rtl8821ae_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL 
[ 4275.226934] 03 01 02 
[ 4275.226935] 
[ 4275.226939] rtl8821ae: 
[ 4275.226940] In process "kworker/u16:4" (pid 199):H2C_RSVDPAGE:
[ 4275.226941] 03 01 02 
[ 4275.226942] 
[ 4275.226993] wlan0: associated

