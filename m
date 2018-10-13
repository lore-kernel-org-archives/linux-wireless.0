Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79370C71122
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2404B20835
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:01:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2404B20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbeJMQhk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 12:37:40 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60269 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbeJMQhj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 12:37:39 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9D90rnL000956, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9D90rnL000956
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Sat, 13 Oct 2018 17:00:53 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Sat, 13 Oct 2018 17:00:53 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <pkshih@realtek.com>,
        <tehuang@realtek.com>, <sgruszka@redhat.com>,
        <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [RFC v4 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Date:   Sat, 13 Oct 2018 17:00:32 +0800
Message-ID: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
rtw88 supports 8822BE and 8822CE chips, and will be able to support
multi-vif combinations in run-time.

For now, only PCI bus is supported, but rtw88 was originally designed
to optionally support three buses includes USB & SDIO. USB & SDIO modules
will soon be supported by rtw88, with configurable core module to fit
with different bus modules in the same time.

For example, if we choose 8822BE and 8822CU, only PCI & USB modules will
be selected, built, loaded into kernel. This is one of the major
difference from rtlwifi, which can only support specific combinations.

Another difference from rtlwifi is that rtw88 is designed to support
the latest Realtek 802.11ac wireless network chips like 8822B and
8822C series. Compared to the earlier chips supported by rtlwifi like
the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
have different MAC & PHY settings, such as new multi-port feature for the
MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.

Multi-Port feature is also supported under rtw88's software architecture.
rtlwifi can only support one vif in the same time, most because of the
hardware limitations for early chips, hence the original design of it
also restricts the usage of multi-vif support, so latest chipset seems not
take advantages from its new MAC engine.

However, rtw88 can run multiple vifs concurrently by holding them on
hardware ports provided by MAC engine, hence can easily start different
roles on a single device.

Based on the reasons mentioned before, we implemented rtw88. It had many
authors, they are listed here alphabetically:

Ping-Ke Shih <pkshih@realtek.com>
Tzu-En Huang <tehuang@realtek.com>
Yan-Hsuan Chuang <yhchuang@realtek.com>

v4

 - remove vis_list and sta_list, use mac80211 iterator
 - use kernel helpers such as bitmap, bcd2bin, lockdep
 - move debugfs into wiphy->debugfsdir
 - use spin_lock in interrupt handler
 - remove unnecessary depends on lines in Kconfig
 - make port config constant
 - avoid watchdog timer spreading
 - return -EOPNOTSUPP for PMF key error message suppression
 - do not replace regd in wiphy for now
 - use host- fix- endian transfer in linux/bitfield.h to
   replace/get bits to/from card

v3

 - missing rcu list traverse for vif_list

v2

 - rename from rtwlan to rtw88
 - remove lots of magic numbers
 - add pci null entry for auto load on boot
 - add rtwdev->mutex to protect against mac80211 callbacks
 - add rcu lock protection for vif_list and sta_list
 - refine bits & endian macros to use helper functions provided by kernel
   instead of create new ones
 - ieee80211_free_txskb for tx path dropped packets
 - not register iface_combination since now only one vif is allowed
 - some fixes suggested by Stanislaw


Yan-Hsuan Chuang (13):
  rtw88: main files
  rtw88: core files
  rtw88: hci files
  rtw88: trx files
  rtw88: mac files
  rtw88: fw and efuse files
  rtw88: phy files
  rtw88: debug files
  rtw88: chip files
  rtw88: 8822B init table
  rtw88: 8822C init table
  rtw88: Kconfig & Makefile
  rtw88: add support for Realtek 802.11ac wireless chips

 MAINTAINERS                                        |     8 +
 drivers/net/wireless/realtek/Kconfig               |     1 +
 drivers/net/wireless/realtek/Makefile              |     1 +
 drivers/net/wireless/realtek/rtw88/Kconfig         |    55 +
 drivers/net/wireless/realtek/rtw88/Makefile        |    19 +
 drivers/net/wireless/realtek/rtw88/debug.c         |   652 +
 drivers/net/wireless/realtek/rtw88/debug.h         |    43 +
 drivers/net/wireless/realtek/rtw88/efuse.c         |   150 +
 drivers/net/wireless/realtek/rtw88/efuse.h         |    53 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   655 +
 drivers/net/wireless/realtek/rtw88/fw.h            |   182 +
 drivers/net/wireless/realtek/rtw88/hci.h           |   211 +
 drivers/net/wireless/realtek/rtw88/mac.c           |  1045 +
 drivers/net/wireless/realtek/rtw88/mac.h           |    35 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   478 +
 drivers/net/wireless/realtek/rtw88/main.c          |  1168 ++
 drivers/net/wireless/realtek/rtw88/main.h          |  1092 +
 drivers/net/wireless/realtek/rtw88/pci.c           |  1208 ++
 drivers/net/wireless/realtek/rtw88/pci.h           |   229 +
 drivers/net/wireless/realtek/rtw88/phy.c           |  1679 ++
 drivers/net/wireless/realtek/rtw88/phy.h           |   125 +
 drivers/net/wireless/realtek/rtw88/ps.c            |   168 +
 drivers/net/wireless/realtek/rtw88/ps.h            |    20 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   404 +
 drivers/net/wireless/realtek/rtw88/regd.c          |   328 +
 drivers/net/wireless/realtek/rtw88/regd.h          |    40 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  1588 ++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |   155 +
 .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 20783 +++++++++++++++++++
 .../net/wireless/realtek/rtw88/rtw8822b_table.h    |    18 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  1167 ++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   171 +
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    |  4150 ++++
 .../net/wireless/realtek/rtw88/rtw8822c_table.h    |    16 +
 drivers/net/wireless/realtek/rtw88/rx.c            |   153 +
 drivers/net/wireless/realtek/rtw88/rx.h            |    41 +
 drivers/net/wireless/realtek/rtw88/sec.c           |   120 +
 drivers/net/wireless/realtek/rtw88/sec.h           |    39 +
 drivers/net/wireless/realtek/rtw88/tx.c            |   273 +
 drivers/net/wireless/realtek/rtw88/tx.h            |    81 +
 40 files changed, 38804 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/Kconfig
 create mode 100644 drivers/net/wireless/realtek/rtw88/Makefile
 create mode 100644 drivers/net/wireless/realtek/rtw88/debug.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/debug.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/fw.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/fw.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/hci.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac80211.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/main.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/main.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/phy.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/phy.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/reg.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.h

-- 
2.7.4

