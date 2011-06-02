Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:50066 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1FBUhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 16:37:50 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-wireless@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	Jiri Pirko <jpirko@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: call dev_alloc_name before copying name to sdata
Date: Thu,  2 Jun 2011 17:28:37 -0300
Message-Id: <1307046517-6921-1-git-send-email-cascardo@holoscopio.com> (sfid-20110602_223755_058185_3A5ADDDD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This partially reverts 1c5cae815d19ffe02bdfda1260949ef2b1806171, because
the netdev name is copied into sdata->name, which is used for debugging
messages, for example. Otherwise, we get messages like this:

wlan%d: authenticated

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Jiri Pirko <jpirko@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
---
 net/mac80211/iface.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 49d4f86..dee30ae 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1145,6 +1145,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 				+ IEEE80211_ENCRYPT_HEADROOM;
 	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
 
+	ret = dev_alloc_name(ndev, ndev->name);
+	if (ret < 0)
+		goto fail;
+
 	ieee80211_assign_perm_addr(local, ndev, type);
 	memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
-- 
1.7.2.5

