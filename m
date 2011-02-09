Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56464 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab1BIOp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:45:27 -0500
Date: Wed, 9 Feb 2011 09:31:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] nl80211: interface update
Message-ID: <20110209143138.GA2494@tuxdriver.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
 <1297252905-29739-2-git-send-email-zefir.kurtisi@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297252905-29739-2-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 09, 2011 at 01:01:41PM +0100, Zefir Kurtisi wrote:
> Interface implementation to pass DFS pulse events via nl80211.
> 
> Includes
>  * new command NL80211_CMD_SET_DFS_EVENT
>  * new attributes NL80211_DFSEVENT_ATTR_{FREQ,TS,WIDTH}
>  * functions to pass DFS pulse events through netlink interface

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 864ddfb..8e75f40 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -4015,7 +4015,6 @@ __cfg80211_testmode_alloc_skb(struct cfg80211_registered_device *rdev,
>  	skb = nlmsg_new(approxlen + 100, gfp);
>  	if (!skb)
>  		return NULL;
> -
>  	hdr = nl80211hdr_put(skb, pid, seq, 0, NL80211_CMD_TESTMODE);
>  	if (!hdr) {
>  		kfree_skb(skb);

Please don't randomly remove whitespace in your patches. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
