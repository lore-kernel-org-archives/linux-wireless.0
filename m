Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:43314 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2ANKnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jan 2012 05:43:39 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Bob Copeland <me@bobcopeland.com>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] ath5k: claim support for IBSS RSN
Date: Sat, 14 Jan 2012 11:42:43 +0100
Message-Id: <1326537763-1831-1-git-send-email-ordex@autistici.org> (sfid-20120114_114346_892010_1859D154)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable group keys programming when using IBSS RSN. Keys will be managed using
software. In this way IBSS RSN can correctly work.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 drivers/net/wireless/ath/ath5k/base.c         |    3 +++
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    8 ++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 178a4dd..7ad9dea 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2442,6 +2442,9 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
+	/* SW support for IBSS_RSN is provided by mac80211 */
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+
 	/* both antennas can be configured as RX or TX */
 	hw->wiphy->available_antennas_tx = 0x3;
 	hw->wiphy->available_antennas_rx = 0x3;
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 6ed4c07..af4c7ec 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -483,6 +483,14 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (ath5k_modparam_nohwcrypt)
 		return -EOPNOTSUPP;
 
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
+	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		/* don't program group keys when using IBSS_RSN */
+		return -EOPNOTSUPP;
+	}
+
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-- 
1.7.3.4

