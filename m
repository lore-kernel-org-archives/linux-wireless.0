Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34708 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1COHDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 03:03:54 -0400
Date: Tue, 15 Mar 2011 10:03:24 +0300
From: Dan Carpenter <error27@gmail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] iwlwifi: remove duplicate initialization in
 __iwl_down()
Message-ID: <20110315070324.GR2008@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We initialize exit_pending twice.  It's the second initialization which
is correct.  That was added in d745d472af "iwlwifi: cancel scan when
down the device".

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 321b18b..7adc60e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2537,7 +2537,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv);
 static void __iwl_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
+	int exit_pending;
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
