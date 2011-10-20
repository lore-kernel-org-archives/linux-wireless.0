Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39313 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab1JTJqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 05:46:18 -0400
Received: by bkbzt19 with SMTP id zt19so3303565bkb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 02:46:17 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Pedersen <thomas@cozybit.com>
Subject: Re: [PATCH 4/6] mac80211: allow frame aggregation for mesh
Date: Thu, 20 Oct 2011 11:46:00 +0200
Cc: linux-wireless@vger.kernel.org, anagar6@uic.edu,
	devel@lists.open80211s.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com> <1319072606-28291-5-git-send-email-thomas@cozybit.com>
In-Reply-To: <1319072606-28291-5-git-send-email-thomas@cozybit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201110201146.00505.chunkeey@googlemail.com> (sfid-20111020_114622_468564_1A28EF1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, October 20, 2011 03:03:24 AM Thomas Pedersen wrote:
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> Signed-off-by: Ashok Nagarajan <anagar6@uic.edu>
> ---
>  net/mac80211/agg-rx.c |    3 ++-
>  net/mac80211/agg-tx.c |    4 +++-
>  net/mac80211/ht.c     |    3 ++-
>  net/mac80211/rx.c     |    1 +
>  4 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 2ac0339..36c2836 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -378,6 +379,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>  	 * by drivers or the standard.
>  	 */
>  	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
> +	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
>  	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
>  	    sdata->vif.type != NL80211_IFTYPE_AP)
>  		return -EINVAL;

just a nitpick, but it looks like the comment in agg-tx.c
seems to be a little out of date. Hence, would you mind
removing it as well?

	/*
	 * The aggregation code is not prepared to handle
	 * anything but STA/AP due to the BSSID handling.
	 * IBSS could work in the code but isn't supported
	 * by drivers or the standard.
	 */
	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
	    sdata->vif.type != NL80211_IFTYPE_AP)
		return -EINVAL;

Regards,
	Chr
