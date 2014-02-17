Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:56626 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaBQRay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 12:30:54 -0500
Message-ID: <5302474B.6090609@broadcom.com> (sfid-20140217_183058_077391_67FB91A3)
Date: Mon, 17 Feb 2014 18:30:51 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>,
	<linux-wireless@vger.kernel.org>,
	<mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [net-next v2 3/3] cfg80211: add MPLS and 802.21 classification
References: <1392656174-14791-1-git-send-email-sw@simonwunderlich.de> <1392656174-14791-4-git-send-email-sw@simonwunderlich.de>
In-Reply-To: <1392656174-14791-4-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/14 17:56, Simon Wunderlich wrote:
> MPLS labels may contain traffic control information, which should be
> evaluated and used by the wireless subsystem if present.
>
> Also check for IEEE 802.21 which is always network control traffic.
>
> Signed-off-by: Simon Wunderlich<sw@simonwunderlich.de>
> Signed-off-by: Mathias Kretschmer<mathias.kretschmer@fokus.fraunhofer.de>
> ---
> Changes to first version:
>
>   * include linux/mpls.h, not the UAPI one
>   * change __constant_htons to htons
> ---
>   net/wireless/util.c |   24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index d39c371..54956eb 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -11,6 +11,7 @@
>   #include<net/ip.h>
>   #include<net/dsfield.h>
>   #include<linux/if_vlan.h>
> +#include<linux/mpls.h>
>   #include "core.h"
>   #include "rdev-ops.h"
>
> @@ -710,6 +711,29 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,

So does the name still covers what it is doing now or should we just 
callit cfg80211_classify_skb()?

>   			return vlan_priority;
>   	}
>
> +	if (skb_headlen(skb)>= sizeof(struct ethhdr)) {
> +		struct ethhdr *eh = (struct ethhdr *)skb->data;
> +		struct mpls_label_stack mpls_tmp, *mpls;
> +
> +		switch (eh->h_proto) {

It seem eh->h_proto should be the same as skb->protocol, right? So why 
not add these case statements to the switch below?

Regards,
Arend

> +		case htons(ETH_P_MPLS_UC):
> +		case htons(ETH_P_MPLS_MC):
> +			/* MPLS */
> +			mpls = skb_header_pointer(skb, sizeof(*eh),
> +						  sizeof(*mpls),&mpls_tmp);
> +			if (!mpls)
> +				break;
> +
> +			return (ntohl(mpls->entry)&  MPLS_LS_TC_MASK)
> +				>>  MPLS_LS_TC_SHIFT;
> +		case htons(ETH_P_80221):
> +			/* 802.21 is always network control traffic */
> +			return 7;
> +		default:
> +			break;
> +		}
> +	}
> +
>   	switch (skb->protocol) {
>   	case htons(ETH_P_IP):
>   		dscp = ipv4_get_dsfield(ip_hdr(skb))&  0xfc;

