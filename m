Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H2GVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 02:21:10 -0400
Subject: Re: [PATCH 1/2] mac80211: add flag to indicate HW only Tx-agg
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1314265865-20208-1-git-send-email-arik@wizery.com> (sfid-20110825_115114_645102_D5D8A23E)
References: <1314265865-20208-1-git-send-email-arik@wizery.com>
	 (sfid-20110825_115114_645102_D5D8A23E)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 08:21:06 +0200
Message-ID: <1314598866.4562.2.camel@jlt3.sipsolutions.net> (sfid-20110829_082113_433441_A8627845)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-25 at 12:51 +0300, Arik Nemtsov wrote:
> When this flag is set, Tx aggregations will not be initiated even
> if the hardware supports A-MPDU aggregation in general. This flag
> is required for devices supporting (partial) software Rx-aggregation.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  include/net/mac80211.h |    4 ++++
>  net/mac80211/agg-tx.c  |    3 ++-
>  net/mac80211/debugfs.c |    2 ++
>  net/mac80211/tx.c      |    3 ++-
>  4 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2f01d84..b21a5bb 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1094,6 +1094,9 @@ enum sta_notify_cmd {
>   *	stations based on the PM bit of incoming frames.
>   *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
>   *	the PS mode of connected stations.
> + *
> + * @IEEE80211_HW_TX_AMPDU_IN_HW_ONLY: The device handles TX aggregation
> + *	strictly in HW. Packets should not be aggregated in software.

In addition to the discussion with Helmut -- this is also misleading
since mac80211 doesn't, right now, aggregate anything in software -- it
just handles session setup (which is what you don't want).

johannes

