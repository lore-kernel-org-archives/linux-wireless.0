Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3058 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaBODCb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 22:02:31 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Avinash Patil <patila@marvell.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Fri, 14 Feb 2014 19:02:22 -0800
Subject: RE: [patch] mwifiex: memory corruption in
 mwifiex_tdls_add_vht_capab()
Message-ID: <477F20668A386D41ADCC57781B1F70430F53A2917F@SC-VEXCH1.marvell.com> (sfid-20140215_040237_970800_4B3FC083)
References: <20140214090312.GB13684@elgon.mountain>
In-Reply-To: <20140214090312.GB13684@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for the patch.

> There is a typo here because the names are confusingly similar.  The
> intent was sizeof(struct ieee80211_vht_cap) (size 12) but sizeof(struct
> ieee80211_ht_cap) (size 32) was used.
> 
> Anway, it's cleaner to just specify the variable instead of the type.
> 
> Fixes: 5f6d5983394f ('mwifiex: add VHT support for TDLS')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> 
> diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
> index 5efd456af571..9d6849f60603 100644
> --- a/drivers/net/wireless/mwifiex/tdls.c
> +++ b/drivers/net/wireless/mwifiex/tdls.c
> @@ -180,7 +180,7 @@ static int mwifiex_tdls_add_vht_capab(struct mwifiex_private *priv,
>  	memset(&vht_cap, 0, sizeof(struct ieee80211_vht_cap));
> 
>  	mwifiex_fill_vht_cap_tlv(priv, &vht_cap, priv->curr_bss_params.band);
> -	memcpy(pos, &vht_cap, sizeof(struct ieee80211_ht_cap));
> +	memcpy(pos, &vht_cap, sizeof(vht_cap));
> 
>  	return 0;
>  }
