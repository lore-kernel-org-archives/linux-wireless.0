Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46562 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab1LHJWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 04:22:10 -0500
Received: by bkbzv3 with SMTP id zv3so1360059bkb.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 01:22:08 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] mac80211: Make use of ieee80211_is_* functions in tx status path
Date: Thu,  8 Dec 2011 10:21:54 +0100
Message-Id: <1323336114-31203-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20111208_102216_708423_45A8F98D)
In-Reply-To: <1323336114-31203-1-git-send-email-helmut.schaa@googlemail.com>
References: <1323336114-31203-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ieee80211_is_data, ieee80211_is_mgmt and ieee80211_has_frag in the
tx status path. This makes the code easier to read and allows us to
remove two local variables: frag and type.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/status.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 46222ce..d0f4d9a 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -340,7 +340,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	u16 frag, type;
 	__le16 fc;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata;
@@ -476,12 +475,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * Fragments are passed to low-level drivers as separate skbs, so these
 	 * are actually fragments, not frames. Update frame counters only for
 	 * the first fragment of the frame. */
-
-	frag = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;
-	type = le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_FTYPE;
-
 	if (info->flags & IEEE80211_TX_STAT_ACK) {
-		if (frag == 0) {
+		if (!ieee80211_has_frag(hdr->seq_ctrl)) {
 			local->dot11TransmittedFrameCount++;
 			if (is_multicast_ether_addr(hdr->addr1))
 				local->dot11MulticastTransmittedFrameCount++;
@@ -496,11 +491,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		 * with a multicast address in the address 1 field of type Data
 		 * or Management. */
 		if (!is_multicast_ether_addr(hdr->addr1) ||
-		    type == IEEE80211_FTYPE_DATA ||
-		    type == IEEE80211_FTYPE_MGMT)
+		    ieee80211_is_data(fc) ||
+		    ieee80211_is_mgmt(fc))
 			local->dot11TransmittedFragmentCount++;
 	} else {
-		if (frag == 0)
+		if (!ieee80211_has_frag(hdr->seq_ctrl))
 			local->dot11FailedCount++;
 	}
 
@@ -572,7 +567,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	/* Need to make a copy before skb->cb gets cleared */
 	send_to_cooked = !!(info->flags & IEEE80211_TX_CTL_INJECTED) ||
-			(type != IEEE80211_FTYPE_DATA);
+			 !(ieee80211_is_data(fc));
 
 	/*
 	 * This is a bit racy but we can avoid a lot of work
-- 
1.7.7

