Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab0CJFWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 24/24] iwl3945: check ucode load error code
Date: Tue,  9 Mar 2010 21:21:52 -0800
Message-Id: <1268198512-6572-25-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Check successful completion of BSM loading. Give a chance to
load BSM again. If BSM loading is unsuccessful we should exit
and not initilize NIC. Before this checking even if the BSM loading failed
driver tries to initilize the NIC which should not be the case.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 252df12..2579bbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2697,7 +2697,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
-		priv->cfg->ops->lib->load_ucode(priv);
+		rc = priv->cfg->ops->lib->load_ucode(priv);
 
 		if (rc) {
 			IWL_ERR(priv,
-- 
1.6.3.3

