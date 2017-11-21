Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57038 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbdKUJu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 04:50:56 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH v8 0/3] mt76: add new wireless driver for MediaTek MT76x2 PCIe chips
Date: Tue, 21 Nov 2017 10:50:50 +0100
Message-Id: <20171121095053.82673-1-nbd@nbd.name> (sfid-20171121_105146_483819_3AB6049A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes since v7:
- Fix build errors

Changes since v6:
- DT documentation fixes
- Add LED configuration
- PHY gain calibration fixes
- Endian fixes
- Tx status processing fixes
- EEPROM validation fixes
- IBSS RSN fix
- AP mode powersave delivery fix

Changes since v5:
- Adjust for mac80211 API changes
- EEPROM parsing fixes
- Ad-hoc mode WPA2 fixes

Changes since v4:
- Cleanups suggested by Stanislaw Gruszka
- Device tree fixes suggested by Rob Herring
- EEPROM MAC address parsing fix

Changes since v3:
- DFS fixes
- stability fixes
- use wiphy_read_of_freq_limits

Changes since v2:
- lots of checkpatch cleanups
- various tx path (and other) fixes
- use the new bitfield API
- documented device tree bindings

Felix Fietkau (3):
  Documentation: dt: net: add mt76 wireless device binding
  mt76: add common code shared between multiple chipsets
  mt76: add driver code for MT76x2e

 .../bindings/net/wireless/mediatek,mt76.txt        |  24 +
 drivers/net/wireless/mediatek/Kconfig              |   1 +
 drivers/net/wireless/mediatek/Makefile             |   1 +
 drivers/net/wireless/mediatek/mt76/Kconfig         |  10 +
 drivers/net/wireless/mediatek/mt76/Makefile        |  15 +
 drivers/net/wireless/mediatek/mt76/debugfs.c       |  76 ++
 drivers/net/wireless/mediatek/mt76/dma.c           | 451 ++++++++++++
 drivers/net/wireless/mediatek/mt76/dma.h           |  38 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        | 112 +++
 drivers/net/wireless/mediatek/mt76/mac80211.c      | 344 +++++++++
 drivers/net/wireless/mediatek/mt76/mmio.c          |  61 ++
 drivers/net/wireless/mediatek/mt76/mt76.h          | 355 ++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        | 223 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_core.c   |  88 +++
 .../net/wireless/mediatek/mt76/mt76x2_debugfs.c    | 133 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c    | 493 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h    |  80 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    | 184 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h    |  68 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 644 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h | 181 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   | 784 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    | 738 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    | 189 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   | 534 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    | 452 ++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h    | 136 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c    | 109 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    | 691 ++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h   | 566 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_trace.c  |  23 +
 drivers/net/wireless/mediatek/mt76/mt76x2_trace.h  | 144 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     | 255 +++++++
 drivers/net/wireless/mediatek/mt76/trace.c         |  23 +
 drivers/net/wireless/mediatek/mt76/trace.h         |  71 ++
 drivers/net/wireless/mediatek/mt76/tx.c            | 511 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/util.c          |  78 ++
 drivers/net/wireless/mediatek/mt76/util.h          |  44 ++
 38 files changed, 8930 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
 create mode 100644 drivers/net/wireless/mediatek/mt76/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mac80211.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/util.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/util.h

-- 
2.11.0
