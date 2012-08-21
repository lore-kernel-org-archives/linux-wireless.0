Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38159 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2HUPBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 11:01:21 -0400
Received: by yhmm54 with SMTP id m54so5880908yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2012 08:01:20 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Li Chaoming <chaoming_li@realsil.com.cn>
Subject: [PATCH 0/6] Updates to rtlwifi family to match latest vendor version
Date: Tue, 21 Aug 2012 10:00:49 -0500
Message-Id: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120821_170125_270339_25582754)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Realtek's latest driver for the PCI-based devices include many changes
that are ported to the in-kernel driver with this set of patches intended
for wireless-next.

Larry Finger (3):
  rtlwifi: rtl8192c: rtl8192de: Fix typo in cursta_connectctate
  rtlwifi: rtl8192c: rtl8192ce: rtl8192cu: rtl8192se: Remove sparse
    warnings
  rtlwifi: Update header file
Li Chaoming (3):
  rtlwifi: Add changes for new vendor driver version
  rtlwifi: rtl8192ce: Update for new vendor driver version
  rtlwifi: rtl8192se: Update driver for changes in 12/30/2011 vendor
    version

 drivers/net/wireless/rtlwifi/base.c               |  323 ++++++++++-
 drivers/net/wireless/rtlwifi/base.h               |   10 +-
 drivers/net/wireless/rtlwifi/cam.c                |    7 +-
 drivers/net/wireless/rtlwifi/core.c               |   76 ++-
 drivers/net/wireless/rtlwifi/debug.h              |    8 +
 drivers/net/wireless/rtlwifi/efuse.c              |   40 +-
 drivers/net/wireless/rtlwifi/efuse.h              |    1 -
 drivers/net/wireless/rtlwifi/pci.c                |  624 +++++++++++----------
 drivers/net/wireless/rtlwifi/pci.h                |    3 +
 drivers/net/wireless/rtlwifi/ps.c                 |   93 ++-
 drivers/net/wireless/rtlwifi/ps.h                 |    3 +-
 drivers/net/wireless/rtlwifi/rc.c                 |    3 +-
 drivers/net/wireless/rtlwifi/regd.c               |   18 +
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   41 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h      |   12 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       |  110 +++-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h      |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c       |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c      |   70 ++-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c       |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c       |   91 +--
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c       |    1 -
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c       |   25 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c      |  353 ++++++------
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c      |   17 +-
 drivers/net/wireless/rtlwifi/usb.c                |    2 +-
 drivers/net/wireless/rtlwifi/wifi.h               |  108 +++-
 28 files changed, 1412 insertions(+), 643 deletions(-)

-- 
1.7.10.4

