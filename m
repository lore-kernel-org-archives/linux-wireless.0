Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:36117 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbbJZEDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 00:03:18 -0400
Subject: Re: [PATCH v2] net: tso: add support for IPv6
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	netdev@vger.kernel.org
References: <1445803107-18513-1-git-send-email-emmanuel.grumbach@intel.com>
 <1445803371-19778-1-git-send-email-emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, egrumbach@gmail.com
From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Message-ID: <562DA5FF.6040307@lab.ntt.co.jp> (sfid-20151026_050357_424417_B337752E)
Date: Mon, 26 Oct 2015 13:03:11 +0900
MIME-Version: 1.0
In-Reply-To: <1445803371-19778-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015/10/26 5:02, Emmanuel Grumbach wrote:
> Adding IPv6 for the TSO helper API is trivial:
> * Don't play with the id (which doesn't exist in IPv6)
> * Correctly update the payload_len (don't include the
>   length of the IP header itself)
...
>  	memcpy(hdr, skb->data, hdr_len);
> -	iph = (struct iphdr *)(hdr + mac_hdr_len);
> -	iph->id = htons(tso->ip_id);
> -	iph->tot_len = htons(size + hdr_len - mac_hdr_len);
> +	if (skb->protocol == htons(ETH_P_IP)) {

I guess this should be vlan_get_protocol(skb).

> +		struct iphdr *iph = (void *)(hdr + mac_hdr_len);
> +
> +		iph->id = htons(tso->ip_id);
> +		iph->tot_len = htons(size + hdr_len - mac_hdr_len);
> +		tso->ip_id++;
> +	} else if (skb->protocol == htons(ETH_P_IPV6)) {

Likewise.

Toshiaki Makita

