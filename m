Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44986 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2LZWIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 17:08:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH V3.8 0/5] Fixes for WARNINGS due to unchecked DMA mapping calls
Date: Wed, 26 Dec 2012 16:08:06 -0600
Message-Id: <1356559691-5048-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20121226_230850_616807_C91EB3B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beginning with kernel 3.8, the DMA mapping systems begins issuing a WARNING for
the first call that maps DMA and fails to call dma_mapping_error() to check
the result. This set of patches adds the appropriate checks to the rtlwifi
family of drivers.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry Finger (5):
  rtlwifi: Fix warning for unchecked pci_map_single() call
  rtlwifi: rtl8192ce: Fix warning for unchecked pci_map_single() call
  rtlwifi: rtl8192de: Fix warning for unchecked pci_map_single() call
  rtlwifi: rtl8192se: Fix warning for unchecked pci_map_single() call
  rtlwifi: rtl8723ae: Fix warning for unchecked pci_map_single() call

 drivers/net/wireless/rtlwifi/pci.c           |    6 ++++++
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |   11 +++++++++++
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c |   10 ++++++++++
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |   13 ++++++++++++-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c |   12 ++++++++++++
 5 files changed, 51 insertions(+), 1 deletion(-)

-- 
1.7.10.4

