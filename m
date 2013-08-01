Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab3HAKEx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 06:04:53 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.11] iwl4965: reset firmware after rfkill off
Date: Thu,  1 Aug 2013 12:07:55 +0200
Message-Id: <1375351675-20181-1-git-send-email-sgruszka@redhat.com> (sfid-20130801_120459_822677_4DCA0EC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using rfkill switch can make firmware unstable, what cause various
Microcode errors and kernel warnings. Reseting firmware just after
rfkill off (radio on) helped with that.

Resolve:
https://bugzilla.redhat.com/show_bug.cgi?id=977053

Reported-and-tested-by: Justin Pearce <whitefox@guardianfox.net>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 10 +++++-----
 drivers/net/wireless/iwlegacy/common.c   |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index f0b7794..f2ed62e 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4460,12 +4460,12 @@ il4965_irq_tasklet(struct il_priv *il)
 		 * is killed. Hence update the killswitch state here. The
 		 * rfkill handler will care about restarting if needed.
 		 */
-		if (!test_bit(S_ALIVE, &il->status)) {
-			if (hw_rf_kill)
-				set_bit(S_RFKILL, &il->status);
-			else
-				clear_bit(S_RFKILL, &il->status);
+		if (hw_rf_kill) {
+			set_bit(S_RFKILL, &il->status);
+		} else {
+			clear_bit(S_RFKILL, &il->status);
 			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
+			il_force_reset(il, true);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 3195aad..b03e22e 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4660,6 +4660,7 @@ il_force_reset(struct il_priv *il, bool external)
 
 	return 0;
 }
+EXPORT_SYMBOL(il_force_reset);
 
 int
 il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-- 
1.7.11.7

