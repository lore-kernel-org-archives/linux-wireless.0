Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaL3OUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:11 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/33] iwlwifi: dvm: tt: Use setup_timer
Date: Tue, 30 Dec 2014 16:18:57 +0200
Message-Id: <1419949148-24046-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154348_991035_9587364A)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a call to init_timer and accompanying intializations of
the timer's data and function fields to a call to setup_timer.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression t,f,d;
@@

-init_timer(&t);
+setup_timer(&t,f,d);
-t.data = d;
-t.function = f;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tt.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tt.c b/drivers/net/wireless/iwlwifi/dvm/tt.c
index acb981a..c4736c8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.c
@@ -612,15 +612,10 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	memset(tt, 0, sizeof(struct iwl_tt_mgmt));
 
 	tt->state = IWL_TI_0;
-	init_timer(&priv->thermal_throttle.ct_kill_exit_tm);
-	priv->thermal_throttle.ct_kill_exit_tm.data = (unsigned long)priv;
-	priv->thermal_throttle.ct_kill_exit_tm.function =
-		iwl_tt_check_exit_ct_kill;
-	init_timer(&priv->thermal_throttle.ct_kill_waiting_tm);
-	priv->thermal_throttle.ct_kill_waiting_tm.data =
-		(unsigned long)priv;
-	priv->thermal_throttle.ct_kill_waiting_tm.function =
-		iwl_tt_ready_for_ct_kill;
+	setup_timer(&priv->thermal_throttle.ct_kill_exit_tm,
+		    iwl_tt_check_exit_ct_kill, (unsigned long)priv);
+	setup_timer(&priv->thermal_throttle.ct_kill_waiting_tm,
+		    iwl_tt_ready_for_ct_kill, (unsigned long)priv);
 	/* setup deferred ct kill work */
 	INIT_WORK(&priv->tt_work, iwl_bg_tt_work);
 	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);
-- 
1.9.1

