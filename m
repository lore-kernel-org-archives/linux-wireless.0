Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19792 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbdHXKK0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 06:10:26 -0400
Date: Thu, 24 Aug 2017 13:08:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: rtlwifi: check for array overflow
Message-ID: <20170824100832.lcmbwcjhzwlgozeh@mwanda> (sfid-20170824_121030_207681_EC1BE8BB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch is distrustful of the "capab" value and marks it as user
controlled.  I think it actually comes from the firmware?  Anyway, I
looked at other drivers and they added a bounds check and it seems like
a harmless thing to have so I have added it here as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/rtlwifi/base.c b/drivers/staging/rtlwifi/base.c
index f7f207cbaee3..a30b928d5ee1 100644
--- a/drivers/staging/rtlwifi/base.c
+++ b/drivers/staging/rtlwifi/base.c
@@ -1414,6 +1414,10 @@ bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
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
