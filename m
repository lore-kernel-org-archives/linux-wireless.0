Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36234 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933272AbdCaQsF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 12:48:05 -0400
Received: by mail-oi0-f66.google.com with SMTP id b187so9912132oif.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 09:48:04 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/12] rtlwifi: btcoex: remove unused functions
Date: Fri, 31 Mar 2017 11:47:31 -0500
Message-Id: <20170331164742.22374-2-Larry.Finger@lwfinger.net> (sfid-20170331_184818_176495_373EC0DA)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

A number of functions in the Bluetooth Coexistence routines are not used,
and can be removed.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 590 -------------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 586 -------------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 897 +------------------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 329 +------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 959 +--------------------
 5 files changed, 26 insertions(+), 3335 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index ffa1f43..e5bb61f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -1573,585 +1573,6 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 	return common;
 }
 
-static void btc8192e_int1(struct btc_coexist *btcoexist, bool tx_pause,
-			  int result)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	if (tx_pause) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 1\n");
-
-		if (coex_dm->cur_ps_tdma == 71) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 13);
-			coex_dm->tdma_adj_type = 13;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 5);
-				coex_dm->tdma_adj_type = 5;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 13);
-				coex_dm->tdma_adj_type = 13;
-			}
-		}
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 71);
-			coex_dm->tdma_adj_type = 71;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
-			coex_dm->tdma_adj_type = 9;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 71) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 71);
-				coex_dm->tdma_adj_type = 71;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			}
-		}
-	}
-}
-
-static void btc8192e_int2(struct btc_coexist *btcoexist, bool tx_pause,
-			  int result)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	if (tx_pause) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			}
-		}
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			}
-		}
-	}
-}
-
-static void btc8192e_int3(struct btc_coexist *btcoexist, bool tx_pause,
-			  int result)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	if (tx_pause) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			}
-		}
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			}
-		}
-	}
-}
-
 static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 						 bool sco_hid, bool tx_pause,
 						 u8 max_interval)
@@ -2322,12 +1743,6 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], max Interval = %d\n", max_interval);
-		if (max_interval == 1)
-			btc8192e_int1(btcoexist, tx_pause, result);
-		else if (max_interval == 2)
-			btc8192e_int2(btcoexist, tx_pause, result);
-		else if (max_interval == 3)
-			btc8192e_int3(btcoexist, tx_pause, result);
 	}
 
 	/* if current PsTdma not match with
@@ -3761,11 +3176,6 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	halbtc8192e2ant_run_coexist_mechanism(btcoexist);
 }
 
-void ex_halbtc8192e2ant_stack_operation_notify(struct btc_coexist *btcoexist,
-					       u8 type)
-{
-}
-
 void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index d67bbfb..f163bc4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -60,188 +60,6 @@ static u32 glcoex_ver_8723b_1ant = 0x47;
 /***************************************************************
  * local function start with halbtc8723b1ant_
  ***************************************************************/
-static u8 halbtc8723b1ant_bt_rssi_state(struct btc_coexist *btcoexist,
-					u8 level_num, u8 rssi_thresh,
-					u8 rssi_thresh1)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	s32 bt_rssi = 0;
-	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
-
-	bt_rssi = coex_sta->bt_rssi;
-
-	if (level_num == 2) {
-		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
-		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			if (bt_rssi >= rssi_thresh +
-					BTC_RSSI_COEX_THRESH_TOL_8723B_1ANT) {
-				bt_rssi_state = BTC_RSSI_STATE_HIGH;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state switch to High\n");
-			} else {
-				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state stay at Low\n");
-			}
-		} else {
-			if (bt_rssi < rssi_thresh) {
-				bt_rssi_state = BTC_RSSI_STATE_LOW;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state switch to Low\n");
-			} else {
-				bt_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state stay at High\n");
-			}
-		}
-	} else if (level_num == 3) {
-		if (rssi_thresh > rssi_thresh1) {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], BT Rssi thresh error!!\n");
-			return coex_sta->pre_bt_rssi_state;
-		}
-
-		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
-		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			if (bt_rssi >= rssi_thresh +
-					BTC_RSSI_COEX_THRESH_TOL_8723B_1ANT) {
-				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state switch to Medium\n");
-			} else {
-				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state stay at Low\n");
-			}
-		} else if ((coex_sta->pre_bt_rssi_state ==
-					BTC_RSSI_STATE_MEDIUM) ||
-			  (coex_sta->pre_bt_rssi_state ==
-					BTC_RSSI_STATE_STAY_MEDIUM)) {
-			if (bt_rssi >= rssi_thresh1 +
-					BTC_RSSI_COEX_THRESH_TOL_8723B_1ANT) {
-				bt_rssi_state = BTC_RSSI_STATE_HIGH;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state switch to High\n");
-			} else if (bt_rssi < rssi_thresh) {
-				bt_rssi_state = BTC_RSSI_STATE_LOW;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state switch to Low\n");
-			} else {
-				bt_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state stay at Medium\n");
-			}
-		} else {
-			if (bt_rssi < rssi_thresh1) {
-				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state switch to Medium\n");
-			} else {
-				bt_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Rssi state stay at High\n");
-			}
-		}
-	}
-
-	coex_sta->pre_bt_rssi_state = bt_rssi_state;
-
-	return bt_rssi_state;
-}
-
-static u8 halbtc8723b1ant_wifi_rssi_state(struct btc_coexist *btcoexist,
-					  u8 index, u8 level_num,
-					  u8 rssi_thresh, u8 rssi_thresh1)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	s32 wifi_rssi = 0;
-	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
-
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
-
-	if (level_num == 2) {
-		if ((coex_sta->pre_wifi_rssi_state[index] ==
-					BTC_RSSI_STATE_LOW) ||
-		    (coex_sta->pre_wifi_rssi_state[index] ==
-					BTC_RSSI_STATE_STAY_LOW)) {
-			if (wifi_rssi >= rssi_thresh +
-					BTC_RSSI_COEX_THRESH_TOL_8723B_1ANT) {
-				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state switch to High\n");
-			} else {
-				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state stay at Low\n");
-			}
-		} else {
-			if (wifi_rssi < rssi_thresh) {
-				wifi_rssi_state = BTC_RSSI_STATE_LOW;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state switch to Low\n");
-			} else {
-				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state stay at High\n");
-			}
-		}
-	} else if (level_num == 3) {
-		if (rssi_thresh > rssi_thresh1) {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], wifi RSSI thresh error!!\n");
-			return coex_sta->pre_wifi_rssi_state[index];
-		}
-
-		if ((coex_sta->pre_wifi_rssi_state[index] ==
-						BTC_RSSI_STATE_LOW) ||
-		    (coex_sta->pre_wifi_rssi_state[index] ==
-						BTC_RSSI_STATE_STAY_LOW)) {
-			if (wifi_rssi >= rssi_thresh +
-					 BTC_RSSI_COEX_THRESH_TOL_8723B_1ANT) {
-				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state switch to Medium\n");
-			} else {
-				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state stay at Low\n");
-			}
-		} else if ((coex_sta->pre_wifi_rssi_state[index] ==
-						BTC_RSSI_STATE_MEDIUM) ||
-			   (coex_sta->pre_wifi_rssi_state[index] ==
-						BTC_RSSI_STATE_STAY_MEDIUM)) {
-			if (wifi_rssi >= rssi_thresh1 +
-					 BTC_RSSI_COEX_THRESH_TOL_8723B_1ANT) {
-				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state switch to High\n");
-			} else if (wifi_rssi < rssi_thresh) {
-				wifi_rssi_state = BTC_RSSI_STATE_LOW;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state switch to Low\n");
-			} else {
-				wifi_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state stay at Medium\n");
-			}
-		} else {
-			if (wifi_rssi < rssi_thresh1) {
-				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state switch to Medium\n");
-			} else {
-				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], wifi RSSI state stay at High\n");
-			}
-		}
-	}
-
-	coex_sta->pre_wifi_rssi_state[index] = wifi_rssi_state;
-
-	return wifi_rssi_state;
-}
 
 static void halbtc8723b1ant_updatera_mask(struct btc_coexist *btcoexist,
 					  bool force_exec, u32 dis_rate_mask)
