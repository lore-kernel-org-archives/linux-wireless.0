Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2ATOSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 09:18:00 -0500
Subject: Re: [PATCH RESEND] mac80211: support fixed rate packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@chromium.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20120119182033.5F60358073@lefflers.sfo.corp.google.com> (sfid-20120119_192053_053697_DFEA50C5)
References: <20120119182033.5F60358073@lefflers.sfo.corp.google.com>
	 (sfid-20120119_192053_053697_DFEA50C5)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jan 2012 15:17:33 +0100
Message-ID: <1327069053.9857.3.camel@jlt3.sipsolutions.net> (sfid-20120120_151804_462814_EA8FCE49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-12 at 09:53 -0800, Sam Leffler wrote:

> +	if (fixed_rate != -1) {
> +		struct ieee80211_channel *chan = local->hw.conf.channel;
> +		struct ieee80211_supported_band *sband =
> +			local->hw.wiphy->bands[chan->band];
> +		struct ieee80211_tx_rate *rates = info->control.rates;
> +		int i;
> +
> +		if (fixed_rate_flags & IEEE80211_TX_RC_MCS) {
> +			WARN_ON(!sband->ht_cap.ht_supported);
> +			rates[0].idx = fixed_rate;

Unless I missed something, this would be *trivial* to trigger by
injection -- doesn't seem like a good idea to me.

johannes


