Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:54907 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3IBHix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 03:38:53 -0400
Received: from smtp04.msg.oleane.net (smtp04.mail.priv [172.17.20.113])
	by smtp-out03.msg.oleane.net with ESMTP id r827cpa1011579
	for <linux-wireless@vger.kernel.org>; Mon, 2 Sep 2013 09:38:52 +0200
Subject: RE: [PATCH V4] cfg80211: vlan priority handling in WMM
Date: Mon, 2 Sep 2013 09:17:57 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319015E105E@sbs2003.acksys.local> (sfid-20130902_093857_281834_6915A04F)
In-Reply-To: <1377518692-30084-1-git-send-email-cedric.voncken@acksys.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
References: <1377518692-30084-1-git-send-email-cedric.voncken@acksys.fr>
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Cc: "Johannes Berg" <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	I sent this patch next week, and I have no answer. 
	Is it applied refused? 

	Regards.

	Cedric Voncken
> -----Message d'origine-----
> De : cedric.voncken@acksys.fr [mailto:cedric.voncken@acksys.fr]
> Envoyé : lundi 26 août 2013 14:05
> À : linux-wireless@vger.kernel.org
> Cc : Cedric VONCKEN
> Objet : [PATCH V4] cfg80211: vlan priority handling in WMM
> 
> From: cedric Voncken <cedric.voncken@acksys.fr>
> 
> If the VLAN tci is set in skb->vlan_tci use the priority field to determine the
> WMM priority.
> 
> Signed-off-by: cedric Voncken <cedric.voncken@acksys.fr>
> ---
>  net/wireless/util.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> V2 modifications:
> 	Fix indentation
> 	Use symbolic constant
> 	include the header linux/if_vlan.h
> 
> V3 modifications:
> 	Check the vlan_tci validity with macro vlan_tx_tag_present
> 	Get the vlan_tci field value with macro vlan_tx_tag_get
> 	Request to netdev mailling list to know if the VLAN priority value 0
> must be treated as no priority request. I add the Ben Hutchings reply below:
> 	IEEE 802.1q refers to the definition in 802.1d:
> 
> 	> The user_priority parameter is the priority requested by the
> 	> originating service user. The value of this parameter is in the range
> 	> 0 through 7.
> 	>
> 	> NOTE -- The default user_priority value is 0. Values 1 through 7
> form an
> 	> ordered sequence of user_priorities, with 1 being the lowest value
> and
> 	> 7 the highest. See 7.7.3 and Annex G (informative) for further
> 	> explanation of the use of user_priority values.
> 
> 	So a value of 0 should be treated as no priority request, same as for
> an untagged frame.
> 
> V4 modifications:
> 	Fix patch format
> 
> diff --git a/net/wireless/util.c b/net/wireless/util.c index ce090c1..9e4cac2
> 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -10,6 +10,7 @@
>  #include <net/cfg80211.h>
>  #include <net/ip.h>
>  #include <net/dsfield.h>
> +#include <linux/if_vlan.h>
>  #include "core.h"
>  #include "rdev-ops.h"
> 
> @@ -691,6 +692,7 @@ EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
>  unsigned int cfg80211_classify8021d(struct sk_buff *skb)  {
>  	unsigned int dscp;
> +	unsigned char vlan_priority;
> 
>  	/* skb->priority values from 256->263 are magic values to
>  	 * directly indicate a specific 802.1d priority.  This is used @@ -700,6
> +702,13 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb)
>  	if (skb->priority >= 256 && skb->priority <= 263)
>  		return skb->priority - 256;
> 
> +	if (vlan_tx_tag_present(skb)) {
> +		vlan_priority = (vlan_tx_tag_get(skb) & VLAN_PRIO_MASK)
> +			>> VLAN_PRIO_SHIFT;
> +		if (vlan_priority > 0)
> +			return vlan_priority;
> +	}
> +
>  	switch (skb->protocol) {
>  	case htons(ETH_P_IP):
>  		dscp = ipv4_get_dsfield(ip_hdr(skb)) & 0xfc;
> --
> 1.7.2.5

