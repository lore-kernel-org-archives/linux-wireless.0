Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab2CTNqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 09:46:19 -0400
Subject: Re: [RFC 01/12] mac80211: prepare ieee80211_mandatory_rates to
 per-vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <add0a349-9bf4-4278-bc1d-25b34892b8e1@FIVLA-EXHUB02.eu.tieto.com>
References: <add0a349-9bf4-4278-bc1d-25b34892b8e1@FIVLA-EXHUB02.eu.tieto.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 14:46:19 +0100
Message-ID: <1332251179.3329.26.camel@jlt3.sipsolutions.net> (sfid-20120320_144631_821781_C8950B06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 08:36 +0100, Michal Kazior wrote:

> -u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
> +u32 ieee80211_mandatory_rates(struct ieee80211_sub_if_data *sdata,
>  			      enum ieee80211_band band)
>  {
> +	struct ieee80211_local *local = sdata->local;
>  	struct ieee80211_supported_band *sband;
>  	struct ieee80211_rate *bitrates;
>  	u32 mandatory_rates;

This doesn't make a lot of sense -- it's only used for a fallback path
that never triggers so we can just remove that path.

johannes

