Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab3JNIxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 04:53:37 -0400
Message-ID: <1381740813.13092.9.camel@jlt4.sipsolutions.net> (sfid-20131014_105340_663211_7FD43339)
Subject: Re: [PATCH v2 1/2] cfg80211: add flags to define country IE
 processing rules
From: Johannes Berg <johannes@sipsolutions.net>
To: Mihir Shete <smihir@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Henri Bahini <hbahini@qca.qualcomm.com>,
	Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 14 Oct 2013 10:53:33 +0200
In-Reply-To: <1381638697-2641-2-git-send-email-smihir@qti.qualcomm.com> (sfid-20131013_063205_048348_568E0EC6)
References: <1381638697-2641-1-git-send-email-smihir@qti.qualcomm.com>
	 <1381638697-2641-2-git-send-email-smihir@qti.qualcomm.com>
	 (sfid-20131013_063205_048348_568E0EC6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-10-13 at 10:01 +0530, Mihir Shete wrote:
> 802.11 cards may have different country IE parsing behavioural
> preferences and vendors may want to support these. These preferences
> were managed by the WIPHY_FLAG_CUSTOM_REGULATORY and the
> WIPHY_FLAG_STRICT_REGULATORY flags and their combination.
> Instead of using this existing notation, split out the country
> IE behavioural preferences to a new flag. This will allow
> us to add more customizations easily and make the code more
> maintainable

>  		regd = ath_world_regdomain(reg);
>  		wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
> +		wiphy->country_ie_pref = NL80211_COUNTRY_IE_FOLLOW_POWER;

That seems pretty weird - maybe you should have a first patch that moves
the existing regulatory flags into some new field, and then adds the
country IE flags there? Adding a new flags field for just the country IE
seems odd and less useful for the future.

> + * @country_ie_pref: country IE processing preferences specified
> + *	by enum nl80211_country_ie_pref

That implies you're exporting it to userspace - why?

>  /**
> + * enum nl80211_country_ie_pref - country IE processing preferences

Why is this userspace API if it's not used anywhere as such?

johannes

