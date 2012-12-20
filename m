Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab2LTNcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 08:32:06 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/3] iwlegacy: allow to enable PS
Date: Thu, 20 Dec 2012 14:31:53 +0100
Message-Id: <1356010313-9782-3-git-send-email-sgruszka@redhat.com> (sfid-20121220_143210_445837_A9EE4AA0)
In-Reply-To: <1356010313-9782-1-git-send-email-sgruszka@redhat.com>
References: <1356010313-9782-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Power save support was removed from iwlegacy due to possible firmware
crashes problems it cause. I use to plan first inspect code to find
reason of problems, fix them and then allow to enable PS. But
realistically - code inspection will not happen, so let's do it, and
wait for eventual bug reports.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    5 ++++-
 drivers/net/wireless/iwlegacy/4965-mac.c |    4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 7a6ce09..5e3ac6c 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3551,7 +3551,8 @@ il3945_setup_mac(struct il_priv *il)
 	hw->vif_data_size = sizeof(struct il_vif_priv);
 
 	/* Tell mac80211 our characteristics */
-	hw->flags = IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_SPECTRUM_MGMT;
+	hw->flags = IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_SPECTRUM_MGMT |
+		    IEEE80211_HW_SUPPORTS_PS | IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
 	hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
@@ -3560,6 +3561,8 @@ il3945_setup_mac(struct il_priv *il)
 	    WIPHY_FLAG_CUSTOM_REGULATORY | WIPHY_FLAG_DISABLE_BEACON_HINTS |
 	    WIPHY_FLAG_IBSS_RSN;
 
+	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX_3945;
 	/* we create the 802.11 header and a zero-length SSID element */
 	hw->wiphy->max_scan_ie_len = IL3945_MAX_PROBE_REQUEST - 24 - 2;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index eb68c83..820f748 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5712,8 +5712,8 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	hw->flags =
 	    IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_AMPDU_AGGREGATION |
 	    IEEE80211_HW_NEED_DTIM_PERIOD | IEEE80211_HW_SPECTRUM_MGMT |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
-
+	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | IEEE80211_HW_SUPPORTS_PS |
+	    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 	if (il->cfg->sku & IL_SKU_N)
 		hw->flags |=
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-- 
1.7.1

