Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab2EGHn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 03:43:28 -0400
Message-ID: <1336376603.4325.3.camel@jlt3.sipsolutions.net> (sfid-20120507_094332_044513_4BBA2136)
Subject: Re: [PATCH] fix the increment of unicast/multicast counters for
 forwarded PREQ
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Mon, 07 May 2012 09:43:23 +0200
In-Reply-To: <1336106215-7431-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120504_063859_676671_B65B65D0)
References: <1336106215-7431-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120504_063859_676671_B65B65D0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-04 at 12:36 +0800, Chun-Yeow Yeoh wrote:
> Forwarded PREQ is either unicast or multicast. The appropriate counters
> should be incremented accordingly.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  net/mac80211/mesh_hwmp.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 503016f..f0695e5 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -603,7 +603,10 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>  				hopcount, ttl, cpu_to_le32(lifetime),
>  				cpu_to_le32(metric), cpu_to_le32(preq_id),
>  				sdata);
> -		ifmsh->mshstats.fwded_mcast++;
> +		if (da != broadcast_addr)

In addition to what Javier said. Err. Think about this comparison again.

johannes

