Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab2AWPW1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 10:22:27 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH -stable 3.0] iwlagn: check for SMPS mode
Date: Mon, 23 Jan 2012 16:22:05 +0100
Message-Id: <1327332125-10910-1-git-send-email-sgruszka@redhat.com> (sfid-20120123_162229_454182_65E27132)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit b2ccccdca46273c7b321ecf5041c362cd950da20 upstream.

Check and report WARN only when its invalid.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=42621
https://bugzilla.redhat.com/show_bug.cgi?id=766071

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3bee0f1..9702b16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1759,6 +1759,7 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 	case IEEE80211_SMPS_STATIC:
 	case IEEE80211_SMPS_DYNAMIC:
 		return IWL_NUM_IDLE_CHAINS_SINGLE;
+	case IEEE80211_SMPS_AUTOMATIC:
 	case IEEE80211_SMPS_OFF:
 		return active_cnt;
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index eabbf1a..fd7ab4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -573,6 +573,9 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&priv->mutex);
 
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		goto out;
+
 	if (unlikely(test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 		goto out;
-- 
1.7.1

