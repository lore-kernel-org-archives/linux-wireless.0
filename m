Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:46328 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZBXCpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:45:39 -0500
Received: by qw-out-2122.google.com with SMTP id 5so1558802qwi.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 18:45:37 -0800 (PST)
Subject: [PATCH] iwl3945: re-add iwl_poll_direct_bit return value check
From: Jason Andryuk <jandryuk@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 21:45:34 -0500
Message-Id: <1235443534.7047.28.camel@rainbow> (sfid-20090224_034541_268526_8763ED20)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-add the iwl_poll_direct_bit return value assignment dropped in Commit
3fdd4102abceb4c99c5091674047b5c61fd3ebba "iwl3945: add apm ops".

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 6ae0df5..0a75053 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1073,7 +1073,7 @@ static int iwl3945_apm_init(struct iwl_priv *priv)
 	* D0U* --> D0A* state */
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-	iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			    CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
 		IWL_DEBUG_INFO(priv, "Failed to init the card\n");

