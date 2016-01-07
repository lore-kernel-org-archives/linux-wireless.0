Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48375 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbcAGMro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:44 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 01/21] iwlwifi: dvm: fix WoWLAN
Date: Thu,  7 Jan 2016 14:47:21 +0200
Message-Id: <1452170861-10060-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134801_256241_45BDE1D3)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My commit below introduced a mutex in the transport to
prevent concurrent operations. To do so, it added a flag
(is_down) to make sure the transport is in the right state.
This uncoverred an bug that didn't cause any harm until
now: iwldvm calls stop_device and then starts the firmware
without calling start_hw in between. While this flow is
fine from the device configuration point of view (register,
etc...), it is now forbidden by the new is_down flag.
This led to this error to appear:
iwlwifi 0000:05:00.0: Can't start_fw since the HW hasn't been started
and the suspend would fail.

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=109591

CC: <stable@vger.kernel.org> [4.3+]
Reported-by: Bogdan Bogush <bogdan.s.bogush@gmail.com>
Fixes=fa9f3281cbb1 ("iwlwifi: pcie: lock start_hw / start_fw / stop_device")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index bee1c03..fd409ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -1154,6 +1154,9 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 
 	priv->ucode_loaded = false;
 	iwl_trans_stop_device(priv->trans);
+	ret = iwl_trans_start_hw(priv->trans);
+	if (ret)
+		goto out;
 
 	priv->wowlan = true;
 
@@ -1247,6 +1250,7 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 
 	ret = iwlagn_send_patterns(priv, wowlan);
  out:
+	iwl_trans_stop_device(priv->trans);
 	kfree(key_data.rsc_tsc);
 	return ret;
 }
-- 
2.5.0

