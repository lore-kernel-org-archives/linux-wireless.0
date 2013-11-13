Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3KMVUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 16:20:47 -0500
Message-ID: <1384377637.28806.14.camel@jlt4.sipsolutions.net> (sfid-20131113_222050_042134_92A0FD88)
Subject: Re: [RFC 1/5] cfg80211: pass the wdev on the country IE regulatory
 hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 13 Nov 2013 22:20:37 +0100
In-Reply-To: <1384366379-25301-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191306_798798_A7D706F7)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131113_191306_798798_A7D706F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> This also records the wdev on the last regulatory request,
> this can be used later to help quiesce wdev's at appropriate
> times by the regulatory core.

> +++ b/net/wireless/reg.c
> @@ -1871,12 +1871,14 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
>  }
>  EXPORT_SYMBOL(regulatory_hint);
>  
> -void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
> +void regulatory_hint_country_ie(struct wireless_dev *wdev,
> +				enum ieee80211_band band,
>  				const u8 *country_ie, u8 country_ie_len)
...
> +       request->wdev = wdev;
> 
You have absolutely no validation of this pointer - the lifetime of the
request object and the wdev aren't necessarily the same.

At least you should very carefully document that this pointer is a
cookie (if it really is) and must never be dereferenced.

johannes

