Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab0E1UfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 16:35:06 -0400
Subject: Re: paged RX skbs and BlockAck Request packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <7994C719-E1C8-4818-A03E-0566E8380CC3@cs.washington.edu>
References: <7994C719-E1C8-4818-A03E-0566E8380CC3@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 22:34:53 +0200
Message-ID: <1275078893.3909.117.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 12:46 -0700, Daniel Halperin wrote:
> I'm using the latest iwlwifi-2.6.git from
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> 
> When using 802.11n aggregation and the other endpoint sends a BlockAck
> Request, many times the transfer will completely stall.
> 
> It looks like the relevant code is in
> net/mac80211/rx.c:ieee80211_rx_h_ctrl . I found that the sequence
> numbers used are invalid. If instead I linearize the SKB, then the
> sequence numbers become valid, so I believe it's a problem with the
> use of paged RX skbs. Mailing both lists since I'm not sure where the
> fix should go.
> 
> The paged RX SKBs are set up in
> drivers/net/wireless/iwlwifi:iwl-agn-lib.c:iwl_pass_packet_to_mac80211. I made a temporary fix at net/mac80211/rx.c:__ieee80211_rx_handle_packet
> 
> by changing 
> 
>         if (ieee80211_is_mgmt(fc))
>                 err = skb_linearize(skb);
> 
> to
> 
>         if (ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc))
>                 err = skb_linearize(skb);
> 
> Can anyone more knowledgeable than I please tell me the right fix?

Wow, good catch. FWIW, that seems like a perfectly appropriate fix,
since control frames are typically very short I don't see any problem in
linearizing them, in fact I'd think the skb should already have enough
space at this point. If you wanted to avoid that, you need a patch like
the one below.

One thing I ask myself though is do we ever check that the frame is long
enough? In the patch below I will by checking the skb_copy_bits() return
value, but without that we don't, as far as I can tell?

johannes

--- wireless-testing.orig/net/mac80211/rx.c	2010-05-28 22:25:07.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-05-28 22:33:30.000000000 +0200
@@ -1819,17 +1819,26 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		return RX_CONTINUE;
 
 	if (ieee80211_is_back_req(bar->frame_control)) {
+		struct {
+			__le16 control, start_seq_num;
+		} __packed bar_data;
+
+		if (skb_copy_bits(skb, offsetof(struct ieee80211_bar, control),
+				  &bar_data, sizeof(bar_data)))
+			return RX_DROP_MONITOR;
+
 		if (!rx->sta)
 			return RX_DROP_MONITOR;
+
 		spin_lock(&rx->sta->lock);
-		tid = le16_to_cpu(bar->control) >> 12;
+		tid = le16_to_cpu(bar_data.control) >> 12;
 		if (!rx->sta->ampdu_mlme.tid_active_rx[tid]) {
 			spin_unlock(&rx->sta->lock);
 			return RX_DROP_MONITOR;
 		}
 		tid_agg_rx = rx->sta->ampdu_mlme.tid_rx[tid];
 
-		start_seq_num = le16_to_cpu(bar->start_seq_num) >> 4;
+		start_seq_num = le16_to_cpu(bar_data.start_seq_num) >> 4;
 
 		/* reset session timer */
 		if (tid_agg_rx->timeout)


