Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18458 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1C3Wyc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 18:54:32 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 15:54:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2.6.38.2] iwlegacy: fix bugs in change_interface
Date: Wed, 30 Mar 2011 15:54:28 -0700
Message-ID: <1301525668-23041-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If change_interface gets invoked during a firmware
restart, it may crash; prevent that from happening
by checking if ctx->vif is assigned.

Additionally, in my initial commit I forgot to set
the vif->p2p variable correctly, so fix that too.

Backport to 2.6.38.2 by Luis.

Cc: stable@kernel.org [2.6.38+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Johannes, I had to backport this for the v2.6.38.2 compat-wireless
release so I'm sending this backport for your review.

 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index efbde1f..3a054db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1867,6 +1867,15 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_lock(&priv->mutex);
 
+	if (!ctx->vif || !iwl_is_ready_rf(priv)) {
+	/*
+	 * Huh? But wait ... this can maybe happen when
+	 * we're in the middle of a firmware restart!
+	 */
+		err = -EBUSY;
+		goto out;
+	}
+
 	interface_modes = ctx->interface_modes | ctx->exclusive_interface_modes;
 
 	if (!(interface_modes & BIT(newtype))) {
@@ -1894,6 +1903,7 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	/* success */
 	iwl_teardown_interface(priv, vif, true);
 	vif->type = newtype;
+	vif->p2p = newp2p;
 	err = iwl_setup_interface(priv, ctx);
 	WARN_ON(err);
 	/*
-- 
1.7.4.15.g7811d

