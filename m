Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33941 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdGQSKO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 14:10:14 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] rtlwifi: rtl8192se: constify pci_device_id.
Date: Mon, 17 Jul 2017 23:39:50 +0530
Message-Id: <1500314995-3181-3-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170717_201326_266020_792853C5)
In-Reply-To: <1500314995-3181-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500314995-3181-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   2817	   1040	      0	   3857	    f11 realtek/rtlwifi/rtl8192se/sw.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   3009	    848	      0	   3857	    f11 realtek/rtlwifi/rtl8192se/sw.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index 2006b09..201100e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -396,7 +396,7 @@ static const struct rtl_hal_cfg rtl92se_hal_cfg = {
 	.maps[RTL_RC_HT_RATEMCS15] = DESC_RATEMCS15,
 };
 
-static struct pci_device_id rtl92se_pci_ids[] = {
+static const struct pci_device_id rtl92se_pci_ids[] = {
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8192, rtl92se_hal_cfg)},
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8171, rtl92se_hal_cfg)},
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8172, rtl92se_hal_cfg)},
-- 
2.7.4
