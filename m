Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38365 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbZHDMoW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 08:44:22 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>, stable@kernel.org
Subject: [PATCH 2.6.30] iwl3945: fix rfkill switch 
Date: Tue,  4 Aug 2009 14:35:50 +0200
Message-Id: <1249389350-4158-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to rfkill and iwlwifi mishmash of SW / HW killswitch representation,
we have race conditions which make unable turn wifi radio on, after enable
and disable again killswitch. I can observe this problem on my laptop
with iwl3945 device.

In rfkill core HW switch and SW switch are separate 'states'. Device can
be only in one of 3 states: RFKILL_STATE_SOFT_BLOCKED, RFKILL_STATE_UNBLOCKED,
RFKILL_STATE_HARD_BLOCKED. Whereas in iwlwifi driver we have separate bits
STATUS_RF_KILL_HW and STATUS_RF_KILL_SW for HW and SW switches - radio can be
turned on, only if both bits are cleared.

In this particular race conditions, radio can not be turned on if in driver
STATUS_RF_KILL_SW bit is set, and rfkill core is in state
RFKILL_STATE_HARD_BLOCKED, because rfkill core is unable to call
rfkill->toggle_radio(). This situation can be entered in case:

- killswitch is turned on
- rfkill core 'see' button change first and move to RFKILL_STATE_SOFT_BLOCKED
  also call ->toggle_radio() and STATE_RF_KILL_SW in driver is set
- iwl3945 get info about button from hardware to set STATUS_RF_KILL_HW bit and
  force rfkill to move to RFKILL_STATE_HARD_BLOCKED
- killsiwtch is turend off
- driver clear STATUS_RF_KILL_HW
- rfkill core is unable to clear STATUS_RF_KILL_SW in driver

Additionally call to rfkill_epo() when STATUS_RF_KILL_HW in driver is set
cause move to the same situation.

In 2.6.31 this problem is fixed due to _total_ rewrite of rfkill subsystem.
This is a quite small fix for 2.6.30.x in iwl3945 driver. We disable
STATUS_RF_KILL_SW bit regardless of HW bit state. Also report to rfkill
subsystem SW switch bit before HW switch bit to move rfkill subsystem
to SOFT_BLOCK rather than HARD_BLOCK.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
I'm not sure if this is good candidate for stable as this is not backport
of upstream commit. Also I did not test this patch with other iwlwifi devices,
only with iwl3945.

 drivers/net/wireless/iwlwifi/iwl-rfkill.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 2ad9faf..d6b6098 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -54,21 +54,28 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 	case RFKILL_STATE_UNBLOCKED:
 		if (iwl_is_rfkill_hw(priv)) {
 			err = -EBUSY;
-			goto out_unlock;
+			/* pass error to rfkill core to make it state HARD
+			 * BLOCKED and disable software kill switch */
 		}
 		iwl_radio_kill_sw_enable_radio(priv);
 		break;
 	case RFKILL_STATE_SOFT_BLOCKED:
 		iwl_radio_kill_sw_disable_radio(priv);
+		/* rfkill->mutex lock is taken */
+		if (priv->rfkill->state == RFKILL_STATE_HARD_BLOCKED) {
+			/* force rfkill core state to be SOFT BLOCKED,
+			 * otherwise core will be unable to disable software
+			 * kill switch */
+			priv->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
+		}
 		break;
 	default:
 		IWL_WARN(priv, "we received unexpected RFKILL state %d\n",
 			state);
 		break;
 	}
-out_unlock:
-	mutex_unlock(&priv->mutex);
 
+	mutex_unlock(&priv->mutex);
 	return err;
 }
 
@@ -132,14 +139,11 @@ void iwl_rfkill_set_hw_state(struct iwl_priv *priv)
 	if (!priv->rfkill)
 		return;
 
-	if (iwl_is_rfkill_hw(priv)) {
+	if (iwl_is_rfkill_sw(priv))
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_SOFT_BLOCKED);
+	else if (iwl_is_rfkill_hw(priv))
 		rfkill_force_state(priv->rfkill, RFKILL_STATE_HARD_BLOCKED);
-		return;
-	}
-
-	if (!iwl_is_rfkill_sw(priv))
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_UNBLOCKED);
 	else
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_SOFT_BLOCKED);
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_UNBLOCKED);
 }
 EXPORT_SYMBOL(iwl_rfkill_set_hw_state);
-- 
1.6.2.5

