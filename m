Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaC1NFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:05:48 -0400
Message-ID: <1396011945.4175.23.camel@jlt4.sipsolutions.net> (sfid-20140328_140551_496534_A18ED09C)
Subject: Re: [PATCH v2 01/13] cfg80211: allow drivers to iterate over
 matching combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 14:05:45 +0100
In-Reply-To: <1395409651-26120-2-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145331_687810_B9ED767F)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_145331_687810_B9ED767F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:

> +int cfg80211_iter_combinations(struct wiphy *wiphy,
> +			       const int num_different_channels,
> +			       const u8 radar_detect,
> +			       const int iftype_num[NUM_NL80211_IFTYPES],
> +			       void (*iter)(const struct ieee80211_iface_combination *c,
> +					    void *data),
> +			       void *data);

Maybe *iter should have a non-void return value and allow aborting the
loop somehow?

> +static void
> +cfg80211_iter_sum_ifcombs(const struct ieee80211_iface_combination *c,
> +			  void *data)
> +{
> +	int *num = data;
> +	(*num)++;
> +}
> +
> +int cfg80211_check_combinations(struct wiphy *wiphy,
> +				const int num_different_channels,
> +				const u8 radar_detect,
> +				const int iftype_num[NUM_NL80211_IFTYPES])
> +{
> +	int err, num = 0;
> +
> +	err = cfg80211_iter_combinations(wiphy, num_different_channels,
> +					 radar_detect, iftype_num,
> +					 cfg80211_iter_sum_ifcombs, &num);
> +	if (err)
> +		return err;
> +	if (num == 0)
> +		return -EBUSY;
> +
> +	return 0;
>  }

This also seems a bit pointless - why not just have an int instead of
num and set it to -EBUSY outside, and to 0 inside, and then just return
it? You don't need the number of available combinations.

johannes

