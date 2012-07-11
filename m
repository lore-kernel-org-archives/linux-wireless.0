Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65501 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2GKI3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 04:29:04 -0400
Received: by ghrr11 with SMTP id r11so944093ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 01:29:02 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: Fix the Problem of Unreachable Mesh STA from DS
Date: Wed, 11 Jul 2012 16:28:21 +0800
Message-Id: <1341995301-24611-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120711_102918_901951_05AB2FA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the problem of unreachable mesh STA from
Distribution System (DS) due to the introduction of previous
patch solving the mesh STA joining from one MBSS to another
MBSS.

Reported-by: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/tx.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 07bd305..dd5b151 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1817,6 +1817,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 					/* RA TA mDA mSA AE:DA SA */
 					mesh_da = mppath->mpp;
 					is_mesh_mcast = 0;
+				} else if (mpath) {
+					mesh_da = mpath->dst;
+					is_mesh_mcast = 0;
 				} else {
 					/* DA TA mSA AE:SA */
 					mesh_da = bcast;
-- 
1.7.0.4

