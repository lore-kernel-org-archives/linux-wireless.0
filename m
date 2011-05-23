Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52547 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab1EWNzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 09:55:17 -0400
Received: by pvg12 with SMTP id 12so2567915pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 06:55:17 -0700 (PDT)
Message-ID: <4DDA6730.7090600@ring3k.org> (sfid-20110523_155525_384461_C33F0F66)
Date: Mon, 23 May 2011 22:54:56 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] rtlwifi: Use write barrier when assigning ownership
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure all updates to a descriptor are flushed to memory
before assigning ownship to hardware.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 54b2bd5..06d9ddb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -932,6 +932,7 @@ void rtl92ce_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
 	if (istx == true) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
+			wmb();
 			SET_TX_DESC_OWN(pdesc, 1);
 			break;
 		case HW_DESC_TX_NEXTDESC_ADDR:
@@ -945,6 +946,7 @@ void rtl92ce_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
 	} else {
 		switch (desc_name) {
 		case HW_DESC_RXOWN:
+			wmb();
 			SET_RX_DESC_OWN(pdesc, 1);
 			break;
 		case HW_DESC_RXBUFF_ADDR:
-- 
1.7.4.1


