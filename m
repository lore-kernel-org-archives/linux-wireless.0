Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42400 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeHPP6O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 11:58:14 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] orinoco: remove unused array encaps_hdr and macro ENCAPS_OVERHEAD
Date: Thu, 16 Aug 2018 13:59:44 +0100
Message-Id: <20180816125944.7804-1-colin.king@canonical.com> (sfid-20180816_150001_140571_B13A629B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Array encaps_hdr and macro ENCAPS_OVERHEAD are declared but are
not being used, hence they are redundant and can be removed.

Cleans up clang warning:
warning: 'encaps_hdr' defined but not used [-Wunused-const-variable=]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 94ad6fe29e69..d8c27203bc57 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -73,10 +73,6 @@
 #define URB_ASYNC_UNLINK 0
 #endif
 
-/* 802.2 LLC/SNAP header used for Ethernet encapsulation over 802.11 */
-static const u8 encaps_hdr[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
-#define ENCAPS_OVERHEAD		(sizeof(encaps_hdr) + 2)
-
 struct header_struct {
 	/* 802.3 */
 	u8 dest[ETH_ALEN];
-- 
2.17.1
