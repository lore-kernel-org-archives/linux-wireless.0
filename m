Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:48496 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3KSUwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 15:52:22 -0500
Received: by mail-we0-f176.google.com with SMTP id t61so1614214wes.35
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 12:52:21 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/7] iwlwifi: mvm: BT Coex - don't enable MULTI_PRIO_LUT
Date: Tue, 19 Nov 2013 22:52:03 +0200
Message-Id: <1384894326-24676-4-git-send-email-egrumbach@gmail.com> (sfid-20131119_215229_195783_8F4F5485)
In-Reply-To: <528BCEDB.8010703@gmail.com>
References: <528BCEDB.8010703@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This feature isn't supported by the firmware (yet).
Note that settingt he values to BT_CFG_CMD is harmless if
the validity bit is clear - so keep the configuration
values in BT_CFG_CMD, but clear the validity bit until thes
feature is enabled in the firmware.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 5d066cb..b647147 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -391,7 +391,6 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 					    BT_VALID_LUT |
 					    BT_VALID_WIFI_RX_SW_PRIO_BOOST |
 					    BT_VALID_WIFI_TX_SW_PRIO_BOOST |
-					    BT_VALID_MULTI_PRIO_LUT |
 					    BT_VALID_CORUN_LUT_20 |
 					    BT_VALID_CORUN_LUT_40 |
 					    BT_VALID_ANT_ISOLATION |
-- 
1.7.9.5

