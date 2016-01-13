Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34740 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbcAMOAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 09:00:00 -0500
Received: by mail-lb0-f180.google.com with SMTP id cl12so73599700lbc.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2016 05:59:58 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/5] ath10k: rename some HTT events
Date: Wed, 13 Jan 2016 15:01:04 +0100
Message-Id: <1452693668-30030-2-git-send-email-michal.kazior@tieto.com> (sfid-20160113_150008_053500_29A02142)
In-Reply-To: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com>
References: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New names make a bit more sense.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.c    | 8 ++++----
 drivers/net/wireless/ath/ath10k/htt.h    | 8 ++++----
 drivers/net/wireless/ath/ath10k/htt_rx.c | 4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 3e6ba63dfdff..7561f22f10f9 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -131,12 +131,12 @@ static const enum htt_t2h_msg_type htt_10_4_t2h_msg_types[] = {
 	[HTT_10_4_T2H_MSG_TYPE_AGGR_CONF] = HTT_T2H_MSG_TYPE_AGGR_CONF,
 	[HTT_10_4_T2H_MSG_TYPE_TX_FETCH_IND] =
 				HTT_T2H_MSG_TYPE_TX_FETCH_IND,
-	[HTT_10_4_T2H_MSG_TYPE_TX_FETCH_CONF] =
-				HTT_T2H_MSG_TYPE_TX_FETCH_CONF,
+	[HTT_10_4_T2H_MSG_TYPE_TX_FETCH_CONFIRM] =
+				HTT_T2H_MSG_TYPE_TX_FETCH_CONFIRM,
 	[HTT_10_4_T2H_MSG_TYPE_STATS_NOUPLOAD] =
 				HTT_T2H_MSG_TYPE_STATS_NOUPLOAD,
-	[HTT_10_4_T2H_MSG_TYPE_TX_LOW_LATENCY_IND] =
-				HTT_T2H_MSG_TYPE_TX_LOW_LATENCY_IND,
+	[HTT_10_4_T2H_MSG_TYPE_TX_MODE_SWITCH_IND] =
+				HTT_T2H_MSG_TYPE_TX_MODE_SWITCH_IND,
 };
 
 int ath10k_htt_connect(struct ath10k_htt *htt)
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 47ca048feaf0..edd3b9070de9 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -413,10 +413,10 @@ enum htt_10_4_t2h_msg_type {
 	HTT_10_4_T2H_MSG_TYPE_EN_STATS               = 0x14,
 	HTT_10_4_T2H_MSG_TYPE_AGGR_CONF              = 0x15,
 	HTT_10_4_T2H_MSG_TYPE_TX_FETCH_IND           = 0x16,
-	HTT_10_4_T2H_MSG_TYPE_TX_FETCH_CONF          = 0x17,
+	HTT_10_4_T2H_MSG_TYPE_TX_FETCH_CONFIRM       = 0x17,
 	HTT_10_4_T2H_MSG_TYPE_STATS_NOUPLOAD         = 0x18,
 	/* 0x19 to 0x2f are reserved */
-	HTT_10_4_T2H_MSG_TYPE_TX_LOW_LATENCY_IND     = 0x30,
+	HTT_10_4_T2H_MSG_TYPE_TX_MODE_SWITCH_IND     = 0x30,
 	/* keep this last */
 	HTT_10_4_T2H_NUM_MSGS
 };
@@ -449,8 +449,8 @@ enum htt_t2h_msg_type {
 	HTT_T2H_MSG_TYPE_TEST,
 	HTT_T2H_MSG_TYPE_EN_STATS,
 	HTT_T2H_MSG_TYPE_TX_FETCH_IND,
-	HTT_T2H_MSG_TYPE_TX_FETCH_CONF,
-	HTT_T2H_MSG_TYPE_TX_LOW_LATENCY_IND,
+	HTT_T2H_MSG_TYPE_TX_FETCH_CONFIRM,
+	HTT_T2H_MSG_TYPE_TX_MODE_SWITCH_IND,
 	/* keep this last */
 	HTT_T2H_NUM_MSGS
 };
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 91afa3ae414c..d923f64e4f42 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2125,8 +2125,8 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case HTT_T2H_MSG_TYPE_EN_STATS:
 	case HTT_T2H_MSG_TYPE_TX_FETCH_IND:
-	case HTT_T2H_MSG_TYPE_TX_FETCH_CONF:
-	case HTT_T2H_MSG_TYPE_TX_LOW_LATENCY_IND:
+	case HTT_T2H_MSG_TYPE_TX_FETCH_CONFIRM:
+	case HTT_T2H_MSG_TYPE_TX_MODE_SWITCH_IND:
 	default:
 		ath10k_warn(ar, "htt event (%d) not handled\n",
 			    resp->hdr.msg_type);
-- 
2.1.4

