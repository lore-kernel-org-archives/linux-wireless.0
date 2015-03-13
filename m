Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43860 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbbCMM6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 08:58:05 -0400
Date: Fri, 13 Mar 2015 14:01:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, sameo@linux.intel.com,
	aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	davem@davemloft.net, kadlec@blackhole.kfki.hu, kaber@trash.net
Subject: Re: [PATCH 3/4] netfilter: Fix portid types
Message-ID: <20150313130155.GA1044@salvia> (sfid-20150313_135831_788515_E16A88A7)
References: <1426246276-15839-1-git-send-email-richard@nod.at>
 <1426246276-15839-4-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426246276-15839-4-git-send-email-richard@nod.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2015 at 12:31:15PM +0100, Richard Weinberger wrote:
> The netlink portid is an unsigned integer, use this type
> also in netfilter.

This small cleanup I can still take it but...

> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  net/netfilter/nfnetlink_log.c        | 4 ++--
>  net/netfilter/nfnetlink_queue_core.c | 7 ++++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 11d85b3..7f00846 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -62,7 +62,7 @@ struct nfulnl_instance {
>  	struct timer_list timer;
>  	struct net *net;
>  	struct user_namespace *peer_user_ns;	/* User namespace of the peer process */
> -	int peer_portid;			/* PORTID of the peer process */
> +	unsigned int peer_portid;		/* PORTID of the peer process */

I think you have to use u32 for consistency. Other spots use the
datatype for the netlink portid.

I think same thing applies to other patches.
