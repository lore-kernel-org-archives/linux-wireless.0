Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXLJRkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:40:05 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 45/48] libertas: remove unreachable code from process_rxed_802_11_packet()
Message-Id: <E1J1kpp-0006nk-HC@shinybook.infradead.org> (sfid-20071210_174009_845735_F543C3B7)
Date: Mon, 10 Dec 2007 10:46:21 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 10 Dec 2007 00:05:37 -0500

The function is only ever called if we're in rtap mode. So the bit in it
which is conditional on rtap mode seems a little superfluous.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/rx.c |   75 +++++++++++++++--------------------
 1 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 58e8311..90a2199 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -355,52 +355,41 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
 
 	/* create the exported radio header */
-	if (priv->monitormode == LBS_MONITOR_OFF) {
-		/* no radio header */
-		/* chop the rxpd */
-		skb_pull(skb, sizeof(struct rxpd));
-	}
 
-	else {
-		/* radiotap header */
-		radiotap_hdr.hdr.it_version = 0;
-		/* XXX must check this value for pad */
-		radiotap_hdr.hdr.it_pad = 0;
-		radiotap_hdr.hdr.it_len = cpu_to_le16 (sizeof(struct rx_radiotap_hdr));
-		radiotap_hdr.hdr.it_present = cpu_to_le32 (RX_RADIOTAP_PRESENT);
-		/* unknown values */
-		radiotap_hdr.flags = 0;
-		radiotap_hdr.chan_freq = 0;
-		radiotap_hdr.chan_flags = 0;
-		radiotap_hdr.antenna = 0;
-		/* known values */
-		radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
-		/* XXX must check no carryout */
-		radiotap_hdr.antsignal = prxpd->snr + prxpd->nf;
-		radiotap_hdr.rx_flags = 0;
-		if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
-			radiotap_hdr.rx_flags |= IEEE80211_RADIOTAP_F_RX_BADFCS;
-		//memset(radiotap_hdr.pad, 0x11, IEEE80211_RADIOTAP_HDRLEN - 18);
-
-		/* chop the rxpd */
-		skb_pull(skb, sizeof(struct rxpd));
-
-		/* add space for the new radio header */
-		if ((skb_headroom(skb) < sizeof(struct rx_radiotap_hdr)) &&
-		    pskb_expand_head(skb, sizeof(struct rx_radiotap_hdr), 0,
-				     GFP_ATOMIC)) {
-			lbs_pr_alert("%s: couldn't pskb_expand_head\n",
-			       __func__);
-		}
-
-		pradiotap_hdr =
-		    (struct rx_radiotap_hdr *)skb_push(skb,
-						     sizeof(struct
-							    rx_radiotap_hdr));
-		memcpy(pradiotap_hdr, &radiotap_hdr,
-		       sizeof(struct rx_radiotap_hdr));
+	/* radiotap header */
+	radiotap_hdr.hdr.it_version = 0;
+	/* XXX must check this value for pad */
+	radiotap_hdr.hdr.it_pad = 0;
+	radiotap_hdr.hdr.it_len = cpu_to_le16 (sizeof(struct rx_radiotap_hdr));
+	radiotap_hdr.hdr.it_present = cpu_to_le32 (RX_RADIOTAP_PRESENT);
+	/* unknown values */
+	radiotap_hdr.flags = 0;
+	radiotap_hdr.chan_freq = 0;
+	radiotap_hdr.chan_flags = 0;
+	radiotap_hdr.antenna = 0;
+	/* known values */
+	radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
+	/* XXX must check no carryout */
+	radiotap_hdr.antsignal = prxpd->snr + prxpd->nf;
+	radiotap_hdr.rx_flags = 0;
+	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
+		radiotap_hdr.rx_flags |= IEEE80211_RADIOTAP_F_RX_BADFCS;
+	//memset(radiotap_hdr.pad, 0x11, IEEE80211_RADIOTAP_HDRLEN - 18);
+
+	/* chop the rxpd */
+	skb_pull(skb, sizeof(struct rxpd));
+
+	/* add space for the new radio header */
+	if ((skb_headroom(skb) < sizeof(struct rx_radiotap_hdr)) &&
+	    pskb_expand_head(skb, sizeof(struct rx_radiotap_hdr), 0,
+			     GFP_ATOMIC)) {
+		lbs_pr_alert("%s: couldn't pskb_expand_head\n",
+			     __func__);
 	}
 
+	pradiotap_hdr = (void *)skb_push(skb, sizeof(struct rx_radiotap_hdr));
+	memcpy(pradiotap_hdr, &radiotap_hdr, sizeof(struct rx_radiotap_hdr));
+
 	/* Take the data rate from the rxpd structure
 	 * only if the rate is auto
 	 */
-- 
1.5.3.4

