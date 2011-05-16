Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35400 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1EPRqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 13:46:00 -0400
Date: Mon, 16 May 2011 13:35:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] netlink: nla_nest_end return "unsigned init"
Message-ID: <20110516173548.GB6551@tuxdriver.com> (sfid-20110516_194606_039166_03B95D07)
References: <1305555810-17565-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1305555810-17565-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should go to netdev@vger.kernel.org instead...

On Mon, May 16, 2011 at 07:23:30AM -0700, Wey-Yi Guy wrote:
> skb->len has unsigned int, return the correct value from nla_nest_end call.
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  include/net/netlink.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 8a3906a..241fc0d 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -1015,7 +1015,8 @@ static inline struct nlattr *nla_nest_start(struct sk_buff *skb, int attrtype)
>   *
>   * Returns the total data length of the skb.
>   */
> -static inline int nla_nest_end(struct sk_buff *skb, struct nlattr *start)
> +static inline unsigned int nla_nest_end(struct sk_buff *skb,
> +					struct nlattr *start)
>  {
>  	start->nla_len = skb_tail_pointer(skb) - (unsigned char *)start;
>  	return skb->len;
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
