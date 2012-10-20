Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38064 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab2JTSAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2012 14:00:48 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so764913wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2012 11:00:47 -0700 (PDT)
Subject: [PATCH] carl9170: split up carl9170_handle_mpdu
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jlopex@cozybit.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 20 Oct 2012 20:00:41 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201210202000.42173.chunkeey@googlemail.com> (sfid-20121020_200054_393268_A01058A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

carl9170_handle_mpdu is the final part of the
rx path of the driver. It splits the raw data
streams from the device into skb packets and
passes them on to mac80211. As a result of
continuous updates, it grew over the years when
new code was added by the following commits:
	- report A-MPDU status
	- fix HT peer BA session corruption
	- A-MPDU frame type filter
	- ...

This patch splits the routine into two stages.
The first stage only deals with the details
about extracting and verifying the data from
the incoming stream. Whereas the second stage
packs it into skbs and passes it on to mac80211.

Reported-by: Javier Lopez <jlopex@cozybit.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/rx.c |   48 +++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 9cd93f1..887a4ae 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -660,6 +660,38 @@ static bool carl9170_ampdu_check(struct ar9170 *ar, u8 *buf, u8 ms,
 	return false;
 }
 
+static int carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len,
+				struct ieee80211_rx_status *status)
+{
+	struct sk_buff *skb;
+	int err = 0;
+
+	/* (driver) frame trap handler
+	 *
+	 * Because power-saving mode handing has to be implemented by
+	 * the driver/firmware. We have to check each incoming beacon
+	 * from the associated AP, if there's new data for us (either
+	 * broadcast/multicast or unicast) we have to react quickly.
+	 *
+	 * So, if you have you want to add additional frame trap
+	 * handlers, this would be the perfect place!
+	 */
+
+	carl9170_ps_beacon(ar, buf, len);
+
+	carl9170_ba_check(ar, buf, len);
+
+	skb = carl9170_rx_copy_data(buf, len);
+	if (skb) {
+		memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+		ieee80211_rx(ar->hw, skb);
+	} else {
+		err = -ENOMEM;
+	}
+
+	return err;
+}
+
 /*
  * If the frame alignment is right (or the kernel has
  * CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS), and there
@@ -669,14 +701,12 @@ static bool carl9170_ampdu_check(struct ar9170 *ar, u8 *buf, u8 ms,
  * mode, and we need to observe the proper ordering,
  * this is non-trivial.
  */
-
-static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
+static void carl9170_rx_untie_data(struct ar9170 *ar, u8 *buf, int len)
 {
 	struct ar9170_rx_head *head;
 	struct ar9170_rx_macstatus *mac;
 	struct ar9170_rx_phystatus *phy = NULL;
 	struct ieee80211_rx_status status;
-	struct sk_buff *skb;
 	int mpdu_len;
 	u8 mac_status;
 
@@ -788,18 +818,10 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	if (phy)
 		carl9170_rx_phy_status(ar, phy, &status);
 
-	carl9170_ps_beacon(ar, buf, mpdu_len);
-
-	carl9170_ba_check(ar, buf, mpdu_len);
-
-	skb = carl9170_rx_copy_data(buf, mpdu_len);
-	if (!skb)
+	if (carl9170_handle_mpdu(ar, buf, mpdu_len, &status))
 		goto drop;
 
-	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
-	ieee80211_rx(ar->hw, skb);
 	return;
-
 drop:
 	ar->rx_dropped++;
 }
@@ -851,7 +873,7 @@ static void __carl9170_rx(struct ar9170 *ar, u8 *buf, unsigned int len)
 	if (i == 12)
 		carl9170_rx_untie_cmds(ar, buf, len);
 	else
-		carl9170_handle_mpdu(ar, buf, len);
+		carl9170_rx_untie_data(ar, buf, len);
 }
 
 static void carl9170_rx_stream(struct ar9170 *ar, void *buf, unsigned int len)
-- 
1.7.10.4

