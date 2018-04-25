Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54895 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYCIg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 22:08:36 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
Date: Wed, 25 Apr 2018 10:08:01 +0800
Message-ID: <20180425020820.6141-1-pkshih@realtek.com> (sfid-20180425_040843_238566_D3C5CA7F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

v3: patch 06/17 in v2 is too big, so mail server may block the mail.
    In this patchset, I decompose the patch into three patches 06/19-08/19,
    so in patchset view v2 and v3 are identical.

v2: remove indirection to get halmac ops
    Only patches 1/17 and 11/17 are changed.

Patches 1/19-3/19 are added structure to support this module.
Patches 4/19-18/19 add new files.
Patch 19/19 add this module to Makefile and Kconfig.

Ping-Ke Shih (19):
  rtlwifi: add halmac structure to wifi.h
  rtlwifi: add debug ID COMP_HALMAC
  rtlwifi: add dmdef.h to share with driver and other modules
  rtlwifi: halmac: add main definition used by halmac
  rtlwifi: halmac: describe number and size of chip functions
  rtlwifi: halmac: add register definitions
  rtlwifi: halmac: add bit field definitions
  rtlwifi: halmac: add bit field definitions of rtl8822b
  rtlwifi: halmac: add definition of TX/RX descriptor
  rtlwifi: halmac: add GPIO pin/pinmux definitions
  rtlwifi: halmac: add power sequence to turn on/off wifi card
  rtlwifi: halmac: access efuse through halmac helper functions
  rtlwifi: halmac: add files to implement halmac ops
  rtlwifi: halmac: add halmac init/deinit functions
  rtlwifi: halmac: add firmware related functions and definitions
  rtlwifi: halmac: add bus interface commands
  rtlwifi: halmac: add to control WiFi mac functions and registers
  rtlwifi: halmac: add to support BB and RF functions
  rtlwifi: add halmac to Makefile and Kconfig

 drivers/net/wireless/realtek/rtlwifi/Kconfig       |     5 +
 drivers/net/wireless/realtek/rtlwifi/Makefile      |     1 +
 drivers/net/wireless/realtek/rtlwifi/debug.h       |     1 +
 drivers/net/wireless/realtek/rtlwifi/dmdef.h       |    40 +
 .../net/wireless/realtek/rtlwifi/halmac/Makefile   |    29 +
 .../halmac_88xx/halmac_8822b/halmac_8822b_cfg.h    |    68 +
 .../halmac_8822b/halmac_cfg_wmac_8822b.c           |   144 +
 .../halmac_8822b/halmac_cfg_wmac_8822b.h           |    36 +
 .../halmac_88xx/halmac_8822b/halmac_common_8822b.c |   173 +
 .../halmac_88xx/halmac_8822b/halmac_common_8822b.h |    32 +
 .../halmac_88xx/halmac_8822b/halmac_gpio_8822b.c   |   847 +
 .../halmac_88xx/halmac_8822b/halmac_gpio_8822b.h   |    34 +
 .../halmac_88xx/halmac_8822b/halmac_init_8822b.c   |   688 +
 .../halmac_88xx/halmac_8822b/halmac_init_8822b.h   |    33 +
 .../halmac_88xx/halmac_8822b/halmac_pcie_8822b.c   |   218 +
 .../halmac_88xx/halmac_8822b/halmac_pcie_8822b.h   |    38 +
 .../halmac_88xx/halmac_8822b/halmac_phy_8822b.c    |   148 +
 .../halmac_8822b/halmac_pwr_seq_8822b.c            |   396 +
 .../halmac_8822b/halmac_pwr_seq_8822b.h            |    26 +
 .../halmac_88xx/halmac_8822b/halmac_sdio_8822b.c   |   880 +
 .../halmac_88xx/halmac_8822b/halmac_sdio_8822b.h   |    62 +
 .../halmac_88xx/halmac_8822b/halmac_usb_8822b.c    |   161 +
 .../halmac_88xx/halmac_8822b/halmac_usb_8822b.h    |    38 +
 .../rtlwifi/halmac/halmac_88xx/halmac_88xx_cfg.h   |    40 +
 .../rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.c |   397 +
 .../rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.h |    53 +
 .../halmac/halmac_88xx/halmac_cfg_wmac_88xx.c      |  1158 ++
 .../halmac/halmac_88xx/halmac_cfg_wmac_88xx.h      |   122 +
 .../halmac/halmac_88xx/halmac_common_88xx.c        |  2931 +++
 .../halmac/halmac_88xx/halmac_common_88xx.h        |   151 +
 .../rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.c |  1918 ++
 .../rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.h |   101 +
 .../rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.c |   316 +
 .../rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.h |    35 +
 .../rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.c    |  1149 ++
 .../rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.h    |    57 +
 .../rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.c  |   415 +
 .../rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.h  |    55 +
 .../rtlwifi/halmac/halmac_88xx/halmac_init_88xx.c  |  1071 ++
 .../rtlwifi/halmac/halmac_88xx/halmac_init_88xx.h  |    70 +
 .../rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.c  |   869 +
 .../rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.h  |    79 +
 .../rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.c  |   538 +
 .../rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.h  |    98 +
 .../rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.c  |   895 +
 .../rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.h  |    75 +
 .../rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.c   |   522 +
 .../rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.h   |    83 +
 .../wireless/realtek/rtlwifi/halmac/halmac_api.c   |   438 +
 .../wireless/realtek/rtlwifi/halmac/halmac_api.h   |    65 +
 .../wireless/realtek/rtlwifi/halmac/halmac_bit2.h  | 18234 +++++++++++++++++++
 .../realtek/rtlwifi/halmac/halmac_bit_8822b.h      | 17870 ++++++++++++++++++
 .../realtek/rtlwifi/halmac/halmac_fw_info.h        |   119 +
 .../rtlwifi/halmac/halmac_fw_offload_c2h_nic.h     |   371 +
 .../rtlwifi/halmac/halmac_fw_offload_h2c_nic.h     |   694 +
 .../realtek/rtlwifi/halmac/halmac_gpio_cmd.h       |    84 +
 .../rtlwifi/halmac/halmac_h2c_extra_info_nic.h     |   171 +
 .../realtek/rtlwifi/halmac/halmac_intf_phy_cmd.h   |    45 +
 .../rtlwifi/halmac/halmac_original_c2h_nic.h       |   408 +
 .../rtlwifi/halmac/halmac_original_h2c_nic.h       |  1143 ++
 .../realtek/rtlwifi/halmac/halmac_pcie_reg.h       |    36 +
 .../realtek/rtlwifi/halmac/halmac_pwr_seq_cmd.h    |    98 +
 .../wireless/realtek/rtlwifi/halmac/halmac_reg2.h  |  1292 ++
 .../realtek/rtlwifi/halmac/halmac_reg_8822b.h      |   733 +
 .../realtek/rtlwifi/halmac/halmac_rx_bd_nic.h      |    36 +
 .../realtek/rtlwifi/halmac/halmac_rx_desc_chip.h   |   100 +
 .../realtek/rtlwifi/halmac/halmac_rx_desc_nic.h    |   123 +
 .../realtek/rtlwifi/halmac/halmac_sdio_reg.h       |    53 +
 .../realtek/rtlwifi/halmac/halmac_state_machine.h  |   157 +
 .../realtek/rtlwifi/halmac/halmac_tx_bd_nic.h      |   106 +
 .../realtek/rtlwifi/halmac/halmac_tx_desc_chip.h   |   398 +
 .../realtek/rtlwifi/halmac/halmac_tx_desc_nic.h    |   439 +
 .../wireless/realtek/rtlwifi/halmac/halmac_type.h  |  2134 +++
 .../realtek/rtlwifi/halmac/halmac_usb_reg.h        |    19 +
 .../wireless/realtek/rtlwifi/halmac/rtl_halmac.c   |  1403 ++
 .../wireless/realtek/rtlwifi/halmac/rtl_halmac.h   |    77 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    59 +
 77 files changed, 64201 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/dmdef.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/Makefile
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_8822b_cfg.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_phy_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_88xx_cfg.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_bit2.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_bit_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_info.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_c2h_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_h2c_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_gpio_cmd.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_h2c_extra_info_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_intf_phy_cmd.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_c2h_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_h2c_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pcie_reg.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pwr_seq_cmd.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_reg2.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_reg_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_bd_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_chip.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_sdio_reg.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_state_machine.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_bd_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_chip.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_type.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_usb_reg.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/rtl_halmac.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/rtl_halmac.h

-- 
2.15.1
