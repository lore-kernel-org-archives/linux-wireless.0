Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59656 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZD3SbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 14:31:00 -0400
Date: Thu, 30 Apr 2009 14:29:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 2.6.30] mac80211: correct fragmentation threshold check
Message-ID: <20090430182927.GB9323@tuxdriver.com>
References: <1241040956.5067.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241040956.5067.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does there happen to be a bugzilla somewhere that corresponds to this?

On Wed, Apr 29, 2009 at 11:35:56PM +0200, Johannes Berg wrote:
> The fragmentation threshold is defined to be including the
> FCS, and the code that sets the TX_FRAGMENTED flag correctly
> accounts for those four bytes. The code that verifies this
> doesn't though, which could lead to spurious warnings and
> frames being dropped although everything is ok. Correct the
> code by accounting for the FCS.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/tx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- wireless-testing.orig/net/mac80211/tx.c	2009-04-29 22:27:51.000000000 +0200
> +++ wireless-testing/net/mac80211/tx.c	2009-04-29 22:28:35.000000000 +0200
> @@ -788,7 +788,7 @@ ieee80211_tx_h_fragment(struct ieee80211
>  	hdrlen = ieee80211_hdrlen(hdr->frame_control);
>  
>  	/* internal error, why is TX_FRAGMENTED set? */
> -	if (WARN_ON(skb->len <= frag_threshold))
> +	if (WARN_ON(skb->len + FCS_LEN <= frag_threshold))
>  		return TX_DROP;
>  
>  	/*
> 
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
