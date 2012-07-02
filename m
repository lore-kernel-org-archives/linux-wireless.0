Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59087 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2GBOW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 10:22:26 -0400
Received: by yenl2 with SMTP id l2so4105369yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 07:22:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341210756-11054-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1341210756-11054-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Mon, 2 Jul 2012 17:22:10 +0300
Message-ID: <CA+XVXfduVieZEVF4eav+K+YHv=B+VoTjZmquMtOrg6XPKVVkOA@mail.gmail.com> (sfid-20120702_162248_172605_00BBC0FA)
Subject: Re: [PATCH 60g v2 1/5] wireless: add 802.11ad (60gHz band)
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 2, 2012 at 9:32 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> Add enumerations for both cfg80211 and nl80211.
> This expands wiphy.bands etc. arrays.
>
> Extend channel <-> frequency translation to cover 60g band
>
> Small fix for mac80211/tx.c required to fix compiler warning
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  include/linux/nl80211.h |    2 ++
>  include/net/cfg80211.h  |    2 ++
>  net/mac80211/tx.c       |    2 ++
>  net/wireless/util.c     |   30 ++++++++++++++++++++++--------
>  4 files changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index c0fc5d2..679831e 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -2539,10 +2539,12 @@ enum nl80211_tx_rate_attributes {
>   * enum nl80211_band - Frequency band
>   * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
>   * @NL80211_BAND_5GHZ: around 5 GHz band (4.9 - 5.7 GHz)
> + * @NL80211_BAND_60GHZ: around 60 GHz band (58.32 - 64.80 GHz)
>   */
>  enum nl80211_band {
>         NL80211_BAND_2GHZ,
>         NL80211_BAND_5GHZ,
> +       NL80211_BAND_60GHZ,
>  };

There's some code in cfg80211.h that uses this value:

enum ieee80211_band {
	IEEE80211_BAND_2GHZ = NL80211_BAND_2GHZ,
	IEEE80211_BAND_5GHZ = NL80211_BAND_5GHZ,

	/* keep last */
	IEEE80211_NUM_BANDS
};

If the 60Ghz band goes here as well, IEEE80211_NUM_BANDS will be
incremented. I'm guessing this can be problematic for a lot of drivers
that use this value more or less blindly (and pass indices to FW etc).
At least the wlcore driver will be impacted.

So this probably should be added, but maybe keep IEEE80211_NUM_BANDS
the same for legacy reasons?

Arik
