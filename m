Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:61536 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYF1IJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 04:09:41 -0400
Received: by nf-out-0910.google.com with SMTP id d3so217486nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 01:09:39 -0700 (PDT)
Message-ID: <f6ca9fed0806280109q312c89c9g2561ac255b704ac9@mail.gmail.com> (sfid-20080628_100946_016688_946C086D)
Date: Sat, 28 Jun 2008 10:09:39 +0200
From: drago01 <drago01@gmail.com>
To: "Linux Wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] iwlwifi: add support for RFKILL_STATE_HARD_BLOCKED
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Zhu, Yi" <yi.zhu@intel.com>, "Dan Williams" <dcbw@redhat.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <f6ca9fed0806280042o21101cb1v56f6ea5f7adbe331@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0806280042o21101cb1v56f6ea5f7adbe331@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The attached patch fixes iwlwifi to set the rfkill state to
RFKILL_STATE_HARD_BLOCKED when the device is disabled by the hardware
rfkill. It also converts all _OFF/_ON states to the new states.

-------
This patch fixes the rfkill states to set RFKILL_STATE_HARD_BLOCKED when the
radio is disabled by a hardware killswitch.
It does not allow setting the sw state while the device is blocked by
a hardware rfkill switch.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h
b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2838093..7f4f598 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -349,10 +349,19 @@ static inline int iwl_is_init(struct iwl_priv *priv)
 	return test_bit(STATUS_INIT, &priv->status);
 }

+static inline int iwl_is_rfkill_sw(struct iwl_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_SW, &priv->status);
+}
+
+static inline int iwl_is_rfkill_hw(struct iwl_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_HW, &priv->status);
+}
+
 static inline int iwl_is_rfkill(struct iwl_priv *priv)
 {
-	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	       test_bit(STATUS_RF_KILL_SW, &priv->status);
+	return iwl_is_rfkill_hw(priv) || iwl_is_rfkill_sw(priv);
 }

 static inline int iwl_is_ready_rf(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index ffefbb4..96d515c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -53,22 +53,23 @@ static int iwl_rfkill_soft_rf_kill(void *data,
enum rfkill_state state)
 	IWL_DEBUG_RF_KILL("we recieved soft RFKILL set to state %d\n", state);
 	mutex_lock(&priv->mutex);

+	if (iwl_is_rfkill_hw(priv)) {
+		err = -EBUSY;
+		goto out;
+	}
+
 	switch (state) {
 	case RFKILL_STATE_UNBLOCKED:
 		iwl_radio_kill_sw_enable_radio(priv);
-		/* if HW rf-kill is set dont allow ON state */
-		if (iwl_is_rfkill(priv))
-			err = -EBUSY;
 		break;
 	case RFKILL_STATE_SOFT_BLOCKED:
 		iwl_radio_kill_sw_disable_radio(priv);
-		if (!iwl_is_rfkill(priv))
-			err = -EBUSY;
 		break;
 	default:
 		IWL_WARNING("we recieved unexpected RFKILL state %d\n", state);
 		break;
 	}
+out:
 	mutex_unlock(&priv->mutex);

 	return err;
@@ -91,7 +92,7 @@ int iwl_rfkill_init(struct iwl_priv *priv)

 	priv->rfkill_mngr.rfkill->name = priv->cfg->name;
 	priv->rfkill_mngr.rfkill->data = priv;
-	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_UNBLOCKED;
 	priv->rfkill_mngr.rfkill->toggle_radio = iwl_rfkill_soft_rf_kill;
 	priv->rfkill_mngr.rfkill->user_claim_unsupported = 1;

@@ -177,9 +178,14 @@ void iwl_rfkill_set_hw_state(struct iwl_priv *priv)
 	if (!priv->rfkill_mngr.rfkill)
 		return;

-	if (!iwl_is_rfkill(priv))
-		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	if (iwl_is_rfkill_hw(priv)) {
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_HARD_BLOCKED;
+		return;
+	}
+
+	if (!iwl_is_rfkill_sw(priv))
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_UNBLOCKED;
 	else
-		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_OFF;
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
 }
 EXPORT_SYMBOL(iwl_rfkill_set_hw_state);
