Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47151 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3JGQKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 12:10:05 -0400
From: djduanjiong@gmail.com
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] mac80211: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
Date: Mon,  7 Oct 2013 17:09:13 -0700
Message-Id: <1381190953-6362-1-git-send-email-duanj.fnst@cn.fujitsu.com> (sfid-20131007_181020_454462_C4715E0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 net/mac80211/key.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 620677e..3e51dd7 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -879,7 +879,7 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 				  keyconf->keylen, keyconf->key,
 				  0, NULL);
 	if (IS_ERR(key))
-		return ERR_PTR(PTR_ERR(key));
+		return ERR_CAST(key);
 
 	if (sdata->u.mgd.mfp != IEEE80211_MFP_DISABLED)
 		key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
-- 
1.7.7.6

