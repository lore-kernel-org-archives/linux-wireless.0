Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57527 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab2AaQ3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 11:29:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: Remove extra debugging message accidentally left in
Date: Tue, 31 Jan 2012 10:29:22 -0600
Message-Id: <1328027362-17881-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120131_172937_481273_3BE1856D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit b0302aba812bcc39291cdab9ad7e37008f352a91, an extra debugging
message that is spamming the logs was not deleted before submission.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index f231b91..278e9f9 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -296,12 +296,10 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 			 * because that will cause nullfunc send by mac80211
 			 * fail, and cause pkt loss, we have tested that 5mA
 			 * is worked very well */
-			if (!rtlpriv->psc.multi_buffered) {
+			if (!rtlpriv->psc.multi_buffered)
 				queue_delayed_work(rtlpriv->works.rtl_wq,
 						&rtlpriv->works.ps_work,
 						MSECS(5));
-				pr_info("In section\n");
-			}
 		} else {
 			rtl_swlps_rf_awake(hw);
 			rtlpriv->psc.sw_ps_enabled = false;
-- 
1.7.7

