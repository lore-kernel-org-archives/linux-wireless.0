Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbXL2NtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 08:49:05 -0500
Subject: Re: Strange mac80211 oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <47764C5A.7060109@gentoo.org>
References: <200712242237.28913.mb@bu3sch.de>
	 <1198532736.4103.44.camel@johannes.berg>
	 <1198533423.4103.46.camel@johannes.berg> <200712242328.56060.mb@bu3sch.de>
	 <47764C5A.7060109@gentoo.org>
Content-Type: text/plain
Date: Sat, 29 Dec 2007 14:48:47 +0100
Message-Id: <1198936128.4172.41.camel@johannes.berg> (sfid-20071229_134909_131605_E59385E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This might help. Totally untested.

---
 drivers/net/wireless/zd1211rw/zd_mac.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-29 14:42:18.292833767 +0100
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-29 14:47:34.022831923 +0100
@@ -612,6 +612,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	int bad_frame = 0;
 	int i;
 	u8 rate;
+	u16 fc;
+	int is_qos, is_4addr;
 
 	if (length < ZD_PLCP_HEADER_SIZE + 10 /* IEEE80211_1ADDR_LEN */ +
 	             FCS_LEN + sizeof(struct rx_status))
@@ -671,6 +673,16 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	skb = dev_alloc_skb(length);
 	if (skb == NULL)
 		return -ENOMEM;
+
+	fc = le16_to_cpu(*((__le16 *) buffer));
+
+	is_qos = !!(fc & IEEE80211_STYPE_QOS_DATA);
+	is_4addr = (fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) ==
+			(IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS);
+
+	if (is_qos ^ is_4addr)
+		skb_reserve(skb, 2);
+
 	memcpy(skb_put(skb, length), buffer, length);
 
 	ieee80211_rx_irqsafe(hw, skb, &stats);


