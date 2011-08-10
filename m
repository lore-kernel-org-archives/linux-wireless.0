Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54844 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab1HJVcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 17:32:54 -0400
Date: Thu, 11 Aug 2011 00:32:49 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Use cfg80211_inform_bss instead of
 cfg80211_inform_bss_frame
Message-ID: <20110810213249.GA7328@jouni.qca.qualcomm.com> (sfid-20110810_233258_105609_8C298492)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point in generating a bogus Beacon frame for
cfg80211_inform_bss_frame when cfg80211_inform_bss can be used
instead.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   44 +++++++++++-----------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 14559ff..201398e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -723,8 +723,6 @@ static inline bool is_ch_11a(u16 ch)
 /* struct ath6kl_node_table::nt_nodelock is locked when calling this */
 void ath6kl_cfg80211_scan_node(struct wiphy *wiphy, struct bss *ni)
 {
-	u16 size;
-	unsigned char *ieeemgmtbuf = NULL;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_channel *channel;
 	struct ieee80211_supported_band *band;
@@ -741,37 +739,29 @@ void ath6kl_cfg80211_scan_node(struct wiphy *wiphy, struct bss *ni)
 	else
 		band = wiphy->bands[IEEE80211_BAND_2GHZ]; /* 11b */
 
-	size = ni->ni_framelen + offsetof(struct ieee80211_mgmt, u);
-	ieeemgmtbuf = kmalloc(size, GFP_ATOMIC);
-	if (!ieeemgmtbuf) {
-		ath6kl_err("ieee mgmt buf alloc error\n");
-		return;
-	}
-
-	/*
-	 * TODO: Update target to include 802.11 mac header while sending
-	 * bss info. Target removes 802.11 mac header while sending the bss
-	 * info to host, cfg80211 needs it, for time being just filling the
-	 * da, sa and bssid fields alone.
-	 */
-	mgmt = (struct ieee80211_mgmt *)ieeemgmtbuf;
-	memset(mgmt->da, 0xff, ETH_ALEN);	/*broadcast addr */
-	memcpy(mgmt->sa, ni->ni_macaddr, ETH_ALEN);
-	memcpy(mgmt->bssid, ni->ni_macaddr, ETH_ALEN);
-	memcpy(ieeemgmtbuf + offsetof(struct ieee80211_mgmt, u),
-	       ni->ni_buf, ni->ni_framelen);
-
 	freq = cie->ie_chan;
 	channel = ieee80211_get_channel(wiphy, freq);
 	signal = ni->ni_snr * 100;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 		   "%s: bssid %pM ch %d freq %d size %d\n", __func__,
-		   mgmt->bssid, channel->hw_value, freq, size);
-	cfg80211_inform_bss_frame(wiphy, channel, mgmt,
-				  size, signal, GFP_ATOMIC);
-
-	kfree(ieeemgmtbuf);
+		   ni->ni_macaddr, channel->hw_value, freq, ni->ni_framelen);
+	/*
+	 * Both Beacon and Probe Response frames have same payload structure,
+	 * so it is fine to share the parser for both.
+	 */
+	if (ni->ni_framelen < 8 + 2 + 2)
+		return;
+	mgmt = (struct ieee80211_mgmt *) (ni->ni_buf -
+					  offsetof(struct ieee80211_mgmt, u));
+	cfg80211_inform_bss(wiphy, channel, ni->ni_macaddr,
+			    le64_to_cpu(mgmt->u.beacon.timestamp),
+			    le16_to_cpu(mgmt->u.beacon.capab_info),
+			    le16_to_cpu(mgmt->u.beacon.beacon_int),
+			    mgmt->u.beacon.variable,
+			    ni->ni_buf + ni->ni_framelen -
+			    mgmt->u.beacon.variable,
+			    signal, GFP_ATOMIC);
 }
 
 static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
