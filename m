Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56173 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2GaVTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 17:19:30 -0400
Received: by bkwj10 with SMTP id j10so3488365bkw.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2012 14:19:29 -0700 (PDT)
In-Reply-To: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
References: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Tue, 31 Jul 2012 23:12:16 +0200
Subject: [PATCH] carl9170: report A-MPDU status
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Message-Id: <20120731211916.1FFC1100193@blech.mobile> (sfid-20120731_231934_107766_36BF003B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because the hardware reports whenever an frame
was either at the start, in the middle or at
the end of a A-MPDU, we can easily report the
information for radiotap.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/rx.c       |   15 +++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 376be11..58b73a0 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -425,6 +425,7 @@ struct ar9170 {
 	bool rx_has_plcp;
 	struct sk_buff *rx_failover;
 	int rx_failover_missing;
+	u32 ampdu_ref;
 
 	/* FIFO for collecting outstanding BlockAckRequest */
 	struct list_head bar_list[__AR9170_NUM_TXQ];
diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 25910a1..a57e44e 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -623,7 +623,8 @@ static void carl9170_ba_check(struct ar9170 *ar, void *data, unsigned int len)
 #undef TID_CHECK
 }
 
-static bool carl9170_ampdu_check(struct ar9170 *ar, u8 *buf, u8 ms)
+static bool carl9170_ampdu_check(struct ar9170 *ar, u8 *buf, u8 ms,
+				 struct ieee80211_rx_status *rx_status)
 {
 	__le16 fc;
 
@@ -636,6 +637,9 @@ static bool carl9170_ampdu_check(struct ar9170 *ar, u8 *buf, u8 ms)
 		return true;
 	}
 
+	rx_status->flag |= RX_FLAG_AMPDU_DETAILS | RX_FLAG_AMPDU_LAST_KNOWN;
+	rx_status->ampdu_reference = ar->ampdu_ref;
+
 	/*
 	 * "802.11n - 7.4a.3 A-MPDU contents" describes in which contexts
 	 * certain frame types can be part of an aMPDU.
@@ -684,12 +688,15 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	if (unlikely(len < sizeof(*mac)))
 		goto drop;
 
+	memset(&status, 0, sizeof(status));
+
 	mpdu_len = len - sizeof(*mac);
 
 	mac = (void *)(buf + mpdu_len);
 	mac_status = mac->status;
 	switch (mac_status & AR9170_RX_STATUS_MPDU) {
 	case AR9170_RX_STATUS_MPDU_FIRST:
+		ar->ampdu_ref++;
 		/* Aggregated MPDUs start with an PLCP header */
 		if (likely(mpdu_len >= sizeof(struct ar9170_rx_head))) {
 			head = (void *) buf;
@@ -720,12 +727,13 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 		break;
 
 	case AR9170_RX_STATUS_MPDU_LAST:
+		status.flag |= RX_FLAG_AMPDU_IS_LAST;
+
 		/*
 		 * The last frame of an A-MPDU has an extra tail
 		 * which does contain the phy status of the whole
 		 * aggregate.
 		 */
-
 		if (likely(mpdu_len >= sizeof(struct ar9170_rx_phystatus))) {
 			mpdu_len -= sizeof(struct ar9170_rx_phystatus);
 			phy = (void *)(buf + mpdu_len);
@@ -773,11 +781,10 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	if (unlikely(mpdu_len < (2 + 2 + ETH_ALEN + FCS_LEN)))
 		goto drop;
 
-	memset(&status, 0, sizeof(status));
 	if (unlikely(carl9170_rx_mac_status(ar, head, mac, &status)))
 		goto drop;
 
-	if (!carl9170_ampdu_check(ar, buf, mac_status))
+	if (!carl9170_ampdu_check(ar, buf, mac_status, &status))
 		goto drop;
 
 	if (phy)
-- 
1.7.10.4

