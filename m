Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42047 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2GRGz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 02:55:28 -0400
Message-ID: <1342594528.5310.5.camel@jlt3.sipsolutions.net> (sfid-20120718_085530_770717_7FC5CC99)
Subject: Re: [PATCH V2 1/2] {cfg,mac}80211: utility function for calculating
 mandatory rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, thomas@cozybit.com, devel@lists.open80211s.org
Date: Wed, 18 Jul 2012 08:55:28 +0200
In-Reply-To: <1342586570-522-1-git-send-email-ashok@cozybit.com> (sfid-20120718_064259_183994_3D509197)
References: <1342586570-522-1-git-send-email-ashok@cozybit.com>
	 (sfid-20120718_064259_183994_3D509197)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-17 at 21:42 -0700, Ashok Nagarajan wrote:

> + */
> +
> +u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,

Please remove the blank line and document the return value.


> +u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
> +			      enum ieee80211_band band)

Passing both the band enum and the sband doesn't make a lot of sense.

> +{
> +	struct ieee80211_rate *bitrates;
> +	u32 mandatory_rates = 0;
> +	enum ieee80211_rate_flags mandatory_flag;
> +	int i;
> +
> +	if (WARN_ON(!sband))
> +		return 1;
> +
> +	bitrates = sband->bitrates;
> +	if (band == IEEE80211_BAND_5GHZ)
> +		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
> +	else {
> +		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
> +		for (i = 0; i < sband->n_bitrates; i++)
> +			if (bitrates[i].bitrate > 110) {
> +				mandatory_flag =
> +					IEEE80211_RATE_MANDATORY_G;
> +				break;
> +			}
> +	}

You're not just moving the function but also changing the logic in it,
it'd be better to do in separate patches I think.

johannes

