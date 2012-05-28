Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab2E1JyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 05:54:24 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwl4965: claim RSN IBSS support
Date: Mon, 28 May 2012 11:54:11 +0200
Message-Id: <1338198851-21676-1-git-send-email-sgruszka@redhat.com> (sfid-20120528_115430_303437_CE1D5E1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar like other drivers including iwl3945, do not configure group
keys to the hardware (on Ad-Hoc mode) to make IBSS RSN work.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index f2baf94..123471b 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5724,7 +5724,8 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->flags |=
-	    WIPHY_FLAG_CUSTOM_REGULATORY | WIPHY_FLAG_DISABLE_BEACON_HINTS;
+	    WIPHY_FLAG_CUSTOM_REGULATORY | WIPHY_FLAG_DISABLE_BEACON_HINTS |
+	    WIPHY_FLAG_IBSS_RSN;
 
 	/*
 	 * For now, disable PS by default because it affects
@@ -5873,6 +5874,16 @@ il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * To support IBSS RSN, don't program group keys in IBSS, the
+	 * hardware will then not attempt to decrypt the frames.
+	 */
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		D_MAC80211("leave - ad-hoc group key\n");
+		return -EOPNOTSUPP;
+	}
+
 	sta_id = il_sta_id_or_broadcast(il, sta);
 	if (sta_id == IL_INVALID_STATION)
 		return -EINVAL;
-- 
1.7.1

