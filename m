Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1DUGuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 02:50:22 -0400
Subject: Re: [PATCH] cfg80211: module_param to disable HT40 in 2.4GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1303344002-4542-1-git-send-email-bzhao@marvell.com>
References: <1303344002-4542-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 08:50:17 +0200
Message-ID: <1303368617.3597.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-20 at 17:00 -0700, Bing Zhao wrote:

> @@ -651,16 +660,28 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
>  			goto nla_put_failure;
>  
>  		/* add HT info */
> -		if (dev->wiphy.bands[band]->ht_cap.ht_supported) {
> +		if (sband->ht_cap.ht_supported) {
>  			NLA_PUT(msg, NL80211_BAND_ATTR_HT_MCS_SET,
> -				sizeof(dev->wiphy.bands[band]->ht_cap.mcs),
> -				&dev->wiphy.bands[band]->ht_cap.mcs);
> +				sizeof(sband->ht_cap.mcs), &sband->ht_cap.mcs);
> +
> +			/*
> +			 * Since cfg80211_disable_40mhz_24ghz is global, we can
> +			 * modify the sband's ht data even if the driver uses a
> +			 * global structure for that.
> +			 */
> +			if (cfg80211_disable_40mhz_24ghz &&
> +					band == IEEE80211_BAND_2GHZ) {
> +				sband->ht_cap.cap &=
> +					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> +				sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
> +			}
> +
>  			NLA_PUT_U16(msg, NL80211_BAND_ATTR_HT_CAPA,
> -				dev->wiphy.bands[band]->ht_cap.cap);
> +				sband->ht_cap.cap);
>  			NLA_PUT_U8(msg, NL80211_BAND_ATTR_HT_AMPDU_FACTOR,
> -				dev->wiphy.bands[band]->ht_cap.ampdu_factor);
> +				sband->ht_cap.ampdu_factor);
>  			NLA_PUT_U8(msg, NL80211_BAND_ATTR_HT_AMPDU_DENSITY,
> -				dev->wiphy.bands[band]->ht_cap.ampdu_density);
> +				sband->ht_cap.ampdu_density);
>  		}
>  
>  		/* add frequencies */

In send_wiphy? You're kidding, right? NACK. Please try to understand how
the code in mac80211 worked.

johannes

