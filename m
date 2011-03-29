Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54466 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1C2M2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 08:28:12 -0400
Received: by fxm17 with SMTP id 17so147452fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 05:28:11 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Tue, 29 Mar 2011 13:43:14 +0200
Subject: [PATCH] carl9170: Fix tx aggregation problems with some clients
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <20110329122755.238593403D3@blech.mobile>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some clients seem to rely upon the reception of BlockAckReqs to flush
their rx reorder buffer. In order to fix aggregation for these clients
carl9170 should set IEEE80211_TX_STAT_AMPDU_NO_BACK to generate a
BlockAckReq if the transmission of an AMPDU subframe fails.

This fixes aggregation problems with Intel 5100 Windows STAs (and maybe
others as well).

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/main.c     |    1 +
 drivers/net/wireless/ath/carl9170/tx.c       |    7 +++++++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 0456a76..8c0642b 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -455,6 +455,7 @@ struct carl9170_ba_stats {
 	u8 ampdu_len;
 	u8 ampdu_ack_len;
 	bool clear;
+	bool req;
 };
 
 struct carl9170_sta_info {
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index d26e79c..c10f132 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1355,6 +1355,7 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
 		tid_info = rcu_dereference(sta_info->agg[tid]);
 
 		sta_info->stats[tid].clear = true;
+		sta_info->stats[tid].req = false;
 
 		if (tid_info) {
 			bitmap_zero(tid_info->bitmap, CARL9170_BAW_SIZE);
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 0ef70b6..cb70ed7 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -383,6 +383,7 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 
 	if (sta_info->stats[tid].clear) {
 		sta_info->stats[tid].clear = false;
+		sta_info->stats[tid].req = false;
 		sta_info->stats[tid].ampdu_len = 0;
 		sta_info->stats[tid].ampdu_ack_len = 0;
 	}
@@ -391,10 +392,16 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 	if (txinfo->status.rates[0].count == 1)
 		sta_info->stats[tid].ampdu_ack_len++;
 
+	if (!(txinfo->flags & IEEE80211_TX_STAT_ACK))
+		sta_info->stats[tid].req = true;
+
 	if (super->f.mac_control & cpu_to_le16(AR9170_TX_MAC_IMM_BA)) {
 		super->s.rix = sta_info->stats[tid].ampdu_len;
 		super->s.cnt = sta_info->stats[tid].ampdu_ack_len;
 		txinfo->flags |= IEEE80211_TX_STAT_AMPDU;
+		if (sta_info->stats[tid].req)
+			txinfo->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+
 		sta_info->stats[tid].clear = true;
 	}
 	spin_unlock_bh(&tid_info->lock);
-- 
1.7.4.1

