Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026AbZAHSS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:26 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/11] iwl3945: Fix iwl3945_init_drv()
Date: Thu,  8 Jan 2009 10:20:01 -0800
Message-Id: <1231438802-10991-11-git-send-email-reinette.chatre@intel.com> (sfid-20090108_192723_297000_0732D43E)
In-Reply-To: <1231438802-10991-10-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-4-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-5-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-6-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-7-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-8-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-9-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

iwl3945_init_drv() initialises the wrong lock, and sets the wrong power saving
default level.
With this power saving mode, we are losing a lot of frames in Ad-Hoc mode.

This is a bug fix for bug #1873.
( http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1873 )

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0604475..1d69239 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7293,7 +7293,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->ibss_beacon = NULL;
 
 	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->power_data.lock);
+	spin_lock_init(&priv->power_data_39.lock);
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
@@ -7318,7 +7318,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 
 	priv->rates_mask = IWL_RATES_MASK;
 	/* If power management is turned on, default to AC mode */
-	priv->power_mode = IWL_POWER_AC;
+	priv->power_mode = IWL39_POWER_AC;
 	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
 
 	ret = iwl3945_init_channel_map(priv);
-- 
1.5.4.3

