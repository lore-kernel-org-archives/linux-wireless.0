Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1JLIZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:25:58 -0400
Subject: Re: [RFC 06/07] compat-wireless: UAPSD configuration in STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
In-Reply-To: <op.v27ru00wya27un@edmitar> (sfid-20111012_030257_788340_E3ADB568)
References: <op.v27ru00wya27un@edmitar>
	 (sfid-20111012_030257_788340_E3ADB568)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:25:55 +0200
Message-ID: <1318407955.3933.23.camel@jlt3.sipsolutions.net> (sfid-20111012_102601_133126_7506D561)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-12 at 03:02 +0200, Dmitry Tarnyagin wrote:
> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Date: Wed, 3 Aug 2011 09:46:05 +0200
> 
> This patch adds UAPSD queues configuration as a param to assoc request.
> With the patch it's possible to configure UAPSD from user space.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>   include/linux/nl80211.h |    2 ++
>   include/net/cfg80211.h  |    1 +
>   net/mac80211/main.c     |    3 ++-
>   net/mac80211/mlme.c     |    2 ++
>   net/wireless/core.h     |    6 ++++--
>   net/wireless/mlme.c     |   10 +++++++---
>   net/wireless/nl80211.c  |    7 ++++++-
>   net/wireless/sme.c      |    2 +-
>   8 files changed, 25 insertions(+), 8 deletions(-)

This is a rare case where *maybe* it's OK to do both mac80211 and
cfg80211 in one patch, but I haven't seen much evidence from all of you
that you really understand the separation, so I'd prefer if you split it
up and explained the changes separately.

> +++ b/include/net/cfg80211.h
> @@ -1050,6 +1050,7 @@ struct cfg80211_assoc_request {
>   	size_t ie_len;
>   	struct cfg80211_crypto_settings crypto;
>   	bool use_mfp;
> +	int uapsd;

int? explain. also you're obviously missing documentation that would
have explained this.

> -	local->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
> +	/* Disable all UAPSD AC by default */
> +	local->uapsd_queues = 0;

You should obviously then remove the default constant, or better yet
just set it to 0. Also _that_ specific change needs to be a separate
change since it modifies existing behaviour.


> +	if (info->attrs[NL80211_ATTR_UAPSD])
> +		uapsd = nla_get_u32(info->attrs[NL80211_ATTR_UAPSD]);

clearly missing validation.

> +++ b/net/wireless/sme.c
> @@ -190,7 +190,7 @@ static int cfg80211_conn_do_work(struct wireless_dev  
> *wdev)
>   					    prev_bssid,
>   					    params->ssid, params->ssid_len,
>   					    params->ie, params->ie_len,
> -					    false, &params->crypto);
> +					    false, &params->crypto, -1);
>   		if (err)
>   			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
>   					       NULL, 0,

Really? Why should this not be able to do uapsd with the same way?

johannes

