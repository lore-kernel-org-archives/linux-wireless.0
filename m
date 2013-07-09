Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:36483 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3GITNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 15:13:33 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] mac80211: fix 5/10 MHz tx_status regression
Date: Tue,  9 Jul 2013 21:13:20 +0200
Message-Id: <1373397200-23686-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130709_211336_767071_2ED64E9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sdata may be used uninitialized in ieee80211_tx_status() when adding the
radiotap header. It was added as parameter in "mac80211: select and
adjust bitrates according to channel mode" to find the current control
channel width (5/10/20+ MHz) and is used to report the bitrate
correctly. Fix this by identifing the required shift when cycling
through the interfaces.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
You might want to squash this into the offending patch before sending it
further upstream.
---
 net/mac80211/status.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 690138a..6ad4c14 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -253,10 +253,9 @@ static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
 }
 
 static void
-ieee80211_add_tx_radiotap_header(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_supported_band *sband,
+ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band *sband,
 				 struct sk_buff *skb, int retry_count,
-				 int rtap_len)
+				 int rtap_len, int shift)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -282,7 +281,6 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_sub_if_data *sdata,
 	/* IEEE80211_RADIOTAP_RATE */
 	if (info->status.rates[0].idx >= 0 &&
 	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) {
-		int shift = ieee80211_vif_get_shift(&sdata->vif);
 		u16 rate;
 
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
@@ -430,6 +428,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	bool acked;
 	struct ieee80211_bar *bar;
 	int rtap_len;
+	int shift = 0;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
@@ -464,6 +463,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
 			continue;
 
+		shift = ieee80211_vif_get_shift(&sta->sdata->vif);
+
 		if (info->flags & IEEE80211_TX_STATUS_EOSP)
 			clear_sta_flag(sta, WLAN_STA_SP);
 
@@ -630,8 +631,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		dev_kfree_skb(skb);
 		return;
 	}
-	ieee80211_add_tx_radiotap_header(sdata, sband, skb, retry_count,
-					 rtap_len);
+	ieee80211_add_tx_radiotap_header(sband, skb, retry_count, rtap_len,
+					 shift);
 
 	/* XXX: is this sufficient for BPF? */
 	skb_set_mac_header(skb, 0);
-- 
1.7.10.4

