Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45105 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421AbZKJVpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 16:45:13 -0500
Date: Tue, 10 Nov 2009 16:43:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Rui Paulo <rpaulo@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 11/20] mac80211: implement RANN processing and
	forwarding
Message-ID: <20091110214350.GF12682@tuxdriver.com>
References: <20091110134802.GA55552@asus-p5b.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20091110134802.GA55552@asus-p5b.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 10, 2009 at 01:48:02PM +0000, Rui Paulo wrote:
> Process the RANN (Root Annoucement) Frame and try to find the HWMP
> root station by sending a PREQ.
> 
> Signed-off-by: Rui Paulo <rpaulo@gmail.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
> Tested-by: Brian Cavagnolo <brian@cozybit.com>
> ---
>  include/linux/ieee80211.h  |   15 ++++++++
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/mesh_hwmp.c   |   79 +++++++++++++++++++++++++++++++++++++++----
>  net/mac80211/util.c        |    4 ++
>  4 files changed, 91 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 50c684d..e6cd039 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -554,6 +554,20 @@ struct ieee80211_tim_ie {
>  	u8 virtual_map[1];
>  } __attribute__ ((packed));
>  
> +/**
> + * struct ieee80211_rann_ie
> + *
> + * This structure refers to "Root Announcement information element"
> + */
> +struct ieee80211_rann_ie {
> +	u8 rann_flags;
> +	u8 rann_hopcount;
> +	u8 rann_ttl;
> +	u8 rann_addr[ETH_ALEN];
> +	u32 rann_seq;
> +	u32 rann_metric;
> +} __attribute__ ((packed));
> +
>  #define WLAN_SA_QUERY_TR_ID_LEN 2
>  
>  struct ieee80211_mgmt {

In file included from net/wireless/lib80211.c:19:
include/linux/ieee80211.h:566: error: ‘ETH_ALEN’ undeclared here (not in a function)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
