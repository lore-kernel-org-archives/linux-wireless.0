Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35088 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdCPB5j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 21:57:39 -0400
Received: by mail-pf0-f194.google.com with SMTP id x63so3859522pfx.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Mar 2017 18:57:38 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH 1/2] nl80211: Use signed function for a signed variable
Date: Thu, 16 Mar 2017 10:57:17 +0900
Message-Id: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com> (sfid-20170316_025742_756338_EB201ADE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rssi_threshold is defined as s32.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b15903b..bd5959f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5714,7 +5714,7 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 		       cur_params.dot11MeshGateAnnouncementProtocol) ||
 	    nla_put_u8(msg, NL80211_MESHCONF_FORWARDING,
 		       cur_params.dot11MeshForwarding) ||
-	    nla_put_u32(msg, NL80211_MESHCONF_RSSI_THRESHOLD,
+	    nla_put_s32(msg, NL80211_MESHCONF_RSSI_THRESHOLD,
 			cur_params.rssi_threshold) ||
 	    nla_put_u32(msg, NL80211_MESHCONF_HT_OPMODE,
 			cur_params.ht_opmode) ||
-- 
2.7.4
