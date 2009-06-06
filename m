Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47277 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZFFAEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 20:04:02 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net
Subject: [PATCH v2 13/15] iwlwifi: use ieee80211_is_data(fc)
Date: Fri,  5 Jun 2009 20:03:47 -0400
Message-Id: <1244246629-28179-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: ipw3945-devel@lists.sourceforge.net
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    7 +++----
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    5 ++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 5eb538d..bd2f709 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -673,7 +673,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	s8 scale_action = 0;
 	unsigned long flags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	u16 fc;
+	__le16 fc;
 	u16 rate_mask = 0;
 	s8 max_rate_idx = -1;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
@@ -685,9 +685,8 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 		rate_mask = sta->supp_rates[sband->band];
 
 	/* Send management frames and NO_ACK data using lowest rate. */
-	fc = le16_to_cpu(hdr->frame_control);
-	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
-	    info->flags & IEEE80211_TX_CTL_NO_ACK ||
+	fc = hdr->frame_control;
+	if (!ieee80211_is_data(fc) || info->flags & IEEE80211_TX_CTL_NO_ACK ||
 	    !sta || !priv_sta) {
 		IWL_DEBUG_RATE(priv, "leave: No STA priv data to update!\n");
 		if (!rate_mask)
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 2addf73..afa1633 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1044,11 +1044,10 @@ EXPORT_SYMBOL(iwl_rxon_add_station);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 {
 	int sta_id;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 
 	/* If this frame is broadcast or management, use broadcast station id */
-	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
-	    is_multicast_ether_addr(hdr->addr1))
+	if (!ieee80211_is_data(fc) ||  is_multicast_ether_addr(hdr->addr1))
 		return priv->hw_params.bcast_sta_id;
 
 	switch (priv->iw_mode) {
-- 
1.6.0.6