@@ -515,202 +333,6 @@ static void halbtc8723b1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 		bt_link_info->hid_only = false;
 }
 
-static u8 halbtc8723b1ant_action_algorithm(struct btc_coexist *btcoexist)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool bt_hs_on = false;
-	u8 algorithm = BT_8723B_1ANT_COEX_ALGO_UNDEFINED;
-	u8 numdiffprofile = 0;
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
-
-	if (!bt_link_info->bt_link_exist) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], No BT link exists!!!\n");
-		return algorithm;
-	}
-
-	if (bt_link_info->sco_exist)
-		numdiffprofile++;
-	if (bt_link_info->hid_exist)
-		numdiffprofile++;
-	if (bt_link_info->pan_exist)
-		numdiffprofile++;
-	if (bt_link_info->a2dp_exist)
-		numdiffprofile++;
-
-	if (numdiffprofile == 1) {
-		if (bt_link_info->sco_exist) {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], BT Profile = SCO only\n");
-			algorithm = BT_8723B_1ANT_COEX_ALGO_SCO;
-		} else {
-			if (bt_link_info->hid_exist) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Profile = HID only\n");
-				algorithm = BT_8723B_1ANT_COEX_ALGO_HID;
-			} else if (bt_link_info->a2dp_exist) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Profile = A2DP only\n");
-				algorithm = BT_8723B_1ANT_COEX_ALGO_A2DP;
-			} else if (bt_link_info->pan_exist) {
-				if (bt_hs_on) {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = PAN(HS) only\n");
-					algorithm =
-						BT_8723B_1ANT_COEX_ALGO_PANHS;
-				} else {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = PAN(EDR) only\n");
-					algorithm =
-						BT_8723B_1ANT_COEX_ALGO_PANEDR;
-				}
-			}
-		}
-	} else if (numdiffprofile == 2) {
-		if (bt_link_info->sco_exist) {
-			if (bt_link_info->hid_exist) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Profile = SCO + HID\n");
-				algorithm = BT_8723B_1ANT_COEX_ALGO_HID;
-			} else if (bt_link_info->a2dp_exist) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Profile = SCO + A2DP ==> SCO\n");
-				algorithm = BT_8723B_1ANT_COEX_ALGO_SCO;
-			} else if (bt_link_info->pan_exist) {
-				if (bt_hs_on) {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = SCO + PAN(HS)\n");
-					algorithm = BT_8723B_1ANT_COEX_ALGO_SCO;
-				} else {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = SCO + PAN(EDR)\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_PANEDR_HID;
-				}
-			}
-		} else {
-			if (bt_link_info->hid_exist &&
-			    bt_link_info->a2dp_exist) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Profile = HID + A2DP\n");
-				algorithm = BT_8723B_1ANT_COEX_ALGO_HID_A2DP;
-			} else if (bt_link_info->hid_exist &&
-				   bt_link_info->pan_exist) {
-				if (bt_hs_on) {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = HID + PAN(HS)\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_HID_A2DP;
-				} else {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = HID + PAN(EDR)\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_PANEDR_HID;
-				}
-			} else if (bt_link_info->pan_exist &&
-				   bt_link_info->a2dp_exist) {
-				if (bt_hs_on) {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = A2DP + PAN(HS)\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_A2DP_PANHS;
-				} else {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = A2DP + PAN(EDR)\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_PANEDR_A2DP;
-				}
-			}
-		}
-	} else if (numdiffprofile == 3) {
-		if (bt_link_info->sco_exist) {
-			if (bt_link_info->hid_exist &&
-			    bt_link_info->a2dp_exist) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], BT Profile = SCO + HID + A2DP ==> HID\n");
-				algorithm = BT_8723B_1ANT_COEX_ALGO_HID;
-			} else if (bt_link_info->hid_exist &&
-				   bt_link_info->pan_exist) {
-				if (bt_hs_on) {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = SCO + HID + PAN(HS)\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_HID_A2DP;
-				} else {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = SCO + HID + PAN(EDR)\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_PANEDR_HID;
-				}
-			} else if (bt_link_info->pan_exist &&
-				   bt_link_info->a2dp_exist) {
-				if (bt_hs_on) {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = SCO + A2DP + PAN(HS)\n");
-					algorithm = BT_8723B_1ANT_COEX_ALGO_SCO;
-				} else {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = SCO + A2DP + PAN(EDR) ==> HID\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_PANEDR_HID;
-				}
-			}
-		} else {
-			if (bt_link_info->hid_exist &&
-			    bt_link_info->pan_exist &&
-			    bt_link_info->a2dp_exist) {
-				if (bt_hs_on) {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = HID + A2DP + PAN(HS)\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_HID_A2DP;
-				} else {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = HID + A2DP + PAN(EDR)\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_HID_A2DP_PANEDR;
-				}
-			}
-		}
-	} else if (numdiffprofile >= 3) {
-		if (bt_link_info->sco_exist) {
-			if (bt_link_info->hid_exist &&
-			    bt_link_info->pan_exist &&
-			    bt_link_info->a2dp_exist) {
-				if (bt_hs_on) {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], Error!!! BT Profile = SCO + HID + A2DP + PAN(HS)\n");
-				} else {
-					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
-						 DBG_LOUD,
-						 "[BTCoex], BT Profile = SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
-					algorithm =
-					    BT_8723B_1ANT_COEX_ALGO_PANEDR_HID;
-				}
-			}
-		}
-	}
-
-	return algorithm;
-}
-
 static void btc8723b1ant_set_sw_pen_tx_rate_adapt(struct btc_coexist *btcoexist,
 						  bool low_penalty_ra)
 {
@@ -1407,64 +1029,6 @@ static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
-static bool halbtc8723b1ant_is_common_action(struct btc_coexist *btcoexist)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	bool commom = false, wifi_connected = false;
-	bool wifi_busy = false;
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
-			   &wifi_connected);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
-
-	if (!wifi_connected &&
-	    BT_8723B_1ANT_BT_STATUS_NON_CONNECTED_IDLE == coex_dm->bt_status) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Wifi non connected-idle + BT non connected-idle!!\n");
-		halbtc8723b1ant_sw_mechanism(btcoexist, false);
-		commom = true;
-	} else if (wifi_connected &&
-		   (BT_8723B_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
-		    coex_dm->bt_status)) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Wifi connected + BT non connected-idle!!\n");
-		halbtc8723b1ant_sw_mechanism(btcoexist, false);
-		commom = true;
-	} else if (!wifi_connected &&
-		   (BT_8723B_1ANT_BT_STATUS_CONNECTED_IDLE ==
-		    coex_dm->bt_status)) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Wifi non connected-idle + BT connected-idle!!\n");
-		halbtc8723b1ant_sw_mechanism(btcoexist, false);
-		commom = true;
-	} else if (wifi_connected &&
-		   (BT_8723B_1ANT_BT_STATUS_CONNECTED_IDLE ==
-		    coex_dm->bt_status)) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Wifi connected + BT connected-idle!!\n");
-		halbtc8723b1ant_sw_mechanism(btcoexist, false);
-		commom = true;
-	} else if (!wifi_connected &&
-		   (BT_8723B_1ANT_BT_STATUS_CONNECTED_IDLE !=
-		    coex_dm->bt_status)) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Wifi non connected-idle + BT Busy!!\n");
-		halbtc8723b1ant_sw_mechanism(btcoexist, false);
-		commom = true;
-	} else {
-		if (wifi_busy)
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
-		else
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
-
-		commom = false;
-	}
-
-	return commom;
-}
-
 static void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 					      u8 wifi_status)
 {
@@ -1700,66 +1264,6 @@ static void halbtc8723b1ant_power_save_state(struct btc_coexist *btcoexist,
 	}
 }
 
