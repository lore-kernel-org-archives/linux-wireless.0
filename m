Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:57229 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbaHVJON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 05:14:13 -0400
Date: Fri, 22 Aug 2014 12:14:09 +0300
From: Jouni Malinen <j@w1.fi>
To: chaitanya.mgit@gmail.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [mac80211] Enforce protected check for unicast robust management
 frames.
Message-ID: <20140822091409.GA3263@w1.fi> (sfid-20140822_111416_569301_ACC9EFBB)
References: <1407783114-5469-1-git-send-email-chaitanya.mgit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1407783114-5469-1-git-send-email-chaitanya.mgit@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 12, 2014 at 12:21:54AM +0530, chaitanya.mgit@gmail.com wrote:
> Enforce the check for protected field for all unicast 
> robust management frames. 

Why? This function is supposed to indicate whether the frame is a robust
action frame and as such, has to have Protected bit set to one. If the
sender (attacker) tries to send the frame unprotected, it will still
need to be caught here.

Rather than enforcing anything, this would add a significant security
vulnerability by breaking PMF more or less completely.

> This removed the dependency on the driver to check for protected
> bit, especially for those drivers who believed the API :-).

Huh.. What is this driver referring to or what do you think the API is
supposed to be doing? ieee80211_is_unicast_robust_mgmt_frame() is a
static function within net/mac80211/rx.c and has only a single caller,
so it cannot really be used by any driver..

> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> @@ -569,6 +569,9 @@ static int ieee80211_is_unicast_robust_mgmt_frame(struct sk_buff *skb)
>  	if (is_multicast_ether_addr(hdr->addr1))
>  		return 0;
>  
> +	if (!ieee80211_has_protected(hdr->frame_control))
> +		return 0;
> +
>  	return ieee80211_is_robust_mgmt_frame(skb);

This looks very incorrect. This would completely break
ieee80211_drop_unencrypted_mgmt() and allow unprotected robust
management frames to be processed.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
