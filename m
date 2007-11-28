Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ro-out-1112.google.com ([72.14.202.181]:5977 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760687AbXK1KlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 05:41:22 -0500
Received: by ro-out-1112.google.com with SMTP id p4so2403979roc
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2007 02:41:21 -0800 (PST)
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <yi.zhu@intel.com>, <ipw3945-devel@lists.sourceforge.net>,
	<linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 2/2] [net/wireless/iwlwifi] : iwlwifi 4965 Fix race conditional panic.
Date: Wed, 28 Nov 2007 19:41:08 +0900
Message-ID: <00e601c831ab$30475910$9c94fea9@jason> (sfid-20071128_104148_480418_87E70438)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think 4965 may suffer it too, but I could not test.

Thanks
Joonwoo

[net/wireless/iwlwifi] : iwlwifi 4965 Fix race conditional panic.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9918780..a71a572 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -9165,6 +9165,7 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
 	mutex_lock(&priv->mutex);
+	cancel_delayed_work_sync(&priv->init_alive_start);
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 	__iwl_down(priv);
 	mutex_unlock(&priv->mutex);
---

