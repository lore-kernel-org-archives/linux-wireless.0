Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab1EGPqQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 11:46:16 -0400
Date: Sat, 7 May 2011 17:46:21 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-2.6] iwlegacy: fix IBSS mode crashes
Message-ID: <20110507154620.GB2276@redhat.com> (sfid-20110507_174620_498698_28082A29)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not switch to non-IBSS channels when working in IBSS mode,
otherwise there are microcode errors, and after some time system
crashes.

This bug is only observable when software scan is used in IBSS mode,
so should be considered as regression after:

commit 0263aa45293838b514b8af674a03faf040991a90
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Tue Mar 29 11:24:21 2011 +0200

    iwl3945: disable hw scan by default

However IBSS mode check, which this patch add again, was removed by

commit b2f30e8bdd8ef5f3b5a7ef9146509585a15347d3
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Jan 21 07:32:20 2010 -0800

    iwlwifi: remove IBSS channel sanity check

That commit claim that mac80211 will not use non-IBSS channel in IBSS
mode, what definitely is not true. Bug probably should be fixed in
mac80211, but that will require more work, so better to apply that patch
temporally, and provide proper mac80211 fix latter.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=34452

Reported-and-tested-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: stable@kernel.org # 2.6.38.5+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-core.c |    7 +++++++
 drivers/net/wireless/iwlegacy/iwl-dev.h  |    6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index d743373..42df832 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -2151,6 +2151,13 @@ int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed)
 			goto set_ch_out;
 		}
 
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
+		    !iwl_legacy_is_channel_ibss(ch_info)) {
+			IWL_DEBUG_MAC80211(priv, "leave - not IBSS channel\n");
+			ret = -EINVAL;
+			goto set_ch_out;
+		}
+
 		spin_lock_irqsave(&priv->lock, flags);
 
 		for_each_context(priv, ctx) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 2d87dba..be0106c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -1411,6 +1411,12 @@ iwl_legacy_is_channel_passive(const struct iwl_channel_info *ch)
 	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
 }
 
+static inline int
+iwl_legacy_is_channel_ibss(const struct iwl_channel_info *ch)
+{
+	return (ch->flags & EEPROM_CHANNEL_IBSS) ? 1 : 0;
+}
+
 static inline void
 __iwl_legacy_free_pages(struct iwl_priv *priv, struct page *page)
 {
-- 
1.7.1

