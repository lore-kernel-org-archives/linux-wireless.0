Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32658 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101AbYF3J1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 32/33] iwl3945: remove RFKILL_STATE_HARD_BLOCKED warnings
Date: Mon, 30 Jun 2008 17:23:32 +0800
Message-Id: <1214817813-17639-33-git-send-email-yi.zhu@intel.com> (sfid-20080630_113812_969050_E8E225AE)
In-Reply-To: <1214817813-17639-32-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-26-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-28-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-29-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-31-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-32-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the compile warning of "enumeration value
=E2=80=98RFKILL_STATE_HARD_BLOCKED=E2=80=99 not handled in switch".

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/=
wireless/iwlwifi/iwl3945-base.c
index 73942a4..3bc2644 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8287,17 +8287,20 @@ static int iwl3945_rfkill_soft_rf_kill(void *da=
ta, enum rfkill_state state)
 	mutex_lock(&priv->mutex);
=20
 	switch (state) {
-	case RFKILL_STATE_ON:
+	case RFKILL_STATE_UNBLOCKED:
 		iwl3945_radio_kill_sw(priv, 0);
 		/* if HW rf-kill is set dont allow ON state */
 		if (iwl3945_is_rfkill(priv))
 			err =3D -EBUSY;
 		break;
-	case RFKILL_STATE_OFF:
+	case RFKILL_STATE_SOFT_BLOCKED:
 		iwl3945_radio_kill_sw(priv, 1);
 		if (!iwl3945_is_rfkill(priv))
 			err =3D -EBUSY;
 		break;
+	default:
+		IWL_WARNING("we recieved unexpected RFKILL state %d\n", state);
+		break;
 	}
 	mutex_unlock(&priv->mutex);
=20
--=20
1.5.3.6

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
