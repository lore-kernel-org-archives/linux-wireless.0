Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13247 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0LBQ5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:57:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/5] iwlwifi: check for STATUS_EXIT_PENDING when send RXON command
Date: Thu,  2 Dec 2010 08:51:23 -0800
Message-Id: <1291308684-3279-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

If driver is on the way down, there is no need to send
RXON to uCode, check the condition before continuous the process.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    3 +++
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d39f449..cac9647 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1784,6 +1784,9 @@ int iwl3945_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	int rc = 0;
 	bool new_assoc = !!(staging_rxon->filter_flags & RXON_FILTER_ASSOC_MSK);
 
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return -EINVAL;
+
 	if (!iwl_is_alive(priv))
 		return -1;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 203ee60..4865b82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -130,6 +130,9 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	lockdep_assert_held(&priv->mutex);
 
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return -EINVAL;
+
 	if (!iwl_is_alive(priv))
 		return -EBUSY;
 
-- 
1.7.0.4

