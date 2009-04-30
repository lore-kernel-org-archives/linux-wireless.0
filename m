Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51754 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZD3UuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 16:50:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>
Subject: [PATCH 2/5] iwlagn: disable PS support for iwlagn
Date: Thu, 30 Apr 2009 13:56:27 -0700
Message-Id: <1241124991-12492-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241124991-12492-2-git-send-email-reinette.chatre@intel.com>
References: <1241124991-12492-1-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Some issues in PS prevent us from supporting it reliably.

When 4965 goes to sleep it stores some data in host DRAM, reads it back
when device wakes up. In 4965 there is a problem that the data is not
correct when ucode starts using it upon wakeup.

For all iwlagn devices there is a problem where command is sent when PS is
enabled. At the moment there is a locking problem with priv->lock not being
held and thus not requesting nic access correctly.

We disable PS until these issues have been resolved.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0f21fc1..1366222 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1298,8 +1298,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_SUPPORTS_PS;
+		    IEEE80211_HW_SPECTRUM_MGMT;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
-- 
1.5.6.3

