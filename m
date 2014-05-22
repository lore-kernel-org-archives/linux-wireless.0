Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45582 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaEVSaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 14:30:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Bing Zhao <bzhao@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwifiex: use 'const' qualifier for 2nd arg of mwifiex_tdls_add_ht_oper
Date: Thu, 22 May 2014 14:23:58 -0400
Message-Id: <1400783038-10174-1-git-send-email-linville@tuxdriver.com> (sfid-20140522_203020_099868_A3F5B43A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the following warning:

  CC      drivers/net/wireless/mwifiex/tdls.o
drivers/net/wireless/mwifiex/tdls.c: In function ‘mwifiex_prep_tdls_encap_data’:
drivers/net/wireless/mwifiex/tdls.c:475:4: warning: passing argument 2 of ‘mwifiex_tdls_add_ht_oper’ discards ‘const’ qualifier from pointer target type [enabled by
default]
    ret = mwifiex_tdls_add_ht_oper(priv, peer, 1, skb);
    ^
drivers/net/wireless/mwifiex/tdls.c:190:1: note: expected ‘u8 *’ but argument is of type ‘const u8 *’
 mwifiex_tdls_add_ht_oper(struct mwifiex_private *priv, u8 *mac,
 ^
drivers/net/wireless/mwifiex/tdls.c:481:4: warning: passing argument 2 of ‘mwifiex_tdls_add_ht_oper’ discards ‘const’ qualifier from pointer target type [enabled by
default]
    ret = mwifiex_tdls_add_ht_oper(priv, peer, 0, skb);
    ^
drivers/net/wireless/mwifiex/tdls.c:190:1: note: expected ‘u8 *’ but argument is of type ‘const u8 *’
 mwifiex_tdls_add_ht_oper(struct mwifiex_private *priv, u8 *mac,
 ^

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwifiex/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index e14fbb5de49b..e73034fbbde9 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -187,7 +187,7 @@ static int mwifiex_tdls_add_vht_capab(struct mwifiex_private *priv,
 }
 
 static int
-mwifiex_tdls_add_ht_oper(struct mwifiex_private *priv, u8 *mac,
+mwifiex_tdls_add_ht_oper(struct mwifiex_private *priv, const u8 *mac,
 			 u8 vht_enabled, struct sk_buff *skb)
 {
 	struct ieee80211_ht_operation *ht_oper;
-- 
1.9.0

