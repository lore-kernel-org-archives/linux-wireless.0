Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYIKD2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 23:28:17 -0400
Subject: [PATCH 25/18] mac80211: pass AP vif pointer for VLANs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080910220145.707263000@sipsolutions.net> (sfid-20080911_001619_033062_98BAB5F3)
References: <20080910220145.707263000@sipsolutions.net>
	 (sfid-20080911_001619_033062_98BAB5F3)
Content-Type: text/plain
Date: Thu, 11 Sep 2008 05:27:40 +0200
Message-Id: <1221103660.3804.86.camel@johannes.berg> (sfid-20080911_052820_916922_8A0AF194)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We cannot pass a VLAN vif pointer to the driver since those are
entirely virtual and we never tell the driver.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- everything.orig/net/mac80211/tx.c	2008-09-11 05:22:58.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-11 05:25:16.000000000 +0200
@@ -1351,6 +1351,10 @@ int ieee80211_master_start_xmit(struct s
 		return 0;
 	}
 
+	if (osdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		osdata = container_of(osdata->bss,
+				      struct ieee80211_sub_if_data,
+				      u.ap);
 	info->control.vif = &osdata->vif;
 	ret = ieee80211_tx(odev, skb);
 	dev_put(odev);


