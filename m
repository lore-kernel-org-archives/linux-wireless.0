Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35342 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbcHCDKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 23:10:51 -0400
Received: by mail-pf0-f194.google.com with SMTP id h186so13647549pfg.2
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 20:10:02 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mac80211: Include HT Capabilities element if capable
Date: Wed,  3 Aug 2016 11:54:29 +0900
Message-Id: <1470192869-4206-1-git-send-email-masashi.honma@gmail.com> (sfid-20160803_051055_572641_21E74AFA)
In-Reply-To: <1470122837.2665.5.camel@sipsolutions.net>
References: <1470122837.2665.5.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, "HT Capabilities element" was not included in beacon and
Mesh Peering Open/Close frames when wpa_supplicant config file includes
disable_ht=1 even though HT is capable. But "HT Capabilities element"
should not be modified because it is defined by hardware and software
spec of the node.

We do not change "HT Operation element" code, because it is defined by
surrounding environment and configuration of the node. So it could be
vanished by disable_ht=1.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/mesh.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c66411d..ebd4159 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -409,10 +409,7 @@ int mesh_add_ht_cap_ie(struct ieee80211_sub_if_data *sdata,
 	u8 *pos;
 
 	sband = local->hw.wiphy->bands[band];
-	if (!sband->ht_cap.ht_supported ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_5 ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_10)
+	if (!sband->ht_cap.ht_supported)
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_cap))
-- 
2.7.4

