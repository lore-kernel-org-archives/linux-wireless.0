Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98229C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60CD420657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392108AbfAPMY3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:24:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:54892 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732749AbfAPMY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 07:24:29 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F3E7BFB5A198C49DAC29;
        Wed, 16 Jan 2019 20:24:24 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Wed, 16 Jan 2019
 20:24:24 +0800
Subject: Re: [PATCH] mac80211-next: remove set but not used variable 'w_priv'
To:     Kalle Valo <kvalo@codeaurora.org>
References: <1545274318-144187-1-git-send-email-yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <65a8caf2-98c0-cf43-f63b-d89ed556111f@huawei.com>
Date:   Wed, 16 Jan 2019 20:24:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <1545274318-144187-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ping...

On 2018/12/20 10:51, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/virt_wifi.c: In function 'virt_wifi_net_device_stop':
> drivers/net/wireless/virt_wifi.c:432:31: warning:
>  variable 'w_priv' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/virt_wifi.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
> index 64b2186..ea10f58 100644
> --- a/drivers/net/wireless/virt_wifi.c
> +++ b/drivers/net/wireless/virt_wifi.c
> @@ -429,13 +429,11 @@ static int virt_wifi_net_device_open(struct net_device *dev)
>  static int virt_wifi_net_device_stop(struct net_device *dev)
>  {
>  	struct virt_wifi_netdev_priv *n_priv = netdev_priv(dev);
> -	struct virt_wifi_wiphy_priv *w_priv;
>  
>  	n_priv->is_up = false;
>  
>  	if (!dev->ieee80211_ptr)
>  		return 0;
> -	w_priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
>  
>  	virt_wifi_cancel_scan(dev->ieee80211_ptr->wiphy);
>  	virt_wifi_cancel_connect(dev);
> 
> 
> 
> 
> .
> 

