Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab2IJLUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 07:20:08 -0400
Message-ID: <1347276044.4272.14.camel@jlt4.sipsolutions.net> (sfid-20120910_132012_599584_F2B01FDF)
Subject: Re: [PATCH v3 4/7] mac80211: add ability to enable TX on op-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 10 Sep 2012 13:20:44 +0200
In-Reply-To: <1344426823-1795-5-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-5-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-08 at 14:53 +0300, Victor Goldenshtein wrote:
> Prior starting tx on DFS channels, the DFS master
> device shall perform a Channel Availability Check
> to ensure that there is no radar interference on
> those channels. Once CAC done, the tx can be
> enabled with ieee80211_dfs_en_tx().
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
>  include/net/mac80211.h    |    4 ++++
>  net/mac80211/cfg.c        |   15 +++++++++++++++
>  net/mac80211/driver-ops.h |   14 ++++++++++++++
>  net/mac80211/trace.h      |    6 ++++++
>  4 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index d29c99a..ecdfb6a 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2266,6 +2266,8 @@ enum ieee80211_rate_control_changed {
>  * @start_radar_detection: Start radar detection on current operational
>   *	channel, once started it will continuously monitor for radars as long
>   *	as the channel active.
> + * @dfs_en_tx: Once channel pass the DFS initial channel availability check,
> + *	initiate the tx on the channel with this command.

Please also document (for both!) the fact that they can sleep.


> +DEFINE_EVENT(local_sdata_evt, drv_dfs_en_tx,
> +	TP_PROTO(struct ieee80211_local *local,
> +		 struct ieee80211_sub_if_data *sdata),
> +	TP_ARGS(local, sdata)
> +);

Again, parameters.

johannes