-/***************************************************
- *
- *	Software Coex Mechanism start
- *
- ***************************************************/
-/* SCO only or SCO+PAN(HS) */
-static void halbtc8723b1ant_action_sco(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, true);
-}
-
-static void halbtc8723b1ant_action_hid(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, true);
-}
-
-/*A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
-static void halbtc8723b1ant_action_a2dp(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, false);
-}
-
-static void halbtc8723b1ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, false);
-}
-
-static void halbtc8723b1ant_action_pan_edr(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, false);
-}
-
-/* PAN(HS) only */
-static void halbtc8723b1ant_action_pan_hs(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, false);
-}
-
-/*PAN(EDR)+A2DP */
-static void halbtc8723b1ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, false);
-}
-
-static void halbtc8723b1ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, true);
-}
-
-/* HID+A2DP+PAN(EDR) */
-static void btc8723b1ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, true);
-}
-
-static void halbtc8723b1ant_action_hid_a2dp(struct btc_coexist *btcoexist)
-{
-	halbtc8723b1ant_sw_mechanism(btcoexist, true);
-}
-
 /*****************************************************
  *
  *	Non-Software Coex Mechanism start
@@ -1840,11 +1344,8 @@ static void halbtc8723b1ant_action_wifi_connected_bt_acl_busy(
 					struct btc_coexist *btcoexist,
 					u8 wifi_status)
 {
-	u8 bt_rssi_state;
-
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
-	bt_rssi_state = halbtc8723b1ant_bt_rssi_state(btcoexist, 2, 28, 0);
 
 	if (bt_link_info->hid_only) {  /*HID */
 		btc8723b1ant_act_bt_sco_hid_only_busy(btcoexist, wifi_status);
@@ -1857,12 +1358,6 @@ static void halbtc8723b1ant_action_wifi_connected_bt_acl_busy(
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 2);
 			coex_dm->auto_tdma_adjust = false;
-		} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-			   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b1ant_tdma_dur_adj_for_acl(btcoexist,
-							  wifi_status);
-			halbtc8723b1ant_coex_table_with_type(btcoexist,
-							     NORMAL_EXEC, 1);
 		} else { /*for low BT RSSI */
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 11);
@@ -2109,75 +1604,6 @@ static void halbtc8723b1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 	}
 }
 
-static void btc8723b1ant_run_sw_coex_mech(struct btc_coexist *btcoexist)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 algorithm = 0;
-
-	algorithm = halbtc8723b1ant_action_algorithm(btcoexist);
-	coex_dm->cur_algorithm = algorithm;
-
-	if (!halbtc8723b1ant_is_common_action(btcoexist)) {
-		switch (coex_dm->cur_algorithm) {
-		case BT_8723B_1ANT_COEX_ALGO_SCO:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = SCO\n");
-			halbtc8723b1ant_action_sco(btcoexist);
-			break;
-		case BT_8723B_1ANT_COEX_ALGO_HID:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = HID\n");
-			halbtc8723b1ant_action_hid(btcoexist);
-			break;
-		case BT_8723B_1ANT_COEX_ALGO_A2DP:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = A2DP\n");
-			halbtc8723b1ant_action_a2dp(btcoexist);
-			break;
-		case BT_8723B_1ANT_COEX_ALGO_A2DP_PANHS:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = A2DP+PAN(HS)\n");
-			halbtc8723b1ant_action_a2dp_pan_hs(btcoexist);
-			break;
-		case BT_8723B_1ANT_COEX_ALGO_PANEDR:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = PAN(EDR)\n");
-			halbtc8723b1ant_action_pan_edr(btcoexist);
-			break;
-		case BT_8723B_1ANT_COEX_ALGO_PANHS:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = HS mode\n");
-			halbtc8723b1ant_action_pan_hs(btcoexist);
-			break;
-		case BT_8723B_1ANT_COEX_ALGO_PANEDR_A2DP:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = PAN+A2DP\n");
-			halbtc8723b1ant_action_pan_edr_a2dp(btcoexist);
-			break;
-		case BT_8723B_1ANT_COEX_ALGO_PANEDR_HID:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = PAN(EDR)+HID\n");
-			halbtc8723b1ant_action_pan_edr_hid(btcoexist);
-			break;
-		case BT_8723B_1ANT_COEX_ALGO_HID_A2DP_PANEDR:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = HID+A2DP+PAN\n");
-			btc8723b1ant_action_hid_a2dp_pan_edr(btcoexist);
-			break;
-		case BT_8723B_1ANT_COEX_ALGO_HID_A2DP:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = HID+A2DP\n");
-			halbtc8723b1ant_action_hid_a2dp(btcoexist);
-			break;
-		default:
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Action algorithm = coexist All Off!!\n");
-			break;
-		}
-		coex_dm->pre_algorithm = coex_dm->cur_algorithm;
-	}
-}
-
 static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -2186,7 +1612,6 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	bool increase_scan_dev_num = false;
 	bool bt_ctrl_agg_buf_size = false;
 	u8 agg_buf_size = 5;
-	u8 wifi_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
 
@@ -2263,8 +1688,6 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	halbtc8723b1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
 				   bt_ctrl_agg_buf_size, agg_buf_size);
 
-	btc8723b1ant_run_sw_coex_mech(btcoexist);
-
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	if (coex_sta->c2h_bt_inquiry_page) {
@@ -2375,12 +1798,6 @@ static void halbtc8723b1ant_init_hw_config(struct btc_coexist *btcoexist,
 	halbtc8723b1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 }
 
-static void halbtc8723b1ant_wifi_off_hw_cfg(struct btc_coexist *btcoexist)
-{
-	/* set wlan_act to low */
-	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
-}
-
 /**************************************************************
  * work around function start with wa_halbtc8723b1ant_
  **************************************************************/
@@ -2703,7 +2120,6 @@ void ex_halbtc8723b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
 		halbtc8723b1ant_coex_table_with_type(btcoexist,
 						     NORMAL_EXEC, 0);
-		halbtc8723b1ant_wifi_off_hw_cfg(btcoexist);
 	} else if (BTC_IPS_LEAVE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], IPS LEAVE notify\n");
@@ -3091,7 +2507,6 @@ void ex_halbtc8723b1ant_halt_notify(struct btc_coexist *btcoexist)
 
 	halbtc8723b1ant_SetAntPath(btcoexist, BTC_ANT_PATH_BT, false, true);
 
-	halbtc8723b1ant_wifi_off_hw_cfg(btcoexist);
 	halbtc8723b1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 
 	halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
@@ -3117,7 +2532,6 @@ void ex_halbtc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 						 0x0, 0x0);
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
 		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
-		halbtc8723b1ant_wifi_off_hw_cfg(btcoexist);
 	} else if (BTC_WIFI_PNP_WAKE_UP == pnp_state) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Pnp notify to WAKE UP\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 1212596..4e5dfaa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -584,44 +584,6 @@ static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 	return algorithm;
 }
 
-static bool btc8723b_need_dec_pwr(struct btc_coexist *btcoexist)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	bool ret = false;
-	bool bt_hs_on = false, wifi_connected = false;
-	s32 bt_hs_rssi = 0;
-	u8 bt_rssi_state;
-
-	if (!btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on))
-		return false;
-	if (!btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
-				&wifi_connected))
-		return false;
-	if (!btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi))
-		return false;
-
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
-
-	if (wifi_connected) {
-		if (bt_hs_on) {
-			if (bt_hs_rssi > 37) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], Need to decrease bt power for HS mode!!\n");
-				ret = true;
-			}
-		} else {
-			if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-			    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], Need to decrease bt power for Wifi is connected!!\n");
-				ret = true;
-			}
-		}
-	}
-
-	return ret;
-}
-
 static void btc8723b2ant_set_fw_dac_swing_level(struct btc_coexist *btcoexist,
 						u8 dac_swing_lvl)
 {
@@ -708,57 +670,6 @@ static void btc8723b2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 	coex_dm->pre_fw_dac_swing_lvl = coex_dm->cur_fw_dac_swing_lvl;
 }
 
