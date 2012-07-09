Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2GIQyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 12:54:04 -0400
Message-ID: <1341852841.4455.51.camel@jlt3.sipsolutions.net> (sfid-20120709_185408_709627_30099A08)
Subject: Re: [PATCH] mac80211: fix invalid band deref building preq IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 18:54:01 +0200
In-Reply-To: <1341852581-8456-1-git-send-email-arik@wizery.com> (sfid-20120709_184946_798984_856287AB)
References: <1341852581-8456-1-git-send-email-arik@wizery.com>
	 (sfid-20120709_184946_798984_856287AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 19:49 +0300, Arik Nemtsov wrote:
> The function building probe-request IEs does not validate the band is
> supported before dereferencing it. This can result in a panic when
> all bands are traversed, as done during sched-scan start.
> 
> Warn when this happens and return an empty probe request. Also fix
> sched-scan to not waste memory on unsupported bands.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> This is not cc stable since the panic only started happening once
> the 60Ghz band was added. Apparently all sched-scan drivers supported
> all possible bands until then.
> 
> 
>  net/mac80211/scan.c |    3 +++
>  net/mac80211/util.c |    2 ++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 379f178..1ff04f6 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -928,6 +928,9 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
>  	}
>  
>  	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
> +		if (!local->hw.wiphy->bands[i])
> +			continue;
> +
>  		local->sched_scan_ies.ie[i] = kzalloc(2 +
>  						      IEEE80211_MAX_SSID_LEN +
>  						      local->scan_ies_len +
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 64493a7..503412a 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -999,6 +999,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
>  	int ext_rates_len;
>  
>  	sband = local->hw.wiphy->bands[band];
> +	if (!WARN_ON_ONCE(sband))
> +		return 0;

That's not right :-)

johannes

