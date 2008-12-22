Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41867 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbYLVH1F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 02:27:05 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2008 23:27:05 -0800
Date: Mon, 22 Dec 2008 12:55:02 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] [RFC v2] mac80211: Scale down to non-HT association
	with TKIP/WEP as pairwise cipher
Message-ID: <20081222072502.GB27816@vasanth-lnx.users.atheros.com> (sfid-20081222_082711_429729_5E4DD0AE)
References: <1229927497-30923-1-git-send-email-vasanth@atheros.com> <1229928585.3087.1.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1229928585.3087.1.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 12:19:45PM +0530, Johannes Berg wrote:
> > +	case IW_AUTH_CIPHER_PAIRWISE:
> > +		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> > +			if (data->value & (IW_AUTH_CIPHER_WEP40 |
> > +			    IW_AUTH_CIPHER_WEP104 | IW_AUTH_CIPHER_TKIP))
> > +				sdata->u.sta.flags |=
> > +					IEEE80211_STA_TKIP_WEP_USED;
> > +			else
> > +				sdata->u.sta.flags &=
> > +					~IEEE80211_STA_TKIP_WEP_USED;
> > +		}
> > +		break;
> 
> I still think you might need to put something into cfg.c. 

I could not find a hook in cfg.c which is meant for configuring negotiated
pairwise cipher into driver. You mean add_key() ?, which configures
the key after the association.

> Can't we check the key algorithm for the pairwise key associated 
> with the AP's sta_info directly in _send_assoc?

In that case, I might need to introduce one more entry in
enum ieee80211_key_alg called ALG_NONE. When we have a new
entry in enum, we might end up handling that in all the case
statements wherever this enum is used (quite a few places in
mac80211 and almost all the drivers) to
mute compilation warnings.

Vasanth