-static void btc8723b2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
-						 bool rx_rf_shrink_on)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	if (rx_rf_shrink_on) {
-		/* Shrink RF Rx LPF corner */
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Shrink RF Rx LPF corner!!\n");
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
-					  0xfffff, 0xffffc);
-	} else {
-		/* Resume RF Rx LPF corner */
-		/* After initialized, we can use coex_dm->btRf0x1eBackup */
-		if (btcoexist->initilized) {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Resume RF Rx LPF corner!!\n");
-			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
-						  0xfffff,
-						  coex_dm->bt_rf0x1e_backup);
-		}
-	}
-}
-
-static void btc8723b2ant_rf_shrink(struct btc_coexist *btcoexist,
-				   bool force_exec, bool rx_rf_shrink_on)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s turn Rx RF Shrink = %s\n",
-		    (force_exec ? "force to" : ""), (rx_rf_shrink_on ?
-						     "ON" : "OFF"));
-	coex_dm->cur_rf_rx_lpf_shrink = rx_rf_shrink_on;
-
-	if (!force_exec) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], bPreRfRxLpfShrink=%d, bCurRfRxLpfShrink=%d\n",
-			    coex_dm->pre_rf_rx_lpf_shrink,
-			    coex_dm->cur_rf_rx_lpf_shrink);
-
-		if (coex_dm->pre_rf_rx_lpf_shrink ==
-		    coex_dm->cur_rf_rx_lpf_shrink)
-			return;
-	}
-	btc8723b2ant_set_sw_rf_rx_lpf_corner(btcoexist,
-					     coex_dm->cur_rf_rx_lpf_shrink);
-
-	coex_dm->pre_rf_rx_lpf_shrink = coex_dm->cur_rf_rx_lpf_shrink;
-}
-
 static void btc8723b_set_penalty_txrate(struct btc_coexist *btcoexist,
 					bool low_penalty_ra)
 {
@@ -863,105 +774,6 @@ static void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
 	coex_dm->pre_dac_swing_lvl = coex_dm->cur_dac_swing_lvl;
 }
 
-static void btc8723b2ant_set_agc_table(struct btc_coexist *btcoexist,
-				       bool agc_table_en)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 rssi_adjust_val = 0;
-
-	/*  BB AGC Gain Table */
-	if (agc_table_en) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BB Agc Table On!\n");
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x6e1A0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x6d1B0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x6c1C0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x6b1D0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x6a1E0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x691F0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x68200001);
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BB Agc Table Off!\n");
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xaa1A0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa91B0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa81C0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa71D0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa61E0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa51F0001);
-		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa4200001);
-	}
-
-	/* RF Gain */
-	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0xef, 0xfffff, 0x02000);
-	if (agc_table_en) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Agc Table On!\n");
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x3b,
-					  0xfffff, 0x38fff);
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x3b,
-					  0xfffff, 0x38ffe);
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Agc Table Off!\n");
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x3b,
-					  0xfffff, 0x380c3);
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x3b,
-					  0xfffff, 0x28ce6);
-	}
-	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0xef, 0xfffff, 0x0);
-
-	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0xed, 0xfffff, 0x1);
-
-	if (agc_table_en) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Agc Table On!\n");
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x40,
-					  0xfffff, 0x38fff);
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x40,
-					  0xfffff, 0x38ffe);
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Agc Table Off!\n");
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x40,
-					  0xfffff, 0x380c3);
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x40,
-					  0xfffff, 0x28ce6);
-	}
-	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0xed, 0xfffff, 0x0);
-
-	/* set rssiAdjustVal for wifi module. */
-	if (agc_table_en)
-		rssi_adjust_val = 8;
-	btcoexist->btc_set(btcoexist, BTC_SET_U1_RSSI_ADJ_VAL_FOR_AGC_TABLE_ON,
-			   &rssi_adjust_val);
-}
-
-static void btc8723b2ant_agc_table(struct btc_coexist *btcoexist,
-				   bool force_exec, bool agc_table_en)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s %s Agc Table\n",
-		 (force_exec ? "force to" : ""),
-		 (agc_table_en ? "Enable" : "Disable"));
-	coex_dm->cur_agc_table_en = agc_table_en;
-
-	if (!force_exec) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], bPreAgcTableEn=%d, bCurAgcTableEn=%d\n",
-			 coex_dm->pre_agc_table_en,
-			 coex_dm->cur_agc_table_en);
-
-		if (coex_dm->pre_agc_table_en == coex_dm->cur_agc_table_en)
-			return;
-	}
-	btc8723b2ant_set_agc_table(btcoexist, agc_table_en);
-
-	coex_dm->pre_agc_table_en = coex_dm->cur_agc_table_en;
-}
-
 static void btc8723b2ant_set_coex_table(struct btc_coexist *btcoexist,
 					u32 val0x6c0, u32 val0x6c4,
 					u32 val0x6c8, u8 val0x6cc)
@@ -1159,19 +971,9 @@ static void btc8723b2ant_sw_mechanism1(struct btc_coexist *btcoexist,
 				       bool shrink_rx_lpf, bool low_penalty_ra,
 				       bool limited_dig, bool bt_lna_constrain)
 {
-	btc8723b2ant_rf_shrink(btcoexist, NORMAL_EXEC, shrink_rx_lpf);
 	btc8723b2ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
 }
 
-static void btc8723b2ant_sw_mechanism2(struct btc_coexist *btcoexist,
-				       bool agc_table_shift, bool adc_backoff,
-				       bool sw_dac_swing, u32 dac_swing_lvl)
-{
-	btc8723b2ant_agc_table(btcoexist, NORMAL_EXEC, agc_table_shift);
-	btc8723b2ant_dac_swing(btcoexist, NORMAL_EXEC, sw_dac_swing,
-			       dac_swing_lvl);
-}
-
 static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 				      u8 antpos_type, bool init_hwcfg,
 				      bool wifi_off)
@@ -1407,7 +1209,6 @@ static void btc8723b2ant_coex_alloff(struct btc_coexist *btcoexist)
 
 	/* sw all off */
 	btc8723b2ant_sw_mechanism1(btcoexist, false, false, false, false);
-	btc8723b2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 
 	/* hw all off */
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
@@ -1423,7 +1224,6 @@ static void btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 	btc8723b2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, false);
 
 	btc8723b2ant_sw_mechanism1(btcoexist, false, false, false, false);
-	btc8723b2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
 static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
@@ -1447,7 +1247,6 @@ static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 	btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btc8723b2ant_sw_mechanism1(btcoexist, false, false, false, false);
-	btc8723b2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 
 	coex_dm->need_recover_0x948 = true;
 	coex_dm->backup_0x948 = btcoexist->btc_read_2byte(btcoexist, 0x948);
@@ -1485,8 +1284,6 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 
 		btc8723b2ant_sw_mechanism1(btcoexist, false, false, false,
 					   false);
-		btc8723b2ant_sw_mechanism2(btcoexist, false, false, false,
-					   0x18);
 
 		common = true;
 	} else {
@@ -1511,8 +1308,6 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 
 			common = true;
 		} else if (BT_8723B_2ANT_BT_STATUS_CONNECTED_IDLE ==
@@ -1538,8 +1333,6 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 
 			common = true;
 		} else {
@@ -1568,20 +1361,9 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 				btc8723b2ant_fw_dac_swing_lvl(btcoexist,
 							      NORMAL_EXEC,
 							      0xb);
-				if (btc8723b_need_dec_pwr(btcoexist))
-					btc8723b2ant_dec_bt_pwr(btcoexist,
-								NORMAL_EXEC,
-								true);
-				else
-					btc8723b2ant_dec_bt_pwr(btcoexist,
-								NORMAL_EXEC,
-								false);
 				btc8723b2ant_sw_mechanism1(btcoexist, false,
 							   false, false,
 							   false);
-				btc8723b2ant_sw_mechanism2(btcoexist, false,
-							   false, false,
-							   0x18);
 				common = true;
 			}
 		}
@@ -1590,550 +1372,6 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 	return common;
 }
 
