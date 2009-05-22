Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20191 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970AbZEVVbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 17:31:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH] iwlwifi: fix otp access init
Date: Fri, 22 May 2009 14:37:55 -0700
Message-Id: <1243028275-15833-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243028275-15833-1-git-send-email-reinette.chatre@intel.com>
References: <1243028275-15833-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Polling function returns positive time if polling was needed to
read value. This is still success.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index cefa501..7d7554a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -240,13 +240,11 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 	if (ret < 0)
 		IWL_ERR(priv, "Time out access OTP\n");
 	else {
-		if (!ret) {
-			iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
-					  APMG_PS_CTRL_VAL_RESET_REQ);
-			udelay(5);
-			iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
-					    APMG_PS_CTRL_VAL_RESET_REQ);
-		}
+		iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
+				  APMG_PS_CTRL_VAL_RESET_REQ);
+		udelay(5);
+		iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
+				    APMG_PS_CTRL_VAL_RESET_REQ);
 	}
 	return ret;
 }
-- 
1.5.6.3

