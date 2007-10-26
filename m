Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3294 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbXJZVGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:06:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org, warmcat <andy@warmcat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] Add get_unaligned to ieee80211_get_radiotap_len
Date: Fri, 26 Oct 2007 17:04:24 -0400
Message-Id: <11934326793639-git-send-email-linville@tuxdriver.com> (sfid-20071026_220652_964572_192CB86A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: warmcat <andy@warmcat.com>

ieee80211_get_radiotap_len() tries to dereference radiotap length without
taking care that it is completely unaligned and get_unaligned()
is required.

Signed-off-by: Andy Green <andy@warmcat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index ff2172f..9b9d716 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -350,7 +350,7 @@ static int ieee80211_get_radiotap_len(struct sk_buff *skb)
 	struct ieee80211_radiotap_header *hdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 
-	return le16_to_cpu(hdr->it_len);
+	return le16_to_cpu(get_unaligned(&hdr->it_len));
 }
 
 #ifdef CONFIG_MAC80211_LOWTX_FRAME_DUMP
-- 
1.5.2.4

