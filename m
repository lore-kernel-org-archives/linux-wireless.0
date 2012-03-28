Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab2C1J2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:28:30 -0400
Message-ID: <1332926906.3479.22.camel@jlt3.sipsolutions.net> (sfid-20120328_112832_325534_D04CC7DA)
Subject: Re: [PATCH] mac80211_hwsim: Report rate info in tx status
From: Johannes Berg <johannes@sipsolutions.net>
To: Timo Lindhorst <tlnd@online.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Date: Wed, 28 Mar 2012 11:28:26 +0200
In-Reply-To: <201203281117.53033.tlnd@online.de>
References: <201203281117.53033.tlnd@online.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-28 at 11:17 +0200, Timo Lindhorst wrote:
>  
> +	if (!ack)
> +		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> +			tx_count[i] = txi->control.rates[i].count;
> +

> +
> +	if (ack) {
...
> +	} else {
> +		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> +			txi->control.rates[i].count = tx_count[i];
> +	}

I don't think I understand why you're copying the same data over itself?

johannes

