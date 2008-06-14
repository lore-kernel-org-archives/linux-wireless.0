Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:44821 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752536AbYFRJnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 05:43:53 -0400
From: bruno randolf <br1@einfach.org>
To: Vladimir Koutny <vlado@work.ksp.sk>
Subject: Re: [PATCH] mac80211: eliminate IBSS warning in rate_lowest_index()
Date: Sat, 14 Jun 2008 20:41:04 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
References: <48528944.2040907@work.ksp.sk>
In-Reply-To: <48528944.2040907@work.ksp.sk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806142041.04146.br1@einfach.org> (sfid-20080618_114358_179019_E8868D60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 June 2008 16:50:44 Vladimir Koutny wrote:
> In IBSS mode prior to join/creation of new IBSS it is possible that
> a frame from unknown station is received and an ibss_add_sta() is
> called. This will cause a warning in rate_lowest_index() since the
> list of supported rates of our station is not initialized yet.
>
> The fix is to add ibss stations with a rate we received that frame
> at; this single-element set will be extended later based on beacon
> data. Also there is no need to store stations from a foreign IBSS.

makes sense.

Acked-by: Bruno Randolf <br1@einfach.org>

> -	sta->supp_rates[local->hw.conf.channel->band] =
> -		sdata->u.sta.supp_rates_bits[local->hw.conf.channel->band];
> +	if (supp_rates)
> +		sta->supp_rates[band] = supp_rates;
> +	else
> +		sta->supp_rates[band] = sdata->u.sta.supp_rates_bits[band];

i'm not sure about that last line. i know, it was like that before - but i 
think we shouldn't assume another station supports the same rates as we do in 
any case. we normally get the supported rates of another station thru the 
beacons we receive. or from received data packets (thanks to this patch).

bruno
