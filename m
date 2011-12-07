Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60225 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab1LGEPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 23:15:16 -0500
Received: by ghbz2 with SMTP id z2so133601ghb.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 20:15:15 -0800 (PST)
Message-ID: <4EDEE850.4040508@lwfinger.net> (sfid-20111207_051521_738421_A0F7B5BA)
Date: Tue, 06 Dec 2011 22:15:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Philipp Dreimann <philipp@dreimann.net>
Subject: [PATCH] rtl8192{ce,cu,de,se}: avoid problems because of possible
 ERFOFF -> ERFSLEEP -> .. transition
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Philipp Dreimann <philipp@dreimann.net>

In drivers rtl8192ce, rtl8192cu, rtl8192se, and rtl8192de, missing break 
statements would allow ppsc->rfpwr_state to be changed to ERFSLEEP even though 
the device is actually in ERFOFF.

Signed-off-by: Philipp Dreimann <philipp@dreimann.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

John,

I have not heard anything from Chaoming, but this code certainly looks wrong. 
Please apply to 3.2 if possible.

Larry

---
  drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |    3 ++-
  drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    3 ++-
  drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    2 +-
  drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    3 ++-
  4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c 
b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index 592a10a..7f6b933 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -569,7 +569,8 @@ static bool _rtl92ce_phy_set_rf_power_state(struct 
ieee80211_hw *hw,
  		}
  	case ERFSLEEP:{
  			if (ppsc->rfpwr_state == ERFOFF)
-				break;
+				return false;
+				
  			for (queue_id = 0, i = 0;
  			     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
  				ring = &pcipriv->dev.tx_ring[queue_id];
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c 
b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index 7285290..33ada66 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -548,7 +548,8 @@ static bool _rtl92cu_phy_set_rf_power_state(struct 
ieee80211_hw *hw,
  		break;
  	case ERFSLEEP:
  		if (ppsc->rfpwr_state == ERFOFF)
-			break;
+			return false;
+			
  		for (queue_id = 0, i = 0;
  		     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
  			ring = &pcipriv->dev.tx_ring[queue_id];
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c 
b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
index 3ac7af1..0883349 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -3374,7 +3374,7 @@ bool rtl92d_phy_set_rf_power_state(struct ieee80211_hw *hw,
  		break;
  	case ERFSLEEP:
  		if (ppsc->rfpwr_state == ERFOFF)
-			break;
+			return false;
   		for (queue_id = 0, i = 0;
  		     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c 
b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index f27171a..539172e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -602,7 +602,8 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
  		}
  	case ERFSLEEP:
  			if (ppsc->rfpwr_state == ERFOFF)
-				break;
+				return false;
+				
   			for (queue_id = 0, i = 0;
  			     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
-- 
1.7.7.3


