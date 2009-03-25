Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3235 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZCYBIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 21:08:19 -0400
Date: Tue, 24 Mar 2009 21:06:26 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
Message-ID: <20090325010626.GA8528@hash.localnet> (sfid-20090325_020821_987647_6369B00A)
References: <200903241938.47155.chunkeey@web.de> <200903242133.28405.chunkeey@web.de> <20090324205847.GB29268@tesla> <200903242324.33485.chunkeey@web.de> <20090324223022.M51759@bobcopeland.com> <43e72e890903241613x6e6de1ecp909ee6f4156ba709@mail.gmail.com> <43e72e890903241617i629a4c75of573bb7f77572ade@mail.gmail.com> <43e72e890903241652o70aa8e2bjd40a5ae9a4ebc91a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890903241652o70aa8e2bjd40a5ae9a4ebc91a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 04:52:09PM -0700, Luis R. Rodriguez wrote:
> Alright here's a quick concat of all these patches (also one small
> sparse fix on Christian's last patch). It also now throws ath5k, ath9k
> and ar9170 into ath/. We can rename the drivers after, was lazy to do
> that. Think its easier for review to separate that too.
> 
> http://bombadil.infradead.org/~mcgrof/patches/ath/ath-common-v3.patch.txt
> 
> Bob, where was that switch break error?

1st patch:

> +	switch (band) {
> +	case IEEE80211_BAND_2GHZ:
> +		ctl = ah->regulatory.regpair->reg_2ghz_ctl;
> +	case IEEE80211_BAND_5GHZ:
> +		ctl = ah->regulatory.regpair->reg_5ghz_ctl;
> +	default:
> +		ctl = NO_CTL;
> +	}
> +	return ctl;
> +}

I think I had it like the following and changed it -- actually with
the returns it's probably better...

switch (band) {
case XXX:
        return ah->...;
case YYY:
...
}

-- 
Bob Copeland %% www.bobcopeland.com

