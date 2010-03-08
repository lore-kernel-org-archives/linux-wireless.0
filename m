Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab0CHIRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 03:17:11 -0500
Subject: Re: [PATCH] ath5k: Fix 64 bits TSF reading.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <1267394932-11038-1-git-send-email-benoit.papillault@free.fr>
References: <4B8AE8F1.40006@free.fr>
	 <1267394932-11038-1-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 09:17:08 +0100
Message-ID: <1268036228.3819.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-02-28 at 23:08 +0100, Benoit Papillault wrote:

> -	u64 tsf = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
> +	u32 tsf_lower, tsf_upper;
> +
> +	/*
> +	 * While reading TSF upper and then lower part, the clock is still
> +	 * counting so the lower part can rollover just after reading the
> +	 * upper part. In this case, we expect the lower part to be quite
> +	 * small (let's say less than 100us) and we would just need to read
> +	 * the upper part again to get the correct value.
> +	 *
> +	 * Tested on AR2425 (AR5001)
> +	 */
> +
> +	tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
> +	tsf_lower = ath5k_hw_reg_read(ah, AR5K_TSF_L32);
> +
> +	if (tsf_lower < 100)
> +		tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);

You would typically do

do {
   read upper 1
   read lower
   read upper 2
} while (upper 1 != upper 2)

or so but that obviously incurs another read in most cases.

johannes

