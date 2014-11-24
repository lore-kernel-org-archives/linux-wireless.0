Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:45957 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaKXOgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:12 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so12522884wgh.12
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:11 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 45/75] iwlwifi: mvm: disconnect TDLS peers on reconfig
Date: Mon, 24 Nov 2014 16:34:21 +0200
Message-Id: <1416839691-28533-45-git-send-email-egrumbach@gmail.com> (sfid-20141124_153624_989518_C601827B)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When TDLS peers are present the FW will send packets on a dedicated
TID vs. the peer when performing TDLS channel-switches. The driver
configures the TID on connection to the peer and the FW is responsible
for maintaining the state of QoS seqno and PN/IV for encryption.

If the FW asserts, the driver cannot correctly reconfigure the starting
seqno/PN to the reloaded FW, thus forcing us to reconnect the peer.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 801abcf..3883a86 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -948,6 +948,12 @@ static void iwl_mvm_restart_complete(struct iwl_mvm *mvm)
 	/* allow transport/FW low power modes */
 	iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
+	/*
+	 * If we have TDLS peers, remove them. We don't know the last seqno/PN
+	 * of packets the FW sent out, so we must reconnect.
+	 */
+	iwl_mvm_teardown_tdls_peers(mvm);
+
 	mutex_unlock(&mvm->mutex);
 }
 
-- 
1.9.1

