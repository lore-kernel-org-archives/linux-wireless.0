Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.lairdtech.com ([63.123.150.69]:61500 "EHLO
        webmail.lairdtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbcH3Egw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 00:36:52 -0400
From: Eric Bentley <eric.bentley@lairdtech.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] Allow the radio to report 0 dbm txpower without timing out
Date: Tue, 30 Aug 2016 00:30:50 -0400
Message-ID: <1472531450-19115-1-git-send-email-eric.bentley@lairdtech.com> (sfid-20160830_063657_265760_C9FFEC74)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath6kl driver attempts to get the txpower from the radio by first
clearing the existing stored value and then watching the value to become
non-zero. However, this value is in dbm and 0 is a valid value.

APs allow setting client power to values from -127..127. However, The radio
is not capable of setting values less then 0 and so will report txpower
as 0 for both negative and 0 client power.

The 6004 defaults to 63dbm which is then limited by regulatory and
hardware limits with max of 18dbm (6003 max is 16dbm), therefore we can
use values larger then this to be able to determine when the value has
been updated.

Set the value to a nonsensical value (255) and wait for it to change.
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 72e2ec6..b7fe0af 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1449,14 +1449,14 @@ static int ath6kl_cfg80211_get_txpower(struct wiphy *wiphy,
 		return -EIO;
 
 	if (test_bit(CONNECTED, &vif->flags)) {
-		ar->tx_pwr = 0;
+		ar->tx_pwr = 255;
 
 		if (ath6kl_wmi_get_tx_pwr_cmd(ar->wmi, vif->fw_vif_idx) != 0) {
 			ath6kl_err("ath6kl_wmi_get_tx_pwr_cmd failed\n");
 			return -EIO;
 		}
 
-		wait_event_interruptible_timeout(ar->event_wq, ar->tx_pwr != 0,
+		wait_event_interruptible_timeout(ar->event_wq, ar->tx_pwr != 255,
 						 5 * HZ);
 
 		if (signal_pending(current)) {
-- 
2.6.0.GIT
