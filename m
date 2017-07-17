Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34061 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbdGQSKQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 14:10:16 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] rtlwifi: rtl8821ae: constify pci_device_id.
Date: Mon, 17 Jul 2017 23:39:51 +0530
Message-Id: <1500314995-3181-4-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170717_201159_092103_21FE48AB)
In-Reply-To: <1500314995-3181-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500314995-3181-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   2491	    960	      0	   3451	    d7b	realtek/rtlwifi/rtl8821ae/sw.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   2587	    864	      0	   3451	    d7b	realtek/rtlwifi/rtl8821ae/sw.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index d71d277..d94e179 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -424,7 +424,7 @@ static const struct rtl_hal_cfg rtl8821ae_hal_cfg = {
 	.maps[RTL_RC_VHT_RATE_2SS_MCS9] = DESC_RATEVHT2SS_MCS9,
 };
 
-static struct pci_device_id rtl8821ae_pci_ids[] = {
+static const struct pci_device_id rtl8821ae_pci_ids[] = {
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8812, rtl8821ae_hal_cfg)},
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8821, rtl8821ae_hal_cfg)},
 	{},
-- 
2.7.4
