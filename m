Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:5493 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbYHYVGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 17:06:17 -0400
Received: by wx-out-0506.google.com with SMTP id h29so1073701wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 14:06:16 -0700 (PDT)
Subject: [PATCH] libertas: use the common frame control functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 14:06:32 -0700
Message-Id: <1219698392.3127.3.camel@brick> (sfid-20080825_230620_947113_6DF5608C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
I noticed some new sparse warnings in linux-next from this file,
instead of silencing the warnings by making fc_le a __le16, I decided
to move this function over to the common helpers.

It may be worth a common helper somewhere to check the packet alignment
rather than have each driver hand-roll alignment checking.

 drivers/net/wireless/libertas_tf/main.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 2c1d680..c948021 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -477,9 +477,9 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 {
 	struct ieee80211_rx_status stats;
 	struct rxpd *prxpd;
-	bool is_qos, is_4addr, is_amsdu, need_padding;
+	int need_padding;
 	unsigned int flags;
-	u16 fc, fc_le;
+	struct ieee80211_hdr *hdr;
 
 	prxpd = (struct rxpd *) skb->data;
 
@@ -497,19 +497,15 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 	stats.rate_idx = prxpd->rx_rate;
 	skb_pull(skb, sizeof(struct rxpd));
 
-	fc_le = *((__le16 *) skb->data);
-	fc = le16_to_cpu(fc_le);
+	hdr = (struct ieee80211_hdr *)skb->data;
 	flags = le32_to_cpu(*(__le32 *)(skb->data + 4));
 
-	is_qos = ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-		 (fc & IEEE80211_STYPE_QOS_DATA);
-	is_4addr = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
-		   (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-	is_amsdu =  ((fc & 0x8C) == 0x88) &&
-		    (*(skb->data + ieee80211_hdrlen(fc_le) - QOS_CONTROL_LEN)
-		     & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT);
+	need_padding = ieee80211_is_data_qos(hdr->frame_control);
+	need_padding ^= ieee80211_has_a4(hdr->frame_control);
+	need_padding ^= ieee80211_is_data_qos(hdr->frame_control) &&
+			(*ieee80211_get_qos_ctl(hdr) &
+			 IEEE80211_QOS_CONTROL_A_MSDU_PRESENT);
 
-	need_padding = is_qos ^ is_4addr ^ is_amsdu;
 	if (need_padding) {
 		memmove(skb->data + 2, skb->data, skb->len);
 		skb_reserve(skb, 2);
-- 
1.6.0.340.g84854



