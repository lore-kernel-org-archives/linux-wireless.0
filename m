Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:3366 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYLEQQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 11:16:24 -0500
Received: by nf-out-0910.google.com with SMTP id d3so38440nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 05 Dec 2008 08:16:21 -0800 (PST)
Message-ID: <eb3ff54b0812050816i5ee503b6o6c107ace966b204c@mail.gmail.com> (sfid-20081205_171628_871484_8A5C15F4)
Date: Fri, 5 Dec 2008 18:16:21 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH] iwlwifi: cleanup (remove pm_state)
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com,
	yi.zhu@intel.com, ipw3945-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches removes unused variable (pm_state) from iwl-dev.h and
from iwl-3945.h. (wireless-testing tree)

Signed-off-by: Rami Rosen <ramirose@gmail.com>


diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 5c2c15e..b7f31d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -906,9 +906,6 @@ struct iwl3945_priv {
 	s8 user_txpower_limit;
 	s8 max_channel_txpower_limit;

-#ifdef CONFIG_PM
-	u32 pm_state[16];
-#endif

 #ifdef CONFIG_IWL3945_DEBUG
 	/* debugging info */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h
b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a19fbb5..2df36e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1003,9 +1003,6 @@ struct iwl_priv {
 	s8 tx_power_user_lmt;
 	s8 tx_power_channel_lmt;

-#ifdef CONFIG_PM
-	u32 pm_state[16];
-#endif

 #ifdef CONFIG_IWLWIFI_DEBUG
 	/* debugging info */
