Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392Ab0JIXwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 19:52:01 -0400
Received: by fxm14 with SMTP id 14so1077588fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 16:51:59 -0700 (PDT)
Message-Id: <47c43586447c4bf1f5887d3cce7bd9d817e99ce8.1286667826.git.chunkeey@googlemail.com>
In-Reply-To: <99eecb7f981fa142324542af768ba8640c7828e1.1286667826.git.chunkeey@googlemail.com>
References: <75b38fb7faac45360bf016016144b15752af07ce.1286667826.git.chunkeey@googlemail.com>
	<99eecb7f981fa142324542af768ba8640c7828e1.1286667826.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 10 Oct 2010 01:15:07 +0200
Subject: [PATCH 3/3] carl9170: A-MPDU frame type filter
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the past, carl9170 has been plagued by mysterious
ghosts.

e.g.:
 wlan4: deauthenticated from 02:04:d8:3c:ac:c1 (Reason: 0)

Apparently, the AP sent us a bogus deauthentication
notification. But upon closer inspection the
"management frame" turned out to be a corrupted
scrap of an unsuccessful A-MPDU.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/rx.c |   42 +++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 256dd42..7164af2 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -576,6 +576,41 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 	}
 }
 
+static bool carl9170_ampdu_check(struct ar9170 *ar, u8 *buf, u8 ms)
+{
+	__le16 fc;
+
+	if ((ms & AR9170_RX_STATUS_MPDU) == AR9170_RX_STATUS_MPDU_SINGLE) {
+		/*
+		 * This frame is not part of an aMPDU.
+		 * Therefore it is not subjected to any
+		 * of the following content restrictions.
+		 */
+		return true;
+	}
+
+	/*
+	 * "802.11n - 7.4a.3 A-MPDU contents" describes in which contexts
+	 * certain frame types can be part of an aMPDU.
+	 *
+	 * In order to keep the processing cost down, I opted for a
+	 * stateless filter solely based on the frame control field.
+	 */
+
+	fc = ((struct ieee80211_hdr *)buf)->frame_control;
+	if (ieee80211_is_data_qos(fc) && ieee80211_is_data_present(fc))
+		return true;
+
+	if (ieee80211_is_ack(fc) || ieee80211_is_back(fc) ||
+	    ieee80211_is_back_req(fc))
+		return true;
+
+	if (ieee80211_is_action(fc))
+		return true;
+
+	return false;
+}
+
 /*
  * If the frame alignment is right (or the kernel has
  * CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS), and there
@@ -594,6 +629,7 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	struct ieee80211_rx_status status;
 	struct sk_buff *skb;
 	int mpdu_len;
+	u8 mac_status;
 
 	if (!IS_STARTED(ar))
 		return;
@@ -604,7 +640,8 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	mpdu_len = len - sizeof(*mac);
 
 	mac = (void *)(buf + mpdu_len);
-	switch (mac->status & AR9170_RX_STATUS_MPDU) {
+	mac_status = mac->status;
+	switch (mac_status & AR9170_RX_STATUS_MPDU) {
 	case AR9170_RX_STATUS_MPDU_FIRST:
 		/* Aggregated MPDUs start with an PLCP header */
 		if (likely(mpdu_len >= sizeof(struct ar9170_rx_head))) {
@@ -693,6 +730,9 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	if (unlikely(carl9170_rx_mac_status(ar, head, mac, &status)))
 		goto drop;
 
+	if (!carl9170_ampdu_check(ar, buf, mac_status))
+		goto drop;
+
 	if (phy)
 		carl9170_rx_phy_status(ar, phy, &status);
 
-- 
1.7.1

