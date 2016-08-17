Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43880 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbcHQUaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 16:30:18 -0400
Message-ID: <1471463348.5173.16.camel@sipsolutions.net> (sfid-20160817_223022_421601_4E7BD708)
Subject: Re: [PATCH v2] mac80211: Move crypto IV generation to after TXQ
 dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Wed, 17 Aug 2016 21:49:08 +0200
In-Reply-To: <20160817144531.4285-1-toke@toke.dk> (sfid-20160817_164550_842827_E5D1AFAC)
References: <20160817125800.19154-1-toke@toke.dk>
	 <20160817144531.4285-1-toke@toke.dk> (sfid-20160817_164550_842827_E5D1AFAC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

You need to work on coding style, a lot of your indentation is
completely messed up.

> +	switch (sdata->vif.type) {
> +	case NL80211_IFTYPE_STATION:
> +		if (sdata->u.mgd.use_4addr) {
> +			pn_offs = 30;
> +			break;
> +		}
> +		pn_offs = 24;
> +		break;
> +	case NL80211_IFTYPE_AP_VLAN:
> +		if (sdata->wdev.use_4addr) {
> +			pn_offs = 30;
> +			break;
> +		}
> +		/* fall through */
> +	case NL80211_IFTYPE_ADHOC:
> +	case NL80211_IFTYPE_AP:
> +		pn_offs = 24;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	if (sta->sta.wme) {
> +		pn_offs += 2;
> +	}

I think you just reinvented ieee80211_hdrlen(). No?

> -	if (fast_tx->pn_offs) {
> -		u64 pn;
> -		u8 *crypto_hdr = skb->data + fast_tx->pn_offs;

No need to undo the pn_offs optimisation for the !txq case, you can
pass it in to the new function that will fill it.

However, you're still doing it wrong - now you haven't fixed anything
for TKIP, which won't hit the fastpath.

johannes
