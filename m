Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab1JLISG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:18:06 -0400
Date: Wed, 12 Oct 2011 10:16:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlagn: fix priv->cfg->ht_params NULL pointer dereference
Message-ID: <20111012081634.GA2675@redhat.com> (sfid-20111012_101810_838663_5DCDFEF2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix regression introduced by commit:

commit 15b3f3b006b42a678523cad989bfd60b76bf4403
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Fri Jun 3 07:54:13 2011 -0700

    iwlagn: set smps mode after assoc for 1000 device

Also remove unneeded brackets on the way.

Address:
https://bugzilla.redhat.com/show_bug.cgi?id=744155

If fix will not get 3.1 release, it should be applied in 3.1 stable.

Cc: stable@kernel.org # 3.1+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index ca632f9..5004342 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -296,8 +296,8 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 		return ret;
 	}
 
-	if ((ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION) &&
-	    priv->cfg->ht_params->smps_mode)
+	if (ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION &&
+	    priv->cfg->ht_params && priv->cfg->ht_params->smps_mode)
 		ieee80211_request_smps(ctx->vif,
 				       priv->cfg->ht_params->smps_mode);
 
-- 
1.7.1

