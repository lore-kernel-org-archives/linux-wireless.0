Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E3FC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 13:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51FD0217F9
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 13:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfBRNZU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 08:25:20 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:3667 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729104AbfBRNZT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 08:25:19 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E8BC94789F47451AA5E5;
        Mon, 18 Feb 2019 21:25:12 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.408.0; Mon, 18 Feb 2019
 21:25:10 +0800
Subject: Re: [PATCH net-next] cfg80211: pmsr: use eth_broadcast_addr() to
 assign broadcast address
To:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kvalo@codeaurora.org>
References: <20190216094710.127182-1-maowenan@huawei.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <927ff17c-c506-734f-fc27-796d4c8fba98@huawei.com>
Date:   Mon, 18 Feb 2019 21:25:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190216094710.127182-1-maowenan@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add kalle Valo in mail list.

Hi Kalle Valo,
Do you have any comments about this patch?

On 2019/2/16 17:47, Mao Wenan wrote:
> This patch is to use eth_broadcast_addr() to assign broadcast address
> insetad of memset().
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  net/wireless/pmsr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
> index de9286703280..21139b82749f 100644
> --- a/net/wireless/pmsr.c
> +++ b/net/wireless/pmsr.c
> @@ -258,7 +258,7 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
>  	} else {
>  		memcpy(req->mac_addr, nla_data(info->attrs[NL80211_ATTR_MAC]),
>  		       ETH_ALEN);
> -		memset(req->mac_addr_mask, 0xff, ETH_ALEN);
> +		eth_broadcast_addr(req->mac_addr_mask);
>  	}
>  
>  	idx = 0;
> 

