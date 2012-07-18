Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2GRG6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 02:58:35 -0400
Message-ID: <1342594716.5310.8.camel@jlt3.sipsolutions.net> (sfid-20120718_085839_469721_7D4EA83D)
Subject: Re: [PATCH V2 2/2] {nl,cfg,mac}80211: Allow user to configure basic
 rates when joining
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, thomas@cozybit.com, devel@lists.open80211s.org
Date: Wed, 18 Jul 2012 08:58:36 +0200
In-Reply-To: <1342586570-522-2-git-send-email-ashok@cozybit.com> (sfid-20120718_064259_657115_0F889420)
References: <1342586570-522-1-git-send-email-ashok@cozybit.com>
	 <1342586570-522-2-git-send-email-ashok@cozybit.com>
	 (sfid-20120718_064259_657115_0F889420)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-17 at 21:42 -0700, Ashok Nagarajan wrote:

> Reviewed-by: Thomas Pedersen <thomas@cozybit.com>

I'd have expected better from you, Thomas :-P


>   * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
> + * @basic_rates: bitmap of basic rates to use when creating the mesh
>   *
>   * These parameters are fixed when the mesh is created.
>   */
> @@ -932,6 +933,7 @@ struct mesh_setup {
>  	bool is_authenticated;
>  	bool is_secure;
>  	int mcast_rate[IEEE80211_NUM_BANDS];
> +	u32 basic_rates;

This doesn't make sense. Why give mcast rate for both bands, but basic
rates only for one band?


> +	if (!setup->basic_rates) {
> +		setup->basic_rates = ieee80211_mandatory_rates(
> +					rdev->wiphy.bands[setup->channel->band],
> +					setup->channel->band);
> +
> +	}

No need for braces nor the extra blank line.


> +	if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES] &&
> +	    !WARN_ON(!wdev->preset_chan)) {

WARN_ON? Really? That doesn't seem right. Also, doesn't the mesh allow
joining with a channel given to the join function, so that preset_chan
will be NULL here?

johannes

