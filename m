Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57755 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZCREq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/13] iwlwifi: support 11h
Date: Tue, 17 Mar 2009 21:51:47 -0700
Message-Id: <1237351913-19202-8-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054710_035779_AB3C3B4C)
In-Reply-To: <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Set IEEE80211_HW_SPECTRUM_MGMT bit in hw->flags, this tell mac80211
we support spectrum mgmt.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index bcdecb1..4b1298c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1298,6 +1298,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
+		    IEEE80211_HW_SPECTRUM_MGMT |
 		    IEEE80211_HW_SUPPORTS_PS;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 33bdd86..d653ff8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4904,7 +4904,8 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_NOISE_DBM;
+		    IEEE80211_HW_NOISE_DBM |
+		    IEEE80211_HW_SPECTRUM_MGMT;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
-- 
1.5.6.3

