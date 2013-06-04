Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43158 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab3FDKPr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:15:47 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: add a tx control flag to indicate PS-Poll/uAPSD response
Date: Tue,  4 Jun 2013 12:15:42 +0200
Message-Id: <1370340942-34407-1-git-send-email-nbd@openwrt.org> (sfid-20130604_121549_627780_E16E91BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h  | 3 +++
 net/mac80211/sta_info.c | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1f0014b..cb37f82 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -460,6 +460,8 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
  *	would be fragmented by size (this is optional, only used for
  *	monitor injection).
+ * @IEEE80211_TX_CTL_PS_RESPONSE: This frame is a response to a poll
+ *	frame (PS-Poll or uAPSD).
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -495,6 +497,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STATUS_EOSP		= BIT(28),
 	IEEE80211_TX_CTL_USE_MINRATE		= BIT(29),
 	IEEE80211_TX_CTL_DONTFRAG		= BIT(30),
+	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(31),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a04c5671..b429798 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1132,6 +1132,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	 * ends the poll/service period.
 	 */
 	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
+		       IEEE80211_TX_CTL_PS_RESPONSE |
 		       IEEE80211_TX_STATUS_EOSP |
 		       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
@@ -1269,7 +1270,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			 * STA may still remain is PS mode after this frame
 			 * exchange.
 			 */
-			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
+				       IEEE80211_TX_CTL_PS_RESPONSE;
 
 			/*
 			 * Use MoreData flag to indicate whether there are
-- 
1.8.0.2

