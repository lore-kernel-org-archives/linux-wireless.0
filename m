Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3F0NIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 09:08:15 -0400
Message-ID: <1372338492.8160.6.camel@jlt4.sipsolutions.net> (sfid-20130627_150825_538686_170E58EF)
Subject: Re: [PATCHv4 03/18] mac80211: fix timing for 5 MHz and 10 MHz
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 27 Jun 2013 15:08:12 +0200
In-Reply-To: <1372337064-19254-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1372337064-19254-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:

> +static inline int
> +ieee80211_chandef_get_divisor(struct cfg80211_chan_def *chandef)
> +{
> +	switch (local->hw.conf.chandef.width) {
> +	case NL80211_CHAN_WIDTH_5:
> +		return 4;
> +	case NL80211_CHAN_WIDTH_10:
> +		return 2;
> +	default:
> +		return 1;

I wonder if instead of 'divisor' this should be expressed as a 'shift'.

With this variable divisor, the compiler can't know that it'll be 1/2/4,
so it has to actually use a real division when you use DIV_ROUND_UP. A
shift would be faster, it seems?

johannes

