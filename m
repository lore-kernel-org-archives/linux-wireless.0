Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40157 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3IRT5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 15:57:52 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 0/8 V3] rtlwifi: Patches to fix problems shown by smatch
Date: Wed, 18 Sep 2013 14:57:32 -0500
Message-Id: <1379534260-14841-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130918_215805_167719_D42288DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix smatch warnings and errors in the rtlwifi family of drivers.

V2 addresses comments by David Laight and Sergei Shtylyov.
V3 addresses further comments by David, Sergei, and Kalle Valo. The
   dead code is removed, and the variable is left in the struct.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Larry Finger (8):
  rtlwifi: rtl8192du: Fix smatch errors in /rtl8192de/dm.c
  rtlwifi: rtl8192de: Fix smatch warnings in rtl8192de/hw.c
  rtlwifi: rtl8192cu: Fix smatch warning in rtl8192cu/trx.c
  rtlwifi: rtl8192_common: Fix smatch errors and warnings in
    rtl8192c/dm_common.c
  rtlwifi: Fix smatch warning in pci.c
  rtlwifi: Fix smatch warnings in usb.c
  rtlwifi: rtl8188ee: Fix smatch warning in rtl8188ee/hw.c
  rtlwifi: Remove all remaining references to variable 'noise'
    in rtl_stats struct

 drivers/net/wireless/rtlwifi/pci.c                | 1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c       | 1 +
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c      | 1 -
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 4 +++-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c      | 1 -
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      | 2 --
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c       | 8 ++++++--
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c       | 2 ++
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c      | 1 -
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c      | 1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c      | 1 -
 drivers/net/wireless/rtlwifi/usb.c                | 6 ++++--
 drivers/net/wireless/rtlwifi/wifi.h               | 1 -
 13 files changed, 16 insertions(+), 14 deletions(-)

-- 
1.8.1.4

