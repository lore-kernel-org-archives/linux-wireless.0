Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43498 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791Ab3IYQZv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 12:25:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 25 Sep 2013 09:25:46 -0700
Subject: RE: [patch] mwifiex: potential integer underflow in
 mwifiex_ret_wmm_get_status()
Message-ID: <477F20668A386D41ADCC57781B1F70430F45077CDA@SC-VEXCH1.marvell.com> (sfid-20130925_221653_549823_0B3D17DE)
References: <20130925085729.GC6661@elgon.mountain>
In-Reply-To: <20130925085729.GC6661@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> If "resp_len" gets set to negative then it counts as a high positive value.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I spotted this reviewing the int => bool changes, but I don't have the
> hardware and can't test it.

Thanks for spotting this potential integer underflow problem.

I think we can change the 'resp_len' variable type to a signed integer to fix this issue.

Thanks,
Bing

> 
> diff --git a/drivers/net/wireless/mwifiex/wmm.c
> b/drivers/net/wireless/mwifiex/wmm.c
> index 2e8f9cd..3c6ee3a 100644
> --- a/drivers/net/wireless/mwifiex/wmm.c
> +++ b/drivers/net/wireless/mwifiex/wmm.c
> @@ -772,6 +772,8 @@ int mwifiex_ret_wmm_get_status(struct
> mwifiex_private *priv,
>  			break;
>  		}
> 
> +		if (resp_len < tlv_len + sizeof(tlv_hdr->header))
> +			break;
>  		curr += (tlv_len + sizeof(tlv_hdr->header));
>  		resp_len -= (tlv_len + sizeof(tlv_hdr->header));
>  	}
