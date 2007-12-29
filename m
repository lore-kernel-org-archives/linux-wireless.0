Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45294 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbXL2QZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 11:25:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: Strange mac80211 oops
Date: Sat, 29 Dec 2007 17:24:23 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200712242237.28913.mb@bu3sch.de> <47764C5A.7060109@gentoo.org> <1198936128.4172.41.camel@johannes.berg>
In-Reply-To: <1198936128.4172.41.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200712291724.23726.mb@bu3sch.de> (sfid-20071229_162558_444791_97F21B69)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes RX packet alignment issues in the zd1211rw driver.
This is based on a patch by Johannes Berg.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/zd1211rw/zd_mac.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-29 17:14:41.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-29 17:15:00.000000000 +0100
@@ -623,6 +623,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	const struct rx_status *status;
 	struct sk_buff *skb;
 	int bad_frame = 0;
+	u16 fc;
+	bool is_qos, is_4addr, need_padding;
 
 	if (length < ZD_PLCP_HEADER_SIZE + 10 /* IEEE80211_1ADDR_LEN */ +
 	             FCS_LEN + sizeof(struct rx_status))
@@ -674,9 +676,22 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 			&& !mac->pass_ctrl)
 		return 0;
 
-	skb = dev_alloc_skb(length);
+	fc = le16_to_cpu(*((__le16 *) buffer));
+
+	is_qos = ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+		 ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_QOS_DATA);
+	is_4addr = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
+		   (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
+	need_padding = is_qos ^ is_4addr;
+
+	skb = dev_alloc_skb(length + (need_padding ? 2 : 0));
 	if (skb == NULL)
 		return -ENOMEM;
+	if (need_padding) {
+		/* Make sure the the payload data is 4 byte aligned. */
+		skb_reserve(skb, 2);
+	}
+
 	memcpy(skb_put(skb, length), buffer, length);
 
 	ieee80211_rx_irqsafe(hw, skb, &stats);
