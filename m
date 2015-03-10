Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38557 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbbCJQEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:04:42 -0400
Message-ID: <1426003477.1926.5.camel@sipsolutions.net> (sfid-20150310_170454_089776_95131D75)
Subject: Re: [PATCH v2] mac80211: Get IV len from key conf and not cipher
 scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Max Stepanov <Max.Stepanov@intel.com>
Date: Tue, 10 Mar 2015 17:04:37 +0100
In-Reply-To: <5842EA9CC042B141995329508713AD672105A9B0@ILMAIL1.corp.local>
References: <5842EA9CC042B141995329508713AD672105A9B0@ILMAIL1.corp.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure I could follow your discussion...

> @@ -790,14 +789,17 @@ ieee80211_crypto_cs_encrypt(struct 
> ieee80211_tx_data *tx,
>   		return TX_CONTINUE;
>   	}
> 
> -	if (unlikely(skb_headroom(skb) < cs->hdr_len &&
> -		     pskb_expand_head(skb, cs->hdr_len, 0, GFP_ATOMIC)))
> +	if (iv_len == 0)
> +		return TX_CONTINUE;

How can this be correct? You have a cipher scheme, so you want to
encrypt, but now you're not doing that? Perhaps you should drop the
frame instead?

johannes

