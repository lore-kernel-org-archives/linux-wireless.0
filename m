Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31154 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbZGJUmd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 16:42:33 -0400
Subject: [PATCH] mac80211: fix injection in monitor mode
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 10 Jul 2009 16:42:29 -0400
Message-ID: <20090710204229.18177.55710.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The location of the 802.11 header is calculated incorrectly due to a
wrong placement of parentheses.  Found by kmemcheck.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 969a4b2..b7e981c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1407,7 +1407,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		monitor_iface = UNKNOWN_ADDRESS;
 
 		len_rthdr = ieee80211_get_radiotap_len(skb->data);
-		hdr = (struct ieee80211_hdr *)skb->data + len_rthdr;
+		hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
 		hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 		/* check the header is complete in the frame */
