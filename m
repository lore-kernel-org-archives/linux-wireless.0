Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2BXHSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 02:18:14 -0500
Subject: Re: [PATCH] {nl,cfg,mac}80211: Enable control quality monitoring
 for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <1330050621-8955-1-git-send-email-ashok@cozybit.com> (sfid-20120224_033027_978577_9073776C)
References: <1330050621-8955-1-git-send-email-ashok@cozybit.com>
	 (sfid-20120224_033027_978577_9073776C)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 08:18:11 +0100
Message-ID: <1330067891.3426.2.camel@jlt3.sipsolutions.net> (sfid-20120224_081819_346101_FB48DF86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 18:30 -0800, Ashok Nagarajan wrote:
> Mesh peer links are established only if average rssi of the peer
> candidate satisfies the threshold. This is not in 802.11s specification
> but was requested by David Fulgham, an open80211s user. This is a way to avoid
> marginal peer links with stations that are barely within range.
> 
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |    1 +
>  net/mac80211/cfg.c                    |    1 +
>  net/mac80211/mesh_plink.c             |   22 +++++++++++++++++++++-
>  net/wireless/nl80211.c                |    3 ++-
>  4 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 4b9e730..ca7d5a6 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -729,6 +729,7 @@ static int mac80211_hwsim_add_interface(struct ieee80211_hw *hw,
>  		    __func__, ieee80211_vif_type_p2p(vif),
>  		    vif->addr);
>  	hwsim_set_magic(vif);
> +	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_CQM_RSSI;

That isn't right, hwsim does nothing to support CQM.

johannes

