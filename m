Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 00/26] rtl8xxxu add rtl8192eu support
Date: Thu, 14 Apr 2016 14:58:41 -0400
Message-Id: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212530_129160_09211F51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This set of patches should be what is required to get rtl8192eu
support going.

I have some additional fixes for 8188ru and other generic fixes for
the driver. I'll send those out once these make it in.

Cheers,
Jes


Jes Sorensen (26):
  rtl8xxxu: Reorder parts of init code to match the 8192eu vendor code
    flow
  rtl8xxxu: Reorg more code to match the flow of the 8192eu vendor
    driver
  rtl8xxxu: Implement generic init_queue_reserved_page() function
  rtl8xxxu: Reorder chip quirks to follow flow of 8192eu driver
  rtl8xxxu: Do not set REG_PBP on 8192eu
  rtl8xxxu: Do not init FPGA0_TX_INFO on 8192eu
  rtl8xxxu: Do not try to set REG_LEDCFG2 on 8192eu
  rtl8xxxu: Implment rtl8192e_set_tx_power()
  rtl8xxxu: Use has_s0s1 for REG_S0S1 issues only
  rtl8xxxu: byteswap the entire RX descriptor for 24 byte RX descriptors
  rtl8xxxu: Name RX descriptor types rxdesc16/rxdesc24
  rtl8xxxu: Remove misleading warning from rtl8192eu_phy_iqcalibrate()
  rtl8xxxu: Remove unused 8723bu path B IQ calibration code
  rtl8xxxu: Correctly mask what was read from REG_CCK0_AFE_SETTING
  rtl8xxxu: Use descriptive bits for setting RX paths for 1T2R parts
  rtl8xxxu: Split rtl8xxxu_init_phy_bb() into device specific functions
  rtl8xxxu: Load AGC table before patching for 1T2R parts
  rtl8xxxu: Move loading of AGC table to device specific function
  rtl8xxxu: REG_LDOA15_CTRL is only used on gen1 parts
  rtl8xxxu: Store device specific TRXFF boundary in the fileops
  rtl8xxxu: Do not backup RF_MODE_AG when it's never being used
  rtl8xxxu: Make PBP tuning a fileops parameter
  rtl8xxxu: Split USB quirks into gen1 and gen2 quirks
  rtl8xxxu: Remove unneeded 8192eu hack
  rtl8xxxu: 8192eu Fix bug in LDPC RX hang fix
  Re-enable 8192eu support

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 715 ++++++++++++---------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  20 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   6 +-
 3 files changed, 428 insertions(+), 313 deletions(-)

-- 
2.5.5

