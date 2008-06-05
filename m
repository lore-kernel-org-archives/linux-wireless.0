Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60128 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYFEO4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 10:56:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] zd1211rw: Fix data padding for QoS
Date: Thu, 5 Jun 2008 16:55:10 +0200
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200806051655.10637.mb@bu3sch.de> (sfid-20080605_165614_874358_809E7403)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a data alignment issue in the zd1211rw driver.
The IEEE80211_STYPE_QOS_DATA bit should be used as a bitwise test
to test for the presence of the 2 byte QoS control field.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix for 2.6.26

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
