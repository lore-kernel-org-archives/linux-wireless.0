Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37447 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1I2LXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 07:23:12 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] mac80211: Ask rate control to send probing frames at lower rate
Date: Thu, 29 Sep 2011 16:53:49 +0530
Message-ID: <1317295429-20709-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110929_132315_942664_17EAA98A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently mac80211 was changed to use nullfunc instead of probe
request for connection monitoring for tx ack status reporting
hardwares. Sometimes in congested network, STA got disconnected
quickly after the association. It was observered that the rate
control was not adopted to environment due to minimal transmission.

As the nullfunc are used for monitoring purpose, these frames should
not be sacrificed for rate control updation. So better to ask to
rate control to send the monitoring null func frames at minimum rate
that could help to retain the connection.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/mlme.c    |    5 +++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1e83afa..62faf6c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -366,6 +366,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_NO_CCK_RATE: This frame will be sent at non CCK rate.
  *	This flag is actually used for management frame especially for P2P
  *	frames not being sent at CCK rate in 2GHz band.
+ * @IEEE80211_TX_CTL_USE_MINRATE: This frame will be sent at lowest rate.
+ *	This flag is used to send nullfunc frame at minimum rate where
+ *	the nullfunc is used for connection monitoring.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -397,6 +400,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
 	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
 	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(27),
+	IEEE80211_TX_CTL_USE_MINRATE		= BIT(28),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cd37a4e..d87a88e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -348,6 +348,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr_3addr *nullfunc;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif);
 	if (!skb)
@@ -358,6 +359,10 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 		nullfunc->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
+			    IEEE80211_STA_CONNECTION_POLL))
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
+
 	ieee80211_tx_skb(sdata, skb);
 }
 
-- 
1.7.6.4