-static void set_tdma_int1(struct btc_coexist *btcoexist, bool tx_pause,
-			  s32 result)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	/* Set PS TDMA for max interval == 1 */
-	if (tx_pause) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 1\n");
-
-		if (coex_dm->cur_ps_tdma == 71) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 1) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-
-		if (coex_dm->cur_ps_tdma == 9) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 13);
-			coex_dm->tdma_adj_type = 13;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		}  else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 5);
-				coex_dm->tdma_adj_type = 5;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 13);
-				coex_dm->tdma_adj_type = 13;
-			}
-		}
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 71);
-			coex_dm->tdma_adj_type = 71;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-
-		if (coex_dm->cur_ps_tdma == 13) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
-			coex_dm->tdma_adj_type = 9;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 71) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		}  else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 71);
-				coex_dm->tdma_adj_type = 71;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 9);
-				coex_dm->tdma_adj_type = 9;
-			}
-		}
-	}
-}
-
-static void set_tdma_int2(struct btc_coexist *btcoexist, bool tx_pause,
-			  s32 result)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	/* Set PS TDMA for max interval == 2 */
-	if (tx_pause) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		}  else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 14);
-				coex_dm->tdma_adj_type = 14;
-			}
-		}
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 10);
-				coex_dm->tdma_adj_type = 10;
-			}
-		}
-	}
-}
-
-static void set_tdma_int3(struct btc_coexist *btcoexist, bool tx_pause,
-			  s32 result)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	/* Set PS TDMA for max interval == 3 */
-	if (tx_pause) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		}  else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 15);
-				coex_dm->tdma_adj_type = 15;
-			}
-		}
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 11);
-				coex_dm->tdma_adj_type = 11;
-			}
-		}
-	}
-}
-
 static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					  bool sco_hid, bool tx_pause,
 					  u8 max_interval)
@@ -2302,12 +1540,6 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], max Interval = %d\n", max_interval);
-		if (max_interval == 1)
-			set_tdma_int1(btcoexist, tx_pause, result);
-		else if (max_interval == 2)
-			set_tdma_int2(btcoexist, tx_pause, result);
-		else if (max_interval == 3)
-			set_tdma_int3(btcoexist, tx_pause, result);
 	}
 
 	/*if current PsTdma not match with the recorded one (when scan, dhcp..),
@@ -2345,11 +1577,6 @@ static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 4);
 
-	if (btc8723b_need_dec_pwr(btcoexist))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	/*for SCO quality at 11b/g mode*/
@@ -2367,26 +1594,18 @@ static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   true, 0x4);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   true, 0x4);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   true, 0x4);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   true, 0x4);
 		}
 	}
 }
@@ -2404,11 +1623,6 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (btc8723b_need_dec_pwr(btcoexist))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	if (BTC_WIFI_BW_LEGACY == wifi_bw) /*/for HID at 11b/g mode*/
@@ -2428,26 +1642,18 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	}
 }
@@ -2482,13 +1688,9 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 		if (BTC_WIFI_BW_HT40 == wifi_bw) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   true, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   true, 0x18);
 		}
 		return;
 	}
@@ -2497,11 +1699,6 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (btc8723b_need_dec_pwr(btcoexist))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-
 	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -2518,26 +1715,18 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	}
 }
@@ -2554,11 +1743,6 @@ static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (btc8723b_need_dec_pwr(btcoexist))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-
 	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
 
 	btc8723b2ant_tdma_duration_adjust(btcoexist, false, true, 2);
@@ -2571,26 +1755,18 @@ static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	}
 }
@@ -2608,10 +1784,10 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (btc8723b_need_dec_pwr(btcoexist))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 10);
 
@@ -2628,26 +1804,18 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	}
 }
@@ -2681,26 +1849,18 @@ static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	}
 }
@@ -2719,8 +1879,8 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (btc8723b_need_dec_pwr(btcoexist))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
@@ -2746,26 +1906,18 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	}
 }
@@ -2780,8 +1932,8 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (btc8723b_need_dec_pwr(btcoexist))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
@@ -2815,26 +1967,18 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	}
 }
@@ -2853,8 +1997,8 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (btc8723b_need_dec_pwr(btcoexist))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
@@ -2880,26 +2024,18 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	}
 }
@@ -2917,11 +2053,6 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (btc8723b_need_dec_pwr(btcoexist))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
@@ -2938,26 +2069,18 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
 		} else {
 			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
-			btc8723b2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
 		}
 	}
 }
@@ -3677,8 +2800,6 @@ void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 
 #if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 0)
 	btc8723b2ant_query_bt_info(btcoexist);
-	btc8723b2ant_monitor_bt_ctr(btcoexist);
-	btc8723b2ant_monitor_bt_enable_disable(btcoexist);
 #else
 	if (btc8723b2ant_is_wifi_status_changed(btcoexist) ||
 	    coex_dm->auto_tdma_adjust)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 8b689ed..4a8d8cf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -670,51 +670,6 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 	return algorithm;
 }
 
-static void halbtc8821a1ant_set_bt_auto_report(struct btc_coexist *btcoexist,
-					       bool enable_auto_report)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 h2c_parameter[1] = {0};
-
-	h2c_parameter[0] = 0;
-
-	if (enable_auto_report)
-		h2c_parameter[0] |= BIT0;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
-		 (enable_auto_report ? "Enabled!!" : "Disabled!!"),
-		 h2c_parameter[0]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
-}
-
-static void halbtc8821a1ant_bt_auto_report(struct btc_coexist *btcoexist,
-					   bool force_exec,
-					   bool enable_auto_report)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s BT Auto report = %s\n",
-		 (force_exec ? "force to" : ""), ((enable_auto_report) ?
-						     "Enabled" : "Disabled"));
-	coex_dm->cur_bt_auto_report = enable_auto_report;
-
-	if (!force_exec) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], pre_bt_auto_report = %d, cur_bt_auto_report = %d\n",
-			    coex_dm->pre_bt_auto_report,
-			    coex_dm->cur_bt_auto_report);
-
-		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
-			return;
-	}
-	halbtc8821a1ant_set_bt_auto_report(btcoexist, coex_dm->cur_bt_auto_report);
-
-	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
-}
-
 static void btc8821a1ant_set_sw_pen_tx_rate(struct btc_coexist *btcoexist,
 					    bool low_penalty_ra)
 {
@@ -1333,196 +1288,6 @@ static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 	return common;
 }
 
-static void btc8821a1ant_tdma_dur_adj(struct btc_coexist *btcoexist,
-				      u8 wifi_status)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	static long		up, dn, m, n, wait_count;
-	/*0: no change, +1: increase WiFi duration, -1: decrease WiFi duration*/
-	long			result;
-	u8			retry_count = 0, bt_info_ext;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], TdmaDurationAdjustForAcl()\n");
-
-	if ((BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN ==
-	     wifi_status) ||
-	    (BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN ==
-	     wifi_status) ||
-	    (BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SPECIAL_PKT ==
-	     wifi_status)) {
-		if (coex_dm->cur_ps_tdma != 1 &&
-		    coex_dm->cur_ps_tdma != 2 &&
-		    coex_dm->cur_ps_tdma != 3 &&
-		    coex_dm->cur_ps_tdma != 9) {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
-			coex_dm->tdma_adj_type = 9;
-
-			up = 0;
-			dn = 0;
-			m = 1;
-			n = 3;
-			result = 0;
-			wait_count = 0;
-		}
-		return;
-	}
-
-	if (!coex_dm->auto_tdma_adjust) {
-		coex_dm->auto_tdma_adjust = true;
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], first run TdmaDurationAdjust()!!\n");
-
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
-		coex_dm->tdma_adj_type = 2;
-		/*============*/
-		up = 0;
-		dn = 0;
-		m = 1;
-		n = 3;
-		result = 0;
-		wait_count = 0;
-	} else {
-		/*accquire the BT TRx retry count from BT_Info byte2*/
-		retry_count = coex_sta->bt_retry_cnt;
-		bt_info_ext = coex_sta->bt_info_ext;
-		result = 0;
-		wait_count++;
-
-		if (retry_count == 0) {
-			/* no retry in the last 2-second duration*/
-			up++;
-			dn--;
-
-			if (dn <= 0)
-				dn = 0;
-
-			if (up >= n) {
-				/* if (retry count == 0) for 2*n seconds ,
-				 * make WiFi duration wider
-				 */
-				wait_count = 0;
-				n = 3;
-				up = 0;
-				dn = 0;
-				result = 1;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], Increase wifi duration!!\n");
-			}
-		} else if (retry_count <= 3) {
-			/* <=3 retry in the last 2-second duration*/
-			up--;
-			dn++;
-
-			if (up <= 0)
-				up = 0;
-
-			if (dn == 2) {
-				/* if retry count< 3 for 2*2 seconds,
-				 * shrink wifi duration
-				 */
-				if (wait_count <= 2)
-					m++; /* avoid bounce in two levels */
-				else
-					m = 1;
-
-				if (m >= 20) {
-					/* m max value is 20, max time is 120 s,
-					 *	recheck if adjust WiFi duration.
-					 */
-					m = 20;
-				}
-				n = 3*m;
-				up = 0;
-				dn = 0;
-				wait_count = 0;
-				result = -1;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], Decrease wifi duration for retryCounter<3!!\n");
-			}
-		} else {
-			/* retry count > 3, if retry count > 3 happens once,
-			 *	shrink WiFi duration
-			 */
-			if (wait_count == 1)
-				m++; /* avoid bounce in two levels */
-			else
-				m = 1;
-		/* m max value is 20, max time is 120 second,
-		 *	recheck if adjust WiFi duration.
-		*/
-			if (m >= 20)
-				m = 20;
-
-			n = 3*m;
-			up = 0;
-			dn = 0;
-			wait_count = 0;
-			result = -1;
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Decrease wifi duration for retryCounter>3!!\n");
-		}
-
-		if (result == -1) {
-			if ((BT_INFO_8821A_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
-			    ((coex_dm->cur_ps_tdma == 1) ||
-			     (coex_dm->cur_ps_tdma == 2))) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			}
-		} else if (result == 1) {
-			if ((BT_INFO_8821A_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
-			    ((coex_dm->cur_ps_tdma == 1) ||
-			     (coex_dm->cur_ps_tdma == 2))) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			}
-		} else {
-			/*no change*/
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], ********** TDMA(on, %d) **********\n",
-				 coex_dm->cur_ps_tdma);
-		}
-
-		if (coex_dm->cur_ps_tdma != 1 &&
-		    coex_dm->cur_ps_tdma != 2 &&
-		    coex_dm->cur_ps_tdma != 9 &&
-		    coex_dm->cur_ps_tdma != 11) {
-			/* recover to previous adjust type*/
-			halbtc8821a1ant_ps_tdma(btcoexist,
-						NORMAL_EXEC, true,
-						coex_dm->tdma_adj_type);
-		}
-	}
-}
-
 static void btc8821a1ant_ps_tdma_check_for_pwr_save(struct btc_coexist *btcoex,
 						    bool new_ps_state)
 {
@@ -1599,74 +1364,11 @@ static void halbtc8821a1ant_coex_under_5g(struct btc_coexist *btcoexist)
 	halbtc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 5);
 }
 
