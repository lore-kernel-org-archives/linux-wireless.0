Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab0D3WrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 18:47:24 -0400
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com, Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH V2] mac80211: fix paged defragmentation
Date: Fri, 30 Apr 2010 15:57:59 -0700
Message-Id: <1272668279-6065-1-git-send-email-abhijeet.kolekar@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paged RX skb patch broke the defragmentation. We need to read hdr again
after linearization.

It fixes following bug
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2194

Signed-off-by: Zhu, Yi <yi.zhu@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
v2: Zhu yi suggested following fix.
 net/mac80211/rx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 72efbd8..e7217e2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1255,6 +1255,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	if (skb_linearize(rx->skb))
 		return RX_DROP_UNUSABLE;
 
+	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
 
 	if (frag == 0) {
-- 
1.6.3.3

