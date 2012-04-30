Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43344 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab2D3TRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 15:17:49 -0400
Date: Mon, 30 Apr 2012 15:09:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org
Subject: Re: [PATCH 3/4] mac80211: Allow nonHT/HT peering in mesh
Message-ID: <20120430190935.GF2560@tuxdriver.com> (sfid-20120430_211753_827733_7EE619D7)
References: <1335498506-9600-1-git-send-email-ashok@cozybit.com>
 <1335498506-9600-3-git-send-email-ashok@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1335498506-9600-3-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 26, 2012 at 08:48:25PM -0700, Ashok Nagarajan wrote:
> Now that we have protection enabled, allow non-HT and HT20 stations to peer
> with HT40+/- stations. Peering is still disallowed for HT40+/- mismatch.
> 
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Reviewed-by: Thomas Pedersen <thomas@cozybit.com>

  CC      net/mac80211/mesh.o
net/mac80211/mesh.c: In function ‘mesh_matches_local’:
net/mac80211/mesh.c:79:28: warning: ‘sta_channel_type’ may be used uninitialized in this function

Please don't add warnings!

> ---
>  net/mac80211/mesh.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 8a952e0..d25cb78 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -76,6 +76,7 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
>  	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>  	struct ieee80211_local *local = sdata->local;
>  	u32 basic_rates = 0;
> +	enum nl80211_channel_type sta_channel_type;
>  
>  	/*
>  	 * As support for each feature is added, check for matching
> @@ -102,10 +103,15 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
>  	if (sdata->vif.bss_conf.basic_rates != basic_rates)
>  		goto mismatch;
>  
> -	/* disallow peering with mismatched channel types for now */
> +	if (ie->ht_operation)
> +		sta_channel_type =
> +			ieee80211_ht_oper_to_channel_type(ie->ht_operation);
> +
> +	/* Disallow HT40+/- mismatch */
>  	if (ie->ht_operation &&
> -	    (local->_oper_channel_type !=
> -	     ieee80211_ht_oper_to_channel_type(ie->ht_operation)))
> +	    local->_oper_channel_type > NL80211_CHAN_HT20 &&
> +	    sta_channel_type > NL80211_CHAN_HT20 &&
> +	    local->_oper_channel_type != sta_channel_type)
>  		goto mismatch;
>  
>  	return true;
> -- 
> 1.7.5.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