-static void halbtc8821a1ant_action_wifi_only(struct btc_coexist *btcoexist)
-{
-	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 9);
-}
-
-static void btc8821a1ant_mon_bt_en_dis(struct btc_coexist *btcoexist)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	static bool	pre_bt_disabled;
-	static u32	bt_disable_cnt;
-	bool		bt_active = true, bt_disabled = false;
-
-	/* This function check if bt is disabled*/
-
-	if (coex_sta->high_priority_tx == 0 &&
-	    coex_sta->high_priority_rx == 0 &&
-	    coex_sta->low_priority_tx == 0 &&
-	    coex_sta->low_priority_rx == 0) {
-		bt_active = false;
-	}
-	if (coex_sta->high_priority_tx == 0xffff &&
-	    coex_sta->high_priority_rx == 0xffff &&
-	    coex_sta->low_priority_tx == 0xffff &&
-	    coex_sta->low_priority_rx == 0xffff) {
-		bt_active = false;
-	}
-	if (bt_active) {
-		bt_disable_cnt = 0;
-		bt_disabled = false;
-		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
-				   &bt_disabled);
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BT is enabled !!\n");
-	} else {
-		bt_disable_cnt++;
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], bt all counters = 0, %d times!!\n",
-			 bt_disable_cnt);
-		if (bt_disable_cnt >= 2) {
-			bt_disabled = true;
-			btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
-					   &bt_disabled);
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], BT is disabled !!\n");
-			halbtc8821a1ant_action_wifi_only(btcoexist);
-		}
-	}
-	if (pre_bt_disabled != bt_disabled) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BT is from %s to %s!!\n",
-			    (pre_bt_disabled ? "disabled" : "enabled"),
-			    (bt_disabled ? "disabled" : "enabled"));
-		pre_bt_disabled = bt_disabled;
-		if (bt_disabled) {
-			btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS,
-					   NULL);
-			btcoexist->btc_set(btcoexist, BTC_SET_ACT_NORMAL_LPS,
-					   NULL);
-		}
-	}
-}
-
-/*=============================================*/
-/**/
-/*	Software Coex Mechanism start*/
-/**/
-/*=============================================*/
+/***********************************************
+ *
+ *	Software Coex Mechanism start
+ *
+ ***********************************************/
 
 /* SCO only or SCO+PAN(HS)*/
 static void halbtc8821a1ant_action_sco(struct btc_coexist *btcoexist)
@@ -1788,10 +1490,8 @@ static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 		return;
 	} else if (bt_link_info->a2dp_only) {
 		/*A2DP*/
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a1ant_tdma_dur_adj(btcoexist, wifi_status);
-		} else {
+		if ((bt_rssi_state != BTC_RSSI_STATE_HIGH) &&
+		    (bt_rssi_state != BTC_RSSI_STATE_STAY_HIGH)) {
 			/*for low BT RSSI*/
 			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 11);
@@ -2814,14 +2514,6 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 								false);
 			}
 		}
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
-		if (!(coex_sta->bt_info_ext & BIT4)) {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], BT ext info bit4 check, set BT to enable Auto Report!!\n");
-			halbtc8821a1ant_bt_auto_report(btcoexist,
-						       FORCE_EXEC, true);
-		}
-#endif
 	}
 
 	/* check BIT2 first ==> check if bt is under inquiry or page scan*/
@@ -2984,14 +2676,7 @@ void ex_halbtc8821a1ant_periodical(struct btc_coexist *btcoexist)
 #if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
 	halbtc8821a1ant_query_bt_info(btcoexist);
 	halbtc8821a1ant_monitor_bt_ctr(btcoexist);
-	btc8821a1ant_mon_bt_en_dis(btcoexist);
 #else
-	if (halbtc8821a1ant_Is_wifi_status_changed(btcoexist) ||
-	    coex_dm->auto_tdma_adjust) {
-		if (coex_sta->special_pkt_period_cnt > 2)
-			halbtc8821a1ant_run_coexist_mechanism(btcoexist);
-	}
-
 	coex_sta->special_pkt_period_cnt++;
 #endif
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 1717e9c..7b7772b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -248,54 +248,6 @@ static u8 halbtc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 	return wifi_rssi_state;
 }
 
-static void btc8821a2ant_mon_bt_en_dis(struct btc_coexist *btcoexist)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	static bool	pre_bt_disabled;
-	static u32	bt_disable_cnt;
-	bool		bt_active = true, bt_disabled = false;
-
-	/* This function check if bt is disabled*/
-
-	if (coex_sta->high_priority_tx == 0 &&
-	    coex_sta->high_priority_rx == 0 &&
-	    coex_sta->low_priority_tx == 0 &&
-	    coex_sta->low_priority_rx == 0)
-		bt_active = false;
-	if (coex_sta->high_priority_tx == 0xffff &&
-	    coex_sta->high_priority_rx == 0xffff &&
-	    coex_sta->low_priority_tx == 0xffff &&
-	    coex_sta->low_priority_rx == 0xffff)
-		bt_active = false;
-	if (bt_active) {
-		bt_disable_cnt = 0;
-		bt_disabled = false;
-		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
-				   &bt_disabled);
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BT is enabled !!\n");
-	} else {
-		bt_disable_cnt++;
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], bt all counters = 0, %d times!!\n",
-			 bt_disable_cnt);
-		if (bt_disable_cnt >= 2) {
-			bt_disabled = true;
-			btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
-					   &bt_disabled);
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], BT is disabled !!\n");
-		}
-	}
-	if (pre_bt_disabled != bt_disabled) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BT is from %s to %s!!\n",
-			 (pre_bt_disabled ? "disabled" : "enabled"),
-			 (bt_disabled ? "disabled" : "enabled"));
-		pre_bt_disabled = bt_disabled;
-	}
-}
-
 static void halbtc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -536,43 +488,6 @@ static u8 halbtc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 	return algorithm;
 }
 
