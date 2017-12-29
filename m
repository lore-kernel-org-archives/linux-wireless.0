Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52789 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755328AbdL2Ibk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 03:31:40 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/11] rtlwifi: check for array overflow
Date: Fri, 29 Dec 2017 16:31:03 +0800
Message-ID: <20171229083112.31540-3-pkshih@realtek.com> (sfid-20171229_093321_557932_A306658D)
In-Reply-To: <20171229083112.31540-1-pkshih@realtek.com>
References: <20171229083112.31540-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

This is merged by Ping-Ke Shih from commit dc33bd4309d2 ("staging:
rtlwifi: check for array overflow"), and the original commit log is
reserved below.

Smatch is distrustful of the "capab" value and marks it as user
controlled.  I think it actually comes from the firmware?  Anyway, I
looked at other drivers and they added a bounds check and it seems like
a harmless thing to have so I have added it here as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 704741d6f495..2052e0e5e083 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1321,6 +1321,10 @@ bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 				  le16_to_cpu(mgmt->u.action.u.addba_req.capab);
 				tid = (capab &
 				       IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+				if (tid >= MAX_TID_COUNT) {
+					rcu_read_unlock();
+					return true;
+				}
 				tid_data = &sta_entry->tids[tid];
 				if (tid_data->agg.rx_agg_state ==
 				    RTL_RX_AGG_START)
-- 
2.14.1
