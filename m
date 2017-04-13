Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34669 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755320AbdDMSHe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:34 -0400
Received: by mail-oi0-f68.google.com with SMTP id t14so4186054oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:33 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 19/19] rtlwifi: btcoex: 21a 2ant: refine tdma duration adjust function
Date: Thu, 13 Apr 2017 13:07:10 -0500
Message-Id: <20170413180710.19953-20-Larry.Finger@lwfinger.net> (sfid-20170413_202544_008766_580D2CFE)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

1. Add more cases to adjust the wifi duration and add a case with
the max interval of 3 for some future uses.

2. rename tdma_adj -> ps_tdma_du_adj to indicate that this member is
for power saving tdma duration adjustment

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 968 +++++++++++++++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   3 +-
 2 files changed, 893 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 3bdf691c9d08..0ef83727fdf4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1716,9 +1716,9 @@ static bool btc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 	return common;
 }
 
-static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
-				      bool sco_hid, bool tx_pause,
-				      u8 max_interval)
+static void btc8821a2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
+					      bool sco_hid, bool tx_pause,
+					      u8 max_interval)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static long up, dn, m, n, wait_count;
@@ -1732,80 +1732,84 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], TdmaDurationAdjust()\n");
 
-	if (coex_dm->reset_tdma_adjust) {
-		coex_dm->reset_tdma_adjust = false;
+	if (coex_dm->auto_tdma_adjust) {
+		coex_dm->auto_tdma_adjust = false;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], first run TdmaDurationAdjust()!!\n");
 		if (sco_hid) {
 			if (tx_pause) {
 				if (max_interval == 1) {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 13);
-					coex_dm->tdma_adj_type = 13;
+							NORMAL_EXEC, true, 13);
+					coex_dm->ps_tdma_du_adj_type = 13;
 				} else if (max_interval == 2) {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 14);
-					coex_dm->tdma_adj_type = 14;
+							NORMAL_EXEC, true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (max_interval == 3) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
 				} else {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 15);
-					coex_dm->tdma_adj_type = 15;
+							NORMAL_EXEC, true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
 				}
 			} else {
 				if (max_interval == 1) {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 9);
-					coex_dm->tdma_adj_type = 9;
+							NORMAL_EXEC, true, 9);
+					coex_dm->ps_tdma_du_adj_type = 9;
 				} else if (max_interval == 2) {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 10);
-					coex_dm->tdma_adj_type = 10;
+							NORMAL_EXEC, true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (max_interval == 3) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
 				} else {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 11);
-					coex_dm->tdma_adj_type = 11;
+							NORMAL_EXEC, true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
 				}
 			}
 		} else {
 			if (tx_pause) {
 				if (max_interval == 1) {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 5);
-					coex_dm->tdma_adj_type = 5;
+							NORMAL_EXEC, true, 5);
+					coex_dm->ps_tdma_du_adj_type = 5;
 				} else if (max_interval == 2) {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 6);
-					coex_dm->tdma_adj_type = 6;
+							NORMAL_EXEC, true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (max_interval == 3) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
 				} else {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 7);
-					coex_dm->tdma_adj_type = 7;
+							NORMAL_EXEC, true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
 				}
 			} else {
 				if (max_interval == 1) {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 1);
-					coex_dm->tdma_adj_type = 1;
+							NORMAL_EXEC, true, 1);
+					coex_dm->ps_tdma_du_adj_type = 1;
 				} else if (max_interval == 2) {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 2);
-					coex_dm->tdma_adj_type = 2;
+							NORMAL_EXEC, true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (max_interval == 3) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
 				} else {
 					btc8821a2ant_ps_tdma(btcoexist,
-							     NORMAL_EXEC,
-							     true, 3);
-					coex_dm->tdma_adj_type = 3;
+							NORMAL_EXEC, true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
 				}
 			}
 		}
@@ -1902,18 +1906,716 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], max Interval = %d\n", max_interval);
+
+		if (max_interval == 1) {
+			if (tx_pause) {
+				if (coex_dm->cur_ps_tdma == 71) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 5);
+					coex_dm->ps_tdma_du_adj_type = 5;
+				} else if (coex_dm->cur_ps_tdma == 1) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 5);
+					coex_dm->ps_tdma_du_adj_type = 5;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 13);
+					coex_dm->ps_tdma_du_adj_type = 13;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 8);
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 16);
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 5);
+						coex_dm->ps_tdma_du_adj_type =
+							5;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 13);
+						coex_dm->ps_tdma_du_adj_type =
+							13;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 71);
+					coex_dm->ps_tdma_du_adj_type = 71;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 9);
+					coex_dm->ps_tdma_du_adj_type = 9;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 71) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 1);
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (coex_dm->cur_ps_tdma == 1) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 4);
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 12);
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 1);
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (coex_dm->cur_ps_tdma == 1) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 71);
+						coex_dm->ps_tdma_du_adj_type =
+							71;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8821a2ant_ps_tdma(
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
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 8);
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 16);
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 1) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 4);
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 12);
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8821a2ant_ps_tdma(
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
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 8);
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 16);
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					btc8821a2ant_ps_tdma(btcoexist,
+							NORMAL_EXEC, true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 1) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 4);
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 12);
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						btc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					}
+				}
+			}
+		}
 	}
 
 	/* if current PsTdma not match with the recorded one
 	 * (when scan, dhcp...), then we have to adjust it back to
 	 * the previous recorded one.
 	 */
