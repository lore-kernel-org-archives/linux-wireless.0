Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0FOHS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 03:18:58 -0400
Subject: Re: [PATCH] iw: Configure basic rates when joining ibss network
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1276583053-30638-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276583053-30638-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 09:18:55 +0200
Message-ID: <1276586335.3648.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 09:24 +0300, Teemu Paasikivi wrote:

> @@ -41,6 +46,31 @@ static int join_ibss(struct nl80211_state *state,
>  		argc--;
>  	}
>  
> +	/* basic rates */
> +	if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {
> +		argv++;
> +		argc--;
> +
> +		value = strtok_r(argv[0], ",", &sptr);
> +
> +		while (value && n_rates < NL80211_MAX_SUPP_RATES) {
> +			rate = atof(value);

should that use strtod() to check you didn't give "1a,2b,6c,11d"?

johannes

