Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33163 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1EWNyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 09:54:14 -0400
Received: by mail-pw0-f46.google.com with SMTP id 15so2611783pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 06:54:13 -0700 (PDT)
Message-ID: <4DDA66F0.5000803@ring3k.org> (sfid-20110523_155434_458382_4AE742CD)
Date: Mon, 23 May 2011 22:53:52 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] rtlwifi: Remove set_rfpowerstate_inprogress
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set_rfpowerstate_inprogress is only set and never read
so remove it.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |    2 --
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    2 --
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    4 ----
 drivers/net/wireless/rtlwifi/wifi.h          |    1 -
 4 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index abe0fcc..544e0b7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -521,7 +521,6 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 	u8 i, queue_id;
 	struct rtl8192_tx_ring *ring = NULL;
 
-	ppsc->set_rfpowerstate_inprogress = true;
 	switch (rfpwr_state) {
 	case ERFON:{
 			if ((ppsc->rfpwr_state == ERFOFF) &&
@@ -617,7 +616,6 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 	}
 	if (bresult)
 		ppsc->rfpwr_state = rfpwr_state;
-	ppsc->set_rfpowerstate_inprogress = false;
 	return bresult;
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index 9a3d023..7285290 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -470,7 +470,6 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 	u8 i, queue_id;
 	struct rtl8192_tx_ring *ring = NULL;
 
-	ppsc->set_rfpowerstate_inprogress = true;
 	switch (rfpwr_state) {
 	case ERFON:
 		if ((ppsc->rfpwr_state == ERFOFF) &&
@@ -590,7 +589,6 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 	}
 	if (bresult)
 		ppsc->rfpwr_state = rfpwr_state;
-	ppsc->set_rfpowerstate_inprogress = false;
 	return bresult;
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index 63b45e6..2ad51b0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -546,8 +546,6 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
 	if (rfpwr_state == ppsc->rfpwr_state)
 		return false;
 
-	ppsc->set_rfpowerstate_inprogress = true;
-
 	switch (rfpwr_state) {
 	case ERFON:{
 			if ((ppsc->rfpwr_state == ERFOFF) &&
@@ -659,8 +657,6 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
 	if (bresult)
 		ppsc->rfpwr_state = rfpwr_state;
 
-	ppsc->set_rfpowerstate_inprogress = false;
-
 	return bresult;
 }
 
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 693395e..0321328 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1188,7 +1188,6 @@ struct rtl_efuse {
 
 struct rtl_ps_ctl {
 	bool pwrdomain_protect;
-	bool set_rfpowerstate_inprogress;
 	bool in_powersavemode;
 	bool rfchange_inprogress;
 	bool swrf_processing;
-- 
1.7.4.1


