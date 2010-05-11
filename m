Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15886 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab0EKSLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 14:11:21 -0400
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com, Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH V3] mac80211: fix paged defragmentation
Date: Tue, 11 May 2010 11:22:11 -0700
Message-Id: <1273602131-9188-1-git-send-email-abhijeet.kolekar@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paged RX skb patch broke the defragmentation. We need to read hdr again
after linearization.

It fixes following bug
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2194

Signed-off-by: Zhu, Yi <yi.zhu@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
v2: Changed hdr reading.
v3: Added more comments.
 net/mac80211/rx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9a08f2c..6e2a7bc 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1253,6 +1253,12 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	if (skb_linearize(rx->skb))
 		return RX_DROP_UNUSABLE;
 
+	/*
+	 *  skb_linearize() might change the skb->data and
+	 *  previously cached variables (in this case, hdr) need to
+	 *  be refreshed with the new data.
+	 */
+	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
 
 	if (frag == 0) {
-- 
1.6.3.3

