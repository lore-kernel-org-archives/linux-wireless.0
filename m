Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45054 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbbATRBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 12:01:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
	netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH V2 for 3.19 4/7] rtlwifi: rtl8192ee: Fix TX hang due to failure to update TX write point
Date: Tue, 20 Jan 2015 11:01:23 -0600
Message-Id: <1421773286-1039-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150120_180155_920295_5924C4BC)
In-Reply-To: <1421773286-1039-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1421773286-1039-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Troy Tan <troy_tan@realsil.com.cn>

Initially, the routine to update the write point in the FIFO buffer was
coded to save CPU time by not doing the calculation every interrupt. This
was an error and results in TX hangs.

Signed-off-by: Troy Tan <troy_tan@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> [V3.18]
---
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
index 0a006c4..1535680 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
@@ -1049,8 +1049,7 @@ bool rtl92ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
 	static u8 stop_report_cnt;
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];
 
-	/*checking Read/Write Point each interrupt wastes CPU */
-	if (stop_report_cnt > 15 || !rtlpriv->link_info.busytraffic) {
+	{
 		u16 point_diff = 0;
 		u16 cur_tx_rp, cur_tx_wp;
 		u32 tmpu32 = 0;
-- 
2.1.2

