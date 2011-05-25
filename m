Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:47526 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab1EYAlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 20:41:10 -0400
Received: by pxi16 with SMTP id 16so4725752pxi.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 17:41:10 -0700 (PDT)
Message-ID: <4DDC500D.6040308@ring3k.org> (sfid-20110525_024113_467316_3EFC54AD)
Date: Wed, 25 May 2011 09:40:45 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] rtlwifi: Use write barrier when assigning ownership
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure all updates to a descriptor are flushed to memory
before assigning ownship to hardware.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
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


