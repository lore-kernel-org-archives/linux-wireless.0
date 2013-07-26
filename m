Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58109 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab3GZI24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/30] iwlwifi: mvm: fix the ACK / CTS kill mask upon RSSI event
Date: Fri, 26 Jul 2013 10:28:26 +0200
Message-Id: <1374827327-3464-10-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102918_380186_1840E041)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If a vif's RSSI gets good enough, we can enable reduced
Tx power. If so, we need to update the ACK / CTS kill mask
accordingly. Since the auditing for the interfaces was bad,
we enabled reduced Tx power, but didn't update the ACK / CTS
kill mask.
This is harmless since the firmware is most likely to
discard this setting anyway, but it is a good practice
to update it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 9195779..3a48cd9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -527,6 +527,8 @@ static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 					lockdep_is_held(&mvm->mutex));
 	mvmsta = (void *)sta->drv_priv;
 
+	data->num_bss_ifaces++;
+
 	/*
 	 * This interface doesn't support reduced Tx power (because of low
 	 * RSSI probably), then set bt_kill_msk to default values.
-- 
1.8.0

