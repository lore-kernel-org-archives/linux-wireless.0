Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:34923 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdDHTHI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 15:07:08 -0400
Received: by mail-pg0-f53.google.com with SMTP id 81so87448567pgh.2
        for <linux-wireless@vger.kernel.org>; Sat, 08 Apr 2017 12:07:08 -0700 (PDT)
Subject: Re: [PATCH v2 3/5] netlink: allow sending extended ACK with cookie on
 success
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20170408183444.2796-1-johannes@sipsolutions.net>
 <20170408183444.2796-4-johannes@sipsolutions.net>
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us,
        Johannes Berg <johannes.berg@intel.com>
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <3176866b-3e8d-4669-796f-8292d68a5511@cumulusnetworks.com> (sfid-20170408_210804_139302_FC77DBAA)
Date: Sat, 8 Apr 2017 15:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <20170408183444.2796-4-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

since a v3 is coming another small cleanup ...


On 4/8/17 2:34 PM, Johannes Berg wrote:
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index c74f56a4fcf1..98e55a59c97e 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2336,20 +2339,27 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
>  	       !(nlk->flags & NETLINK_F_CAP_ACK) ? nlh->nlmsg_len
>  						 : sizeof(*nlh));
>  
> -	if (err && nlk->flags & NETLINK_F_EXT_ACK && extack) {
> -		if (extack->_msg)
> -			WARN_ON(nla_put_string(skb, NLMSGERR_ATTR_MSG,
> -					       extack->_msg));
> -		if (extack->bad_attr &&
> -		    !WARN_ON((u8 *)extack->bad_attr < in_skb->data ||
> -			     (u8 *)extack->bad_attr >= in_skb->data +
> -						       in_skb->len))
> -			WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
> -					    (u8 *)extack->bad_attr -
> -					    in_skb->data));
> -		if (extack->missing_attr)
> -			WARN_ON(nla_put_u16(skb, NLMSGERR_ATTR_ATTR,
> -					    extack->missing_attr));
> +	if (nlk->flags & NETLINK_F_EXT_ACK) {
> +		if (err && extack) {

push the extack into the flags if check

> +			if (extack->_msg)
> +				WARN_ON(nla_put_string(skb, NLMSGERR_ATTR_MSG,
> +						       extack->_msg));
> +			if (extack->bad_attr &&
> +			    !WARN_ON((u8 *)extack->bad_attr < in_skb->data ||
> +				     (u8 *)extack->bad_attr >= in_skb->data +
> +							       in_skb->len))
> +				WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
> +						    (u8 *)extack->bad_attr -
> +						    in_skb->data));
> +			if (extack->missing_attr)
> +				WARN_ON(nla_put_u16(skb, NLMSGERR_ATTR_ATTR,
> +						    extack->missing_attr));
> +		} else if (!err && extack) {

and here too

> +			if (extack->cookie_len)
> +				WARN_ON(nla_put(skb, NLMSGERR_ATTR_COOKIE,
> +						extack->cookie_len,
> +						extack->cookie));
> +		}
