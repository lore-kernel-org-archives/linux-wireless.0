Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:46382 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbaBVUgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 15:36:32 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 6/6] mac80211: move flag IEEE80211_TX_CTL_USE_MINRATE into info->control.flags
Date: Sat, 22 Feb 2014 21:36:20 +0100
Message-Id: <1393101380-1646-7-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140222_213701_187459_A33ABCE9)
In-Reply-To: <1393101380-1646-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1393101380-1646-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag IEEE80211_TX_CTL_USE_MINRATE is only used within the tx path while
ieee80211_tx_info->control is valid. Therefore this patch moves this flag
from info->flags structure into the info->control.flags and renames it to
IEEE80211_TX_CTRL_USE_MINRATE.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/ar5523/ar5523.c |    2 +-
 include/net/mac80211.h                   |    9 +++------
 net/mac80211/mlme.c                      |    2 +-
 net/mac80211/rate.c                      |    4 ++--
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 507d9a9..b83a08b 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -849,7 +849,7 @@ static void ar5523_tx_work_locked(struct ar5523 *ar)
 		else
 			desc->connid = cpu_to_be32(AR5523_ID_BROADCAST);
 
-		if (txi->flags & IEEE80211_TX_CTL_USE_MINRATE)
+		if (txi->control.flags & IEEE80211_TX_CTRL_USE_MINRATE)
 			txqid |= UATH_TXQID_MINRATE;
 
 		desc->txqid = cpu_to_be32(txqid);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 427ef6f..245e1f2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -436,9 +436,6 @@ struct ieee80211_bss_conf {
  *	an SP that mac80211 transmits, it is already set; for driver frames
  *	the driver may set this flag. It is also used to do the same for
  *	PS-Poll responses.
- * @IEEE80211_TX_CTL_USE_MINRATE: This frame will be sent at lowest rate.
- *	This flag is used to send nullfunc frame at minimum rate when
- *	the nullfunc is used for connection monitoring purpose.
  * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
  *	would be fragmented by size (this is optional, only used for
  *	monitor injection).
@@ -472,9 +469,8 @@ enum mac80211_tx_info_flags {
 	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(21),
 	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(22),
 	IEEE80211_TX_STATUS_EOSP		= BIT(23),
-	IEEE80211_TX_CTL_USE_MINRATE		= BIT(24),
-	IEEE80211_TX_CTL_DONTFRAG		= BIT(25),
-	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(26),
+	IEEE80211_TX_CTL_DONTFRAG		= BIT(24),
+	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(25),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		19
@@ -515,6 +511,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_NO_PS_BUFFER          = BIT(4),
 	IEEE80211_TX_CTRL_MORE_FRAMES           = BIT(5),
 	IEEE80211_TX_CTRL_TX_OFFCHAN            = BIT(6),
+	IEEE80211_TX_CTRL_USE_MINRATE           = BIT(7),
 };
 
 /*
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46b62bb..e03d761 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -875,7 +875,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL)
-		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
+		IEEE80211_SKB_CB(skb)->control.flags |= IEEE80211_TX_CTRL_USE_MINRATE;
 
 	ieee80211_tx_skb(sdata, skb);
 }
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 8fdadfd..199e883 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -191,8 +191,8 @@ static bool rc_no_data_or_no_ack_use_min(struct ieee80211_tx_rate_control *txrc)
 
 	fc = hdr->frame_control;
 
-	return (info->flags & (IEEE80211_TX_CTL_NO_ACK |
-			       IEEE80211_TX_CTL_USE_MINRATE)) ||
+	return (info->flags & IEEE80211_TX_CTL_NO_ACK) ||
+	       (info->control.flags & IEEE80211_TX_CTRL_USE_MINRATE) ||
 		!ieee80211_is_data(fc);
 }
 
-- 
1.7.9.5