-	if (coex_dm->cur_ps_tdma != coex_dm->tdma_adj_type) {
-		bool	scan = false, link = false, roam = false;
+	if (coex_dm->cur_ps_tdma != coex_dm->ps_tdma_du_adj_type) {
+		bool scan = false, link = false, roam = false;
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], PsTdma type dismatch!!!, cur_ps_tdma = %d, recordPsTdma = %d\n",
-			 coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
+			 coex_dm->cur_ps_tdma, coex_dm->ps_tdma_du_adj_type);
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
@@ -1921,14 +2623,12 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 
 		if (!scan && !link && !roam) {
 			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
-					     coex_dm->tdma_adj_type);
+					     coex_dm->ps_tdma_du_adj_type);
 		} else {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
 		}
 	}
-
-	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 0x6);
 }
 
 /* SCO only or SCO+PAN(HS)*/
@@ -2082,7 +2782,7 @@ static void btc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 						       15, 0);
 	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
-	/* fw dac swing is called in btc8821a2ant_tdma_dur_adj()
+	/* fw dac swing is called in btc8821a2ant_tdma_duration_adjust()
 	 * btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 	 */
 
@@ -2097,9 +2797,11 @@ static void btc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, false, 1);
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  false, 1);
 		} else {
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 1);
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  true, 1);
 		}
 
 		/* sw mechanism */
@@ -2119,9 +2821,11 @@ static void btc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, false, 1);
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  false, 1);
 		} else {
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 1);
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  true, 1);
 		}
 
 		/* sw mechanism */
@@ -2160,10 +2864,12 @@ static void btc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 		/* fw mechanism */
 		if (bt_info_ext&BIT0) {
 			/* a2dp basic rate */
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 2);
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  true, 2);
 		} else {
 			/* a2dp edr rate */
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 1);
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  true, 1);
 		}
 
 		/* sw mechanism */
@@ -2183,10 +2889,12 @@ static void btc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 		/* fw mechanism */
 		if (bt_info_ext&BIT0) {
 			/* a2dp basic rate */
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 2);
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  true, 2);
 		} else {
 			/* a2dp edr rate */
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 1);
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  true, 1);
 		}
 
 		/* sw mechanism */
@@ -2384,12 +3092,27 @@ static void btc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
-			btc8821a2ant_tdma_dur_adj(btcoexist, false,
-						  false, 3);
-		else
-			btc8821a2ant_tdma_dur_adj(btcoexist, false,
-						  true, 3);
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			if (bt_info_ext&BIT0) {
+				/* a2dp basic rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							false, false, 3);
+			} else {
+				/* a2dp edr rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							false, false, 3);
+			}
+		} else {
+			if (bt_info_ext&BIT0) {
+				/* a2dp basic rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							false, true, 3);
+			} else {
+				/* a2dp edr rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							false, true, 3);
+			}
+		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -2407,10 +3130,27 @@ static void btc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 	} else {
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, false, 3);
-		else
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 3);
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			if (bt_info_ext&BIT0) {
+				/* a2dp basic rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							false, false, 3);
+			} else {
+				/* a2dp edr rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							false, false, 3);
+			}
+		} else {
+			if (bt_info_ext&BIT0) {
+				/* a2dp basic rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							false, true, 3);
+			} else {
+				/* a2dp edr rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							false, true, 3);
+			}
+		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -2538,7 +3278,28 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
-		btc8821a2ant_tdma_dur_adj(btcoexist, true, true, 3);
+		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			if (bt_info_ext&BIT0) {
+				/* a2dp basic rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							true, true, 3);
+			} else {
+				/* a2dp edr rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							true, true, 3);
+			}
+		} else {
+			if (bt_info_ext&BIT0) {
+				/* a2dp basic rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							true, true, 3);
+			} else {
+				/* a2dp edr rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							true, true, 3);
+			}
+		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -2559,22 +3320,24 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			if (bt_info_ext&BIT0) {
 				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  false, 3);
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							true, false, 3);
 			} else {
 				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  false, 3);
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+							true, false, 3);
 			}
 		} else {
 			if (bt_info_ext&BIT0) {
 				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  3);
 			} else {
 				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  3);
 			}
 		}
 
@@ -2622,7 +3385,32 @@ static void btc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
-		btc8821a2ant_tdma_dur_adj(btcoexist, true, true, 2);
+		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			if (bt_info_ext & BIT0) {
+				/* a2dp basic rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  2);
+			} else {
+				/* a2dp edr rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  2);
+			}
+		} else {
+			if (bt_info_ext & BIT0) {
+				/* a2dp basic rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  2);
+			} else {
+				/* a2dp edr rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  2);
+			}
+		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -2639,7 +3427,33 @@ static void btc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 		}
 	} else {
 		/* fw mechanism */
-		btc8821a2ant_tdma_dur_adj(btcoexist, true, true, 2);
+		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			if (bt_info_ext & BIT0) {
+				/* a2dp basic rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  2);
+
+			} else {
+				/* a2dp edr rate */
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  2);
+			}
+		} else {
+			if (bt_info_ext & BIT0) {
+				/*a2dp basic rate*/
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  2);
+			} else {
+				/*a2dp edr rate*/
+				btc8821a2ant_tdma_duration_adjust(btcoexist,
+								  true, true,
+								  2);
+			}
+		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index 603e446b5953..535ca10e910b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -87,8 +87,9 @@ struct coex_dm_8821a_2ant {
 	u8		pre_ps_tdma;
 	u8		cur_ps_tdma;
 	u8		ps_tdma_para[5];
-	u8		tdma_adj_type;
+	u8		ps_tdma_du_adj_type;
 	bool		reset_tdma_adjust;
+	bool		auto_tdma_adjust;
 	bool		pre_ps_tdma_on;
 	bool		cur_ps_tdma_on;
 	bool		pre_bt_auto_report;
-- 
2.12.0
