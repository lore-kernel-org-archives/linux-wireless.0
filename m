Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.236]:17688 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbYF1NkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 09:40:03 -0400
Received: by hu-out-0506.google.com with SMTP id 28so1919311hub.21
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 06:40:01 -0700 (PDT)
Message-ID: <f6ca9fed0806280640y2a5faed3ne885382afd610a62@mail.gmail.com> (sfid-20080628_154008_769967_909F5752)
Date: Sat, 28 Jun 2008 15:40:01 +0200
From: drago01 <drago01@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: [PATCHv2] iwlwifi: add support for RFKILL_STATE_HARD_BLOCKED
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>, "Dan Williams" <dcbw@redhat.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20080628131439.GA871@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0806280042o21101cb1v56f6ea5f7adbe331@mail.gmail.com>
	 <20080628131439.GA871@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 3:14 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sat, 28 Jun 2008, drago01 wrote:
>> This patch fixes the rfkill states to set RFKILL_STATE_HARD_BLOCKED when the
>> radio is disabled by a hardware killswitch.
>> It does not allow setting the sw state while the device is blocked by
>> a hardware rfkill switch.
>
> It should.  In fact, you should do it in a way that it is possible to
> double-block the radio (i.e. in SW while it is blocked in HW), so that if
> the HW block goes away, the radio remains blocked.
>
> Read the docs and examples again, please.  There even is special code in the
> rfkill_toggle_radio private function to allow for it, we want drivers to be
> able to double-block.

OK, v2 attached it allows double-block.

-----
This patch fixes the rfkill states to set RFKILL_STATE_HARD_BLOCKED when the
radio is disabled by a hardware killswitch.
It does not allow unblocking the sw state while the device is blocked by
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
index ffefbb4..8a47bdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -55,20 +55,20 @@ static int iwl_rfkill_soft_rf_kill(void *data,
enum rfkill_state state)

 	switch (state) {
 	case RFKILL_STATE_UNBLOCKED:
-		iwl_radio_kill_sw_enable_radio(priv);
-		/* if HW rf-kill is set dont allow ON state */
-		if (iwl_is_rfkill(priv))
+		if (iwl_is_rfkill_hw(priv)) {
 			err = -EBUSY;
+			goto out_unlock;
+		}
+		iwl_radio_kill_sw_enable_radio(priv);
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
+out_unlock:
 	mutex_unlock(&priv->mutex);

 	return err;
@@ -91,7 +91,7 @@ int iwl_rfkill_init(struct iwl_priv *priv)

 	priv->rfkill_mngr.rfkill->name = priv->cfg->name;
 	priv->rfkill_mngr.rfkill->data = priv;
-	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_UNBLOCKED;
 	priv->rfkill_mngr.rfkill->toggle_radio = iwl_rfkill_soft_rf_kill;
 	priv->rfkill_mngr.rfkill->user_claim_unsupported = 1;

@@ -177,9 +177,14 @@ void iwl_rfkill_set_hw_state(struct iwl_priv *priv)
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
