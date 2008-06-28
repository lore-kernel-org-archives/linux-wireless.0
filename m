Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.236]:30632 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbYF1NvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 09:51:24 -0400
Received: by hu-out-0506.google.com with SMTP id 28so1926656hub.21
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 06:51:21 -0700 (PDT)
Message-ID: <f6ca9fed0806280651w48cac49ew8fd29b4d8dddaa0c@mail.gmail.com> (sfid-20080628_155127_924135_DEFE02B7)
Date: Sat, 28 Jun 2008 15:51:21 +0200
From: drago01 <drago01@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: [PATCHv2] iwl3945: add support for RFKILL_STATE_HARD_BLOCKED
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, "Zhu, Yi" <yi.zhu@intel.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <20080628131701.GB871@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0806280115o409136a0x20b2109c25330b63@mail.gmail.com>
	 <20080628131701.GB871@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 3:17 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sat, 28 Jun 2008, drago01 wrote:
>> This patch fixes the rfkill states to set RFKILL_STATE_HARD_BLOCKED when the
>> radio is disabled by a hardware killswitch.
>> It does not allow setting the sw state while the device is blocked by
>> a hardware rfkill switch.
>
> See my comment on your other patch, the device should be able to
> double-block.

OK, see attached patch.

--------------
This patch fixes the rfkill states to set RFKILL_STATE_HARD_BLOCKED when the
radio is disabled by a hardware killswitch.
It does not allow unblocking the radio state while the device is blocked by
a hardware rfkill switch.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 43cb8ff..4e5309e 100644
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
@@ -8299,18 +8309,21 @@ static int iwl3945_rfkill_soft_rf_kill(void
*data, enum rfkill_state state)
 	mutex_lock(&priv->mutex);

 	switch (state) {
-	case RFKILL_STATE_ON:
-		iwl3945_radio_kill_sw(priv, 0);
-		/* if HW rf-kill is set dont allow ON state */
-		if (iwl3945_is_rfkill(priv))
+	case RFKILL_STATE_UNBLOCKED:
+		if (iwl3945_is_rfkill_hw(priv)) {
 			err = -EBUSY;
+			goto out_unlock;
+		}
+		iwl3945_radio_kill_sw(priv, 0);
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
+out_unlock:
 	mutex_unlock(&priv->mutex);

 	return err;
@@ -8333,7 +8346,7 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)

 	priv->rfkill_mngr.rfkill->name = priv->cfg->name;
 	priv->rfkill_mngr.rfkill->data = priv;
-	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_UNBLOCKED;
 	priv->rfkill_mngr.rfkill->toggle_radio = iwl3945_rfkill_soft_rf_kill;
 	priv->rfkill_mngr.rfkill->user_claim_unsupported = 1;

@@ -8408,10 +8421,15 @@ void iwl3945_rfkill_set_hw_state(struct
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
