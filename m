Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758919AbZJIUV7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:21:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/17 v2.6.32 and w-t] iwlwifi: turn off device when not used.
Date: Fri,  9 Oct 2009 13:20:20 -0700
Message-Id: <1255119634-3060-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

In some cases (e.g. when mac80211 calls iwl_mac_stop() for suspend or user
no longer wants device active), device has not been going into low power state
via __iwl_down().  apm_ops.reset() does not put device into low power state;
instead it resets the device, then puts it into a powered-up state ready to be
re-loaded with uCode and re-started.  This has needlessly warmed up user's
laptops and drained batteries.

With current architecture in which mac80211 controls device up/down (including
resetting device after firmware errors), there is no need for apm_ops.reset()
any more; apm_ops.reset() is basically a combination of apm_ops.stop() and
apm_ops.init().

Instead, __iwl_down() now unconditionally places the device into a low-power
state via apm_ops.stop(). Device may be re-started via __iwl_up() calling
apm_ops.init() as soon as it may be needed (e.g. quickly for firmware errors),
but in the meantime, device will stop wasting energy.

Note that, even in this low power state, if driver re-enables interrupts,
the device retains the ability to sense the hardware RF-KILL switch, and
(except for 3945) interrupt the host when it changes.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ++----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8d7bc38..0878b34 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1899,11 +1899,9 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	udelay(5);
 
-	/* FIXME: apm_ops.suspend(priv) */
-	if (exit_pending)
-		priv->cfg->ops->lib->apm_ops.stop(priv);
-	else
-		priv->cfg->ops->lib->apm_ops.reset(priv);
+	/* Stop the device, and put it in low power state */
+	priv->cfg->ops->lib->apm_ops.stop(priv);
+
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c347d66..adf4ebe 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2576,10 +2576,8 @@ static void __iwl3945_down(struct iwl_priv *priv)
 
 	udelay(5);
 
-	if (exit_pending)
-		priv->cfg->ops->lib->apm_ops.stop(priv);
-	else
-		priv->cfg->ops->lib->apm_ops.reset(priv);
+	/* Stop the device, and put it in low power state */
+	priv->cfg->ops->lib->apm_ops.stop(priv);
 
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
-- 
1.5.6.3

