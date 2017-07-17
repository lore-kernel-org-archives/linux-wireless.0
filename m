Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34857 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdGQSK0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 14:10:26 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] rtlwifi: rtl8192ee: constify pci_device_id.
Date: Mon, 17 Jul 2017 23:39:55 +0530
Message-Id: <1500314995-3181-8-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170717_201104_305790_3FF14323)
In-Reply-To: <1500314995-3181-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500314995-3181-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   1899	    928	      0	   2827	    b0b	realtek/rtlwifi/rtl8192ee/sw.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   1963	    864	      0	   2827	    b0b	realtek/rtlwifi/rtl8192ee/sw.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index eaa503b..bc4e561 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -354,7 +354,7 @@ static const struct rtl_hal_cfg rtl92ee_hal_cfg = {
 	.maps[RTL_RC_HT_RATEMCS15] = DESC92C_RATEMCS15,
 };
 
-static struct pci_device_id rtl92ee_pci_ids[] = {
+static const struct pci_device_id rtl92ee_pci_ids[] = {
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x818B, rtl92ee_hal_cfg)},
 	{},
 };
-- 
2.7.4
