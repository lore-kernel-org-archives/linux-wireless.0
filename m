Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab3FROVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 10:21:53 -0400
Message-ID: <1371565283.8318.21.camel@jlt4.sipsolutions.net> (sfid-20130618_162202_089871_42915D47)
Subject: Re: [PATCHv3 05/18] mac80211: fix timing for 5 MHz and 10 MHz
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 18 Jun 2013 16:21:23 +0200
In-Reply-To: <1368702045-27598-6-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1368702045-27598-6-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static inline int
> +ieee80211_hw_get_divisor(struct ieee80211_hw *hw)
> +{
> +	switch (hw->conf.chandef.width) {
> +	case NL80211_CHAN_WIDTH_5:
> +		return 4;
> +	case NL80211_CHAN_WIDTH_10:
> +		return 2;
> +	default:
> +		return 1;
> +	}
> +}

Using this function will break with drivers that use channel contexts,
you really shouldn't do that.

Also, you're disabling HT so why bother changing minstrel_ht?

johannes

