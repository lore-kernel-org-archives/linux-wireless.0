Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:40777 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeIULwJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 07:52:09 -0400
From: <yhchuang@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>
Subject: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac wireless network chips
Date: Fri, 21 Sep 2018 14:03:55 +0800
Message-ID: <1537509847-21087-1-git-send-email-yhchuang@realtek.com> (sfid-20180921_080454_102154_0C49353F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
rtwlan supports 8822BE and 8822CE chips, and will be able to support
multi-vif combinations in run-time.

For now, only PCI bus is supported, but rtwlan was originally designed
to optionally support three buses includes USB & SDIO. USB & SDIO modules
will soon be supported by rtwlan, with configurable core module to fit
with different bus modules in the same time.

For example, if we choose 8822BE and 8822CU, only PCI & USB modules will
be selected, built, loaded into kernel. This is one of the major
difference from rtlwifi, which can only support specific combinations.

Another difference from rtlwifi is that rtwlan is designed to support
the latest Realtek 802.11ac wireless network chips like 8822B and
8822C series. Compared to the earlier chips supported by rtlwifi like
the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
have different MAC & PHY settings, such as new multi-port feature for the
MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.

Multi-Port feature is also supported under rtwlan's software architecture.
rtlwifi can only support one vif in the same time, most because of the
hardware limitations for early chips, hence the original design of it
also restricts the usage of multi-vif support, so latest chipset seems not
take advantages from its new MAC engine.

However, rtwlan can run multiple vifs concurrently by holding them on
hardware ports provided by MAC engine, so we can easily start different
roles on a single device.

Based on the reasons mentioned before, we implemented rtwlan. It had many
authors, they are listed here alphabetically:

Ping-Ke Shih <pkshih@realtek.com>
Tzu-En Huang <tehuang@realtek.com>
Yan-Hsuan Chuang <yhchuang@realtek.com>

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Yan-Hsuan Chuang (12):
  rtwlan: main files
  rtwlan: core files
  rtwlan: hci files
  rtwlan: trx files
  rtwlan: mac files
  rtwlan: fw and efuse files
  rtwlan: phy files
  rtwlan: debug files
  rtwlan: chip files
  rtwlan: 8822B init table
  rtwlan: 8822C init table
  rtwlan: Kconfig & Makefile

 drivers/net/wireless/realtek/Kconfig               |     1 +
 drivers/net/wireless/realtek/Makefile              |     1 +
 drivers/net/wireless/realtek/rtwlan/Kconfig        |    55 +
 drivers/net/wireless/realtek/rtwlan/Makefile       |    21 +
 drivers/net/wireless/realtek/rtwlan/debug.c        |   653 +
 drivers/net/wireless/realtek/rtwlan/debug.h        |    45 +
 drivers/net/wireless/realtek/rtwlan/efuse.c        |   153 +
 drivers/net/wireless/realtek/rtwlan/efuse.h        |    53 +
 drivers/net/wireless/realtek/rtwlan/fw.c           |   640 +
 drivers/net/wireless/realtek/rtwlan/fw.h           |   182 +
 drivers/net/wireless/realtek/rtwlan/hci.h          |   212 +
 drivers/net/wireless/realtek/rtwlan/mac.c          |  1063 +
 drivers/net/wireless/realtek/rtwlan/mac.h          |    35 +
 drivers/net/wireless/realtek/rtwlan/mac80211.c     |   447 +
 drivers/net/wireless/realtek/rtwlan/main.c         |  1164 ++
 drivers/net/wireless/realtek/rtwlan/main.h         |  1188 ++
 drivers/net/wireless/realtek/rtwlan/pci.c          |  1217 ++
 drivers/net/wireless/realtek/rtwlan/pci.h          |   227 +
 drivers/net/wireless/realtek/rtwlan/phy.c          |  1671 ++
 drivers/net/wireless/realtek/rtwlan/phy.h          |   125 +
 drivers/net/wireless/realtek/rtwlan/ps.c           |   193 +
 drivers/net/wireless/realtek/rtwlan/ps.h           |    21 +
 drivers/net/wireless/realtek/rtwlan/reg.h          |   399 +
 drivers/net/wireless/realtek/rtwlan/regd.c         |   462 +
 drivers/net/wireless/realtek/rtwlan/regd.h         |    40 +
 drivers/net/wireless/realtek/rtwlan/rtw8822b.c     |  1572 ++
 drivers/net/wireless/realtek/rtwlan/rtw8822b.h     |   270 +
 .../net/wireless/realtek/rtwlan/rtw8822b_table.c   | 20783 +++++++++++++++++++
 .../net/wireless/realtek/rtwlan/rtw8822b_table.h   |    18 +
 drivers/net/wireless/realtek/rtwlan/rtw8822c.c     |  1164 ++
 drivers/net/wireless/realtek/rtwlan/rtw8822c.h     |   403 +
 .../net/wireless/realtek/rtwlan/rtw8822c_table.c   |  4150 ++++
 .../net/wireless/realtek/rtwlan/rtw8822c_table.h   |    16 +
 drivers/net/wireless/realtek/rtwlan/rx.c           |   138 +
 drivers/net/wireless/realtek/rtwlan/rx.h           |    30 +
 drivers/net/wireless/realtek/rtwlan/sec.c          |   135 +
 drivers/net/wireless/realtek/rtwlan/sec.h          |    40 +
 drivers/net/wireless/realtek/rtwlan/tx.c           |   271 +
 drivers/net/wireless/realtek/rtwlan/tx.h           |    81 +
 39 files changed, 39339 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtwlan/Kconfig
 create mode 100644 drivers/net/wireless/realtek/rtwlan/Makefile
 create mode 100644 drivers/net/wireless/realtek/rtwlan/debug.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/debug.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/efuse.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/efuse.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/fw.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/fw.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/hci.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/mac.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/mac.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/mac80211.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/main.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/main.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/pci.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/pci.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/phy.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/phy.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/ps.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/ps.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/reg.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/regd.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/regd.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rtw8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rtw8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rtw8822b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rtw8822b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rtw8822c.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rtw8822c.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rtw8822c_table.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rtw8822c_table.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rx.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/rx.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/sec.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/sec.h
 create mode 100644 drivers/net/wireless/realtek/rtwlan/tx.c
 create mode 100644 drivers/net/wireless/realtek/rtwlan/tx.h

-- 
2.7.4
