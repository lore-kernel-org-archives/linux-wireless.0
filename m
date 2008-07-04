Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:59550 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbYGDWKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 18:10:05 -0400
Message-ID: <486EAD93.5060109@gentoo.org> (sfid-20080705_001024_454124_2F3D1601)
Date: Fri, 04 Jul 2008 18:09:07 -0500
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
Subject: 2.6.26: iwl4965 problems changing interface mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think I've found a bug changing from managed to ad-hoc mode, using 
iwl4965 on 2.6.26-rc8. This is a regression as it worked fine in 2.6.25. 
It is reproducible every time.

To reproduce:
Load the driver, bring up the default managed interface and associate to 
a network. (I think association is important here, the bug does not 
appear unless you associate at this point)
Then bring the interface down and perform the steps shown below. I also 
included debug message output showing what's going on.

# iwconfig wlan0 mode ad-hoc

# ifconfig wlan0 up

iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 
100102, writing 100106)
iwl4965: U iwl4965_power_init_handle Initialize power
iwl4965: U iwl4965_power_init_handle adjust power command flags
iwl4965: U iwl4965_hw_nic_init HW Revision ID = 0x61
iwl4965: U iwl4965_hw_card_show_info 4965ABGN HW Version 0.0.209
iwl4965: U iwl4965_hw_card_show_info 4965ABGN PBA Number 3379011
iwl4965: U iwl4965_load_bsm Begin load bsm
iwl4965: U iwl4965_verify_bsm Begin verify bsm
iwl4965: U iwl4965_verify_bsm BSM bootstrap uCode image OK
iwl4965: U iwl4965_load_bsm BSM write complete, poll 1 iterations
iwl4965: U __iwl4965_up iwl4965 is coming up
iwl4965: U iwl4965_mac_start Start UP work done.
iwl4965: I iwl4965_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 
0x1 0x9
iwl4965: I iwl4965_rx_reply_alive Initialization Alive received.
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
iwl4965: U iwl4965_verify_ucode Initialize uCode is good in inst SRAM
iwl4965: U iwl4965_get_temperature Running temperature calibration
iwl4965: U iwl4965_get_temperature Calib values R[1-3]: -164 13532 
-13690 R4: -3152
iwl4965: U iwl4965_get_temperature Calibrated temperature: 317K, 44C
iwl4965: U iwl4965_init_alive_start Initialization Alive received.
iwl4965: U iwl4965_set_ucode_ptrs Runtime uCode pointers are set.
iwl4965: I iwl4965_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
iwl4965: I iwl4965_rx_reply_alive Alive ucode status 0x00000001 revision 
0x1 0x0
iwl4965: I iwl4965_rx_reply_alive Runtime Alive received.
iwl4965: U iwl4965_alive_start Runtime Alive received.
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 788
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 10312
iwl4965: U iwl4965_verify_inst_sparse ucode inst image size is 92720
iwl4965: U iwl4965_verify_ucode Runtime uCode is good in inst SRAM
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 0 on AC 3
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 1 on AC 2
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 2 on AC 1
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 3 on AC 0
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 4 on AC 4
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 5 on AC 5
iwl4965: U iwl4965_tx_queue_set_status Activate AC Queue 6 on AC 6
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_STATISTICS_CMD 
(#9c), seq: 0x0400, 8 bytes at 0[0]:4
iwl4965: U iwl4965_update_power_cmd Flags value = 0x00000000
iwl4965: U iwl4965_update_power_cmd Tx timeout = 0
iwl4965: U iwl4965_update_power_cmd Rx timeout = 0
iwl4965: U iwl4965_update_power_cmd Sleep interval vector = { 0 , 0 , 0 
, 0 , 0 }
iwl4965: U iwl4965_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), 
seq: 0x0401, 40 bytes at 1[1]:4
iwl4965: I iwl4965_rx_handle r = 4, i = 2, REPLY_STATISTICS_CMD, 0x9c
iwl4965: I iwl4965_get_temperature Running temperature calibration
iwl4965: I iwl4965_get_temperature Calib values R[1-3]: -164 13532 
-13690 R4: -3152
iwl4965: I iwl4965_get_temperature Calibrated temperature: 317K, 44C
iwl4965: I iwl4965_is_temp_calib_needed Getting cooler, delta -9,
iwl4965: I iwl4965_is_temp_calib_needed Thermal txpower calib needed
iwl4965: I iwl_generic_cmd_callback back from REPLY_STATISTICS_CMD 
(0x00000000)
iwl4965: I iwl4965_rx_handle r 4 i 3 No handler needed for 
POWER_TABLE_CMD, 0x77
iwl4965: U iwl4965_set_rxon_chain rx chain 280E
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), 
seq: 0x0402, 16 bytes at 2[2]:4
iwl4965: I iwl4965_rx_handle r 5 i 4 No handler needed for 
REPLY_BT_CONFIG, 0x9b
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel = 1
* bssid = 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 
0x0403, 48 bytes at 3[3]:4
iwl4965: I iwl4965_rx_handle r 6 i 5 No handler needed for REPLY_RXON, 0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD 
(#97), seq: 0x0404, 140 bytes at 4[4]:4
iwl4965: I iwl4965_rx_handle r 7 i 6 No handler needed for 
REPLY_TX_PWR_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), 
seq: 0x0405, 72 bytes at 5[5]:4
iwl4965: I iwl4965_rx_handle r = 8, i = 7, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command 
REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0406, 92 bytes at 6[6]:4
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_CT_KILL_CONFIG_CMD 
(#a4), seq: 0x0407, 16 bytes at 7[7]:4
iwl4965: I iwl4965_rx_handle r 10 i 8 No handler needed for 
REPLY_TX_LINK_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD 
(0x00000000)
iwl4965: I iwl4965_rx_handle r 10 i 9 No handler needed for 
REPLY_CT_KILL_CONFIG_CMD, 0xa4
iwl4965: U iwl4965_rf_kill_ct_config REPLY_CT_KILL_CONFIG_CMD succeeded
iwl4965: U iwl4965_alive_start ALIVE processing complete.
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD 
(#97), seq: 0x0408, 140 bytes at 8[8]:4
iwl4965: U iwl4965_mac_start leave
iwl4965: U iwl4965_mac_add_interface enter: type 3
iwl4965: I iwl4965_rx_handle r 11 i 10 No handler needed for 
REPLY_TX_PWR_TABLE_CMD, 0x97
iwl4965: U iwl4965_mac_add_interface Set 00:1d:e0:be:4e:1d
iwl4965: U iwl4965_set_rxon_chain rx chain 280E
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel = 1
* bssid = 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 
0x0409, 48 bytes at 9[9]:4
iwl4965: I iwl4965_rx_handle r 12 i 11 No handler needed for REPLY_RXON, 
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD 
(#97), seq: 0x040A, 140 bytes at 10[10]:4
iwl4965: I iwl4965_rx_handle r 13 i 12 No handler needed for 
REPLY_TX_PWR_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), 
seq: 0x040B, 72 bytes at 11[11]:4
iwl4965: I iwl4965_rx_handle r = 14, i = 13, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command 
REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x040C, 92 bytes at 12[12]:4
iwl4965: U iwl4965_mac_add_interface leave
iwl4965: U iwl4965_mac_config_interface bssid: 00:00:00:00:00:00
iwl4965: U iwl4965_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel = 1
* bssid = 00:00:00:00:00:00
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 
0x040D, 48 bytes at 13[13]:4
iwl4965: I iwl4965_rx_handle r 16 i 14 No handler needed for 
REPLY_TX_LINK_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD 
(0x00000000)
iwl4965: I iwl4965_rx_handle r 16 i 15 No handler needed for REPLY_RXON, 
0x10
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD 
(#97), seq: 0x040E, 140 bytes at 14[14]:4
iwl4965: I iwl4965_rx_handle r 17 i 16 No handler needed for 
REPLY_TX_PWR_TABLE_CMD, 0x97
iwl4965: U iwl4965_add_station_flags Add STA ID 31: ff:ff:ff:ff:ff:ff
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_ADD_STA (#18), 
seq: 0x040F, 72 bytes at 15[15]:4
iwl4965: I iwl4965_rx_handle r = 18, i = 17, REPLY_ADD_STA, 0x18
iwl4965: U iwl4965_send_add_station REPLY_ADD_STA PASSED
iwl4965: U iwl4965_enqueue_hcmd Sending command 
REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0410, 92 bytes at 16[16]:4
iwl4965: U iwl4965_mac_config_interface leave
iwl4965: U iwl4965_bss_info_changed changes = 0x6
iwl4965: U iwl4965_bss_info_changed ERP_PREAMBLE 0
iwl4965: U iwl4965_bss_info_changed ERP_CTS 0
iwl4965: I iwl4965_rx_handle r 19 i 18 No handler needed for 
REPLY_TX_LINK_QUALITY_CMD, 0x4e
iwl4965: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD 
(0x00000000)
iwl4965: I iwl4965_rx_handle r = 20, i = 19, REPLY_RX, 0xc3
iwl4965: U iwl4965_mac_config enter to channel 11
iwl4965: U iwlcore_set_rxon_channel Staging channel set to 11 [0]
iwl4965: U iwl4965_enqueue_hcmd Sending command REPLY_CARD_STATE_CMD 
(#a0), seq: 0x0411, 8 bytes at 17[17]:4
iwl4965: I iwl4965_rx_handle r 22 i 20 No handler needed for 
REPLY_CARD_STATE_CMD, 0xa0
iwl4965: I iwl4965_rx_handle r = 22, i = 21, CARD_STATE_NOTIFICATION, 0xa1
iwl4965: U iwl4965_mac_config leave - radio disabled

# iwconfig wlan0 essid foo
Error for wireless request "Set ESSID" (8B1A) :
	SET failed on device wlan0 ; Input/output error.

wlan0: sta_find_ibss (active_ibss=0)
    sta_find_ibss: selected 00:00:00:00:00:00 current 00:00:00:00:00:00
    did not try to join ibss
wlan0: Trigger new scan to find an IBSS to join
iwl4965: U iwl4965_mac_hw_scan enter
iwl4965: U iwl4965_mac_hw_scan leave - not ready or exit pending
iwl4965: I iwl4965_enqueue_hcmd Not sending command - RF KILL<3>iwl4965: 
Error sending REPLY_STATISTICS_CMD: enqueue_hcmd failed: -5

# ifconfig wlan0 down

iwl4965: U iwl4965_mac_remove_interface enter
iwl4965: U iwl4965_mac_remove_interface leave
iwl4965: U iwl4965_mac_stop enter
iwl4965: U __iwl4965_down iwl4965 is going down
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U iwl4965_hw_nic_stop_master stop master
iwl4965: U iwl4965_hw_nic_stop_master stop master
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U iwl4965_clear_free_frames 0 frames on pre-allocated heap on 
clear.
ACPI: PCI interrupt for device 0000:03:00.0 disabled
iwl4965: U iwl4965_mac_stop leave

# ifconfig wlan0 up

iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 
100102, writing 100106)
iwl4965: Radio disabled by SW RF kill (module parameter)
ACPI: PCI interrupt for device 0000:03:00.0 disabled
iwl4965: U iwl4965_mac_start leave - failed

It's interesting how RF kill plays into it. I definitely didn't press 
the RF kill switch.

Daniel
