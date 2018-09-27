Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86957C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F7F2152C
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:17:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35F7F2152C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbeI0Qe7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:34:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbeI0Qe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:34:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AEC19C057F8F;
        Thu, 27 Sep 2018 10:17:26 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48079194A5;
        Thu, 27 Sep 2018 10:17:23 +0000 (UTC)
Date:   Thu, 27 Sep 2018 12:17:22 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 17/26] mt76: add mt76x02_mac_start routine
Message-ID: <20180927101721.GD19941@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <282971bcd54817ae02fbe065bc357ded9e068e56.1538036134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282971bcd54817ae02fbe065bc357ded9e068e56.1538036134.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 27 Sep 2018 10:17:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 27, 2018 at 11:01:46AM +0200, Lorenzo Bianconi wrote:
> Introduce mt76x02_mac_start since the mac start code is shared between
> mt76x0e and mt76x2 drivers.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 15 +++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.h |  1 +
>  drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 12 +-----------
>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> index df4366a702c9..5f120c1fa79f 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> @@ -18,6 +18,8 @@
>  #include "mt76.h"
>  #include "mt76x02_regs.h"
>  #include "mt76x02_mac.h"
> +#include "mt76x02_dma.h"
> +#include "mt76x02_util.h"
>  
>  enum mt76x02_cipher_type
>  mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
> @@ -520,3 +522,16 @@ void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr)
>  		  FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_mac_setaddr);
> +
> +void mt76x02_mac_start(struct mt76_dev *dev)
> +{
> +	mt76x02_dma_enable(dev);
> +	__mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
> +	__mt76_wr(dev, MT_MAC_SYS_CTRL,
> +		  MT_MAC_SYS_CTRL_ENABLE_TX |
> +		  MT_MAC_SYS_CTRL_ENABLE_RX);
> +	mt76x02_irq_enable(dev,
> +			   MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
> +			   MT_INT_TX_STAT);
> +}

irq_enable is PCIe specific (also mt76x02_dma_enable() seems to
be PCIe specifc). I think this should be not mixed within generic code
and perhaps the function name prefix should be mt76x02e_ .

Thanks
Stanislaw