-static bool halbtc8821a2ant_need_to_dec_bt_pwr(struct btc_coexist *btcoexist)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	bool ret = false;
-	bool bt_hs_on = false, wifi_connected = false;
-	long bt_hs_rssi = 0;
-	u8 bt_rssi_state;
-
-	if (!btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on))
-		return false;
-	if (!btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
-				&wifi_connected))
-		return false;
-	if (!btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi))
-		return false;
-
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
-
-	if (wifi_connected) {
-		if (bt_hs_on) {
-			if (bt_hs_rssi > 37) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], Need to decrease bt power for HS mode!!\n");
-				ret = true;
-			}
-		} else {
-			if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-			    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], Need to decrease bt power for Wifi is connected!!\n");
-				ret = true;
-			}
-		}
-	}
-	return ret;
-}
-
 static void btc8821a2ant_set_fw_dac_swing_lev(struct btc_coexist *btcoexist,
 					      u8 dac_swing_lvl)
 {
@@ -634,140 +549,6 @@ static void halbtc8821a2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
 	coex_dm->pre_dec_bt_pwr = coex_dm->cur_dec_bt_pwr;
 }
 
-static void btc8821a2ant_set_fw_bt_lna_constr(struct btc_coexist *btcoexist,
-					      bool bt_lna_cons_on)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 h2c_parameter[2] = {0};
-
-	h2c_parameter[0] = 0x3;	/* opCode, 0x3 = BT_SET_LNA_CONSTRAIN */
-
-	if (bt_lna_cons_on)
-		h2c_parameter[1] |= BIT0;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], set BT LNA Constrain: %s, FW write 0x69 = 0x%x\n",
-		 bt_lna_cons_on ? "ON!!" : "OFF!!",
-		 h2c_parameter[0] << 8 | h2c_parameter[1]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x69, 2, h2c_parameter);
-}
-
-static void btc8821a2_set_bt_lna_const(struct btc_coexist *btcoexist,
-				       bool force_exec, bool bt_lna_cons_on)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s BT Constrain = %s\n",
-		 (force_exec ? "force" : ""),
-		 ((bt_lna_cons_on) ? "ON" : "OFF"));
-	coex_dm->cur_bt_lna_constrain = bt_lna_cons_on;
-
-	if (!force_exec) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], pre_bt_lna_constrain = %d,cur_bt_lna_constrain = %d\n",
-			    coex_dm->pre_bt_lna_constrain,
-			    coex_dm->cur_bt_lna_constrain);
-
-		if (coex_dm->pre_bt_lna_constrain ==
-		    coex_dm->cur_bt_lna_constrain)
-			return;
-	}
-	btc8821a2ant_set_fw_bt_lna_constr(btcoexist,
-					  coex_dm->cur_bt_lna_constrain);
-
-	coex_dm->pre_bt_lna_constrain = coex_dm->cur_bt_lna_constrain;
-}
-
-static void halbtc8821a2ant_set_fw_bt_psd_mode(struct btc_coexist *btcoexist,
-					       u8 bt_psd_mode)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 h2c_parameter[2] = {0};
-
-	h2c_parameter[0] = 0x2;	/* opCode, 0x2 = BT_SET_PSD_MODE */
-
-	h2c_parameter[1] = bt_psd_mode;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], set BT PSD mode = 0x%x, FW write 0x69 = 0x%x\n",
-		 h2c_parameter[1],
-		 h2c_parameter[0] << 8 | h2c_parameter[1]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x69, 2, h2c_parameter);
-}
-
-static void halbtc8821a2ant_set_bt_psd_mode(struct btc_coexist *btcoexist,
-					    bool force_exec, u8 bt_psd_mode)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s BT PSD mode = 0x%x\n",
-		 (force_exec ? "force" : ""), bt_psd_mode);
-	coex_dm->cur_bt_psd_mode = bt_psd_mode;
-
-	if (!force_exec) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], pre_bt_psd_mode = 0x%x, cur_bt_psd_mode = 0x%x\n",
-			 coex_dm->pre_bt_psd_mode, coex_dm->cur_bt_psd_mode);
-
-		if (coex_dm->pre_bt_psd_mode == coex_dm->cur_bt_psd_mode)
-			return;
-	}
-	halbtc8821a2ant_set_fw_bt_psd_mode(btcoexist,
-					   coex_dm->cur_bt_psd_mode);
-
-	coex_dm->pre_bt_psd_mode = coex_dm->cur_bt_psd_mode;
-}
-
-static void halbtc8821a2ant_set_bt_auto_report(struct btc_coexist *btcoexist,
-					       bool enable_auto_report)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 h2c_parameter[1] = {0};
-
-	h2c_parameter[0] = 0;
-
-	if (enable_auto_report)
-		h2c_parameter[0] |= BIT0;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
-		 (enable_auto_report ? "Enabled!!" : "Disabled!!"),
-		 h2c_parameter[0]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
-}
-
-static void halbtc8821a2ant_bt_auto_report(struct btc_coexist *btcoexist,
-					   bool force_exec,
-					   bool enable_auto_report)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s BT Auto report = %s\n",
-		 (force_exec ? "force to" : ""),
-		 ((enable_auto_report) ? "Enabled" : "Disabled"));
-	coex_dm->cur_bt_auto_report = enable_auto_report;
-
-	if (!force_exec) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], pre_bt_auto_report = %d, cur_bt_auto_report = %d\n",
-			    coex_dm->pre_bt_auto_report,
-			    coex_dm->cur_bt_auto_report);
-
-		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
-			return;
-	}
-	halbtc8821a2ant_set_bt_auto_report(btcoexist,
-					   coex_dm->cur_bt_auto_report);
-
-	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
-}
-
 static void halbtc8821a2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 					     bool force_exec,
 					     u8 fw_dac_swing_lvl)
@@ -796,58 +577,6 @@ static void halbtc8821a2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 	coex_dm->pre_fw_dac_swing_lvl = coex_dm->cur_fw_dac_swing_lvl;
 }
 
-static void btc8821a2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
-						 bool rx_rf_shrink_on)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	if (rx_rf_shrink_on) {
-		/* Shrink RF Rx LPF corner */
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Shrink RF Rx LPF corner!!\n");
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
-					  0xfffff, 0xffffc);
-	} else {
-		/* Resume RF Rx LPF corner
-		 * After initialized, we can use coex_dm->bt_rf0x1e_backup
-		 */
-		if (btcoexist->initilized) {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Resume RF Rx LPF corner!!\n");
-			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A,
-						  0x1e, 0xfffff,
-						   coex_dm->bt_rf0x1e_backup);
-		}
-	}
-}
-
-static void halbtc8821a2ant_RfShrink(struct btc_coexist *btcoexist,
-				     bool force_exec, bool rx_rf_shrink_on)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s turn Rx RF Shrink = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((rx_rf_shrink_on) ? "ON" : "OFF"));
-	coex_dm->cur_rf_rx_lpf_shrink = rx_rf_shrink_on;
-
-	if (!force_exec) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], pre_rf_rx_lpf_shrink = %d, cur_rf_rx_lpf_shrink = %d\n",
-			 coex_dm->pre_rf_rx_lpf_shrink,
-			 coex_dm->cur_rf_rx_lpf_shrink);
-
-		if (coex_dm->pre_rf_rx_lpf_shrink ==
-		    coex_dm->cur_rf_rx_lpf_shrink)
-			return;
-	}
-	btc8821a2ant_set_sw_rf_rx_lpf_corner(btcoexist,
-					     coex_dm->cur_rf_rx_lpf_shrink);
-
-	coex_dm->pre_rf_rx_lpf_shrink = coex_dm->cur_rf_rx_lpf_shrink;
-}
-
 static void btc8821a2ant_SetSwPenTxRateAdapt(struct btc_coexist *btcoexist,
 					     bool low_penalty_ra)
 {
@@ -958,47 +687,6 @@ static void halbtc8821a2ant_dac_swing(struct btc_coexist *btcoexist,
 	coex_dm->pre_dac_swing_lvl = coex_dm->cur_dac_swing_lvl;
 }
 
-static void halbtc8821a2ant_set_adc_back_off(struct btc_coexist *btcoexist,
-					     bool adc_back_off)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	if (adc_back_off) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BB BackOff Level On!\n");
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x8db, 0x60, 0x3);
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BB BackOff Level Off!\n");
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x8db, 0x60, 0x1);
-	}
-}
-
-static void halbtc8821a2ant_adc_back_off(struct btc_coexist *btcoexist,
-					 bool force_exec, bool adc_back_off)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s turn AdcBackOff = %s\n",
-		 (force_exec ? "force to" : ""),
-		 ((adc_back_off) ? "ON" : "OFF"));
-	coex_dm->cur_adc_back_off = adc_back_off;
-
-	if (!force_exec) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], pre_adc_back_off = %d, cur_adc_back_off = %d\n",
-			 coex_dm->pre_adc_back_off,
-			 coex_dm->cur_adc_back_off);
-
-		if (coex_dm->pre_adc_back_off == coex_dm->cur_adc_back_off)
-			return;
-	}
-	halbtc8821a2ant_set_adc_back_off(btcoexist, coex_dm->cur_adc_back_off);
-
-	coex_dm->pre_adc_back_off = coex_dm->cur_adc_back_off;
-}
-
 static void halbtc8821a2ant_set_coex_table(struct btc_coexist *btcoexist,
 					   u32 val0x6c0, u32 val0x6c4,
 					   u32 val0x6c8, u8 val0x6cc)
