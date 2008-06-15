Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:65412 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYFOGdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 02:33:38 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3882106waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 23:33:38 -0700 (PDT)
Subject: [PATCH 2/4] zd1211rw: use frame control helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Jun 2008 23:33:39 -0700
Message-Id: <1213511619.11544.31.camel@brick> (sfid-20080615_083343_827968_A11C92BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6d86b36..317c5e2 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -376,8 +376,6 @@ static int zd_calc_tx_length_us(u8 *service, u8 zd_rate, u16 tx_length)
 static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 	                   struct ieee80211_hdr *header, u32 flags)
 {
-	u16 fctl = le16_to_cpu(header->frame_control);
-
 	/*
 	 * CONTROL TODO:
 	 * - if backoff needed, enable bit 0
@@ -395,8 +393,7 @@ static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 		cs->control |= ZD_CS_MULTICAST;
 
 	/* PS-POLL */
-	if ((fctl & (IEEE80211_FCTL_FTYPE|IEEE80211_FCTL_STYPE)) ==
-	    (IEEE80211_FTYPE_CTL|IEEE80211_STYPE_PSPOLL))
+	if (ieee80211_is_pspoll(header->frame_control))
 		cs->control |= ZD_CS_PS_POLL_FRAME;
 
 	if (flags & IEEE80211_TX_CTL_USE_RTS_CTS)
@@ -550,13 +547,11 @@ static int zd_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
 		      struct ieee80211_rx_status *stats)
 {
-	u16 fc = le16_to_cpu(rx_hdr->frame_control);
 	struct sk_buff *skb;
 	struct sk_buff_head *q;
 	unsigned long flags;
 
-	if ((fc & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) !=
-	    (IEEE80211_FTYPE_CTL | IEEE80211_STYPE_ACK))
+	if (!ieee80211_is_ack(rx_hdr->frame_control))
 		return 0;
 
 	q = &zd_hw_mac(hw)->ack_wait_queue;
@@ -584,8 +579,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 	const struct rx_status *status;
 	struct sk_buff *skb;
 	int bad_frame = 0;
-	u16 fc;
-	bool is_qos, is_4addr, need_padding;
+	__le16 fc;
+	int need_padding;
 	int i;
 	u8 rate;
 
@@ -644,13 +639,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 			&& !mac->pass_ctrl)
 		return 0;
 
-	fc = le16_to_cpu(*((__le16 *) buffer));
-
-	is_qos = ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-		 (fc & IEEE80211_STYPE_QOS_DATA);
-	is_4addr = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
-		   (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-	need_padding = is_qos ^ is_4addr;
+	fc = *(__le16 *)buffer;
+	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
 
 	skb = dev_alloc_skb(length + (need_padding ? 2 : 0));
 	if (skb == NULL)
-- 
1.5.6.rc3.283.g198e


