Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B27C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 275CB20651
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:23:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 275CB20651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=v3.sk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbeJWWq5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 18:46:57 -0400
Received: from shell.v3.sk ([90.176.6.54]:60885 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbeJWWq5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 18:46:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 5D1EABE744;
        Tue, 23 Oct 2018 16:23:14 +0200 (CEST)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id yRZNknH4uy6x; Tue, 23 Oct 2018 16:23:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 1FA24BE746;
        Tue, 23 Oct 2018 16:23:11 +0200 (CEST)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oh4-vni3Nqp4; Tue, 23 Oct 2018 16:23:10 +0200 (CEST)
Received: from belphegor (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 58918BE744;
        Tue, 23 Oct 2018 16:23:10 +0200 (CEST)
Message-ID: <25ed3d0b71eb34e121f2d7a8d936665d7720270f.camel@v3.sk>
Subject: Re: [PATCH] libertas: remove set but not used variable 'int_type'
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     zhong jiang <zhongjiang@huawei.com>, kvalo@codeaurora.org
Cc:     davem@davemloft.net, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 23 Oct 2018 16:23:09 +0200
In-Reply-To: <1540265568-58721-1-git-send-email-zhongjiang@huawei.com>
References: <1540265568-58721-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1 (3.30.1-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-23 at 11:32 +0800, zhong jiang wrote:
> int_type is not used after setting its value. It is safe to remove
> the unused variable.

Hi. I believe your colleague has sent an equivalent patch a few days
ago in <1539569795-176889-1-git-send-email-yuehaibing@huawei.com>:

https://lore.kernel.org/linux-wireless/1539569795-176889-1-git-send-email-yuehaibing@huawei.com/

Cheers,
Lubo

> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/net/wireless/marvell/libertas/if_spi.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c
> b/drivers/net/wireless/marvell/libertas/if_spi.c
> index 504d6e0..7c3224b 100644
> --- a/drivers/net/wireless/marvell/libertas/if_spi.c
> +++ b/drivers/net/wireless/marvell/libertas/if_spi.c
> @@ -796,15 +796,13 @@ static void if_spi_h2c(struct if_spi_card
> *card,
>  {
>  	struct lbs_private *priv = card->priv;
>  	int err = 0;
> -	u16 int_type, port_reg;
> +	u16 port_reg;
>  
>  	switch (type) {
>  	case MVMS_DAT:
> -		int_type = IF_SPI_CIC_TX_DOWNLOAD_OVER;
>  		port_reg = IF_SPI_DATA_RDWRPORT_REG;
>  		break;
>  	case MVMS_CMD:
> -		int_type = IF_SPI_CIC_CMD_DOWNLOAD_OVER;
>  		port_reg = IF_SPI_CMD_RDWRPORT_REG;
>  		break;
>  	default:

