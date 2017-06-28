Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48520 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbdF1SS2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 14:18:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: libertas: Fix lbs_prb_rsp_limit_set()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170623151738.qxncismrvd4yzzfr@mwanda>
References: <20170623151738.qxncismrvd4yzzfr@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jingoo Han <jg1.han@samsung.com>, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20170628181822.742BF60AD6@smtp.codeaurora.org> (sfid-20170628_201841_215195_344DCFFE)
Date: Wed, 28 Jun 2017 18:18:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The kstrtoul() test was reversed so this always returned -ENOTSUPP.
> 
> Fixes: 27d7f47756f4 ("net: wireless: replace strict_strtoul() with kstrtoul()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: James Cameron <quozl@laptop.org>
> 
> diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
> index eeeb892219aa..37ace5cb309d 100644
> --- a/drivers/net/wireless/marvell/libertas/mesh.c
> +++ b/drivers/net/wireless/marvell/libertas/mesh.c
> @@ -233,8 +233,9 @@ static ssize_t lbs_prb_rsp_limit_set(struct device *dev,
>  	memset(&mesh_access, 0, sizeof(mesh_access));
>  	mesh_access.data[0] = cpu_to_le32(CMD_ACT_SET);
>  
> -	if (!kstrtoul(buf, 10, &retry_limit))
> -		return -ENOTSUPP;
> +	ret = kstrtoul(buf, 10, &retry_limit);
> +	if (ret)
> +		return ret;
>  	if (retry_limit > 15)
>  		return -ENOTSUPP;

Patch applied to wireless-drivers-next.git, thanks.

69551f5f370c libertas: Fix lbs_prb_rsp_limit_set()

-- 
https://patchwork.kernel.org/patch/9806775/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
