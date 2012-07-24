Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49528 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab2GXHMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 03:12:18 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes\@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>
Date: Tue, 24 Jul 2012 10:12:16 +0300
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>
	(Mahesh Palivela's message of "Mon, 23 Jul 2012 09:17:40 +0000")
Message-ID: <87lii97hv3.fsf@purkki.adurom.net> (sfid-20120724_091222_037516_67D65F0E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mahesh Palivela <maheshp@posedge.com> writes:

> 80MHz Regulatory changes for 11ac.
>
> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>

[...]

> +static bool is_vht80_not_allowed(struct ieee80211_channel *chan)
> +{
> +	if (!chan)
> +		return true;
> +	if (chan->flags & IEEE80211_CHAN_DISABLED)
> +		return true;
> +	/* This would happen when regulatory rules disallow VHT80 completely */
> +	if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & (IEEE80211_CHAN_NO_VHT80)))
> +		return true;
> +	return false;
> +}

I think it's better to change this to is_vht80_allowed(). The
not_allowed might trick someone.

-- 
Kalle Valo
