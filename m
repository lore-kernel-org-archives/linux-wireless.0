Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35371 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751198AbXLZAbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 19:31:36 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH v2] mac80211: Fix rate reporting regression
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	Stefano Brivio <stefano.brivio@polimi.it>
Date: Tue, 25 Dec 2007 19:33:16 -0500
Message-Id: <200712251933.16364.flamingice@sourmilk.net> (sfid-20071226_003140_029234_CE6310BB)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mattias Nissler's "clean up rate selection" patch incorrectly changes
the behavior of txrate setting in sta_info. This patch backs out parts
of the rate selection consolidation in order to fix this issue for now.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

Thanks to Stefano Brivio for pointing out the refcounting issues in the
previous patch.

 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   10 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    7 ++++++-
 net/mac80211/ieee80211_rate.c              |   18 +-----------------
 net/mac80211/rc80211_pid_algo.c            |   20 +++++++++++++++++---
 net/mac80211/rc80211_simple.c              |   18 ++++++++++++++++--
 5 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 022cea0..4b475e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -657,14 +657,20 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
-	u16 rate_mask;
+	u16 fc, rate_mask;
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RATE("enter\n");
 
 	sta = sta_info_get(local, hdr->addr1);
-	if (!sta || !sta->rate_ctrl_priv) {
+
+	/* Send management frames and broadcast/multicast data using lowest
+	 * rate. */
+	fc = le16_to_cpu(hdr->frame_control);
+	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
+	    is_multicast_ether_addr(hdr->addr1) ||
+	    !sta || !sta->rate_ctrl_priv) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
 		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
 		if (sta)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 229b341..5081e28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -2017,6 +2017,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
+	u16 fc;
 	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
 	struct iwl4965_rate_scale_priv *lq;
 
@@ -2024,7 +2025,11 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 
 	sta = sta_info_get(local, hdr->addr1);
 
-	if (!sta || !sta->rate_ctrl_priv) {
+	/* Send management frames and broadcast/multicast data using lowest
+	 * rate. */
+	fc = le16_to_cpu(hdr->frame_control);
+	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
+	    !sta || !sta->rate_ctrl_priv) {
 		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
 		if (sta)
 			sta_info_put(sta);
diff --git a/net/mac80211/ieee80211_rate.c b/net/mac80211/ieee80211_rate.c
index 65fc9ad..dc2ec2e 100644
--- a/net/mac80211/ieee80211_rate.c
+++ b/net/mac80211/ieee80211_rate.c
@@ -164,29 +164,13 @@ void rate_control_get_rate(struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct rate_control_ref *ref = local->rate_ctrl;
-	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sta_info *sta = sta_info_get(local, hdr->addr1);
 	int i;
-	u16 fc;
 
 	memset(sel, 0, sizeof(struct rate_selection));
 
-	/* Send management frames and broadcast/multicast data using lowest
-	 * rate. */
-	fc = le16_to_cpu(hdr->frame_control);
-	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
-	    is_multicast_ether_addr(hdr->addr1))
-		sel->rate = rate_lowest(local, mode, sta);
-
-	/* If a forced rate is in effect, select it. */
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
-		sel->rate = &mode->rates[sdata->bss->force_unicast_rateidx];
-
-	/* If we haven't found the rate yet, ask the rate control algo. */
-	if (!sel->rate)
-		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
+	ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
 
 	/* Select a non-ERP backup rate. */
 	if (!sel->nonerp) {
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index 631e468..078c379 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -307,22 +307,36 @@ static void rate_control_pid_get_rate(void *priv, struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	int rateidx;
+	u16 fc;
 
 	sta = sta_info_get(local, hdr->addr1);
 
-	if (!sta) {
-		sel->rate = rate_lowest(local, mode, NULL);
-		sta_info_put(sta);
+	/* Send management frames and broadcast/multicast data using lowest
+	 * rate. */
+	fc = le16_to_cpu(hdr->frame_control);
+	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
+	    is_multicast_ether_addr(hdr->addr1) || !sta) {
+		sel->rate = rate_lowest(local, mode, sta);
+		if (sta)
+			sta_info_put(sta);
 		return;
 	}
 
+	/* If a forced rate is in effect, select it. */
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
+		sta->txrate = sdata->bss->force_unicast_rateidx;
+
 	rateidx = sta->txrate;
 
 	if (rateidx >= mode->num_rates)
 		rateidx = mode->num_rates - 1;
 
+	sta->last_txrate = rateidx;
+
 	sta_info_put(sta);
 
 	sel->rate = &mode->rates[rateidx];
diff --git a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simple.c
index c1c8b76..9924242 100644
--- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -208,19 +208,33 @@ rate_control_simple_get_rate(void *priv, struct net_device *dev,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sta_info *sta;
 	int rateidx;
+	u16 fc;
 
 	sta = sta_info_get(local, hdr->addr1);
 
-	if (!sta) {
-		sel->rate = rate_lowest(local, mode, NULL);
+	/* Send management frames and broadcast/multicast data using lowest
+	 * rate. */
+	fc = le16_to_cpu(hdr->frame_control);
+	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
+	    is_multicast_ether_addr(hdr->addr1) || !sta) {
+		sel->rate = rate_lowest(local, mode, sta);
+		if (sta)
+			sta_info_put(sta);
 		return;
 	}
 
+	/* If a forced rate is in effect, select it. */
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
+		sta->txrate = sdata->bss->force_unicast_rateidx;
+
 	rateidx = sta->txrate;
 
 	if (rateidx >= mode->num_rates)
 		rateidx = mode->num_rates - 1;
 
+	sta->last_txrate = rateidx;
+
 	sta_info_put(sta);
 
 	sel->rate = &mode->rates[rateidx];


