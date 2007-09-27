Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXI0Dew (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:52 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Ian Schram <ischram@telenet.be>
Subject: [PATCH] iwlwifi: fix add_station to avoid FW error
Date: Thu, 27 Sep 2007 11:27:35 +0800
Message-Id: <11908636732679-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636712746-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
 <11908636712746-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a few Firmware errors reported the most reproducible
http://bughost.org/bugzilla/show_bug.cgi?id=1471

The root cause is rate_n_flags isn't set anymore. This patch fixes
the problem.

Signed-off-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6e46920..a83934f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -464,6 +464,7 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
 	struct iwl_station_entry *station;
 	unsigned long flags_spin;
 	DECLARE_MAC_BUF(mac);
+	u8 rate;
 
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
 	if (is_ap)
@@ -507,6 +508,15 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
 	station->sta.sta.sta_id = index;
 	station->sta.station_flags = 0;
 
+	rate = (priv->phymode == MODE_IEEE80211A) ? IWL_RATE_6M_PLCP :
+				IWL_RATE_1M_PLCP | priv->hw_setting.cck_flag;
+
+	/* Turn on both antennas for the station... */
+	station->sta.rate_n_flags =
+			iwl_hw_set_rate_n_flags(rate, RATE_MCS_ANT_AB_MSK);
+	station->current_rate.rate_n_flags =
+			le16_to_cpu(station->sta.rate_n_flags);
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 	iwl_send_add_station(priv, &station->sta, flags);
 	return index;
-- 
1.5.1
