Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:52577 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYFITj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 15:39:59 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1416913ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 12:39:58 -0700 (PDT)
Subject: Re: [PATCHv2 1/8] iwlwifi: minimal compile fix in presence of new
	mac80211 helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213039700.5974.66.camel@brick>
References: <1213039700.5974.66.camel@brick>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 12:39:56 -0700
Message-Id: <1213040396.5974.74.camel@brick> (sfid-20080609_214004_181486_FFF76BBD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This needs to be folded into the patch that adds the new mac80211
frame control helpers.  This is the minimal fix until I finish converting
all the user of the iwl-helpers.h

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   14 ++++++--------
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h |   11 -----------
 4 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0ba6889..834bf32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -464,7 +464,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 		else if (ieee80211_is_probe_response(fc)) {
 			title = "PrbRsp";
 			print_dump = 1;	/* dump frame contents */
-		} else if (ieee80211_is_beacon(fc)) {
+		} else if (ieee80211_is_beacon(header->frame_control)) {
 			title = "Beacon";
 			print_dump = 1;	/* dump frame contents */
 		} else if (ieee80211_is_atim(fc))
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index d8f2b4d..fa0c8e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -804,12 +804,12 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	struct iwl4965_scale_tbl_info tbl_type;
 	struct iwl4965_scale_tbl_info *curr_tbl, *search_tbl;
 	u8 active_index = 0;
-	u16 fc = le16_to_cpu(hdr->frame_control);
 	s32 tpt = 0;
 
 	IWL_DEBUG_RATE_LIMIT("get frame ack response, update rate scale window\n");
 
-	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1))
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
 		return;
 
 	/* This packet was aggregated but doesn't carry rate scale info */
@@ -1678,7 +1678,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	int high_tpt = IWL_INVALID_VALUE;
 	u32 fail_count;
 	s8 scale_action = 0;
-	u16 fc, rate_mask;
+	u16 rate_mask;
 	u8 update_lq = 0;
 	struct iwl4965_lq_sta *lq_sta;
 	struct iwl4965_scale_tbl_info *tbl, *tbl1;
@@ -1695,8 +1695,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	IWL_DEBUG_RATE("rate scale calculate new rate for skb\n");
 
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1)) {
+	if (!ieee80211_is_data(hdr->frame_control) || is_multicast_ether_addr(hdr->addr1)) {
 		/* Send management frames and broadcast/multicast data using
 		 * lowest rate. */
 		/* TODO: this could probably be improved.. */
@@ -2136,7 +2135,6 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
-	u16 fc;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct iwl4965_lq_sta *lq_sta;
 
@@ -2148,8 +2146,8 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !sta->rate_ctrl_priv) {
 		sel->rate_idx = rate_lowest_index(local, sband, sta);
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index aee7014..3902df8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2634,7 +2634,7 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 		else if (ieee80211_is_probe_response(fc)) {
 			title = "PrbRsp";
 			print_dump = 1;	/* dump frame contents */
-		} else if (ieee80211_is_beacon(fc)) {
+		} else if (ieee80211_is_beacon(header->frame_control)) {
 			title = "Beacon";
 			print_dump = 1;	/* dump frame contents */
 		} else if (ieee80211_is_atim(fc))
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index dedefa0..0f261c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -160,11 +160,6 @@ static inline int ieee80211_is_control(u16 fc)
 	return (fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL;
 }
 
-static inline int ieee80211_is_data(u16 fc)
-{
-	return (fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA;
-}
-
 static inline int ieee80211_is_back_request(u16 fc)
 {
 	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
@@ -183,12 +178,6 @@ static inline int ieee80211_is_probe_request(u16 fc)
 	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_REQ);
 }
 
-static inline int ieee80211_is_beacon(u16 fc)
-{
-	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON);
-}
-
 static inline int ieee80211_is_atim(u16 fc)
 {
 	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-- 
1.5.6.rc2.261.ga8fbe



