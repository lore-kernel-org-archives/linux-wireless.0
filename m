Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43626 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbZAHLeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 06:34:31 -0500
Message-Id: <20090108113422.077652813@atheros.com> (sfid-20090108_123904_069370_E0B4FB6D)
References: <20090108113158.681894124@atheros.com>
Date: Thu, 08 Jan 2009 13:32:14 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCHv2 16/16] mac80211_hwsim: Report driver as MFP capable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211_hwsim has no problems with MFP, so report it as MFP capable.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 drivers/net/wireless/mac80211_hwsim.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-01-08 13:12:12.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-01-08 13:17:36.000000000 +0200
@@ -784,6 +784,8 @@ static int __init init_mac80211_hwsim(vo
 			BIT(NL80211_IFTYPE_MESH_POINT);
 		hw->ampdu_queues = 1;
 
+		hw->flags = IEEE80211_HW_MFP_CAPABLE;
+
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
 		hw->sta_data_size = sizeof(struct hwsim_sta_priv);

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
