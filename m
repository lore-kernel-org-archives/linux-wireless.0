Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC77C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 826CE20833
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 826CE20833
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbeI0Qbl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:31:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbeI0Qbl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:31:41 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 43C0DC04BD5B;
        Thu, 27 Sep 2018 10:14:09 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D77026108F;
        Thu, 27 Sep 2018 10:14:05 +0000 (UTC)
Date:   Thu, 27 Sep 2018 12:14:04 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/26] mt76x0: init: reset beacon offset during bootstrap
Message-ID: <20180927101404.GC19941@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <758cdeb9c4ab95c01a79dfc44e53f50b631948a2.1538036134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <758cdeb9c4ab95c01a79dfc44e53f50b631948a2.1538036134.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 27 Sep 2018 10:14:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 27, 2018 at 11:01:44AM +0200, Lorenzo Bianconi wrote:
> Add beacon offset reset in mt76x0e_init_hardware routine
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> index 03211fd0db33..6600ee046800 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> @@ -345,7 +345,7 @@ EXPORT_SYMBOL_GPL(mt76x0_mac_stop);
>  
>  int mt76x0_init_hardware(struct mt76x0_dev *dev)
>  {
> -	int ret;
> +	int ret, i, j, beacon_len;
>  
>  	if (!mt76x02_wait_for_wpdma(&dev->mt76, 1000))
>  		return -EIO;
> @@ -385,6 +385,12 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
>  					     MT_BEACON_TIME_CFG_TBTT_EN |
>  					     MT_BEACON_TIME_CFG_BEACON_TX));
>  
> +	beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
> +	for (i = 0; i < 8; i++) {
> +		for (j = 0; j < beacon_len; j += 4)
> +			mt76_wr(dev, mt76x02_beacon_offsets[i] + j, 0);
> +	}
> +

This seems to ba fix for 

"mt76: move mt76x02_beacon_offset in mt76x02_core.c"

please add "Fixes:" tag or merge this patch into previous one.

Thanks
Stanislaw
