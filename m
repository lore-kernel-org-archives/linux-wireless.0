Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47535 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbbJHJZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 05:25:40 -0400
Message-ID: <1444296337.2131.9.camel@sipsolutions.net> (sfid-20151008_112551_922725_D52918B1)
Subject: Re: [PATCH] mac80211:  Take bitrates into account when building IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Thu, 08 Oct 2015 11:25:37 +0200
In-Reply-To: <1442610145-8759-1-git-send-email-greearb@candelatech.com>
References: <1442610145-8759-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-09-18 at 14:02 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> If a user restricts the rateset for some reason, then the
> probe requests should not advertise rates that are not
> selected by the user.
> 
> To implement this, we save the requested bitrates at
> the mac80211 level and take it into account when building
> the IEs.
> 
> This allows one to create a more realistic /b mode
> station on modern hardware, for instance.  Good for
> testing, and likely good for other things as well.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  include/net/mac80211.h     |  4 ++
>  net/mac80211/cfg.c         |  3 ++
>  net/mac80211/ieee80211_i.h | 15 ++++++-
>  net/mac80211/scan.c        | 26 ++++++++++++-
>  net/mac80211/util.c        | 97 ++++++++++++++++++++++++++++++++++++++++++----
>  5 files changed, 135 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index d52914b..be069bd 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1838,10 +1838,14 @@ struct ieee80211_hw {
>   * struct ieee80211_scan_request - hw scan request
>   *
>   * @ies: pointers different parts of IEs (in req.ie)
> + * @disable_ht: Ensure nothing related to HT is in the probe request?
> + * @disable_vht: Ensure nothing related to VHT is in the probe request?

what's with the question marks? :)

I don't really see why it should be in this struct - the driver
shouldn't have to access it even for hardware scan?

> +++ b/net/mac80211/cfg.c
> @@ -2466,6 +2466,9 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
>  > 	> if (!ieee80211_sdata_running(sdata))
>  > 	> 	> return -ENETDOWN;
>  
> +> 	> memcpy(&sdata->cfg_bitrate_mask, mask, sizeof(*mask));
> +> 	> sdata->cfg_bitrate_mask_set = true;


I'm not entirely convinced of this ...

The documentation for @NL80211_CMD_SET_TX_BITRATE_MASK doesn't really
state this - it clearly states it's for TX only. Settings it up this
way now might be rather confusing.

Consider P2P for example, the bitrate mask might be set w/o CCK, but
perhaps other networks can be found?

> +> 	> /* Store bitrate mask configured from user-space */
> +> 	> struct cfg80211_bitrate_mask cfg_bitrate_mask;
> +> 	> bool cfg_bitrate_mask_set; /* Has user set the mask? */

I'm also not really happy with such stateful API in general. If you set
this, and forget to reset it ...

Obviously that's already the case for the TX bitrates, but it's
typically used in pretty restricted situations.

Perhaps, for the use case you're considering, it would make more sense
to be able to in general change the device capabilities in some way?

johannes
