Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:49060 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAPB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 10:01:27 -0500
Received: by mail-bk0-f53.google.com with SMTP id j10so1377536bkw.26
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 07:01:26 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCH] mac80211: fix oops on mesh PS broadcast forwarding
Date: Fri,  1 Mar 2013 16:01:18 +0100
Message-Id: <1362150078-10802-1-git-send-email-marco@cozybit.com> (sfid-20130301_160131_812108_98587C53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduced with de74a1d9032f4d37ea453ad2a647e1aff4cd2591
"mac80211: fix WPA with VLAN on AP side with ps-sta".
Apparently overwrites the sdata pointer with non-valid data in
the case of mesh.
Fix this by checking for IFTYPE_AP_VLAN.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 net/mac80211/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c79860f..cb4b9ab 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2749,7 +2749,8 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
 		if (!ieee80211_tx_prepare(sdata, &tx, skb))
 			break;
 		dev_kfree_skb_any(skb);
-- 
1.7.9.5

