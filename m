Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaL3OUN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:13 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/33] iwlwifi: dvm: main: Use setup_timer
Date: Tue, 30 Dec 2014 16:18:58 +0200
Message-Id: <1419949148-24046-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154349_158029_00FD4ACD)
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
 drivers/net/wireless/iwlwifi/dvm/main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index fcdc128..de43dd7 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -997,13 +997,11 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	if (priv->lib->bt_params)
 		iwlagn_bt_setup_deferred_work(priv);
 
-	init_timer(&priv->statistics_periodic);
-	priv->statistics_periodic.data = (unsigned long)priv;
-	priv->statistics_periodic.function = iwl_bg_statistics_periodic;
+	setup_timer(&priv->statistics_periodic, iwl_bg_statistics_periodic,
+		    (unsigned long)priv);
 
-	init_timer(&priv->ucode_trace);
-	priv->ucode_trace.data = (unsigned long)priv;
-	priv->ucode_trace.function = iwl_bg_ucode_trace;
+	setup_timer(&priv->ucode_trace, iwl_bg_ucode_trace,
+		    (unsigned long)priv);
 }
 
 void iwl_cancel_deferred_work(struct iwl_priv *priv)
-- 
1.9.1

