Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADEAC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 05:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5313E2175B
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 05:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfA2F6B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 00:58:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:2690 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbfA2F6B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 00:58:01 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 034F8E7E5BE1A5D2E257;
        Tue, 29 Jan 2019 13:57:58 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.408.0; Tue, 29 Jan 2019
 13:57:56 +0800
Subject: Re: [PATCH] rtlwifi: remove set but not used variable 'cmd_seq'
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1536667978-10556-1-git-send-email-yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>,
        <"netdev@vger.kernel.org kernel-janitors"@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <581817ea-a414-e6ed-3615-5e44837a5221@huawei.com>
Date:   Tue, 29 Jan 2019 13:57:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <1536667978-10556-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ping...

On 2018/9/11 20:12, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/base.c: In function 'rtl_c2h_content_parsing':
> drivers/net/wireless/realtek/rtlwifi/base.c:2313:13: warning:
>  variable 'cmd_seq' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/base.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index f4122c8..92b6918 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -2310,11 +2310,10 @@ static void rtl_c2h_content_parsing(struct ieee80211_hw *hw,
>  	struct rtl_priv *rtlpriv = rtl_priv(hw);
>  	struct rtl_hal_ops *hal_ops = rtlpriv->cfg->ops;
>  	const struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
> -	u8 cmd_id, cmd_seq, cmd_len;
> +	u8 cmd_id, cmd_len;
>  	u8 *cmd_buf = NULL;
>  
>  	cmd_id = GET_C2H_CMD_ID(skb->data);
> -	cmd_seq = GET_C2H_SEQ(skb->data);
>  	cmd_len = skb->len - C2H_DATA_OFFSET;
>  	cmd_buf = GET_C2H_DATA_PTR(skb->data);
> 
> 
> .
> 

