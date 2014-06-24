Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:58796 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaFXTwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:47 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so929219wes.14
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:46 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/27] iwlwifi: dvm: add a force_cam module parameter to fully disable power saving
Date: Tue, 24 Jun 2014 22:52:07 +0300
Message-Id: <1403639541-4621-13-git-send-email-egrumbach@gmail.com> (sfid-20140624_215257_580582_C8EA0ECF)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Lutomirski <luto@amacapital.net>

iwldvm stalls are often blamed on power management.  Add an option
to force it all the way off.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/power.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c b/drivers/net/wireless/iwlwifi/dvm/power.c
index f2c1439..760c45c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/iwlwifi/dvm/power.c
@@ -40,6 +40,10 @@
 #include "commands.h"
 #include "power.h"
 
+static bool force_cam;
+module_param(force_cam, bool, 0644);
+MODULE_PARM_DESC(force_cam, "force continuously aware mode (no power saving at all)");
+
 /*
  * Setting power level allows the card to go to sleep when not busy.
  *
@@ -288,6 +292,11 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 	bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
 	int dtimper;
 
+	if (force_cam) {
+		iwl_power_sleep_cam_cmd(priv, cmd);
+		return;
+	}
+
 	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
 
 	if (priv->wowlan)
-- 
1.8.3.2

