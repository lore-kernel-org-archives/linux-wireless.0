Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3834 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbYCYUGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 16:06:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: reinette.chatre@intel.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: do not register bands with no supported channels
Date: Tue, 25 Mar 2008 15:58:40 -0400
Message-Id: <1206475120-10188-1-git-send-email-linville@tuxdriver.com> (sfid-20080325_200650_683523_DAAE3BF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Otherwise, b/g-only devices fail in wiphy_register.  Tested in Fedora
kernels for the last week or so...

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 ++++++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 093b863..4ba9591 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5136,8 +5136,12 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
 	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
-	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->bands[IEEE80211_BAND_2GHZ];
-	priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->bands[IEEE80211_BAND_5GHZ];
+	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			&priv->bands[IEEE80211_BAND_2GHZ];
+	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&priv->bands[IEEE80211_BAND_5GHZ];
 
 	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 44cfd02..9ae3d29 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5001,8 +5001,12 @@ int iwl4965_init_geos(struct iwl_priv *priv)
 	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
-	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->bands[IEEE80211_BAND_2GHZ];
-	priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->bands[IEEE80211_BAND_5GHZ];
+	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			&priv->bands[IEEE80211_BAND_2GHZ];
+	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&priv->bands[IEEE80211_BAND_5GHZ];
 
 	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 
-- 
1.5.3.3

