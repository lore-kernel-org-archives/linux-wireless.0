Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52797 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755478AbdL2Ibl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 03:31:41 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/11] rtlwifi: mark expected switch fall-through in rtl_make_smps_action
Date: Fri, 29 Dec 2017 16:31:07 +0800
Message-ID: <20171229083112.31540-7-pkshih@realtek.com> (sfid-20171229_093250_577683_472E515C)
In-Reply-To: <20171229083112.31540-1-pkshih@realtek.com>
References: <20171229083112.31540-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

This is merged by Ping-Ke Shih from commit 640019bba419 ("staging:
rtlwifi: mark expected switch fall-through in rtl_make_smps_action"),
and original commit log is reserved below.

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 2052e0e5e083..c01c5ca767a4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2229,9 +2229,7 @@ static struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
 	case IEEE80211_SMPS_AUTOMATIC:/* 0 */
 	case IEEE80211_SMPS_NUM_MODES:/* 4 */
 		WARN_ON(1);
-	/* Here will get a 'MISSING_BREAK' in Coverity Test, just ignore it.
-	 * According to Kernel Code, here is right.
-	 */
+	/* fall through */
 	case IEEE80211_SMPS_OFF:/* 1 */ /*MIMO_PS_NOLIMIT*/
 		action_frame->u.action.u.ht_smps.smps_control =
 				WLAN_HT_SMPS_CONTROL_DISABLED;/* 0 */
-- 
2.14.1
