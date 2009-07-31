Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZGaBh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 21:37:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: remove usage of orig_flags
Date: Thu, 30 Jul 2009 21:37:27 -0400
Message-Id: <1249004247-20780-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a private flag, internal to cfg80211. cfg80211
will set orig_* stuff internally upon wiphy registration,
drivers do not need to muck with it.

Cc: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 071c05b..a31bdc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -548,9 +548,6 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
 		}
 
-		/* Save flags for reg domain usage */
-		geo_ch->orig_flags = geo_ch->flags;
-
 		IWL_DEBUG_INFO(priv, "Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
 				ch->channel, geo_ch->center_freq,
 				is_channel_a_band(ch) ?  "5.2" : "2.4",
-- 
1.6.3.3

