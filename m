Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33209 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3KSUwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 15:52:23 -0500
Received: by mail-wi0-f170.google.com with SMTP id f4so7199566wiw.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 12:52:22 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/7] iwlwifi: mvm: BT Coex fix another NULL pointer dereference
Date: Tue, 19 Nov 2013 22:52:04 +0200
Message-Id: <1384894326-24676-5-git-send-email-egrumbach@gmail.com> (sfid-20131119_215230_048017_169184F4)
In-Reply-To: <528BCEDB.8010703@gmail.com>
References: <528BCEDB.8010703@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch is very similar to a previous fix: 22cba0c0852f

When we disassociate, mac80211 removes the station and
then, it sets the bss it unsets the assoc bool in bss_info.

Since the firwmware wants it the opposite (first set the
MAC context as unassoc, and only then, remove the STA of
the API), we have a small period of time in which the STA
in firmware doesn't have a valid ieee80211_sta pointer.
During that time, iwl_mvm_vif->ap_sta_id, is still set
to the STA in firmware that represent the AP.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index b647147..75b72a9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -841,6 +841,11 @@ static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 
 	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
 					lockdep_is_held(&mvm->mutex));
+
+	/* This can happen if the station has been removed right now */
+	if (IS_ERR_OR_NULL(sta))
+		return;
+
 	mvmsta = (void *)sta->drv_priv;
 
 	data->num_bss_ifaces++;
-- 
1.7.9.5

