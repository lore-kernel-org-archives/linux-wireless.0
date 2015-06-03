Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33051 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbbFCA5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 20:57:44 -0400
Received: by igbpi8 with SMTP id pi8so99518680igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 17:57:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433273994-14430-1-git-send-email-johannes@sipsolutions.net>
References: <1433273994-14430-1-git-send-email-johannes@sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 3 Jun 2015 10:57:23 +1000
Message-ID: <CAGRGNgV_4axC8Cq5AYkd7RQdJOnrT_9L85qisrrZnKYHyUEczQ@mail.gmail.com> (sfid-20150603_025748_083176_0D78CDAC)
Subject: Re: [RFC] mac80211: convert HW flags to unsigned long bitmap
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	gregory.greenman@intel.com, Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Minor nit:

On Wed, Jun 3, 2015 at 5:39 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> As we're running out of hardware capability flags pretty quickly,
> convert them to use the regular test_bit() style unsigned long
> bitmaps.
>
> This introduces a number of helper functions/macros to set and to
> test the bits, along with new debugfs code.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index e09a32cb139f..dc56734d0154 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2050,6 +2053,20 @@ struct ieee80211_hw {
>         int txq_ac_max_pending;
>  };
>
> +static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
> +                                      enum ieee80211_hw_flags flg)
> +{
> +       return test_bit(flg, hw->flags);
> +}
> +#define ieee80211_hw_check(hw, flg)    _ieee80211_hw_check(hw, IEEE80211_HW_##flg)
> +
> +static inline void _ieee80211_hw_set(struct ieee80211_hw *hw,
> +                                    enum ieee80211_hw_flags flg)
> +{
> +       return __set_bit(flg, hw->flags);
> +}
> +#define ieee80211_hw_set(hw, flg)      _ieee80211_hw_set(hw, IEEE80211_HW_##flg)
> +

Why not add a ieee80211_hw_clear() function? Yes, it'd only be used in
3 places, but it'd look neater.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
