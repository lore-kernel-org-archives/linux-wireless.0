Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965905AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 00/28] rtl8xxxu updates and fixes
Date: Wed,  3 Feb 2016 13:39:34 -0500
Message-Id: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_201502_245157_55625D94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Please find included a smaller patchset for the rtl8xxxu driver. It
includes fixes from Bruno Randolf for monitor mode support, Jakub
Sitnicki (I have a few more patches pending from Jakub), and Tobias
Klauser. It also includes a few fixes and some preparatory patches for
the next patchset which will include rtl8723bu and rtl8192eu support.

This is all I was able to split out, without breaking my follow-on
patches.

I have another stack that goes on top of this, that I will try to post
as soon as I see these hit the tree.

Thanks,
Jes


Bruno Randolf (3):
  rtl8xxxu: Enable monitor mode by handling filters
  rtl8xxxu: Document REG_RXFLTMAP registers
  rtl8xxxu: Enable data frame reception in rtl8xxxu_start

Jakub Sitnicki (1):
  rtl8xxxu: Use REG_EFUSE_TEST register only on multifunctional devices

Jes Sorensen (22):
  rtl8xxxu: Minor cleanup to rtl8xxxu_download_firmware()
  rtl8xxxu: rtl8xxxu_download_firmware(): Cosmetic cleanups
  rtl8xxxu: If fw running in RAM, reset the 8051 before trying to
    download a new one
  rtl8xxxu: Add RQPN_[NE]PQ_SHIFT values
  rtl8xxxu: Define SYS_CFG_SW_OFFLOAD_EN
  rtl8xxxu: Add REG_TX_REPORT_* defines
  rtl8xxxu: Add more RCR bits
  rtl8xxxu: Implement rtl8xxxu_reset_8051()
  rtl8xxxu: Add definitions for antenna selection registers for 8723BU
  rtl8xxxu: Add mbox extension register definitions for 8723B
  rtl8xxxu: Add REG_OFDM0_RX_D_SYNC_PATH definitions
  rtl8xxxu: Remove unused clutter for handling recursive calls to
    rtl8xxxu_init_device()
  rtl8xxxu: Fix cosmetics to quiet down checkpatch police
  rtl8xxxu: Remove duplicate USB ID
  rtl8xxxu: Fix 80 character per line issue
  rtl8xxxu: rtl8xxxu_set_linktype(): Be consistent aboutregister size
    REG_MSR
  rtl8xxxu: Set correct bit to reset MCU IO wrapper
  rtl8xxxu: Remove unused mgmt variable from rtl8xxxu_rx_complete()
  rtl8xxxu: Remove unused len/cnt variables from rtl8xxxu_rx_complete()
  rtl8xxxu: Do not mask RF registers to 6 bits
  rtl8xxxu: Make device_init kludge 8723au only
  rtl8xxxu: Add missing bit define for REG_APS_FSMCO

Tobias Klauser (2):
  rtl8xxxu: Fix typo in Kconfig help text
  rtl8xxxu: Check return value of kmemdup()

 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |   2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 183 ++++++++++++++-------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  55 ++++++-
 4 files changed, 169 insertions(+), 73 deletions(-)

-- 
2.5.0

