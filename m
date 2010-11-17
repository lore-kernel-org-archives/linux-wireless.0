Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47485 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab0KQTj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 14:39:58 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 11:39:45 -0800
Date: Wed, 17 Nov 2010 11:39:54 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Youquan Song <youquan.song@linux.intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"hui.xiao@intel.com" <hui.xiao@intel.com>,
	"chaohong.guo@intel.com" <chaohong.guo@intel.com>,
	"youquan.song@intel.com" <youquan.song@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat-wireless: Fix USHRT_MAX undefine before 2.6.35
Message-ID: <20101117193954.GD2268@tux>
References: <20101117201723.GA29982@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101117201723.GA29982@linux-youquan.bj.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 12:17:24PM -0800, Youquan Song wrote:
> Since 2.6.35, USHORT_MAX change to USHRT_MAX, which also need be updated in
> compat-wireless
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> Signed-off-by: Hui Xiao <hui.xiao@intel.com>
> ---
> 
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 6d8f897..d7ff02f 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -258,7 +258,11 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>  	skb_queue_head_init(&sta->tx_filtered);
>  
>  	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2.6.35))
>  		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
> +#else
> +		sta->last_seq_ctrl[i] = cpu_to_le16(USHORT_MAX);
> +#endif
>  
>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
>  	wiphy_debug(local->hw.wiphy, "Allocated STA %pM\n", sta->sta.addr);

Can you just #define USHRT_MAX USHORT_MAX for older kernels through compat.git ?

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git

  Luis
