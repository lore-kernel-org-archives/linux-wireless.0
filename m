Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab0IPNUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 09:20:13 -0400
Subject: [RFC] ath9k: advertise support for p2p
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <20100916125821.369545798@sipsolutions.net>
References: <20100916125821.369545798@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 15:20:11 +0200
Message-ID: <1284643211.3731.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Obvious patch really, but I guess the filtering thing should be figured
out first ... this is just for people who want to keep using ath9k after
updates to the supplicant and already have a patched kernel.

---
 drivers/net/wireless/ath/ath9k/init.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/init.c	2010-09-16 14:08:48.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/init.c	2010-09-16 14:09:03.000000000 +0200
@@ -638,6 +638,8 @@ void ath9k_set_hw_capab(struct ath_softc
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
 	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_P2P_GO) |
+		BIT(NL80211_IFTYPE_P2P_CLIENT) |
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) |


