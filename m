Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:63088 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761952AbXK2Bni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 20:43:38 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2006559wah
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2007 17:43:38 -0800 (PST)
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <yi.zhu@intel.com>, <ipw3945-devel@lists.sourceforge.net>,
	<linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: 
Subject: RE: [PATCH 2/2] [net/wireless/iwlwifi] : iwlwifi 4965 Fix race conditional panic.
Date: Thu, 29 Nov 2007 10:43:16 +0900
Message-ID: <016501c83229$3abdbbe0$9c94fea9@jason> (sfid-20071129_014426_067078_3BDE493B)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
In-Reply-To: 
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cancel_delayed_work_sync has moved into ilw_cancel_deferred_work.
Thanks Zhu Yi.

[net/wireless/iwlwifi] : iwlwifi 4965 Fix race conditional panic.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9918780..2474eba 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8864,6 +8864,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
 	iwl_hw_cancel_deferred_work(priv);
 
+	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_delayed_work(&priv->post_associate);
---

