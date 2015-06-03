Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:58557 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752951AbbFCGfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 02:35:18 -0400
Message-ID: <1433313312.4861.119.camel@perches.com> (sfid-20150603_083524_961289_5EE2B382)
Subject: Re: [RFC] mac80211: convert HW flags to unsigned long bitmap
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, gregory.greenman@intel.com,
	Johannes Berg <johannes.berg@intel.com>
Date: Tue, 02 Jun 2015 23:35:12 -0700
In-Reply-To: <1433273994-14430-1-git-send-email-johannes@sipsolutions.net>
References: <1433273994-14430-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-02 at 21:39 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> As we're running out of hardware capability flags pretty quickly,
> convert them to use the regular test_bit() style unsigned long
> bitmaps.

I think this is nice, thanks.

> diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
[]
> @@ -1369,9 +1369,9 @@ static void adm8211_configure_filter(struct ieee80211_hw *dev,
[]
> -		dev->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
> +		ieee80211_hw_set(dev, RX_INCLUDES_FCS);
[]
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
[]
> @@ -1889,35 +1889,38 @@ struct ieee80211_txq {
[]
>  enum ieee80211_hw_flags {
> -	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
> -	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
[]
> +	IEEE80211_HW_HAS_RATE_CONTROL,
> +	IEEE80211_HW_RX_INCLUDES_FCS,

It may be nicer to use specified bit numbers here.

It may make compatibility easier and maybe it should be
written down that new entries are only to be added at
the bottom of the enum and not inserted in the middle.

[]

> +static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
> +				       enum ieee80211_hw_flags flg)
> +{
> +	return test_bit(flg, hw->flags);
> +}
> +#define ieee80211_hw_check(hw, flg)	_ieee80211_hw_check(hw, IEEE80211_HW_##flg)
> +
> +static inline void _ieee80211_hw_set(struct ieee80211_hw *hw,
> +				     enum ieee80211_hw_flags flg)
> +{
> +	return __set_bit(flg, hw->flags);
> +}

This is similar to the broadcom tg3 driver, but a little different.

The mechanism in tg3 compared to ieee80211_hw is
	tg3_flag	ieee80211_hw_check
	tg3_flag_set	ieee80211_hw_set
	tg3_flag_clear	?

Would a ieee80211_hw_clear be useful?
Would it be clearer without the _check?

>  static ssize_t hwflags_read(struct file *file, char __user *user_buf,
>  			    size_t count, loff_t *ppos)
>  {
[]
> +	for (i = 0; i < NUM_IEEE80211_HW_FLAGS; i++) {
> +		if (test_bit(i, local->hw.flags))

Maybe use the ieee80211_hw_check() function?