@@ -1152,14 +840,8 @@ static void btc8821a2ant_sw_mech1(struct btc_coexist *btcoexist,
 			shrink_rx_lpf = false;
 	}
 
-	halbtc8821a2ant_RfShrink(btcoexist, NORMAL_EXEC, shrink_rx_lpf);
 	halbtc8821a2ant_low_penalty_ra(btcoexist,
 				       NORMAL_EXEC, low_penalty_ra);
-
-	/* no limited DIG
-	 * btc8821a2_set_bt_lna_const(btcoexist,
-		NORMAL_EXEC, bBTLNAConstrain);
-	 */
 }
 
 static void btc8821a2ant_sw_mech2(struct btc_coexist *btcoexist,
@@ -1167,10 +849,8 @@ static void btc8821a2ant_sw_mech2(struct btc_coexist *btcoexist,
 				  bool adc_back_off, bool sw_dac_swing,
 				  u32 dac_swing_lvl)
 {
-	/* halbtc8821a2ant_AgcTable(btcoexist, NORMAL_EXEC, bAGCTableShift); */
-	halbtc8821a2ant_adc_back_off(btcoexist, NORMAL_EXEC, adc_back_off);
 	halbtc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, sw_dac_swing,
-				  sw_dac_swing);
+			       sw_dac_swing);
 }
 
 static void halbtc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
@@ -1541,12 +1221,6 @@ static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 			halbtc8821a2ant_ps_tdma(btcoexist,
 						NORMAL_EXEC, true, 21);
 
-			if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-				halbtc8821a2ant_dec_bt_pwr(btcoexist,
-							   NORMAL_EXEC, true);
-			else
-				halbtc8821a2ant_dec_bt_pwr(btcoexist,
-							   NORMAL_EXEC, false);
 
 			common = true;
 		}
@@ -1555,585 +1229,6 @@ static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 	return common;
 }
 
-static void btc8821a2_int1(struct btc_coexist *btcoexist, bool tx_pause,
-			   int result)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	if (tx_pause) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 1\n");
-
-		if (coex_dm->cur_ps_tdma == 71) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 13);
-			coex_dm->tdma_adj_type = 13;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 5);
-				coex_dm->tdma_adj_type = 5;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 13);
-				coex_dm->tdma_adj_type = 13;
-			}
-		}
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 71);
-			coex_dm->tdma_adj_type = 71;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
-			coex_dm->tdma_adj_type = 9;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 71) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 71);
-				coex_dm->tdma_adj_type = 71;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			}
-		}
-	}
-}
-
-static void btc8821a2_int2(struct btc_coexist *btcoexist, bool tx_pause,
-			   int result)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	if (tx_pause) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			}
-		}
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			}
-		}
-	}
-}
-
-static void btc8821a2_int3(struct btc_coexist *btcoexist, bool tx_pause,
-			   int result)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	if (tx_pause) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			}
-		}
-	} else {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			}
-		}
-	}
-}
-
 static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 				      bool sco_hid, bool tx_pause,
 				      u8 max_interval)
@@ -2319,12 +1414,6 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], max Interval = %d\n", max_interval);
-		if (max_interval == 1)
-			btc8821a2_int1(btcoexist, tx_pause, result);
-		else if (max_interval == 2)
-			btc8821a2_int2(btcoexist, tx_pause, result);
-		else if (max_interval == 3)
-			btc8821a2_int3(btcoexist, tx_pause, result);
 	}
 
 	/* if current PsTdma not match with the recorded one
@@ -2366,7 +1455,7 @@ static void halbtc8821a2ant_action_sco(struct btc_coexist *btcoexist)
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 4);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
+	if (BTC_RSSI_HIGH(bt_rssi_state))
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -2444,7 +1533,7 @@ static void halbtc8821a2ant_action_hid(struct btc_coexist *btcoexist)
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
+	if (BTC_RSSI_HIGH(bt_rssi_state))
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -2526,7 +1615,7 @@ static void halbtc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 	 * halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 	 */
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
+	if (BTC_RSSI_HIGH(bt_rssi_state))
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -2594,7 +1683,7 @@ static void halbtc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 	 *halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 	 */
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
+	if (BTC_RSSI_HIGH(bt_rssi_state))
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -2661,7 +1750,7 @@ static void halbtc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
+	if (BTC_RSSI_HIGH(bt_rssi_state))
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -2810,7 +1899,7 @@ static void halbtc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
+	if (BTC_RSSI_HIGH(bt_rssi_state))
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -2878,7 +1967,7 @@ static void halbtc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
+	if (BTC_RSSI_HIGH(bt_rssi_state))
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -2954,7 +2043,7 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
+	if (BTC_RSSI_HIGH(bt_rssi_state))
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -3032,7 +2121,7 @@ static void halbtc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 							  15, 0);
 	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
+	if (BTC_RSSI_HIGH(bt_rssi_state))
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
 		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -3592,7 +2681,6 @@ void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8		bt_info = 0;
 	u8		i, rsp_source = 0;
-	static u32	set_bt_lna_cnt, set_bt_psd_mode;
 	bool		bt_busy = false, limited_dig = false;
 	bool		wifi_connected = false, bt_hs_on = false;
 
@@ -3642,25 +2730,6 @@ void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 					BTC_MEDIA_DISCONNECT);
 			}
 
-			set_bt_psd_mode = 0;
-		}
-		if (set_bt_psd_mode <= 3) {
-			halbtc8821a2ant_set_bt_psd_mode(btcoexist, FORCE_EXEC,
-							0x0); /*fix CH-BW mode*/
-			set_bt_psd_mode++;
-		}
-
-		if (coex_dm->cur_bt_lna_constrain) {
-			if (!(coex_sta->bt_info_ext & BIT2)) {
-				if (set_bt_lna_cnt <= 3) {
-					btc8821a2_set_bt_lna_const(btcoexist,
-								   FORCE_EXEC,
-								   true);
-					set_bt_lna_cnt++;
-				}
-			}
-		} else {
-			set_bt_lna_cnt = 0;
 		}
 
 		if ((coex_sta->bt_info_ext & BIT3)) {
@@ -3669,13 +2738,6 @@ void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		} else {
 			/* BT already NOT ignore Wlan active, do nothing here.*/
 		}
-
-		if ((coex_sta->bt_info_ext & BIT4)) {
-			/* BT auto report already enabled, do nothing*/
-		} else {
-			halbtc8821a2ant_bt_auto_report(btcoexist,
-						       FORCE_EXEC, true);
-		}
 	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
@@ -3787,5 +2849,4 @@ void ex_halbtc8821a2ant_periodical(struct btc_coexist *btcoexist)
 
 	halbtc8821a2ant_query_bt_info(btcoexist);
 	halbtc8821a2ant_monitor_bt_ctr(btcoexist);
-	btc8821a2ant_mon_bt_en_dis(btcoexist);
 }
-- 
2.10.2
