Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64491 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab1LGTnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 14:43:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Philipp Dreimann <philipp@dreimann.net>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH V2] rtlwifi: rtl8192ce: rtl8192cu: rtl8192se: rtl8192de: avoid problems because of possible ERFOFF -> ERFSLEEP transition
Date: Wed,  7 Dec 2011 13:43:31 -0600
Message-Id: <1323287011-29987-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111207_204358_189169_C1A39320)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Philipp Dreimann <philipp@dreimann.net>

In drivers rtl8192ce, rtl8192cu, rtl8192se, and rtl8192de, break
statements would allow ppsc->rfpwr_state to be changed to ERFSLEEP
even though the device is actually in ERFOFF.

Signed-off-by: Philipp Dreimann <philipp@dreimann.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
---

V2 - Fix whitespace issues

John,

Please disregard the first submission under the title
"[PATCH] rtl8192{ce,cu,de,se}: avoid problems because
of possible ERFOFF -> ERFSLEEP -> .. transition"

I have not heard anything from Chaoming, but this code
certainly looks wrong. Please apply to 3.2 if possible.

Larry
---

 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index 592a10a..3b585aa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -569,7 +569,7 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		}
 	case ERFSLEEP:{
 			if (ppsc->rfpwr_state == ERFOFF)
-				break;
+				return false;
 			for (queue_id = 0, i = 0;
 			     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
 				ring = &pcipriv->dev.tx_ring[queue_id];
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index 7285290..e49cf22 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -548,7 +548,7 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		break;
 	case ERFSLEEP:
 		if (ppsc->rfpwr_state == ERFOFF)
-			break;
+			return false;
 		for (queue_id = 0, i = 0;
 		     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
 			ring = &pcipriv->dev.tx_ring[queue_id];
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
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
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index f27171a..f10ac1a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -602,7 +602,7 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		}
 	case ERFSLEEP:
 			if (ppsc->rfpwr_state == ERFOFF)
-				break;
+				return false;
 
 			for (queue_id = 0, i = 0;
 			     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
-- 
1.7.7

