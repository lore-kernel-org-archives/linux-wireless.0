Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3FZHdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 03:33:51 -0400
Message-ID: <1372232028.8157.1.camel@jlt4.sipsolutions.net> (sfid-20130626_093353_807548_6BB31486)
Subject: Re: [PATCH] wireless: vlan priority handling in WMM
From: Johannes Berg <johannes@sipsolutions.net>
To: cedric.voncken@acksys.fr
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Jun 2013 09:33:48 +0200
In-Reply-To: <1372174262-13526-1-git-send-email-cedric.voncken@acksys.fr> (sfid-20130625_205307_645728_289E3D48)
References: <1372174262-13526-1-git-send-email-cedric.voncken@acksys.fr>
	 (sfid-20130625_205307_645728_289E3D48)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-25 at 17:31 +0200, cedric.voncken@acksys.fr wrote:
> From: Cedric Voncken <cedric.voncken@acksys.fr>
> 
> If the VLAN priority is set in skb->vlan_tci use it to determine the WMM priority.

What's the VLAN priority? How are you even running 802.1q on top of
wifi? heh.

> @@ -694,6 +695,10 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb)
>  	if (skb->priority >= 256 && skb->priority <= 263)
>  		return skb->priority - 256;
>  
> +	vlan_priority = (skb->vlan_tci >> 13) & 0x07;

Are there no symbolic constants for this?

> +		if (vlan_priority > 0)
> +			return vlan_priority;

I think you got indentation a bit confused :-)

johannes

