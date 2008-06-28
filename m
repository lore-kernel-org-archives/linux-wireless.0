Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:63671 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYF1IPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 04:15:07 -0400
Received: by nf-out-0910.google.com with SMTP id d3so217731nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 01:15:05 -0700 (PDT)
Message-ID: <f6ca9fed0806280115o409136a0x20b2109c25330b63@mail.gmail.com> (sfid-20080628_101513_005681_F91C2B11)
Date: Sat, 28 Jun 2008 10:15:05 +0200
From: drago01 <drago01@gmail.com>
To: "Linux Wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] iwl3945: add support for RFKILL_STATE_HARD_BLOCKED
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, "Zhu, Yi" <yi.zhu@intel.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes iwl3945 to use the new rfkill states and set the
state to RFKILL_STATE_HARD_BLOCKED when the device is blocked by the
hardware killswitch.
This patch depends on the rfkill subsystem patch for iwl3945.
-------
This patch fixes the rfkill states to set RFKILL_STATE_HARD_BLOCKED when the
radio is disabled by a hardware killswitch.
It does not allow setting the sw state while the device is blocked by
a hardware rfkill switch.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 43cb8ff..f390b96 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -537,10 +537,20 @@ static inline int iwl3945_is_init(struct
iwl3945_priv *priv)
 	return test_bit(STATUS_INIT, &priv->status);
 }

+static inline int iwl3945_is_rfkill_sw(struct iwl3945_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_SW, &priv->status);
+}
+
+static inline int iwl3945_is_rfkill_hw(struct iwl3945_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_HW, &priv->status);
+}
+
 static inline int iwl3945_is_rfkill(struct iwl3945_priv *priv)
 {
-	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	       test_bit(STATUS_RF_KILL_SW, &priv->status);
+	return iwl3945_is_rfkill_hw(priv) ||
+		iwl3945_is_rfkill_sw(priv);
 }

 static inline int iwl3945_is_ready_rf(struct iwl3945_priv *priv)
@@ -8298,19 +8308,23 @@ static int iwl3945_rfkill_soft_rf_kill(void
*data, enum rfkill_state state)
 	IWL_DEBUG_RF_KILL("we recieved soft RFKILL set to state %d\n", state);
 	mutex_lock(&priv->mutex);

+	if (iwl3945_is_rfkill_hw(priv)) {
+		err = -EBUSY;
+		goto out;
+	}
+
 	switch (state) {
-	case RFKILL_STATE_ON:
+	case RFKILL_STATE_UNBLOCKED:
 		iwl3945_radio_kill_sw(priv, 0);
-		/* if HW rf-kill is set dont allow ON state */
-		if (iwl3945_is_rfkill(priv))
-			err = -EBUSY;
 		break;
-	case RFKILL_STATE_OFF:
+	case RFKILL_STATE_SOFT_BLOCKED:
 		iwl3945_radio_kill_sw(priv, 1);
-		if (!iwl3945_is_rfkill(priv))
-			err = -EBUSY;
+		break;
+	default:
+		IWL_WARNING("we recieved unexpected RFKILL state %d\n", state);
 		break;
 	}
+out:
 	mutex_unlock(&priv->mutex);

 	return err;
@@ -8333,7 +8347,7 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)

 	priv->rfkill_mngr.rfkill->name = priv->cfg->name;
 	priv->rfkill_mngr.rfkill->data = priv;
-	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_UNBLOCKED;
 	priv->rfkill_mngr.rfkill->toggle_radio = iwl3945_rfkill_soft_rf_kill;
 	priv->rfkill_mngr.rfkill->user_claim_unsupported = 1;

@@ -8408,10 +8422,15 @@ void iwl3945_rfkill_set_hw_state(struct
iwl3945_priv *priv)
 	if (!priv->rfkill_mngr.rfkill)
 		return;

-	if (!iwl3945_is_rfkill(priv))
-		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	if (iwl3945_is_rfkill_hw(priv)) {
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_HARD_BLOCKED;
+		return;
+	}
+
+	if (!iwl3945_is_rfkill_sw(priv))
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_UNBLOCKED;
 	else
-		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_OFF;
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
 }
 #endif
