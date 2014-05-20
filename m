Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:54868 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaETI1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 04:27:09 -0400
Received: by mail-la0-f44.google.com with SMTP id hr17so105390lab.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 01:27:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399798250-20987-3-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com> <1399798250-20987-3-git-send-email-emmanuel.grumbach@intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 01:26:45 -0700
Message-ID: <CAB=NE6XOm1EK5CMc8N1xfdKeXcfxRuyCZQtUXQGC3wyGXudAEQ@mail.gmail.com> (sfid-20140520_102725_976074_22309144)
Subject: Re: [PATCH 2/7] cfg80211: introduce regulatory flags controlling bw
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 11, 2014 at 1:50 AM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Arik Nemtsov <arik@wizery.com>
>
> Allow setting bandwidth related regulatory flags. These flags are mapped
> to the corresponding channel flags in the specified range.
> Make sure the new flags are consulted when calculating the maximum
> bandwidth allowed by a regulatory-rule.
>
> Also allow propagating the GO_CONCURRENT modifier from a reg-rule to a
> channel.
>
> Change-Id: I1b0506ab332cdd268cbf4b02e03574f5c30ba5c0
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  include/uapi/linux/nl80211.h | 12 ++++++++++++
>  net/wireless/reg.c           | 30 ++++++++++++++++++++++++++++--
>  2 files changed, 40 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 406010d..f332231 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2558,6 +2558,11 @@ enum nl80211_sched_scan_match_attr {
>   * @NL80211_RRF_AUTO_BW: maximum available bandwidth should be calculated
>   *     base on contiguous rules and wider channels will be allowed to cross
>   *     multiple contiguous/overlapping frequency ranges.
> + * @NL80211_RRF_GO_CONCURRENT: See &NL80211_FREQUENCY_ATTR_GO_CONCURRENT
> + * @NL80211_RRF_NO_HT40MINUS: channels can't be used in HT40- operation
> + * @NL80211_RRF_NO_HT40PLUS: channels can't be used in HT40+ operation
> + * @NL80211_RRF_NO_80MHZ: 80MHz operation not allowed
> + * @NL80211_RRF_NO_160MHZ: 160MHz operation not allowed
>   */
>  enum nl80211_reg_rule_flags {
>         NL80211_RRF_NO_OFDM             = 1<<0,
> @@ -2570,11 +2575,18 @@ enum nl80211_reg_rule_flags {
>         NL80211_RRF_NO_IR               = 1<<7,
>         __NL80211_RRF_NO_IBSS           = 1<<8,
>         NL80211_RRF_AUTO_BW             = 1<<11,
> +       NL80211_RRF_GO_CONCURRENT       = 1<<12,
> +       NL80211_RRF_NO_HT40MINUS        = 1<<13,
> +       NL80211_RRF_NO_HT40PLUS         = 1<<14,
> +       NL80211_RRF_NO_80MHZ            = 1<<15,
> +       NL80211_RRF_NO_160MHZ           = 1<<16,
>  };

Automatic calculation on max bandwidth scales better, I'd much prefer
these only be used and properly documented to only be used in cases
where we want to be explicit about this, I don't think this should be
the automatic behavior, or at least your patch in no way explains any
justification as to why the move is being done, so I cannot guess what
the logic was here.

>  #define NL80211_RRF_PASSIVE_SCAN       NL80211_RRF_NO_IR
>  #define NL80211_RRF_NO_IBSS            NL80211_RRF_NO_IR
>  #define NL80211_RRF_NO_IR              NL80211_RRF_NO_IR
> +#define NL80211_RRF_NO_HT40            (NL80211_RRF_NO_HT40MINUS |\
> +                                        NL80211_RRF_NO_HT40PLUS)
>
>  /* For backport compatibility with older userspace */
>  #define NL80211_RRF_NO_IR_ALL          (NL80211_RRF_NO_IR | __NL80211_RRF_NO_IBSS)
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 558b0e3..efd6d0d 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -572,8 +572,9 @@ static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
>         return get_cfg80211_regdom();
>  }
>
> -unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
> -                                  const struct ieee80211_reg_rule *rule)
> +static unsigned int
> +reg_get_max_bandwidth_from_range(const struct ieee80211_regdomain *rd,
> +                                const struct ieee80211_reg_rule *rule)

This change is renaming a routine we used heavily to something tucked
in the closet and then introducing the usage of the new flags, which
have no justifications nor proper regdb updates, this also doesn't
even account for the old regdb situations so I'll have to provide a
huge NACK for all these reasons.

You want to consider wireless-regdb / CRDA when making these changes.

  Luis
