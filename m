Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1HaGiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:38:00 -0400
Subject: Re: [PATCH v2 2/4] cfg80211: Add cfg80211_get_bss_ht to also match
 HT configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <5559682.keg4y6PyKd@alex-1> (sfid-20110829_163151_961847_63AD57DE)
References: <2053881.ENil2Dy3QM@alex-1>  <5559682.keg4y6PyKd@alex-1>
	 (sfid-20110829_163151_961847_63AD57DE)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 08:37:57 +0200
Message-ID: <1314772677.4161.14.camel@jlt3.sipsolutions.net> (sfid-20110831_083803_468291_DBA63CB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-29 at 16:30 +0200, Alexander Simon wrote:

> +/**
> + * cfg80211_get_bss_ht - search for an BSS in scan results
> + * @wiphy: the wiphy
> + * @bssid: BSSID to match, if set
> + * @ssid: SSID to match
> + * @ssid_len: length of the SSID
> + * @capa_mask: AND mask for capabilities comparison
> + * @capa_val: SSID capabilities to match
> + * @check_ht: if to match for an HT mode
> + * @ht_mode: HT mode to match
> + *
> + * Return the first BSS found in the last scan.
> + * No match return NULL.
> + */
> +struct cfg80211_bss *
> +cfg80211_get_bss_ht(struct wiphy *wiphy, struct ieee80211_channel *channel,
> +		    const u8 *bssid, const u8 *ssid, size_t ssid_len,
> +		    u16 capa_mask, u16 capa_val, bool check_ht,
> +		    enum nl80211_channel_type ht_mode);
> +
> +struct cfg80211_bss *
> +cfg80211_get_bss(struct wiphy *wiphy, struct ieee80211_channel *channel,
> +		 const u8 *bssid, const u8 *ssid, size_t ssid_len,
> +		 u16 capa_mask, u16 capa_val);

Make this an inline now.

I'm not happy. I told you this before. Next time I'm just going to say
"read my previous comments".

johannes

