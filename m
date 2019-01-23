Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC2CC282C0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 10:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B6421019
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 10:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfAWKU1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:20:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfAWKU1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 05:20:27 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 060BBC05A1D8;
        Wed, 23 Jan 2019 10:20:27 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D5201726D;
        Wed, 23 Jan 2019 10:20:26 +0000 (UTC)
Date:   Wed, 23 Jan 2019 11:20:24 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mt76: fix per-chain signal strength reporting
Message-ID: <20190123102022.GA32492@redhat.com>
References: <20190122153823.46270-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190122153823.46270-1-nbd@nbd.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 23 Jan 2019 10:20:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 22, 2019 at 04:38:22PM +0100, Felix Fietkau wrote:
> Fix an off-by-one error that resulted in not reporting the signal strength
> for the first chain
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Not sure how serious this bug is, but I think patch should be marked:

Fixes: d9f8934ed147 ("mt76: move mt76x02_mac_process_rx in mt76x02-lib module")
Cc: stable@vger.kernel.org # 4.20+

Thanks
Stanislaw

> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> index ce9bb702045f..63fa27d2c404 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> @@ -648,7 +648,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
>  
>  	status->chains = BIT(0);
>  	signal = mt76x02_mac_get_rssi(dev, rxwi->rssi[0], 0);
> -	for (i = 1; i < nstreams; i++) {
> +	for (i = 0; i < nstreams; i++) {
>  		status->chains |= BIT(i);
>  		status->chain_signal[i] = mt76x02_mac_get_rssi(dev,
>  							       rxwi->rssi[i],
> -- 
> 2.17.0
> 
