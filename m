Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35790 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932328AbdDQALR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:17 -0400
Received: by mail-oi0-f66.google.com with SMTP id a21so8760130oic.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/27] rtlwifi: btcoex: Restore 23b 1ant routine for tdma adjustment
Date: Sun, 16 Apr 2017 19:10:45 -0500
Message-Id: <20170417001111.29384-2-Larry.Finger@lwfinger.net> (sfid-20170417_021126_278752_03BA3B2C)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Routine btc8723b1ant_tdma_dur_adj_for_acl() was removed in a set of
Sparse fixes; however, this routine will be needed later.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 177 ++++++++++++++++++++-
 1 file changed, 176 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 2003c8c51dcc..48b941e75e54 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1037,8 +1037,183 @@ static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
+void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
+				       u8 wifi_status)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	static s32 up, dn, m, n, wait_count;
+	/*  0: no change, +1: increase WiFi duration,
+	 * -1: decrease WiFi duration
+	 */
+	s32 result;
+	u8 retry_count = 0, bt_info_ext;
+	bool wifi_busy = false;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], TdmaDurationAdjustForAcl()\n");
+
+	if (wifi_status == BT_8723B_1ANT_WIFI_STATUS_CONNECTED_BUSY)
+		wifi_busy = true;
+	else
+		wifi_busy = false;
+
+	if ((wifi_status ==
+	     BT_8723B_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN) ||
+	    (wifi_status == BT_8723B_1ANT_WIFI_STATUS_CONNECTED_SCAN) ||
+	    (wifi_status == BT_8723B_1ANT_WIFI_STATUS_CONNECTED_SPECIAL_PKT)) {
+		if (coex_dm->cur_ps_tdma != 1 && coex_dm->cur_ps_tdma != 2 &&
+		    coex_dm->cur_ps_tdma != 3 && coex_dm->cur_ps_tdma != 9) {
+			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						true, 9);
+			coex_dm->tdma_adj_type = 9;
+
+			up = 0;
+			dn = 0;
+			m = 1;
+			n = 3;
+			result = 0;
+			wait_count = 0;
+		}
+		return;
+	}
+
+	if (!coex_dm->auto_tdma_adjust) {
+		coex_dm->auto_tdma_adjust = true;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], first run TdmaDurationAdjust()!!\n");
+
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
+		coex_dm->tdma_adj_type = 2;
+
+		up = 0;
+		dn = 0;
+		m = 1;
+		n = 3;
+		result = 0;
+		wait_count = 0;
+	} else {
+		/* acquire the BT TRx retry count from BT_Info byte2 */
+		retry_count = coex_sta->bt_retry_cnt;
+		bt_info_ext = coex_sta->bt_info_ext;
+		result = 0;
+		wait_count++;
+		/* no retry in the last 2-second duration */
+		if (retry_count == 0) {
+			up++;
+			dn--;
+
+			if (dn <= 0)
+				dn = 0;
+
+			if (up >= n) {
+				wait_count = 0;
+				n = 3;
+				up = 0;
+				dn = 0;
+				result = 1;
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Increase wifi duration!!\n");
+			}
+		} else if (retry_count <= 3) {
+			up--;
+			dn++;
+
+			if (up <= 0)
+				up = 0;
+
+			if (dn == 2) {
+				if (wait_count <= 2)
+					m++;
+				else
+					m = 1;
+
+				if (m >= 20)
+					m = 20;
+
+				n = 3 * m;
+				up = 0;
+				dn = 0;
+				wait_count = 0;
+				result = -1;
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Decrease wifi duration for retryCounter<3!!\n");
+			}
+		} else {
+			if (wait_count == 1)
+				m++;
+			else
+				m = 1;
+
+			if (m >= 20)
+				m = 20;
+
+			n = 3 * m;
+			up = 0;
+			dn = 0;
+			wait_count = 0;
+			result = -1;
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Decrease wifi duration for retryCounter>3!!\n");
+		}
+
+		if (result == -1) {
+			if ((BT_INFO_8723B_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
+			    ((coex_dm->cur_ps_tdma == 1) ||
+			     (coex_dm->cur_ps_tdma == 2))) {
+				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+							true, 9);
+				coex_dm->tdma_adj_type = 9;
+			} else if (coex_dm->cur_ps_tdma == 1) {
+				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+							true, 2);
+				coex_dm->tdma_adj_type = 2;
+			} else if (coex_dm->cur_ps_tdma == 2) {
+				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+							true, 9);
+				coex_dm->tdma_adj_type = 9;
+			} else if (coex_dm->cur_ps_tdma == 9) {
+				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+							true, 11);
+				coex_dm->tdma_adj_type = 11;
+			}
+		} else if (result == 1) {
+			if ((BT_INFO_8723B_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
+			    ((coex_dm->cur_ps_tdma == 1) ||
+			     (coex_dm->cur_ps_tdma == 2))) {
+				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+							true, 9);
+				coex_dm->tdma_adj_type = 9;
+			} else if (coex_dm->cur_ps_tdma == 11) {
+				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+							true, 9);
+				coex_dm->tdma_adj_type = 9;
+			} else if (coex_dm->cur_ps_tdma == 9) {
+				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+							true, 2);
+				coex_dm->tdma_adj_type = 2;
+			} else if (coex_dm->cur_ps_tdma == 2) {
+				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+							true, 1);
+				coex_dm->tdma_adj_type = 1;
+			}
+		} else {
+			/* if busy / idle change */
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex],********* TDMA(on, %d) ********\n",
+				 coex_dm->cur_ps_tdma);
+		}
+
+		if (coex_dm->cur_ps_tdma != 1 && coex_dm->cur_ps_tdma != 2 &&
+		    coex_dm->cur_ps_tdma != 9 && coex_dm->cur_ps_tdma != 11) {
+			/* recover to previous adjust type */
+			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						coex_dm->tdma_adj_type);
+		}
+	}
+}
+
 static void halbtc8723b1ant_ps_tdma_chk_pwr_save(struct btc_coexist *btcoexist,
-						 bool new_ps_state)
+					  bool new_ps_state)
 {
 	u8 lps_mode = 0x0;
 
-- 
2.12.0
