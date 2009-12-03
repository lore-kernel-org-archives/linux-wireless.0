Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6515 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696AbZLCT3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 14:29:54 -0500
Subject: Re: [PATCH v2 3/5] mac80211: correctly place aMPDU RX reorder code
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259867689.12843.14.camel@johannes.local>
References: <20091125164614.427835023@sipsolutions.net>
	 <20091125164821.184669673@sipsolutions.net>
	 <1259864007.4653.298.camel@rc-desk>
	 <1259867689.12843.14.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 03 Dec 2009 11:30:00 -0800
Message-Id: <1259868600.4653.300.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, 2009-12-03 at 11:14 -0800, Johannes Berg wrote:
> ---
>  net/mac80211/rx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- wireless-testing.orig/net/mac80211/rx.c	2009-12-03 20:13:44.000000000 +0100
> +++ wireless-testing/net/mac80211/rx.c	2009-12-03 20:13:50.000000000 +0100
> @@ -570,7 +570,7 @@ static void ieee80211_release_reorder_fr
>  		rate = &sband->bitrates[status->rate_idx];
>  	tid_agg_rx->stored_mpdu_num--;
>  	tid_agg_rx->reorder_buf[index] = NULL;
> -	skb_queue_tail(frames, skb);
> +	__skb_queue_tail(frames, skb);
>  
>  no_frame:
>  	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
> 
> 

Thank you very much for looking into this so promptly. This patch fixes
the problem.

Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


