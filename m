Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44073 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbXG0J3J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Mohamed Abbas <mabbas@linux.intel.com>
Subject: [PATCH 14/17] iwlwifi: fix channel switch assert
Date: Fri, 27 Jul 2007 17:26:38 +0800
Message-Id: <11855284263627-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284253382-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
 <11855284142478-git-send-email-yi.zhu@intel.com>
 <11855284161716-git-send-email-yi.zhu@intel.com>
 <11855284183313-git-send-email-yi.zhu@intel.com>
 <11855284201330-git-send-email-yi.zhu@intel.com>
 <11855284212390-git-send-email-yi.zhu@intel.com>
 <1185528423816-git-send-email-yi.zhu@intel.com>
 <11855284253382-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the system freeze when do channel switch to radar channel.
If we are switching to a radar channel then we need to set
expect_beacon. Otherwise we get assert from ucode. we still
see assert if we do more than one channel switch currently,
fix will be coming next.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |    7 +++++++
 drivers/net/wireless/iwl-base.c |    8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index fcee3f5..da3e9a7 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -2607,11 +2607,14 @@ int iwl_hw_channel_switch(struct iwl_priv *priv, u8 channel)
 	u8 is_fat = 0;
 	u8 ctrl_chan_high = 0;
 	struct iwl_channel_switch_cmd cmd = { 0 };
+	const struct iwl_channel_info *ch_info;
 
 	band = ((priv->phymode == MODE_IEEE80211B) ||
 		(priv->phymode == MODE_IEEE80211G) ||
 		(priv->phymode == MODE_ATHEROS_TURBOG)) ? 1 : 0;
 
+	ch_info = iwl_get_channel_info(priv, priv->phymode, channel);
+
 	is_fat = is_fat_channel(priv->staging_rxon.flags);
 
 	if (is_fat &&
@@ -2624,6 +2627,10 @@ int iwl_hw_channel_switch(struct iwl_priv *priv, u8 channel)
 	cmd.rxon_flags = priv->active_rxon.flags;
 	cmd.rxon_filter_flags = priv->active_rxon.filter_flags;
 	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
+	if (ch_info)
+		cmd.expect_beacon = is_channel_radar(ch_info);
+	else
+		cmd.expect_beacon = 1;
 
 	rc = iwl4965_fill_txpower_tbl(priv, band, channel, is_fat,
 				      ctrl_chan_high, &cmd.tx_power);
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index a17fbd9..c28a56a 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -7484,8 +7484,12 @@ static int iwl_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	/* if we are switching fron ht to 2.4 clear flags
 	 * from any ht related info since 2.4 does not
 	 * support ht */
-	if (is_channel_bg_band(ch_info) &&
-	    (priv->staging_rxon.channel != conf->channel))
+	if ((priv->staging_rxon.channel != conf->channel)
+#ifdef IEEE80211_CONF_CHANNEL_SWITCH
+	    && !(conf->flags & IEEE80211_CONF_CHANNEL_SWITCH))
+#else
+	    )
+#endif
 		priv->staging_rxon.flags = 0;
 #endif /* CONFIG_IWLWIFI_HT */
 #endif /* IWL == 4965 */
-- 
1.5.2
