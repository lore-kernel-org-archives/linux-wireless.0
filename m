Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54339 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0KIVo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 16:44:59 -0500
Date: Tue, 9 Nov 2010 16:40:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	helmut.schaa@googlemail.com
Subject: Re: [PATCH 2/2] mac80211: Add support for CQM tx bitrate monitoring
Message-ID: <20101109214045.GF2374@tuxdriver.com>
References: <201010211402.43857.helmut.schaa@googlemail.com>
 <20101021161006.CF75720391@glenhelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20101021161006.CF75720391@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 21, 2010 at 08:58:12AM -0700, Paul Stewart wrote:
> Am Donnerstag 21 Oktober 2010 schrieb Helmut Schaa:
> > You might want to filter out probe frames based on
> > IEEE80211_TX_CTL_RATE_CTRL_PROBE as otherwise you could end up with
> > sending a huge number of events to userspace.
> 
> Thanks, Helmut.  I've incorporated your excellent suggestion.  In practice
> I have gotten reasonably modest rates of updates at the user side, but
> filtering unnecessary stuff is definitely worthwhile.
> 
> --
> 
> Add state, work proc and debugging parameters for monitoring
> transmit-rate changes.
> 
> Signed-off-by: Paul Stewart <pstew@google.com>

> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 3153c19..22c2c61 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -154,6 +154,24 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
>  		}
>  
>  		ieee80211_queue_work(&local->hw, &local->recalc_smps);
> +	} else if (ieee80211_is_data(mgmt->frame_control) &&
> +		   sdata->vif.type == NL80211_IFTYPE_STATION &&
> +                   !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
> +		struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> +		if (ifmgd->cqm_bitrate_thold != 0 &&
> +		    (ifmgd->last_cqm_tx_rate.idx != sta->last_tx_rate.idx ||
> +		     (ifmgd->last_cqm_tx_rate.flags &
> +		      (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_40_MHZ_WIDTH |
> +		       IEEE80211_TX_RC_SHORT_GI)) !=
> +		     (sta->last_tx_rate.flags &
> +		      (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_40_MHZ_WIDTH |
> +		       IEEE80211_TX_RC_SHORT_GI)) ||
> +		     sdata->u.mgd.last_cqm_bitrate == 0)) {
> +			ifmgd->last_cqm_tx_rate = sta->last_tx_rate;
> +			ifmgd->tx_bitrate_changed = true;
> +			ieee80211_queue_work(&local->hw,
> +					     &ifmgd->bitrate_notify_work);
> +		}
>  	}
>  }

  CC [M]  net/mac80211/status.o
net/mac80211/status.c: In function ‘ieee80211_frame_acked’:
net/mac80211/status.c:159: error: ‘info’ undeclared (first use in this function)
net/mac80211/status.c:159: error: (Each undeclared identifier is reported only once
net/mac80211/status.c:159: error: for each function it appears in.)
make[1]: *** [net/mac80211/status.o] Error 1
make: *** [net/mac80211/] Error 2

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
