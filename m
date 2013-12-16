Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab3LPPJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:09:30 -0500
Message-ID: <1387206567.2057.21.camel@jlt4.sipsolutions.net> (sfid-20131216_160934_082643_4B191458)
Subject: Re: [PATCH v2] mac80211: add helper functions for tracking P2P NoA
 state
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 16:09:27 +0100
In-Reply-To: <1386626388-45880-1-git-send-email-nbd@openwrt.org>
References: <1386626388-45880-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-09 at 22:59 +0100, Felix Fietkau wrote:

> +static u32
> +ieee80211_get_noa_absent_time(struct ieee80211_noa_data *data, u32 tsf)
> +{
> +	s32 offset = 0;
> +	int tries = 0;
> +
> +	ieee80211_extend_absent_time(data, tsf, &offset);
> +	do {
> +		if (!ieee80211_extend_absent_time(data, tsf, &offset))
> +			break;
> +
> +		tries++;
> +	} while (tries < 5);

What's "tries < 5"?

johannes

