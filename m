Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33406 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbcEBGVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 02:21:36 -0400
Date: Mon, 2 May 2016 14:11:02 +0800
From: Wang YanQing <udknight@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: chaoming_li@realsil.com.cn, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi:rtl_lps_enter: fix double check cnt_after_linked
Message-ID: <20160502061102.GB12832@udknight> (sfid-20160502_082152_660500_FA7466D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have checked cnt_after_linked in below code:
"
/*sleep after linked 10s, to let DHCP and 4-way handshake ok enough!! */
if (mac->cnt_after_linked < 5)
        return;
"
So the second check isn't necessary.

This patch delete second check code.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/ps.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index b69321d..9d73581c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -443,14 +443,11 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	/* Idle for a while if we connect to AP a while ago. */
-	if (mac->cnt_after_linked >= 2) {
-		if (ppsc->dot11_psmode == EACTIVE) {
-			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
-				 "Enter 802.11 power save mode...\n");
+	if (ppsc->dot11_psmode == EACTIVE) {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			"Enter 802.11 power save mode...\n");
 
-			rtl_lps_set_psmode(hw, EAUTOPS);
-		}
+		rtl_lps_set_psmode(hw, EAUTOPS);
 	}
 
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
-- 
1.8.5.6.2.g3d8a54e.dirty
