Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46275 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYLUVkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 16:40:37 -0500
Date: Sun, 21 Dec 2008 15:40:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8180: Fix to add STA mode
Message-ID: <494eb7d1.t197ktKMLMlIer8t%Larry.Finger@lwfinger.net> (sfid-20081221_224041_525205_B0C21FE7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be compatible with mac80211 following commit 3fc7826b95521 (mac80211:
only create default STA interface if supported), rtl8180 needs to set
NL80211_IFTYPE_STATION in interface_modes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Fabio Rossi <rossi.f@inwind.it>
Tested-by: Piter PUNK <piterpunk@unitednerds.org>
---

John,

This patch should be included with the 2.6.29 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -898,6 +898,7 @@ static int __devinit rtl8180_probe(struc
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_UNSPEC;
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	dev->queues = 1;
 	dev->max_signal = 65;
 
---

