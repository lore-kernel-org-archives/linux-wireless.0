Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:33052 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab0E1ViV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 17:38:21 -0400
Subject: Re: paged RX skbs and BlockAck Request packets
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Daniel Halperin <dhalperi@cs.washington.edu>
In-Reply-To: <1275078893.3909.117.camel@jlt3.sipsolutions.net>
Date: Fri, 28 May 2010 14:38:07 -0700
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Message-Id: <9F6635B9-D6BE-4C6A-AA12-37662043B70E@cs.washington.edu>
References: <7994C719-E1C8-4818-A03E-0566E8380CC3@cs.washington.edu> <1275078893.3909.117.camel@jlt3.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On May 28, 2010, at 1:34 PM, Johannes Berg wrote:
> One thing I ask myself though is do we ever check that the frame is long
> enough? In the patch below I will by checking the skb_copy_bits() return
> value, but without that we don't, as far as I can tell?

Good point.

> --- wireless-testing.orig/net/mac80211/rx.c	2010-05-28 22:25:07.000000000 +0200
> +++ wireless-testing/net/mac80211/rx.c	2010-05-28 22:33:30.000000000 +0200
> @@ -1819,17 +1819,26 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
> 		return RX_CONTINUE;
> 
> 	if (ieee80211_is_back_req(bar->frame_control)) {
> +		struct {
> +			__le16 control, start_seq_num;
> +		} __packed bar_data;
> +
> +		if (skb_copy_bits(skb, offsetof(struct ieee80211_bar, control),
> +				  &bar_data, sizeof(bar_data)))
> +			return RX_DROP_MONITOR;
> +
> 		if (!rx->sta)
> 			return RX_DROP_MONITOR;

Maybe invert the order of these two exit conditions? Figure most CPUs will speculate anyway, but the second check seems a more efficient short-circuit.

Dan