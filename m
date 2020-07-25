Return-Path: <SRS0=EDlr=BE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD5AC433F4
	for <linux-wireless@archiver.kernel.org>; Sat, 25 Jul 2020 19:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1E13206D8
	for <linux-wireless@archiver.kernel.org>; Sat, 25 Jul 2020 19:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgGYT4Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 25 Jul 2020 15:56:24 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:36004 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728031AbgGYT4Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Jul 2020 15:56:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 5AA211802926E;
        Sat, 25 Jul 2020 19:56:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: verse03_3401d9026f52
X-Filterd-Recvd-Size: 6761
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Jul 2020 19:56:20 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 6/6] rtlwifi: Convert sleeped to slept in rtl_dbg uses
Date:   Sat, 25 Jul 2020 12:55:08 -0700
Message-Id: <33734b374f82d41425c926ec9d2f136be3b65dc2.1595706420.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595706419.git.joe@perches.com>
References: <cover.1595706419.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use a more standard word.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 4771b76bdefa..507cd44661fa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -2189,7 +2189,7 @@ static bool _rtl88ee_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
index b0a978ff6193..aef4d88ebbe9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
@@ -454,7 +454,7 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 						  RT_RF_OFF_LEVL_HALT_NIC);
 			} else {
 				rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-					"Set ERFON sleeped:%d ms\n",
+					"Set ERFON slept:%d ms\n",
 					jiffies_to_msecs(jiffies -
 							 ppsc->last_sleep_jiffies));
 				ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
index 1787b82422f2..a8d9fe269f31 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
@@ -398,7 +398,7 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index f7419b4b3d8d..1a79e1c046cf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -3074,7 +3074,7 @@ bool rtl92d_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_POWER, DBG_DMESG,
-				"awake, sleeped:%d ms state_inap:%x\n",
+				"awake, slept:%d ms state_inap:%x\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies),
 				rtlpriv->psc.state_inap);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index 56d795418e18..48d9fe4054af 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -539,7 +539,7 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
 						  RT_RF_OFF_LEVL_HALT_NIC);
 			} else {
 				rtl_dbg(rtlpriv, COMP_POWER, DBG_DMESG,
-					"awake, sleeped:%d ms state_inap:%x\n",
+					"awake, slept:%d ms state_inap:%x\n",
 					jiffies_to_msecs(jiffies -
 							 ppsc->last_sleep_jiffies),
 					rtlpriv->psc.state_inap);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index e7445fb74075..349275c45622 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -1562,7 +1562,7 @@ static bool _rtl8723e_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index b43574c44117..f742b9069668 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -2528,7 +2528,7 @@ static bool _rtl8723be_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 2255c9b9fc16..852f452d3fd3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -4736,7 +4736,7 @@ static bool _rtl8821ae_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
-- 
2.26.0

