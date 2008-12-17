Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39459 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYLQU1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 15:27:04 -0500
Date: Wed, 17 Dec 2008 14:26:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Print unknown packet type in tasklet_handler
Message-ID: <49496093.ddL5Pgdq/zMZM8op%Larry.Finger@lwfinger.net> (sfid-20081217_212709_275458_D328B273)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In stress testing p54usb, the WARN_ON() in ieee80211_tasklet_handler() was
triggered; however, there is no logging of the received value for packet
type. Adding that feature will improve the warning.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John.

This is 2.6.29 material.

Larry
---

Index: wireless-testing/net/mac80211/main.c
===================================================================
--- wireless-testing.orig/net/mac80211/main.c
+++ wireless-testing/net/mac80211/main.c
@@ -341,7 +341,8 @@ static void ieee80211_tasklet_handler(un
 			dev_kfree_skb(skb);
 			break ;
 		default:
-			WARN_ON(1);
+			WARN(1, "mac80211: Packet is of unknown type %d\n",
+			     skb->pkt_type);
 			dev_kfree_skb(skb);
 			break;
 		}
