Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 000/113] rtl8xxxu: Add support for rtl8723bu
Date: Mon, 29 Feb 2016 17:03:58 -0500
Message-Id: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_015231_EC34D7CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This is a rather large set of patches adding support for rtl8723bu
devices, as well as containing some code for rtl8192eu devices.

I started working on 8192eu support at the beginning but later
switched over and completed 8723bu support, before finally completing
8192eu support. The two new devices share a lot of new features not
found in the older generation parts (8723au/8188cu/8192cu/8188ru).

I am holding back the 8192eu support for now, in order to reduce the
size of the patch set (I have another 60 patches that goes on top of
this set with 8192eu support and additional bug fixes). Given that
support for the two devices is intermingled, trying to disentangle it
is pretty much impossible at this point, and risks breaking the code.

This applies on top of wireless-drivers-next as of today 2016-02-29.

Cheers,
Jes


Jakub Sitnicki (5):
  rtl8xxxu: Don't check for illegal offset when reading from efuse
  rtl8xxxu: Skip disabled efuse words early
  rtl8xxxu: rtl8723au: Introduce a pointer to efuse
  rtl8xxxu: rtl8192cu: Introduce a pointer to efuse
  rtl8xxxu: rtl8192eu: Map out EFUSE TX power area

Jes Sorensen (108):
  rtl8xxxu: Add initial code to parse rtl8192eu efuse
  rtl8xxxu: Identify chip vendors correctly
  rtl8xxxu: Use 1024 byte block loads for 8192eu firmware
  rtl8xxxu: Add rtl8192eu_nic.bin to the MODULE_FIRMWARE list
  rtl8xxxu: Implment rtl8192eu_power_on()
  rtl8xxxu: Add rtl8xxxu_auto_llt_table()
  rtl8xxxu: Init page boundaries before starting the firmware
  rtl8xxxu: Init the LLT after we start the firmware
  rtl8xxxu: Fix incorrect test for auto LLT failure
  rtl8xxxu: Kludge to drop incorrect USB OUT EP for 8192EU
  rtl8xxxu: Init REG_HIMR[01] for 8192eu parts
  rtl8xxxu: Initial rtl8723bu chip identification
  rtl8xxxu: Add rtl8723bu_parse_efuse() and 8723bu efuse definition
  rtl8xxxu: Use 1024 byte writes for writing 8723bu firmware
  rtl8xxxu: Only setup USB interrupts for parts which support it
  rtl8xxxu: Add rtl8723b_phy_1t_init_table
  rtl8xxxu: Add rtl8723bu_radioa_1t_init_table
  rtl8xxxu: Add rtl8723bu_phy_init_antenna_selection()
  rtl8xxxu: Add rtl8723b_mac_init_table
  rtl8xxxu: Add 8723by AGC table
  rtl8xxxu: Handle 32 bit mailbox extension regs found on
    8723bu/8192eu/8812
  rtl8xxxu: Add some missing register definitions for 8723bu
  rtl8xxxu: Group USB fixups together for all chips
  rtl8xxxu: Add definitions for new generation h2c commands
  rtl8xxxu: rtl8192eu_parse_efuse(): Use a pointer to the struct
    rtl8192eu_efuse
  rtl8xxxu: rtl8723bu_parse_efuse(): Use a pointer to the struct
    rtl8723bu_efuse
  rtl8xxxu: rtl8xxxu_h2c_cmd(): Add size argument
  rtl8xxxu: Do BT_WLAN_CALIBRATION before doing IQK calibration
  rtl8xxxu: Do not overwrite rtl8xxxu_debug for untested chips
  rtl8xxxu: Use correct formatting type to print sizeof()
  rtl8xxxu: Make rtl8xxxu_add_path_on() use device specific init values
  rtl8xxxu: Add a couple of new register definitions
  rtl8xxxu: First stab at adding IQK calibration for 8723bu parts
  rtl8xxxu: Handle S0S1 register in lc_calibrate()
  rtl8xxxu: Do LC calibration before IQK calibration
  rtl8xxxu: Remove backing up certain registers, which was never used
  rtl8xxxu: Initial implementation of rtl8723bu_config_channel()
  rtl8xxxu: Initial rtl8723bu_init_bt() code
  rtl8xxxu: Remove unused variable
  rtl8xxxu: Improve 8723bu init code
  rtl8xxxu: Do not ignore wlan activity on 8723bu
  rtl8xxxu: Set the right type for ps tdma on 8723bu
  rtl8xxxu: Add rtl8723bu (nextgen) rx descriptor definition
  rtl8xxxu: Handle 8723bu style rx descriptors
  rtl8xxxu: Initial functionality to handle C2H events for 8723bu
  rtl8xxxu: Handle BT register writes and MP_OPER events
  rtl8xxxu: Issue BT_INFO command
  rtl8xxxu: Do not set REG_AFE_XTAL_CTRL on 8723bu
  rtl8xxxu: Implement 8723bu power on sequence
  rtl8xxxu: Setup LLT before downloading firmware
  rtl8xxxu: Additional fixes for 8723bu
  rtl8xxxu: Handle XTAL_K value in efuse specific location
  rtl8xxxu: Another 8723bu patch for rtl8xxxu_init_phy_bb()
  rtl8xxxu: Another 8723bu magic register set during init
  rtl8xxxu: Init H2C command register for 8723bu
  rtl8xxxu: 80M spur hack is for 8723au only
  rtl8xxxu: Do queue init in same order as 8723bu vendor driver
  rtl8xxxu: Do not set FPGA0_TX_INFO for 8723bu and use a larger PBP
    page size
  rtl8xxxu: Set RX boundary for 8723bu
  rtl8xxxu: Initialize burst parameters for 8723bu
  rtl8xxxu: Call device specific _config_channel()
  rtl8xxxu: 8723bu lock phy after RF init
  rtl8xxxu: Add REG_DWBCN1_CTRL_8723B define
  rtl8xxxu: Group chip quirks together
  rtl8xxxu: Setup RX aggregation
  rtl8xxxu: Add missing blank space in front of bracket
  rtl8xxxu: Implement init_statistics for 8723bu
  rtl8xxxu: RF_T_METER is different on the newer chips
  rtl8xxxu: Set WLAN_ACT_CONTROL per vendor driver setting
  rtl8xxxu: 8723bu: REG_BT_COEX_TABLE4 is only 8 bits
  rtl8xxxu: Use name for REG_RFE_BUFFER rather than hard coded value
  rtl8xxxu: Use REG_RFE_CTRL_ANTA_SRC rather than hard coded value
  rtl8xxxu: Setup coex table correctly (hopefully)
  rtl8xxxu: Do not use hard-wired RF enable settings for 8723bu
  rtl8xxxu: Correct struct rtl8723bu_efuse to list power bases correctly
  rtl8xxxu: Introduce set_tx_power() fileop and a new 8723b dummy
    derivative
  rtl8xxxu: Use size of source pointer when copying efuse data
  rtl8xxxu: Bump TX power arrays to handle larger channel groups
  rtl8xxxu: Parse efuse power indices for 8723bu
  rtl8xxxu: Set 8723bu TX power for CCK and OFDM rates
  rtl8xxxu: Set 8723bu MCS TX power
  rtl8xxxu: Set the correct thermal meter register for 8723bu
  rtl8xxxu: Add definition for 8723bu tx descriptor
  rtl8xxxu: Handle 40 byte TX descriptors for rtl8723bu
  rtl8xxxu: Do not unconditionally print debug info in
    rtl8723bu_handle_c2h()
  rtl8xxxu: Add additional tx descriptor bits for data word 0
  rtl8xxxu: Add more 40 byte TX desc bit definitions
  rtl8xxxu: Set the correct TX descriptor bits for agg and break on
    8723b
  rtl8xxxu: Set sequence number correctly for 40 byte TX descriptors
  rtl8723au: Update TX descriptor words 4 and 5 definitions
  rtl8xxxu: TX RTS rate is word 4 for 8723a
  rtl8xxxu: Improve handling of txdesc32 vs txdesc40 handling
  rtl8xxxu: Do not parse RX descriptor info for C2H packets
  rtl8xxxu: Define 8723b H2C ramask command structure
  rtl8xxxu: Implement basic 8723b specific update_rate_mask() function
  rtl8xxxu: Report media status using the correct H2C command for 8723bu
  rtl8xxxu: Dump contents of unhandled C2H events
  rtl8xxxu: Process C2H RA_REPORT events for 8723bu
  rtl8xxxu: Pass RX rate to rx_parse_phystats and enable phystats for
    rtl8723bu
  rtl8xxxu: Remove unncessary semicolon
  rtl8xxxu: convert rtl8723bu_init_bt() into rtl8723b_enable_rf()
  rtl8xxxu: Use define for REG_PWR_DATA bits
  rtl8xxxu: Implement 8723bu specific disable_rf() function
  rtl8xxxu: Implement device specific power_off function
  rtl8xxxu: Flush FIFO before powering down devices
  rtl8xxxu: Print a warning if flushing the FIFO fails
  rtl8xxxu: Use correct 8051 reset function for 8723b parts
  rtl8xxxu: Temporarily disable 8192eu device init

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 3524 +++++++++++++++++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  691 +++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   97 +-
 3 files changed, 3852 insertions(+), 460 deletions(-)

-- 
2.5.0

