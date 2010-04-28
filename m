Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63978 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab0D1UtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 16:49:09 -0400
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH] mac80211: fix paged defragmentation
Date: Wed, 28 Apr 2010 13:59:22 -0700
Message-Id: <1272488362-14603-1-git-send-email-abhijeet.kolekar@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the bug at
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2194

Paged RX skb patch broke the fragmentation while checking the sequnce
control bit in headers. Instead of doing linearization of all the frames
to check seq_ctrl bit just copy the bits.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 net/mac80211/rx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 72efbd8..4126392 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1234,14 +1234,16 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
 	u16 sc;
-	__le16 fc;
+	__le16 fc, seq_ctrl;
 	unsigned int frag, seq;
 	struct ieee80211_fragment_entry *entry;
 	struct sk_buff *skb;
 
 	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	fc = hdr->frame_control;
-	sc = le16_to_cpu(hdr->seq_ctrl);
+	skb_copy_bits(rx->skb, offsetof(struct ieee80211_hdr, seq_ctrl),
+			&seq_ctrl, sizeof(seq_ctrl));
+	sc = le16_to_cpu(seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
 	if (likely((!ieee80211_has_morefrags(fc) && frag == 0) ||
-- 
1.6.3.3

