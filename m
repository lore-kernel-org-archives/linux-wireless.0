Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34959 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbdALCko (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 21:40:44 -0500
Received: by mail-pf0-f181.google.com with SMTP id f144so4270019pfa.2
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2017 18:40:44 -0800 (PST)
Subject: Re: mac80211: Fix headroom allocation when forwarding mesh pkt
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
References: <e3b7a95724944c6aadc8512eadfe1c1d@ceva-dsp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <74c98387-69d7-39c3-d4bb-8d8a3dcfc71c@gmail.com> (sfid-20170112_034048_616218_D5E235EE)
Date: Thu, 12 Jan 2017 11:40:41 +0900
MIME-Version: 1.0
In-Reply-To: <e3b7a95724944c6aadc8512eadfe1c1d@ceva-dsp.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017/01/11 23:39, Cedric Izoard wrote:
> -	fwd_skb = skb_copy_expand(skb, local->tx_headroom, 0, GFP_ATOMIC);
> +	fwd_skb = skb_copy_expand(skb, local->tx_headroom +
> +				  sdata->encrypt_headroom, 0, GFP_ATOMIC);
>  	if (!fwd_skb) {
>  		net_info_ratelimited("%s: failed to clone mesh frame\n",
>  				    sdata->name);
>

# I retransmit this because of server error.

Thanks ! It work for me.

Bisected-reported-and-tested-by: Masashi Honma <masashi.honma@gmail.com>

Masashi Honma.
