Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34273 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbZADPit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 10:38:49 -0500
Message-ID: <4960D7FF.9010903@lwfinger.net> (sfid-20090104_163851_958344_1584070C)
Date: Sun, 04 Jan 2009 09:38:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John W Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH - resubmit] rtl8180: Fix to add STA mode
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be compatible with mac80211 following commit 3fc7826b95521
(mac80211: only create default STA interface if supported), rtl8180
needs to set NL80211_IFTYPE_STATION in interface_modes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Fabio Rossi <rossi.f@inwind.it>
Tested-by: Piter PUNK <piterpunk@unitednerds.org>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---

John,

This bug has now started to affect users of 2.6.28-git mainline. Did
it get lost, or has it already been push upstream?

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

