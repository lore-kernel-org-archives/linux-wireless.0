Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57687 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103AbYFDTYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 15:24:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: [PATCH RFC] zd1211rw: Fix data padding for QoS
Date: Wed, 4 Jun 2008 21:22:58 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806042122.58622.mb@bu3sch.de> (sfid-20080604_212446_056728_62F9B437)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was wondering whether the data padding was broken in zd1211
for QoS frames. The IEEE80211_STYPE_QOS_DATA is a bit that can be
used as indicator for the presence of the 2 byte QoS control field.

This patch is neither tested, nor did I see any runtime breakage.
It just seems to me that this is a bug anyway.

Index: wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-05-16 00:26:29.000000000 +0200
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2008-06-04 21:19:06.000000000 +0200
@@ -719,7 +719,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	fc = le16_to_cpu(*((__le16 *) buffer));
 
 	is_qos = ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-		 ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_QOS_DATA);
+		 (fc & IEEE80211_STYPE_QOS_DATA);
 	is_4addr = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
 		   (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
 	need_padding = is_qos ^ is_4addr;

-- 
Greetings Michael.
