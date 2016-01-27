Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48600 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555AbcA0O1C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 09:27:02 -0500
Message-ID: <1453904819.2351.7.camel@sipsolutions.net> (sfid-20160127_152706_374919_F898E305)
Subject: Re: [PATCH v2] mac80211: expose txq queue depth and size to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 27 Jan 2016 15:26:59 +0100
In-Reply-To: <1453904772-25289-1-git-send-email-michal.kazior@tieto.com> (sfid-20160127_152508_654339_7FE9E06C)
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
	 <1453904772-25289-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160127_152508_654339_7FE9E06C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 15:26 +0100, Michal Kazior wrote:
> 
> @@ -1294,6 +1298,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct
> ieee80211_hw *hw,
>  	if (!skb)
>  		goto out;
>  
> +	txqi->byte_cnt -= skb->len;
> +
>  	atomic_dec(&sdata->txqs_len[ac]);
> 
This *looks* a bit worrying - you have an atomic dec for the # of
packets and a non-atomic one for the bytes.

You probably thought about it and I guess it's fine, but can you
explain it?

johannes
