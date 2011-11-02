Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44404 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1KBKTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 06:19:50 -0400
Subject: Re: [PATCH 3/4] mac80211: check if frame is really part of this BA
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
In-Reply-To: <1319864732-11286-3-git-send-email-thomas@cozybit.com> (sfid-20111029_070615_135144_45E428A3)
References: <1319864732-11286-1-git-send-email-thomas@cozybit.com>
	 <1319864732-11286-3-git-send-email-thomas@cozybit.com>
	 (sfid-20111029_070615_135144_45E428A3)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 11:19:46 +0100
Message-ID: <1320229186.3950.42.camel@jlt3.sipsolutions.net> (sfid-20111102_111953_435070_02F8ED4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 22:05 -0700, Thomas Pedersen wrote:
> There was an an implicit assumption that any QoS data frame received
> from a STA/TID with an active BA session was sent to this vif as part of
> a BA.  This is not true if IFF_PROMISC is enabled and the frame was
> destined for a different peer, for example. Don't treat these frames as
> part of a BA from the sending STA.
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/rx.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index ee9e71b..ad39216 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -776,6 +776,10 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>  	      (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)))
>  		goto dont_reorder;
>  
> +	/* not actually part of this BA session */
> +	if (compare_ether_addr(hdr->addr1, rx->sdata->vif.addr) != 0)
> +		goto dont_reorder;

Huh that seems strange. Shouldn't that rather check
IEEE80211_RX_RA_MATCH?

johannes

