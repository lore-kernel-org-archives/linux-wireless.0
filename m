Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbXHKJ16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 05:27:58 -0400
Subject: [PATCH] mac80211: allow crypto with radiotap injection
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sat, 11 Aug 2007 11:30:34 +0200
Message-Id: <1186824634.5363.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As discussed on the radiotap list, the WEP flag should be used for this.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-dev.orig/net/mac80211/tx.c	2007-08-11 11:05:12.029563528 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-11 11:26:14.059563528 +0200
@@ -865,6 +865,7 @@ __ieee80211_parse_tx_radiotap(
 			/*
 			 * radiotap rate u8 is in 500kbps units eg, 0x02=1Mbps
 			 * ieee80211 rate int is in 100kbps units eg, 0x0a=1Mbps
+			 * TODO: auto-select when the rate field is not present!
 			 */
 			target_rate = (*iterator.this_arg) * 5;
 			for (i = 0; i < mode->num_rates; i++) {
@@ -912,6 +913,8 @@ __ieee80211_parse_tx_radiotap(
 
 				skb_trim(skb, skb->len - FCS_LEN);
 			}
+			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
+				control->flags &= ~IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 			break;
 
 		default:


