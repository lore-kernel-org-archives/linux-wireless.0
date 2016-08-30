Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.lairdtech.com ([63.123.150.69]:49653 "EHLO
        webmail.lairdtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751952AbcH3GS3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 02:18:29 -0400
From: Eric Bentley <eric.bentley@lairdtech.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Allow the radio to report 0 dbm txpower without timing out
Date: Tue, 30 Aug 2016 02:16:19 -0400
Message-ID: <1472537779-3723-1-git-send-email-eric.bentley@lairdtech.com> (sfid-20160830_081834_051860_A70210A6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath6kl driver attempts to get the txpower value from the radio by first
clearing the existing stored value and then watching the value to become
non-zero.

APs allow setting client power to values from -127..127, but this radio
is not capable of setting values less then 0 and so will report txpower
as 0dbm for both negative and 0 client power values.

When the radio has txpower set to 0dbm txpower (equivalent to 1mw) the
ath6kl_cfg80211_get_txpower() function will remain in the
wait_event_interruptible_timeout() loop waiting for the value to be
non-zero, and will eventually timeout. This results in a 5 second delay in
response. However, the correct value of zero is eventually returned.

The 6004 defaults to 63dbm which is then limited by regulatory and
hardware limits with max of 18dbm (6003 max is 16dbm), therefore we can
use values larger then these to be able to determine when the value has
been updated.

To correct the issue, set the value to a nonsensical value (255) and wait
for it to change to the valid value.

--
Tested on both 6003 and 6004 based radios.  Return value of zero is
correctly returned in an expected amount of time (similar to when
returning non-zero values) when AP client power is set to both 0 and
negative values.

Signed-off-by: Eric Bentley <eric.bentley@lairdtech.com>
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
