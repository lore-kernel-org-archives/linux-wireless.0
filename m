Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33769 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932072AbdDDQu1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:27 -0400
Received: by mail-oi0-f68.google.com with SMTP id f193so25703827oib.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:27 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 04/13] rtlwifi: btcoex: 23b 2ant: more cases for adjusting tdma duration
Date: Tue,  4 Apr 2017 11:49:57 -0500
Message-Id: <20170404165006.14329-5-Larry.Finger@lwfinger.net> (sfid-20170404_185034_521250_F3DDE173)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

These cases are for the btcoex to tune the performance

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 766 +++++++++++++++++++++
 1 file changed, 766 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index ae02be8..1f3c2bc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1638,6 +1638,11 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 							     NORMAL_EXEC,
 							     true, 14);
 					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (max_interval == 3) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
@@ -1655,6 +1660,11 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 							     NORMAL_EXEC,
 							     true, 10);
 					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (max_interval == 3) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+						     true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
@@ -1674,6 +1684,11 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 							     NORMAL_EXEC,
 							     true, 6);
 					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (max_interval == 3) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
@@ -1691,6 +1706,11 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 							     NORMAL_EXEC,
 							     true, 2);
 					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (max_interval == 3) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
@@ -1796,6 +1816,752 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], max Interval = %d\n", max_interval);
+		if (max_interval == 1) {
+			if (tx_pause) {
+				if (coex_dm->cur_ps_tdma == 71) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 5);
+					coex_dm->ps_tdma_du_adj_type = 5;
+				} else if (coex_dm->cur_ps_tdma == 1) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 5);
+					coex_dm->ps_tdma_du_adj_type = 5;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 13);
+					coex_dm->ps_tdma_du_adj_type = 13;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 8);
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 16);
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 5);
+						coex_dm->ps_tdma_du_adj_type =
+							5;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 13);
+						coex_dm->ps_tdma_du_adj_type =
+							13;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 71);
+					coex_dm->ps_tdma_du_adj_type = 71;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 9);
+					coex_dm->ps_tdma_du_adj_type = 9;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 71) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 1);
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (coex_dm->cur_ps_tdma == 1) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 4);
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 12);
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 1);
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (coex_dm->cur_ps_tdma == 1) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 71);
+						coex_dm->ps_tdma_du_adj_type =
+							71;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 9);
+						coex_dm->ps_tdma_du_adj_type =
+							9;
+					}
+				}
+			}
+		} else if (max_interval == 2) {
+			if (tx_pause) {
+				if (coex_dm->cur_ps_tdma == 1) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 8);
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 16);
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 1) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 4);
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 12);
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					}
+				}
+			}
+		} else if (max_interval == 3) {
+			if (tx_pause) {
+				if (coex_dm->cur_ps_tdma == 1) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 8);
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 16);
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					btc8723b2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 1) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 4);
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 12);
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8723b2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					}
+				}
+			}
+		}
 	}
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-- 
2.10.2
