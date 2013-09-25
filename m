Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:41936 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3IYR6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 13:58:04 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 0/8 V4] rtlwifi: Patches to fix problems shown by smatch
Date: Wed, 25 Sep 2013 12:57:41 -0500
Message-Id: <1380131869-19185-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130925_221657_688148_E3866650)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix smatch warnings and errors in the rtlwifi family of drivers.

V2 addresses comments by David Laight and Sergei Shtylyov.
V3 addresses further comments by David, Sergei, and Kalle Valo. The
   dead code is removed, and the variable is left in the struct.
V4 Fixes extra line removed by accident from rtl8192de/hw.c as
   noted by Sergei

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
  rtlwifi: Remove all remaining references to variable 'noise' in
    rtl_stats struct

 drivers/net/wireless/rtlwifi/pci.c                |  1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c       |  1 +
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c      |  1 -
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 25 +----------------------
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c      |  1 -
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |  2 --
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c       |  8 ++++++--
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c       | 18 ----------------
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c      |  1 -
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c      |  1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c      |  1 -
 drivers/net/wireless/rtlwifi/usb.c                |  6 ++++--
 12 files changed, 12 insertions(+), 54 deletions(-)

-- 
1.8.1.4

