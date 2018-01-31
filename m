Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58060 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753159AbeAaVuS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 16:50:18 -0500
Message-ID: <1517435416.2189.65.camel@sipsolutions.net> (sfid-20180131_225022_180114_7A0B1DDC)
Subject: Re: [PATCH 4/6] mac80211: Send control port frames over nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 31 Jan 2018 22:50:16 +0100
In-Reply-To: <20180131213329.25322-5-denkenz@gmail.com> (sfid-20180131_223355_270289_971C06E1)
References: <20180131213329.25322-1-denkenz@gmail.com>
         <20180131213329.25322-5-denkenz@gmail.com>
         (sfid-20180131_223355_270289_971C06E1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-31 at 15:33 -0600, Denis Kenzior wrote:
> 
> +		if (!cfg80211_rx_control_port(dev, skb->data, skb->len,
> +					      ehdr->h_source,
> +					      be16_to_cpu(skb->protocol),
> +					      noencrypt))
> +			dev_kfree_skb(skb);

Err, you should free it unconditionally, no? You don't do anything with
the skb afterwards, since you can't get into the else branch and
deliver it to the netdev now, so afaict it'd be leaked if not freed?

Which explains why you didn't notice the error in the previous patch,
it was making this code correct by freeing it all the time (never
hitting an error, presumably, and even if you wouldn't notice the small
leaks)

johannes
